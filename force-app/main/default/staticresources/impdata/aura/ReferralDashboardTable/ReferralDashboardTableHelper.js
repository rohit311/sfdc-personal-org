({
    setData: function(component){
        debugger;
         
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
        debugger;
       var poList = [] = component.get("v.lstPo");
        var newPoList = [];//Added for Bug 23064
        var PaginationList = [];
        var validExotelProd=component.get("v.validExotelProd");//Added for Bug 23064
             
        for(var i=0; i< pageSize; i++){
            if(poList.length > i){
			//Added for bug 23064
              for(var j=0 ; j < validExotelProd.length ; j++){

                    if(validExotelProd[j].toUpperCase() === (poList[i].poObj.Products__c).toUpperCase()){
                       newPoList.push({'po':poList[i].poObj,'showCall':true});
                     
                    }
                }
                PaginationList.push(poList[i]);    
        }
        }
        component.set("v.newPoList",newPoList);//Added for Bug 23064
        component.set('v.PaginationList', PaginationList);
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
        this.executeApex(component, 'getPOsMethod', {"searchLimit": component.get('v.selectedRadio')},
                         function (error, result) {
                             if (!error && result) {
                                 var data=JSON.parse(result);
                                 component.set('v.PaginationList',data);
                                 component.set('v.lstPo',data);
                                 console.log('Dashboard data '+result);
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
    },//Added for bug 23064 start
    getValidExotelProd: function(component, event){
      // alert('gere');
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