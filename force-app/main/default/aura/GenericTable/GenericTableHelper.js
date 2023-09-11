({
    fetchData: function(component,event) {
        
        this.executeApex(component,"initialize",{},function(error, result){
            component.set("v.Spinner",false);
            if(!error && result){
                
                var response = JSON.parse(result);
                if(response != null && response.objList != null){
                    
                    component.set("v.objNamesList",response.objList.sort());
                }
                else{
                    console.log('Error in processing request');
                }
                
                
            }
            else{
                console.log('Some error occured '+error);
            }
            
        });  
    }, 
    getData : function(component,event) {
        var self = this;
        
        this.executeApex(component,"queryData",{"query":component.get("v.queryStr")},function(error, result){
            if(!error && result){
                var response = JSON.parse(result);
                if(response != null){
                    if(response.status == 'Success'){
                    	//console.log(Object.getOwnPropertyNames(response.recordsList[0]));
                        component.set("v.recordList",response.recordsList);
                        self.displayData(component, event);
                    }
                    else{
                        //show error here
                    }
                }
            }
            else{
                //show error here
            }
            
            
        });
    },
    getFields : function(component,event) {
        this.executeApex(component,"fetchFieldNames",{"objName":component.find("objSel").get("v.value")},function(error, result){
            if(!error && result){
                
                var response = JSON.parse(result);
                if(response != null){
                    component.set("v.Spinner",false);
                    if(response.status == 'Success'){
                        var fieldVals = [];
                        var fieldsArray = response.fieldAPIList.sort();
                        for(var i =0;i<response.fieldAPIList.length;i++){
                            fieldVals.push({
                                label: response.fieldAPIList[i],
                                value: response.fieldAPIList[i]
                            });
                            
                        }
                        component.set("v.FieldsList",fieldVals);
                        //show success toast
                    }
                    else{
                        
                        //show faliure toast
                    }
                }
            }
            
        });
        
        
    },
    setQuery : function(component,event){
        var Query = component.find("Query").get("v.value");
        var SelectedFieldsList = component.get("v.SelectedFieldsList");
        
        if(SelectedFieldsList != null && SelectedFieldsList.length >0){
            var fields = ''+SelectedFieldsList[0];
            var qur = '';
            for(var i =1;i<SelectedFieldsList.length;i++){
                fields = fields+','+SelectedFieldsList[i];
            }
            qur = 'SELECT '+ fields+' FROM '+component.get("v.Obj");
            component.set("v.queryStr",qur);            
        }
        else{
            component.set("v.queryStr","");
        }
    },
    displayData: function(component,event){
       var dataCol = component.get("v.dataCol");
       var SelectedFieldsList = component.get("v.SelectedFieldsList");
       dataCol = new Array();
        
        for(var i=0;i<SelectedFieldsList.length;i++){
            dataCol.push( {label: SelectedFieldsList[i], fieldName: SelectedFieldsList[i], type: 'text'});
        }
        component.set("v.dataCol",dataCol);
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