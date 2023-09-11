({
	createExpense : function(component,expense) {
		 var theExpenses = component.get("v.expenses");
 
     
        var newExpense = JSON.parse(JSON.stringify(expense));
        console.log("Expenses before 'create': " + JSON.stringify(theExpenses));
        theExpenses.push(newExpense);
        component.set("v.expenses", theExpenses);
        console.log("Expenses after 'create': " + JSON.stringify(theExpenses));
	}
})