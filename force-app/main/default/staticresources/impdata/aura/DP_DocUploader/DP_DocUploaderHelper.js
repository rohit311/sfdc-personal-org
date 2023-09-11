({
    
	refresh : function(component, event, helper) 
    {
        console.log('###' +  component.find("test"));
		var getApplicantAction = component.get("c.getApplicants"); 
        getApplicantAction.setParams({ loanId : component.get("v.oppId")});
        
        getApplicantAction.setCallback(this, function(response){
            var resState = response.getState();
            if(resState == 'SUCCESS'){
                var retval = response.getReturnValue();
                
                if( retval != null && retval != undefined && retval != 'NULL'){
                    component.set("v.appList",   retval);
                    var appList = component.get("v.appList");                    
                    console.log("val of app list : " +  JSON.stringify( appList ) );
                                        
                    var typeList = [];
                    for(var i =0 ; i< appList.length; i++){
                        typeList.push({
                            key : i, 
                            value : '', 
                            count : ''
                        });
                    }
                    console.log("Type list : "  + JSON.stringify(typeList)  );
                    component.set("v.typeList",   typeList);
                    component.set("v.showSpinner", false);
                }
            }
        });	
        
        $A.enqueueAction(getApplicantAction); 
	},
    
    showConfetti: function()
    {
        var end = Date.now() + (3 * 1000);
        
        var interval = setInterval(function() {
            if (Date.now() > end) {
                return clearInterval(interval);
            }            
            confetti({
                startVelocity: 30,
                spread: 300,
                ticks: 100,
                origin: {
                    x: Math.random(),
                    // since they fall down, start a bit higher than random
                    y: Math.random() - 0.2
                }
            });
        }, 200);
    }
})