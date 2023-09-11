({
   saveFinancialDetaildummy: function(component, event, helper) 
{
  component.set("v.spinnerFlag", "true");
      console.log('spinner here save==>'+component.get("v.spinnerFlag"));
  component.set("v.spinnerFlag", "true");
   this.executeApex(component, "checkSpinner", {
     "poID": component.get("v.poID")
   }, function(error, result) {
    console.log('Result is :' + result);
    if (!error && result) {
     console.log('Result' + result);
     this.AutopopulateDataDummy(component);
     component.set("v.spinnerFlag", "false");
   
    } else {
     component.set("v.spinnerFlag", "false");
    }
   });
 },
     AutopopulateDataDummy: function(component) {
          this.executeApex(component, "checkSpinner", {
     "poID": component.get("v.poID")
   }, function(error, result) {
    console.log('Result is :' + result);
    if (!error && result) {
     console.log('Result' + result);
    
     component.set("v.spinnerFlag", "false");
   
    } else {
     component.set("v.spinnerFlag", "false");
    }
   });
     },
    disbleForm: function(component){
    console.log('inside disbleForm');
      var list = [
           "bankName","bnkaccNo","bnkAccType","monthName","yearFirst","1st","11th","21st","monthNamesecond","YearSecond","1stSecond",
          "11thSecond","21stSecond","monthNameThird","YearThird","1stThird","11thThird","21stThird"
        ];
        console.log('list over here==>'+list);
        for (var i = 0; i < list.length; i++) {
            var cmpFind=component.find(list[i]);
           // console.log('cmpFind==>'+cmpFind);
            if(cmpFind)
            {
              //  console.log('inside cmpFind==>'+cmpFind);
            component.find(list[i]).set("v.disabled", true);
            }
        }
       // component.find("saveBtn").getElement().disabled = true;
},
 AutopopulateData: function(component) {
  component.set("v.spinnerFlag", "true");
  console.log('Id is of passed-->' + component.get("v.poID"));
  this.executeApex(component, "getFinancialDetails", {
    "poID": component.get("v.poID")
   },
   function(error, result) {
    if (!error && result) {
     console.log('result===>' + result);
    
     if (result.bank != null && result.bank != '' && result.bank != undefined) {
      component.set("v.bankAccountObj", result.bank);
     }
     if (result.trans1 != null && result.trans1 != '' && result.trans1 != undefined) {
      component.set("v.bankTransObjOne", result.trans1);
     }
     if (result.trans2 != null && result.trans2 != '' && result.trans2 != undefined) {
      component.set("v.bankTransObjSecond", result.trans2);
     }
     if (result.trans3 != null && result.trans3 != '' && result.trans3 != undefined) {
      component.set("v.bankTransObjThird", result.trans3);
     }
     component.set("v.yearFirst", component.get("v.bankTransObjOne").Year__c);
     component.set("v.yearSecond", component.get("v.bankTransObjSecond").Year__c);
     component.set("v.yearThird", component.get("v.bankTransObjThird").Year__c);

     component.set("v.monthNameFirst", component.get("v.bankTransObjOne").Months__c);
     component.set("v.monthNameSecond", component.get("v.bankTransObjSecond").Months__c);
     component.set("v.monthNameThird", component.get("v.bankTransObjThird").Months__c);
     console.log('component.get("v.bankAccountObj").Account_Type__c==>' + component.get("v.bankAccountObj").Account_Type__c);
     component.set("v.bankName", component.get("v.bankAccountObj").Bank_Name__c);
     component.set("v.bnkAccType", component.get("v.bankAccountObj").Account_Type__c);
console.log('here');
     component.set("v.spinnerFlag", "false");
        console.log('here spier',component.get("v.spinnerFlag"));
    } else {
     component.set("v.spinnerFlag", "false");
     console.log('error occured');
    }
    //    console.log('converted flag here is==>'+component.get("v.convertedFlag"));
    var isValid=true;
       if(result.poObj!=null)
 isValid = isValid && result.poObj.Product_Offering_Converted__c;
       console.log('isValid==>'+isValid);
      if(isValid)
     {
         console.log('inside disable form==>'+result.poObj.Product_Offering_Converted__c);
         this.disbleForm(component);
         console.log('save button found==>'+ component.find("saveBtn"));
          component.find("saveBtn").set("v.disabled", true);
       // component.find("saveBtn").getElement().disabled = true;
         
     }
   });
 },
 setYearValues: function(component) {
  var i = 0;
  var year;
  var listofyears = [];
  year = new Date().getFullYear()
  console.log('Year====>' + year);
  for (i = year; i > year - 100; i--) {
   listofyears.push(i);
  }
  console.log('added years are==>' + listofyears);

  component.set("V.yearvalue", listofyears);
 },
 getPicklistvalBankAccount: function(component) {

  component.set("v.spinnerFlag", "true");
  console.log('Inside all picklist');
  var listofAPIname = ["Bank_Name_List__c", "Account_Type__c"];
  var selectListNameMap = {};
  selectListNameMap["Bank_Account__c"] = listofAPIname;
  this.executeApex(component, "getAllPicklistvals", {
   "mapOfFeilds": JSON.stringify(selectListNameMap)
  }, function(error, result) {
   console.log('Result is :' + result);

   if (!error && result) {
    console.log('Result' + result);
    var bankpicklist = result["Bank_Account__c"];
    component.set("v.bankNamevalue", bankpicklist["Bank_Name_List__c"]);
    component.set("v.bnkAccTypevalue", bankpicklist["Account_Type__c"]);

    component.set("v.spinnerFlag", "false");
   } else {
    console.log('Errorrr');
    component.set("v.spinnerFlag", "false");
   }
  });


 },
 getPicklistvalBankTrans: function(component) {

  component.set("v.spinnerFlag", "true");
  console.log('Inside all picklist');
  var listofAPIname = ["Months__c"];
  var selectListNameMap = {};
  selectListNameMap["Bank_Transaction__c"] = listofAPIname;
  this.executeApex(component, "getAllPicklistvals", {
   "mapOfFeilds": JSON.stringify(selectListNameMap)
  }, function(error, result) {
   console.log('Result is :' + result);

   if (!error && result) {
    console.log('Result' + result);
    var bankpicklist = result["Bank_Transaction__c"];
    component.set("v.monthNamevalue", bankpicklist["Months__c"]);

    component.set("v.spinnerFlag", "false");
   } else {
    console.log('Errorrr');
    component.set("v.spinnerFlag", "false");
   }
  });



 },
 calculateMonthValue: function(month, component) {
  var monthValue = 0;

  if (month == 'JAN')
   monthValue = 1;
  if (month == 'FEB')
   monthValue = 2;
  if (month == 'MAR')
   monthValue = 3;
  if (month == 'APR')
   monthValue = 4;
  if (month == 'MAY')
   monthValue = 5;
  if (month == 'JUN')
   monthValue = 6;
  if (month == 'JUL')
   monthValue = 7;
  if (month == 'AUG')
   monthValue = 8;
  if (month == 'SEP')
   monthValue = 9;
  if (month == 'OCT')
   monthValue = 10;
  if (month == 'NOV')
   monthValue = 11;
  if (month == 'DEC')
   monthValue = 12;

  return monthValue;

 },
 saveFinancialDetail: function(component, event, helper) {
  component.set("v.spinnerFlag", "true");
      console.log('spinner here save==>'+component.get("v.spinnerFlag"));
component.set("v.bankAccountObj.Average_Bank_Balance__c", 0);
  component.set("v.monthValueFirst", this.calculateMonthValue(component.get("V.monthNameFirst")));
  component.set("v.monthValueSecond", this.calculateMonthValue(component.get("V.monthNameSecond")));
  component.set("v.monthValueThird", this.calculateMonthValue(component.get("V.monthNameThird")));

  component.set("v.bankTransObjOne.Month__c", component.get("v.monthValueFirst"));
  component.set("v.bankTransObjSecond.Month__c", component.get("v.monthValueSecond"));
  component.set("v.bankTransObjThird.Month__c", component.get("v.monthValueThird"));

  component.set("v.bankTransObjOne.Months__c", component.get("v.monthNameFirst"));
  component.set("v.bankTransObjSecond.Months__c", component.get("v.monthNameSecond"));
  component.set("v.bankTransObjThird.Months__c", component.get("v.monthNameThird"));

  component.set("v.bankTransObjOne.Year__c", component.get("v.yearFirst"));
  component.set("v.bankTransObjSecond.Year__c", component.get("v.yearSecond"));
  component.set("v.bankTransObjThird.Year__c", component.get("v.yearThird"));
component.set("v.bankAccountObj.Product_Offerings__c", component.get("v.poID"));
  component.set("v.bankAccountObj.Bank_Name__c", component.get("v.bankName"));
  component.set("v.bankAccountObj.Account_Type__c", component.get("v.bnkAccType"));
  var abbvalue = 0;
     
 abbvalue = (parseFloat(component.get("v.bankTransObjOne").Balance_10th_of_month__c) + parseFloat(component.get("v.bankTransObjOne").Balance_20th_of_month__c) + parseFloat(component.get("v.bankTransObjOne").Balance_Ist_of_Month__c) + parseFloat(component.get("v.bankTransObjSecond").Balance_10th_of_month__c) + parseFloat(component.get("v.bankTransObjSecond").Balance_20th_of_month__c) + parseFloat(component.get("v.bankTransObjSecond").Balance_Ist_of_Month__c) + parseFloat(component.get("v.bankTransObjThird").Balance_10th_of_month__c) + parseFloat(component.get("v.bankTransObjThird").Balance_20th_of_month__c) + parseFloat(component.get("v.bankTransObjThird").Balance_Ist_of_Month__c)) / 9;
 console.log('abbvalue===>'+abbvalue);
    if (abbvalue != null)
 component.set("v.bankAccountObj.Average_Bank_Balance__c", abbvalue.toFixed(2));
console.log('transaction 1===>'+component.get("v.bankTransObjOne").Balance_10th_of_month__c);
		
  var bankobj = component.get("v.bankAccountObj");
  var bankTransobj1 = component.get("v.bankTransObjOne");
  var bankTransobj2 = component.get("v.bankTransObjSecond");
  var bankTransobj3 = component.get("v.bankTransObjThird");
  var currentMonth = new Date().getMonth();
  var currentYear = new Date().getFullYear();
  currentMonth = currentMonth + 1;
  console.log('currentMonth  value==>' + currentMonth);
  console.log('currentYear  value==>' + currentYear);
  component.set("v.spinnerFlag", "true");
  var isvalid = true;
  var isMonthValid = true;
  var list = ["bankName", "bnkAccType", "monthName", "yearFirst", "1st", "11th", "21st", "monthNamesecond", "YearSecond", "1stSecond", "11thSecond", "21stSecond", "monthNameThird", "YearThird", "1stThird", "11thThird", "21stThird"];
  for (var i = 0; i < list.length; i++) {
   if (component.find(list[i]) && component.find(list[i]).get("v.required") == true && $A.util.isEmpty(component.find(list[i]).get("v.value"))) {
    isvalid = false;
    component.set("v.spinnerFlag", "false");
    component.find(list[i]).showHelpMessageIfInvalid();
    component.set("v.bankAccountObj.Average_Bank_Balance__c", 0);
   }
  }

  if ((currentYear == component.get("v.yearFirst") && component.get("v.monthValueFirst") > currentMonth) || (currentYear == component.get("v.yearSecond") && component.get("v.monthValueSecond") > currentMonth) || (currentYear == component.get("v.yearThird") && component.get("v.monthValueThird") > currentMonth)) {
   console.log('error here in month');
   isvalid = false;
   isMonthValid = false;
       component.set("v.bankAccountObj.Average_Bank_Balance__c", 0);

  }

  if (isvalid) {
   console.log('inside is valid');

   this.executeApex(component, "saveFinancialDetails", {
    "bankObject": JSON.stringify(bankobj),
    "bankTransObject1": JSON.stringify(bankTransobj1),
    "bankTransObject2": JSON.stringify(bankTransobj2),
    "bankTransObject3": JSON.stringify(bankTransobj3)
   }, function(error, result) {

    console.log('Result is :' + result);

    if (!error && result) {
     console.log('Result' + result);
     this.showtoast(component, event, 'sucess', "Financial Details Saved Sucessfully!!", 'sucess');
     helper.AutopopulateData(component,helper);
     component.set("v.spinnerFlag", "false");
    // component.set("v.isOpen", false);
     //component.set("v.bankAccountObj", {'sobjectType': 'Bank_Account__c', Bank_Name__c: '',Average_Bank_Balance__c: '0',Bank_Account_Number__c: '',Account_Type__c: ''});
     //component.set("v.bankTransObjOne", { 'sobjectType': 'Bank_Transaction__c',Months__c: '',Month__c: '', Year__c: '',Balance_10th_of_month__c: '',Balance_20th_of_month__c: '',Balance_Ist_of_Month__c: ''});
    // component.set("v.bankTransObjSecond", {'sobjectType': 'Bank_Transaction__c',Months__c: '',Month__c: '',Year__c: '', Balance_10th_of_month__c: '', Balance_20th_of_month__c: '',Balance_Ist_of_Month__c: ''});
     //component.set("v.bankTransObjThird", {'sobjectType': 'Bank_Transaction__c', Months__c: '',Month__c: '',Year__c: '',Balance_10th_of_month__c: '', Balance_20th_of_month__c: '',Balance_Ist_of_Month__c: ''});
    // component.set("v.yearFirst", '');
   //  component.set("v.yearSecond", '');
    // component.set("v.yearThird", '');
     //component.set("v.monthNameFirst", '');
    // component.set("v.monthNameSecond", '');
    // component.set("v.monthNameThird", '');
   //  component.set("v.bankName", '');
    // component.set("v.bnkAccType", '');
    } else {
     this.showtoast(component, event, 'Error', "Error while saving details!!", 'error');
     component.set("v.spinnerFlag", "false");
    }
   });


  } else {
   if (isMonthValid == false) {
    this.showtoast(component, event, 'Error', "Future Transaction Not Allowed!!", 'error');

   } else {
    this.showtoast(component, event, 'Error', "Please fill all the mandatory fields!!", 'error');
   }
   component.set("v.spinnerFlag", "false");
  }

 },

 showtoast: function(component, event, title, message, type) {
  var self = this;
  console.log('self', self);
  var toastEvent = $A.get("e.force:showToast");
  if (toastEvent) { //Standard toast message : if supports standard toast message
   console.log('Inside standard toast');
   toastEvent.setParams({
    "title": title,
    "message": message,
    "type": type,
    "mode": "dismissible",
    "duration": "3000"
   });
   toastEvent.fire();
  } else { //Custom toast message : if doesn not support standard toast message
   console.log('inside displayToastMessage' + message + type);
   var showhideevent = $A.get("e.c:ShowCustomToast");
   console.log('showhideevent--> ' + showhideevent);
   showhideevent.setParams({
    "title": title,
    "message": message,
    "type": type
   });
   showhideevent.fire();
  }
 },
 executeApex: function(component, method, params, callback) {
  var action = component.get("c." + method);
  action.setParams(params);
  console.log('In executeapex');
  action.setCallback(this, function(response) {
   var state = response.getState();
   console.log('reponse, ', response);
   if (state === "SUCCESS") {
    console.log('Success... ');
    callback.call(this, null, response.getReturnValue());
   } else if (state === "ERROR") {
    console.log('Error calling method' + response.getReturnValue() + method);
    callback.call(this, null, response.getReturnValue());

   }
  });
  $A.enqueueAction(action);
 },
})