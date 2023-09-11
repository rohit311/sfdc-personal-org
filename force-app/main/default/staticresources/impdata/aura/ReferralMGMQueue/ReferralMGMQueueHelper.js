({
    setData: function(component){
        var pageSize = component.get("v.pageSize");
        component.set("v.totalRecords", component.get("v.lstPo").length);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        
        var totRec = component.get("v.lstPo").length;
        var rem = totRec % pageSize;
        
        if(rem > 0){
            component.set("v.totalPages",Math.floor((totRec/pageSize))+1);
        }
        else{
            component.set("v.totalPages",(totRec/pageSize));
        }
        
       var poList = [] = component.get("v.lstPo");
          var PaginationList = [];
        var newPoList = [];//Added for Bug 23064
      
        var validExotelProd=component.get("v.validExotelProd");//Added for Bug 23064
             
        for(var i=0; i< pageSize; i++){
            if(poList.length > i){
			//Added for bug 23064
              for(var j=0 ; j < validExotelProd.length ; j++){
			console.log('prod dfas '+poList[i].Products__c);
                    if(validExotelProd[j].toUpperCase() === (poList[i].Products__c).toUpperCase()){
                       newPoList.push({'po':poList[i],'showCall':true});
                     
                    }
                }
                PaginationList.push(poList[i]);    
        }
        }
         component.set('v.PaginationList', PaginationList);
        component.set("v.newPoList",newPoList);//Added for Bug 23064
        component.set("v.lstPo",poList);//Added for bug 23064
        this.showhidespinner(component,event,false);

        
    },
    next : function(component, event){
        var sObjectList = component.get("v.lstPo");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        debugger;
        var newPoList = [];//Added for Bug 23064
        var validExotelProd=component.get("v.validExotelProd");//Added for Bug 23064
        console.log('validExotelProd 2 '+validExotelProd);
        for(var i= end ; i<end+pageSize; i++){
            if(sObjectList.length > i){
                
                //Added for bug 23064
                for(var j=0 ; j < validExotelProd.length ; j++){
                    console.log('prod dfas two '+poList[i].Products__c);
                    if(validExotelProd[j].toUpperCase() === (poList[i].Products__c).toUpperCase()){
                        newPoList.push({'po':poList[i],'showCall':true});
                    }
                }
                
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
         component.set("v.newPoList",newPoList);//Added for Bug 23064
        component.set("v.lstPo",poList);//Added for bug 23064
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")+1);
    },
    
    previous : function(component, event){
        var sObjectList = component.get("v.lstPo");
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
    },
    toRadian : function(val){
        return val * Math.PI / 180;
    },
     getPOS1 : function(component, event) {
        this.executeApex(component, 'getPOsMethod', {"searchLimit": "getAllReferredPO"},
                         function (error, result) {
                             if (!error && result) {
                                 var data=JSON.parse(result);
                                 component.set('v.PaginationList',data);
                                 component.set('v.lstPo',data);
                              	console.log('MGM received data +'+JSON.stringify(data));
                                 this.setData(component);
                             }
                             else{
                                        this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Message','No Records found','message');
                                 
                             }
                         });   
    },
     executeApex: function(component, method, params,callback){
       
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
          
            if(state === "SUCCESS"){
                
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
     showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
      
    },
    displayToastMessage:function(component,event,title,message,type)
    {
      
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
     sortBy : function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.lstPo");
        
      
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
        
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
        
            if($A.util.isEmpty(a[field])){
                return 1;
            }
            else if($A.util.isEmpty(b[field])){
                return -1;
            }
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.lstPo", records);
        
        var PaginationList = [];
        var pageSize = component.get("v.pageSize");
        for(var i=0; i< pageSize; i++){
            if(records.length> i)
                PaginationList.push(records[i]);    
        }
        component.set('v.PaginationList', PaginationList);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        component.set("v.sortAscDist", true);
        
    },//Added for bug 23064 start
    getValidExotelProd: function(component, event){
        debugger;
        this.executeApex(component,'getvalidExotelProduct', {
        }, function (error, result) {
            
         console.log('PR_Result'+result);
            if (!error && result) {
               
                var data=JSON.parse(result);
                component.set("v.validExotelProd",data);
                 this.getPOS1(component);
                
            }else{
                console.log('Product not matching '+error.getBody());
            }
            
        
        }); 
    },
//Added for Bug 23064 end


})