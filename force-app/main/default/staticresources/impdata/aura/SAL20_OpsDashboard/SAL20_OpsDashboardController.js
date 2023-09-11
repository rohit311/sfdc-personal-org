({
	onInit : function(component, event, helper) {
        var prodValues = $A.get("$Label.c.salaried_pricing_product");
		if(prodValues){
        	var prodName = prodValues.split(';');
            var salPricingProd = [];
            for (var i=0;i<prodName.length; i++) {
                 salPricingProd.push(prodName[i].toUpperCase());
                 }
             }
        var loanProduct = component.get("v.loan.Product__c");
        console.log('Loan product***'+loanProduct);
        console.log('Label product***'+salPricingProd);
            if (salPricingProd && salPricingProd.includes((loanProduct).toUpperCase())){
                    component.set("v.showSALCmp",true);
            }
            else{
                   component.set("v.showSALCmp",false);
           }
	}
})