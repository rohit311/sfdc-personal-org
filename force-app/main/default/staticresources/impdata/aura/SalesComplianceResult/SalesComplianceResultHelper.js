({
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        console.log('calling method'+method);
        
        debugger; 
        
        var action = component.get("c."+method); 
        console.log('calling method'+action);
        
        action.setParams(params);
        //alert(JSON.stringify(params)+'  '+method);
        action.setCallback(this, function(response) {
            // console.log('in execute apex');
            // console.log('response@@@ '+JSON.stringify(response));
            var state = response.getState();
            console.log('state ' + state);
            
            
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
    getResultData : function(component, event){
        console.log('@@@Oppid '+component.get("v.oppId"));
        var oppId=component.get("v.oppId");
        
        this.executeApex(component,"fetchResult",
                         {
                             oppId:oppId
                             
                         },function(error, result){
                             
                             if(result){
                                 
                                 var data =JSON.parse(result);
                                 component.set("v.officeList",data.offResult);
                                 component.set("v.resList",data.resResult);
                                 console.log( 'result '+ component.get("v.resList"));
                                 var Compstatus;
                                 var res1;
                                 var res2;
                                 if(!$A.util.isEmpty(data.resResult)){
                                     Compstatus =data.pdResult;
                                     component.set("v.ResOne",data.finalResult1);
                                     component.set("v.ResTwo",data.finalResult2);
                                 }else{
                                     Compstatus='Memo not Completed';
                                 }
                                 
                                 if(Compstatus=='Memo Completed'){
                                     component.set("v.ComplianceStatus",true);
                                 }else{
                                     component.set("v.ComplianceStatus",false);
                                 }
                                 
                             }else{
                                 alert('Data Error in result '+error);
                             }
                         });
    },
    setComplianceStatus : function(component, event){
        
    }
})