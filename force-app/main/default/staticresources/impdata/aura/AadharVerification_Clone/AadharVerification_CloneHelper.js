({
	getOTP: function(component,cancelClk) {
        var aadhaarField = component.find("aadharNumberCo");
        var aadhaarNumber = aadhaarField.get("v.value");
        var pattern = /^$|^\d{12}$/;
         var pObj = component.get("v.parentObj");
        var pId = component.get("v.parentId");
        //alert('aadhar '+aadhaarNumber);
         if(pObj === 'Applicant' && pId === 'OpenMarket'){
			pObj = '';
        	pId = '';
        }
        if(cancelClk )
            pId =component.get("v.parentId")+'-'+ 'cancel';             
       console.log('cancelClk'+cancelClk);
        //alert('rohit '+component.get("v.parentObj")+pId);
        
        if(pattern.test(aadhaarNumber)){
            var action = component.get("c.generateAadharOTPforMobility");
            action.setParams({
                "adharNmbr": aadhaarNumber,
                "Product":component.get('v.Product'),
                "HashCode": component.get("v.HashCode"),
                "parentObj" : pObj,
                "parentId" : pId
            });//added for Bug - 15230
            
            action.setCallback(this, function(response) {
        		var otpResponse = JSON.parse(response.getReturnValue());
                //alert('here1 '+otpResponse.status);
                if(otpResponse.status == 'SUCCESS'){
                    aadhaarField.set("v.disabled", "true");                  
                    component.set("v.HashCode",otpResponse.hashCode);//added for Bug - 15230
                    console.log('otpResponse.hashCode'+otpResponse.hashCode);
                    $A.util.addClass(component.find("generateOTPCo"), 'slds-hide');
                    //$A.util.removeClass(component.find("otpDetailsCo"), 'slds-hide');
                   
                     //Rohit Ekyc 16111 start
                     document.getElementById('checkBoxIdCo').style.display = 'none';
                    document.getElementById('consentDivCo').style.display = 'none';
                    document.getElementById('IAgreeCo').style.display = 'none';
                    //if(otpResponse.showEkycDetails && !cancelClk){
                        //alert('hi');
                    	//var showdet = component.find("showEkycDetails");
                     //console.log('inside OTP'+(aadhaarField.get('v.value') == '413061363611'));	 
                   if(otpResponse.showEkycDetails && !cancelClk){  
                    //if(aadhaarField.get('v.value') == '413061363611' && !cancelClk){
                       //alert('here1 '+otpResponse.showEkycDetails);
                    	//var vaultData = component.get("v.vaultData");
                        var vaultData = new Array();
                        console.log('robin '+otpResponse.ekycFN);
                        vaultData[0] = {"Name":"First Name ","Value": otpResponse.ekycFN};
                        vaultData[1] = {"Name":"Last Name","Value":otpResponse.ekycLN};
                        vaultData[2] = {"Name":"Gender","Value":otpResponse.ekycGender};
                        vaultData[3] = {"Name":"DOB","Value":otpResponse.ekycDob};
                        vaultData[4] = {"Name":"StreetAddress","Value":otpResponse.ekycStreetAddress};
                        vaultData[5] = {"Name":"City","Value":otpResponse.ekycCity};
                        vaultData[6] = {"Name":"State","Value":otpResponse.eKYCState};
                        vaultData[7] = {"Name":"ZipCode","Value":otpResponse.eKYCPinCode};
                        vaultData[8] = {"Name":"Phone","Value":otpResponse.ekycMobile};
                        vaultData[9] = {"Name":"Email","Value":otpResponse.ekycEmail};
                    	//console.log('robin3 '+otpResponse.ekycFN );
                    	//Date dob = new Date(otpResponse.ekycDob);
                    	//alert('here2 '+dob);
                    	
                    	var kycnew = component.get("v.kyc");            
                        
                       
                        kycnew.eKYC_First_Name__c = otpResponse.ekycFN;
                        kycnew.eKYC_Aadhaar_Number__c = otpResponse.eKYCAadhaarNumber;
                        kycnew.eKYC_Last_Name__c  = otpResponse.ekycLN;                       
                        //alert('here3');
                        kycnew.eKYC_Gender__c  = otpResponse.ekycGender;
                        //console.log('hashcode'+otpResponse.eKYCAadhaarNumber);                       
                          
                        //alert('here2 '+(typeof otpResponse.img));
                        kycnew.eKYC_Address_details__c = otpResponse.ekycStreetAddress;
                        kycnew.eKYC_City__c = otpResponse.ekycCity;
                        kycnew.eKYC_State__c = otpResponse.eKYCState;
                        kycnew.eKYC_Pin_Code__c = parseInt(otpResponse.eKYCPinCode);
                        kycnew. eKYC_Mobile_Number__c = parseInt(otpResponse.ekycMobile);
                        kycnew.Transaction_Id__c = otpResponse.Transaction_ID ;
                        kycnew.eKYC_District__c = otpResponse.eKYCDistrict; 
                        kycnew.eKYC_processing__c = otpResponse.eKYCprocessing;
                        kycnew.Device_Id__c = otpResponse.DeviceId;
                        kycnew.Device_Type__c = otpResponse.DeviceType;
                        kycnew.Service_Code__c = otpResponse.ServiceCode;
                        kycnew.Sub_Service_Code__c = otpResponse.SubServiceCode;
                        kycnew.Country__c = otpResponse.Country; 
                        kycnew.Location__c = otpResponse.Location;  
                        kycnew.Sub_District__c = otpResponse.SubDistrict;
                        kycnew.eKYC_Response__c = otpResponse.eKYCResponse; 
                        console.log('img '+(typeof otpResponse.img));
                        //Bug 16435
                        //kycnew.eKYC_Photo__c  = Base64.encode(otpResponse.img);
                        kycnew.eKYC_Photo__c =  '<!DOCTYPE html><html><body>' +							
                        ' <body><img src=' + 'data:image/jpeg;base64,' +otpResponse.img + '/>' +
              			'</body></html>';
                        //kycnew.eKYC_Enquiry_Number__c = parseInt(otpResponse.Transaction_ID);
                        component.set("v.kyc",kycnew);
                       var appEvent = $A.get("e.c:InitiateKYCForm");
                        if(appEvent){
                            appEvent.setParams({ "kyc" : kycnew});
                            appEvent.fire();
                        }
                       component.set("v.CoAppAadharNo",component.find("aadharNumberCo").get("v.value"));
                        //alert('here '+component.get("v.CoAppAadharNo"));    
                       //alert('here4');
                       component.set("v.vaultData",vaultData);
                       console.log('pktest');
                       //console.log(component.get("v.kyc"));
                       if(document.getElementById('myModalCo')!= null)
        				document.getElementById('myModalCo').style.display = "block";
                    	//showdet.set("v.value",vaultData);
                    	
                       
                        console.log('rohit '+document.getElementById('myModalCo'));
                         console.log(component.get("v.isDSS"));
                     //  document.getElementById('VaultSuccessCo').style.display = "block";//for bug id 16111
                       $A.util.addClass(component.find("otpDetailsCo"), 'slds-hide');
                       //document.getElementById('VaultSuccessCo').style.display = "block";                      
                       
                    }                 
                    else
                    {
                        component.set("v.kyc",null);
                        var appEvent = $A.get("e.c:InitiateKYCForm");
                        if(appEvent){
                            appEvent.setParams({ "kyc" : null});
                            appEvent.fire();
                        }
                         if(document.getElementById('myModalCo')!= null)	
                        	document.getElementById('myModalCo').style.display = "none";
                        $A.util.removeClass(component.find("otpDetailsCo"), 'slds-hide'); 
                        $A.util.addClass(component.find("otpDetailsCo"), 'slds-show');
                    }
        			//Rohit Ekyc 16111 stop
                    
        		} else if(component.get("v.isDSS") == false)
                {
                      $A.util.removeClass(component.find("otpDetailsCo"), 'slds-hide'); 
                      $A.util.addClass(component.find("otpDetailsCo"), 'slds-show');
                }
                else { 
                    aadhaarField.set("v.disabled", "false");
                    aadhaarField.set("v.errors", [{message:"Please Enter Valid Aadhaar Number and try again."}]);
                }
      		});
            $A.enqueueAction(action);
            aadhaarField.set("v.errors", [{message:""}]); 
        } else {
            aadhaarField.set("v.errors", [{message:"Please Enter Valid Aadhaar Number."}]);
        }
    },
    submitOTP: function(component) {
        var otpField = component.find("otpCo");
        otpField.set("v.errors", [{message:""}]);
        //alert('hi');
        //$A.util.removeClass(component.find("waitingCo"), 'slds-hide');
         console.log('inside submitOTP'+component.get("v.parentObj"));
        var action = component.get("c.getKYCDetails");
        var pObj = component.get("v.parentObj");
       
        action.setParams({
            "aadharCardNumber" : component.find("aadharNumberCo").get("v.value"),
            "otpCode" : otpField.get("v.value"),
            "HashCode": component.get("v.HashCode"),
            "parentObj" : pObj,
            "parentId" : component.get("v.parentId")
        });// Bug 16111
        //alert(component.get("v.parentId"));
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            if(result == null || result == 'undefined'){
                otpField.set("v.errors", [{message:"Validation Failed. Kindly regenerate OTP"}]);
            } else {
                $A.util.addClass(component.find("otpDetailsCo"), 'slds-hide');
                var appEvent = $A.get("e.c:InitiateKYCForm");
                // Bug 16111 S - Hemant Keni - Passing hashcode to VF page
                if(appEvent){
                    appEvent.setParams({ "kyc" : result });
                    appEvent.fire();
                }
                //Rohit 16111 hiding consent S
                document.getElementById('consentDivCo').style.display = 'none';
                document.getElementById('VaultSuccessCo').style.display = "block";
                
                document.getElementById('otpSubmitCo').style.display = "block";
                document.getElementById('aadharNumberInputDiv1Co').style.display = "none";
                document.getElementById('aadharNumberInputDivCo').style.display = "none";
                //Rohit 16111 hiding consent E
                var hashCodeEvt = $A.get("e.c:shareAadhaarHashCode");
                if(hashCodeEvt){
                    console.log('Inside HashCode Event');
                    hashCodeEvt.setParams({ "hashCode" : result.eKYC_Aadhaar_Number__c , "ekycid" : result.Id, "fromObj" : component.get("v.parentObj")});
                    console.log('result.eKYC_Aadhaar_Number__c : '+ result.eKYC_Aadhaar_Number__c + 'EKYCId : '+ result.Id);
                    hashCodeEvt.fire();
                   
                }
                console.log('component.get("v.isMobility")'+component.get("v.isMobility"));
                console.log('result is'+result);
                // Bug 16111 E - Hemant Keni - Passing hashcode to VF page
                if(component.get("v.isMobility") == true){
                    var vaultData = new Array();
                    console.log('robin '+result.eKYC_First_Name__c);
                    vaultData[0] = {"Name":"First Name ","Value": result.eKYC_First_Name__c};
                    vaultData[1] = {"Name":"Last Name","Value":result.eKYC_Last_Name__c};
                    vaultData[2] = {"Name":"Gender","Value":result.eKYC_Gender__c};
                    vaultData[3] = {"Name":"DOB","Value":result.eKYC_Date_of_Birth__c};
                    vaultData[4] = {"Name":"StreetAddress","Value":result.eKYC_Address_details__c};
                    vaultData[5] = {"Name":"City","Value":result.eKYC_City__c};
                    vaultData[6] = {"Name":"State","Value":result.eKYC_State__c};
                    vaultData[7] = {"Name":"ZipCode","Value":result.eKYC_Pin_Code__c};
                    vaultData[8] = {"Name":"Phone","Value":result.eKYC_Mobile_Number__c};
                    vaultData[9] = {"Name":"Email","Value":result.eKYC_E_mail__c};
                    component.set("v.vaultData",vaultData);
                    component.set("v.kyc",result);
                    if(document.getElementById('myModalDetailsCo')!= null)
                        document.getElementById('myModalDetailsCo').style.display = "block";
                }
                console.log('component.find("otpDetailsCo")'+component.find("otpDetailsCo"));
                $A.util.removeClass(component.find("otpDetailsCo"), 'slds-show');
                $A.util.addClass(component.find("otpDetailsCo"), 'slds-hide');
            }
            //$A.util.addClass(component.find("waitingCo"), 'slds-hide');
        });
        $A.enqueueAction(action);
	},
    disableForm: function(component){
        component.find("aadharNumberCo").set("v.disabled", true);
        component.find("generateOTPCo").set("v.disabled", true);
        $A.util.addClass(component.find("otpDetailsCo"), 'slds-hide');
    },
    getOtpUponCancel: function(component){
    	var aadhaarField = component.find("aadharNumberCo");
        var aadhaarNumber = aadhaarField.get("v.value");
        var pattern = /^$|^\d{12}$/;
        if(pattern.test(aadhaarNumber)){
            var action = component.get("c.generateAadharOTPforCancel");
            action.setParams({
                "adharNmbr": aadhaarNumber,
                "Product":component.get('v.Product'),
                "HashCode": component.get("v.HashCode"),
                "parentObj" : '',
                "parentId" : component.get("v.parentId")
            });//added for Bug - 15230
        }
         document.getElementById('VaultSuccessCo').style.display = "none";//16111 bug id
	},
    /*Bug 16111 Krish s*/
    cancelDetails: function(component) {
        var action = component.get("c.cancelAadharDetails");
        action.setParams({
            "ekycRec" : component.get("v.kyc"),
        });
        action.setCallback(this, function(response) {
            console.log('inside cancel details');
            document.getElementById('VaultFailureCo').style.display = 'block';
            document.getElementById('VaultSuccessCo').style.display = 'none';
            document.getElementById('myModalCo').style.display = "none";
            document.getElementById('myModalDetailsCo').style.display = "none";
            component.set("v.kyc",null);
            var appEvent = $A.get("e.c:InitiateKYCForm");
            if(appEvent){
                appEvent.setParams({ "kyc" : null});
                appEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    /*Bug 16111 Krish e*/
    
     /*Rohit Vault save start */
     saveEKYC:function(component, event){
         
          document.getElementById('myModalCo').style.display = "none";
        document.getElementById('consentDivCo').style.display = "none";
        document.getElementById('aadharNumberInputDivCo').style.display = "none";
        document.getElementById('aadharNumberInputDiv1Co').style.display = "none";
        var action = component.get("c.generateAadharOTPforMobility");
        console.log('gdeg '+action);
        var pId = component.get("v.parentId");
        if(pId != 'OpenMarket')
            pId = component.get("v.parentId")+'-'+'save';
        else
            pId = ''+'-'+'save';
        
        var kycnew = component.get("v.kyc");
         kycnew.attributes ={
			           type: 'eKYC__c'
		                };
        //alert('hiii '+component.get("v.CoAppAadharNo"));
         /*"adharNmbr" : component.find("aadharNumberCo").get("v.value"),*/
            action.setParams({
               
                "adharNmbr" :component.get("v.CoAppAadharNo"),                   
                "HashCode": component.get("v.HashCode"),
                "parentObj" : 'AppDSS',
                "Product": JSON.stringify([kycnew]),
                "parentId" : pId
            });
            
           
            action.setCallback(this, function(response) {
                
                var result = response.getReturnValue();
                if(result == null || result == 'undefined'){
                    alert('Details not found, Please initiate E-kyc');
                }
                else
                {
                    $A.util.addClass(component.find("otpDetailsCo"), 'slds-hide');
                   
                    //Rohit 16111 hiding consent S
                    var kycnew2 = component.get("v.kyc");
                    document.getElementById('consentDivCo').style.display = 'none';
                    document.getElementById('aadharNumberInputDivCo').style.display = 'none';
                    document.getElementById('aadharNumberInputDiv1Co').style.display = 'none';
                    //document.getElementById('VaultSuccessCo').style.display = "block";
                    //Rohit 16111 hiding consent E
                    var hashCodeEvt = $A.get("e.c:shareAadhaarHashCode");
                    var parsedResp = JSON.parse(response.getReturnValue());
                    console.log('parsedResp.ekycmobility'+parsedResp.ekycmobility);
                     var appEvent = $A.get("e.c:InitiateKYCForm");
                        if(appEvent){
                            appEvent.setParams({ "kyc" : parsedResp.ekycmobility});
                            appEvent.fire();
                        }
                    var fromObj = "APPLICANT";
                    if(component.get("v.parentObj") == 'Contact'){
                        fromObj = 'Contact';
                       
                    }
                    if(hashCodeEvt){
                        console.log('Inside HashCode Event');
                        hashCodeEvt.setParams({ "hashCode" : kycnew2.eKYC_Aadhaar_Number__c , "ekycid" : parsedResp.id, "fromObj" : fromObj});
                        console.log('result.eKYC_Aadhaar_Number__c : '+ parsedResp.id);
                        hashCodeEvt.fire();
                       
                    }
                    // Bug 16111 E - Hemant Keni - Passing hashcode to VF page
                }
            });
            $A.enqueueAction(action);
            console.log('End of SAVEEKYC');
     },
     /*Rohit Vault save end */
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
    }//added for bug id 21851 stop
})