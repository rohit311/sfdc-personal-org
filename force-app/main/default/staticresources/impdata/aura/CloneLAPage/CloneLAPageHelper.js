({
    
    searchLA: function(component){
     
        var action = component.get("c.SearchLoanApplication");
        action.setParams({
            "selectedcriteria": component.get('v.selectedcriteria'),
            "enteredValue": component.get('v.enteredValue'),
            "counter": component.get('v.offset'),
            "list_size": component.get('v.pageSize') 
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state === "SUCCESS") {
              var  result=response.getReturnValue();
                component.set('v.Spinner',false);
                component.set("v.LAlist",result.cloneList);
                component.set("v.ErrorMessage",true);
                //console.log('OppLIST'+response.getReturnValue());
                var pageSize = component.get("v.pageSize");
                component.set("v.totalRecords", result.total_size);
                var totRec = result.total_size;
                var rem = totRec % pageSize;
                if(rem > 0){
                    component.set("v.totalPages",Math.floor((totRec/pageSize))+1);
                }
                else{
                    component.set("v.totalPages",(totRec/pageSize));
                }
                var oppList = [] = component.get("v.LAlist");
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(oppList.length> i)
                        PaginationList.push(oppList[i]);    
                }
                component.set('v.PaginationList', PaginationList);
        
    }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    cloneLA: function(component,event){
        
        var action = component.get("c.CloneLoanApplication");
        action.setParams({
            "cloneid": component.get('v.cloneLAid'),
            
        });
        var self = this;
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = JSON.parse(response.getReturnValue());
                var oppnewId = resp['recId'];
                var dupe = resp['dupe'];
                var line = resp['line'];
                debugger;
                component.set('v.Spinner',false);
                console.log('dupe is '+dupe+' Line is'+line );
                if(!dupe && !line){
                $A.createComponent(
                    "c:SAL_SalesCmp",{"recordId":oppnewId,
                                      "fromcloneflag":true},
                    function(newComponent,status,errorMessage){
                        component.set("v.body",newComponent); 
                    }
                );
                    component.set("v.cloneFlag",false);
            	}
                else{
                    console.log('Line PO Available or Loan with duplicate data found');
                    if(dupe)
                    	this.displayToastMessage(component,event,'Error','We cannot proceed due to duplicate data!','error');
                	else if(line)
                    	this.displayToastMessage(component,event,'Error','Line PO already exists for this customer. Kindly convert the PO','error');
                        
                }
                 
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
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