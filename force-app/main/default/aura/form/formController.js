({
	doInit : function(component, event, helper) {
		helper.getExpenses(component);
	},
    
    createExpense: function(component, event, helper){
        var amt=component.find("amount");
        
        var amtvalue=amt.get("v.value");
        alert(amtvalue);
        if(isNaN(amtvalue) || amtvalue=='')
        {
            amt.set("v.errors",[{message:"Enter an expense amount."}]);
        }
        else
        {
            amt.set("v.errors",null);
            var newExpense=component.get("v.newExpense");
            helper.createExpense(component,newExpense);
        }
    }
})