({
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
    },//added for bug id 21851 stop
	
	getOTP: function(component,cancelClk) {
        var aadhaarField = component.find("aadharNumber");
        var aadhaarNumber = aadhaarField.get("v.value");
        var pattern = /^$|^\d{12}$/;
         var pObj = component.get("v.parentObj");
        var pId = component.get("v.parentId");
         if(pObj === 'Applicant' && pId === 'OpenMarket'){
            console.log('inside one>>');
			pObj = '';
        	pId = '';
        }
        if(cancelClk )
            pId =component.get("v.parentId")+'-'+ 'cancel';             
       console.log('cancelClk'+cancelClk);
        
        //bug id 19912 start
         var oppId = component.get("v.oppId");
         var flowtype = component.get("v.flowis");
         console.log('flow>>>'+flowtype);
        console.log('oppId>>>'+oppId);
        if((oppId == '' || oppId ==null) && (flowtype != null && flowtype == 'OpenMarketMobility')){
            console.log('inside OpenMarketMobility');
            if(cancelClk && component.get('v.aadharValue') == 'Aadhaar OTP'){
                console.log('inside pid if>>>');
                pId = 'OpenMarketMobility' +'-'+ 'cancel'; ;
            }
            else {
                 console.log('inside pid else>>>');
                 pId = 'OpenMarketMobility' ;
            }
               
            console.log('inside pId>>'+pId);
        }
        
        //bug id 19912 end 
        
        if(pattern.test(aadhaarNumber)){
            var action = component.get("c.generateAadharOTPforMobility");
            // if(pId != 'OpenMarket')
              console.log('inside getotp sm1>>>'+component.get("v.parentId"));
            console.log('inside getotp sm>>>'+component.get('v.Product'));
            action.setParams({
                "adharNmbr": aadhaarNumber,
                "Product":component.get('v.Product'),
                "HashCode": component.get("v.HashCode"),
                "parentObj" : pObj,
                "parentId" : pId
            });//added for Bug - 15230
            
            action.setCallback(this, function(response) {
        		var otpResponse = JSON.parse(response.getReturnValue());
                if(otpResponse.status == 'SUCCESS'){
                    aadhaarField.set("v.disabled", "true");                  
                    component.set("v.HashCode",otpResponse.hashCode);//added for Bug - 15230
                   
                    $A.util.addClass(component.find("generateOTP"), 'slds-hide');
                   
                    //Rohit Ekyc 16111 start
                    if(document.getElementById('checkBoxId') != null)
                    document.getElementById('checkBoxId').style.display = 'none';
                    if(document.getElementById('consentDiv')  != null)
                    document.getElementById('consentDiv').style.display = 'none';
                    if(document.getElementById('IAgree')  != null)
                    document.getElementById('IAgree').style.display = "none";
                    //Rohit added for Bug 20755 start
                    if(document.getElementById('aadharNumberInputDiv') != null){
                    	document.getElementById('aadharNumberInputDiv').style.display = 'none';
                    }    
                    if(document.getElementById('aadharNumberInputDiv1') != null){
                    	document.getElementById('aadharNumberInputDiv1').style.display = 'none';
                    }   
                    //Rohit added for Bug 20755 stop
                     //Added by swapnil start 20818
					 if(document.getElementById('IAgree') != null){
                     	document.getElementById('IAgree').style.display = 'none';
                     }
                     console.log('otpResponse.hashCode'+component.get("v.isPro"));
                     //Added by swapnil 20818 end 
                 
                    console.log('otpResponse.hashCode'+component.get("v.isPro"));
                    
                   
                    if(otpResponse.showEkycDetails && !cancelClk){                  
                    	if(component.get("v.isPro") == true || component.get("v.isMobility") == true)
                    	{
                       		document.getElementById('VaultSuccess').style.display = 'Block';
                           
                    	}
                        var vaultData = new Array();
                        console.log('robin '+otpResponse.ekycFN);
                        vaultData[0] = {"Name":"First Name ","Value": otpResponse.ekycFN};
                        vaultData[1] = {"Name":"Last Name","Value":otpResponse.ekycLN};
                        vaultData[2] = {"Name":"Gender","Value":otpResponse.ekycGender};
                        vaultData[3] = {"Name":"DOB","Value":otpResponse.ekycDob};
                        //added if else for bug id 19959 start
                        if(otpResponse.ekycStreetAddress == '---')
                            vaultData[4] = {"Name":"StreetAddress","Value":''};
                        else
                        vaultData[4] = {"Name":"StreetAddress","Value":otpResponse.ekycStreetAddress};
                        //added if else for bug id 19959 end
                        vaultData[5] = {"Name":"City","Value":otpResponse.ekycCity};
                        vaultData[6] = {"Name":"State","Value":otpResponse.eKYCState};
                        vaultData[7] = {"Name":"ZipCode","Value":otpResponse.eKYCPinCode};
                         //added if else for bug id 19959 start
                        if(otpResponse.ekycMobile == null)
                             vaultData[8] = {"Name":"Phone","Value":''};
                        else
                        vaultData[8] = {"Name":"Phone","Value":otpResponse.ekycMobile};
                        if(otpResponse.ekycEmail == null)
                        	vaultData[9] = {"Name":"Email","Value":''};
                        else
                            vaultData[9] = {"Name":"Email","Value":otpResponse.ekycEmail};
                      //added if else for bug id 19959 start
                    	
                    	var kycnew = component.get("v.kyc");            
                        kycnew.eKYC_First_Name__c = otpResponse.ekycFN;
                        console.log('frist name'+ typeof(otpResponse.ekycFN)+otpResponse.ekycFN);
                        kycnew.eKYC_Aadhaar_Number__c = otpResponse.eKYCAadhaarNumber;
                        kycnew.eKYC_Last_Name__c  = otpResponse.ekycLN;                       
                        kycnew.eKYC_Gender__c  = otpResponse.ekycGender;
                        console.log('hashcode'+otpResponse.eKYCAadhaarNumber);
                        //rohit added if condition 1/25
                        //Rohit commented for Bug 20753 
                       // if(component.get("v.isPro") == false){
                            var moddate = otpResponse.ekycDob;//.replace(new RegExp("-", 'g'), "/");
                           // debugger;
                            moddate = moddate.toString();
                        	var parts =moddate.split('-');
                            console.log('parts after'+otpResponse.eKYCAadhaarNumber);
                            var dobDate1 = new Date(parts[2], parts[1]-1, parts[0]);
                            dobDate1.setMinutes((dobDate1.getMinutes()+1440) + dobDate1.getTimezoneOffset());
                            console.log('dobDate1 after'+dobDate1);
                       		// debugger;
                            kycnew.eKYC_Date_of_Birth__c = Date.parse(dobDate1);
                            console.log('kyc '+component.get("v.isPro"));
                    //    }     
                       
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
                        kycnew.CO__c = otpResponse.ekycCo;//added for bug id 20992
                        console.log('img '+(typeof otpResponse.img));
                        //Bug 16435
                        //kycnew.eKYC_Photo__c  = Base64.encode(otpResponse.img);
                        kycnew.eKYC_Photo__c =  '<!DOCTYPE html><html><body>' +							
                        ' <body><img src=' + 'data:image/jpeg;base64,' +otpResponse.img + '/>' +
              			'</body></html>';
                        kycnew.eKYC_Enquiry_Number__c = otpResponse.ekycEnquiryNumber;
                        kycnew.Error_Code__c = otpResponse.ekycErrorCode;
                        kycnew.Auth_Code__c = otpResponse.ekycAuthCode;
                        kycnew.Source__c = otpResponse.ekycSource;
                        kycnew.Product__c = otpResponse.ekycProduct;
                        console.log('otpresponse');
                        console.log(otpResponse);
                        //debugger;
                        component.set("v.kyc",kycnew);
                        console.log('kycnew');
                        console.log(kycnew);
                        var appEvent = $A.get("e.c:InitiateKYCForm");
                        if(appEvent){
                            appEvent.setParams({ "kyc" : kycnew});
                            appEvent.fire();
                        }
                        component.set("v.CoAppAadharNo",component.find("aadharNumber").get("v.value"));
                        component.set("v.vaultData",vaultData);
                        console.log('pktest');
                        console.log(component.get("v.kyc"));
                        if(document.getElementById('myModal')!= null){
        				  	document.getElementById('myModal').style.display = "block";
                        }
                       //Rohit added for 19712
                       component.set("v.isOpen", true);
                    	                     
                       console.log('rohit '+vaultData);
                       console.log(component.get("v.isDSS"));
                       $A.util.addClass(component.find("otpDetails"), 'slds-hide');
                       
                    }                 
                    else
                    {
                        component.set("v.kyc",null);
                        var appEvent = $A.get("e.c:InitiateKYCForm");
                        if(appEvent){
                            appEvent.setParams({ "kyc" : null});
                            appEvent.fire();
                        }
                         if(document.getElementById('myModal')!= null)	
                        	document.getElementById('myModal').style.display = "none";
                        
                        //Rohit added for 19712
                        component.set("v.isOpen", false);
                        $A.util.removeClass(component.find("otpDetails"), 'slds-hide'); 
                        $A.util.addClass(component.find("otpDetails"), 'slds-show');
                    }
        			//Rohit Ekyc 16111 stop
                    
        		} else if(component.get("v.isDSS") == false && component.get("v.isPro") == false)
                {
                        $A.util.removeClass(component.find("otpDetails"), 'slds-hide'); 
                        $A.util.addClass(component.find("otpDetails"), 'slds-show');
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
    submitOTP_helper: function(component) {
        var otpField = component.find("otp");
        otpField.set("v.errors", [{message:""}]);
        console.log('inside submitOTP 11'+component.get("v.parentObj"));
       
        var action = component.get("c.getKYCDetails");
        var pObj = component.get("v.parentObj");
        
        action.setParams({
            "aadharCardNumber" : component.find("aadharNumber").get("v.value"),
            "otpCode" : otpField.get("v.value"),
            "HashCode": component.get("v.HashCode"),
            "parentObj" : pObj,
            "parentId" : component.get("v.parentId")
        });// Bug 16111
       
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            console.log('robin ');
            if(result == null || result == 'undefined'){
                otpField.set("v.errors", [{message:"Validation Failed. Kindly regenerate OTP"}]);
            } else {
                $A.util.addClass(component.find("otpDetails"), 'slds-hide');
                var appEvent = $A.get("e.c:InitiateKYCForm");
                // Bug 16111 S - Hemant Keni - Passing hashcode to VF page
                if(appEvent){
                    appEvent.setParams({ "kyc" : result });
                    appEvent.fire();
                }
                //Rohit 16111 hiding consent S
                document.getElementById('consentDiv').style.display = 'none';
                document.getElementById('VaultSuccess').style.display = "block";
                
                document.getElementById('otpSubmit').style.display = "block";
                document.getElementById('aadharNumberInputDiv1').style.display = "none";
                document.getElementById('aadharNumberInputDiv').style.display = "none";
               
                //Added by swapnil hiding I agree on successfl OTP submition bug id: 20818 
                if(document.getElementById('IAgree') != null){
                document.getElementById('IAgree').style.display = "none";
                }
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
                    component.set("v.isMobilityOpen", true);
                }
                console.log('component.find("otpDetails")'+component.find("otpDetails"));
                $A.util.removeClass(component.find("otpDetails"), 'slds-show');
                $A.util.addClass(component.find("otpDetails"), 'slds-hide');
                document.getElementById('aadharNumberInputDiv').style.display = "none";//added for bug id 16111
       			document.getElementById('aadharNumberInputDiv1').style.display = "none";//added for bug id 16111
            }
            //$A.util.addClass(component.find("waiting"), 'slds-hide');
        });
        $A.enqueueAction(action);
	},
    disableForm: function(component){
        if( component.get("v.hideAadhaarSection") == false){//added if for bug id 21851
        	component.find("aadharNumber").set("v.disabled", true);
        	component.find("generateOTP").set("v.disabled", true);
        	$A.util.addClass(component.find("otpDetails"), 'slds-hide');
        }
    },
    getOtpUponCancel: function(component){
    	var aadhaarField = component.find("aadharNumber");
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
         document.getElementById('VaultSuccess').style.display = "none";//16111 bug id
	},
    /*Bug 16111 Krish s*/
    cancelDetails: function(component) {
        var action = component.get("c.cancelAadharDetails");
        action.setParams({
            "ekycRec" : component.get("v.kyc"),
        });
        action.setCallback(this, function(response) {
            console.log('inside cancel details');
            document.getElementById('VaultFailure').style.display = 'block';
            document.getElementById('VaultSuccess').style.display = 'none';
            //Rohit added for Bug 19712 Start
            /*document.getElementById('myModal').style.display = "none";
            document.getElementById('myModalDetails').style.display = "none";*/
            //Rohit added for Bug 19712 Stop
            component.set("v.isMobilityOpen", false);
            component.set("v.isOpen", false);
            //Rohit added for 19712
            component.set("v.isOpen", false);
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
        
        //document.getElementById('myModal').style.display = "none";
        //document.getElementById('consentDiv').style.display = "none";
        if(document.getElementById('aadharNumberInputDiv') != null)
        document.getElementById('aadharNumberInputDiv').style.display = "none";//added for bug id 16111
        if(document.getElementById('aadharNumberInputDiv1') != null)
        document.getElementById('aadharNumberInputDiv1').style.display = "none";//added for bug id 16111
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
                    $A.util.addClass(component.find("otpDetails"), 'slds-hide');
                   
                    //Rohit 16111 hiding consent S
                    var kycnew2 = component.get("v.kyc");
                    if(document.getElementById('consentDiv') != null)
                    	document.getElementById('consentDiv').style.display = 'none';
                    if(document.getElementById('VaultSuccess') != null)
                    document.getElementById('VaultSuccess').style.display = "none";//16111;
                    if(component.get("v.isPro") == true || component.get("v.isMobility") == true)
                    {
                        if(document.getElementById('VaultSuccess') != null)
                       	document.getElementById('VaultSuccess').style.display = 'Block';                       
                    }
                    //Rohit 16111 hiding consent E
                    var hashCodeEvt = $A.get("e.c:shareAadhaarHashCode");
                    var parsedResp = JSON.parse(response.getReturnValue());
                    console.log('parsedResp.ekycmobility'+parsedResp.ekycmobility);
                    component.set("v.isOpen", false);
                    var appEvent = $A.get("e.c:InitiateKYCForm");
                        if(appEvent){
                            appEvent.setParams({ "kyc" : parsedResp.ekycmobility});
                            appEvent.fire();
                        }
                    if(hashCodeEvt){
                        console.log('Inside HashCode Event');
                        hashCodeEvt.setParams({ "hashCode" : kycnew2.eKYC_Aadhaar_Number__c , "ekycid" : parsedResp.id, "fromObj" : "APPLICANT"});
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
    /*Bug 18669 Start*/
     getEncryptedAadhar : function(component,aadhaarNumber){
         console.log('Aadhar inside execute method : '+aadhaarNumber);
        this.executeApex(component, "getEncAadharNum", {aadharNum: aadhaarNumber}, function(error, result){
            console.log('inside execute apex');
            if(!error && result){
                var data = result;
                console.log('data'+JSON.stringify(data));
                console.log('inside biometric field condition');
				component.set("v.encAadhar",data);
                console.log('inside biometric after :'+component.get("v.encAadhar"));
                var random = component.get("v.randomNum");
                var appBioId='';
                if(component.get("v.parentId") != '' ){
                    if(component.get("v.parentId") == 'OpenMarket')//added for DSS changes for bug id 18669
                        appBioId = '';
                	else
                        appBioId = component.get("v.parentId");
                }
                var adhrNum = component.get("v.encAadhar");
                console.log('adhrNum : :'+adhrNum);
                console.log('appBioId : '+appBioId);
                console.log('random : '+random);
                //component.set("v.isBioEkycModalOpen", true);
                console.log('Community User : '+component.get("v.isCommunityUsr"));
				
               //Code added by swapnil 20822 start
                if(component.get("v.isPro") == true)
                { 
                       component.set('v.flowis','mobilityPro');      
                 }
                //Added by swapnil bug id : 20822 end
               
                    var flowis = component.get("v.flowis");//added flow for bug id 19912
                	window.open('http://bflloans.force.com/EkycBiometricPage?randomNum=' + random +'&applicantId='+ appBioId +'&flow='+ flowis +'&fromObject=Applicant&aadharNumber='+ adhrNum,'_blank');//added flow for bug id 19912
                //window.open('https://partial-bflloans.cs72.force.com/EkycBiometricPage?randomNum=' + random +'&applicantId='+ appBioId +'&fromObject=Applicant&aadharNumber='+ adhrNum,'_blank'); //commented for bug id 19912
				
            }
        });
    },
    
     //start- Added the consent to Static Resource Bug-19368 by Nihit
    getAadharConsent:function(component)
    {

        var action = component.get("c.getConsent2");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {

               component.set('v.aadharConsent',response.getReturnValue());
                
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
    },//stop- Added the consent to Static Resource Bug-19368 by Nihit
    // end Bug-19368
    //added for bug id 18669 for proMobility start
    copyAadhaarDetails : function (component) {
        console.log('inside copy aadhar address helper>>>'+component.get("v.randomNum"));
        var randomNum = component.get("v.randomNum");
		var action = component.get("c.getEkycRecord");
            action.setParams({
                "ranNum": randomNum
            });
            
            action.setCallback(this, function(response) {
				var aadhaarResponse = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log('aadhaarResponse is>>>'+aadhaarResponse);
                //console.log('aadhaarResponse is>>>'+aadhaarResponse.id);
                if(aadhaarResponse == null || aadhaarResponse == 'undefined'|| aadhaarResponse == undefined){
                    console.log('entered in if');
                    console.log('aadhar record not found');
                    //test start
                     if(document.getElementById('customToast') != null)
                    	document.getElementById('customToast').style.display = 'block';
                    //test stop
                   // alert('Details not found, Please initiate E-kyc');
                }else{ 
                     if(document.getElementById('customToast') != null)
                    	document.getElementById('customToast').style.display = 'none';
                    var kycnew = component.get("v.kyc");       
                    kycnew.eKYC_First_Name__c = aadhaarResponse.eKYC_First_Name__c;
                    kycnew.eKYC_Aadhaar_Number__c = aadhaarResponse.eKYC_Aadhaar_Number__c;
                    kycnew.eKYC_Last_Name__c  = aadhaarResponse.eKYC_Last_Name__c;                       
                    kycnew.eKYC_Gender__c  = aadhaarResponse.eKYC_Gender__c;
                    kycnew.eKYC_Address_details__c = aadhaarResponse.eKYC_Address_details__c;
                    kycnew.eKYC_City__c = aadhaarResponse.eKYC_City__c;
                    kycnew.eKYC_State__c = aadhaarResponse.eKYC_State__c;
                    kycnew.eKYC_Pin_Code__c = parseInt(aadhaarResponse.eKYC_Pin_Code__c);
                    kycnew.eKYC_Mobile_Number__c = parseInt(aadhaarResponse.eKYC_Mobile_Number__c);
                    kycnew.Transaction_Id__c = aadhaarResponse.Transaction_Id__c ;
                    kycnew.eKYC_District__c = aadhaarResponse.eKYC_District__c; 
                    kycnew.eKYC_processing__c = aadhaarResponse.eKYC_processing__c;
                    kycnew.Device_Id__c = aadhaarResponse.Device_Id__c;
                    kycnew.Device_Type__c = aadhaarResponse.Device_Type__c;
                    kycnew.Service_Code__c = aadhaarResponse.Service_Code__c;
                    kycnew.Sub_Service_Code__c = aadhaarResponse.Sub_Service_Code__c;
                    kycnew.Country__c = aadhaarResponse.Country__c; 
                    kycnew.Location__c = aadhaarResponse.Location__c;  
                    kycnew.Sub_District__c = aadhaarResponse.Sub_District__c;
                    kycnew.eKYC_Response__c = aadhaarResponse.eKYC_Response__c; 
                    kycnew.eKYC_Photo__c =  '<!DOCTYPE html><html><body>' +							
                        ' <body><img src=' + 'data:image/jpeg;base64,' +aadhaarResponse.eKYC_Photo__c + '/>' +
                        '</body></html>';
                    kycnew.eKYC_Enquiry_Number__c = aadhaarResponse.eKYC_Enquiry_Number__c;
                    kycnew.Error_Code__c = aadhaarResponse.Error_Code__c;
                    kycnew.Auth_Code__c = aadhaarResponse.Auth_Code__c;
                    kycnew.Source__c = aadhaarResponse.Source__c;
                    kycnew.Product__c = aadhaarResponse.Product__c;
                    kycnew.CO__c = aadhaarResponse.ekycCo;//added for bug id 20992
                    // harshal start
                    kycnew.bio_Ekyc__c = aadhaarResponse.bio_Ekyc__c;
                    kycnew.Random_Number__c = aadhaarResponse.Random_Number__c;
                    kycnew.Id = aadhaarResponse.Id;
                    // harshal End
                    
                    console.log('aadhaarResponse');
                    console.log(aadhaarResponse);
                    console.log('aadhaarResponse'+aadhaarResponse);
                    component.set("v.kyc",kycnew);
                    console.log('kycnew');
                    console.log(kycnew);
                    var appEvent = $A.get("e.c:InitiateKYCForm");
                    if(appEvent){
                        appEvent.setParams({ "kyc" : kycnew});
                        appEvent.fire();
                    }
                    $A.util.addClass(component.find("generateOTP"), 'slds-hide');
                    $A.util.addClass(component.find("copyAadhaarDetails"), 'slds-hide');
                    $A.util.addClass(component.find("IagreeChk"), 'slds-hide');
                   // component.find("copyAadhaarDetails").set("v.disabled", true);
                    document.getElementById('consentDiv').style.display = 'none';
                    document.getElementById('aadharNumberInputDiv').style.display = "none";
                    //if(component.get("v.isPro") == true)
                    {
                        document.getElementById('VaultSuccess').style.display = 'Block';
                    }
                    //added for bug 1d 18669 DSS start
                   /* console.log('aadhaarResponse.id :before '+ aadhaarResponse.id);
                            console.log('aadhaarResponse.eKYC_Last_Name__c :before '+ aadhaarResponse.eKYC_Last_Name__c);
					if(component.get("v.isDSS") == true){
						var hashCodeEvt = $A.get("e.c:shareAadhaarHashCode");
					   // var parsedResp = JSON.parse(response.getReturnValue());
						//console.log('aadhaarResponse.ekycmobility'+parsedResp.ekycmobility);
						//component.set("v.isOpen", false);
						/*var appEvent = $A.get("e.c:InitiateKYCForm");
							if(appEvent){
								appEvent.setParams({ "kyc" : parsedResp.ekycmobility});
								appEvent.fire();
							}*/
						/*if(hashCodeEvt){
							console.log('Inside HashCode Event');
							hashCodeEvt.setParams({ "hashCode" : aadhaarResponse.eKYC_Aadhaar_Number__c , "ekycid" : aadhaarResponse.Id, "fromObj" : "APPLICANT"});
							console.log('aadhaarResponse.id : '+ aadhaarResponse.Id);
							hashCodeEvt.fire();
						}
					}*/
					//added for bug id 18669 DSS end
                }
			});
            $A.enqueueAction(action);
	}
 //added for bug id 18669 for proMobility end
})