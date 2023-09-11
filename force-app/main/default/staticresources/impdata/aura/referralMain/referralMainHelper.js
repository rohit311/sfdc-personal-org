({
    helperMethod : function() {
        
    },
    
    getleads : function(component){
        
        
    },
    //check if referral check box is clicked or not
    referrarSelectCheck : function(component, event){
        var result = false;
        var table = document.getElementsByName("chk");
        var contacts = component.get("v.contacts");
        var count=0;
        
        for(var i=0;i<table.length;i++){
            
            if(table.length>0 && table[i].checked){
                count++;
                console.log('Selected id is '+ table[i].value);
                component.set("v.SelectedContact",table[i].value);
                
            }            
        }
        
        return count;
    },
    createNewPanel: function(component, event) {
        
      
        var RowItemList = component.get("v.leadList");
        var referralNumber=component.get("v.referralNumber");
        
        if(event.getSource().getLocalId()=='proceedButton' && RowItemList.length==0){
            RowItemList.push({
                'sobjectType': 'lead'
            });
            component.set("v.leadList", RowItemList);
            component.set("v.referralNumber", referralNumber);
            component.set('v.addReferrelGrid',true);
            component.set("v.disableProceed", true);
           
            setTimeout(function(){
               document.getElementById('0').scrollIntoView({ 
 				 behavior: 'smooth' 
			});
                                }, 100);
           // this.focusHelper(component,event,'referralCompList');
        }
        else{
            if(RowItemList.length>0){
                var counter =component.get("v.counter");
                var res = (RowItemList.length);
                
                 component.set("v.counter",res);
                referralNumber=referralNumber+1;
                RowItemList.push({
                    'sobjectType': 'lead'
                });
                component.set("v.leadList", RowItemList);
                component.set("v.referralNumber", referralNumber);
              component.set('v.addReferrelGrid',true);
                  setTimeout(function(){  document.getElementById(res).scrollIntoView({ 
 				 behavior: 'smooth' 
				});  }, 100);
             
            }
            else{
                this.displayToastMessage(component,event,'Message','Please click on proceed button ','info');
            }
        }
    },
    removePanel :  function(component, event) {
        
        var RowItemList = component.get("v.leadList");
        if(RowItemList.length>1){
            RowItemList.pop({
                'sobjectType': 'lead'
            });
        }else{
            this.displayToastMessage(component,event,'Error','Can not remove this section','error');
        }
        component.set("v.leadList", RowItemList);
    },
    
    validateRefferalAddSection : function(component, event){
        var isValid = false;	
        var ref=component.find('referralCompList');
        if ($A.util.isEmpty(ref)){
            this.displayToastMessage(component,event,'Error','No componenent found : referralMainHepler','error');
        }else{
            if($A.util.isArray(ref)){
                isValid = ref[ref.length-1].validateReferralSection();
            } 
            else{
                isValid = ref.validateReferralSection();
            }
            
        }
        return isValid;
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
        console.log('32222222');
        showhideevent.fire();
                console.log('23231223323232');

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
    refreshSave : function (component,event){
        var RowItemList = component.get("v.leadList");
        var referralNumber=1;
        while(RowItemList.length>0){
            RowItemList.pop({
                'sobjectType': 'lead'
            });
        }
        
         RowItemList.push({
                'sobjectType': 'lead'
            });
            component.set("v.leadList", RowItemList);
            component.set("v.referralNumber", referralNumber);
            component.set('v.addReferrelGrid',true);
            component.set("v.disableProceed", true);
       
    }
    ,
    focusHelper: function(component,event,cmpid) {
        var cmplist = component.find("referralCompList");
        console.log('pk');
        console.log(cmplist);
      component.find("referralCompList")[0].getElement().focus(); 
    }   
    
})