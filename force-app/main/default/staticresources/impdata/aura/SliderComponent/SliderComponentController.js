({
    handleSliderChange : function(component, event, helper) {
        try {
            var sliderParams = component.get("v.sliderParams");
            if(sliderParams) {
                sliderParams.value = event.getSource().get("v.value");
                component.set("v.sliderParams", sliderParams);
            }
        } catch(err) {
            console.debug("Error in handleSliderChange --> " + err.message + " stack --> " + err.stack);
        }
   	},
})