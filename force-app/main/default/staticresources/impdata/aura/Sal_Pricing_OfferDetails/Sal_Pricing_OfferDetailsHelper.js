({	
    //Bug 24667 Start
    deleteRecord : function(component, event) {
        debugger;
        try{
        var recSolId = event.currentTarget.value;
        this.executeApex(component, "deleteSolObject", {
            "solId": recSolId,
            "loanId": component.get("v.oppId")
            
        }, function (error, result) {
            
            if (!error && result) {
                if(result == 'Fail'){
                    console.log('%%^^&^&** ');
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Error while processing!','error');
                }
                else if (result == 'Empty'){
                    console.log('464363 ');
                    component.set("v.addOnSolList",null);
                    this.showhidespinner(component,event,false);
                    this.validateSolList(component, event);
                    this.displayToastMessage(component,event,'Succces','Record deleted successfully!','success');
                }
                    else{
                        console.log('fgdsafg ');
                        component.set("v.addOnSolList",JSON.parse(result));
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Succces','Record deleted successfully!','success');
                        this.validateSolList(component, event);
                    }
                console.log('mhmfgf ');
            }
        });
        }
            catch(exception){
            console.log('exception is'+exception);
            this.showhidespinner(component,event,false);
        } 
    },
    
    
    
    
    editRecord : function(component, event) {
        debugger;
        try{
        var recSolId = event.currentTarget.value;
        
        console.log('nnn id is'+recSolId);
        $A.createComponent(
            "c:AddOnCardModal",{
                "header":"Edit Record",
                "loanId":component.get("v.oppId"),
                "appId":component.get("v.applicantObj").Id,
                "solId":recSolId
            },
            function(newComponent,status,errorMessage){
                console.log('in create'+status+errorMessage+newComponent);
                component.set("v.body",newComponent);
            }
        )
        
        console.log('after');
        }catch(exception){
            console.log('exception is'+exception);
            this.showhidespinner(component,event,false);
        } 
    },
    
    addNewRecord : function(component, event) {
        try{
        var recAppId = event.currentTarget.value;
        
        console.log('id is'+component.get("v.applicantObj").Id);
        $A.createComponent(
            "c:AddOnCardModal",{
                "header":"Add Record",
                "loanId":component.get("v.oppId"),
                "appId":component.get("v.applicantObj").Id
            },
            function(newComponent,status,errorMessage){
                console.log('in create'+status+errorMessage+newComponent);
                component.set("v.body",newComponent);
            }
        )
        
        console.log('after');
        }catch(exception){
            console.log('exception is'+exception);
            this.showhidespinner(component,event,false);
        } 
    },
    
    validateSolList : function(component, event){
        try{
        debugger;
        console.log(component.get("v.isPreapproved"));
        console.log("newsols"+component.get("v.addOnSolList"));
        var NoOfAddCards = component.get("v.NoOfAddCards");
        console.log("NoOfAddCards"+NoOfAddCards);
        var Sollength = 0;
        if(component.get("v.addOnSolList")){
            Sollength = component.get("v.addOnSolList").length;
        } 
        
        if(component.get("v.isPreapproved")== true){
            if(NoOfAddCards ==2){
                component.set("v.DisableAdd",true);
            }
            else if(NoOfAddCards ==-1 && Sollength ==2){
                component.set("v.DisableAdd",true);
            }
                else if(NoOfAddCards ==0 && Sollength ==2){
                    component.set("v.DisableAdd",true);
                }
                    else if(NoOfAddCards ==1 && Sollength >=1){
                        console.log('fgdsafg '+Sollength);
                        component.set("v.DisableAdd",true);
                    }else if(Sollength ==2){
                        component.set("v.DisableAdd",true);
                    }
                        else{
                            component.set("v.DisableAdd",false);
                        }
            
        }
        else{
            if(Sollength == 2){
                component.set("v.DisableAdd",true);
            }else{
                component.set("v.DisableAdd",false);
            }
            
        }
            }catch(exception){
            console.log('exception is'+exception);
            this.showhidespinner(component,event,false);
        }  
        
    },
    
    handleUpdateSol : function(component, event){
        debugger;
        try{
        this.showhidespinner(component,event,true);
        this.executeApex(component, "fetchAddOnSolList", {
            "opp" : component.get("v.oppId")
        }, function (error, result) {
            
            if (!error && result) {
                if(result == 'Fail'){
                    this.showhidespinner(component,event,false);
                }
                else{
                    var data = JSON.parse(result);
                    
                    console.log('addOnSolList'+data.addOnSolList);
                    //console.log(data.addOnSolList[0].Charge_Type__c);
                    component.set("v.addOnSolList",data.addOnSolList);
                    this.validateSolList(component, event);
                    this.showhidespinner(component,event,false);
                    // location.reload();
                }
                
            }
        });
            }catch(exception){
            console.log('exception is'+exception);
            this.showhidespinner(component,event,false);
        }  
      
    },
    
    // Bug 24667 End
    
    subscribeToOffer : function() {
        
    },

    saveOffersHelper : function(component,event)
    {
       	this.showhidespinner(component,event,true);
        this.executeApex(component, 'saveOffersMethod', {
            "loanId" :component.get("v.oppId") , "JSONapplicantObj" :JSON.stringify(component.get("v.applicantObj")),
            "JSONsurrogateObj" :JSON.stringify(component.get("v.scam"))     
        },   
                         function (error, result) {
                            
                             if (!error && result) {
                                 // user story 978 s
                                 /*var updateidentifier =  $A.get("e.c:Update_identifier");
                                 updateidentifier.setParams({
                                     "eventName": 'Pricing Cross Sell Cart',
                                     "oppId":component.get("v.oppId")
                                 });
                                 updateidentifier.fire();*/
                                 // user story 978 e
                                 if(result == 'EMIError'){
                                             this.displayToastMessage(component,event,'Success','Cannot add EMI Card !','error');
                                     		 this.showhidespinner(component,event,false);
                                 }else{
                                  this.displayToastMessage(component,event,'Success','Offer Saved','success');   
                                 	//977 start
									 this.executeApex(component, 'updateFees', {
										 "loanId" :component.get("v.oppId")                               
									 },function (error, result) {
                                         console.log('in updateFees');
										 if(result != 'NULL'){
											 component.set('v.loan',JSON.parse(result));
                                             var updateidentifier =  $A.get("e.c:Update_identifier");
                                             updateidentifier.setParams({
                                                 "eventName": 'Pricing Cross Sell Cart',
                                                 "oppId":component.get("v.oppId")
                                             });
                                             updateidentifier.fire();
										 } 
										 console.log('result is))))::'+result);
										 this.showhidespinner(component,event,false);
									});//977 stop	
                                 }
                                // this.showhidespinner(component,event,false);
                             }
                             else{
                                 this.displayToastMessage(component,event,'Error','Unable to save Offer','error');
                                 this.showhidespinner(component,event,false);
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
    displayToastMessage:function(component,event,title,message,type)
    {
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    }
})