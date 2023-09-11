({
    removerecord : function(component, event, helper) {
alert('Success');
    },
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded.. table'); 
    },
    toggleAssVersion : function(component, event, helper)
    {
       
        var click=event.target.getAttribute('id');
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    doInit : function(component, event, helper) {
       helper.showhidespinner(component,event,true);
        helper.getValidExotelProd(component); //20364   
        
    },
    
    next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
    },
    navigateToPoCmp : function(component, event, helper) {
        var evt = $A.get("e.c:SetPOId");
        evt.setParams({
            "productOfferingId" : event.target.getAttribute('id')
        });
        evt.fire();
        component.destroy();
        
    },
    DestroyChildCmp: function(component, event, helper) {
       
        var numbers =[];
        component.set("v.lstPo",numbers);
        component.destroy();
    },
    closeCustomToast: function(component, event, helper){
        helper.closeCustomToast(component);
    },/*added by swapnil 23064 s*/
    makeacall : function(component,event,helper){
       
       
        helper.displayToastMessage(component,event,'Success','Calling....','success');
        
        var data = event.getSource().get("v.value");//('value');
        var fromNumber;
      
        var dataList=data.split(';');
        var LeadId=dataList[0];
        var tomobile =dataList[1];
        var product=dataList[2];
     console.log(dataList[0]+'  fdsafas '+dataList[1]+' fdsafas '+dataList[2]);
        helper.executeApex(component,'callToCustomer', {
            "frommobile" :  "none",
            "tomobile" :tomobile,
            "objName":"Lead",
            "Id" : LeadId,
            "Product" :product
          }, function (error, result) {
             
             if (!error && result) {
                 console.log('Callback done '+JSON.stringify(result));
                 if(result !== 'Success'){
                     helper.displayToastMessage(component,event,'Error',result,'error');
    }
                 //helper.showhidespinner(component,event,false);
             }else{
                 console.log('error '+leadId);
                 helper.displayToastMessage(component,event,'Error',result,'error');
             }
            // helper.showhidespinner(component,event,false);
             
         }); 
    },
 /*added by swapnil 23064 e*/    
    
    
})