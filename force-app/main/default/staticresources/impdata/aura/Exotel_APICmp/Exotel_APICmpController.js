({
    doinit:function(component,event,helper){
       
    },
    makeacall : function(component,event,helper){
        helper.showhidespinner(component,event,true);
        helper.displayToastMessage(component,event,'Success','Calling....','success'); 
        
     
               var fromNumber;
       
        helper.executeApex(component,'callToCustomer', {
            "frommobile" :  component.get("v.frommobile")+'',
            "tomobile":component.get("v.tomobile")+'',             
            "recordId" : component.get("v.recordId")+'',
            "Product":component.get("v.Product").toUpperCase()+''
        }, function (error, result) {
            if (!error && result) {
                console.log('Callback done '+JSON.stringify(result));
                if(result !== 'Success'){
                    helper.displayToastMessage(component,event,'Error',result,'error');
                }
                helper.showhidespinner(component,event,false);
                
            }else{
                
                helper.displayToastMessage(component,event,'Error',result,'error');
            }
            helper.showhidespinner(component,event,false);
        }); 
    },
})