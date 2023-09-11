({
    doinit : function(component, event, helper) {
        console.log('Login created');
        
         var url = $A.get('$Resource.bajaj_finserv_logo');
        component.set('v.backgroundImageURL', url);
               var url1 = $A.get('$Resource.employeeLoanBackground');
            component.set('v.employeeLoanBackground', url1);
    },
    
    
    
    
    scriptsLoaded : function(component, event, helper) {
        console.log('javaScript files loaded successful'); 
    },
    
    DisplayMobileNo : function(component, event, helper){
        var empId= component.get("v.EmployeeDetails.EmployeeId__c")
        component.set('v.EmployeeDetails.Mobile__c','');
        component.set('v.mobileToShow','');
        //if (empId.length==6)
        helper.DisplayMobileNo(component,empId);
        
    },
    getOTP :function(component, event, helper){
        //  var empId=component.find("empidno").get("v.value");
        // console.log(empId.length);
        var mobNo= component.get("v.EmployeeDetails.Mobile__c")
        if(mobNo.length>9)
        {
                    component.set("v.hideOTPButton",true);
            component.set("v.showSubmitButton",true);
            helper.getOTP(component);
        }
        else
        {        helper.displayToastMessage(component,event,'Error','Please enter valid Employee ID','error');	
         
        }    
        
    },
    submitOTP :function(component, event, helper){
        if(component.get("v.EmployeeDetails.One_Time_Password__c").length>0)
            helper.submitOTP(component);
        else
            helper.displayToastMessage(component,event,'Error','Please enter valid OTP','error');	
        
        
        
    }
})