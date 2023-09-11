({
	getExpenses : function(component) {
		
        var action=component.get("c.getExpenses");
        
        action.setCallback(this,function(response){
            var state=response.getState();
            
            if(component.isValid() && state==="SUCCESS")
                {
                    component.set("v.expenses",response.getReturnValue());
                    this.updateTotal(component);
                }
        });
        
        $A.enqueueAction(action);
	},
    
    updateTotal:function(component){
        var expenses=component.get("v.expenses");
        var total=0.0;
        
        for(var i=0;i<expenses.length;i++)
        {
            var e=expenses[i];
            alert(e.Amount__c);
            total = total + parseInt(e.Amount__c);
		}
        
        component.set("v.total",total);
        component.set("v.exp",expenses.length);
    },
    
    
    createExpense:function(component,expense){
        this.upsertExpense(component,expense,function(a){
            var expenses=component.get("v.expenses");
            expenses.push(a.getReturnValue());
            component.set("v.expenses",expenses);
            this.updateTotal(component);
        });
    },
    
    
    upsertExpense: function(component,expense,callback){
        var action=component.get("c.saveExpense");
        action.setParams({
            "expense":expense           
        });
        
        if(callback)
            {
                action.setCallback(this,callback);
            }
        
        $A.enqueueAction(action);
    }
})