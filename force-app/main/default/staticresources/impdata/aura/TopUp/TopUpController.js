({
    doInit: function(component, event, helper) {
        console.log('in init....');
        var data = component.get('v.lstTopUp');
        
        if(data.length == 5){
            component.set('v.isAddNewDisabled', true);
        }
        
        helper.initialize(component, event, helper);
    },
    
    selectAll: function(component, event, helper) {
        helper.handleSelectAll(component, event, helper);
    },

    onAddRow: function(component, event, helper) {
        helper.handleAddRow(component, event, helper);
    },

    onFetchPOS: function(component, event, helper) {
        //alert('Fetch POS button Clicked.');
        helper.fetchPOS(component, event, helper);
        
    },

    onSaveRow: function(component, event, helper) {
        helper.validateBeforeSave(component, event, helper);
        
    },

    /*onDelRow: function(component, event, helper) 
    {        
        helper.handleDelRow(component, event, helper);
    },*/
    removeRow : function(component, event, helper){
     //alert('Delete button Clicked.');
       helper.removeDeletedRow(component, event, helper);
        
    }, 
    
    handleKeyDown:function(component, event, helper)
    {
        var keyCode = event.getParams().keyCode();
    	console.log('key code'  +  keyCode);
        if(parseInt(keyCode) >= 48 && parseInt(keyCode) <= 57){
            
        }
    },
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
})