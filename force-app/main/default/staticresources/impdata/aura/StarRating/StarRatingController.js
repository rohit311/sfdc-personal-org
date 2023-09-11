({
    doInit : function(component, event, helper) {
        // load raty rating plugin.
       var ratingElement = component.find("starRating").getElement();
        
        helper.loadRatingElement( component, helper, ratingElement );
        $(ratingElement).raty('set', { score:component.get("v.currentRating") });
     
    }
})