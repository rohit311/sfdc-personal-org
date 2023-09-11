({
	handleClick:function(component,event){
       // alert("in Handleclick");
       /* var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);*/
        console.log("end handle click");
        //alert(component.get("v.recordId"));
         $A.createComponent(
                    "c:DigitalSamplingDocuments",{"loanID": component.get("v.recordId")},
                    function(newComponent,status,errorMessage){
                        component.set("v.body",newComponent);
                        if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    }
                    else if (status === "INCOMPLETE") {
                       console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                    }
                    }
                );
        //alert('end method');
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    displayMessage : function(component, title, message, type, fadeTimeout, isAutoClose) {
       console.log('inside generic flow...');
       console.log('Inside Display Message');
       			$A.createComponent(
                    "c:ToastMessage",
                    {
                        "title" : title,
                        "message" : message,
                        "type" : type,
                        "fadeTimeout" : fadeTimeout,
                        "isAutoClose" : isAutoClose
                    },
                    function(newComp) {
                        var body = [];
                        body.push(newComp);
                        component.set("v.body", body);
                    }
                );
    },

})