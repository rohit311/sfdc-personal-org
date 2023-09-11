({
    generateOTP : function(component, event, helper) {
       
        /*Bug 18669 Start*/
        console.log('ispro::'+component.get("v.isPro"));
        console.log('ssm::'+component.get('v.aadharValue'));
       // if((component.get('v.aadharValue') == 'Biometric') && ((component.get("v.isPro") == true) || (component.get("v.isDSS") == true && component.get("v.isMobility") == true))){//added component.get("v.isPro") for ProMobility 18669
       if(component.get('v.aadharValue') == 'Biometric'){
        console.log('Aadhar Number is : '+component.find("aadharNumber").get("v.value"));
        var aadhaarField = component.find("aadharNumber");
        var aadhaarNumber = aadhaarField.get("v.value");
        var pattern = /^$|^\d{12}$/;
            if(pattern.test(aadhaarNumber)){
            	helper.getEncryptedAadhar(component,component.find("aadharNumber").get("v.value"));
                aadhaarField.set("v.errors",'');
            }
            else{
                aadhaarField.set("v.errors", [{message:"Please Enter Valid Aadhaar Number."}]);
            }
        }
        /*Bug 18669 End*/
        else{
		console.log('here '+component.get('v.isDSS'));      
       
        console.log('robin3 '+event.getSource().getLocalId());	
         //Rohit 16111 start for cancel button     
         if(component.get("v.ekycDone") != 'true') 
         {   
             if(event.getSource().getLocalId() == "CancelPopUp" || event.getSource().getLocalId() == "regenerateOTP" )
             {
                 helper.getOTP(component,true);
                 //Rohit bug 16463
                 document.getElementById('VaultSuccess').style.display = 'none';
             }
            else
            {   
                console.log('else cond');
                helper.getOTP(component,false);        
            }
        }
        else
        {
             alert('Ekyc already done !!');
        }
        //Rohit 16111 stop for cancel button
       }
    },
    /*Bug 16111 Krish s*/
    cancelDetails : function(component, event, helper) {
        helper.cancelDetails(component);
    },
    /*Bug 16111 Krish e*/
    submitOTP : function(component, event, helper){
        //Rohit changed name of method
        helper.submitOTP_helper(component);
        
    },
    disableForm: function(component, event, helper){
        helper.disableForm(component);
    },
    //Rohit ekyc 16111 start
    copyToConsent:function(component, event, helper){

       var num = component.find("aadharNumber").get("v.value");
       var v = num.replace(/\s+/g, '').replace(/[^0-9]/gi, '')
       var matches = v.match(/\d{4,16}/g);
  	   var match = matches && matches[0] || ''
  	   var parts = [];
  		for (i=0, len=match.length; i<len; i+=4) {         
    		parts.push(match.substring(i, i+4));
            
  		}
  		if (parts.length) {
   			parts.join(' ')
 		 } else;
        component.find("conAadhar").set("v.value",parts[0]+'-'+parts[1]+'-'+parts[2]);
        console.log('test');
    },
    validateButton:function(component, event, helper){
         console.log('hello');
         if(component.get("v.AgreeFlag")){
             component.find("generateOTP").set("v.disabled", false);
             //Rohit added for bug 20761
             if(component.get("v.isPro") == true && component.get('v.aadharValue') == 'Biometric') //added && component.get('v.aadharValue') == 'Biometric' for bug id 20800
             	component.find("copyAadhaarDetails").set("v.disabled", false);
        }
        else
        {
             component.find("generateOTP").set("v.disabled", true);
             //Rohit added for bug 20761
             if(component.get("v.isPro") == true && component.get('v.aadharValue') == 'Biometric')//added && component.get('v.aadharValue') == 'Biometric' for bug id 20800 
             	component.find("copyAadhaarDetails").set("v.disabled", true);
        }
        /* CR 22307 s*/
		if(!$A.util.isEmpty(component.get("v.page")) && ((component.get("v.page") == "Pricing2" && component.get("v.stageName") != 'Post Approval Sales') || (component.get("v.page") == "Sales2" && component.get("v.stageName") != 'DSA/PSF Login'))){
			component.find("generateOTP").set("v.disabled", true);
		}
		if(!$A.util.isEmpty(component.get("v.page")) && component.get("v.page") == "Credit2" ){
			var stage = component.get("v.stageName");
            if(stage == 'Underwriting' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
			{
			
			} 
			else{
				component.find("generateOTP").set("v.disabled", true);
			}
		}
        /* CR 22307 e*/
    },   
    doInit: function(component, event, helper) {
        if(component.find("generateOTP") != undefined)
         component.find("generateOTP").set("v.disabled", true);
        
        //Rohit added for Bug 20761 Start
        if(component.find("copyAadhaarDetails") != undefined)
         component.find("copyAadhaarDetails").set("v.disabled", true);
        //Rohit added for Bug 20761 Stop
        //console.log(typeof chkbox);
         window.onclick = function(event) {
           					if (document.getElementById('myModal') != null && (event.target == document.getElementById('myModal'))) {
                            document.getElementById('myModal').style.display = "none";
                        	}
                            
       					} 
        debugger;
        var btn = document.getElementById("termsAndConditions");
        /*Bug 18669 Start*/
        if((component.get("v.isDSS") == true|| component.get("v.ismobilityV2") == true )&& (component.get("v.isPro") == false) &&(component.get("v.stageName") != 'Post Approval Sales')  ){//added for Mobility V1&&component.get("v.isMobility") == false
            console.log('aadhar val : '+component.get("v.aadharValue")	);
            component.set("v.aadharValue",'Aadhaar OTP') ; //added for POS po
              }
        console.log('aadhar val after : '+component.get("v.aadharValue"));
        //if((component.get("v.isDSS") == true) && component.get("v.isMobility") == false) // removed || component.get("v.isPro") == true from first if for Promobility bug id 18669
            //component.set('v.aadharValue','Aadhaar OTP') ;//changed for radiobutton bug id 18669
        //commented for radiobutton bug id 18669 start
        /*var myResults =[];
        console.log('Stage is : '+component.get("v.stageName"));
         if(component.get("v.isDSS") == true && component.get("v.isMobility") == true){//added condition to enable biometric ekyc only for mobility and not for DSS and Promobility
        if(component.get("v.stageName") == 'Post Approval Sales'){
           // myResults.push({'label': 'Biometric', 'value': 'Biometric'});//commented for radiobutton bug id 18669
        }
        else{
           // myResults.push({'label': 'Aadhaar OTP', 'value': 'Aadhar_OTP'});//changed aadhaar spelling for bug id 19896 
           // myResults.push({'label': 'Biometric', 'value': 'Biometric'});//commented for radiobutton bug id 18669
        } 
         }/*else if(component.get("v.isPro") == true){//added for 18669 proMobility start
			myResults.push({'label': 'Aadhaar OTP', 'value': 'Aadhar_OTP'}); 
            myResults.push({'label': 'Biometric', 'value': 'Biometric'});             
         }*///added for 18669 proMobility end
       // component.set("v.aadharOption",myResults);*/ 
        //commented for radiobutton bug id 18669 end
        
        var ran = new Date();
        console.log('tiem: '  + ran.getTime().toString());
		component.set("v.randomNum", ran.getTime().toString());
        
        helper.getAadharConsent(component); //Bug-19368 by Nihit 
       //added for bug id 21851 start
        helper.getHideAadhaarSectionHelper(component);
       
        //added for 21851 end 
        //Added by Harshal for POS PO
        
        console.log('here I am'+component.get('v.aadharValue'));
         //var radioSelectEkyc = component.find("radioBiometric");
         //Post Approval Sales
        if(component.get('v.aadharValue') == 'Aadhaar OTP' && component.get('v.stageName') != 'Post Approval Sales' && (component.get("v.isPro") == true ||component.get("v.isMobility") == true) && component.get("v.ismobilityV2") == false){// bug id 18669
            component.find("radioAadharOTP").set('v.checked', 'true');
            component.find("radioBiometric").set('v.checked', 'false');
        }
        //console.log(radioSelectEkyc.get('v.checked'));
        // Harshal Added End
    },
    hideModal: function(component, event, helper){
    
        document.getElementById('consentDiv').style.display = "Block";
        document.getElementById('AadharHeading').style.display = "Block";
        document.getElementById('aadharNumberInputDiv').style.display = "Block";
        document.getElementById('VaultSuccess').style.display = "none";
        document.getElementById('checkBoxId').style.display = "block";
        document.getElementById('AadharHeading').style.display = "none";
        component.find("aadharNumber").set("v.disabled", false); 
        $A.util.removeClass(component.find("generateOTP"), 'slds-hide'); 
        $A.util.addClass(component.find("generateOTP"), 'slds-show');       
        $A.util.addClass(component.find("IagreeChk"), 'slds-show');
        document.getElementById('IAgree').style.display = "block";
        console.log('robin '+document.getElementById('checkBoxId').style.display);
        //Rohit added for 19712 start
        component.set("v.isOpen", false);
        component.set("v.isMobilityOpen", false);
        //Rohit added for 19712 end
        ///*17138 s*/
        var appEvent = $A.get("e.c:InitiateKYCForm");
        if(appEvent){
            appEvent.setParams({ "kyc" : null});
            appEvent.fire();
        }
        /*17138 e*/
	},
    displayTC: function(){
        document.getElementById("termsAndConditions").onclick = function(event) {
                        document.getElementById('consentDiv').style.display = "block";
                    }
    },
     hideMoblilityModal: function(component){
        component.set("v.isOpen", false);
        component.set("v.isMobilityOpen", false);
        if(!$A.util.isEmpty(document.getElementById('myModalDetails')))
    		document.getElementById('myModalDetails').style.display = "none";
        document.getElementById('consentDiv').style.display = "none";
        document.getElementById('aadharNumberInputDiv').style.display = "none";//added for bug id 16111
        document.getElementById('aadharNumberInputDiv1').style.display = "none";//added for bug id 16111
	},
    saveEKYC:function(component, event, helper){
        helper.saveEKYC(component, event);
    },
    closeModel : function (component, event, helper) {
    	component.set("v.isBioEkycModalOpen", false);
    },
    //added for bug id 18669 radiobutton start
    handleRadioClick : function (component, event, helper) {
        console.log('hello selected option is'+event.getSource().get('v.value'));
        component.set('v.aadharValue', event.getSource().get('v.value'));
        
        //Rohit added for bug 20761 S
        var valBtn = component.get('c.validateButton');
        $A.enqueueAction(valBtn);
        //Rohit added for bug 20761 E
    },//added for bug id 18669 radiobutton end
    //Rohit ekyc 16111 stop
    //added for 18669 for proMobility start
    copyAadhaarDetails: function (component, event, helper) {
        console.log('in ctrller method'+component.get("v.randomNum"));
		helper.copyAadhaarDetails(component);
    }
    //added for 18669 for proMobility end
   
})