({
    doInit : function(component, event, helper) {
        var urlEvent;
        //url=lightning/r/Report/00O90000009P2uJEAS/view?queryScope=userFolders
        urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/r/Report/00O90000009P2uJEAS/view?queryScope=userFolders"
        });
        urlEvent.fire();
    }
})