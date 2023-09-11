({
    doInit : function(component,event,helper){
        
        console.log('primary app'+component.get("v.primaryApp.Id"));
         if(component.get("v.cetralisedSampling")) //US 5113
           helper.getoppDetails(component, event); //US 5113	
        helper.getDataOnLoad(component,event);
              /* CR 22307 s */
        var stage = component.get("v.stageName");
         
        if(component.get("v.isUnderwitercmp") == true){
            if(stage == 'Underwriting' || component.get("v.Oppobj.Consider_for_Re_Appraisal__c") == true || stage == 'Approved' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
                component.set("v.displayReadOnly",false);
            } 
            else{ 
                component.set("v.displayReadOnly",true);
                
            }
            
        }
        // Bug 23064 start
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            { 
                component.set("v.displayReadOnly",true);
                
            } 
            // Bug 23064 stop
    },
     /*US_5574 S*/
    onChange : function(component,event,helper){
       var verificationType = component.find("veritype").get("v.value");
       // alert(verificationType);
        if(verificationType=="RSA verifications")
        {
            component.set('v.selectFlag','RSA');
            console.log('Abhi::'+verificationType);
        }
        else if(verificationType=="RCU verifications"){
            component.set('v.selectFlag','RCU');
        }
         else if(verificationType=="Centralised sampling")
            component.set('v.selectFlag','Centralised sampling');
        else
            component.set('v.selectFlag','');
    },
    /*US_5574 E*/
    addRecords : function(component,event,helper){
        helper.addveriRecords(component,event);
    },
    sendEmail : function(component,event,helper){
        helper.sendEmailHelper(component,event);
    },
    updateRecords : function(component,event,helper){
          //Condition added by swapnil for Story #899 s
        if(helper.verifyRecords(component,event)) 
            helper.updateVeriRecords(component,event);
        else
            helper.displayToastMessage(component,event,'Error','Please select RSA Flag.','error');
        //Condition added by swapnil for Story #899 e
    },
    
	onCrossButton : function(component,event,helper){
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-show");
        $A.util.addClass(modalname, "slds-hide");
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
})