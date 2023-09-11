({
	onInit: function (component, event, helper) {
		var j$ = jQuery.noConflict();
		window.isOpened = false;	
        
        //To hide the component on tab changes! 
		document.addEventListener("visibilitychange", function(){
            helper.fetchDataFromServer(component);
			component.set("v.isOpen", false);
		}, false);

        //To prevent the cut-copy-paste-and-right click event
		j$("#modalContainer").on("contextmenu cut copy paste", function (e) {
			e.preventDefault();
		});							
        
        //initializing object level data:
        helper.fetchDataFromServer(component);
        
	},

	openModel: function (component, event, helper) {
		// for Display Model,set the "isOpen" attribute to "true"
		component.set("v.isOpen", true);
        helper.fetchDataFromServer(component);
	},

	closeModel: function (component, event, helper) {
		// for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
		component.set("v.isOpen", false);
        helper.fetchDataFromServer(component);
	},

	SavenClose: function (component, event, helper) {
		// Display alert message on the click on the "Like and Close" button from Model Footer 
		// and set set the "isOpen" attribute to "False for close the model Box.		
		
        component.set("v.isProcessing" , true);
        
        var allValid = component.find('formId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);

		var utility = component.find("toastCmp");
        
        if (allValid) 
        {
            var errFields = [];
            //Checked for existance of values. Now checking correct values. 
            
            var inputDOB = component.get("v.pdObj.Date_of_Birth__c");
            var oppDOB = component.get("v.opp.Account.Date_of_Birth__c");
            var oppDOI = component.get("v.opp.Account.Year_of_Incorporation__c");
            
            
            var inputDOBArr = inputDOB.split('-');
            
            
            if("Individual" == component.get("v.primaryApplicant.Contact_Name__r.Customer_Type__c") )
            {
                //if new values are not equals to existing values              	
            	var oppDOBArr = oppDOB.split('-');
                
                console.log('INPUT DOB::' + inputDOBArr);
                console.log('Opp DOB::' + oppDOBArr);
                
                //Used NOT deliberately(so that single AND failure will thr back from condition exeuctions)
                if( ! (parseInt(inputDOBArr[0]) == parseInt(oppDOBArr[0])  &&  parseInt(inputDOBArr[1]) == parseInt(oppDOBArr[1])  && parseInt(inputDOBArr[2]) == parseInt(oppDOBArr[2]) ) )
                {                    
                    errFields.push('\nDate of Birth');
            	}
                
            }
            else if("Corporate" == component.get("v.primaryApplicant.Contact_Name__r.Customer_Type__c") )
            {
                //if new values are not equals to existing value
                var oppDOBArr = oppDOI.split('-');
                
                if( ! (inputDOBArr[0] == oppDOBArr[0]  &&  inputDOBArr[1] == oppDOBArr[2]  && inputDOBArr[2] == oppDOBArr[1] ) )
                {
                    errFields.push('\nDate of Birth');
                }
            }
            
            //checking mobile by filtering symbols
            var inputMob = component.get("v.pdObj.Mobile_No__c");
            var oppMob = component.get("v.opp.Account.Mobile__c") + '';
            
            if(inputMob != undefined && inputMob !='' )
            {
                inputMob = inputMob.replace(/[()-]/g,'');
                inputMob = inputMob.replace(' ','');
                
                oppMob = oppMob.replace(/[()-]/g,'');
                oppMob = oppMob.replace(' ','');
                
                if( inputMob != oppMob )
                {
                    errFields.push('\nMobile Number');
                }
            }
            
            var inputEmail = component.get("v.pdObj.Email_Id__c");
            
            if(inputEmail != undefined && inputEmail != '')
            {
                if( component.get("v.pdObj.Email_Id__c") != component.get("v.opp.Account.Accountant_email_id__c") )
                {
                    errFields.push('\nEmail Id');
                }
            }
            if( component.get("v.pdObj.Nominee_Name__c") != component.get("v.opp.Nominee_Name__c") )
            {
                errFields.push('\nNominee Name');
            }
            
            if(component.get("v.pdObj.Customer_Account_Number__c") != component.get("v.opp.A_C_No__c")  )
            {
                errFields.push('\nAccount Number');
            }
            
            if( component.get("v.pdObj.Account_Holder_Name__c") != component.get("v.opp.Account_Holder_Name__c") ) 
            {
               errFields.push('\nAccount Holder Name');
            }
            
            if( component.get("v.pdObj.Account_Type__c") != component.get("v.opp.A_C_Type__c") )
            {
                errFields.push('\nAccount Type');
            }
            
            if( component.get("v.pdObj.IFSC_Code__c ") != component.get("v.opp.IFSC_Code__c") )
            {
                errFields.push('\nIFSC Code');
            }
            
            if(component.get("v.pdObj.MICR_Number__c") != component.get("v.repayObj.MICR_Code__c"))
            {
                errFields.push('\nMICR Number');
            }
            
            if(component.get("v.repayObj.ECS_Barcode_No__c"))                
            {
                if(component.get("v.pdObj.Blind_ECS_Barcode_No__c") != component.get("v.repayObj.ECS_Barcode_No__c") )
                errFields.push('\nECS BarCode Number');
            }
            
            if(errFields.length > 0 ){
                //alert('Please correct following values:' + errFields);
                utility.showToast('Error!', 'Please correct following values:' +errFields, 'error');
                component.set("v.isProcessing" , false);
                return;
            }
            else
            {
                helper.saveData(component);    
            }
            
            
        } 
        else
        {
            //alert('Please update the invalid form entries and try again.');
            utility.showToast('Error!', 'Please update the invalid form entries and try again.', 'error');
            component.set("v.isProcessing" , false);
        }
        
	}
})