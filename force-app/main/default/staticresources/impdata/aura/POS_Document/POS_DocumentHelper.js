({
	
    setOfferConverted : function(component){
        var offer = component.get('v.offer');
        offer.converted = true;
        component.set('v.offer',offer);
    },

 
})