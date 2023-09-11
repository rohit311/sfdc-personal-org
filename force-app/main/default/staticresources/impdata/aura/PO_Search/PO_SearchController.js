({
    doInit : function(component, event, helper) {
        helper.getProduct(component, event, helper);
        
    },

    searchData : function(component, event, helper) {
        console.log("searchdata:1");
        if(component.get("v.offerproduct")&&(component.get("v.mobNo")||component.get("v.poid"))){
            $A.util.addClass(component.find("mySpinner"), "slds-show");        
            helper.searchAllPOS(component, event, helper);    
        }
        else if($A.util.isEmpty(component.get("v.offerproduct"))|| component.get("v.offerproduct")=="-None-"){
            helper.showToast(component, "Message!", 'Please Enter Offer Product', "error");
        } 
            else{
                helper.showToast(component, "Message!", 'One detail is mandatory out of PO ID and Mobile number', "error");
            }
    },
    closeCustomToast: function(component, event, helper) {
        helper.closeToast(component);
    },
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
})