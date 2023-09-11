({
    // 16270 s
    doInit: function(component) {
        var profile = component.get ("v.profileName");
        console.log ('obligEditProfCheck logged in user profile='+profile);
        var flaggedProfiles = ['Area Sales Manager','Regional Sales Manager'
                               ,'Zonal Sales Manager','National Sales Manager','Partner Pro PSF for SALPL'];
        if (flaggedProfiles.indexOf(profile)!= -1)
            component.set ("v.obligEditProfCheck",true);
        else
            component.set ("v.obligEditProfCheck",false);
        
        console.log ('obligEditProfCheck='+component.get("v.obligEditProfCheck"));
    },
    // 16270 e
    
    
    saveDetails : function(component, event, helper) {
        
        helper.showhidespinner(component,event,true);
        var isValid = helper.validateDetails(component, event);
        if (isValid == 0){
            helper.saveObligations(component, event);
        }
        else if (isValid == 1 ){
            
            helper.showhidespinner(component,event,false);
            helper.displayToastMessage(component,event,'Error','Please enter mandatory fields','error');
        }
        else if(isValid == 2){
            helper.showhidespinner(component,event,false);
            helper.displayToastMessage(component,event,'Error','Please enter correct Loan Amount/Current balance','error');
        }
        else {
            helper.showhidespinner(component,event,false);
            helper.displayToastMessage(component,event,'Error','Start date should not be a future date','error');
        }
    },
    mobCalc : function(component, event, helper) {
        console.log(event.currentTarget.id);
        
    },
    
    addRec : function(component, event, helper) {
        var exObj = new Object();
        exObj.Loan_Application__c = component.get("v.oppId"); 
        exObj.Obligation__c = 'Yes';
        exObj.Type_of_Oblig__c = 'Individual';
        exObj.Identifier__c = 'Manual';
        var obligLst = component.get("v.obligLst");
        console.log ('identifier value='+exObj.Identifier__c);
        if(!obligLst){
            debugger;
            obligLst = new Array();
        }
        debugger;
        obligLst.push({"exObj":exObj,"deleteRecord":false});
        console.log ('obliglst------ '+JSON.stringify(obligLst));
        component.set("v.obligLst",obligLst);
        console.log('attribute = '+component.get ("v.obligLst"));
    },
    
     redirectToViewCibilReport : function (component, event, helper) {
        console.log(component.get("v.cibil.Id"));
        /*24997 added if else*/
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isViewReportModalOpen", true);
        else
            window.open('/apex/OTPOneViewCIBILpage?id=' + component.get("v.cibil.Id")+'&appId='+component.get("v.applicantObj.Id"),'_blank', 'toolbar=0,location=0,menubar=0');
    },
    closeModel : function (component, event, helper) {
    	component.set("v.isViewReportModalOpen", false);
        component.set("v.showcibilpopup",false );
    },
	redirectToOneViewCibilReport : function (component, event, helper) {
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isOneViewReportModalOpen", true);
        else
            window.open('/apex/DetailedCibilReportPage?id=' + component.get("v.cibil.Id"),'_blank', 'toolbar=0,location=0,menubar=0'); 
    },
    closeOneViewModel : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpen", false);
    }, 
    opencibilpopup: function (component, event, helper) {
        if(!$A.util.isEmpty(component.get("v.secondaryCibilRecs")))
    	   component.set("v.showcibilpopup",true );
    }, 
  
    
})