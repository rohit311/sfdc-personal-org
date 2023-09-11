({
	
    toggleAssVersion : function(component, event) {
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
    redirectToPerfiosRecord: function(component, event) {
        var bankAccount = component.get("v.bankObj");
        var theme = component.get("v.theme");
       // alert('isCommunityUsr++'+component.get("v.isCommunityUsr")+'>>theme>>'+theme);
        if(theme =='Theme3' || theme =='Theme2'){
            if(component.get('v.iscommunityUser'))
                window.open('/Partner/' + bankAccount.Id);
            else
                window.open('/' + bankAccount.Id);
        }else if(theme == 'Theme4d')
            window.open('/lightning/r/Opportunity/' + bankAccount.Id + '/view');
         else if(theme == 'Theme4t')
            this.navigateToPerfiosSF1(component, event, bankAccount.Id);
    },
	
    navigateToPerfiosSF1 : function(component, event, bankAccountId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": bankAccountId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
     //24315s
    updateBnkAccHelper : function(component,event){
        this.showhidespinner(component,event,true);
     var bankAccountList = component.get("v.bankObj"); 
        console.log("bankAccount" + JSON.stringify(component.get("v.bankObj")));
        var self = this;
        if(!$A.util.isEmpty(bankAccountList)){      
            bankAccountList.Perfios_account_same_as_Salary_account__c = true;
            var action = component.get('c.saveBankAccount');
            action.setParams({                
                "bankAccount" : JSON.stringify([bankAccountList])
            });
            
            action.setCallback(this, function(response){       
                this.showhidespinner(component,event,false);
                var state = response.getState();
                if (state == "SUCCESS") {
                    console.log('success');
                    if(!$A.util.isEmpty(response.getReturnValue())){
                    	var data = JSON.parse(response.getReturnValue());
                        console.log(data[0]);
                        if(!$A.util.isEmpty(data)){
                            
                            component.set("v.bankObj",data[0]);
                            console.log(component.get("v.bankObj"));
                        }                    
            		 	console.log('robin flag '+component.get("v.bankObj").Perfios_account_same_as_Salary_account__c);
                     	self.displayToastMessage(component,event,'Success','Record updated successfully','success');
                    }
                }
                else{self.displayToastMessage(component,event,'Error','Error occured while saving records','error');
                }
            });
            $A.enqueueAction(action);
        }
        else

        {
            self.showhidespinner(component,event,false);
             self.displayToastMessage(component,event,'Error','There are no records to save','error');
        }
        
    },
     displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    }
    //24315e 
    
})