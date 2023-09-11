({
    downloadAll : function(component,event){
        var allDocs = component.get("v.allDocs");
        for(var i in allDocs){
            if(allDocs[i].cvData.FileType != 'PDF'){
                window.open('/sfc/servlet.shepherd/version/download/'+allDocs[i].cvData.Id, '_blank');
            }
        }
    },
    doInit : function(component, event, helper){
        helper.getAllAttachments(component);
    },
    DestroyChildCmp: function(component, event, helper) {
        component.set("v.body",'');
        component.destroy();
    },
    openPop : function(component, event, helper) {
        console.log('in ctrl');
        var elements = document.getElementsByClassName("parentDiv");
        console.log('elements'+elements.length);
        while(elements.length > 0){
            elements[0].parentNode.removeChild(elements[0]);
        }
        
        helper.openPopUp(component,event);
        
    },
    closePopNew : function(component, event, helper) {
        console.log('checking close');
        
    },
    
    closePop : function(component, event, helper) {
        var cmpTarget = component.find('pop');
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget, 'slds-show');
        var backdrop = component.find('backdrop');
        $A.util.addClass(backdrop, 'slds-hide');
        $A.util.removeClass(backdrop, 'slds-show');
        var elements = document.getElementsByClassName("parentDiv");
        console.log('elements'+elements.length);
        while(elements.length > 0){
            elements[0].parentNode.removeChild(elements[0]);
        }
        
        
    }
})