({
    /*
    *   @description	: 	Method is called when user enters text in search box. 
    * 						Calls helper method to get results for SearchKeyWord.
    * 						Displays result list using css if any. 
    *   @version		: 	1.0
    */
	keyPressController : function(component, event, helper) {
        event.preventDefault();
        // Get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        var isSALMobilityFlow = component.get("v.isSALMobilityFlow");
        //alert(isSALMobilityFlow);

        // Check if getInputKeyWord size is more than 0 and open the lookup result List  
  
       if(getInputkeyWord.length > 2 && isSALMobilityFlow) {
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, "slds-is-open");
            $A.util.removeClass(forOpen, "slds-is-close");
            helper.searchHelper(component, event, getInputkeyWord);
        }
        else if(getInputkeyWord.length > 0 && !isSALMobilityFlow) {
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, "slds-is-open");
            $A.util.removeClass(forOpen, "slds-is-close");
            helper.searchHelper(component, event, getInputkeyWord);
        } else {  
            component.set("v.listOfSearchRecords", null); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, "slds-is-close");
            $A.util.removeClass(forclose, "slds-is-open");
        }        
	},
  
    /*
    *   @description	: 	Method is called when user clicks on remove button in search box. 
    * 						Clears existing text from the search box using css.
    *   @version		: 	1.0
    */ 
    clear : function(component, event, helper) {
        event.preventDefault();
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        // Hide pill target
        $A.util.addClass(pillTarget, "slds-hide");
        $A.util.removeClass(pillTarget, "slds-show");
        
        // Show lookup target
        $A.util.addClass(lookUpTarget, "slds-show");
        $A.util.removeClass(lookUpTarget, "slds-hide");
      	
        // Clear search keyword and result list
        component.set("v.SearchKeyWord", null);
        component.set("v.listOfSearchRecords", null);
        component.set("v.isCleared",true); // Bug 20391
        component.set("v.schemeId",null);// Bug 20391
    },
    
    /*
    *   @description	: 	Method is called when the user selects any record from the result list. 
    * 						Called from SelectedRecordEvent handler.
    *   @version		: 	1.0
    */
    handleComponentEvent : function(component, event, helper) {
        event.preventDefault();
        // Get the selected record from the COMPONENT event 	 
        var selectedRecordGetFromEvent = event.getParam("record");	   
        component.set("v.selectedRecord", selectedRecordGetFromEvent); 
        // Bug 20391(Start)
        if(selectedRecordGetFromEvent){
            component.set("v.schemeId",selectedRecordGetFromEvent.Id);
            component.set("v.isCleared",false);
        }
        //Bug 20391(End)
        
        // Show pill target
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, "slds-show");
        $A.util.removeClass(forclose, "slds-hide");
        
        // Add remove icon to search box
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, "slds-is-close");
        $A.util.removeClass(forclose, "slds-is-open");
        
        // Hide lookup target
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, "slds-hide");
        $A.util.removeClass(lookUpTarget, "slds-show");
	},
    
    /*
    *   @description	: 	Method is called from doneWaiting event. 
    * 						Hides the spinner icon.
    *   @version		: 	1.0
    */ 
    hideSpinner : function (component, event, helper) {
        var spinner = component.find("spinner");
        var evt = spinner.get("e.toggle");
        evt.setParams({ 
            isVisible : false 
        });
        evt.fire();    
    },
    
    /*
    *   @description	: 	Method is called from waiting event. 
    * 						Shows the spinner icon.
    *   @version		: 	1.0
    */ 
    showSpinner : function (component, event, helper) {
        var spinner = component.find("spinner");
        var evt = spinner.get("e.toggle");
        evt.setParams({ 
            isVisible : true 
        });
        evt.fire();    
    },  
    
    setCustfields : function (component, event, helper) 
    {
        var params = event.getParam('arguments');
        var forclose = component.find("searchRes");
        
        $A.util.addClass(forclose, "slds-is-close");
        $A.util.removeClass(forclose, "slds-is-open");
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField");    
        
        // Hide pill target
        $A.util.addClass(pillTarget, "slds-hide");
        $A.util.removeClass(pillTarget, "slds-show");
        
        //   Show lookup target
        $A.util.addClass(lookUpTarget, "slds-show");
        $A.util.removeClass(lookUpTarget, "slds-hide");
        
        // Clear search keyword and result list
        component.set("v.SearchKeyWord", null);
        component.set("v.listOfSearchRecords", null);
        
        var selectedRecord1 = params.selectedRecord1;
        var ObjectName1 = params.ObjectName1;
        var ObjectLabel1 = params.ObjectLabel1;
        var FieldName1 = params.FieldName1;    
        
        component.set("v.selectedRecord",selectedRecord1);
        component.set("v.ObjectName",ObjectName1);
        component.set("v.ObjectLabel",ObjectLabel1);
        component.set("v.FieldName",FieldName1);
        console.log("Parameters ="+selectedRecord1 +" "+ObjectName1+" "+ObjectLabel1+" "+FieldName1);          
    },
})