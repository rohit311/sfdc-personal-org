({
	saveContact : function(component, event, helper){
    var action = component.get("c.createContact");
    action.setParams({"newContact" : component.get("v.newContact")});
    console.log("newContact first name : " + component.get("v.newContact.FirstName"));

    action.setCallback(this, function(a){
        console.log("state : " + a.getState());
        if(a.getState()==="SUCCESS"){
            var result = a.getReturnValue();
            component.set("v.newContact", result);
            //var evt = $A.get("e.c:B_RefreshEvent");
            //evt.fire();

            //document.getElementById("newContactModal").style.display = "none";
            //document.getElementById("backGroundSectionId").style.display = "none";

            component.set("v.newContact",{'sobjectType':'Contact',
                    'FirstName':'',
                    'LastName':'',
                    'Phone':''});

            //helper.hidePopUp(component);
        }
        else if(a.getState() === "ERROR"){
            $A.log("Errors", a.getError());
        }
    });
    $A.enqueueAction(action);
	}
})