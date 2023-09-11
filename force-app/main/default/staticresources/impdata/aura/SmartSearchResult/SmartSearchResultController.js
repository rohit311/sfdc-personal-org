({
	    
    sourceKeyPressController: function (component, event, helper) {
        console.log ('sourceKeyPressController');
        console.log('insourcekey');
        component.set("v.ValidSourceChannel",false);
        helper.startSearch(component, 'source');
    },
    
    
 selectSource: function (component, event, helper) {
        console.log ('selectSource'); 
        var index = event.currentTarget.dataset.record;
        var selectedSource = component.get("v.sourceList")[index];
        console.log("selected source"+selectedSource);
       
	   var keyword = selectedSource.Name;
        var branchtype =selectedSource.Branch__c;
  
  component.set("v.obj.Branch_Name__c",branchtype);
     
        if(!$A.util.isEmpty(selectedSource.Branch__r.Name))
            component.set("v.obj.Branch__c",selectedSource.Branch__r.Name);
       
        if(!$A.util.isEmpty(selectedSource.sourcing_channel_user__r))
            component.set("v.obj.Relationship_Manager__c",selectedSource.sourcing_channel_user__r.Id);
     
        else if(!$A.util.isEmpty(selectedSource.Reporting_Manager__r))
              component.set("v.obj.Relationship_Manager__c",selectedSource.Reporting_Manager__r.id);
        
		
		if(!$A.util.isEmpty(selectedSource.Reporting_Manager__r)){
            component.set("v.obj.ASM_email_id__c",selectedSource.Reporting_Manager__r.Email);
                }
        
		
		console.log('branchtype -->'+selectedSource.Branch__r.SAL_Branch_Type__c);
        component.set("v.ValidSourceChannel",true);
        component.set("v.selectedSource", selectedSource);
        component.set("v.sourceSearchKeyword", keyword);
        component.set("v.obj.Sourcing_Channel__c", selectedSource.Id);
     	// added on 6/6/2019 
   /*  	var acc = new Object();
		acc.Id = component.get ("v.obj.AccountId");
		acc.Sourcing_Channel__c = selectedSource.Id ;
     	acc.OwnerId = component.get ("v.obj.OwnerId");
     	var acsLst = component.get ("v.acsToUpdate");
     	acsLst.push (acc);
     	component.set ("v.acsToUpdate",acsLst);
     	console.log ('account update list='+JSON.stringify(component.get ("v.acsToUpdate")));*/
     // logic added to add info to account object  
     var actslst = component.get ("v.acsToUpdate");
         var oprecord = component.get ("v.obj");
         var flag = false;
         
        for (var i=0; i < actslst.length ; i++)
        {
            var temp = actslst[i];
            if (temp.Id === oprecord.AccountId)   
              { 
                  console.log ('existing account record found');
                  temp.Sourcing_Channel__c = oprecord.Sourcing_Channel__c ;
                  actslst[i] = temp;
                  flag=true;
              }
         }
        
        if (flag==false)
        {
            console.log ('existing account record not found');
            var account = new Object();
            account.Id = oprecord.AccountId;
            account.Sourcing_Channel__c = oprecord.Sourcing_Channel__c;
            actslst.push (account);
         }
        component.set ("v.acsToUpdate",actslst);
        console.log ("accounts list = "+JSON.stringify (component.get ("v.acsToUpdate")));
       
       // added on 6/6/2019 
     
        helper.openCloseSearchResults(component, "source", false);
        component.find("sourceName").set("v.errors", [{
            message: ""
        }
                                                     ]);
    
    },

})