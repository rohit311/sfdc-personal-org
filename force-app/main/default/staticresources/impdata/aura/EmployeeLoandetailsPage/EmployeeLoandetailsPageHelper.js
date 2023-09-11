({
    getoppDetails : function(component, event) {
        this.showhidespinner(component,event,true);                   

        var AccountSelectList = ["Total_Work_Experience_Yrs__c", "Total_Work_Experience_Months__c", "Current_experiance_in_Years__c", "Current_experiance_in_Month__c","Type_of_Educational_Institution__c"];
        var selectListNameMap = {};
        selectListNameMap["Account"] = AccountSelectList;
        var oppSelectList = ["Reject_Reason_1__c","Reject_Reason__c"];
        selectListNameMap["Opportunity"] = oppSelectList;
        var action = component.get('c.getOpportunityData');
        action.setParams({
            "oppId" : component.get('v.oppId'),
            "objectFieldJSON": JSON.stringify(selectListNameMap)
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('success');
                if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
                    console.log('print data '+response.getReturnValue()); 
                    component.set("v.profileName", data.myProflieName);
                    var picklistFields = data.picklistData;
                    var accountPickFlds = picklistFields["Account"];
                    var oppPickFlds = picklistFields["Opportunity"];
                    component.set("v.rejectOption1", oppPickFlds["Reject_Reason_1__c"]);
                    //component.set("v.rejectOption", oppPickFlds["Reject_Reason__c"]);
                    if (!$A.util.isEmpty(data) && !$A.util.isEmpty(data.options))
                    {
                        component.set("v.rejectOption",data.options);
                    }
                    console.log('pkreason'+oppPickFlds["Reject_Reason__c"]);
                    console.log('accountPickFlds["Total_Work_Experience_Yrs__c"] : ' + accountPickFlds["Total_Work_Experience_Yrs__c"]);
                    if (!$A.util.isEmpty(data.theme))
                    {
                        component.set("v.nameTheme",data.theme);
                    }
                    if (!$A.util.isEmpty(data.dsaUser))
                    {
                        component.set("v.dsaUser",data.dsaUser);
                    } 
                    console.log('pkisCommunityUsr'+oppPickFlds["Reject_Reason__c"]);
                    if (!$A.util.isEmpty(data.isCommunityUsr)){
                        component.set('v.iscommunityUser', data.isCommunityUsr);
                    }
                    if (!$A.util.isEmpty(data.ekycobj))
                    {
                        component.set('v.eKycObj',data.ekycobj);
                        component.set("v.isEkycDone",true);
                        this.eKycSplitAddress(component, event);
                    }
                    if (!$A.util.isEmpty(data.creditofcList))
                    {
                        component.set('v.creditofficerList',data.creditofcList);
                    }
                    if(!$A.util.isEmpty(data.tatMasterRecord))
                        component.set("v.tatMasterRecord", data.tatMasterRecord);   
                    if (!$A.util.isEmpty(data.poobj)){
                        component.set('v.poObj',data.poobj);
                        
                        if(!$A.util.isEmpty(data.poobj.Customer_ID1__r))
                            component.set("v.custId",data.poobj.Customer_ID1__r.Id);
                    }
                    
                    if (!$A.util.isEmpty(data.isPreapproved))
                        component.set("v.isPreapproved" ,data.isPreapproved);
                    if (!$A.util.isEmpty(data.opp))
                        component.set('v.loan',data.opp);
                    var loan = component.get("v.loan");
                    if(loan.StageName != 'DSA/PSF Login'){
                        component.set("v.isUWCheck",true);
                    }
                    if(loan != undefined && loan.Branch_Name__r != undefined && loan.Branch_Name__r.SAL_Branch_Type__c == 'Tier III')
                    {
                        component.set("v.isSpecialProfile", true);
                    }
                    component.set("v.TatTime", data.TatTime);
                    console.log('Tat time is ='+data.TatTime);
                    if (!$A.util.isEmpty(data.cibilobj))
                        component.set('v.cibilobj',data.cibilobj);
                    
                    if (!$A.util.isEmpty(data.cibilExt))
                        component.set('v.cibilExt',data.cibilExt);
                    
                    if (!$A.util.isEmpty(data.cibilExt1))
                        component.set('v.cibilExt1',data.cibilExt1);
                    
                    if (!$A.util.isEmpty(data.objCon)) {
                        component.set("v.conObj", data.objCon);
                        console.log('Contact object '+ JSON.stringify(component.get("v.conObj")));
                        var currentAddress="";
                        if(component.get("v.conObj.Address_1__c")!=null)
                            currentAddress=component.get("v.conObj.Address_1__c");
                        if(component.get("v.conObj.Address_2__c")!=null)
                            currentAddress=currentAddress+', '+component.get("v.conObj.Address_2__c");
                        if(component.get("v.conObj.Address_3__c")!=null)
                            currentAddress=currentAddress+', '+component.get("v.conObj.Address_3__c");
                       /*added by Employee Loan swapnil bug 22777 */
                        if(data.objCon.Permanent_Address_same_as_Residence__c !=null){
                           
                            component.set("v.copyresiaddressflag",data.objCon.Permanent_Address_same_as_Residence__c);
                        }
                        /*added by Employee Loan swapnil bug 22777 */
                        console.log('Current address '+currentAddress);
                        component.set("v.currentAddress",currentAddress);
                        console.log('pk gender1'+data.objCon.Sex__c);
                        //component.set("v.isSpecialProfile", data.objCon.Special_Profile_Employer__c);
                        component.set("v.specialPro",data.objCon.Special_Profile_Employer__c);
                        var officeResiAdd = '';
                        if(data.objCon.Address_Line_One__c != null)
                            officeResiAdd = officeResiAdd + data.objCon.Address_Line_One__c;
                        if(data.objCon.Address_2nd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + data.objCon.Address_2nd_Line__c;
                        if(data.objCon.Address_3rd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + data.objCon.Address_3rd_Line__c;
                        component.set("v.officeAddress",officeResiAdd);
                        
                    }
                    if (!$A.util.isEmpty(data.accObj)) {
                        component.set("v.accObj", data.accObj);
                        console.log('Contact object '+ JSON.stringify(component.get("v.accObj")));
                        //  console.log('Stamping Employer Name '+component.get("v.accObj").Employer__r.Name);
                        //  component.set("v.EmployerSearchKeyword",component.get("v.accObj").Employer__r.Name);
                        var mobile_number = component.get("v.mobileNumber");
                        mobile_number = "tel:"+data.accObj.Mobile__c;
                        component.set("v.mobileNumber",mobile_number);
                        
                        if (!$A.util.isEmpty(data.accObj.Area_Locality__c))
                            component.set("v.areaSearchKeyword", data.accObj.Area_Locality__r.Name);
                    }
                    if (!$A.util.isEmpty(component.get("v.accObj")) && !$A.util.isEmpty(component.get("v.accObj.EPFO_Result__c"))) {
                        component.set("v.epfoShow",true); 
                    }
                    if (!$A.util.isEmpty(data.applicantPrimary))
                    { 	
                        console.log('in if condition');
                         component.set("v.applicantObj", data.applicantPrimary);
                        component.get("v.applicantObj.Emp_tele_identifier__c")
                        if(component.get("v.applicantObj.Customer_Decline_Reasons__c")!=null || component.get("v.applicantObj.Emp_tele_identifier__c")){
                           component.set('v.availeLater',true);
                            console.log("avail later is "+ component.get("v.availeLater"));
                        }
                    }
                     
                    
                    console.log('data.applicantPrimary '+JSON.stringify(data.applicantPrimary));
                    if (!$A.util.isEmpty(data.bankObj))
                        component.set("v.bankObj", data.bankObj);
                    console.log('bank details');
                    console.log(component.get("v.bankObj"));
                    if (!$A.util.isEmpty(data.camObj))
                        component.set("v.camObj", data.camObj);
                    var bankObj = component.get("v.bankObj");
                    if(!$A.util.isEmpty(bankObj)){
                        if($A.util.isEmpty(bankObj.Perfios_Flag__c) || (!$A.util.isEmpty(bankObj.Perfios_Flag__c) && bankObj.Perfios_Flag__c == false)){
                            
                            var date1,date2,date3,diffDays12,diffDays13,diffDays23;
                            if(!$A.util.isEmpty(bankObj.Salary_Credit_Date1__c))
                                date1 = new Date(bankObj.Salary_Credit_Date1__c);
                            if(!$A.util.isEmpty(bankObj.Salary_Credit_Date2__c))
                                var date2 = new Date(bankObj.Salary_Credit_Date2__c);
                            if(!$A.util.isEmpty(bankObj.Salary_Credit_Date3__c))
                                var date3 = new Date(bankObj.Salary_Credit_Date3__c);
                            if(!$A.util.isEmpty(date1) && !$A.util.isEmpty(date2)){
                                var timeDiff12 = Math.abs(date1.getTime() - date2.getTime());
                                diffDays12 = Math.ceil(timeDiff12 / (1000 * 3600 * 24)); 
                            }
                            if(!$A.util.isEmpty(date1) && !$A.util.isEmpty(date3)){
                                var timeDiff13 = Math.abs(date1.getTime() - date3.getTime());
                                diffDays13 = Math.ceil(timeDiff13 / (1000 * 3600 * 24)); 
                            }
                            if(!$A.util.isEmpty(date2) && !$A.util.isEmpty(date3)){
                                var timeDiff23 = Math.abs(date1.getTime() - date2.getTime());
                                diffDays23 = Math.ceil(timeDiff23 / (1000 * 3600 * 24));  
                            }
                            if((!$A.util.isEmpty(diffDays12) && diffDays12 > 5) || (!$A.util.isEmpty(diffDays13) && diffDays13 > 5) || (!$A.util.isEmpty(diffDays23) &&diffDays23 >5))
                            {
                                component.set("v.datevariation","YES");
                            }
                            else
                            {
                                component.set("v.datevariation","NO");
                            }
                        }
                        else
                            component.set("v.datevariation","NO");
                        
                        
                        if($A.util.isEmpty(bankObj.Perfios_abb02__c))
                            bankObj.Perfios_abb02__c =0;
                        if($A.util.isEmpty(bankObj.Perfios_abb05__c))
                            bankObj.Perfios_abb05__c =0;
                        if($A.util.isEmpty(bankObj.Perfios_abb10__c))
                            bankObj.Perfios_abb10__c  =0;
                        var abbvalue = bankObj.Perfios_abb02__c + bankObj.Perfios_abb05__c + bankObj.Perfios_abb10__c;
                        if(abbvalue != 0)
                            abbvalue  = abbvalue / 3;
                        component.set("v.abbvalue",abbvalue);
                        
                        
                        
                    }
                    else{
                        component.set("v.datevariation","NO");
                        component.set("v.abbvalue","0");
                        
                    }
                    console.log('here cam');
                    var camObj = component.get("v.camObj");
                    if(!$A.util.isEmpty(camObj)){
                        console.log('here cam');
                        var amount1 = 0,amount2 = 0,amount3 = 0,diffamount12 = 0,diffAmount13 = 0,diffAmount23 = 0,averageSal = 0;
                        if(!$A.util.isEmpty(camObj.Average_incentive_for_Q1__c))
                            amount1 = camObj.Average_incentive_for_Q1__c;
                        if(!$A.util.isEmpty(camObj.Average_incentive_for_Q2__c))
                            amount2 = camObj.Average_incentive_for_Q2__c;
                        if(!$A.util.isEmpty(camObj.Average_incentive_for_Q3__c))
                            amount3 = camObj.Average_incentive_for_Q3__c;
                        
                        if(amount1 != 0){
                            diffamount12 = (amount1-amount2)/amount1;
                            diffAmount13 = (amount1-amount3)/amount1;
                        }
                        if(amount2 != 0){
                            diffAmount23 = (amount2-amount3)/amount2;
                        }
                        if((diffamount12 !=0 && diffamount12 > 0.15) || (!$A.util.isEmpty(diffAmount13) && diffAmount13 > 0.15) || (!$A.util.isEmpty(diffAmount23) && diffAmount23 > 0.15))
                        {
                            component.set("v.amountvariation","YES");
                        }
                        else
                        {
                            component.set("v.amountvariation","NO");
                        }
                        averageSal = amount1 + amount2 + amount3;
                        if(averageSal != 0)
                            averageSal = averageSal/3;
                        console.log('averageSal'+averageSal)
                        component.set("v.averageSal",averageSal);
                    }
                    else
                        component.set("v.amountvariation","NO");
                    if (!$A.util.isEmpty(data.SOLPolicyList))
                        component.set("v.solpolicyList", data.SOLPolicyList);
                    console.log('underwriter solpolicy');
                    console.log(data.SOLPolicyList);
                    if (!$A.util.isEmpty(data.accObj) && !$A.util.isEmpty(data.accObj.Employer__c)) {
                        var employerSearchKeyword = data.accObj.Employer__r.Name;
                        if (employerSearchKeyword.toUpperCase() == 'COMPANY NOT LISTED' || employerSearchKeyword.toUpperCase() == 'OTHER' || employerSearchKeyword.toUpperCase() == 'OTHERS') {
                            component.set("v.isOther", true);
                        }
                    }
                    var oppStage = data.opp.StageName;
                    if(oppStage == 'DSA/PSF Login' || oppStage == 'Underwriting')
                    {
                        console.log('pkstage'+oppStage);
                        // component.set("v.isdiablebutton",false);
                        component.set("v.isdiablesendback",false);
                    } 
                    if(oppStage == 'Re-Appraise- Loan amount' || oppStage == 'Underwriting' || oppStage == 'Re-Appraise- IRR' || oppStage == 'Re-Appraise- Tenor' || oppStage == 'Re-Appraise- Reject Case')
                    {
                        component.set("v.isdiablebutton",false);
                    }
                    if(oppStage == 'Approved' || oppStage == 'Re-Appraise- Loan amount' || oppStage == 'Underwriting' || oppStage == 'Re-Appraise- IRR' || oppStage == 'Re-Appraise- Tenor' || oppStage == 'Re-Appraise- Reject Case')
                    {
                        console.log('pkstage'+oppStage);
                        component.set("v.isdisablePricingbutton",false);
                    }
                    if(oppStage != null)
                    {
                        if(oppStage == 'DSA/PSF Login')
                            component.set("v.stageCompletion","20%");
                        else if(oppStage == 'Underwriting')
                            component.set("v.stageCompletion","40%");
                            else if(oppStage == 'Post Approval Sales')
                                component.set("v.stageCompletion","60%");
                                else if(oppStage == 'Branch Ops')
                                    component.set("v.stageCompletion","80%");
                                    else if(oppStage == 'Moved To Finnone')
                                    {
                                        component.set("v.stageCompletion","100%");
                                        $A.util.addClass(component.find("progressSpan"),"slds-progress-bar__value_success");
                                    }    
                    }
                    else
                        component.set("v.stageCompletion","0%");
                    
                } 
                this.showhidespinner(component,event,false);
            }
            else{
                console.log('error');
                this.showhidespinner(component,event,false);}
            // this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
        });
        $A.enqueueAction(action);
        
        
    },
     startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        //var keyword = component.get("v.AreaSearchKeyword");
        console.log("keyword" + keyword+"key"+key);
        if(key == 'area')
        {   console.log('outside area'+component.find("pincode").get("v.value")+component.get('v.areasearching'));
         if(!$A.util.isEmpty(component.find("pincode").get("v.value"))){
             if (keyword.length > 2 && !component.get('v.areasearching')) {
                 console.log('inside area');
                 component.set('v.areasearching', true);
                 component.set('v.oldAreaKeyword', keyword);
                 console.log('keyword -->'+component.get('v.oldAreaKeyword'));
                 this.searchHelperArea(component, key, keyword);
             }
             else if (keyword.length <= 2) {
                 console.log("keyword" + keyword+"key"+key);
                 component.set("v." + key + "List", null);
                 this.openCloseSearchResults(component, key, false);
             }
         }
         else{
             if(!self.areaCheck){
                 this.displayToastMessage(component,event,'Error','Please enter pin code','error');  
                 self.areaCheck = true;
             }
         }
        }
    },
      openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    eKycSplitAddress: function(component, event) {
        var eKycObj = component.get('v.eKycObj');
        if(eKycObj !=null)
        {
            var permanentAddress = component.get('v.eKycObj.eKYC_Address_details__c');
            if (permanentAddress) {
                var result = [], line = [];
                var length = 0;
                permanentAddress.split(" ").forEach(function(word) {
                    if ((length + word.length) >= 35) {
                        result.push(line.join(" "));
                        line = []; length = 0;
                    }
                    length += word.length + 1;
                    console.log('word'+word);
                    line.push(word);
                    console.log('line'+line);
                });
                if (line.length > 0) {
                    result.push(line.join(" "));
                    console.log('final result'+result);
                }
                
                if(result[0])
                    component.set('v.eKycAddress1',result[0]);
                else
                    component.set('v.eKycAddress1','');
                
                if(result[1])
                    component.set('v.eKycAddress2',result[1]);
                else
                    component.set('v.eKycAddress2','');
                
                if(result[2])
                    component.set('v.eKycAddress3',result[2]);
                else
                    component.set('v.eKycAddress3','');
            }
        }
    },
    validateData: function(component, event) {
        
        var BankaAccountNo=component.get("v.loan.Bank_A_c_No_of_Customer__c");
        var BankaAccountHolder=component.get("v.loan.Repayment_Account_Holder_Name__c");
        var BankName=component.get("v.loan.Repayment_Bank_Name__c");
        var currentAddress=component.get("v.currentAddress");
        var City=component.get("v.conObj.Residence_City__c");
        var State=component.get("v.conObj.State__c");
        var pincode=component.get("v.conObj.Pin_Code__c");
        
        console.log('BankaAccountNo '+BankaAccountNo+' BankaAccountHolder '+BankaAccountHolder+' BankName '+BankName+' currentAddress'+currentAddress+' City '+City+' State '+State+' pincode '+pincode );
        if(!$A.util.isEmpty(BankaAccountNo) && !$A.util.isEmpty(BankaAccountHolder) && !$A.util.isEmpty(BankName) && !$A.util.isEmpty(currentAddress)  && !$A.util.isEmpty(currentAddress)  && !$A.util.isEmpty(City)  && !$A.util.isEmpty(State)  && !$A.util.isEmpty(pincode)){
            
            return true;
        }
        return false;
    },
    saveLoanDetails :function(component, event,actionName) {
        this.showhidespinner(component,event,true);
        var loanObj='';
        var contObj='';
        var action = component.get('c.updateEmplyeeDetails');
        console.log('MY Action name is'+actionName);
        if(actionName=='Bank Details'){
            loanObj = JSON.stringify(component.get("v.loan"));
            contObj=JSON.stringify(component.get("v.conObj")); 
            action.setParams({"loanObjString":loanObj,"contObjString":contObj, "actionOn": actionName });
        }
        if(actionName=='Demographic Details'){
            
            var fullAdd =component.get('v.currentAddress');
            var str= fullAdd.split(' ');
            var address1='';
            var address2='';
            var address3='';
            var add='';
            var i=0;
            
            while(i<str.length){   
                console.log('str[i].length '+str[i]+'  '+str[i].length );
                if(((add.length)+(str[i].length))<=35 ){
                    address1=address1+" "+str[i]; 
                    add=address1;
                    
                    
                }else if( ((add.length)+(str[i].length))>35  && ((add.length)+(str[i].length))<=70 ){
                    address2=address2+" "+str[i];
                    add=address1+" "+address2;
                    
                }else{
                    address3=address3+" "+str[i];
                    add=address1+" "+address2+" "+address3;
                    
                }  
                i++;
            }
            
            console.log(' Adress will hold 1 '+address1+' 2 '+ address2+' 3 '+address3);
            component.set("v.conObj.Address_1__c",address1);
            component.set("v.conObj.Address_2__c",address2);
            component.set("v.conObj.Address_3__c",address3);          
            
            loanObj = JSON.stringify(component.get("v.loan"));
            contObj=JSON.stringify(component.get("v.conObj")); 
            action.setParams({"loanObjString":loanObj,"contObjString":contObj, "actionOn": actionName });
        }
        if(actionName==='Confirm EmployeeLA'){
            
           /* 
            var today= new Date().getDate();
            console.log(today);
            var fdd =new Date();
            if(today>=15)
            {
                var fddMonth=new Date().getMonth()+1;
                var now_year=new Date().getFullYear();
                fdd = new Date(now_year, fddMonth,2, 0, 0, 0, 0);
                console.log('fdd date '+fdd );
                
            }else{
                var fddMonth=new Date().getMonth()+2;
                var now_year=new Date().getFullYear();
                fdd = new Date(now_year, fddMonth,2, 0, 0, 0, 0);
                console.log('fdd date '+fdd);
            }
            
            var dd = fdd.getDate();
            var mm = fdd.getMonth()+1; //January is 0!
            var yyyy = fdd.getFullYear();
            if(dd<10){
                dd='0'+dd;
            } 
            if(mm<10){
                mm='0'+mm;
            } 
            var fddFinal =yyyy+'-'+mm+'-'+dd;  //month-day-year format*/
            var loan=component.get("v.loan");
            loan.StageName='Post Approval Sales';
            component.set("v.loan.StageName",'Post Approval Sales');
            // component.set("v.loan.First_Due_Date__c",fddFinal);
            loanObj = JSON.stringify(component.get("v.loan"));
            console.log('Updating LA '+loanObj);
            action.setParams({"loanObjString":loanObj,"contObjString":null, "actionOn": actionName });
        }
        action.setCallback(this,function(actionResult){
            var state = actionResult.getState();
            
            console.log('Status is '+state+'  retruned valeus are   '+JSON.stringify(actionResult));
            if(state === "SUCCESS"){
                
                this.displayToastMessage(component,event,'success','Data saved','success');
                var loanNum=component.get("v.loan.Loan_Application_Number__c");
                var msg='Your application '+loanNum+' is pending for verification . Our representative will contact you soon .';
                component.set('v.Message',msg);
               // component.set("v.currentStageIsMydetails",false); //stage gets change to POST APProval, so its false
                if(actionName=='Bank Details'){
                    component.set('v.isEditBank',true); 
                     component.set("v.applicantObj.Employee_Modified__c",true);

                }
                else if(actionName=='Demographic Details'){
                    component.set('v.isEditDemo',true);
                   component.set("v.applicantObj.Employee_Modified__c",true);
                } else if(actionName=='Confirm EmployeeLA'){
                    component.set("v.isDetailsAvailable",false);
                    component.set('v.selTabId','tab3');
                }
                
                
                component.set("v.goNext", true); 
                this.showhidespinner(component, event,false);
                
            } 
            else if(state === "ERROR") {
                his.showhidespinner(component, event,false);
                this.displayToastMessage(component,event,'Error',actionResult.getReturnValue(),'error');
            }
            
            
             this.showhidespinner(component,event,false);
        });
        $A.enqueueAction(action);
       
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
    
    hideConfirmation : function(component, event) {
        var cmpTarget = component.find('overrideModalbox');
        $A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpTarget, 'slds-hide');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');
    },
    callFeesAndCharges : function(component, event){
        this.showhidespinner(component,event,true);
        console.log('loan id passed is::::'+ component.get("v.oppId"));
        this.executeApex(component,"callCharges",{
            "oppId": component.get("v.oppId")
        },function(error, result){
            if(!error && result){
                console.log('result is'+result);
                this.getFeesList(component,event);   
               // this.showhidespinner(component,event,false);
                
            }
            
            this.showhidespinner(component, event,false);
        });
        
    },
    getFeesList : function(component,event){
        this.showhidespinner(component,event,true);
        this.executeApex(component,'getFeesList',{
            "oppId": component.get("v.oppId")
        },function(error, result){
            if(!error && result){
                var FeesList = JSON.parse(result);
                if(!$A.util.isEmpty(FeesList))
                    component.set("v.callCharges",true);   
            }
           // this.showhidespinner(component,event,false);
        });
        
    },
    executeApex: function(component, method, params,callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    searchHelperArea: function (component, key, keyword) {
        var pincode = component.find("pincode").get("v.value");
        console.log('executeApex>>' + keyword + '>>key>>' + key +'>>pincode'+pincode);
        
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord':keyword,
            'pincode':pincode.toString()
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
            }
            else if(key == 'area')
            {
                component.set('v.areasearching', false);
            }
        });
    },
    handleSearchResult: function (component, key, result) {
        console.log('key :  handleSearchResult' + key);
        console.log(result);
        console.log('v.oldSearchKeyword :' + component.get('v.oldSearchKeyword') + '  -> SearchKeyword : ' + component.get("v." + key + "SearchKeyword"));
        
        console.log('inside handleserach'+component.get('v.oldSearchKeyword')+component.get("v." + key + "SearchKeyword"));
        if(key == 'Employer')
        {
            component.set('v.empsearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
        if(key == 'area')
        {
            component.set('v.areasearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldAreaKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
    },
    isValidData : function (component, event,fieldList) {
        
        var valid=true;
        for(var i=0;i<fieldList.length;i++){
            console.log('list >>> ' + fieldList[i]);
            if(!component.find(fieldList[i]).get("v.validity").valid){
                
                component.find(fieldList[i]).showHelpMessageIfInvalid();
                valid=false;
            }
        }
        if(component.get("v.isConfirm"))
            { 
                component.set("v.isEditDemo",true);
        	    component.set("v.isEditBank",true);
                component.set("v.isConfirm",true);
            }
        return valid;
    },
})