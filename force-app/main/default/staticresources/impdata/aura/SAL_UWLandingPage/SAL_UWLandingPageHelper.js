({
    retriggerCIBIL:function(component, event) {
        this.showhidespinner(component,event,true);
        console.log('pk gender'+component.get("v.conObj").Sex__c);
        var action = component.get('c.retriggerCIBILOperation');
        action.setParams({
            "jsonOppRecord": JSON.stringify(component.get("v.oppObj")),
            "jsonConRecord": JSON.stringify(component.get("v.conObj")),
            "jsonAppRecord": JSON.stringify(component.get("v.applicantObj"))
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event,'Message','Retrigger CIBIL successfully.','success');
            }
            else if(state == 'ERROR')
            {   
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event,'Error','Error with CIBIL Retrigger','error');
            }
        });
        $A.enqueueAction(action);        
    },
    
    retriggerDedupe:function(component, event) {
        this.showhidespinner(component,event,true);
        var action = component.get('c.retriggerDedupeOperation');
        action.setParams({
            "jsonOppRecord": JSON.stringify(component.get("v.oppObj")),
            "jsonConRecord": JSON.stringify(component.get("v.conObj")),
            "jsonAppRecord": JSON.stringify(component.get("v.applicantObj"))
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event,'Message','Retrigger Dedupe successfully.','success');
            }
            else if(state == 'ERROR')
            {   
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event,'Error','Error with Dedupe Retrigger','error');
            }
        });
        $A.enqueueAction(action);        
    },
    
    doEmpCheck:function(component, event) {
        this.showhidespinner(component,event,true);
        var action = component.get('c.doEmploymentChecks');
        action.setParams({
            "accObj": JSON.stringify(component.get("v.accObj")),
            "oppObj": JSON.stringify(component.get("v.oppObj")),
            "cont": JSON.stringify(component.get("v.conObj"))
        });
        action.setCallback(this,function(response){
            if(!$A.util.isEmpty(response.getReturnValue()))
            {
                var result = response.getReturnValue();
                var objlst = JSON.parse(result);
                console.log('objlistr -->'+JSON.stringify(objlst.objCon));
                if(!$A.util.isEmpty(objlst))
                {
                    if(objlst.status == 'success')
                    {
                        component.set("v.applicantObj",objlst.applicantPrimary);
                        component.set("v.conObj",objlst.objCon);
                        component.set("v.accObj",objlst.accObj);
                        this.displayToastMessage(component,event,'Success','Employment check done Successfully','success'); 
                        this.showhidespinner(component,event,false);
                    }
                    else
                    {
                        console.log('result>>>'+result);
                        this.displayToastMessage(component,event,'Error','Error with Employment Check','error'); 
                        this.showhidespinner(component,event,false);
                    }
                }
            }
        });
        $A.enqueueAction(action);        
    },
    
    callPANBre : function(component,event) {
        this.showhidespinner(component,event,true);
        var action = component.get('c.callPANBRE');
        action.setParams({
            "acc" : JSON.stringify(component.get("v.accObj")),
            "con" : JSON.stringify(component.get("v.conObj")),
            "loanobj" : JSON.stringify(component.get("v.oppObj")),
            "appObj1" : JSON.stringify(component.get("v.applicantObj"))
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state sal_uwlandingpage>>>>'+state);
            var result = response.getReturnValue();
                var objlst = JSON.parse(result);
                console.log('objlistr -->'+JSON.stringify(objlst));
                if(!$A.util.isEmpty(objlst))
                {
                    if(objlst.status == 'Success'){
						if(!$A.util.isEmpty(objlst.applicantPrimary))
							component.set("v.applicantObj",objlst.applicantPrimary);
						
						if(!$A.util.isEmpty(objlst.cibilExt1))
							component.set("v.cibilExt1",objlst.cibilExt1);   
						
						if(!$A.util.isEmpty(objlst.cibilExt))
							component.set("v.cibilExt",objlst.cibilExt1);   
						
						if(!$A.util.isEmpty(objlst.cibilobj))
							component.set("v.cibilobj",objlst.cibilobj);   
						
						this.showhidespinner(component,event,false);
						this.displayToastMessage(component,event,'Success','BRE called Successfully.','success');
					}
					else{
						 this.showhidespinner(component,event,false);
						this.displayToastMessage(component,event,'Failure','Error while calling BRE','failure'); 
				 
					 }
                }
				else{
					 this.showhidespinner(component,event,false);
					 this.displayToastMessage(component,event,'Failure','Error while calling BRE','failure'); 
					 
				 }
            
        });
        $A.enqueueAction(action);        
    },
    
    saveDispositionRecord:function(component, event) {
        this.showhidespinner(component,event,true);
        var contObj = component.get("v.conObj");
        var accObj = component.get("v.accObj");
        var loan = component.get("v.oppObj");
        var applicantObj = component.get("v.applicantObj");
        contObj.Special_Profile_Employer__c = component.get("v.specialPro");
        //prod new CR s
        if(!$A.util.isEmpty(component.get("v.oldOfficeemail")) && contObj.Office_Email_Id__c.toUpperCase() !== component.get("v.oldOfficeemail").toUpperCase()){
            contObj.Office_Email_sent__c = false;
            applicantObj.Office_Email_Id_Verified__c = false;
        } 
        //prod new CR e
     
        if (accObj.First_Name__c != null) {
            accObj.Name = accObj.First_Name__c;
            if (accObj.Middle_Name__c != null)
                accObj.Name = accObj.Name + ' ' + accObj.Middle_Name__c;
        }
        if (accObj.Last_Name__c != null)
            accObj.Name = accObj.Name + ' ' + accObj.Last_Name__c;
        contObj.FirstName = accObj.First_Name__c;
        contObj.Middle_Name__c = accObj.Middle_Name__c;
        contObj.LastName = accObj.Last_Name__c;
        loan.Name = accObj.Name;
        console.log('pk con address'+contObj.Address_2__c);
        component.set("v.conObj",contObj);
        component.set("v.accObj",accObj);
        component.set("v.oppObj",loan);
        component.set("v.applicantObj",applicantObj);//prod new CR
        
        console.log('pkdata'+component.get("v.oldemployername")+'___'+component.get("v.accObj").First_Name__c);
        var action = component.get('c.saveUWLandingPage');
        action.setParams({
            "accObj": JSON.stringify(accObj),
            "conObj": JSON.stringify(contObj),
            "oppObj": JSON.stringify(loan),
            "oldemployername" :component.get("v.oldemployername"),
            "applicantObj":JSON.stringify(component.get("v.applicantObj"))//prod new CR
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(!$A.util.isEmpty(response))
            {
                var result = response.getReturnValue();
                if(result == 'success')
                {
                    this.showhidespinner(component,event,false);
                    component.set("v.oldOfficeemail",contObj.Office_Email_Id__c);//prod new CR
                    this.displayToastMessage(component,event,'Success','Data Saved Successfully.','success');
                   // this.callPANBre(component,event)  // performance issue
                }
                else
                {
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Error while Saving','error');
                }
            }
        });
       
        $A.enqueueAction(action);        
    },
    
    showHideDiv: function(component, divId, show)
    {
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    
    showSpinner: function (component) 
    {
        this.showHideDiv(component, "waiting", true);
    },
    
    hideSpinner: function (component)
    {
        this.showHideDiv(component, "waiting", false);
    },
    
    showhidespinner:function(component, event, showhide){
        console.log('in showhidespinner');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    doEPFO : function(component, event) {
        this.showhidespinner(component,event,true);
        var action = component.get('c.doEPFOChecks');
        action.setParams({
            "accObj": JSON.stringify(component.get("v.accObj")),
            "oppObj": JSON.stringify(component.get("v.oppObj")),
            "cont": JSON.stringify(component.get("v.conObj"))
        });
        action.setCallback(this,function(response){
                             var objlst = JSON.parse(response.getReturnValue());
                             console.log('objlistr -->'+JSON.stringify(objlst.objCon));
                             if(!$A.util.isEmpty(objlst))
                             {
                                 if(objlst.status == 'success')
                                 {
                                     //component.set("v.applicant",objlst.applicantPrimary);
                                     component.set("v.conObj",objlst.objCon);
                                     component.set("v.accObj",objlst.accObj);
                                     this.displayToastMessage(component,event,'Success','EPFO check done Successfully','success'); 
                                     this.showhidespinner(component,event,false);
                                 }
                                 else
                                 {
                                     this.displayToastMessage(component,event,'Error','Error in EPFO check','error'); 
                                     this.showhidespinner(component,event,false);
                                 }
                             }
                         });
        $A.enqueueAction(action);        
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
    }
})