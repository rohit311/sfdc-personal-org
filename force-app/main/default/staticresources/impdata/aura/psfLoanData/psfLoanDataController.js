({
	
 // method to display expanded data view on + button click   
toggleAssVersion : function(component, event, helper)
    {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        //alert(click);
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    
    storeAccountOwner : function(component, event, helper ){
        
         var selectedItem = event.currentTarget; // Get the target object
         
         console.log ('on change check selectedItem='+selectedItem);
         var index = selectedItem.dataset.record; 
         console.log ('on change check index='+index);
         var actslst = component.get ("v.acsToUpdate");
         var oprecord = component.get ("v.opDisplayValues")[index];
         console.log ('account list ='+actslst);
         
         var flag = false;
         
        for (var i=0; i < actslst.length ; i++)
        {
            var temp = actslst[i];
            if (temp.Id === oprecord.AccountId)   
              { 
                  console.log ('existing account record found');
                  
                  temp.OwnerId = oprecord.OwnerId ;
                  actslst[i] = temp;
                  flag=true;
              }
         }
        
        if (flag==false)
        {
            console.log ('existing account record not found');
            var account = new Object();
            account.Id = oprecord.AccountId;
            account.OwnerId = oprecord.OwnerId;
            actslst.push (account);
         }
        
        component.set ("v.acsToUpdate",actslst);
        console.log ("accounts list = "+JSON.stringify (component.get ("v.acsToUpdate")));
       
        
        },
        
doInit : function (component , event , helper)
{
 	console.log ('inside component doInit');
    console.log (component.get ("v.reRender"));
    component.set ("v.reRender",true);
    console.log (component.get ("v.reRender"));
	helper.getPsfTableData(component ,  event);
		
},
 
    // fetch opp values for the selected sales manager 
   goToPsfOpps : function(component, event) {
       
       console.log ('button click registered');
       console.log ('FLAG pre='+component.get ("v.flag"));
       component.set ("v.flag",true);
       console.log ('FLAG pre='+component.get ("v.flag"));
       var comp = event.getSource() ;
       console.log ('component='+comp);
       console.log ('index of element = '+ comp.get("v.value"));
       var opps = component.get("v.opTableValues")[comp.get("v.value")];
      
       if(!$A.util.isEmpty(opps.Sourcing_Channel__c))
       component.set ("v.sourceSearchKeyword",opps.Sourcing_Channel__r.Name);

       var oppsList = [];

       for (var i=0 ; i < opps.length ; i++){
           var temp = opps [i];
           temp.Created_Time__c = temp.Created_Time__c.substring(0,10);
           oppsList.push (temp);
       }
       component.set ("v.opDisplayValues",oppsList);
        },

    
    
    goToZeroPsfOpps : function (component , event , helper){
        component.set ("v.flag",false);
        helper.displayToastMessage(component,event,'Error','No Opportunities to display!','error');
    },
 
    
    
    saveRecords : function (component , event , helper) {
        console.log ('save method:controller');
        helper.saveOpportunities(component, event);
   
    },
   
    
     sendback : function(component,event,helper){
        var targetCmp = component.find("childCmp");
        console.log(targetCmp);
        var body = targetCmp.get("v.body");
        targetCmp.set("v.body",''); 
      
        var evt1 = $A.get("e.c:DestroyChild");
        evt1.fire();
        console.log(component.get("v.poListInit"));
        console.log(component.get("v.body"));
        
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "display" : true
        });
        evt.fire();
        component.destroy();
    }
    

 
})