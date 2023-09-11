({
    initMainCmp : function(component, event, helper) {
        console.log('INSIDE MAIN COMP INIT')
        helper.fetchInsData(component, event, helper);
    },
    
    next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
    },
    openCustInfo: function(component, event, helper){
        helper.openCustInfoHelper(component, event, helper);
    },
    searchCust: function(component,event,helper){
        helper.searchCustHelper(component, event, helper);
    },
    backToHome: function(component,event,helper){
        helper.backToHomeHelper(component, event, helper);
    },
    
    handleMainCmpEvt: function(component,event,helper){
        console.log('Inside Event Handler');
       component.set("v.openCustDetails",false);
        component.set("v.showFltrSec",false);
        var evtParams = event.getParams();
        console.log('evtParams ::' + JSON.stringify(evtParams));
        if(evtParams.MainCmpParam.MainCmpFlag)
            component.set("v.InsMainFlag",true);
        //INIT is invoked to get updated data on back button
         helper.fetchInsData(component, event, helper);
    },
   /*handleNavEvt:function(component,event,helper){
        console.log('Inside Event Handler');
         event.stopPropagation();
        var evtParams = event.getParams();
        console.log('evtParams ::' + JSON.stringify(evtParams));
        if(evtParams.evtParams.isTileCmpFlag)
        	component.set("v.InsMainFlag",true);
        
    }*/
    clearSearch: function(component,event,helper){
    	component.set("v.searchText","");
        component.set("v.searchList.length",0 );
        var combList = helper.getLstOfRec(component,event,helper);
        helper.setRecs(component,event,helper,combList);
	},
    filterCust: function(component,event,helper){
        if(component.get("v.showFltrSec"))
        	component.set("v.showFltrSec", false);
        else
        	component.set("v.showFltrSec", true);
    },
    removeFilter: function(component,event,helper){
        component.set("v.FilterObj",{});
        component.set("v.fltrList.length", 0);
        var combList = helper.getLstOfRec(component,event,helper);
        helper.setRecs(component,event,helper,combList);
        
    },
    applyFilter: function(component,event,helper){
        helper.filterCustHelper(component,event,helper);
    }
})