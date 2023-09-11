({
	
    closeModalWindow : function(component, event, helper) {  
        console.log('in Close Functionality JS');
        component.set("v.isOpen", false);
        
    },
    searchRec : function(component, event, helper) {  
        //alert('in controller');
        helper.searchrecords(component,event);
        event.preventDefault();
    },
    onGroup: function(component,event,helper){
        
        
        var getWhichBtn2 = event.getSource().get("v.text");
        console.log('getWhichBtn2 : '+getWhichBtn2)
        component.set("v.selectedRecord" , getWhichBtn2); 
        event.preventDefault();
        return false;
        
    },
    cloneRec: function(component, event, helper) { 
    	//alert('in clone');
        
        helper.cloneRecord(component);
        
        //event.preventDefault();
        
    }
})