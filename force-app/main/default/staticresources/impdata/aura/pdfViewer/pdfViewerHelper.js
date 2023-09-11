({

	loadpdf:function(component,event){
		try{
			var pdfData = component.get('v.pdfData');
			var pdfjsframe = component.find('pdfFrame');
            console.log(component.get('v.OppObj'))
			if(typeof pdfData != 'undefined'){
				pdfjsframe.getElement().contentWindow.postMessage(pdfData,'*');	
			}
		}catch(e){
			alert('Error: ' + e.message);
		}
	},
    fetchUrl : function(component, event) {
        
        var action = component.get("c.fetchBaseUrl");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
               // var state = response.getState();
                var baseurln= response.getReturnValue();
                console.log('base '+baseurln);
                component.set("v.baseurl", baseurln);
                 }
            else{
            console.log("Error");
            }
        });
        $A.enqueueAction(action);
        
    },
    fetchCmnUsr : function(component, event) {
        
        var action = component.get("c.isCommunityUser");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //var state = response.getState();
                var cmnUsr= response.getReturnValue();
                console.log('cmnUsr '+cmnUsr);
                component.set("v.isCommUser", cmnUsr);
                this.fetchUrl(component, event);
                 }
            else{
            console.log("Error");
            }
        });
        $A.enqueueAction(action);
        
    }
})