({
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
                //this.displayMessage(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getWalletData : function(component) {
        var walletId = component.get("v.wallletId");
        
        this.executeApex(component, "getwalletData", {
            walletId: walletId
        }, function(error, result){
            if(!error && result){
                var insWallet = result;
                //var dedupeRec = insWallet[0].De_Dupes__r;
                //component.set('v.Dedupe', dedupeRec);
                component.set('v.InsWalletRec', insWallet);
                console.log('insWallet :::'+ JSON.stringify(insWallet));
				if(typeof insWallet[0].CUSTOMER__c != 'undefined' && insWallet[0].CUSTOMER__c != null){
					component.set("v.disableCustButton", true);
					
				}
            }
        });

    },
    
    getDedupeData: function(component){
        
        this.executeApex(component, "getDeupeRecords", {}, function(error, result){
            if(!error && result){
                component.set('v.Dedupe', result);
                console.log('result getdeupe::::' + JSON.stringify(result));
            }
        });
        
    }, 
    reInitDedupe: function(component){
        
        component.set("v.waitingFlag",true);
        var walletId = component.get("v.wallletId");
        //var action = component.get('c.reinitDedupe');
        
        this.executeApex(component, "reinitDedupe", {
            walletId: walletId
        }, function(error, result){
            if(!error && result){
                console.log('result' + JSON.stringify(result));
                if(result != '') {
                    component.set('v.Dedupe', result);
                    component.set("v.waitingFlag",false);
                }
                else
                    this.displayMessage(component,'Failure','Family record (Self) for the customer does not exists!!',"error", 5000, true); 
               
            }
        });
       //this.getDedupeData(component);
       //this.getWalletData(component);
    },
    
    createDedupeCustHelper: function(component){
    	component.set("v.waitingFlag",true);
		var matchedDedupe = component.get('v.matchedDedupe');
        var walletId = component.get("v.wallletId");
        
		//If customer already exists
		var insWallet = component.get("v.InsWalletRec");
		if(typeof insWallet != 'undefined' && insWallet != null){
			if(typeof insWallet[0].CUSTOMER__c != 'undefined' && insWallet[0].CUSTOMER__c != null){
				this.displayMessage(component,'Failure','Customer already exists !!',"error", 5000, true);
				return;
			}
		}
        this.executeApex(component, "createDedCust", {
            jsonMatchDed : JSON.stringify(matchedDedupe),
            walletId: walletId
        }, function(error, result){
            if(!error && result){
               
                this.displayMessage(component,'Success','Customer Created Successfully !!',"success", 5000, true);   
                component.find("idProceedBtn").set("v.disabled", true);            }
            else {
                component.set("v.waitingFlag",false);
                component.find("idProceedBtn").set("v.disabled", false);
            }
        });
           
	},
    
    getmatchDedupe: function(component){
        var dedupeId = component.get('v.selectedRecId');
        
        //If customer already exists
		var insWallet = component.get("v.InsWalletRec");
        if(typeof insWallet != 'undefined' && insWallet != null){
			if(typeof insWallet[0].CUSTOMER__c != 'undefined' && insWallet[0].CUSTOMER__c != null){
				this.displayMessage(component,'Failure','Customer already exists !!',"error", 5000, true);
				component.find("idProceedBtn").set("v.disabled", true);	
				return;
			}
		}
        this.executeApex(component, "getMatchDedupe", {
            dedupeId: dedupeId
        }, function(error, result){
            if(!error && result){
                
                if(typeof result[0].Customer_ID__c != 'undefined'){
                    component.set('v.matchedDedupe', result);
                    console.log('helper matched dedupe :::' + JSON.stringify(component.get('v.matchedDedupe')));
                }
                else {
                    this.displayMessage(component,'Failure','Can not create Customer. Customer ID not present !!',"error", 5000, true);
                     component.find("idProceedBtn").set("v.disabled", true);
                }
                
                component.set("v.waitingFlag",false);
                
            }
        });
         
    },
    
    getSOLData: function(component, event, helper){
        var walletId = component.get("v.wallletId");
        
        this.executeApex(component, "getSolData", {
            walletId: walletId
        }, function(error, result){
            if(!error && result){
                
                if(result != ''){
                	component.set('v.SOLRecord', result);
                	console.log('SOLRecord :::' + JSON.stringify(component.get("v.SOLRecord")));
    			}
                else
                    this.displayMessage(component,'Failure','No record found for Sales officer !!',"error", 5000, true); 
            }
        });
        
    },
    
	createCustCallout: function(component, event, helper){
        component.set("v.waitingFlag",true);
        
        var insWallet = component.get("v.InsWalletRec");
        component.set("v.disableCustButton", true);
        if(typeof insWallet != 'undefined' && insWallet != null){
            var InsWalletName = insWallet[0].Name;
            if(typeof insWallet[0].Family_Details_S_To_S__r != 'undefined' && insWallet[0].Family_Details_S_To_S__r != null)
                var familyRecArr = insWallet[0].Family_Details_S_To_S__r;
        }	 
        
        var SolRecord = component.get("v.SOLRecord");
        
        var monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN","JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        
        var customerRec = {};
        
        customerRec.pfinnCustid = "";
        customerRec.psourceSystem = 'DIRECT';
        
        customerRec.pconstid = 1;
        customerRec.pindustryid = 1;
        customerRec.pcategoryid = "";
        customerRec.pspousename = "";
        customerRec.pindvCorpFlag = 'I';
        
        customerRec.pincomeSource = "";
        customerRec.pyearsCurrJob = "";
        customerRec.pcorDoi = "";
        customerRec.pmakerid = 'CASUSRA';
        customerRec.pmakerdate = ((new Date()).getDate()) + '-' + monthNames[(new Date()).getMonth()] + '-' +  (new Date()).getFullYear();
        
        customerRec.pauthid = 'CASUSRA';
        customerRec.pauthdate = ((new Date()).getDate()) + '-' + monthNames[(new Date()).getMonth()] + '-' +  (new Date()).getFullYear();
        
        
        customerRec.paccotype = "";
        customerRec.paccocatg = "";
        customerRec.pdatelastupdt = "";
        customerRec.pnationalid = 'NA';
        customerRec.ppassportno = '';
        customerRec.pnationality = 'INDIA';
        
        customerRec.pregionid = 1;
        customerRec.getpBankType = 'R';
        customerRec.pentityflag = '';
        customerRec.pcontactPerson = 'NOT AVAILABL';
        
        customerRec.peconomicSecId = 1;
        customerRec.pfraudFlag = "";
        customerRec.pfraudScore = "";
        customerRec.pemiCardElig = '';
        customerRec.pbankDtl = '';
        customerRec.pnName = '';
        customerRec.pnAddress = '';
        customerRec.pnRelation = '';
        customerRec.pnField9 = '';
        customerRec.pnField10 = '';
        customerRec.pinsUpdFlag = 'I';
        
        if(typeof SolRecord[0] != 'undefined' && typeof SolRecord[0].Branch__r != 'undefined' && SolRecord[0].Branch__r != null && typeof SolRecord[0].Branch__r.Branch_Code__c != 'undefined' && SolRecord[0].Branch__r.Branch_Code__c != null )
            customerRec.pbranchid = SolRecord[0].Branch__r.Branch_Code__c;
        else 
            customerRec.pbranchid = 320;
        
        customerRec.psfdcCustomerid = Number(InsWalletName.slice(4));
        
        if(typeof familyRecArr != 'undefined' && familyRecArr != null){
            for(var i=0; i< familyRecArr.length; i++){
                if(familyRecArr[i].Family_Relation__c == 'Self'){
                    var selfRecord = familyRecArr[i];
                }
            }
        }
        
        if(typeof selfRecord != 'undefined' && selfRecord != null) {
            
            customerRec.pfname = selfRecord.First_Name__c;
            customerRec.pmname = selfRecord.Middle_Name__c;
            customerRec.plname = selfRecord.Last_Name__c;
            
            var DOB = new Date(selfRecord.Date_of_Birth__c);
            customerRec.pdob = (DOB).getDate() + '-' + monthNames[(DOB).getMonth()] + '-' +  (DOB).getFullYear();
            
            customerRec.pcustsearchid = String(selfRecord.Mobile__c);
            
            customerRec.pcustomername = selfRecord.First_Name__c + ' ' + selfRecord.Middle_Name__c + ' ' + selfRecord.Last_Name__c;
            
            if(selfRecord.Gender__c == 'Male')
                customerRec.psex = 'M';
            else if(selfRecord.Gender__c == 'Female')
                customerRec.psex = 'F';
            customerRec.ppanNo = selfRecord.PAN__c;
            
            //console.log('selfRecord :::' + JSON.stringify(selfRecord));
            
            /*if(selfRecord.Preferred_Communication_Address__c == 'Permanent' ){
                customerRec.paddressDtl = 'CURRES~' + selfRecord.City__c + '~' + 'INDIA~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c + '~' + selfRecord.Office_Telephone__c + '~' + 'Y~' + selfRecord.DoorNo__c + '~' + selfRecord.BuildingName__c + '~' + selfRecord.LandmarkArea__c + '~'+ selfRecord.Place__c + '~' +selfRecord.Email__c + ';' + 'OFFICE~'+ selfRecord.City__c + '~' + 'INDIA~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + 'N~' + selfRecord.PresentDoorNo__c + '~' + selfRecord.PresentBuildingName__c + '~' + selfRecord.PresentPlace__c + '~' +selfRecord.PresentLandmarkArea__c + '~'+ selfRecord.Email__c + ';';
                
            }
            else{
                customerRec.paddressDtl = 'CURRES~' + selfRecord.City__c + '~' + 'INDIA~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + selfRecord.Office_Telephone__c + '~' + 'N~' + selfRecord.DoorNo__c + '~' + selfRecord.BuildingName__c + '~' + selfRecord.LandmarkArea__c + '~'+ selfRecord.Place__c + '~' +selfRecord.Email__c + ';' + 'OFFICE~'+ selfRecord.City__c + '~' + 'INDIA~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + 'Y~' + selfRecord.PresentDoorNo__c + '~' + selfRecord.PresentBuildingName__c + '~' + selfRecord.PresentPlace__c + '~' + selfRecord.PresentLandmarkArea__c + '~'+ selfRecord.Email__c + ';';
            }*/
            
            if(selfRecord.Preferred_Communication_Address__c == 'Permanent' ){
                //customerRec.paddressDtl = 'CURRES~' + ' ' + '~' + 'INDIA~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c + '~' + selfRecord.Office_Telephone__c + '~' + 'Y~' + selfRecord.DoorNo__c + '~' + selfRecord.BuildingName__c + '~' + selfRecord.LandmarkArea__c + '~'+ selfRecord.Place__c + '~' +selfRecord.Email__c + ';' + 'OFFICE~'+ ' ' + '~' + 'INDIA~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + 'N~' + selfRecord.PresentDoorNo__c + '~' + selfRecord.PresentBuildingName__c + '~' + selfRecord.PresentPlace__c + '~' +selfRecord.PresentLandmarkArea__c + '~'+ selfRecord.Email__c + ';';
                customerRec.paddressDtl = 'CURRES~'  + '~' + 'INDIA~'+ '~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c + '~' + selfRecord.Office_Telephone__c + '~' + 'Y~' + selfRecord.DoorNo__c + '~' + selfRecord.BuildingName__c + '~' + selfRecord.LandmarkArea__c + '~'+ selfRecord.Place__c + '~' + '011~E~' + selfRecord.Email__c + ';' + 'MAL~' + '~' + 'INDIA~~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + selfRecord.Office_Telephone__c + '~' + 'N~' + selfRecord.PresentDoorNo__c + '~' + selfRecord.PresentBuildingName__c + '~' + selfRecord.PresentPlace__c + '~' +selfRecord.PresentLandmarkArea__c + '~'+ '020~E~'+ selfRecord.Email__c + ';';
            }
            else{
                //customerRec.paddressDtl = 'CURRES~' + ' ' + '~' + 'INDIA~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + selfRecord.Office_Telephone__c + '~' + 'N~' + selfRecord.DoorNo__c + '~' + selfRecord.BuildingName__c + '~' + selfRecord.LandmarkArea__c + '~'+ selfRecord.Place__c + '~' +selfRecord.Email__c + ';' + 'OFFICE~'+ ' ' + '~' + 'INDIA~'+ selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + 'Y~' + selfRecord.PresentDoorNo__c + '~' + selfRecord.PresentBuildingName__c + '~' + selfRecord.PresentPlace__c + '~' + selfRecord.PresentLandmarkArea__c + '~'+ selfRecord.Email__c + ';';
                customerRec.paddressDtl = 'CURRES~' + '~' + 'INDIA~'+ '~' + selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + selfRecord.Office_Telephone__c + '~' + 'N~' + selfRecord.DoorNo__c + '~' + selfRecord.BuildingName__c + '~' + selfRecord.LandmarkArea__c + '~'+ selfRecord.Place__c + '~' + '011~E~' + selfRecord.Email__c + ';' + 'MAL~'+ '~' + 'INDIA~~' + selfRecord.Pincode__c + '~' + selfRecord.Mobile__c +'~' + selfRecord.Office_Telephone__c + '~' + 'Y~' + selfRecord.PresentDoorNo__c + '~' + selfRecord.PresentBuildingName__c + '~' + selfRecord.PresentPlace__c + '~' + selfRecord.PresentLandmarkArea__c + '~'+ '020~E~'+ selfRecord.Email__c + ';';
            }
            
            //customerRec.paddressDtl = 'CURRES~1948~INDIA~5~411006~999999999~01165765571~Y~E-81~RAM BAGH COLONY~SECTOR 45~FARIDABAD~011~E~VATS@gmail.com;MAL~1948~INDIA~5~411006~7788994455~01161468571~N~A-56~SRI SAI NIVAS COLONY~SECTOR 49~PUNE~020~E~abc@gmail.com;';
                    
        }
        
        console.log('customerRec :::' +JSON.stringify(customerRec));
        
        this.executeApex(component, "getCalloutResponse", {
            customerJson: JSON.stringify(customerRec)
        }, function(error, result){
            if(!error && result){
                var response = result;
                console.log('reponse ::::' + JSON.stringify(response));
                //var response = JSON.parse('[  \r\n   {  \r\n      \"errorCode\":\"00\",\r\n      \"errorDescription\":\"SUCCESS\",\r\n      \"pfinnCustId\":\"83398677\",\r\n      \"psuccessReject\":\"S\",\r\n      \"prejectionReason\":\"Customer created in FinnOne.  CustomerID 83398677\"\r\n   }\r\n]');
                this.processResponse(response, component);
            }
            else{
                component.set("v.disableCustButton", true);
            }
            
        });
        
        
        //}
        //}
        
    },
    
    processResponse : function(response, component){
        //Code for testing purpose
        /*console.log('response:::' + JSON.stringify(response));
        console.log('customerID :::' + response[0].pfinnCustId);
        component.set("v.FinnOneCustID", response[0].pfinnCustId);
        this.createFinnOneCust(response, component);
        */
        
        if(typeof response != 'undefined' && response != null ){
           
            if(response.psuccessReject == 'R'){
                this.displayMessage(component,'Failure',response.errorDescription,"error", 5000, true);  
            }
            else if(response.psuccessReject == 'S'){
                
                this.displayMessage(component,'Success',response.prejectionReason,"success", 5000, true); 
                
                component.set("v.FinnOneCustID", response.pfinnCustId);
                this.createFinnOneCust(response, component);
            }
                
        }
        
    },
    
    createFinnOneCust: function(response,component){
        
        var customerID = component.get('v.FinnOneCustID');
        console.log('customerID :::' + customerID);
        var walletId = component.get("v.wallletId");
        
        this.executeApex(component, "createFinnOneCust", {
            customerName : customerID,
            walletId : walletId
        }, function(error, result){
            if(!error && result){
                var response = result;
                if(typeof response != 'undefined' && response != null){
                    component.set("v.waitingFlag",false);
                    console.log('Customer Created Successfully :::' + JSON.stringify(response));
                    this.getDedupeData(component);
                    this.getWalletData(component);
                    
                    //this.displayMessage(component,'Success','Customer Created Successfully in SFDC!!',"success", 5000, true);   
            	}
            }
 			else{
 				 component.set("v.waitingFlag",false);
                
 			}
        });
        
    },
    
    displayMessage : function(component, title, message, type, fadeTimeout, isAutoClose) {
        console.debug('Inside EDGE');
        component.set("v.waitingFlag",false);
    	$A.createComponent(
            "c:ToastMessage",
            {
                "title": title,
                "message": message,
                "type": type,
                "fadeTimeout": fadeTimeout,
                "isAutoClose" : isAutoClose
            },
            function(newComp) {
                var body = [];
                body.push(newComp);
                component.set("v.body", body);
                console.debug('--------------------------'+JSON.stringify(body));

            }
        );    
    },
   
})