({
	getFruits : function(component, event, helper) {
		var fruits = window.fetchfruits();
        console.log('fruits');
        component.set("v.externalList",fruits);
        console.log(fruits);
	}
})