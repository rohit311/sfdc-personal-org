({
	doInit : function(component, event, helper) {
      //alert('in doinit');
       helper.updatedlistHelper(component, event);
       console.log("in uploaded document");
       console.log(component.get("v.submitButtonMap"));
	},
    updatedlist: function(component, event, helper) {
    helper.updatedlistHelper(component, event);
    },
    selectoptionvalue: function(component, event, helper) {
        console.log('in select values');
         var selectedCVIds = [];
        var selectedIdSize = [];
        var totalMemory = 0;
        var input = event.target.id;
        var inputValue = document.getElementById(input).value;
        var checkboxes = document.querySelectorAll('input[type=checkbox]:checked')
			for (var i = 0; i < checkboxes.length; i++) {
  				var cvId = checkboxes[i].value.substring(0 , checkboxes[i].value.indexOf("_"));
                selectedCVIds.push(cvId+'_'+component.get('v.LoanGuardRegNo'));
                var cvSize = checkboxes[i].value.substring(checkboxes[i].value.indexOf("_")+1);
                selectedIdSize.push(cvSize);
			}
        component.set("v.selectedDocuments" , selectedCVIds);
        for(var i = 0 ; i < selectedIdSize.length ; i++){
            totalMemory = parseInt(selectedIdSize[i]) + totalMemory;
            }
        if(totalMemory > 3000){
            helper.showToast(component, 'message','You cannot upload more then 3 MB','Message');
            event.getSource().set("v.value" , false);
        }
    },
    closeLoader:function(component, event, helper) {
         helper.closeLoaderHelper(component, event);
    },
    processButton: function(component, event, helper) {
        //alert('in process button');
        //component.set("v.showToastOnce" ,true);
        //component.set("v.count" ,'0');
        var cvids = component.get("v.selectedDocuments");
         var selectedCVIds = [];
        component.set("v.selectedDocuments" , selectedCVIds);
        if(cvids.length > 0)
        {
            helper.showhidespinner(component,event,true);
            for(var i = 0 ; i < cvids.length ; i++){
                 var cvid = cvids[i].substring(0 , cvids[i].indexOf("_"));
                 var lgid = cvids[i].substring(cvids[i].indexOf("_")+1,cvids[i].length);
                 console.log(cvids[i].indexOf("_"));
                 console.log(lgid);
                 if(lgid == component.get("v.LoanGuardRegNo"))
                 {
                    console.log('in if');
                     selectedCVIds.push(cvid);
                 }
                 
             }
            console.log(selectedCVIds);
            console.log('in event');
            var docSubmitEvent = component.getEvent("LGDocSubmitEvent");
            docSubmitEvent.setParams({
                "selectedDocs" : selectedCVIds,
                "AppNo" : component.get("v.ApplicationNo"),
                "lgRegNo" : component.get("v.LoanGuardRegNo")
            });
            docSubmitEvent.fire();
            console.log('after event');
        }
        else{
            helper.displayToastMessage(component,'message','Please select document.','Message');
        }

    },
     toggleAssVersion : function(component, event, helper)
    {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        console.log(click);
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        console.log(cls);
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           console.log(component.get("v.class"));
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    
})