({
    scriptsLoaded : function(component, event, helper) {
        console.log('Script loaded.. table'); 
        /*setTimeout(function(){ 
                             $('#tableId').dataTable({
                                 "width": 10,
                                "aaSorting": [],
                                 "searching": false,
                                 "aoColumnDefs": [{
                                        'bSortable': false,
                                        'aTargets': ['nosort']
                                        
                                    }]
                            });
                           // $('#tableId').DataTable();
                            // add lightning class to search filter field with some bottom margin..  
                            $('div.dataTables_filter input').addClass('slds-input');
                            $('div.dataTables_filter input').css("marginBottom", "10px");
                        }, 500); */
    },
     performSearch : function(component, event, helper) {
         console.log('performed search');

         
         var fromDate=new Date(component.find("from").get("v.value")); 
        // var toDate=new Date(component.find("to").get("v.value"));
         var toDate;
        
      
         if(!$A.util.isEmpty(component.find("to").get("v.value")))
           toDate=new Date(component.find("to").get("v.value")); 
         var POList = component.get("v.allPOsList");
         var followDate,updatedList=[];
                           //  updatedList.splice(0, updatedList.length);  
         for(var i=0;i<POList.length;i++){	
              followDate= new Date(POList[i].Follow_Up_Date__c); //981
                           console.log('before conversion '+fromDate+'---'+toDate+'==='+followDate);

           /* var date1 = new Date(POList[i].Follow_Up_Date__c); //981
             var mnth1 = ("0" + (date1.getMonth()+1)).slice(-2);
             var day1  = ("0" + date1.getDate()).slice(-2);
             followDate= [ date1.getFullYear(), mnth1, day1 ].join("-");
             
                var date2 =new Date(fromDate);
             if(!$A.util.isEmpty(date2)){
             var mnth2 = ("0" + (date2.getMonth()+1)).slice(-2);
             var day2  = ("0" + date2.getDate()).slice(-2);
                 fromDate= [ date2.getFullYear(), mnth2, day2 ].join("-");}
             
             var date3 =toDate;
             if(!$A.util.isEmpty(date3)){
                 var tday=new Date();
                 toDate=  tday.setMonth( tday.getMonth() + 2 );
                 date3=new Date(toDate);
                 var mnth3 = ("0" + (date3.getMonth()+1)).slice(-2);
                 var day3 = ("0" + date3.getDate()).slice(-2);
                 toDate= [ date3.getFullYear(), mnth3, day3 ].join("-");}*/
         
             
      console.log(fromDate+'---'+toDate+'==='+followDate);

             
           
             
          
         
             if((followDate>fromDate) && (followDate<toDate)  )
                     {
                         //alert('hi1');
                            updatedList.push(POList[i]);
                     }
                      //alert('Length ='+updatedList.length);
         }     
         
         component.set('v.lstPo',updatedList);
         helper.setData(component);    
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
    doInit : function(component, event, helper) {
    helper.getValidExotelProd(component);    
	//helper.setData(component);
       
        
    },
    
    sortByAmt: function(component, event, helper) {
        component.set("v.class", 'hideCls');
                component.set('v.myid','');

        
        helper.sortBy(component, "Availed_Amount__c");
    },
    sortByDist: function(component, event, helper) {
        component.set("v.class", 'hideCls');
        component.set('v.myid','');
        helper.showhidespinner(component,'waitingDiv',true);
		var POList = component.get("v.lstPo");
            console.log('POList : '+POList);
            if (POList != null && POList.length > 0){
                //alert('check');
                helper.getGeolocation(component,event,function(){
                    var POList = component.get("v.lstPo");
                    if (POList != null && POList.length > 0){
                        //alert('check');
                        console.log('in check dist2'+component.get("v.isGPSEnabled")); 
                        if(component.get("v.isGPSEnabled")){
                            //alert('check11');
                            helper.calcDistance(component,event,function(){
                                console.log('in calculate distance');
                            	if(component.get("v.isGPSEnabled")){
                                    helper.sortByDist(component);
                                }
                                else{
                                    //helper.showToast(component,'Info','Please enable GPS and refresh for distance.','info')
                                    helper.showhidespinner(component,'waitingDiv',false);
                                    helper.showCustomToast(component,'errorToast','errormsg',' Please enable GPS and refresh for distance.','Info','info');
                                }    
                            });
                        }  else {
                            console.log('inside disable')
                            ;
                            //helper.showToast(component,'Info','Please enable GPS and refresh for distance.','info')
                            helper.showCustomToast(component,'errorToast','errormsg',' Please enable GPS and refresh for distance.','Info!','info');
                        }
                    }
                    else{
                        if(!component.get("v.isGPSEnabled")){
                            //helper.showToast(component,'Info','Please enable GPS and refresh for distance.','info')
                            helper.showCustomToast(component,'errorToast','errormsg',' Please enable GPS and refresh for distance.','Info!','info');
                        }
                    }
                    helper.showhidespinner(component,'waitingDiv',false);
                });
                //alert('test');
            }
            else{
                console.log('inside showhidespinner before');
                helper.showhidespinner(component,'waitingDiv',false);
                console.log('inside showhidespinner after');
            }
        
        
    },
    next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
    },
    navigateToPoCmp : function(component, event, helper) {
        /*  component.set("v.body",'');
           console.log(event.target.getAttribute('id')); 
           $A.createComponent(
                "c:SAL_POMainScreen",{"productOfferingId" :event.target.getAttribute('id')},
                function(newComponent){
                    component.set("v.body",newComponent);
                }
            )*/
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
    },/*added by swapnil 23064 s*/
    makeacall : function(component,event,helper){
       
       
        helper.displayToastMessage(component,event,'Success','Calling....','success'); 
       
        var data = event.getSource().get("v.value");//('value');
        var fromNumber;
      
        var dataList=data.split(';');
        var LeadId=dataList[0];
        var tomobile =dataList[1];
        var product=dataList[2];
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