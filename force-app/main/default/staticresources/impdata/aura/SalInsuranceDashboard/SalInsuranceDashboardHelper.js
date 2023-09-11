({
    getData : function(component, event) {
        var self = this;
        component.set("v.Spinner",true);
        this.executeApex(component,"fetchData",{},function(error,result){
            component.set("v.Spinner",false);
            var response = JSON.parse(result);
            
            if(!error && response.status == "SUCCESS"){ 
                
                component.set("v.Leadlst",response.leadLst);
                component.set("v.filteredData",response.leadLst);
                console.log(component.get("v.filteredData").length);
                
                self.setPagedData(component, event);
            }
            
        });
    },
    executeApex: function(component, method, params,callback){
        
        console.log('params'+params);
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
    submitAndPay : function(component, event) {
        component.set("v.Spinner",true);
        var params = new Object();
        var self = this;
        params["lead"] = JSON.stringify([component.get("v.leadWrp").leadObj]);
        params["event"] = 'xyz';   
        if(component.get("v.selectedProd") == 'Combo(CPP+FFR)'){
            params["product"] = "CPP &#038; FFR";
        }
        else{
            params["product"] = component.get("v.leadWrp").insProduct;
            
        }
        
        params["totalAmt"] = component.get("v.leadWrp").totalAmt+'';
        params["premium"] = component.get("v.leadWrp").premium+'';
        params["leadId"] = component.get("v.leadWrp").leadObj.Id;
        
        console.log('params');
        console.log(params["product"]);
        this.executeApex(component,"sendCommunication",{"paramsMap":params},function(error,result){
            component.set("v.Spinner",false);
             var response = JSON.parse(result);
            if(!error && response.status == "SUCCESS"){
                self.displayToastMessage(component,event,'Success','Communication sent to customer successfully !','success');
                self.getData(component,event);
            }
			else{               
                self.displayToastMessage(component,event,'Error','Internal server error :'+response.message,'error');
            }            
        });
        
        
    },
    setPagedData : function(component, event) {
        
        var pageSize = component.get("v.pageSize");
        console.log('robin '+component.get("v.filteredData").length);
        component.set("v.totalRecords", component.get("v.filteredData").length);
        component.set("v.startPage",0);
        if(component.get("v.filteredData").length >0){
            component.set("v.currentPage",1);
        }  
        else{
            component.set("v.currentPage",0);
        }
        component.set("v.endPage",pageSize);
        var totRec = component.get("v.filteredData").length;
        var rem = totRec % pageSize;
        if(rem > 0){
            component.set("v.totalPages",Math.floor((totRec/pageSize))+1);
        }
        else{
            component.set("v.totalPages",(totRec/pageSize));
        }
        var poList = [] = component.get("v.filteredData");
        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(poList.length> i)
                PaginationList.push(poList[i]);    
        }
        console.log('PaginationList'+PaginationList.length);
        component.set('v.PaginationList', PaginationList);
        
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
})