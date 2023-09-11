({
	 submitOTP : function(component, event, helper){
         var oldotpval =component.get("v.oldotpValue");
         var productofferId = component.get("v.productofferId");
         var enteredotpval =component.get("v.otpValue");
          console.log('enterd'+enteredotpval);
         if(!$A.util.isEmpty(enteredotpval))
          {
          if(oldotpval === enteredotpval)
          {   
              $A.util.removeClass(component.find("otpdiv"), "slds-show");
              $A.util.addClass(component.find("otpdiv"), "slds-hide");
              var appEvent = $A.get("e.c:afterSubmitotp");
              if(appEvent){
                  appEvent.setParams({ "submitStatus" : true,"poId" : productofferId});
                  console.log('inside submitOTP'+oldotpval+enteredotpval);
                  appEvent.fire();
                  helper.displayToastMessage(component,event,'Success','OTP Validated Successfully','success');
                  component.destroy();
              }
            
          helper.submitOTP(component,event);
          }
              else
              {
                   var inputField = component.find('otpvalue');
    			   
                  if(inputField.get("v.validity").valid){
                      helper.displayToastMessage(component,event,'Error','OTP entered is invalid.Kindly regenerate OTP','error');
                      $A.util.removeClass(component.find("otpdiv"), "slds-hide");
                      $A.util.addClass(component.find("otpdiv"), "slds-show");
                  }
                  
              }
          }
          else if($A.util.isEmpty(enteredotpval))
         {
             console.log('in blank otp');
           helper.displayToastMessage(component,event,'Error','Please enter OTP','error');
           //component.find("otpvalue").showHelpMessageIfInvalid(); //commented for //22018/24966
            $A.util.removeClass(component.find("otpdiverr"), "slds-hide");////22018/24966
           $A.util.addClass(component.find("otpdiverr"), "slds-show"); //22018/24966 
             
         }
          else
          {
              console.log('in blank otp1');
           //helper.displayToastMessage(component,event,'Error','Please enter valid OTP','error');<!--Commented this code for Bug 18536 -->
           // Bug 18536 Start
           $A.util.removeClass(component.find("otpdiv"), "slds-hide");
           $A.util.addClass(component.find("otpdiv"), "slds-show");
           // Bug 18536 End
          
          }
          
         console.log('in blank otp1');
        /* else
         {
           helper.displayToastMessage(component,event,'Error','Please enter OTP','error');
           component.find("otpvalue").showHelpMessageIfInvalid();   
         }*/
    },
    generateOTP : function(component,event,helper){
               component.set("v.otpValue","");//22018
        console.log('inside generateOTP');
        $A.util.removeClass(component.find("otpdiverr"), "slds-show");//22018/24966
        $A.util.addClass(component.find("otpdiverr"), "slds-hide");  //22018/24966
        $A.util.addClass(component.find("otpdiv"), "slds-hide");// Bug 18536
        $A.util.removeClass(component.find("otpdiv"), "slds-show");//22018
        var phonenumber = component.get("v.phonenumber");
        console.log('inside generateOTP phonenumber'+phonenumber);
         if(!$A.util.isEmpty(phonenumber))
         {
             helper.generateOTP(component,event);  
         }
        
            
    },
	setOtpValue: function (component, event) {
        var otpval = event.getParam("Otpvalue");
        var productofferval = event.getParam("poId");
       console.log('inside setOtpValue'+otpval+productofferval);
         if(!$A.util.isEmpty(otpval)){
		 component.set("v.oldotpValue",otpval);
         }else{
             component.set("v.oldotpValue", '');
         }
         if(!$A.util.isEmpty(productofferval)){
         component.set("v.productofferId",productofferval);
         }else{
             component.set("v.productofferId", '');
         }
    },
    clearOtpVal : function(component,event,helper){
       component.set("v.otpValue","");
        //var otpfield = component.find("otpvalueId");
       // otpfield.set("v.errors",null);
        $A.util.removeClass(component.find("otpdiverr"), "slds-show");//22018/24966
        $A.util.addClass(component.find("otpdiverr"), "slds-hide"); //22018/24966
       $A.util.removeClass(component.find("otpdiv"), "slds-show");
       $A.util.addClass(component.find("otpdiv"), "slds-hide");
    },
    valueChangeValidation : function(component,event,helper){
        console.log('in value chnage');
      	$A.util.removeClass(component.find("otpdiv"), "slds-show");
      	$A.util.addClass(component.find("otpdiv"), "slds-hide");
    },
})