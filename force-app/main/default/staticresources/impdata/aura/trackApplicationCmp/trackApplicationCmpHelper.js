({
     setData: function(component){
        
        var pageSize = component.get("v.pageSize");
        component.set("v.totalRecords", component.get("v.listApp").length);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        var totRec = component.get("v.listApp").length;
        var rem = totRec % pageSize;
        if(rem > 0){
            component.set("v.totalPages",Math.floor((totRec/pageSize))+1);
        }
        else{
            component.set("v.totalPages",(totRec/pageSize));
        }
        var poList = [] = component.get("v.listApp");
        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(poList.length> i)
                PaginationList.push(poList[i]);    
        }
        
        component.set('v.PaginationList', PaginationList);
        this.showhidespinner(component,event,false);
        
        
    },
    getEmandateRegStatus : function(component, event,Oppid) {
        //repayObj  
      
        this.executeApex(component, 'getEmandateState',{"oppId":Oppid},
                         function (error, result) {
                               console.log('parameter passed');
                              
                             if (!error && result) {
                                 var data=JSON.parse(result);
                                 component.set('v.repayObj',data);
                                 console.log('Repayment details '+data);
                                 if($A.util.isEmpty(component.get('v.repayObj.UMRN__c'))){
                                     component.set('v.emandateStatus',false);
                                   
                                 }else{
                                      component.set('v.emandateStatus',true);
                                       
                                 }
                             }
                             else{
                                 this.showhidespinner(component,event,false);
                                 
                                 
                             }
                         });   
    }
    ,
	getApps : function(component, event) {
          console.log('Calling track geApps '+component.get("v.empId"));
        this.executeApex(component, 'getOppList', {'empId':component.get("v.empId")},
                         function (error, result) {
                               console.log('parameter passed');
                             if (!error && result) {
                                 var data=JSON.parse(result);
                                 component.set('v.PaginationList',data);
                                 component.set('v.listApp',data);
                                 console.log('Dashboard result '+result);
                                 console.log('Dashboard data '+data);
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
     closeWindow :  function(component, event) {
   
        var cmpTarget = component.find('overrideModalbox');
         // alert('Closing '+cmpTarget);
        $A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpTarget, 'slds-hide');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
   
})