({
	doInit : function(component, event, helper) {
        console.log('in list view');
        helper.getValidExotelProd(component);//Added for bug 23064
		//helper.setData(component);
	},
    next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
    },
    toggleAssVersion : function(component, event, helper)
    {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    navigateToLA : function(component, event, helper) {
        var loanId = event.target.getAttribute('id');
        var loanObj;
        var oppList = component.get("v.oppList");
        for(var i in oppList){
            if(oppList[i].Id == loanId)
                loanObj = oppList[i];
        }
        console.log('stage is'+loanObj.StageName+loanObj.Id);
        var evt = $A.get("e.c:navigateToOpp");
        evt.setParams({
            "oppId" : loanObj.Id,
            "stage" : loanObj.StageName
        });
        evt.fire();
        component.destroy();
        
        
    },
    /*added by swapnil 23064 s*/
    makeacall : function(component,event,helper){
       
       
        helper.displayToastMessage(component,event,'Success','Calling....','success'); 
        var data = event.getSource().get("v.value");//('value');
      //  var name = event.target.getAttribute('Name');
        var fromNumber;
      
        var dataList=data.split(';');
        var oppId=dataList[0];
        var tomobile =dataList[1];
      alert('getApplicant');
        helper.executeApex(component,'getApplicant', {
            "frommobile" :  "none",
            "tomobile" :tomobile,
            "oppId":oppId
          }, function (error, result) {
             
             if (!error && result) {
                 console.log('Callback done '+JSON.stringify(result));
                 if(result !== 'Success'){
                      alert('error '+JSON.stringify(result));
                     helper.displayToastMessage(component,event,'Error',result,'error');
                 }
                 //helper.showhidespinner(component,event,false);
             }else{
                alert('error '+JSON.stringify(result));
                 helper.displayToastMessage(component,event,'Error',result,'error');
             }
            // helper.showhidespinner(component,event,false);
             
         }); 
    },
 /*added by swapnil 23064 e*/      
})