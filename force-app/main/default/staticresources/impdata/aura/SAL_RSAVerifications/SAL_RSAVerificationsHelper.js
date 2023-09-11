({
    getDataOnLoad : function(component,event) {
        this.showhidespinner(component,event,true);
        var verSelectList = ["Status__c","Upload_Status__c","VerificationCategory__c","Month__c"];
        var appSelectList = ["Check_RSA__c"];
        var selectListNameMap = {};
        selectListNameMap["Verification__c"] = verSelectList;
        selectListNameMap["Applicant__c"] = appSelectList;
        this.executeApex(component, "getVerificationData", {
            'oppId': component.get("v.oppId"),'objectFieldJSON':JSON.stringify(selectListNameMap)
        }, function (error, result) {
            console.log('error'+error+result);
            if (!error && result) {
                console.log('result is'+result);
                var resultStr = JSON.parse(result);
                component.set("v.allVeriList",resultStr.veriList);
                var picklistFields = resultStr.picklistData;
                var verPickFlds = picklistFields["Verification__c"];
                var statusList = verPickFlds["Status__c"];
                statusList.push('Fraud');
                component.set("v.statusList", statusList);
                component.set("v.upStatusList", verPickFlds["Upload_Status__c"]);
                component.set("v.verCategoryList", verPickFlds["VerificationCategory__c"]);
                component.set("v.monList", verPickFlds["Month__c"]);
                var appPickFlds = picklistFields["Applicant__c"];
                component.set("v.RSAList", appPickFlds["Check_RSA__c"]);
                var allVeriList = component.get("v.allVeriList");
                var verAgencyMaster = resultStr.veriAgency;
                console.log('master length'+verAgencyMaster.length);
                for(var i = 0;i < verAgencyMaster.length;i++){
                    console.log('Name is'+verAgencyMaster[i].Name);
                }
                component.set("v.allVeriAgency",verAgencyMaster);
                var verAtt = [];
                var verAdded = [];
                for(var j in allVeriList){
                    for(var i in resultStr.veriAtt){
                        
                        if(resultStr.veriAtt[i].LinkedEntityId == allVeriList[j].Id){
                            if(!verAdded.includes(allVeriList[j].Id))
                                verAtt.push({'verId':allVeriList[j].Id,'att':true});
                            verAdded.push(allVeriList[j].Id);
                        }
                    }
                    if(!verAdded.includes(allVeriList[j].Id)){
                        verAtt.push({'verId':allVeriList[j].Id,'att':false});   
                    }
                    
                    
                }
                //console.log('veratt'+verAtt.length);
                component.set("v.verAtt",verAtt);
                console.log('verAgencyMaster'+resultStr.veriAtt.length);
                var veriAgencyList = [];
                var Loan = component.get("v.Oppobj");
                for(var i in allVeriList){
                    var agencyList = [];
                    for(var j in verAgencyMaster){
                        console.log(verAgencyMaster[j].Verification_Types__c+'--'+allVeriList[i].Verification_Type__c+'--'+verAgencyMaster[j].Location__c+'--'+Loan.Branch_Name__r.Name);
                        if(verAgencyMaster[j].Verification_Types__c.includes(allVeriList[i].Verification_Type__c) && (verAgencyMaster[j].Location__c.toUpperCase() == Loan.Branch_Name__r.Name.toUpperCase())){
                            agencyList.push(verAgencyMaster[j]);    
                        }
                    }
                    console.log('agencyList'+agencyList.length);
                    var valpresent = false;
                    for(var j in veriAgencyList){
                        console.log('veriAgencyList'+veriAgencyList[j].verType);
                        if(veriAgencyList[j].verType == allVeriList[i].Verification_Type__c)    
                            valpresent = true;
                    }
                    if(!valpresent)
                        veriAgencyList.push({'verType':allVeriList[i].Verification_Type__c,'verAgencies':agencyList})
                        }
                component.set("v.veriAgencyList",veriAgencyList);
                /*var veriTypes = [];
                var primApp = component.get("v.primaryApp");
                veriTypes.push({'type':'Salary Slip','val':primApp.Pay_Slips_Status__c});
                veriTypes.push({'type':'Form-16','val':primApp.FORM_16__c});
				veriTypes.push({'type':'Dual PAN check','val':primApp.PAN_Check__c});
                veriTypes.push({'type':'Office Set-up','val':primApp.Office_Status__c});
                veriTypes.push({'type':'Residence Profile','val':primApp.Residence_Status__c});
				veriTypes.push({'type':'KYC verification','val':primApp.KYC_Verifications__c});
                veriTypes.push({'type':'Banking verification','val':primApp.Bank_Status__c});
				veriTypes.push({'type':'Profile Check – Demographic change','val':primApp.Pay_Slips_Status__c});
            	component.set("v.veriTypesList",veriTypes);*/
            }
            this.showhidespinner(component,event,false);
        });
    },
    sendEmailHelper : function(component,event) {
        this.showhidespinner(component,event,true);
        var allVeriList = component.get("v.allVeriList");
        
        var veriMail = [];
        var mailCheckbox = component.find("mailCheckbox");
        for(var i in allVeriList){
            console.log('id is:'+allVeriList[i].Id);
            if(!$A.util.isEmpty(allVeriList[i].Id)){
                var mailName = 'sendMail'+allVeriList[i].Id;
                if ($A.util.isArray(mailCheckbox)) {
                    console.log('isArray');
                    mailCheckbox.forEach(cmp => {
                        if(cmp.get("v.name") == mailName && cmp.get("v.checked") == true){
                        veriMail.push(allVeriList[i]);   
                    }
                                         })
                } else {
                    // do stuff on the instance
                    if(mailCheckbox.get("v.name") == mailName && mailCheckbox.get("v.checked") == true){
                        veriMail.push(allVeriList[i]);   
                    }
                }
                
                
            }
        }
        console.log('veriMail'+veriMail.length);
        if(!$A.util.isEmpty(veriMail)){
            this.executeApex(component, "sendVerificationMail", {
                'veriList':JSON.stringify(veriMail),'vamList':JSON.stringify(component.get("v.allVeriAgency"))
            }, function (error, result) {
                console.log('error'+error+result);
                if (!error && result) {
                    if(result == 'No records')
                        this.displayToastMessage(component,event,'Error','Email has already been triggered for existing records.','error');
                    else{
                        if ($A.util.isArray(mailCheckbox)) {
                            console.log('isArray');
                            mailCheckbox.forEach(cmp => {
                                cmp.set("v.checked",false);   
                            }
                                )
                            } else {
                                // do stuff on the instance
                                mailCheckbox.set("v.checked",false);   
                            }
                                this.displayToastMessage(component,event,'Success','Email sent successfully.','success');	
                            }
                                
                            }
                                this.showhidespinner(component,event,false);
                            });	   
                            }
                                else{
                                this.showhidespinner(component,event,false);
                                this.displayToastMessage(component,event,'Error','No records selected to send mail.','error');
                            }
                                
                            },
                                updateVeriRecords : function(component,event) {
                                    this.showhidespinner(component,event,true);
                                    var allVeriList = component.get("v.allVeriList");
                                    var app = component.get("v.primaryApp");
                                    if(app.Check_RSA__c == 'Yes')
                                        app.RSA_flag__c = true;
                                    else
                                        app.RSA_flag__c = false;
                                    if(!$A.util.isEmpty(component.find("Pay_Slips_Status__c")) && component.find("Pay_Slips_Status__c").get("v.checked")){
                                        app.Pay_Slips_Status__c = true;
                                    }
                                    if(!$A.util.isEmpty(component.find("FORM_16__c")) && component.find("FORM_16__c").get("v.checked")){
                                        app.FORM_16__c = true;
                                    }
                                    if(!$A.util.isEmpty(component.find("PAN_Check__c")) && component.find("PAN_Check__c").get("v.checked")){
                                        app.PAN_Check__c = true;
                                    }
                                    if(!$A.util.isEmpty(component.find("Office_Status__c")) && component.find("Office_Status__c").get("v.checked")){
                                        app.Office_Status__c = true;
                                    }
                                    if(!$A.util.isEmpty(component.find("Residence_Status__c")) && component.find("Residence_Status__c").get("v.checked")){
                                        app.Residence_Status__c = true;
                                    }
                                    if(!$A.util.isEmpty(component.find("KYC_Verifications__c")) && component.find("KYC_Verifications__c").get("v.checked")){
                                        app.KYC_Verifications__c = true;
                                    }
                                    if(!$A.util.isEmpty(component.find("Bank_Status__c")) && component.find("Bank_Status__c").get("v.checked")){
                                        app.Bank_Status__c = true;
                                    }
                                    if(!$A.util.isEmpty(component.find("PROFILE_VERIFICATION__c")) && component.find("PROFILE_VERIFICATION__c").get("v.checked")){
                                        app.PROFILE_VERIFICATION__c = true;
                                    }
                                    this.executeApex(component, "updateVerificationData", {
                                        'appObj': JSON.stringify(app),'veriList':JSON.stringify(allVeriList),'vamList':JSON.stringify(component.get("v.allVeriAgency"))
                                    }, function (error, result) {
                                        console.log('error'+error+result);
                                        if (!error && result) {
                                            try{
                                                if(result != 'Fail' && result !='Remark Error'){
                                                    var resultStr = JSON.parse(result);
                                                    component.set("v.allVeriList",resultStr.veriList);
                                                    component.set("v.primaryApp",resultStr.applicantPrimary);
                                                    component.set("v.class",'hideCls');
                                                    this.displayToastMessage(component,event,'Success','Records saved successfully','success');
                                                }
                                                else if(result =='Remark Error'){//US_5574
                                                    this.displayToastMessage(component,event,'Error','Remarks is too long','error');
                                                }else{//US_5574
                                                    this.displayToastMessage(component,event,'Error','Internal Server Error ','error');
                                                }
                                            }
                                            catch(ex){//US_5574
                                                this.displayToastMessage(component,event,'Error','Internal Server Error ','error');
                                            }
                                        }
                                        this.showhidespinner(component,event,false);
                                    });
                                },
                                addveriRecords : function(component,event) {
                                    //console.log('value is'+component.find("Pay_Slips_Status__c").get("v.checked"));    
                                    var allVeriList = component.get("v.allVeriList");
                                    console.log('allVeriList'+allVeriList.length);
                                    console.log('allverilist data'+allVeriList)
                                    var app = component.get("v.primaryApp");
                                    var primarybankacc = component.get("v.bankObj");
                                    var camObj = component.get("v.camObj");
                                    var dedList = component.get("v.dedupeList");
                                    var Loan = component.get("v.Oppobj");
                                    var verificationType = component.find("veritype").get("v.value");//US_5574
                                    //alert('test0');
                                    if(!$A.util.isEmpty(component.find("Pay_Slips_Status__c")) && component.find("Pay_Slips_Status__c").get("v.checked")){
                                        var recordPresent = false;
                                        for(var i in allVeriList){
                                            if ((app.Id == allVeriList[i].Applicant__c) && (allVeriList[i].Verification_Type__c == 'Salary Slip Format')) 
                                            {
                                                recordPresent = true;
                                                break;
                                            }
                                        }
                                        if(!recordPresent){
                                            for(var i =0; i<3; i++){
                                                var objVfy = new Object();
                                                /*US_5574 S*/
                                                if(verificationType =='RSA verifications'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RSA';
                                                }else if(verificationType =='RCU verifications'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RCU';
                                                }
                                                /*US_5574 E*/
                                                /*5331 s*/
                                                    else if(verificationType =='Centralised sampling'){
                                                        objVfy.RSA_Reason__c = 'Initiated through RSA sampling';
                                                    }
                                                /*5331 e*/
                                                objVfy.sobjectType = 'Verification__c';
                                                objVfy.Verification_Type__c = 'Salary Slip Format';
                                                objVfy.Loan_Application__c = Loan.Id;
                                                objVfy.Applicant__c = app.Id;
                                                if(!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){
                                                    objVfy.Contact__c = app.Contact_Name__c;
                                                }
                                                if(!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c) && !$A.util.isEmpty(app.Contact_Name__r.Employer_Name__c)){
                                                    objVfy.Employer_Name__c = app.Contact_Name__r.Employer_Name__c;
                                                }
                                                if(!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c) && !$A.util.isEmpty(app.Contact_Name__r.Employer__c) && !$A.util.isEmpty(app.Contact_Name__r.Employer__r.Name)){
                                                    objVfy.Employer_Name__c = app.Contact_Name__r.Employer__r.Name;
                                                }     
                                                if(!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c) && !$A.util.isEmpty(app.Contact_Name__r.Name_of_Employer__c)){
                                                    objVfy.Employer_Name__c = app.Contact_Name__r.Name_of_Employer__c;
                                                }
                                                if(!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c) && !$A.util.isEmpty(app.Contact_Name__r.Designation__c)){
                                                    objVfy.Designation__c = Loan.Account.DesignationOTP__c;
                                                }
                                                if(!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c) && !$A.util.isEmpty(app.Contact_Name__r.Office_Phone_Number__c)){
                                                    objVfy.Phone_number__c = app.Contact_Name__r.Office_Phone_Number__c;
                                                }
                                                if(!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c) && !$A.util.isEmpty(app.Contact_Name__r.Mobile__c)){
                                                    objVfy.Mobile_Number__c = app.Contact_Name__r.Mobile__c;
                                                }
                                                if(!$A.util.isEmpty(primarybankacc) && !$A.util.isEmpty(primarybankacc.Bank_Name__c)){
                                                    objVfy.Name_of_the_Bank__c = primarybankacc.Bank_Name__c;
                                                }
                                                if(!$A.util.isEmpty(primarybankacc) && !$A.util.isEmpty(primarybankacc.Bank_Acct_Number__c)){
                                                    objVfy.Account_No__c = primarybankacc.Bank_Acct_Number__c;
                                                }
                                                if(!$A.util.isEmpty(primarybankacc) && !$A.util.isEmpty(primarybankacc.Bank_Branch__c)){
                                                    objVfy.Name_of_the_Branch__c = primarybankacc.Bank_Branch__c;
                                                } 
                                                // console.log('months are'+camObj.Month1__c+camObj.Month2__c+camObj.Month3__c);
                                                for(var j=0;j<3;j++){
                                                    if(!$A.util.isEmpty(camObj))
                                                    {
                                                        if(i == 0 && !$A.util.isEmpty(camObj.Month1__c)){
                                                            objVfy.Month__c = camObj.Month1__c.toUpperCase();
                                                        }
                                                        else if(i == 1 && !$A.util.isEmpty(camObj.Month2__c)){
                                                            objVfy.Month__c = camObj.Month2__c.toUpperCase();
                                                        }
                                                            else if(i == 2 && !$A.util.isEmpty(camObj.Month3__c)){
                                                                objVfy.Month__c = camObj.Month3__c.toUpperCase();
                                                            }
                                                        if(i == 0 && !$A.util.isEmpty(camObj.Average_incentive_for_Q1__c)){
                                                            objVfy.Net_Salary__c = camObj.Average_incentive_for_Q1__c;
                                                        }
                                                        else if(i == 1 && !$A.util.isEmpty(camObj.Average_incentive_for_Q2__c))
                                                        {
                                                            objVfy.Net_Salary__c = camObj.Average_incentive_for_Q2__c;
                                                        }
                                                            else if(i == 2 && !$A.util.isEmpty(camObj.Average_incentive_for_Q3__c)){
                                                                objVfy.Net_Salary__c = camObj.Average_incentive_for_Q3__c;
                                                            }
                                                        
                                                    }
                                                    if(!$A.util.isEmpty(primarybankacc))
                                                    {
                                                        if(i == 0 && !$A.util.isEmpty(primarybankacc.Salary_Credit_Date1__c))
                                                        {
                                                            objVfy.Salary_Credit_Date__c = primarybankacc.Salary_Credit_Date1__c;
                                                        }
                                                        else if(i == 1 && !$A.util.isEmpty(primarybankacc.Salary_Credit_Date2__c))
                                                        {
                                                            objVfy.Salary_Credit_Date__c = primarybankacc.Salary_Credit_Date2__c;
                                                        }
                                                            else if(i == 2 && !$A.util.isEmpty(primarybankacc.Salary_Credit_Date3__c))
                                                            {
                                                                objVfy.Salary_Credit_Date__c = primarybankacc.Salary_Credit_Date3__c;
                                                            }
                                                    }
                                                }
                                                allVeriList.push(objVfy);
                                            }
                                            
                                        }
                                        
                                    }
                                    //alert('test1');
                                    if(!$A.util.isEmpty(component.find("FORM_16__c")) && component.find("FORM_16__c").get("v.checked")){
                                        var recordPresent = false;
                                        for(var i in allVeriList){
                                            if ((app.Id == allVeriList[i].Applicant__c) && (allVeriList[i].Verification_Type__c == 'FORM 16')) 
                                            {
                                                recordPresent = true;
                                                break;
                                            }
                                        }
                                        if(!recordPresent){
                                            var objVfy = new Object();
                                            /*US_5574 S*/
                                            if(verificationType =='RSA verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RSA';
                                            }else if(verificationType =='RCU verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RCU';
                                            }
                                            /*US_5574 E*/
                                            /*5331 s*/
                                                else if(verificationType =='Centralised sampling'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RSA sampling';
                                                }
                                            /*5331 e*/
                                            objVfy.sobjectType = 'Verification__c';
                                            objVfy.Verification_Type__c = 'FORM 16';
                                            objVfy.Contact__c = app.Contact_Name__c;
                                            objVfy.Applicant__c = app.Id;
                                            objVfy.Loan_Application__c = Loan.Id;
                                            allVeriList.push(objVfy);
                                        }
                                    }
                                    //alert('test2');
                                    if(!$A.util.isEmpty(component.find("PAN_Check__c")) && component.find("PAN_Check__c").get("v.checked")){
                                        var recordPresent = false;
                                        for(var i in allVeriList){
                                            console.log('Applicant '+app.Id+allVeriList[i].Applicant__c+allVeriList[i].Verification_Type__c);
                                            if ((app.Id == allVeriList[i].Applicant__c) && (allVeriList[i].Verification_Type__c == 'PAN')) 
                                            {
                                                recordPresent = true;
                                                break;
                                            }
                                        }
                                        if(!recordPresent){
                                            var objVfy = new Object();
                                            if(verificationType =='RSA verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RSA';
                                            }else if(verificationType =='RCU verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RCU';
                                            }
                                            /*5331 s*/
                                                else if(verificationType =='Centralised sampling'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RSA sampling';
                                                }
                                            /*5331 e*/
                                            objVfy.sobjectType = 'Verification__c';
                                            objVfy.Verification_Type__c = 'PAN';
                                            objVfy.Contact__c = app.Contact_Name__c;
                                            objVfy.Applicant__c = app.Id;
                                            objVfy.Loan_Application__c = Loan.Id;
                                            objVfy.PAN_Number__c = app.PAN_Number__c;
                                            objVfy.Document_particulars__c = app.PAN_Number__c;
                                            allVeriList.push(objVfy);
                                        }
                                    }
                                    if(!$A.util.isEmpty(component.find("Office_Status__c")) && component.find("Office_Status__c").get("v.checked")){
                                        var recordPresent = false;
                                        for(var i in allVeriList){
                                            
                                            if ((app.Id == allVeriList[i].Applicant__c) && (allVeriList[i].Verification_Type__c == 'Office verification')) 
                                            {
                                                recordPresent = true;
                                                break;
                                            }
                                        }
                                        if(!recordPresent){
                                            var StrOffAdd = '',StrPayOff ='';
                                            var objVfy = new Object();
                                            if(verificationType =='RSA verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RSA';
                                            }else if(verificationType =='RCU verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RCU';
                                            }
                                            /*5331 s*/
                                                else if(verificationType =='Centralised sampling'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RSA sampling';
                                                }
                                            /*5331 e*/
                                            objVfy.sobjectType = 'Verification__c';
                                            objVfy.Verification_Type__c = 'Office verification';
                                            objVfy.Contact__c = app.Contact_Name__c;
                                            objVfy.Applicant__c = app.Id;
                                            objVfy.Loan_Application__c = Loan.Id;
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                objVfy.Designation__c = Loan.Account.DesignationOTP__c;;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                objVfy.Phone_number__c = app.Contact_Name__r.Office_Phone_Number__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                objVfy.Mobile_Number__c = app.Contact_Name__r.Mobile__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c) && !$A.util.isEmpty(app.Contact_Name__r.Employer__c)) 
                                            {
                                                console.log('app.Contact_Name__r.Employer__r.Name'+app.Contact_Name__r.Employer__r.Name);
                                                objVfy.Employer_Name__c = app.Contact_Name__r.Employer__r.Name;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrOffAdd = app.Contact_Name__r.Address_Line_One__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrOffAdd = StrOffAdd + ',' + app.Contact_Name__r.Address_2nd_Line__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrOffAdd = StrOffAdd + ',' + app.Contact_Name__r.Address_3rd_Line__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrOffAdd = StrOffAdd + ',' + app.Contact_Name__r.Office_City__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrOffAdd = StrOffAdd + ',' + app.Contact_Name__r.Office_Pin_Code__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                objVfy.Others_Employer__c = app.Contact_Name__r.Name_of_Employer__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrPayOff = app.Contact_Name__r.Address_Line_One__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Address_2nd_Line__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Address_3rd_Line__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Office_City__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Office_Pin_Code__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)) 
                                            {
                                                StrPayOff = StrPayOff + ',' + app.Contact_Name__r.Office_State__c;
                                            }
                                            objVfy.Document_particulars__c = StrPayOff;
                                            objVfy.Employer_Address__c = StrPayOff;
                                            objVfy.Address__c = StrOffAdd;
                                            allVeriList.push(objVfy);
                                        }
                                    }
                                    if(!$A.util.isEmpty(component.find("Residence_Status__c")) && component.find("Residence_Status__c").get("v.checked")){
                                        var recordPresent = false;
                                        for(var i in allVeriList){
                                            if ((app.Id == allVeriList[i].Applicant__c) && (allVeriList[i].Verification_Type__c == 'Residence verification')) 
                                            {
                                                recordPresent = true;
                                                break;
                                            }
                                        }
                                        if(!recordPresent){
                                            var objVfy = new Object();
                                            if(verificationType =='RSA verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RSA';
                                            }else if(verificationType =='RCU verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RCU';
                                            }
                                            /*5331 s*/
                                                else if(verificationType =='Centralised sampling'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RSA sampling';
                                                }
                                            /*5331 e*/
                                            objVfy.sobjectType = 'Verification__c';
                                            objVfy.Verification_Type__c = 'Residence verification';
                                            objVfy.Contact__c = app.Contact_Name__c;
                                            objVfy.Applicant__c = app.Id;
                                            objVfy.Loan_Application__c = Loan.Id;
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){
                                                objVfy.Contact__c = app.Contact_Name__c;
                                            }
                                            var StrResAdd = '';
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){ 
                                                StrResAdd = app.Contact_Name__r.Address_1__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){
                                                StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Address_2__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){ 
                                                StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Address_3__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){ 
                                                StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Pin_Code__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){ 
                                                StrResAdd = StrResAdd + ',' + app.Contact_Name__r.Residence_City__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){ 
                                                StrResAdd = StrResAdd + ',' + app.Contact_Name__r.State__c;
                                            }
                                            objVfy.Address__c = StrResAdd;
                                            objVfy.Document_particulars__c = StrResAdd;
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){ 
                                                objVfy.Office_City__c = app.Contact_Name__r.Office_City__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){
                                                objVfy.Phone_number__c = app.Contact_Name__r.Phone_Number__c;
                                            }
                                            if (!$A.util.isEmpty(app) && !$A.util.isEmpty(app.Contact_Name__c)){
                                                objVfy.Mobile_Number__c = app.Contact_Name__r.Mobile__c;
                                            }
                                            allVeriList.push(objVfy);
                                        }
                                    }
                                    console.log('test1'+$A.util.isArray(component.find("KYC_Verifications__c")));
                                    if(!$A.util.isEmpty(component.find("KYC_Verifications__c")) && component.find("KYC_Verifications__c").get("v.checked")){
                                        var recordPresent = false;
                                        for(var i in allVeriList){
                                            if ((app.Id == allVeriList[i].Applicant__c) && (allVeriList[i].Verification_Type__c == 'KYC')) 
                                            {
                                                recordPresent = true;
                                                break;
                                            }
                                        }
                                        if(!recordPresent){
                                            var objVfy = new Object();
                                            if(verificationType =='RSA verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RSA';
                                                
                                            }else if(verificationType =='RCU verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RCU';
                                            }
                                            /*5331 s*/
                                                else if(verificationType =='Centralised sampling'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RSA sampling';
                                                }
                                            /*5331 e*/
                                            objVfy.sobjectType = 'Verification__c';
                                            objVfy.Verification_Type__c = 'KYC';
                                            objVfy.Contact__c = app.Contact_Name__c;
                                            objVfy.Applicant__c = app.Id;
                                            objVfy.Loan_Application__c = Loan.Id;
                                            allVeriList.push(objVfy);
                                        }
                                    }
                                    console.log('primarybankacc'+primarybankacc);
                                    if(!$A.util.isEmpty(component.find("Bank_Status__c")) && component.find("Bank_Status__c").get("v.checked")){
                                        var recordPresent = false;
                                        for(var i in allVeriList){
                                            if ((app.Id == allVeriList[i].Applicant__c) && (allVeriList[i].Verification_Type__c == 'Bank Statements')) 
                                            {
                                                recordPresent = true;
                                                break;
                                            }
                                        }
                                        if(!recordPresent){
                                            var objVfy = new Object();
                                            if(verificationType =='RSA verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RSA';
                                            }else if(verificationType =='RCU verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RCU';
                                            }
                                            /*5331 s*/
                                                else if(verificationType =='Centralised sampling'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RSA sampling';
                                                }
                                            /*5331 e*/
                                            objVfy.sobjectType = 'Verification__c';
                                            objVfy.Verification_Type__c = 'Bank Statements';
                                            objVfy.Contact__c = app.Contact_Name__c;
                                            objVfy.Applicant__c = app.Id;
                                            objVfy.Loan_Application__c = Loan.Id;
                                            objVfy.Name_of_the_Bank__c = primarybankacc.Bank_Name__c;
                                            objVfy.Account_No__c = primarybankacc.Bank_Acct_Number__c; 
                                            objVfy.Name_of_the_Branch__c = primarybankacc.Bank_Branch__c;
                                            objVfy.PAN_Number__c = app.PAN_Number__c;
                                            allVeriList.push(objVfy);
                                        }
                                    }
                                    //alert('test');
                                    if(!$A.util.isEmpty(component.find("PROFILE_VERIFICATION__c")) && component.find("PROFILE_VERIFICATION__c").get("v.checked")){
                                        var recordPresent = false;
                                        for(var i in allVeriList){
                                            if ((app.Id == allVeriList[i].Applicant__c) && (allVeriList[i].Verification_Type__c == 'Profile Verification')) 
                                            {
                                                recordPresent = true;
                                                break;
                                            }
                                        }
                                        console.log('recordPresent'+recordPresent);
                                        if(!recordPresent){
                                            var objVfy = new Object();
                                            if(verificationType =='RSA verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RSA';
                                            }else if(verificationType =='RCU verifications'){
                                                objVfy.RSA_Reason__c = 'Initiated through RCU';
                                            }
                                            /*5331 s*/
                                                else if(verificationType =='Centralised sampling'){
                                                    objVfy.RSA_Reason__c = 'Initiated through RSA sampling';
                                                }
                                            /*5331 e*/
                                            objVfy.sobjectType = 'Verification__c';
                                            objVfy.Verification_Type__c = 'Profile Verification';
                                            objVfy.Contact__c = app.Contact_Name__c;
                                            objVfy.Applicant__c = app.Id;
                                            objVfy.Loan_Application__c = Loan.Id;
                                            var demogsChange = '';
                                            if(!$A.util.isEmpty(Loan) && !$A.util.isEmpty(Loan.CUSTOMER__c)){
                                                demogsChange = Loan.CUSTOMER__r.Name;
                                            }
                                            
                                           /* if(!$A.util.isEmpty(dedList)){
                                                console.log('Existing_cust_demog_change__c'+dedList[0].Existing_cust_demog_change__c);
                                                for(var i in dedList){
                                                    if(dedList[i].Applicant__c == app.Id && dedList[i].Source_Or_Target__c == 'Source'){
                                                        demogsChange = demogsChange+ ' '+dedList[i].Existing_cust_demog_change__c;
                                                    }
                                                }
                                                
                                            }*/
                                            
                                            /*CR 27077 s*/
                                            if(component.get("v.contObj") && !$A.util.isEmpty(component.get("v.contObj"))){
                                                console.log('Existing_cust_demog_change__c'+component.get("v.contObj").Existing_cust_demog_change__c);
                                                
                                                demogsChange =component.get("v.contObj").Existing_cust_demog_change__c;
                                                console.log('swapnil demogsChange::  '+demogsChange);
                                                
                                            }
                                            /*CR 27077*/
                                            
                                            objVfy.Document_particulars__c = demogsChange;
                                            allVeriList.push(objVfy);
                                        }
                                    }
                                    //alert('allVeriList'+allVeriList.length);
                                    component.set("v.allVeriList",allVeriList);
                                    var verAgencyMaster = component.get("v.allVeriAgency");
                                    var veriAgencyList = [];
                                    for(var i in allVeriList){
                                        var agencyList = [];
                                        for(var j in verAgencyMaster){
                                            // console.log('Sanity'+verAgencyMaster[j].Verification_Types__c+'Test--'+allVeriList[i].Verification_Type__c+'Test--'+verAgencyMaster[j].Location__c+'--'+Loan.Branch_Name__r.Name);
                                            if(verAgencyMaster[j].Verification_Types__c.includes(allVeriList[i].Verification_Type__c) && (verAgencyMaster[j].Location__c.toUpperCase() == Loan.Branch_Name__r.Name.toUpperCase())){
                                                agencyList.push(verAgencyMaster[j]); 
                                                
                                            }
                                        }
                                        //alert('agencyList'+agencyList.length);
                                        var valpresent = false;
                                        for(var j in veriAgencyList){
                                            console.log('veriAgencyList'+veriAgencyList[j].verType);
                                            if(veriAgencyList[j].verType == allVeriList[i].Verification_Type__c)    
                                                valpresent = true;
                                        }
                                        if(!valpresent)
                                            veriAgencyList.push({'verType':allVeriList[i].Verification_Type__c,'verAgencies':agencyList})
                                            }
                                    //alert('testing');
                                    component.set("v.veriAgencyList",veriAgencyList);
                                },
                                executeApex: function (component, method, params, callback) {
                                    var action = component.get("c." + method);
                                    action.setParams(params);
                                    action.setCallback(this, function (response) {
                                        var state = response.getState();
                                        console.log('state'+state);
                                        if (state === "SUCCESS") {
                                            console.log('response.getReturnValue()' + response.getReturnValue());
                                            callback.call(this, null, response.getReturnValue());
                                        } else if (state === "ERROR") {
                                            var errors = ["Some error occured. Please try again. "];
                                            var array = response.getError();
                                            for (var i = 0; i < array.length; i++) {
                                                var item = array[i];
                                                if (item && item.message) {
                                                    errors.push(item.message);
                                                }
                                            }
                                            //this.showToast(component, "Error!", errors.join(", "), "error");
                                            callback.call(this, errors, response.getReturnValue());
                                        }
                                    });
                                    $A.enqueueAction(action);
                                },
                                showhidespinner:function(component, event, showhide){
                                    console.log('in show hide');
                                    var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
                                    showhideevent.setParams({
                                        "isShow": showhide
                                    });
                                    showhideevent.fire();
                                    console.log('after event fire');
                                },
                                displayToastMessage:function(component,event,title,message,type)
                                {
                                    console.log('inside displayToastMessage'+message+type);
                                    var showhideevent =  $A.get("e.c:ShowCustomToast");
                                    showhideevent.setParams({
                                        "title": title,
                                        "message":message,
                                        "type":type
                                    });
                                    showhideevent.fire();
                                },
                                //Method added by swapnil for Story *899 s
                                verifyRecords : function(component,event){
                                    var verificationType = component.find("veritype").get("v.value");//US_5574
                                    if(component.find("rsaFlag") != null)//US_5574
                                        var selectRSA=component.find("rsaFlag").get("v.value");   
                                    if(!$A.util.isEmpty(selectRSA) && selectRSA != '--None--'){
                                        return true;
                                    }else if(verificationType=='RCU verifications' || verificationType=='Centralised sampling')//US_5574
                                    {
                                        return true;
                                    }
                                        else
                                            return false;
                                },
                                //Method added by swapnil for Story *899 s
                                /*Added by swapnil US 5331 s*/
                                getoppDetails : function(component, event) {
                                    console.log('in callVerificationAPI '+component.get('v.oppId'));
                                    var action = component.get('c.getOppDetails');
                                    action.setParams({
                                        "loanApplicationId" : component.get('v.oppId')
                                        
                                    });
                                    action.setCallback(this, function(response){
                                        
                                        var state = response.getState();
                                        //  alert('state '+state);
                                        if (state == "SUCCESS") {
                                            console.log('@@swapnil success');
                                            if(!$A.util.isEmpty(response.getReturnValue())){
                                                var data = JSON.parse(response.getReturnValue());
                                                // alert(JSON.stringify(data.opp));
                                                
                                                component.set("v.profileName",data.myProflieName);
                                                if (!$A.util.isEmpty(data.opp)){
                                                    component.set('v.Oppobj',data.opp);
                                                    
                                                    var product = $A.get("$Label.c.Top_Up_Dup_Unsecured_Products");
                                                    var productCodes = product.split(";");
                                                    if (!$A.util.isEmpty(component.get("v.Oppobj.Product__c"))){
                                                        var loanProduct = component.get("v.Oppobj.Product__c");                            
                                                    }
                                                    //US 5331 s
                                                    if (!$A.util.isEmpty(data.opp.stageName)){
                                                        component.set("v.stageName",data.opp.stageName);
                                                    }else
                                                        console.log('Stage Name not found');
                                                    //US 5331 e
                                                    
                                                    component.set("v.loanProduct",component.get('v.Oppobj.Product__c'));
                                                } 
                                                if (!$A.util.isEmpty(data.theme))
                                                    component.set('v.nameTheme', data.theme);
                                                
                                                
                                                if (!$A.util.isEmpty(data.applicantPrimary))
                                                    component.set("v.primaryApp", data.applicantPrimary);
                                                //  alert(JSON.stringify(data.applicantPrimary));
                                                if(!$A.util.isEmpty(data.dedupeList) && !$A.util.isEmpty(data.applicantPrimary)) 
                                                {
                                                    
                                                    var dedupeLst = data.dedupeList;
                                                    var dedupePrimaryLst = [];
                                                    for(var i=0;i<dedupeLst.length;i++){
                                                        if(dedupeLst[i].Applicant__c == data.applicantPrimary.Id){
                                                            
                                                            dedupePrimaryLst.push(dedupeLst[i]);
                                                        }
                                                        
                                                    }
                                                    component.set("v.dedupeList", dedupePrimaryLst); 
                                                }
                                                
                                                  /*CR 27077 s*/
                                                if(!$A.util.isEmpty(data.objCon)){
                                                  component.set("v.contObj", data.objCon); 
                                                   console.log('Swapnil critical demog change '+JSON.stringify(data.objCon)); 
                                                   
                                                }
                                                 /*CR 27077 e*/
                                                
                                                
                                                
                                                var verifyList  = [];
                                                var verComplete = true;
                                                console.log('data.veriList'+data.veriList);
                                                if (!$A.util.isEmpty(data.veriList)){
                                                    
                                                } 
                                                
                                                if (!$A.util.isEmpty(verifyList))
                                                    component.set("v.verifyList", verifyList);
                                                
                                                if (!$A.util.isEmpty(data.bankObj)){
                                                    component.set("v.bankObj", data.bankObj);
                                                    
                                                    
                                                }   
                                                
                                                if (!$A.util.isEmpty(data.accObj)) {
                                                    component.set("v.account", data.accObj);
                                                    
                                                    
                                                }
                                                
                                                
                                                //24668 stop*/
                                                if (!$A.util.isEmpty(data.camObj)){
                                                    //24668 stop
                                                    
                                                    
                                                    component.set("v.camObj", data.camObj);
                                                    
                                                }
                                                
                                                
                                            }  
                                        }
                                        else
                                            console.log('error'); 
                                        // this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
                                        this.showhidespinner(component,event,false);
                                        console.log('Applicant Obj now '+JSON.stringify(component.get("v.primaryApp")));
                                        // console.log('App type selected '+component.get("v.appType"));
                                    });
                                    $A.enqueueAction(action);
                                    
                                },
                                /*Added by swapnil US 5113 e*/
                            })