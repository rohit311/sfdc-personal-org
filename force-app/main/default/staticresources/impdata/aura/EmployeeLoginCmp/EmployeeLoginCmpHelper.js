({
    DisplayMobileNo : function(component,empId) {
        var action = component.get("c.GetEmployeeMobileNo");
        action.setParams({
            "EmployeeID": empId,
            
        });
        action.setCallback(this, function(response) {
            var inputCmp = component.find("empidno");
            
            if(response.getReturnValue() != "NO DATA"){

                var objlst = JSON.parse(response.getReturnValue());
                component.set("v.EmployeeDetails.Mobile__c",objlst.encryptedMob);
                //var respMob=response.getReturnValue();
                //var MobileNumberToShow="";
                //MobileNumberToShow=MobileNumberToShow.concat("XXXXXXX", respMob.substring(respMob.length-3,respMob.length));
                component.set("v.mobileToShow",objlst.mobileToShow);
                component.set("v.isError",false);
                
                inputCmp.setCustomValidity("");
            }
            else{
                component.set("v.errorMessage","Please enter valid Employee ID");
                component.set("v.isError",true);
                
                inputCmp.setCustomValidity("Please enter valid Employee ID");
                
                
            }
            inputCmp.reportValidity();
        });
        
        $A.enqueueAction(action);
    },
    
    getOTP : function(component) {
        var action = component.get("c.sendOTP");
        action.setParams({
            "mobNumber": component.get("v.EmployeeDetails.Mobile__c"),
            "EmployeeID":component.get("v.EmployeeDetails.EmployeeId__c")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS' && response.getReturnValue() !='too many attempts') {
            	this.displayToastMessage(component,event,'Success','OTP has been sent to your registered mobile number','success');
            }
            else if(state == 'SUCCESS' && response.getReturnValue() =='too many attempts') {
                this.displayToastMessage(component,event,'Error','Your account is locked due to too many failed login attempts, Please contact Admin','error');	
            }
            else{
                this.displayToastMessage(component,event,'Error','An Internal Server error occured,Please try again later.','error');
            }            
        });
        
        $A.enqueueAction(action);
    },
    submitOTP : function(component) {
        var action = component.get("c.validateOTP");
        action.setParams({
            "EmployeeID":component.get("v.EmployeeDetails.EmployeeId__c"),
            "OTP": component.get("v.EmployeeDetails.One_Time_Password__c")
        });
        
        action.setCallback(this, function(response) {
            
            if(response.getReturnValue() == 'Login Successfull'){
                //login
                component.set("v.isError",false);
                
                component.set("v.homeFlag",false);
                
                var empid=component.get("v.EmployeeDetails.EmployeeId__c");
                console.log('Selected employee id '+empid);
               // var staticLabel = $A.get("$Label.c.BflsiteuserURL");
              //  window.location.href = staticLabel+'/EmployeeLoansLanding_VF?EmployeeId='+empid;
              this.sendEncryptEmployeeId(component,event);
            
            }
            else if(response.getReturnValue() =='Account locked' )
            {
                this.displayToastMessage(component,event,'Error','Your account is locked due to too many failed login attempts, Please contact Admin','error');	
            }
            else{
                // component.set("v.errorMessage","Please enter valid OTP");
                component.set("v.isError",true);
                this.displayToastMessage(component,event,'Error','Please enter valid OTP','error');	
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
    
    
     sendEncryptEmployeeId : function(component,event) {
                         var empid=component.get("v.EmployeeDetails.EmployeeId__c");
        var action = component.get("c.encryptEmpId");
        action.setParams({
            "EmployeeID": empid,
            
        });
        action.setCallback(this, function(response) {
            
            if(response.getReturnValue() != "NO DATA"){
                  var staticLabel = $A.get("$Label.c.BflsiteuserURL");
                console.log(response.getReturnValue());
                window.location.href = staticLabel+'/EmployeeLoansLanding_VF?EmployeeId='+response.getReturnValue();
                
            }
        });
        
        $A.enqueueAction(action);
    },
})