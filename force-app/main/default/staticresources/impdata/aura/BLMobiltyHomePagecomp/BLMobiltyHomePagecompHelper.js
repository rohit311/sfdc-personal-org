({       
    hideAllTabs : function(component){
    	component.set("v.hot",false);
    	component.set("v.fresh",false);
    	component.set("v.followUp",false);
    	component.set("v.docsRec",false);
    	component.set("v.others",false);
    },
    
    hideAllInnerTabs : function(component) {
    	component.set("v.Interested",false);
    	component.set("v.NotContactable",false);
    	component.set("v.NotInterested",false);
    	component.set("v.Rejected",false);
    	component.set("v.other",false);
    },
})