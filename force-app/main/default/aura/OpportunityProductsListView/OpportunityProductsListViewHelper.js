({
	getOppProducts : function(component, event) {
		var action = component.get("c.fetchOppProducts");
        action.setParams({"oppId":component.get("v.oppId")});
        action.setCallback(this,function(response){
            var state = response.getState();
            
             if (state === "SUCCESS") {
                 if(response.getReturnValue() && response.getReturnValue().length >0){
                     
                     component.set("v.oppProducts",response.getReturnValue());
                 }
                 else{
                     
                     alert('No records found !!');
                 }
             
             }
            else{
                
                alert('Some error occured.');
            }
            
        });
        
        $A.enqueueAction(action);
	},
    
    saveLineItems : function(component, event) {
        var action = component.get("c.upsertOppProds");
        
         var oppProducts = component.get("v.oppProducts");
        for(var i=0;i<oppProducts.length;i++){
            oppProducts[i].TotalPrice = oppProducts[i].Quantity*oppProducts[i].ListPrice; 
            oppProducts[i].PricebookEntryId = '01u28000001hiwKAAQ';
        }
         component.set("v.oppProducts",oppProducts);
        action.setParams({"jsonLst":JSON.stringify(component.get("v.oppProducts"))});
        action.setCallback(this,function(response){
            var state = response.getState();
            
             if (state === "SUCCESS") {
                 if(response.getReturnValue() && response.getReturnValue() != '' && response.getReturnValue() != 'Failure'){
                     
                     component.set("v.oppProducts",JSON.parse(response.getReturnValue()));
                     alert('Saved successfully !!');
                 }
                 else{
                     
                     alert('Some error occured !');
                 }
             
             }
            else{
                
                alert('Some error occured.');
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
})