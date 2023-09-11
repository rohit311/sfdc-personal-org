({
	answer : function(component, event, helper) {
		//var phoneEvent=component.get("messageEvent");
	var phoneEvent=component.getEvent("messageEvent");
       var text=phoneEvent.getParam("phone");
        component.set("v.number",text);
      //  text.set(phoneEvent.getParams("phone"));
	}
})