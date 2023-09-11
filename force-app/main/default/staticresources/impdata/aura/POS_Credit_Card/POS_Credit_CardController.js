({
     doInit: function(component,event, helper) {
        debugger;
        // 16142__CIBIL Validation for Credit Card-Standalone
                   console.log('flow is Amar----- '+ component.get("v.flow"));
					    if (component.get("v.flow") == "PO") {
					         var validcibilrange = $A.get("$Label.c.cibil_Range"); // including both value for validation range.
							 
					 // var cibilarray = validcibilrange.split("-");
					      var indx = validcibilrange.lastIndexOf("-");
						  var min_val = parseInt(validcibilrange.substring(0, indx));
						  var max_val = parseInt(validcibilrange.substring(indx+1));
					/*	  
					  for (var i = 0; i < cibilarray.length; i++) {
					    if(i== 0)
					     min_val = parseInt(cibilarray[i]);
						if(i == 1)
					     max_val = parseInt(cibilarray[i]); 
					  }
					 */ 
					  
					  var cibilscore = 0;
					    if(component.get("v.cibil_Score") === "000-1")
						   cibilscore = 0;
						else if(component.get("v.cibil_Score") != null)
						   cibilscore = parseInt(component.get("v.cibil_Score"));
                        
						console.log('min_val for cibil validation is ----- '+ min_val);
                        console.log('max_val for cibil validation is ----- '+ max_val);						
                       	console.log('cibilscore is ----- '+ cibilscore);					
					  if (cibilscore >= min_val && cibilscore <= max_val){
					        component.set("v.isValidCibil",false);
						 console.log('cibil range condition satisfied');
					    }
                       console.log('Value of isValidCibil is ----- '+ component.get("v.isValidCibil"));
					 }
				  // US_16142__CIBIL Validation for Credit Card-Standalone
         var mode=component.get("v.readOnlyMode");
         if(mode=='true'){
             component.set("v.isMCPDedupePassSTS",true);
             component.set("v.readOnlyMode",true);
             }
         else
             component.set("v.readOnlyMode",false);
         helper.getPicklistOptions(component);
          //US:24037 USERSTORY_Requirement for CA Cards start 
         helper.getPicklistOptionsMstatus(component);
          //US:24037 USERSTORY_Requirement for CA Cards end 
         helper.cCDPicklistOptions(component);//US : 2702
         var IsDSS = component.get("v.isDSS");
         if(IsDSS == 'true'){
             console.log('inside DSS');
             helper.creditCardClick(component,event,helper);
         }
        
     },
     closeCustomToast : function(component, event, helper){  
        helper.closeToast(component);
    } ,
     getDocuments: function(component,event, helper) {

        helper.getDocument(component);
    },
    creditCardClick: function(component,event, helper) {
         component.set("v.isConfirmOpen",false);
          component.set("v.isApplyWithoutLoan",false);
        helper.creditCardClick(component);
    },
      closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
     //US:17397 USERSTORY_Credit card E-application Standalone sourcing start
     SendConsentToCustomer: function(component, event, helper) {
      console.log('inside send consent to customer'+component.get("v.flow"));
      if(component.get("v.flow")=="PO" ){
      }   
	  //added by Gopika 
	  var isalldatavalid1 = true; 
         var isalldatavalid2 = true; 
         var isalldatavalid3 = true; 
         var isalldatavalid4 = true; 
         //US:24037 USERSTORY_Requirement for CA Cards start
          var isalldatavalid5 = true; 
          //US:24037 USERSTORY_Requirement for CA Cards end
         var inputField = component.find('inputFieldv');
         if(inputField) {
           inputField.showHelpMessageIfInvalid();
           isalldatavalid1 = inputField.get("v.validity").valid; // US : 2702 S
           console.log('issue is not fixed in  inputFieldv '+ isalldatavalid1);
         }
           //US:24037 USERSTORY_Requirement for CA Cards start
          var inputFieldMstatus = component.find('inputFieldvMarital');
         if(inputFieldMstatus) {
           inputFieldMstatus.showHelpMessageIfInvalid();
           isalldatavalid5 = inputFieldMstatus.get("v.validity").valid; // US : 2702 S
           console.log('issue is not fixed in  inputFieldMstatus '+ isalldatavalid5);
         }
          //US:24037 USERSTORY_Requirement for CA Cards end
         var inputCCD = component.find('inputCCDv'); 
         if(inputCCD){
             inputCCD.showHelpMessageIfInvalid();
             isalldatavalid2 = inputCCD.get("v.validity").valid;
             console.log('issue is not fixed in  inputCCDv '+ isalldatavalid2);
         }
         var mn = component.find('mName'); 
         if(mn){
             mn.showHelpMessageIfInvalid();
             isalldatavalid3 = mn.get("v.validity").valid;
             console.log('issue is not fixed in  mName '+ isalldatavalid3);
         }
         var fn = component.find('fName');
         if(fn){
             fn.showHelpMessageIfInvalid();
             isalldatavalid4 = fn.get("v.validity").valid;
             console.log('issue is not fixed in  fName '+ isalldatavalid4);
         }
          //US:24037 USERSTORY_Requirement for CA Cards start added isalldatavalid5
         if((isalldatavalid1 && isalldatavalid2 && isalldatavalid3 && isalldatavalid4 && isalldatavalid5) && (component.get("v.CC_Variant__c") || (!component.get("v.Customer_Interest__c")))){/*US : 2702 || component.get("v.Customer_Interest__c") == 'No' */
         console.log('here===>'+component.get("v.record"));
             component.set("v.record.Lead__r.CC_Disposition__c", component.get("v.CC_Disposition__c")); // US : 2702
           console.log('here===>sfsfsf');
             // console.log('after CC_Dispsosition__c --> '+ component.get("v.record.Lead__r.CC_Disposition__c")); // US : 2702
         component.set("v.record.Credit_Card_Type__c",component.get("v.CC_Variant__c"));
         //US:24037 USERSTORY_Requirement for CA Cards start
		  component.set("v.record.Lead__r.Marital_Status__c",component.get("v.maritalStatus"));
          helper.SendConsentToCustomer(component, event, helper);
         helper.saveDataCC(component);
		 }
   },
     //US:17397 USERSTORY_Credit card E-application Standalone sourcing end
     saveData: function(component, event, helper) {
         debugger;
         var isalldatavalid1 = true; // US : 2702 S added variable
         var isalldatavalid2 = true; // US : 2702 S added variable
         var isalldatavalid3 = true; // US : 2702 S added variable
         var isalldatavalid4 = true; // US : 2702 S added variable
           //US:24037 USERSTORY_Requirement for CA Cards start
            var isalldatavalid5 = true;
          //US:24037 USERSTORY_Requirement for CA Cards end
          var inputField = component.find('inputFieldv');
         if(inputField) {
           inputField.showHelpMessageIfInvalid();
           isalldatavalid1 = inputField.get("v.validity").valid; // US : 2702 S
           console.log('issue is not fixed in  inputFieldv '+ isalldatavalid1);
         }
          //US:24037 USERSTORY_Requirement for CA Cards start
          var inputFieldMstatus = component.find('inputFieldvMarital');
         if(inputFieldMstatus) {
           inputFieldMstatus.showHelpMessageIfInvalid();
           isalldatavalid5 = inputFieldMstatus.get("v.validity").valid; // US : 2702 S
           console.log('issue is not fixed in  inputFieldMstatus '+ isalldatavalid5);
         }
 //US:24037 USERSTORY_Requirement for CA Cards start
         var inputCCD = component.find('inputCCDv'); // US : 2702 S
         if(inputCCD){
             inputCCD.showHelpMessageIfInvalid();
             isalldatavalid2 = inputCCD.get("v.validity").valid;
             console.log('issue is not fixed in  inputCCDv '+ isalldatavalid2);
         }
         var mn = component.find('mName'); // US : 2702 S
         if(mn){
             mn.showHelpMessageIfInvalid();
             isalldatavalid3 = mn.get("v.validity").valid;
                 console.log('issue is not fixed in  mName '+ isalldatavalid3);
         }
         var fn = component.find('fName'); // US : 2702 S
         if(fn){
             fn.showHelpMessageIfInvalid();
             isalldatavalid4 = fn.get("v.validity").valid;
                 console.log('issue is not fixed in  fName '+ isalldatavalid4);
         }
 //US:24037 USERSTORY_Requirement for CA Cards start added isalldatavalid5
         if( (isalldatavalid1 && isalldatavalid2 && isalldatavalid3 && isalldatavalid4 && isalldatavalid5) && (component.get("v.CC_Variant__c") || (!component.get("v.Customer_Interest__c")))){/*US : 2702 || component.get("v.Customer_Interest__c") == 'No' */
             if( component.get("v.flow")=="PO" ){
                 if (component.get("v.record.Lead__r")) {
                     //component.set("v.record.Lead__r.Customer_Interest__c",component.get("v.Customer_Interest__c") ? 'Yes' : 'No');
                     console.log('before CC_Disposition__c --> '+ component.get("v.record.Lead__r.CC_Disposition__c")); // US : 2702
                     console.log('attribute CC_Disposition__c --> ', component.get("v.CC_Disposition__c")); // US : 2702
                     component.set("v.record.Lead__r.CC_Disposition__c", component.get("v.CC_Disposition__c")); // US : 2702
                     console.log('after CC_Dispsosition__c --> '+ component.get("v.record.Lead__r.CC_Disposition__c")); // US : 2702
                     component.set("v.record.Credit_Card_Type__c",component.get("v.CC_Variant__c"));
                      //US:24037 USERSTORY_Requirement for CA Cards start
                     component.set("v.record.Lead__r.Marital_Status__c",component.get("v.maritalStatus"));
                     if (component.get("v.isMCPDedupePassSTS") == false) {// US : 2702
                         // set value as Not eligible
                         component.set("v.CC_Disposition__c", 'Not Eligible');
                     }
                     debugger;
                     if(component.get("v.CC_Disposition__c") == 'Not Eligible' || component.get("v.CC_Disposition__c") == 'Not Interested')// !component.get("v.Customer_Interest__c") || component.get("v.Customer_Interest__c") == 'No' US : 2702
                         helper.saveData(component);
                     /*else if(helper.CheckDisposionField(component) && helper.CheckDocuments(component) && helper.CheckCardLimit(component))
                         helper.saveData(component);*/
                     else {// US : 2702 start if(helper.CheckDisposionField(component))
                         debugger;
                         if (component.get("v.CC_Disposition__c") == 'Only Credit Card') {
                             if (helper.CheckDocuments(component) && helper.CheckCardLimit(component)) {
                                 helper.saveData(component);
                             }
                         } else {
                             if (helper.CheckCardLimit(component)) {
                                helper.saveData(component);
                             }
                         }
                     }// US : 2702 end
                 }
             } else {
                 if (component.get("v.record.Account")) {
                     console.log('else 1 -->', component.get("v.record.Account"));
                     //component.set("v.record.Account.Customer_Interest__c",component.get("v.Customer_Interest__c") ? 'Yes' : 'No');US : 2702
                      component.set("v.record.Account.CC_Disposition__c", component.get("v.CC_Disposition__c")); // US : 2702
                     component.set("v.record.Account.CC_Variant__c",component.get("v.CC_Variant__c"));
 //US:24037 USERSTORY_Requirement for CA Cards start
                     component.set("v.conObj.Marital_Status__c",component.get("v.maritalStatus"));                    
					//if(!component.get("v.Customer_Interest__c") || component.get("v.Customer_Interest__c") == 'No' )// US : 2702
                     if(component.get("v.CC_Disposition__c") == 'Not Eligible' || component.get("v.CC_Disposition__c") == 'Not Interested')// US : 2702
                         helper.saveData(component);
                     else if(helper.CheckCardLimit(component))//helper.CheckDocuments(component) && // US : 2702
                         helper.saveData(component);
                 }
             }
         }
   },
    resendClick:function(component, event, helper) {
        debugger;
        if(component.get("v.ccSolRecord").CC_Number__c)
             component.set("v.Application_Number",component.get("v.ccSolRecord").CC_Number__c);
        var lstDocuments= [];
        var docToResend =event.getSource().get("v.value");  
        if(docToResend){
            lstDocuments.push(docToResend);
            helper.sendDocument(component,lstDocuments,true);
        }
           
    },

    closeConfirmBox: function (component,event,helper){ 
        component.set("v.isApplyWithoutLoan",false);
        component.set("v.isConfirmOpen",false);
    },
    // User Story 2357 Starts
     handleDocumentEvent: function (component,event,helper){ 
        var IsDSS = component.get("v.isDSS");
         if(IsDSS == 'true'){
           var docVar =  event.getParam("openDocument");
             if(docVar == 'true'){
                 component.set("v.documentOpen",true);
             }
             else{
                 component.set("v.documentOpen",false);
                  helper.getDocument(component);
             }
    
         }
    },
	// User Story 2357 Ends
    confirmOkTakeAction : function(component,event,helper){
        component.set("v.isApplyWithoutLoan",true);
        component.set("v.isConfirmOpen",false);
        if(component.get("v.isApplyWithoutLoan"))
            helper.sendCCRequestToSTS(component);//if field disposition is not doc recevied and interest yes then send request for cc
                   
        
    },
    CCDChange : function(component,event,helper) {/*US : 2702*/
        console.log('on change --> ', component.get("v.CC_Disposition__c"));
       // component.set("v.motherNm", "");
       // component.set("v.fatherNm", "");
        if(!$A.util.isEmpty(component.get("v.CC_Disposition__c")) && component.get("v.CC_Disposition__c") != 'Not Eligible' && component.get("v.CC_Disposition__c") != 'Not Interested') {
            component.set("v.Customer_Interest__c", true);
            debugger;
        } else {
            component.set("v.Customer_Interest__c", false);
            //component.set("v.motherNm", "");
            //component.set("v.fatherNm", "");
            debugger;
        }
        console.log('UI should change --> ', component.get("v.Customer_Interest__c"));
    },
    setCkycData : function(component,event,helper) {/*US : 2702*/
        var respMap = event.getParam("infObj");
        console.log('respMap --> ', respMap);
        //console.log('card number --> ', record.SOL_Policys__r);
        if (respMap != null && respMap != undefined) {
            component.set("v.ckycResp", respMap);
        }
    }

})