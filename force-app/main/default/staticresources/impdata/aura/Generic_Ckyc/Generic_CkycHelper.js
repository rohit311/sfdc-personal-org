({
    getCkycDetails: function(component,event){    
        console.log('inside ckyc data');
        var oppId = component.get("v.oppId");
        var contSelectList = ["months_of_Residence__c","Marital_Status__c","Father_Spouse__c","Occupation_CKYC__c","Residence_Type__c","Father_Spouse_Salutation__c","Occupation_CKYC__c","Gender__c"];
        var appSelectList = ["Proof_of_Residence_Address_Submitted__c","Proof_of_Identity__c","Proof_of_Address_Submitted_for_Permanent__c"];
        var accSelectList = ["Gender__c","Preferred_language__c"];    
        var selectListNameMap = {};
        selectListNameMap["Applicant__c"] = appSelectList;
        selectListNameMap["Contact"] = contSelectList;
        selectListNameMap["Account"] = accSelectList;
        //console.log('inside ckyc data2');
        this.executeApex(component, "getCkycDetails", {"oppID":oppId, "objectFieldJSON" : JSON.stringify(selectListNameMap)}, function(error, result){
            if(!error && result){
                var data = JSON.parse(result);
                console.log('datapk'+JSON.stringify(data.objCon));
                var picklistFields = data.picklistData;
                var appPickFields = picklistFields["Applicant__c"];
                var conPickFields = picklistFields["Contact"];
                var accPickFlds = picklistFields["Account"];
                component.set("v.maritalStatusList", conPickFields["Marital_Status__c"]);
                component.set("v.fatherSpouseList", conPickFields["Father_Spouse__c"]);
                component.set("v.F_S_salutationlist", conPickFields["Father_Spouse_Salutation__c"]);
                component.set("v.employmentTypeList", conPickFields["Occupation_CKYC__c"]);
                component.set("v.residenceTypeList", conPickFields["Residence_Type__c"]);
                //Rohit months at residence start
                component.set("v.monthsAtResidence", conPickFields["months_of_Residence__c"]);
                //Rohit months at residence stop
                component.set("v.OccupationList", conPickFields["Occupation_CKYC__c"]);
                component.set("v.documentTypeList", appPickFields["Proof_of_Identity__c"]);
                component.set("v.permDocumentList", appPickFields["Proof_of_Address_Submitted_for_Permanent__c"]);
                component.set("v.resDocumentList", appPickFields["Proof_of_Residence_Address_Submitted__c"]);
                component.set("v.genderList", accPickFlds["Gender__c"]);
                component.set("v.pref_Language",accPickFlds["Preferred_language__c"]);
                if(component.get("v.forprimeAPP"))
                {
                    component.set("v.oppObj", data.opp);
                    component.set("v.accObj", data.accObj);
                    component.set("v.contObj", data.objCon);
                    component.set("v.appObj", data.applicantPrimary);
                    /*City CR s*/
                    console.log('Proof_of_Residence_Address_Submitted__c'+data.applicantPrimary.Proof_of_Residence_Address_Submitted__c);
                    if(!$A.util.isEmpty(component.get('v.contObj.Permanant_City__c'))){
                        component.set("v.validCity",true);
                        component.set("v.citySearchKeyword", component.get('v.contObj.Permanant_City__c'));
                    }
                    /*City CR e*/
                    if(!$A.util.isEmpty(data.poobj))
                    	component.set("v.poObj", data.poobj);
                    
                    if(!$A.util.isEmpty(data.eKycObj))
                    	component.set("v.eKycObj", data.eKycObj);
                    
                    if(!$A.util.isEmpty(data.bankObj))
                    	component.set("v.bankObj", data.bankObj);
                    
                    if(!$A.util.isEmpty(data.ekycobj) && data.ekycobj.eKYC_Gender__c!=null)
                    {
                        var gen= (data.ekycobj.eKYC_Gender__c =='M') ? "Male":"Female";
                        component.set("v.accObj.Gender__c", gen);
                    }
                    if(!$A.util.isEmpty(data.cibilobj))
                    	component.set("v.cibilobj", data.cibilobj);
                    
                    if(!$A.util.isEmpty(data.objCon))
                        component.set("v.permpincodebackup",data.objCon.Permanent_Pin_Code__c);
                    var resiAdd = '';
                    if(!$A.util.isEmpty(data.accObj))
                    {
                        if(data.accObj.Current_Residence_Address1__c != null)
                            resiAdd = resiAdd + data.accObj.Current_Residence_Address1__c;
                        if(data.accObj.Current_Residence_Address2__c != null)
                            resiAdd = resiAdd + ' ' + data.accObj.Current_Residence_Address2__c;
                        if(data.accObj.Current_Residence_Address3__c != null)
                            resiAdd = resiAdd + ' ' + data.accObj.Current_Residence_Address3__c;
                        component.set("v.resiAddress",resiAdd);
                    }
                    var permanentResiAdd = '';
                    if(!$A.util.isEmpty(data.objCon))
                    {
                        if(data.objCon.Permanant_Address_Line_1__c != null)
                            permanentResiAdd = permanentResiAdd + data.objCon.Permanant_Address_Line_1__c;
                        if(data.objCon.Permanant_Address_Line_2__c != null)
                            permanentResiAdd = permanentResiAdd + ' ' + data.objCon.Permanant_Address_Line_2__c;
                        if(data.objCon.Permanant_Address_Line_3__c != null)
                            permanentResiAdd = permanentResiAdd + ' ' + data.objCon.Permanant_Address_Line_3__c;
                        component.set("v.paramAddress",permanentResiAdd);
                        component.set("v.paramAddressbackup",permanentResiAdd);
                        
                    }
                    console.log("checkdataPer" + component.get("v.paramAddress"));
                    
                    var officeResiAdd = '';
                    if(!$A.util.isEmpty(data.objCon))
                    {
                        if(data.objCon.Address_Line_One__c != null)
                            officeResiAdd = officeResiAdd + data.objCon.Address_Line_One__c;
                        if(data.objCon.Address_2nd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + data.objCon.Address_2nd_Line__c;
                        if(data.objCon.Address_3rd_Line__c != null)
                            officeResiAdd = officeResiAdd + ' ' + data.objCon.Address_3rd_Line__c;
                        component.set("v.officeAddress",officeResiAdd);
                    }
                    console.log("checkdataOff" + component.get("v.officeAddress"));
                    var createContact = component.get('v.contObj');
                    if(createContact && (createContact.Residence_Type__c == 'Owned by Self/Spouse' 
                       || createContact.Residence_Type__c == 'Owned by Parent/Sibling'))
                        component.set('v.isOwnedTrue',false);
                    else      
                        component.set('v.isOwnedTrue',true);
                    this.showhidespinner(component,event,false);   
                }
            }
            else
                this.showhidespinner(component,event,false);
            
            //Apply active validations to POI and Name fields
            this.applyCkycValidation(component, event, true, true); //Bug 23146 - CKYC POI/ POA validation
            
        });
    },
    
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()'+response.getReturnValue());
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
    callPANBre :function(component , event)
    {
        
        this.showhidespinner(component,event,true);
        this.executeApex(component, "callPANBreOnCKYC", {
            'oppObj': JSON.stringify(component.get("v.oppObj")),
            'accObj': JSON.stringify(component.get("v.accObj")),
            'conObj': JSON.stringify(component.get("v.contObj")),
            'appObj': JSON.stringify(component.get("v.appObj")),
            'loanId': component.get("v.oppId")
        }, function (error, result) {
            console.log('result test: ' + result);
            if (!error && result) {
                console.log('result -->'+result);
                
                var objlst = JSON.parse(result);
                console.log('objlistr -->'+JSON.stringify(objlst));
                
                if(!$A.util.isEmpty(objlst))
                {
                    if(!$A.util.isEmpty(objlst.status))
                    {
                        if(objlst.status == 'PANBRE Done' || objlst.status == 'Success')
                        {
                            this.showhidespinner(component,event,false);
                            //this.displayToastMessage(component,event,'Success','PAN Check has already been done','success'); 
                        }
                        else{
                            this.showhidespinner(component,event,false);
                            if(objlst.status.includes('CIBIL And Dedupe response are not recived yet'))
                            {
                               this.displayToastMessage(component,event,'Pending',objlst.status,'error'); 
                            }
                            else
                            this.displayToastMessage(component,event,'Error',objlst.status,'error'); 
                            if(!$A.util.isEmpty(objlst.applicantPrimary))
                            {
                                component.set("v.appObj" , objlst.applicantPrimary);
                            }
                        }
                    }
                    
                    
                }
                
                
                
            }
            else{
                this.showhidespinner(component,event,false);
            }
        });
        
        
    },
    
    saveCKYCData: function(component,event){ 
        var conobj = component.get("v.contObj");
        var accObj = component.get("v.accObj");
        console.log(conobj);
        var result =[];
        //alert('a++'+component.get('v.contObj.Permanent_Pin_Code__c'));
        /*if(!$A.util.isEmpty(component.get('v.contObj.Permanent_Pin_Code__c'))
          || component.get('v.contObj.Permanent_Pin_Code__c') == 0)
        {
            component.set('v.contObj.Permanent_Pin_Code__c','');
            //alert('b++'+component.get('v.contObj.Permanent_Pin_Code__c'));
        }*/
                      
        if(component.get("v.forprimeAPP"))
        {
             conobj.Gender__c = accObj.Gender__c; //BUG 24006- GENDER NOT GETTING UPDATED IN CONTACT
            if(accObj.Gender__c == 'Male'){
               conobj.Sex__c = "M"; 
            }
            else if(accObj.Gender__c == 'Female'){
                conobj.Sex__c = "F";
            }
            else{
                conobj.Sex__c = "O";    
            }
            
            if((component.get("v.contObj.Residence_Type__c") != 'Owned by Self/Spouse') && 
           	(component.get("v.contObj.Residence_Type__c") != 'Owned by Parent/Sibling'))
        	{
                /*result = this.splitAddress(component,event,"perm_address");
                //console.log('inside saveckyc perm'+result);
                if(!$A.util.isEmpty(result))
                {
                    if(result[0])
                        conobj.Permanant_Address_Line_1__c = result[0];
                    else
                        conobj.Permanant_Address_Line_1__c ='';
                    if(result[1])
                        conobj.Permanant_Address_Line_2__c =result[1];
                    else
                        conobj.Permanant_Address_Line_2__c='';
                    if(result[2])
                        conobj.Permanant_Address_Line_3__c =result[2];
                    else
                        conobj.Permanant_Address_Line_3__c='';
                    
                    accObj.Permanent_Residence_Address1__c = conobj.Permanant_Address_Line_1__c;
                    accObj.Permanent_Residence_Address2__c = conobj.Permanant_Address_Line_2__c;
                    accObj.Permanent_Residence_Address3__c = conobj.Permanant_Address_Line_3__c;
                }*/
                accObj.Permanent_Residence_Address1__c = conobj.Permanant_Address_Line_1__c;
                accObj.Permanent_Residence_Address2__c = conobj.Permanant_Address_Line_2__c;
                accObj.Permanent_Residence_Address3__c = conobj.Permanant_Address_Line_3__c;
            }
            else{
               
                conobj.Permanent_Pin_Code__c = accObj.PinCode__c;
                conobj.Permanant_Address_Line_1__c='';
                conobj.Permanant_Address_Line_2__c='';
                conobj.Permanant_Address_Line_3__c='';
                conobj.months_of_Residence__c='';
                component.set("v.paramAddress",'');
                /*City CR s*/
                conobj.Permanant_City__c = '';
                conobj.Permanent_State__c = '';
                component.set("v.citySearchKeyword", '');
                component.set("v.validCity",false); 
                /*City CR e*/
            }
           /* result = this.splitAddress(component,event,"office_address");
            console.log('inside saveckyc offi'+result);
            if(!$A.util.isEmpty(result))
            {
                if(result[0])
                    conobj.Address_Line_One__c = result[0];
                else
                    conobj.Address_Line_One__c ='';
                if(result[1])
                    conobj.Address_2nd_Line__c =result[1];
                else
                    conobj.Address_2nd_Line__c='';
                if(result[2])
                    conobj.Address_3rd_Line__c =result[2];
                else
                    conobj.Address_3rd_Line__c='';
                
                accObj.Office_Address_1st_Line__c = conobj.Address_Line_One__c;
                accObj.Office_Address_2nd_Line__c = conobj.Address_2nd_Line__c;
                accObj.Office_Address_3rd_Line__c = conobj.Address_3rd_Line__c;
                
            }*/
            accObj.Current_Email_Id__c = conobj.Email;
            //accObj.Email_Id__c = conobj.Email;
            component.set("v.contObj", conobj);
            component.set("v.accObj", accObj);
        }
        
 /*addes by swapnil Employee Loan bug 20934  s*/
        if(component.get("v.isEmployeeLoan") ==true){
            //component.set("v.appObj.Employee_Modified__c",true); removed for CR by nandha,CKYC modification no longer restricted
            //console.log("swapnil v.appObj.ModifiedStatus__c"+component.get("v.appObj.ModifiedStatus__c"));
            // console.log('Index '+component.get("v.appObj.ModifiedStatus__c").indexOf("C"));
            /*var Modstatus='';
            if($A.util.isEmpty(component.get("v.appObj.ModifiedStatus__c")) || component.get("v.appObj.ModifiedStatus__c")=="undefined"){
                console.log('In swapnil first check ');
                 Modstatus='C;';
                
            } else { 

              //   console.log('In swapnil second check ');
             //   if(component.get("v.appObj.ModifiedStatus__c").indexOf("C") === -1)
                 Modstatus=component.get("v.appObj.ModifiedStatus__c")+'C;';
            }
            component.set("v.appObj.ModifiedStatus__c",Modstatus);*/
        }
        
        /*addes by swapnil Employee Loan bug 20934  e*/
        var check=component.get("v.copyresiaddressflag");
        component.set("v.contObj.Permanent_Address_same_as_Residence__c",check);
        var contactobj =JSON.stringify([component.get("v.contObj")]);
        var appobj =JSON.stringify([component.get("v.appObj")]);
        var accountobj =JSON.stringify([component.get("v.accObj")]);
        var oppObj =JSON.stringify([component.get("v.oppObj")]);
        console.log('oppObj is : '+oppObj);
        console.log('oppObj String: '+JSON.stringify(oppObj));
        this.executeApex(component, 'updateCKYCDetails', {
            "jsoncontactObj": contactobj,
            "jsonaccountObj":accountobj,
            "jsonappObj":appobj,
            "oppObj":oppObj,
            "copyresiaddress":component.get("v.copyresiaddressflag")
        }, function(error, result){
            console.log('in save ckyc');
            if(!error && result){
                //alert('result'+result);
                if(!$A.util.isEmpty(result))
                {
                     // user story 978 start
                     if(component.get("v.stageName") == 'DSA/PSF Login' && component.get("v.isUWCheck") == false) {
                    var updateidentifier =  $A.get("e.c:Update_identifier");
                    updateidentifier.setParams({
                        "eventName": 'Other Details',
                        "oppId":component.get("v.oppObj").Id
                    });
                    updateidentifier.fire();
                     }
                     if(component.get("v.stageName") == 'Post Approval Sales' && component.get("v.isUWCheck") == false && component.get("v.page") == 'pricing') {
                         var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'Pricing Other Details',
                            "oppId":component.get("v.oppObj").Id
                        });
                        updateidentifier.fire();
                     }
                      // user story 978 end
                    var data = JSON.parse(result);
                    console.log(data);
                    if(data.status == "City Fail"){
                        this.showhidespinner(component,event,false); 
                        this.displayToastMessage(component,event,'Error','Unable to save details. City/State mapping not available for pincode.','error');
                    }
                    else{
                        component.set("v.accObj", data.accObj );
                        component.set("v.contObj", data.objCon);
                        component.set("v.appObj", data.applicantPrimary);
                        
                        this.displayToastMessage(component,event,'Success','Data Saved successfully','success');
                        console.log('component.get("v.forprimeAPP")'+component.get("v.forprimeAPP"));
                        if(!component.get("v.forprimeAPP"))
                        {
                            var appEvent = $A.get("e.c:destroyAddCoAppCmp");
                            if(appEvent){
                                appEvent.fire();
                            } 
                        }
                        //underwriter screen changes start
                        //alert('Hi++'+component.get("v.accObj.Area_Locality__r.id"));
                        if(component.get("v.accObj.Area_Locality__r") != null){
                            component.set("v.accObj.Area_Locality__c",component.get("v.accObj.Area_Locality__r.id"));
                            //delete loan['Area_Locality__r'];
                        }
                        //underwriter screen changes end
                    }
                }
                else
                    this.displayToastMessage(component,event,'Error','Failed To Save','error');
                
                this.showhidespinner(component,event,false);
            }
            else
            {
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Failed To Save','error');
            }
            
        });
        
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
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
    splitAddress: function (component,event,key) {
        var totalAddress = component.find(key).get("v.value");
        var result = [];
        if (totalAddress) {
            var line = [];
            var length = 0;
            totalAddress.split(" ").forEach(function(word) {
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
        }
        return result;
    },
    
    disableRadioAddress: function (component, event) {
        if($A.util.isEmpty(component.get("v.eKycObj")))
            component.set("v.disableAadhaar", true);
        if($A.util.isEmpty(component.get("v.poObj")))
            component.set("v.disablePO", true);
        if($A.util.isEmpty(component.get("v.bankObj")))
            component.set("v.disablePerfios", true);
    },
    
    changePOaddress: function(component, event) {
        var productObj = component.get('v.poObj');
        if(productObj !=null)
        {
            var permAddress = '';
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_1__c'))){
                permAddress += component.get('v.poObj.Address_Line_1__c');
            }
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_2__c'))){
                permAddress += component.get('v.poObj.Address_Line_2__c');
            }
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_3__c'))){
                permAddress += component.get('v.poObj.Address_Line_3__c');
            }
            component.find("perm_address").set("v.value", permAddress);
            component.set('v.contObj.Permanent_Pin_Code__c',component.get('v.poObj.Pin_Code__c'));
            component.set('v.contObj.Permanant_City__c',component.get('v.poObj.Lead__r.Resi_City__c'));
            component.set('v.contObj.Permanent_State__c',component.get('v.poObj.Lead__r.Resi_State__c'));
        }
    },
    
    changeAadhaaraddress: function(component, event) {
        var eKycObj = component.get('v.eKycObj');
        if(eKycObj != null)
        {
            var permAddress = '';
            if(!$A.util.isEmpty(component.get('v.eKycObj.eKYC_Address_details__c'))){
                permAddress += component.get('v.eKycObj.eKYC_Address_details__c');
            }
            component.find("perm_address").set("v.value", permAddress);
            component.set('v.contObj.Permanent_Pin_Code__c',component.get('v.eKycObj.eKYC_Pin_Code__c'));
            component.set('v.contObj.Permanant_City__c',component.get('v.eKycObj.eKYC_City__c'));
            component.set('v.contObj.Permanent_State__c',component.get('v.eKycObj.eKYC_State__c'));
        }
    },
    
    changePerfiosaddress: function(component, event) {
        var bankObj = component.get('v.bankObj');
        if(bankObj !=null)
        {
            var permAddress = '';
            if(!$A.util.isEmpty(component.get('v.bankObj.Perfios_Client_Address__c'))){
                permAddress += component.get('v.bankObj.Perfios_Client_Address__c');
            }
            component.find("perm_address").set("v.value", permAddress);
            //component.set('v.contObj.Permanent_Pin_Code__c',component.get('v.poObj.Pin_Code__c'));
        }
    },
      //underwriter screen changes start
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        //var keyword = component.get("v.AreaSearchKeyword");
        console.log("keyword" + keyword+"key"+key);
        if(key == 'Employer')
        {
            if (keyword.length > 2 && !component.get('v.empsearching')) {
                console.log("keyword empsearching" + keyword+"key"+key);
                component.set('v.empsearching', true);
                component.set('v.oldSearchKeyword', keyword);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
        if(key == 'area')
        {
            if (keyword.length > 2 && !component.get('v.areasearching')) {
                component.set('v.areasearching', true);
                component.set('v.oldAreaKeyword', keyword);
                console.log('keyword -->'+component.get('v.oldAreaKeyword'));
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
    },
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    searchHelper: function (component, key, keyword) {
        console.log('executeApex>>' + keyword + '>>key>>' + key);
        
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord': keyword
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
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
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    //underwriter screen changes end
    
    validateCkycDetails: function(component, event, validatePOIFields){ 
        /**
         * @desc    Validate CKYC fields and add custom validity 
         * @param   component, event
         * 			validatePOIFields - flag indicating whether to validate Indentity Id(POI) field
         * @return  NA  
         * @requirement    Bug 23146 - CKYC POI/ POA validation
         */
        
        try{
            console.log('Helper validateCkycDetails ');
            console.log(validatePOIFields);
            
            //Is CKYCValidation Applicable : Start
            let isCKYCValidationApplicable = false;
            if( component.get('v.oppObj') && component.get('v.oppObj.Id') && component.get('v.oppObj.Created_Time__c') ){
                if(typeof CKYC_Validation != "undefined"){
                    if(typeof CKYC_Validation.isCKYCValidationApplicable != "undefined" ){
                        isCKYCValidationApplicable = CKYC_Validation.isCKYCValidationApplicable( component.get('v.oppObj.Id'), component.get('v.oppObj.Created_Time__c') );
                    }
                }
            }
            if(!isCKYCValidationApplicable){
                return true;
            }
            //Is CKYCValidation Applicable : End
            
            let isValid = true;
            
            //Validation: Configuration : Start
            let AllMessages, Validation_Details_POI_Number, keywords_document_name;
            if(typeof CKYC_Validation != "undefined"){
                //Get all Validation message details
                if(typeof CKYC_Validation.getAllMessages != "undefined" ){
                    AllMessages = CKYC_Validation.getAllMessages();
                }
                //Get all Validation details for identity document number field
                if(typeof CKYC_Validation.getValidation_Details_Proof_of_ID_Document_Number != "undefined" ){
                    Validation_Details_POI_Number = CKYC_Validation.getValidation_Details_Proof_of_ID_Document_Number();
                }
                //Get all keywords for identity document
                if(typeof CKYC_Validation.getKeywords_Proof_of_ID_Document_Name != "undefined" ){
                    keywords_document_name = CKYC_Validation.getKeywords_Proof_of_ID_Document_Name();
                }
            }
            //Validation: Configuration : End
            
            //Validation: POI Number Field : Start
            if(validatePOIFields){
                let isKeyPresent = false;
                let ele_proof = component.find('documet_type');
                let ele_id = component.find('doc_number');
                
                if(keywords_document_name && Validation_Details_POI_Number && ele_proof && ele_id){
                    let ele_proof_value = ele_proof.get('v.value');
                    let ele_id_value = ele_id.get('v.value');
                    let custom_validation_msg ='';
                    
                    //Resetting maxlength attributes
                    ele_id.set('v.maxlength', null );
                    ele_id.set('v.messageWhenTooLong', null );
                    
                    let isDisabled = false; //Field disbaled check
                    if(ele_id.get('v.disabled') && ele_id.get('v.disabled') == true){
                        isDisabled = ele_id.get('v.disabled');
                    }
                    console.log('isDisabled', isDisabled);
                    
                    if(ele_proof_value){
                        ele_proof_value = ele_proof_value.toLowerCase();
                        for(let i=0; i < keywords_document_name.length; i++){
                            let key = keywords_document_name[i];
                            //Check if document name is maintained in ckyc validation script
                            if(ele_proof_value.includes(key) && Validation_Details_POI_Number[key]){
                                isKeyPresent = true;
                                //Apply max length attribute 
                                if( Validation_Details_POI_Number[key].maxlength  ){
                                    ele_id.set('v.maxlength', Validation_Details_POI_Number[key].maxlength );
                                }
                                
                                //Test against valid regex pattern maintained in ckyc validation script 
                                if(ele_id_value && !isDisabled){ //Do not validate if field is disabled 
                                    let pattern = new RegExp(Validation_Details_POI_Number[key].regex_javascript_pattern);
                                    let isValid_current = pattern.test(ele_id_value);
                                    isValid = isValid && isValid_current;
                                    if(!isValid_current){
                                        custom_validation_msg ='Please enter valid ID Number';
                                        //Set message as per message maitained in ckyc validation script
                                        if(AllMessages && Validation_Details_POI_Number[key].validation_msg && AllMessages[Validation_Details_POI_Number[key].validation_msg].message_invalid){
                                            custom_validation_msg = AllMessages[Validation_Details_POI_Number[key].validation_msg].message_invalid;
                                        }
                                    }else{
                                        custom_validation_msg = '';
                                    }   
                                }
                                break;
                            }
                        }
                        //Set custom validation to element
                        if(ele_id_value && !isDisabled){ //Do not apply validation if field is disabled
                            ele_id.setCustomValidity(custom_validation_msg);
                            ele_id.reportValidity();   
                        }
                    }
                }
                console.log('After POI Validation : ',isValid);
            }
            //Validation: POI Number Field : End
            
            console.log('Final Validation : ',isValid);
        }catch(e){
            console.log('Exception in validateCkycDetails ', e);
        }
    },
    
    applyCkycValidation: function(component, event, applyToNameFields, applyToPOIFields){
        /**
         * @desc    Apply active validations for CKYC fields i.e. pattern, maxlength etc. 
         * @param   component, event
         * 			applyToNameFields - flag indicating whether to apply validation to Name fields
         * 			applyToPOIFields - flag indicating whether to apply validation to Indentity Id(POI) field
         * @return  NA  
         * @requirement    Bug 23146 - CKYC POI/ POA validation
         */
        try{
            console.log('Helper applyCkycValidation');
            
            //Is CKYCValidation Applicable : Start
            let isCKYCValidationApplicable = false;
            if( component.get('v.oppObj') && component.get('v.oppObj.Id') && component.get('v.oppObj.Created_Time__c') ){
                if(typeof CKYC_Validation != "undefined"){
                    if(typeof CKYC_Validation.isCKYCValidationApplicable != "undefined" ){
                        isCKYCValidationApplicable = CKYC_Validation.isCKYCValidationApplicable( component.get('v.oppObj.Id'), component.get('v.oppObj.Created_Time__c') );
                    }
                }
            }
            if(!isCKYCValidationApplicable){
                return true;
            }
            //Is CKYCValidation Applicable : End
            
            //Validation: Configuration : Start
            let Validation_Details_Name_Field,  Validation_Details_POI_Number, keywords_document_name;
            if(typeof CKYC_Validation != "undefined"){ 
                //Get Validation details for name field
                if(typeof CKYC_Validation.getValidation_Details_Name_Field != "undefined" ){
                    Validation_Details_Name_Field = CKYC_Validation.getValidation_Details_Name_Field();
                }
                //Get all Validation details for identity document number field
                if(typeof CKYC_Validation.getValidation_Details_Proof_of_ID_Document_Number != "undefined" ){
                    Validation_Details_POI_Number = CKYC_Validation.getValidation_Details_Proof_of_ID_Document_Number();
                }
                //Get all keywords for identity document
                if(typeof CKYC_Validation.getKeywords_Proof_of_ID_Document_Name != "undefined" ){
                    keywords_document_name = CKYC_Validation.getKeywords_Proof_of_ID_Document_Name();
                }
            }
            //Validation: Configuration : End
            
            //Apply html regex pattern to name fields : Start
            if(applyToNameFields){
                let fields_name = ['F_S_firstname', 'F_S_lastname', 'm_firstname', 'm_lastname']; 
                for(let i=0; i < fields_name.length; i++){
                    //Get name element
                    let ele_name = component.find(fields_name[i]);
                    
                    if(ele_name){
                        if(Validation_Details_Name_Field && Validation_Details_Name_Field.regex_html_pattern){
                            console.log('applying pattern ', Validation_Details_Name_Field.regex_html_pattern);
                            ele_name.set("v.pattern", Validation_Details_Name_Field.regex_html_pattern);
                        }
                    }
                }
            }
            //Apply html regex pattern to name fields : End
            
            //Apply maxlength to POI fields : Start
            if(applyToPOIFields){
                let ele_proof = component.find('documet_type');
                let ele_id = component.find('doc_number');
                if(keywords_document_name && Validation_Details_POI_Number && ele_proof && ele_id){
                    let ele_proof_value = ele_proof.get('v.value');
                    let ele_id_value = ele_id.get('v.value');
                    
                    //Resetting maxlength attributes
                    ele_id.set('v.maxlength', null );
                    ele_id.set('v.messageWhenTooLong', null );
                    
                    if(ele_proof_value){
                        ele_proof_value = ele_proof_value.toLowerCase();
                        for(let i=0; i < keywords_document_name.length; i++){
                            let key = keywords_document_name[i];
                            //Check if document name is maintained in ckyc validation script
                            if(ele_proof_value.includes(key) && Validation_Details_POI_Number[key]){
                                //Apply max length attribute 
                                if( Validation_Details_POI_Number[key].maxlength  ){
                                    ele_id.set('v.maxlength', Validation_Details_POI_Number[key].maxlength );
                                }
                                break;
                            }
                        }
                    }
                }
            }
            //Apply maxlength pattern to POI fields : End
        }catch(e){
            console.log('Exception in applyCkycValidation ', e);
        }
    },
    
})