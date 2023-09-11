({
    fetchBankAccountPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getSelectPicklistOPtions");
        action.setParams({
            "objObject": component.get("v.bankAccount"),
            "fld": fieldName
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log('allValues+'+allValues);
                component.set("v.bankAccountList", allValues);
            }
        });
        $A.enqueueAction(action);
    },

    redirectToPerfiosRecord: function(component, event) {
        var bankAccount = component.get("v.bankAccount");
        var theme = component.get("v.theme");
       // alert(bankAccount);
        if(theme =='Theme3' || theme =='Theme2'){
            if(component.get('v.iscommunityUser'))
                window.open('/Partner/' + bankAccount.Id);
            else
                window.open('/' + bankAccount.Id);
        }else if(theme == 'Theme4d')
            window.open('/lightning/r/Opportunity/' + bankAccount.Id + '/view');
         else if(theme == 'Theme4t')
            this.navigateToPerfiosSF1(component, event, bankAccount.Id);
    },
	
    navigateToPerfiosSF1 : function(component, event, bankAccountId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": bankAccountId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    
    closeToastnew: function (component) {
		document.getElementById('perfiosSuccessMsg').innerHTML = "";
		document.getElementById('perfiosSuccess').style.display = "none";
	},
	closeToastError: function (component) {
		document.getElementById('perfiosErrorMsg').innerHTML = "";
		document.getElementById('perfiosError').style.display = "none";
	},
    closeToastInfo: function (component) {
		document.getElementById('perfiosInfoMsg').innerHTML = "";
		document.getElementById('perfiosInfo').style.display = "none";
	},
	/*displayMessage: function (component, toastid, messageid, message) {

		document.getElementById(messageid).innerHTML = message;
		document.getElementById(toastid).style.display = "block";
		setTimeout(function () {
			document.getElementById(messageid).innerHTML = "";
			document.getElementById(toastid).style.display = "none";
		}, 3000);
	},*/
     displayMessage: function (component, toastid, messageid, message) {
        document.getElementById(toastid).style.display = "block";
        if(component.get('v.theme') == 'Theme4d'){
        var toastClasses = document.getElementById("perfiosErr").classList;
             toastClasses.add("lightningtoast");
        document.getElementById("perfiosSucc").classList.add("lightningtoast");  
         }
        document.getElementById(messageid).innerHTML = message;
        console.log('message'+message +component.get('v.theme'));
        
        setTimeout(function () {
            document.getElementById(messageid).innerHTML = "";
            document.getElementById(toastid).style.display = "none";
        }, 3000);
     },
    uploadPerfiosButton: function (component) {
        var bankAccountId = component.get('v.bankAccount.Id'); 
        console.log('Hello Aman1'+component.get('v.bankAccount'));
        console.log('Hello Aman2'+bankAccountId);
        if(bankAccountId == undefined || bankAccountId == '')
            this.displayMessage(component, 'perfiosInfo', 'perfiosInfoMsg', 'Info! Please Initiate Perfios.');
        
        else
            window.open('http://bflloans.force.com/perfios?id='+bankAccountId+'&destination=statement','_blank');
    },
    showSpinner: function (component) {
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function (component) {
        this.showHideDiv(component, "waiting", false);
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    
})