({
	save : function(component, event, helper) {
        var docType = component.find("selectedDoc");
        if(docType){
            var selectedDoc = docType.get('v.value');
            console.log('selectedDoc : '+ selectedDoc);
            if(selectedDoc != ''){
                var docCMP = component.find("file-uploader-1");
                console.log('docCMP : '+ docCMP);
                if(docCMP){
                    docCMP.uploadDoc();
                }
            }else{
                helper.showToast(component, 'Error!', ' Please select document type.' , 'error');
                //helper.showParentToastHelper('parentErrorToast', 'parentErrorMsg', 'Error! Please select document type.');
            }
        }
	},
   
    reset : function(component, event, helper){
		var docCMP = component.find("file-uploader-1");
        console.log('docCMP : '+ docCMP);
        if(docCMP){
            docCMP.resetDoc();
        }        
    },
    /*toggletab : function(component, event, helper) {
        helper.toggleAccordion(component,event);
    },*/
    doInit : function(component, event, helper) {
        var loanId = component.get('v.parentId');
        helper.handlePerfiosAttr(component, event);
       // alert('loanId+Perfios+'+loanId);
       helper.getHideAadhaarSectionHelper(component);//added for bug id 21851
        var action = component.get('c.getDocumentChecklistData');
        console.log('action++'+action);
        action.setParams({
            loanApplicationId : loanId 
        });
        
        action.setCallback(this,function(response){	
            var state = response.getState();
            if(state == 'SUCCESS')
            {
               console.log('onlod documents');
                var data = JSON.parse(response.getReturnValue());
                console.log(data);
                if(!$A.util.isEmpty(data.theme))
                    component.set('v.theme',data.theme);
                if(!$A.util.isEmpty(data.applicantPrimary))
                	component.set('v.primaryApp',data.applicantPrimary);
                if(component.get('v.theme') == 'Theme4d'){
                    var maindiv = component.find('offer-pg1');
                    $A.util.addClass(maindiv,'divWidth'); 
                }
            }
            else if(state == 'ERROR')
                console.log('Error while creating Contact Record!!');
        });
        $A.enqueueAction(action);
    },
    stageItemClick: function(component, event, helper){ 
        helper.activateTab(component, event.target.getAttribute('id'),true);
    },
    prevStage :function(component, event, helper){ 
		var previous ='';
		var activepath = component.get("v.activePath");
        var pathList = component.get("v.pathList");
		for(var i=0; i < pathList.length; i++) {
		  if(pathList[i] == activepath){
			  component.set("v.disablePrev", false); 
			  component.set("v.disableNext", false);
			  console.log('i>>>'+i);
			  if(i !=0){
				  previous = pathList[i-1];
				  helper.activateTab(component,previous,false);
			  }
			  if(i==1){
				  component.set("v.disablePrev", true); 
			  }
			  component.set("v.StageNum",i);
		  }
		}
        var items = $(".testing");
		var scrollContainer = $(".offer-pg-cont1");
        var item = helper.fetchItem(component,scrollContainer, items, false);
        if (item){
			var currentleft = scrollContainer.scrollLeft();
			var addleft = item.position().left + scrollContainer.scrollLeft();
          //  alert('>>item left >>'+item.offset().left+'scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left);
			if(addleft < currentleft){
            scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
			//scrollContainer.animate({"scrollLeft": item.offset().left + scrollContainer.scrollLeft()}, 400);
            }
        }
    }, 
    nextStage :function(component, event, helper){ 
        var next ='';
        var activepath = component.get("v.activePath");
        var pathList = component.get("v.pathList");
		for(var i=0; i < pathList.length; i++) {
		  if(pathList[i] == activepath){
				component.set("v.disablePrev", false); 
				component.set("v.disableNext", false); 
				if(i !=2){
					next = pathList[i+1];
                    
					helper.activateTab(component,next,false);
				}
				if(i==2){
					component.set("v.disableNext", true); 
				}
				component.set("v.StageNum",i+2);    
			}
		}
        var items = $(".testing");
		var scrollContainer = $(".offer-pg-cont1");
		var item = helper.fetchItem(component,scrollContainer, items, true);
        if (item){
			//scroll to item
			var currentleft = scrollContainer.scrollLeft();
			var addleft = item.position().left + scrollContainer.scrollLeft();
           
           		
           // alert('scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left);
			//addleft = addleft;
			//addleft = item.offset().left  + scrollContainer.scrollLeft()  ;
          //  alert(addleft);
          //  alert(item.offset().left);
            if(addleft > currentleft){
			   //scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
			   scrollContainer.animate({"scrollLeft":addleft}, 400);  
			}
		}
    },
     disablepage: function(component,event,helper)
    {
        console.log('inside disablepage'+component.get("v.disablepage"));
        if(component.get("v.disablepage"))
        helper.showSpinner(component);
        else
        helper.hideSpinner(component);
    },
    
    showDocumentToast: function(component,event,helper)
    {
         var messagetype = component.get("v.documentToast")
         if(messagetype)
         {
         var Allstr = messagetype.split(",");
         if(messagetype.includes("Error"))
         helper.showParentToastHelper(component,'parentErrorToast', 'parentErrorMsg','Error! ' +Allstr[1]);
         else
          helper.showParentToastHelper(component,'parentSuccessToast', 'parentSuccessMsg','Success! '+Allstr[1]);        
         }
         component.set("v.documentToast",'');
    },
    closeParentSuccessToast: function (component, event, helper) {
		helper.closeSuccessToastHelper(component);
	},
    closeParentErrorToast: function (component, event, helper) {
		helper.closeErrorToastHelper(component);
	},
    handlePerfiosAttr : function(component, event, helper) {
        //helper.handlePerfiosAttr(component, event);
    },
    handleEkycAttr : function(component, event, helper) {
        if(!$A.util.isEmpty(event.getParam("eKycObj")))
        	component.set("v.isEKycFlag", true);
        console.log("isEKycFlag+" + component.get("v.isEKycFlag"));
    } 
})