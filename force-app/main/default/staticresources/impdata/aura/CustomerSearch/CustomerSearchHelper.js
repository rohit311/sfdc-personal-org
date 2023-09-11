({
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
    searchCustomer : function(component,event){
        var params = new Object();
        
        params["pan"] = component.get("v.panStr");
        params["mobile"] = component.get("v.mobileNo");
        
        var self = this;
        component.set("v.isSearched",true);
        console.log('in helper1');
        var action = component.get("c.fetchCustomers");
        action.setParams({ "paramsMap":params });
        console.log('in helper1');
        action.setCallback(this, function(response) {
            console.log('in helper2');
             var state = response.getState();
            component.set("v.Spinner",false);
             if (state === "SUCCESS") {
                 console.log('in helper3');
                 var resp = JSON.parse(response.getReturnValue());
                 console.log('in helper4 ');
                 console.log(resp);
                 console.log('in helper4 pan');
                 component.set("v.customerList",resp.customerLst);
                 self.setPagedData(component, event);
                 console.log('in helper5');
                console.log('list ');
                console.log(component.get("v.customerList"));
                if(component.get("v.customerList") && component.get("v.customerList").length > 0){
                	self.displayToastMessage(component,event,'Success','Data fetched successfully !','success');
                    //$A.util.removeClass(component.find('resultsPanel'), 'slds-hide');
                }
                else{
                    self.displayToastMessage(component,event,'Info','Data not found !','info');
                }
                 
             }
            else{
                self.displayToastMessage(component,event,'Error','Internal server error , Please try again later','error');
                console.log('in else');
            }
            
        });
        
        $A.enqueueAction(action);

        /*this.executeApex(component,"fetchCustomers",{"paramsMap":params},function(error,result){
            component.set("v.Spinner",false);
            var response = JSON.parse(result);
            if(!error && response && response.status == "SUCCESS"){
                component.set("v.customerList",response.customerList);
                console.log('list ');
                console.log(component.get("v.customerList"));
                if(component.get("v.customerList") && component.get("v.customerList").length > 0){
                	self.displayToastMessage(component,event,'Success','Data fetched successfully !','success');
                }
                else{
                    self.displayToastMessage(component,event,'Info','Data not found !','info');
                }
            }
            else{
                self.displayToastMessage(component,event,'Error','Internal server error , Please try again later','error');
                console.log('in else');
            }
            
        });*/
        
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
     setPagedData : function(component, event) {
        
        var pageSize = component.get("v.pageSize");
        console.log('robin '+component.get("v.customerList").length);
       component.set("v.totalRecords", component.get("v.customerList").length);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        var totRec = component.get("v.customerList").length;
        var rem = totRec % pageSize;
        if(rem > 0){
            component.set("v.totalPages",Math.floor((totRec/pageSize))+1);
        }
        else{
            component.set("v.totalPages",(totRec/pageSize));
        }
        var poList = [] = component.get("v.customerList");
        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(poList.length> i)
                PaginationList.push(poList[i]);    
        }
        console.log('PaginationList'+PaginationList.length);
        component.set('v.PaginationList', PaginationList);
        
    }
})