({
    removerecord : function(component, event, helper) {
alert('Success');
    },
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded.. table'); 
    },
    toggleAssVersion : function(component, event, helper)
    {
        console.log('old '+component.get("v.oldId")); 
     
        var click=event.target.getAttribute('id');
           console.log('new '+click);
       
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }    
         component.set("v.oldId",click);
    },
    doInit : function(component, event, helper) {
       helper.showhidespinner(component,event,true);
          console.log('get POS1 called Do in it');
        helper.getValidExotelProd(component); //20364  
        //helper.getPOS1(component,event);
        
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
        console.log('child destroy'); 
        var numbers =[];
        component.set("v.lstPo",numbers);
        component.destroy();
    },
    closeCustomToast: function(component, event, helper){
        helper.closeCustomToast(component);
    },
    
    sortByAcceptance :  function(component, event, helper) {
      
           component.set("v.class", 'hideCls');
           component.set('v.myid','');
           helper.sortBy(component, "Customer_Acceptance_Flag__c");

    },
     sortByAmt: function(component, event, helper) {
        component.set("v.class", 'hideCls');
                component.set('v.myid','');

        
        helper.sortBy(component, "Offer_Amount__c");
    },
     next : function(component, event,helper){
       
        var sObjectList = component.get("v.lstPo");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
         
          console.log('Next ==> List size'+sObjectList.length+' end is '+end+' start is '+start+' Page size is '+pageSize);
        var Paginationlist = [];
        var newPoList = [];//Added for Bug 23064
        var validExotelProd=component.get("v.validExotelProd");//Added for Bug 23064
        var counter = 0;
        for(var i= end ; i<end+pageSize; i++){
            if(sObjectList.length > i){
               
                  //Added for bug 23064
                for(var j=0 ; j < validExotelProd.length ; j++){
                    console.log('prod dfas two '+sObjectList[i].Products__c+'  '+sObjectList[i].Id);
                    if(sObjectList[i].Products__c && validExotelProd[j].toUpperCase() === (sObjectList[i].Products__c).toUpperCase()){
                        newPoList.push({'po':sObjectList[i],'showCall':true});
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
        //component.set("v.lstPo",sObjectList);//Added for bug 23064
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")+1);
    },
    
    previous : function(component, event,helper){
        var sObjectList = component.get("v.lstPo");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        var newPoList = [];//Added for Bug 23064
        var validExotelProd=component.get("v.validExotelProd");//Added for Bug 23064
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                   //Added for bug 23064
                for(var j=0 ; j < validExotelProd.length ; j++){
                  //  console.log('prod dfas two '+sObjectList[i].Products__c+'  '+sObjectList[i].Id);
                    if( sObjectList[i] && sObjectList[i].Products__c && validExotelProd[j].toUpperCase() === (sObjectList[i].Products__c).toUpperCase()){
                        newPoList.push({'po':sObjectList[i],'showCall':true});
                    }
                }
                
                
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        // component.set("v.sortAsc",false);
         component.set("v.newPoList",newPoList);//Added for Bug 23064
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")-1);
    },
    /*added by swapnil 23064 s*/
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
               
                 helper.displayToastMessage(component,event,'Error',result,'error');
             }
            // helper.showhidespinner(component,event,false);
             
         }); 
    },
 /*added by swapnil 23064 e*/    
    
    
})