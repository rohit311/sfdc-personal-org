({
	checkuser : function(component,event) {
		
        
        var params = new Map();
        params["UserName"] = component.get("v.userName");
        params["pwd"] = component.get("v.pwd");
        var self = this;
        
        this.executeApex(component,"validateUser",{"params":params},
                         function(error, result){
                             if(!error && result){
                                 
                                 var response = JSON.parse(result);
                                 console.log(response);
                                 if(response.Status == 'Success'){
                                     component.get("v.contact",response.contact);
                                     //redirect
                                     self.createcmp(component,"StockAnalysis",{"contact":response.contact},"outerLogindiv");
                                     var loginDiv = component.find("LoginFormdiv");
        							 $A.util.toggleClass(loginDiv, "hidecls");
                                 }
                                 else{
                                     
                                     component.set("v.isError",true);
            						 component.set("v.errorMsg",response.msg);
                                 }
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