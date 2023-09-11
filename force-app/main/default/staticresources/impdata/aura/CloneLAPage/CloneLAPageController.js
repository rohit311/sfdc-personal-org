({
     searchLA : function(component, event, helper){
        debugger;
         var valueSel = component.get("v.selectedcriteria");
         var inputCmp;
         console.log('valueSel'+valueSel);
         if(valueSel == 'PAN Number')
         	inputCmp = component.find('enteredvaluePAN');
         else if(valueSel == 'Mobile Number')
         	inputCmp = component.find('enteredvalueMob');
         else
         	inputCmp = component.find('enteredvalueOth');
        
         console.log('is array'+$A.util.isArray(inputCmp));
        // Displays error messages for invalid fields
        inputCmp.showHelpMessageIfInvalid();
         var validForm= inputCmp.get('v.validity').valid;
        
        
        if(validForm){
            component.set('v.Spinner',true);
            helper.searchLA(component);
        }
    
       
    },
    
    cloneLA : function(component, event, helper){
        debugger;
        component.set('v.Spinner',true);
        var loanappId = event.target.id; 
        console.log('nnn'+loanappId);
        component.set('v.cloneLAid',loanappId);
        helper.cloneLA(component,event);
        
    },
    sendback : function(component,event,helper){
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "display" : true
        });
        evt.fire();
        component.destroy();
    },
    previous: function (component, event, helper) {
       var currentPage= component.get('v.currentPage');
        var pageSize= component.get('v.pageSize');
        if(currentPage > 0){
            currentPage=currentPage-1;
            component.set('v.currentPage',currentPage);
           var  offset=currentPage * pageSize;
            component.set('v.offset',offset); 
        }
        helper.searchLA(component);
       // helper.previous(component, event);
    },
    next: function (component, event, helper) {
        debugger;
        var currentPage= component.get('v.currentPage');  
        var totalPages= component.get("v.totalPages");
        var pageSize= component.get('v.pageSize');
        if(currentPage  < totalPages ){
           currentPage=currentPage+1;
           component.set('v.currentPage',currentPage);
        var  offset=currentPage * pageSize;
        component.set('v.offset',offset);
    }
       helper.searchLA(component);
       // helper.next(component, event);
    },
    
    newLoanApplicationForm : function(component, event, helper) {
        component.set("v.cloneFlag",false);
        $A.createComponent(
            "c:SAL_SalesCmp",{"newloanFlag": false},
            function(newComponent,status,errorMessage){
                component.set("v.body",newComponent);
                if (status === "SUCCESS") {
                    console.log('SUCCESS');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        )
        
    },
    
    
})