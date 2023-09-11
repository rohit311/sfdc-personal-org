({
    areaCheck : false,
    pinChangeHelper : function(component) {
        component.set("v.areaSearchKeyword",'');
        self.areaCheck = false;
    },
    doEmpCheck : function(component, event) {
        this.showhidespinner(component,event,true);
        var accObj = component.get("v.account");
        accObj.Accountant_email_id__c = component.get("v.contObj.Office_Email_Id__c");
      
        this.executeApex(component, "doEmploymentChecks",{
            "accObj": JSON.stringify(accObj),
            "oppObj": JSON.stringify(component.get("v.loan")),
            "cont": JSON.stringify(component.get("v.contObj"))
        },
                         function(error, result){
                             var objlst = JSON.parse(result);
                             console.log('objlistr -->'+JSON.stringify(objlst.objCon));
                             if(!$A.util.isEmpty(objlst))
                             {
                                 if(objlst.status == 'success')
                                 {
                                     component.set("v.applicantObj",objlst.applicantPrimary);
                                     component.set("v.contObj",objlst.objCon);
                                     component.set("v.account",objlst.accObj);
                                     this.displayToastMessage(component,event,'Success','Employment Check Initiated Successfully','success'); 
                                     this.showhidespinner(component,event,false);
                                 }
                                 else
                                 {
                                     this.displayToastMessage(component,event,'Error',result,'error'); 
                                     this.showhidespinner(component,event,false);
                                 }
                             }
                         });
    },
    PanCheck : function(component,event) {
        console.log("in pan check helper");
        var con= component.get("v.contObj");
        var acc = component.get("v.account");
        component.set("v.isPANCheckClick",true);//US_10726
        console.log('pan -->'+con);
        this.executeApex(component, "PANCheck", {"panNumber": component.get("v.account").PANNumber__c, "product": $A.get("$Label.c.Product_For_PAN_Check"),"oppId" : component.get("v.OppID"),"acc" :JSON.stringify(acc) ,"con" : JSON.stringify(con)}, function (error, result) {
            console.log('result : ' + (result.includes('exception')));
            console.log('Abhishek result::: '+result);
            if (!error && result && (!result.includes('exception'))) {
                 /*US_10726 S*/
                if(component.get("v.isPANCheckClick")==true && component.get("v.isCopyCKYC")==false)
                {
               component.find("FirstName").set("v.disabled", false); 
               component.find("MiddleName").set("v.disabled", false); 
               component.find("LastName").set("v.disabled", false); 
                }
                /*US_10726 E*/
                console.log('result12 : ' + result);
                if(result != 'Invalid')
                    var objlst = JSON.parse(result);
                console.log('result13 : '+objlst.accObj.PAN_Check_Status__c);
                this.displayToastMessage(component,event,'Success','PAN Check Initiated Successfully','success');
                //console.log('objlistr -->'+JSON.stringify(objlst));
                //console.log('objlst -->'+JSON.stringify(objlst.objCon.FirstName));
				  //Rohit 23578 added ckyc check start
                 console.log('ckyc flag' +component.get("v.isCkycDone"));
                if(component.get("v.isCkycDone") == false){
                component.set("v.contObj", objlst.objCon);
                component.set("v.account", objlst.accObj);
                }
                //Rohit 23578 ckyc check stop
                component.set("v.contObj", objlst.objCon);
                component.set("v.account", objlst.accObj);
                //added for bug id 18661 start
                var acc = component.get("v.account");
                /*component.set("v.panFname",acc.First_Name__c);
                 component.set("v.panMname",acc.Middle_Name__c);
                 component.set("v.panLname",acc.Last_Name__c);*/
                //acc.PAN_Check_Status__c = '';
                /*if(acc != null && acc != undefined && acc.Middle_Name__c != null || acc.Middle_Name__c !='' )
                	component.find("MiddleName").set("v.disabled",true);*/
                //added for bug id 18661 end
                
                //console.log('tatMasterRecord'+objlst.tatMasterRecord.PAN_Number__c);
                if(!$A.util.isEmpty(objlst.tatMasterRecord)){
                    if(!$A.util.isEmpty(objlst.tatMasterRecord.Name__c)){
                        var nameList = objlst.tatMasterRecord.Name__c.split(' ');
                        if(nameList.length > 0){
                            component.set("v.disablePAN",false);
                            component.set("v.panFname",nameList[0]);
                            if(nameList.length <= 2)
                                component.set("v.panLname",nameList[1]);
                            else{
                                component.set("v.panMname",nameList[1]);
                                component.set("v.panLname",nameList[2]);
                            }
                        }
                        
                    }
                    component.set("v.tatMasterRecord",objlst.tatMasterRecord);
                }
                
                if(!$A.util.isEmpty(objlst.PanCheckSOlPolicy))
                    component.set("v.PrimaryPNCheckLst",objlst.PanCheckSOlPolicy);
                if(!$A.util.isEmpty(objlst.accObj.Employer__c)){
                    component.set("v.EmployerSearchKeyword", objlst.accObj.Employer__r.Name);
                }
            }
            else{
                var acc = component.get("v.account"); 
                acc.First_Name__c = '';
                acc.Middle_Name__c = '';
                acc.Last_Name__c = '';
                acc.PAN_Check_Status__c = '';
                component.set("v.panFname",'');
                component.set("v.panMname",'');
                component.set("v.panLname",'');
                component.set("v.disablePAN",true);
                component.set("v.account",acc); 
                this.displayToastMessage(component,event,'Error','Unable to fetch details','error');
                console.log('result1234343 : ' + result);
            }
            this.showhidespinner(component,event,false);
			 //23578 start
                console.log('in pan '+$A.util.isEmpty(component.get("v.loan")));
                if(component.get("v.panSrc") && component.get("v.panSrc") == 'Landing'){
                    var callSave = $A.get("e.c:callSaveAfterPANChk");
                    callSave.fire();
                    
                }
                
                //23578 stop
        });
        /*var action = component.get("c.PANCheck");
        action.setParams({"panNumber": component.get("v.PAN"), "product": "SAL","oppId" : component.get("v.OppID"),"acc" :acc ,"con" : con});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var splitResult;
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result -->'+result);
                if(!$A.util.isEmpty(result))
                {
                    var objlst = JSON.parse(result);
                    console.log('objlistr -->'+JSON.stringify(objlst));
                    console.log('objlst -->'+JSON.stringify(objlst.con.FirstName));
                    component.set("v.contact", objlst.con);
                    component.set("v.account", objlst.acc);
                }
            }
            else{
                console.log('result failure-->'+response.getReturnValue());
            }
            this.showhidespinner(component,event,false);
        });
        
        $A.enqueueAction(action);*/
    },
    searchPOOfferHelper:function(component, event){
        console.log('in helper test');
        if(!$A.util.isEmpty(component.get("v.account.PANNumber__c"))||!$A.util.isEmpty(component.get("v.account.Mobile__c")) || (!$A.util.isEmpty(component.get("v.account.First_Name__c"))&&!$A.util.isEmpty(component.get("v.account.Mobile__c")))){
            this.showhidespinner(component,event,true);
            var mobStr;
            if(!$A.util.isEmpty(component.get("v.account.Mobile__c"))){
                mobStr = component.get("v.account.Mobile__c").toString();
            }
            var searchstring = '';
            if(!$A.util.isEmpty(component.find("PANString").get("v.value")))
                searchstring += component.find("PANString").get("v.value")+';';
            else
                searchstring += ';';
            if(!$A.util.isEmpty(component.find("FirstName").get("v.value")))
            	searchstring += component.find("FirstName").get("v.value")+';';
            else
                searchstring += ';';
            if(!$A.util.isEmpty(component.find("Mobile").get("v.value")))
            {  
                 var mobile = component.find("Mobile").get("v.value")+'';
                console.log('mobile '+mobile);
                if(mobile){
                 var  mobile1 = mobile.substring(0,5);
                 var mobile2 = mobile.substring(5);
                 console.log("pk mobile"+mobile1+'  '+mobile2);
            	//searchstring += component.find("Mobile").get("v.value")+';';
            	searchstring += mobile1+';'+mobile2+';';
                }
            }
            else
                searchstring += ';';
            
			console.log(searchstring);
            
            this.executeApex(component, 'getLoanItems', {
                "searchString" : searchstring
                
            }, function (error, result) {
                console.log('in result')
                if (!error && result) {
                    console.log('result  : '+result);
                    var data = JSON.parse(result);
                    component.set("v.defaultShow",true);
                    if($A.util.isEmpty(data.poList))
                        component.set("v.items", null);
                    else
                        component.set("v.items", data.poList);
                    console.log('result1  : '+result);
                    this.showhidespinner(component,event,false);
                }
                else{
                    this.showhidespinner(component,event,false);
                    component.set("v.items", null);
                }
                
            });
        }else
        {
            
            this.showhidespinner(component,event,false);
            component.set("v.items", null);
        }
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
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    executeApex: function(component, method, params,callback){
        
        console.log('params'+JSON.stringify(params));
        console.log('method name is '+method)
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('response is'+response);
            var state = response.getState();
            console.log('state is '+state);
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()123'+response.getReturnValue());
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
    officeemailverify : function(component, event) {
        this.executeApex(component, "verifyOtp",{"contObj" : JSON.stringify(component.get("v.contObj")), "applicantObj" :  JSON.stringify(component.get("v.applicantObj")), "otpValue" : component.get("v.otpValue")} , function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                if(result == 'success'){
                    //console.log("v.Ckycapplicant "+ component.get("v.Ckycapplicant").CKYC_No__c);
                    this.displayToastMessage(component,event,'Success','OTP validated successfully','success');
                    //23578 start
                    if(component.get("v.Ckycapplicant") && component.get("v.Ckycapplicant").Id){
                        console.log('inside ckyc ');
                        component.set("v.applicantObj",component.get("v.Ckycapplicant"));
                    }
                     //23578 stop
                    var app = component.get("v.applicantObj");
                    app.Office_Email_Id_Verified__c = true;
                    console.log('CKYC_No__c '+app.CKYC_No__c);
                    component.set("v.otpValue",'');
                    component.find("otpvalue").set("v.value",'');
                    component.set("v.applicantObj",app);
                }
                // US 3493 s
                else if (result=='mismatch') this.displayToastMessage(component,event,'Error','Official Email ID changed , please request for a new OTP','error');
                // US 3493 e
                
                else this.displayToastMessage(component,event,'Error','OTP did not match','error');
                
                
            }
            this.showhidespinner(component,event,false);
            
        });
        
    }, 
    fetchDataForDetails :function(component, event){
        var self = this;
        this.executeApex(component,"getOppDetails",{"loanApplicationId":component.get("v.OppID")},function (error, result) {
            if(!error && result != null && result != undefined){
                console.log('after'+result);
                var response = JSON.parse(result); 
                console.log(response);
                if(component.get("v.OppID") != null)
                {
                    if(!$A.util.isEmpty(response)){
                        console.log(response.opp);
                        
                        if(!$A.util.isEmpty(response.ekycobj) && !$A.util.isEmpty(response.ekycobj.eKYC_First_Name__c))
                            component.set("v.kyc",response.ekycobj);					            	                   
                        else
                            component.set("v.disableAadhaar",true);
                        
                        if(!$A.util.isEmpty(response.tatMasterRecord)){
                            if(!$A.util.isEmpty(response.tatMasterRecord.Name__c)){
                                var nameList = response.tatMasterRecord.Name__c.split(' ');
                                if(nameList.length > 0){
                                    component.set("v.disablePAN",false);
                                    component.set("v.panFname",nameList[0]);
                                    if(nameList.length <= 2)
                                        component.set("v.panLname",nameList[1]);
                                    else{
                                        component.set("v.panMname",nameList[1]);
                                        component.set("v.panLname",nameList[2]);
                                    }
                                }
                            }
                        }
                        if(response.isPreapproved == true)
                            component.set("v.po",response.poobj); 
                        else
                            component.set("v.disablePO",true);
                        
                        if(response.accObj != null){
                            component.set("v.account",response.accObj); 
                            /*if($A.util.isEmpty(response.accObj.PAN_Check_Status__c))
                            	component.set("v.disablePAN",true);*/
                        }
                        
                        /*else
                            component.set("v.disablePAN",true);*/
                        
                        //if(!$A.util.isEmpty(response.SOLPolicyList))
                        //  component.set("v.solObj",response.SOLPolicyList[0]); 
                        
                        if(!$A.util.isEmpty(component.get('v.account.Area_Locality__c')))
                            component.set("v.ValidAreaLocality",true);
                        if(!$A.util.isEmpty(component.get('v.account.Employer__c')))
                            component.set("v.ValidCompanyName",true);
                        /*City CR s*/
                        if(!$A.util.isEmpty(component.get('v.account.Current_City__c'))){
                            component.set("v.validCity",true);
                    }
                        /*City CR e*/
                    }
                    else{
                        component.set("v.disableAadhaar",true);
                        component.set("v.disablePO",true);
                        component.set("v.disablePAN",true);
                    }   
                }
            }
            else{              
                self.displayToastMessage(component,event,'Error','Internal server error , Please try again later !','error');
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
    doEPFO : function(component, event) {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "doEPFOChecks",{
            "accObj": JSON.stringify(component.get("v.account")),
            "oppObj": JSON.stringify(component.get("v.loan")),
            "cont": JSON.stringify(component.get("v.contObj")),
            "app": JSON.stringify(component.get("v.applicantObj")) //24668
        },
                         function(error, result){
                             var objlst = JSON.parse(result);
                             console.log('objlistr -->'+JSON.stringify(objlst.objCon));
                             if(!$A.util.isEmpty(objlst))
                             {
                                 if(objlst.status == 'success')
                                 {
                                     //component.set("v.applicant",objlst.applicantPrimary);
                                     component.set("v.contObj",objlst.objCon);
                                     component.set("v.account",objlst.accObj);
                                     this.displayToastMessage(component,event,'Success','EPFO check done Successfully','success'); 
                                     this.showhidespinner(component,event,false);
                                     component.set("v.epfoShow",true);
                                 }
                                 else
                                 {
                                     this.displayToastMessage(component,event,'Error','Error in EPFO check','error'); 
                                     this.showhidespinner(component,event,false);
                                 }
                             }
                         });
    },
    //added for bug id 21851 start
    getHideAadhaarSectionHelper:function(component)
    {
        var action = component.get("c.getHideAadhaarSection");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log('hide aadhaaar>>>'+response.getReturnValue());
               		component.set('v.hideAadhaarSection',response.getReturnValue());  
            }         
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
    },
    //added for bug id 21851 stop
    //23578 start
    changeCKYCfields : function(component,isEditable,event){
        console.log('in change');
           component.set("v.isCopyCKYC",true);//US_10726
           component.find("FirstName").set("v.disabled", !isEditable); 
           component.find("MiddleName").set("v.disabled", !isEditable); 
           component.find("LastName").set("v.disabled", !isEditable);  
           component.find("pincode").set("v.disabled", !isEditable);
           //component.find("PANString").set("v.disabled", !isEditable);     
           component.find("DOB").set("v.disabled", !isEditable);	
        //21238 start
        if(component.find("resAdd") && component.find("resAdd").get("v.value")){
            console.log('inside ckyc');
             component.find("resAdd").set("v.disabled", !isEditable);
            component.find("resAdd2").set("v.disabled", !isEditable);
            component.find("resAdd3").set("v.disabled", !isEditable);
                        
        } //21238 stop
           //component.find("areaLoc").set("v.disabled", !isEditable); 
           debugger;
        try {
         component.set("v.Ckycapplicant",JSON.parse(event.getParam("arguments").appObj));
            }catch(err) {
 					console.log('err.message '+err.message);
		}
        console.log("v.Ckycapplicant "+ component.get("v.Ckycapplicant").CKYC_No__c);
    },
    //23578 stop
    
})