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
   fetchpicklistdata: function (component, oppId) {
    	var dedupeselectList = ["Dedupe_Source__c", "De_Dupe_Decision__c", "De_Dupe_result__c"];
		var selectListNameMap = {};
		selectListNameMap["De_Dupe__c"] = dedupeselectList;
		console.log('selectListNameMap' + selectListNameMap);
       
       var action = component.get('c.getDedupeDetails');
        action.setParams({
            "oppID": oppId,
			"objectFieldJSON": JSON.stringify(selectListNameMap)
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
                    var picklistFields = data.picklistData;
					var dedupePickFlds = picklistFields["De_Dupe__c"];
				
                    component.set("v.dedupesourceList", dedupePickFlds["Dedupe_Source__c"]);
                    component.set("v.decisionList", dedupePickFlds["De_Dupe_Decision__c"]);
                    component.set("v.resultList", dedupePickFlds["De_Dupe_result__c"]);
                        
                }
            }else
                console.log('error');
            
        });
        $A.enqueueAction(action);
       
      
    },
    saveDedupe : function(component,event){
     var dedupeList = component.get("v.dedupeList");
       /* var isvalid = true;
        var cmplist = component.find("dedupesource");
         for(var i=0;i<cmplist.length;i++)
        {
            if(!$A.util.isEmpty(cmplist[i]) && !cmplist[i].get("v.validity").valid)
            {
                isvalid = false;
                cmplist[i].showHelpMessageIfInvalid();
            }
        }*/
        if(!$A.util.isEmpty(dedupeList)){
             this.showhidespinner(component,event,true);
            var action = component.get('c.saveDedupeRecords');
            action.setParams({
                "oppId" : component.get('v.oppId'),
                "dedupeRecs" : JSON.stringify(component.get("v.dedupeList"))
            });
            action.setCallback(this, function(response){
               
                var state = response.getState();
                if (state == "SUCCESS") {
                    console.log('success');
                     if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
                         if(!$A.util.isEmpty(data.dedupeList)){
                             component.set("v.dedupeList",data.dedupeList);
                          var evt = $A.get("e.c:SetParentAttributes");
                            evt.setParams({
                                "dedupeList" : component.get("v.dedupeList"),
                                "SecName":"dedupe"
                            });
                            evt.fire();
                         }
                    
            		 console.log(JSON.stringify(component.get("v.dedupeList")));
                     this.displayToastMessage(component,event,'Success','Record updated successfully','success');
                   this.showhidespinner(component,event,false);
                     }
                }
                else{
                    this.showhidespinner(component,event,false);
                }
            });
            $A.enqueueAction(action);
        }
        else
        {
             this.displayToastMessage(component,event,'Error','There are no records to save','error');
        }
        
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
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    
})