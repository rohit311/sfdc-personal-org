({
	doInit : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        var action = component.get("c.getCurrentTheme");
        console.log(component.get("v.recordId"));
        action.setParams({loanId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("In Setcallback " + state);
            
            var detailStr = response.getReturnValue();
            if (state === "SUCCESS") {
            	console.log("Success dointit");
                console.log(detailStr);
                var strarray = detailStr.split("_");
               console.log('detailStr-->'+strarray);
                if(strarray[0] != '' && strarray[0] != null)
                {
                    var theme = strarray[0];
                    component.set("v.currentTheme" , theme);
                }
                if(strarray[1] != '' && strarray[1] != null)
                {
                    var showSaveButton = strarray[1];
                    component.set("v.showSaveButton" , showSaveButton);
                }
                else{
                    component.set("v.showSaveButton" , false);
                }
                 if(strarray[2] != '' && strarray[2] != null)
                {
                    var showIniDGSamplingButton = strarray[2];
                    component.set("v.showIniDGSamplingButton" , showIniDGSamplingButton);
                }
                else{
                    component.set("v.showIniDGSamplingButton" , false);
                }
                 if(strarray[3] != '' && strarray[3] != null)
                {
                    var showBypass = strarray[3];
                    component.set("v.showBypass" , showBypass);
                }
                else{
                    component.set("v.showBypass" , showBypass);
                }
                if(strarray[4] != '' && strarray[4] != null)
                {
                    var isbypassselected = strarray[4];
                    console.log(isbypassselected);
                    if(isbypassselected == 'true')
                    {
                        var selectRadio = component.find('bypass');
                        component.set("v.isbypassselected" , true);
                        console.log('in bypass');
                       // console.log(selectRadio.prop('checked',true));
                    }
                    else{
                        var selectRadio = component.find('register');
                        console.log('in register')
                       // console.log(selectRadio.prop('checked',true));
                    }
                }
                
                console.log("showDgSection");
                console.log(component.get("v.showDgSection"));
                console.log(component.get("v.currentTheme"));
            }
            else {
                 helper.displayMessage(component, 'Error', 'Internal Server Error', 'error', 10000, false);
            }
        })
        $A.enqueueAction(action);
        helper.showhidespinner(component,event,false);
       
        
    },
    onGroup : function(component, event, helper) {
		var opts = document.querySelector('input[name="options"]:checked').value;
        component.set("v.storeRadioValue" , opts);				
	},
    //24316 start
    gotoApp:function(component,event,helper){
       component.set("v.showDgSection" , false);
        $A.createComponent(
            "c:DigitalSamplingDocuments",{"loanID":component.get("v.recordId"),"isMobility": true},
            function(newComponent){
                component.set("v.body",newComponent);
            }
        )
    },
    //24316 stop
    
    gotoURL:function(component,event,helper){
        helper.showhidespinner(component,event,true);
        if(component.get("v.currentTheme") == 'Theme3'){
            window.open("/apex/DigitalSamplingCmpPage?id=" + component.get("v.recordId"))
        }
        else{
            component.set("v.showDgSection" , false);
            helper.handleClick(component,event);
        }
        helper.showhidespinner(component,event,false);
    },
    
    
    save : function(component, event, helper) {
        console.log("record Id");
        
        helper.showhidespinner(component,event,true);
        
        console.log(component.get("v.recordId"));
        var val = document.querySelector('input[name="options"]:checked').value;
        component.set("v.storeRadioValue" , val);
        console.log("Selected Value");
        console.log(component.get("v.storeRadioValue"));
        console.log(component.get("v.loanValue"));
        console.log(component.get("v.Applicants"));
        
        
        var action = component.get("c.callBRELoanguardAPI");
        action.setParams({selectedRadio : component.get("v.storeRadioValue"),
                          loanId : component.get("v.recordId"),
                          testRes : 'Test'
                         });
        action.setCallback(this, function(response) {
            console.log(' SAVE response ',response);
            var state = response.getState();
            console.log("In Setcallback : save : " + state);
            var showHideStr = response.getReturnValue();
            console.log("showHideStr");
            console.log(showHideStr);
            
            
            if (state === "SUCCESS") {
            	console.log("Success");
                var strarray = showHideStr.split("_");
               console.log('showHideStr-->'+strarray);
                if(strarray[0] != '' && strarray[0] != null)
                {
                    var showSaveButton = strarray[0];
                    component.set("v.showSaveButton" , showSaveButton);
                }
                else{
                    component.set("v.showSaveButton" , false);
                }
                 if(strarray[1] != '' && strarray[1] != null)
                {
                     var showIniDGSamplingButton = strarray[1];
                   component.set("v.showIniDGSamplingButton" , showIniDGSamplingButton);
                }
                else{
                    console.log('in else');
                    component.set("v.showIniDGSamplingButton" , false);
                }
               
                var resultmsg =strarray[2];
                
                
                
                //helper.displayToastMessage(component,'message','Success','Message');
                var title = "Message";
				var message = resultmsg;
				var type = "message";
				var fadeTimeout = 10000;
                //24316 s
              	if(component.get("v.isMobility")) 
                	helper.displayToastMessage(component,event,title,message,type);
                else 
                    helper.displayMessage(component, title, message, type, fadeTimeout, false);
                //24316 e 
				helper.showhidespinner(component,event,false);
            }
            else{
                
                //alert('Error');
                helper.displayMessage(component, 'Error', 'Internal Server Error', 'error', 10000, false);
                helper.showhidespinner(component,event,false);
                
            }
        })
        $A.enqueueAction(action);
     	
        console.log("after all action");
    },
    
})