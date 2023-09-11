({
	displayValue : function(component, event, helper) {
		console.log(event.target.id);
        var evtId = event.target.id;
        var tagValue = document.getElementById(evtId).value;
        
        if(document.getElementById(evtId).innerHTML != null && document.getElementById(evtId).innerHTML != '' && document.getElementById(evtId).innerHTML.includes('+')){
            document.getElementById(evtId).innerHTML = '-&nbsp;&nbsp;&nbsp;';
        }
        else{
            document.getElementById(evtId).innerHTML = '+&nbsp;&nbsp;&nbsp;';
        }
                                
        helper.toggleDiv(evtId+"_valueDiv1");
        helper.toggleDiv(evtId+"_valueDiv2");
	},
    handleRadioGroupChange : function(component, event, helper) {
         //var ctarget = event.currentTarget; 
    	//var index = ctarget.dataset.value;
    	var custId = event.getSource().get("v.label");
        console.log(custId);
        var customer = new Object();
        var customerList = component.get("v.customerList");
        if(custId){
            for(var i=0;i<customerList.length;i++){
                if(customerList[i].Customer_ID__c == custId){
                  customer = customerList[i];
                  break;  
                }
            }
            component.set("v.customer",customer); 
            console.log(component.get("v.customer"));
            var shareinfo = component.getEvent("shareCustomerInfo");
            if(shareinfo){
                shareinfo.setParams({"custObj":component.get("v.customer")});
                shareinfo.fire();
            }
        }       
        
    },  
     next : function(component, event){
        var sObjectList = component.get("v.customerList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= end ; i<end+pageSize; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")+1);
    },
    
    previous : function(component, event){
        var sObjectList = component.get("v.customerList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")-1);
    }
})