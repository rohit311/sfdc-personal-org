({
	doInit:function(component,event,helper) {
		helper.pageskus(component, 1);
	},
	
	PageDirection: function(component, event, helper) {
    	var page = component.get("v.page");
       	var direction = event.currentTarget.dataset.dir;
        page=page*1;
        page = direction === "previous" ? (page - 1) : (page + 1);        
    	helper.pageskus(component, page);
    },

    pageNum : function(component, event, helper) {
        var page = event.currentTarget.dataset.index;
        helper.pageskus(component, page); 
    },
    
    handleClick : function(component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/006/o"
        });
        urlEvent.fire();
	},
    
    navigateToMyComponent : function(component, event, helper) {
    var evt = $A.get("e.force:navigateToComponent");
    evt.setParams({
        componentDef : "c:BLMobilityOfferDetailComp",
        componentAttributes: {
            header : component.get("v.myhead")
        }
    });
    evt.fire();
	},
    
    navigateToMyDetailComponent : function(component, event, helper) {
    var evt = $A.get("e.force:navigateToComponent");
    evt.setParams({
        componentDef : "c:expenseForm",
        componentAttributes: {
        }
    });
    evt.fire();
	},
})