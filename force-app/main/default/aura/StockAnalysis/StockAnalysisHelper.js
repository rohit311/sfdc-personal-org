({
	fetchData : function(component, event) {
		console.log('in helper');
        
        var self = this;
        this.executeApex(component,'callStockApi',{"keyword":component.get("v.StkName")},function(error, result){
            console.log(typeof result);
            //var response = JSON.deserialize();
            component.set("v.isLoading",false);
            if(!error && result){
               
                var response = JSON.parse(result);
                component.set("v.isDataFetched",true);
                component.set("v.stkData",response.respMap);
                console.log(component.get("v.stkData")); 
            	var appEvent = $A.get("e.c:shareAPIResponse");
                if(appEvent){                   
                    appEvent.setParams({ "Response" : component.get("v.stkData")});
                    appEvent.fire();
                }
                
            }
            else{                
            	component.set("v.isError",true);
            	component.set("v.errorMsg",'Internal Server error , Please try again Later !!');
            }    
            
        });
	},
     executeApex: function(component, method, params, callback){
        var action = component.get("c."+method);
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = [];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    openLogin : function(component, event){
        this.createcmp(component,"LoginCmp",{},"SearchDiv");
        
    },
    createcmp :function(component,Name,params,divName){
        var cmpName = "c:"+Name;
        
         console.log('in create');
            $A.createComponent(
                cmpName,params,
            function(newComponent,status,errorMessage){
                if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    var targetCmp = component.find(divName);
                    	var body = targetCmp.get("v.body");
                    	body.push(newComponent);
                    	targetCmp.set("v.body", body);
                    
                    }
                    else if (status === "INCOMPLETE") {
                       console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                    }
            }
        )
        
    }
})