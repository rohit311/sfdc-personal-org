({
    doInit : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        helper.getPOSData(component,event);
    },
    renderSec : function(component, event, helper) {
        helper.renderSec(component,event);
        if(component.get("v.isCredit") && (component.get("v.oppObj").Product__c=='SAL'|| component.get("v.oppObj").Product__c=='SPL'))
        	helper.updateSchemeList(component, event);//US_18345
    },
     /*US_18345 S*/
     varientChange : function(component, event, helper) {
        if((component.get("v.isCredit")  || component.get("v.oppObj").StageName == 'DSA/PSF Login') && (component.get("v.oppObj").Product__c=='SAL'||component.get("v.oppObj").Product__c=='SPL'))
        { 
         helper.varientChange(component,event);
         if(component.get("v.isCredit"))
         helper.updateSchemeList(component, event);
        }
    },
    updateScheme :function(component, event, helper) {
       if(component.get("v.isCredit") && (component.get("v.oppObj").Product__c=='SAL'||component.get("v.oppObj").Product__c=='SPL'))
        helper.updateSchemeList(component, event);
    },
     /*US_18345 E*/
    addNewRecord : function(component, event, helper) {
        var telePDList = component.get("v.posListTU");
        if(telePDList.length<5){
            telePDList.push({'sobjectType':'TelePDQuestionMaster__c'});
        	component.set("v.posListTU",telePDList);
        } 
        else{
            helper.displayToastMessage(component,event,'Error','Cannot add more than 5 records','error');
        }
                    
        
    },
    savePOSTU : function(component, event, helper){
        if(component.get("v.isCredit")){
            if(!$A.util.isEmpty(component.find('schemeName').get('v.value')))
            {
                helper.showhidespinner(component,event,true);
                helper.savePOSDataTU(component,event);
            }
            else
                helper.displayToastMessage(component,event,'Error','Please Enter Scheme','error');
        }
        else{
            helper.showhidespinner(component,event,true);
            helper.savePOSDataTU(component,event);
        }
    },
    savePOSBT : function(component, event, helper){
        if(component.get("v.isCredit")){
            if(!$A.util.isEmpty(component.find('schemeName').get('v.value')))
            {
                helper.showhidespinner(component,event,true);
                helper.savePOSDataBT(component,event);
            }
            else  
                helper.displayToastMessage(component,event,'Error','Please Enter Scheme','error');
        }
        else{
            helper.showhidespinner(component,event,true);
            helper.savePOSDataBT(component,event);
        }
    },
    savePOSOth : function(component, event, helper){
        if(component.get("v.isCredit")){
            if(!$A.util.isEmpty(component.find('schemeName').get('v.value')))
            {
                helper.showhidespinner(component,event,true);
                 //alert('Abhi ctrl1');
                helper.savePOSDataOth(component,event);
            }
            else  
                helper.displayToastMessage(component,event,'Error','Please Enter Scheme','error');
        }
        else{
            helper.showhidespinner(component,event,true);
             //alert('Abhi ctrl2');
            helper.savePOSDataOth(component,event);
        }
                     

    },
    
    fetchPOS : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        helper.fetchPOSData(component,event);
    },
    deleteRecord : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        var recId = event.currentTarget.value;
        if(!$A.util.isEmpty(recId)){
            helper.deletePOSRecord(component,event,recId);
        }
        else{
            var posListTU = component.get("v.posListTU");
            console.log('posListTU'+posListTU);
            posListTU.pop();
            component.set("v.posListTU",posListTU);
            helper.renderSec(component,event);
            helper.showhidespinner(component,event,false);
        }
    },
    //underwriter screen changes start
    schemeKeyPressController : function (component, event, helper) {
        console.log ('scheme list='+component.get("v.schemeList"));
        helper.startSearch(component, 'scheme');
    },
    selectScheme: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedArea = component.get("v.schemeList")[index];
        console.log(selectedArea);
        var keyword = selectedArea.Name;
        
        console.log('keyword>>' + selectedArea);
        component.set("v.selectedScheme", selectedArea);
        component.set("v.schemeSearchKeyword", keyword);
        component.set("v.oppObj.Scheme_Master__c", selectedArea.Id);
        helper.openCloseSearchResults(component, "scheme", false);
        component.find("schemeName").set("v.errors", [{
            message: ""
        }
                                                     ]);
    },
  //underwriter screen changes end
  // /*Retrigger 20939 s*/
    retriggerBRE: function(component, event, helper) {
         helper.displayToastMessage(component,event,'Success','We are processing your BRE. Please Wait.','success');
        helper.retriggerBRE(component, event, helper);
    },
    /*Retrigger 20939 e*/
})