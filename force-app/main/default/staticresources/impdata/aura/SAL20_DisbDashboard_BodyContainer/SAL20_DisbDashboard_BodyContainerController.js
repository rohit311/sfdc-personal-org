({
    routeNavigation : function(component, event, helper) {
        var evtParam = event.getParam('SAL20_Dashboard_Component');
        console.log('swapnil Parent id '+component.get("v.parentId"));
        var navURL = event.getParam('navigationURL');
        if(evtParam){
            component.set('v.CurrentNavigation','');
            component.set('v.CurrentNavigation',evtParam);
            component.set('v.navigationURL',navURL);
        }
    },/*DMS 24317 s*/
    updateDocumentPanel : function(component, event){
        var filename = event.getParam("fileName");
        var uploadStatus=event.getParam("uploadStatus");
        var cmp = component.find("docUploaded");
        cmp.updateChkRec(filename,uploadStatus);
    }
    /*DMS 24317 e*/
})