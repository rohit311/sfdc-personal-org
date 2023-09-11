({
	doInit : function(component, event, helper) {
        $A.createComponent("ui:button",{"aura:id":"aid","label":"Click","press":component.getReference("c.handleClick")},function(newButton){
            if(component.isValid()){
                var body=component.get("v.body");
                console.log(body);
                body.push(newButton);
                component.set("v.body",body);
            } 
            
        });
	},
    
    handleClick: function(){
        console.log("clicked");
    }
})