({
	handleNotificationEVT: function (component,event) {
        console.log('11::');
        var toastid = event.getParam("toastid");
        var messageid = event.getParam("messageid");
		var message = event.getParam("message");
        console.log(" ** toastId : "+toastid);
        console.log(" ** messageid : "+messageid);
        console.log(" ** message : "+message);
        console.log(" ** document.getElementById(messageid) : "+document.getElementById(messageid));
        console.log(" ** document.getElementById(toastid) : "+document.getElementById(toastid) );
        /*
        // set the handler attributes based on event data
        cmp.set("v.messageFromEvent", message);
        
        var toastid = component.get("v.toastid");
        var messageid = component.get("v.messageid");
        var message = component.get("v.message");
        */
        console.log('inEVT' +toastid + messageid +message );
        if(document.getElementById(toastid))
        	document.getElementById(toastid).style.display = "block";
        if(component.get('v.theme') == 'Theme4d'){
            var toastClasses = document.getElementById("ErrorToast").classList;
            toastClasses.add("lightningtoast");
            document.getElementById("SuccessToast").classList.add("lightningtoast");  
        }
        if(document.getElementById(messageid))
        	document.getElementById(messageid).innerHTML = message;

        
        
        setTimeout(function () {
            if(document.getElementById(messageid))
            	document.getElementById(messageid).innerHTML = "";
            if(document.getElementById(toastid))
            	document.getElementById(toastid).style.display = "none";
        }, 3000);
    },
    
    closeToastnew: function (component) {
        if(document.getElementById('successmsg1'))
        	document.getElementById('successmsg1').innerHTML = "";
        if(document.getElementById('SuccessToast1'))
        	document.getElementById('SuccessToast1').style.display = "none";
    },
 
    closeToastError: function (component) {
        if(document.getElementById('errormsg1'))
        	document.getElementById('errormsg1').innerHTML = "";
        if(document.getElementById('ErrorToast1'))
        	document.getElementById('ErrorToast1').style.display = "none";
    },
})