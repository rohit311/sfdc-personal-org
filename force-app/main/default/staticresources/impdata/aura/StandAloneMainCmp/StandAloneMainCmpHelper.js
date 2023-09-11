({
	fetchConfigData : function(component, event) {
		
        var selectListNameMap = {};
        var custSelectList=["City_New__c"];
         selectListNameMap["CUSTOMER_INFO__c"] = custSelectList;
        
        this.executeApex(component,"initialize",{"objectFieldJSON" : JSON.stringify(selectListNameMap)},function(error,result){
            component.set("v.Spinner",false);
            var response = JSON.parse(result);
             if(!error && response.status == "SUCCESS"){  
             	console.log('response');               
                 component.set("v.products",response.products);
                 
                 component.set("v.premLst",response.premLst);
                 component.set("v.sumAsrLst",response.SumAsrLst);
                 component.set("v.tenorList",response.tenorLst);
                 component.set("v.FFRAmt",response.FFRAmt);
                 component.set("v.payRequest",response.payRequest);
                 component.set("v.payRecord",response.payRecord);
                 component.set("v.merMap",response.merMap);
                 console.log(response.merMap);
                 var totalAmt = parseInt(component.get("v.premLst")[0])+parseInt(component.get("v.FFRAmt"));
                 component.set("v.totalAmt",totalAmt+'');
                 component.set("v.cityLst",response.picklistData["CUSTOMER_INFO__c"]["City_New__c"]);
                 var cityList = response.cityList;
                var finalCityList = [];
                for(var key in cityList){
                    var stateMap = cityList[key];
                    var state = stateMap['state'];
                   
                    finalCityList.push({city : key,state : state});
                }
                component.set("v.cityList",finalCityList);
                 var products = component.get("v.products");
                 var parsedProds = new Array();
                 
                 for(var i=0;i<products.length;i++){
                     var obj = new Object();
                     if(products[i].split(":")[1].toUpperCase() == 'DISABLE'){
                         obj = {"product":products[i].split(":")[0],"status":true};                         
                     }
                     else{
                         obj = {"product":products[i].split(":")[0],"status":false}; 
                     }
                     console.log('hii  '+obj);
                     parsedProds.push(obj);
                 }
                 
                 component.set("v.products",parsedProds);
                 console.log(component.get("v.products")); 
                 console.log(component.get("v.premLst")); 
                 console.log(component.get("v.sumAsrLst")); 
             }
            else{
                 
                 
             }
            
        });
        
	},
    executeApex: function(component, method, params,callback){
        
        console.log('params'+JSON.stringify(params));
        console.log('method name is '+method)
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('response is'+response);
            var state = response.getState();
            console.log('state is '+state);
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()123'+response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})