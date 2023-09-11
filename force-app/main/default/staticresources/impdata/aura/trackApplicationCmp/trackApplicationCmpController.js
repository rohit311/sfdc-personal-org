({
	doinit : function(component, event, helper) {
        console.log('Calling track application ');
          helper.showhidespinner(component,event,true);
		helper.getApps(component, event);
    },
    nevigateToStage :  function(component, event, helper){
        var click=event.target.getAttribute('id');
        var poList = [] = component.get("v.listApp");
      // alert('id is '+click);
        for(var i=0; i< poList.length; i++){
           
            if(poList[i].Loan_Application__c == click)   { 
                // alert('id is '+poList[i].Loan_Application__c+' selected id is  '+poList[i].Loan_Application__r.StageName);
                if(!$A.util.isEmpty(poList[i].Loan_Application__r.StageName) && (poList[i].Loan_Application__r.StageName == 'DSA/PSF Login') || (poList[i].Loan_Application__r.StageName == 'Branch Ops') || (poList[i].Loan_Application__r.StageName == 'Moved to Finnone')){
                    if((poList[i].Loan_Application__r.StageName == 'Branch Ops') || (poList[i].Loan_Application__r.StageName == 'Moved to Finnone')){
                         component.set("v.isDetailsAvailable",false);
                         component.set("v.isOfferAvailabel",false);
                          var appEvent = $A.get("e.c:flowIdToLanding");
                    		appEvent.setParams({ "Id" : poList[i].Loan_Application__r.Id,
                                                "tabid" : 'tab2',
                                                 "detailsAvailable" : component.get("v.isDetailsAvailable"),
                      							 "offerAvailable":component.get("v.isOfferAvailabel")});
                    			appEvent.fire();
  								//component.set("v.selTabId",tab2);
                        
                          var appEventNew = $A.get("e.c:invokeMyDetails");
                          appEventNew.setParams({ "Id" : poList[i].Loan_Application__r.Id});
                          appEventNew.fire();
                         
                    }else{
                         component.set("v.isDetailsAvailable",true);
                         component.set('v.isOfferAvailabel',false);
                       // alert('details available is'+component.get("v.isDetailsAvailable"));
                      var appEvent = $A.get("e.c:flowIdToLanding");
                    		appEvent.setParams({ "Id" : poList[i].Loan_Application__r.Id,
                                        "tabid" : 'tab2',
                                        "detailsAvailable" : component.get("v.isDetailsAvailable"),
                                        "offerAvailable":false});
                    	   appEvent.fire();
                        
                           console.log('Track id '+poList[i].Loan_Application__r.Id);
                           var appEventNew = $A.get("e.c:invokeMyDetails");
                           appEventNew.setParams({ "Id" : poList[i].Loan_Application__r.Id});
                           appEventNew.fire();
                        
                    }
                    
                    //component.set("v.oppId",poList[i].Loan_Application__r.Id);
                    
                    //component.set("v.selTabId","tab2");   
                }
                if(!$A.util.isEmpty(poList[i].Loan_Application__r.StageName) && (poList[i].Loan_Application__r.StageName == 'Post Approval Sales')){
                  component.set("v.isDetailsAvailable",false);
                   component.set("v.isOfferAvailabel",false);
                     var appEvent = $A.get("e.c:flowIdToLanding");
                    		appEvent.setParams({ "Id" : poList[i].Loan_Application__r.Id,
                                        "tabid" : 'tab3',
                                        "detailsAvailable" : component.get("v.isDetailsAvailable"),
                                        "offerAvailable":component.get("v.isOfferAvailabel")});
                    	   appEvent.fire();
                           component.set("v.selTabId","tab3");   
                }
                if(!$A.util.isEmpty(poList[i].Loan_Application__r.StageName) && (poList[i].Loan_Application__r.StageName == 'Moved to Finnone')){
                    component.set("v.selTabId","tab4");  
                     var appEvent = $A.get("e.c:flowIdToLanding");
                    		appEvent.setParams({ "Id" : poList[i].Loan_Application__r.Id,
                                        "tabid" : 'tab4',
                                        "detailsAvailable" : component.get("v.isDetailsAvailable")});
                    		appEvent.fire();
                }
            
                 var compEvent = component.getEvent("DestroyTrackApplicationEvent");
                 compEvent.fire(); 
            }
         }
       
    },
      toggleAssVersion : function(component, event, helper)
    {
       
        var click=event.target.getAttribute('id');
        
       	var poList = [] = component.get("v.listApp");
        component.set("v.applicationAcceptance",false);
        component.set("v.agrementAcceptance",false);
        for(var i=0; i< poList.length; i++){
            if(poList[i].Loan_Application__c == click)   { 
                if($A.util.isEmpty(poList[i].Application_Form_Timestamp__c) || ((poList[i].Application_Form_Timestamp__c.indexOf("Accepted"))<0)){
                    component.set("v.applicationAcceptance",true);   
                }
                 if($A.util.isEmpty(poList[i].IP_Address_Timestamp__c) || ((poList[i].IP_Address_Timestamp__c.indexOf("Accepted"))<0)){
                    component.set("v.agrementAcceptance",true);
                }
            }
         }
        
         helper.getEmandateRegStatus(component, event,click);
       
        component.set('v.myid',click);
    
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
   
    getValue : function(component, event, helper){
    	//SUB(obj.Application_Form_Timestamp__c, 'Accepted'
    	return true;
	}, 
})