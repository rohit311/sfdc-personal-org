({
	doInit : function(component, event, helper) {
      
		helper.fetchOppData(component, event,helper);
     
	},
    openQuestions :  function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:salesComplianceCmp",
            {
                OppId:component.get('v.oppId'),
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    },
})