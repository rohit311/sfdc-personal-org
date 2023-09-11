({
    doInit : function(component){
        this.getallpicklistvalues(component);
        this.getappList(component);  
       // console.log('HI.....');
    },
	getappList : function(component) {
        this.executeApex(component, "getApplicantList", {"loanId" : component.get("v.loanId")}, function(error, result){
            if(!error && result){
                component.set("v.appLst", result || []); 
            }
		});
    },
    getallpicklistvalues : function(component){
        this.getpicklistvalues(component,'Applicant__c','Google_Check_Result__c','Result','googleCheckResult');
        this.getpicklistvalues(component,'Applicant__c','NonPositive_Result_Category__c','Non-Positive Result','nonPositiveResult');                                      	
    },
    getpicklistvalues : function(component,objapiname,fieldapiname,label,cmpId){
        this.executeApex(component, "getpicklistoptions", {"objectApiName" : objapiname,"fieldApiName" : fieldapiname}, function(error, result){
                if(!error && result){
                   // component.set("v."+listattribute, result || []);
                      //console.log(result);
                        this.setSelectOptions(component, result,label, cmpId);
                    
                   }
            });
	},
    setSelectOptions: function(component, data, label, cmpId){

      
         setTimeout(function(){ 
             //
             if(component.find(cmpId)){          
             //
             if( Object.prototype.toString.call( component.find(cmpId) ) === '[object Array]' ) {
                    for(var i=0; i < component.find(cmpId).length; i++){
                        
                        var opts = [{"class": "optionClass", label: "Select " + label, value: ""}];
                        for(var j=0; j < data.length; j++){
                            opts.push({"class": "optionClass", label: ''+data[j], value: data[j]});
                        }
                        component.find(cmpId)[i].set("v.options", opts);
                    }
             }else{
                 var opts = [{"class": "optionClass", label: "Select " + label, value: ""}];
                 for(var i=0; i < data.length; i++){
                     opts.push({"class": "optionClass", label: ''+data[i], value: data[i]});
                 }
                 component.find(cmpId).set("v.options", opts);
             }
         }
            },10);
     },
    googleCheck :function(component, event, helper){
        var currentappId = event.currentTarget.dataset.value; 
        var appLst = component.get("v.appLst");
        var URL = "https://www.google.co.in/search?source=hp&q=";
        //Added below URL_API by Rohan on -01-Feb-18. for q parameter Issue.
        var URL_API = "";
        for(var i = 0;i<appLst.length;i++)
        {
            if(currentappId == appLst[i].Id){   
         	URL += '"'+appLst[i].Contact_Name__r.Name+'"';
            URL_API += '"'+appLst[i].Contact_Name__r.Name+'"';
                if( appLst[i].Applicant_Type__c == "Primary")
                {
				// added for BugId-17136
						if(appLst[i].Contact_Name__r.Account.Group_Type__c == 'selfemployed' || appLst[i].Contact_Name__r.Account.Group_Type__c==''||appLst[i].Contact_Name__r.Account.Group_Type__c==null)
                        {
						
							 URL += 	' AND "'+appLst[i].Contact_Name__r.Residence_City__c+'" AND ';
							 //Added below URL_API by Rohan on -01-Feb-18. for q parameter Issue.
							 URL_API += 	' AND "'+appLst[i].Contact_Name__r.Residence_City__c+'" AND ';
						}else{
							 URL += 	' AND "'+appLst[i].Contact_Name__r.Account.Office_City__c+'" AND ';
							 //Added below URL_API by Rohan on -01-Feb-18. for q parameter Issue.
							 URL_API += 	' AND "'+appLst[i].Contact_Name__r.Account.Office_City__c+'" AND ';
						
						}
               
                }else{
                     URL += ' AND "'+appLst[i].Contact_Name__r.AppCity__c+'" AND ';
                    //Added below URL_API by Rohan on -01-Feb-18. for q parameter Issue.
                    URL_API += ' AND "'+appLst[i].Contact_Name__r.AppCity__c+'" AND ';
                }
            break;
         } 
        }
        //console.log($A.get("$Label.c.GoogleCheckString"));
         URL += $A.get("$Label.c.GoogleCheckString");
        //Added below URL_API by Rohan on -01-Feb-18. for q parameter Issue.
         URL_API += $A.get("$Label.c.GoogleCheckString");
        //window.open(URL,'_blank', 'location=yes,height=570,width=520,scrollbars=yes,status=yes');
         console.log(URL);
         console.log(URL_API);
        //Added below URL_API by Rohan on -01-Feb-18. for q parameter Issue.
        this.executeApex(component, "googleCheckAPI", {"id" : currentappId,"searchString" : URL_API}, function(error, result){
            if(!error && result){
                appLst[i].attachId = result;
                this.showToast(component, "success!",result, "success");
                //$A.get('e.force:refreshView').fire();
                //Added by Rohan on 30-Oct-2017 for Enhancment:14957 Biz Changes.
        			window.open(URL,'_blank');
         		//Ended by Rohan on 30-Oct-2017 for Enhancment:14957 Biz Changes.
               }
		});        
        
    },
    saveData :function(component, event, helper){
      if(this.validateData(component)){
       var saveButton = component.find("saveButton");
        saveButton.set("v.disabled",true);
         this.executeApex(component, "saveApplicants", {"appList" : component.get("v.appLst")}, function(error, result){
            if(!error && result){
               this.showToast(component, "success!",result, "success");
                 saveButton.set("v.disabled",false);
                //$A.get('e.force:refreshView').fire();
                window.location.href = window.location.href;
            }
		});
       }
    },
    validateData : function(component){
        var cmp = component.find("googleCheckResult");
        var flag = true;
        var isValid = true,result;
        if( Object.prototype.toString.call( cmp ) === '[object Array]' ) {
            for(var i=0;i<cmp.length;i++)
            {
               // console.log(cmp[i].get("v.value") == "");
                var isValid1 = true;
                result = !(cmp[i].get("v.value").includes("Select") ||  cmp[i].get("v.value") == "");
                cmp[i].set("v.errors", [{message: result ? "" : "Please select a valid Result"}]);
                isValid1 = isValid1 && result;
                
                if(isValid1){
                    cmp[i].set("v.errors", [{message:""}]);
                    var nonPositiveResult = component.find("nonPositiveResult")[i];
                    var GoogleCheckURL = component.find("GoogleCheckURL")[i];
                    //console.log(cmp[i].get("v.value") != "Positive");
                    if(cmp[i].get("v.value") != "Positive")
                    {
                        
                        
                        result = !(nonPositiveResult.get("v.value").includes("Select") ||  nonPositiveResult.get("v.value") == "");
                        nonPositiveResult.set("v.errors", [{message: result ? "" : "Please select a valid Result"}]);
                        isValid1 = isValid1 && result;
                        console.log(GoogleCheckURL.get("v.value"));
                        result = !(GoogleCheckURL.get("v.value") == "" || GoogleCheckURL.get("v.value") == undefined);
                        console.log('result'+result);
                        GoogleCheckURL.set("v.errors", [{message: result ? "" : "Please Add URLs"}]);
                        isValid1 = isValid1 && result;
                        
                        /*if(nonPositiveResult.get("v.value").includes("Select") || nonPositiveResult.get("v.value") == "")
                        {
                          nonPositiveResult.set("v.errors", [{message:"Please select a valid Result"}]); 
                            flag = false;
                        }else{
                          nonPositiveResult.set("v.errors", [{message:""}]); 
                        }*/
                        
                    }else{
                        nonPositiveResult.set("v.errors", [{message:""}]);
                        GoogleCheckURL.set("v.errors", [{message:""}]);
                    }
                }else{
                    
                }
                isValid = isValid1 && isValid;
            }
        }else{
            result = !(cmp.get("v.value").includes("Select") ||  cmp.get("v.value") == "");
			cmp.set("v.errors", [{message: result ? "" : "Please select a valid Result"}]);
            isValid = isValid && result;            
            
        	 if(isValid){
                cmp.set("v.errors", [{message:""}]);
                var nonPositiveResult = component.find("nonPositiveResult");
                var GoogleCheckURL = component.find("GoogleCheckURL");
                if(cmp.get("v.value") != "Positive")
                {                    
                    result = !(nonPositiveResult.get("v.value").includes("Select") ||  nonPositiveResult.get("v.value") == "");
                    nonPositiveResult.set("v.errors", [{message: result ? "" : "Please select a valid Result"}]);
                    isValid = isValid && result;
                    
                    result = !(GoogleCheckURL.get("v.value") == "" || GoogleCheckURL.get("v.value") == undefined);
                    console.log('result'+result);
                    GoogleCheckURL.set("v.errors", [{message: result ? "" : "Please Add URLs"}]);
                    isValid = isValid && result;
                }else{
                    nonPositiveResult.set("v.errors", [{message:""}]);
                    GoogleCheckURL.set("v.errors", [{message:""}]);
                }
                
            }
        }
      
        
        return isValid;
           
	},
    showToast: function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
            this.showHideDiv(component, "customToast", true);
        } 
    },
    showHideDiv: function(component, divId, show){
     
            $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
           $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
        
    },
    closeToast: function(component){
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
    executeApex: function(component, method, params, callback){
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
                this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component){
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function(component){
        this.showHideDiv(component, "waiting", false);
    }
})