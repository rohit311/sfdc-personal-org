({
    doInit : function(component, event, helper) {
        console.log('Amit'+component.get("v.loanTenor"));
        //if(!$A.util.isEmpty(component.get("v.performance_report.Loan_Type__c"))){
        		//Added by Aniket start
			if($A.util.isEmpty(component.get("v.performance_report.Loan_Type__c"))) {
                    component.set("v.isValid",false);
                    helper.showhidespinner(component,event,false);
                    helper.displayToastMessage(component,event,'Error','Please Select Valid Loan Type','error');
                }//Added by Aniket stop
        //}
        	console.log('Performance_report in helper '+JSON.stringify(component.get('v.performance_report')));
        // component.set("v.loanTenor",component.get("v.performance_report.Approved_Tenor__c"));
        // alert(component.get('v.availedAmount'));
       // alert(component.get("v.availedTenor"));     
                 console.log('Test  '+component.get("v.performance_report.Loan_Type__c"));

        component.set("v.InitialTenorHybrid",component.get("v.availedTenor"));
        if(component.get("v.performance_report.Loan_Type__c") == 'Hybrid Loan'){
            if(component.get("v.performance_report.Approved_Tenor__c") != null){
                                 console.log('TestIN  '+component.get("v.performance_report.Approved_Tenor__c"));

            	var tenor = component.get("v.performance_report.Approved_Tenor__c");
                if(component.get("v.InitialTenorHybrid") != '--None--' || component.get("v.InitialTenorHybrid") != null){
                   var inittenor = component.get("v.InitialTenorHybrid");
                    if(inittenor == 'none')
                    {
                        console.log('create zero');
                        inittenor=0;
                    }
                    var subTenor=0;
                    subTenor= tenor - inittenor;
                    console.log(tenor+' 000 '+inittenor);
                    component.set("v.loanTenor",subTenor);
                    console.log('Check  '+subTenor);
                    
                }
            }
        }
        
        helper.setRejectReasons(component,event);
        helper.fetchScheme(component,event);
    },
    
    fetchSchemes : function(component, event, helper) {
        component.set("v.InitialTenorHybrid","--None--");
        //alert(component.get("v.availedTenor"));
      //  component.set("v.loanTenor",component.get("v.availedTenor"));
        helper.selectScheme(component,event);
        
    },
    navigateToDetailsTab : function(component, event, helper) {
        var valid=true;
        var tenor;
        var fieldList;
        console.log('Welcome');
        if(component.get("v.performance_report.Loan_Type__c")=='Hybrid Loan'){
            tenor=component.get('v.InitialTenorHybrid');
            fieldList=["Amount","InitialTenorHybrid"];
        }else{
            fieldList=["Amount","loanTenor"]; 
            tenor=component.get('v.loanTenor');
        }
        
        var valid=true;
        for(var i=0;i<fieldList.length;i++){
            if(!component.find(fieldList[i]).get("v.validity").valid){
                            console.log('console result'+component.find(fieldList[i]));

                component.find(fieldList[i]).showHelpMessageIfInvalid();
                valid=false;
            }
        }
        
       // console.log('testing purpose tenor> v.InitialTenor'+tenor+component.get("v.InitialTenor"));
        
        if( component.get("v.availedAmount") >component.get("v.InitialAmount") ){
            helper.displayToastMessage(component,event,'error','Amount can not be greater that approved amount','error');
            return false;
        }else if( component.get("v.availedAmount") < 100000 ){
            helper.displayToastMessage(component,event,'error','Amount can not be less than 100000','error');
              return false;
        }else if( tenor>component.get("v.InitialTenor") && component.get("v.performance_report.Loan_Type__c")!='Hybrid Loan'){
            helper.displayToastMessage(component,event,'error','Tenor can not be greater that approved tenor','error');
              return false;
        } else{
            console.log('here1 '+valid)
            if(valid)
                helper.availOffer(component,event);
        }
        
        
    },
    
    SetLaterFlag : function(component,event,helper) {
       
             var valid=true;
        var tenor;
        var fieldList;
        if(component.get("v.performance_report.Loan_Type__c")=='Hybrid Loan'){
            tenor=component.get('v.InitialTenorHybrid');
            fieldList=["Amount","InitialTenorHybrid"];
        }else{
            fieldList=["Amount","loanTenor"];
            tenor=component.get('v.loanTenor');
        }
        
        
        var valid=true;
        for(var i=0;i<fieldList.length;i++){
            if(!component.find(fieldList[i]).get("v.validity").valid){
                
                component.find(fieldList[i]).showHelpMessageIfInvalid();
                valid=false;
            }
        }
         if( component.get("v.availedAmount") >component.get("v.InitialAmount") ){
            helper.displayToastMessage(component,event,'error','Amount can not be greater that approved amount','error');
            return false;
        }else if( component.get("v.availedAmount") < 100000 ){
            helper.displayToastMessage(component,event,'error','Amount can not be less than 100000','error');
              return false;
        }else if( tenor>component.get("v.InitialTenor")){
            helper.displayToastMessage(component,event,'error','Tenor can not be greater that approved tenor','error');
              return false;
        } else{
            console.log('here1')
            if(valid)
              { 
               component.set("v.laterFlag",true);
                var reasons = null;
                var multislect = component.find("mymultiselect");
                multislect.setRejectReason(reasons);
              }
        }
        
        
    },
    Save : function(component,event,helper){
        
        
        var multislect = component.find("mymultiselect");
        var mySelectedvalues = multislect.bindData();
        component.set("v.mySelectedvalues",mySelectedvalues);
        if(!$A.util.isEmpty(mySelectedvalues)){
            helper.availLater(component,event);
        }
        else{
            helper.displayToastMessage(component,event,'Error','Please choose one or more decline reasons','error');
        	helper.showhidespinner(component,event,false);
        }
    },
    
    Cancel : function(component,event,helper){
        component.set("v.laterFlag",false);
        component.set("v.mySelectedvalues","");
    },
    tenorChanged : function(component,event,helper){
            component.set("v.InitialTenorHybrid",'');
        helper.calculateEMI(component,event);
    },
    initialTenorChanged :  function(component,event,helper){
        
        var InitialloanTenor=component.get("v.InitialTenor");
        var subSequentTenor=component.get("v.loanTenor");
        var initialTenor =component.get("v.InitialTenorHybrid");
        var hybridFullTenor=component.get("v.hybridFullTenor");
          //alert('InitialloanTenor '+InitialloanTenor+' subSequentTenor '+subSequentTenor+' initialTenor ' +initialTenor);
          console.log('ff '+hybridFullTenor);
            console.log('ff '+initialTenor);
        if(initialTenor == '--None--' || initialTenor=='' ){
            helper.displayToastMessage(component,event,'Error','Please select initial tenor','error')
            return;
        }else if(initialTenor >= hybridFullTenor){
            helper.displayToastMessage(component,event,'Error','Pure Flexi Tenor cannot be greater than pre approved tenor','error')
            return;
        }
        else{        
            console.log('Hi '+hybridFullTenor);
            console.log('Hi '+initialTenor);
            var newSubTenor=hybridFullTenor-initialTenor;
            component.set("v.InitialTenorHybrid",initialTenor);
            component.set("v.loanTenor",newSubTenor);
                        console.log('Subsi '+newSubTenor);
            helper.calculateEMI(component,event);
        }
    },showInfoMessage : function(component,event,helper){
        
        var cmpTarget = component.find('overrideModalbox1');
        var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpBack, 'slds-backdrop_open');
        
    }, closeMessage : function(component,event,helper){
        var cmpTarget = component.find('overrideModalbox1');
        var cmpBack = component.find('Modalbackdrop');
        //$A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.removeClass(cmpTarget, 'slds-show');
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpBack, 'slds-backdrop_open');
    },
    resetTenor :  function(component,event,helper){
        
        console.log('hii');
                    helper.calculateEMI(component,event);

		//component.set("v.InitialTenorHybrid","--None--");
        //component.set("v.loanTenor","");
		        
    }
})