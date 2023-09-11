({
    getProduct:function(component, event, helper){
         var action = component.get("c.validateCurrentUser");
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log("state::",state);
            if(state === "SUCCESS"){  
                console.log("validateCurrentUser::",response.getReturnValue());
                component.set("v.isValidUser", response.getReturnValue());
                
                if(response.getReturnValue()=="false"){
                    this.showToast(component, "Message!", 'This functionality is not available for you.', "error");
                	return;
                }
                
            }
        })
        $A.enqueueAction(action);
        
        var action = component.get("c.getProductofUser");
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log("state::",state);
            if(state === "SUCCESS"){  
                console.log("Products::",response.getReturnValue());
                component.set("v.productvalue", response.getReturnValue());
                console.log("productvalue::",component.get("v.productvalue"));
            }
        })
        $A.enqueueAction(action);
        
        
        
    },
    closeToast: function(component) {
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
    searchAllPOS:function(component, event, helper){
        var action = component.get("c.fetchAllPOs");
        action.setParams({
            "POID" : component.get("v.poid"),
            "mobileNumber" : component.get("v.mobNo"),
            "offerProduct": component.get("v.offerproduct")
        })
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log("state::",state);
            if(state === "SUCCESS"){
                component.set("v.totalPages", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
                var records = response.getReturnValue();
                console.log("records",records);
                records.forEach(function(record){
                    if(record.Field_Remarks__c != null){
                   		record.Field_Remarks__c = record.Field_Remarks__c.substring(0,20);
                    }     
                }); 
                component.set("v.allData", records);
                component.set("v.currentPageNumber",1);
                this.buildData(component, helper);
                if(response.getReturnValue()==null || response.getReturnValue().length<1)
                {
                    this.showToast(component, "Message!", 'PO is not found !', "error");
                }
            }
            $A.util.addClass(component.find("mySpinner"), "slds-hide");
            
        })
        $A.enqueueAction(action);
    },
    showToast: function(component, title, message, type) {        
        var toastEvent = $A.get("e.force:showToast");       
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type,
                "mode": "dismissible",
                "duration": "30000"
            });
            toastEvent.fire();
        } else {          
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if (type == 'error') {
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if (type == 'success') {
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title + ' ');
            this.showHideDiv(component, "customToast", true);
        }
    },
    showHideDiv: function(component, divId, show) {
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        component.set("v.data", data);
        
        helper.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    
})