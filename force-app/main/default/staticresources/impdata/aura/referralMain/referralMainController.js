({
    doInit : function(component, event,helper){
        
        helper.executeApex(component, 'getUser',
                           {},
                           function (error, result) {
                               if (!error && result) {
                                   var data=JSON.parse(result);
                                   component.set('v.User',data);
                               }
                               else{
                                   this.showhidespinner(component,event,false);
                                   helper.displayToastMessage(component,event,'Message','No Records found','message');
                               }
                           });   
        
        
    },
    //Search Lead/Contact using mobile number
    searchReferrar : function(component, event, helper) {
        var phone=component.get("v.referrarMobile");
        
        if($A.util.isEmpty(component.find('referrarMobile').get("v.value"))){
            	console.log('In empty if Showing on 25');
                helper.displayToastMessage(component,event,'Message','Enter Mobile Number','info');
                 
            	return null;
        }    
        else{
              
            console.log('In empty else');
           	 	var action = component.get('c.getContacts');
            	var RowItemList = component.get("v.leadList");
            	var isvalid = true;
            
           		while(RowItemList.length>0){
                	RowItemList.pop({'sobjectType': 'lead'});
            	}
                component.set("v.leadList", RowItemList);
                component.set("v.addReferrelGrid",false);
                component.set('v.showGrid',false);
                component.set('v.emptyResult',false);
                
            //Check if mobile string is not empty
            if($A.util.isEmpty(component.get("v.referrarMobile"))|| (component.find("referrarMobile") && !component.find("referrarMobile").get("v.validity").valid)){
              	     
                    component.set('v.showGrid',false);
               	    isvalid = false;
               	    component.find("referrarMobile").showHelpMessageIfInvalid();
                    console.log('Showing on 48');
                    helper.displayToastMessage(component,event,'Error','Enter correct mobile to search ','error');
                    component.set('v.showGrid',false);
                    console.log('Contact error cought');
            }
            
            
            //if all given criterias are filled for input mobile string 
            if(isvalid)
            {
                helper.showhidespinner(component, event,true);
                helper.executeApex(component, 'getContacts',
                                   {mobile:phone},
                                   function (error, result) {
                                       if (!error && result) {
                                           var data=JSON.parse(result);
                                           component.set('v.contacts',data);
                                           console.log('Contact we get '+data);
                                           helper.showhidespinner(component,event,false);
                                           component.set('v.showGrid',true);
                                           
                                       }
                                       else{
                                           this.showhidespinner(component,event,false);
                                          
                                           helper.displayToastMessage(component,event,'Message','No Records found','message');
                                           
                                       }
                                   });   
                
            }
        } 
    },
    
    
    // Load new referral add section first time
    createFirstPanel : function(component, event,helper){
        //check if at least or exactly one checkbox is selected for referral==>can be changed if required
        if(helper.referrarSelectCheck(component, event)==1){
               if(component.get("v.leadList").length==0){
                      helper.createNewPanel(component, event); 
                      component.set('v.addReferrelGrid',true);
               }else
                      helper.displayToastMessage(component,event,'Information','Please click Add','info');
        }else{
        	  if(helper.referrarSelectCheck(component, event)>1)
            	      helper.displayToastMessage(component,event,'Message','Please select only one referrrr ','info');
              else 
                	  helper.displayToastMessage(component,event,'Message','Please select referrer ','info');
         }	 
          
    },
    
    addNewRow: function(component, event, helper) {
           //check if atleast or exactly one checkbox is selected for referral==>can be changed if required
          if(helper.referrarSelectCheck(component, event)==1){
                 var checkValid=helper.validateRefferalAddSection(component, event);
                 if(checkValid)
                        helper.createNewPanel(component, event);    
                 else
                        helper.displayToastMessage(component,event,'Message','Please enter all required fields ','info');
          }else 
                 helper.displayToastMessage(component,event,'Message','Please select referrer ','info');
        
             
        
    },
    RemoveRow : function(component, event, helper) {
           helper.removePanel(component, event);
    },
    
    
    SaveLead: function(component, event, helper){       
        
        var leadList = JSON.stringify(component.get("v.leadList"));        
        var contactJSON = "";        
        var action = component.get('c.saveLeads');
        
        if(helper.validateRefferalAddSection(component, event)==true){
            
            helper.referrarSelectCheck(component, event);
            var selectedContact = component.get("v.SelectedContact");            
            var contacts = component.get("v.contacts");
            var contact = component.get("v.selectedContactRecord");
            for(var k=0; k<contacts.length;k++){
                if(component.get('v.contacts')[k].contObj.Id==selectedContact){
                    
                    contactJSON=JSON.stringify(component.get('v.contacts')[k]);
                }
            }
            var selectedContactRecord = component.get("v.selectedContactRecord");
            console.log('Passed contacts '+contactJSON);
            action.setParams({leadJson:leadList, selectedContact: contactJSON })
            helper.showhidespinner(component, event,true);
            action.setCallback(this,function(actionResult){
                var state = actionResult.getState();
                helper.showhidespinner(component, event,false);
                console.log('Status is '+state+'  retruned valeus are   '+JSON.stringify(actionResult));
                if(state === "SUCCESS"){
                    
                    helper.displayToastMessage(component,event,'success','PO generated successfully','success');
                    helper.refreshSave(component,event);
                } 
                else if(state === "ERROR") {
                    helper.displayToastMessage(component,event,'Failure',actionResult.getReturnValue(),'Failure');
                }
                
                helper.showhidespinner(component, event,false);
                
            });
            $A.enqueueAction(action);
        }else{
            helper.displayToastMessage(component,event,'Error','Please enter all required fields ','error');
        }
        var referralCompList=component.find('referralCompList');
    },
    enableProceed : function(component, event, helper) {
        component.set("v.disableProceed", false);
        var items = document.getElementsByName('chk');
        for (var i = 0; i < items.length; i++) {
            if (items[i].type == 'checkbox')
                items[i].checked = false;
        }
        event.target.checked=true;        
        
    },
    callFocus :  function(component, event, helper) {
    
     setTimeout(function(){  document.getElementById('0').scrollIntoView({ 
 				 behavior: 'smooth' 
				});  }, 2);
}

})