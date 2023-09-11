({
	showToast : function(component, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        }else{
			var showToast = $A.get("e.c:ShowCustomToast");
            showToast.fire(title, message, type);     
           
        }		
	},
  /*  toggleAccordion : function(component,event) {
        var targetId= event.target.getAttribute('id'); 
        console.log('TargetId : '+ targetId);
        if(targetId=="name11" || targetId=="icon11" || targetId=="section11"){
            this.showHideSection(component,"icon11","section11Content");
        }else if(targetId=="name12" || targetId=="icon12" || targetId=="section12"){
            this.showHideSection(component,"icon12","section12Content");
        }else if(targetId=="name13" || targetId=="icon13" || targetId=="section13"){
            this.showHideSection(component,"icon13","section13Content");
        }else if(targetId=="name14" || targetId=="icon14" || targetId=="section14"){
            this.showHideSection(component,"icon14","section14Content");
        }
    },
    showHideSection: function(component,iconId,sectionId){
      	var i;
         for(i=11 ; i<15; i++){ 
             var icon = 'icon'+i;
             var section = 'section'+i+'Content';
             //console.log('icon : '+ icon);
             if(icon == iconId)
             {
                 var x = document.getElementById(icon).innerHTML;
                 if(x =="[-]")
                 	document.getElementById(icon).innerHTML = "[+]"; 
                 else
                     document.getElementById(icon).innerHTML = "[-]";    	
             }else
             {
                 document.getElementById(icon).innerHTML = "[+]";
             }
             if(section == sectionId)
                 $A.util.toggleClass(component.find(section), 'slds-hide'); 
             else
                 $A.util.addClass(component.find(section), 'slds-hide'); 
    	}
	},*/
    activateTab: function(component, tabId,onstageclick) {
		console.log('tabId>>>'+tabId); 
		component.set("v.disablePrev", false); 
		component.set("v.disableNext", false);
	
		$A.util.removeClass(component.find("ChecklistTab"), "slds-is-current slds-is-active");
		$A.util.removeClass(component.find("docUploderTab"), "slds-is-current slds-is-active");
		$A.util.removeClass(component.find("docUplodedTab"), "slds-is-current slds-is-active");
		
		$A.util.addClass(component.find("ChecklistTab"), "slds-is-incomplete");
		$A.util.addClass(component.find("docUploderTab"), "slds-is-incomplete");
		$A.util.addClass(component.find("docUplodedTab"), "slds-is-incomplete");
			
		 $A.util.removeClass(component.find(tabId), "slds-is-incomplete");
		$A.util.addClass(component.find(tabId), "slds-is-current slds-is-active");
						
		this.showHideDiv(component, "ChecklistTabContent", false);
		this.showHideDiv(component, "docUploderTabContent", false);
		this.showHideDiv(component, "docUplodedTabContent", false);
		
        this.showHideDiv(component, tabId+"Content", true);
		if(onstageclick){ 
			var activepath = component.get("v.activePath");
			var pathList = component.get("v.pathList");
			var currentPos = 1;
			var prevPos = 1;
			var pathscroll = false;
			for(var i=0; i < pathList.length; i++) {
				if(pathList[i] == activepath){
					prevPos = i+1;
				}
				if(pathList[i] == tabId){
					currentPos = i+1;
				}
			}
			if(prevPos < currentPos){
				pathscroll = true;
            }
			var scrollContainer = $(".offer-pg-cont1");
			var items = $(".testing");
			var item = this.fetchItem(component,scrollContainer, items, pathscroll);
			var currentleft = scrollContainer.scrollLeft();
            var addleft = item.position().left + scrollContainer.scrollLeft();
            //alert('pathscroll>>'+pathscroll+'>>scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left);
            if(pathscroll && (addleft > currentleft)){
              //  addleft = addleft + 20;
               // scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft() + 20 }, 400);
			scrollContainer.animate({"scrollLeft":addleft }, 400);
            }
            else if(pathscroll == false && (addleft < currentleft) )
                scrollContainer.animate({"scrollLeft": item.position().left + scrollContainer.scrollLeft()}, 400);
        }
		component.set("v.activePath", tabId);
        if(tabId == 'ChecklistTab'){
			  component.set("v.disablePrev", true);    
              component.set("v.StageNum",1);
        }
        else if(tabId == 'docUplodedTab'){
			  component.set("v.disableNext", true);   
             component.set("v.StageNum",3);
        }
        else if(tabId == 'docUploderTab'){
			 component.set("v.StageNum",2);
        }
        
    },
    fetchItem :function(component,container, items, isNext) {
        var i,
        scrollLeft = container.scrollLeft();
		//set isNext default to true if not set
		if (isNext === undefined) {
			isNext = true;
		}
		if (isNext && container[0].scrollWidth - container.scrollLeft() <= container.outerWidth()) {
			//we reached the last one so return the first one for looping:
			return $(items[0]);
		}
		//loop through items
		for (i = 0; i < items.length; i++) {

			if (isNext && $(items[i]).position().left > 0) {
				//this item is our next item as it's the first one with non-negative "left" position
				return $(items[i]);
			} else if (!isNext && $(items[i]).position().left >= 0) {
				//this is our previous item as it's the one with the smallest negative "left" position
				//if we're at item 0 just return the last item instead for looping
				return i == 0 ? $(items[items.length - 1]) : $(items[i-1]);
			}
		}

		//nothing found
		return null;
    },
    showHideDiv: function(component, divId, show){
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
     showSpinner: function (component) {
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function (component) {
        this.showHideDiv(component, "waiting", false);
    },
    showParentToastHelper : function(component,toastDivId, messageDivId, message)
    {
        console.log('---->>> '+document.getElementById(toastDivId));
        
    	if(component.get('v.theme') == 'Theme4d'){
            //document.getElementById(messageDivId).classList.add("lightningtoast");  
        }
		document.getElementById(messageDivId).innerHTML = message;
        document.getElementById(toastDivId).style.display = "block";
        setTimeout(function () {
            document.getElementById(toastDivId).style.display = "none";
			document.getElementById(messageDivId).innerHTML = "";
		}, 5000);
	},
    
    closeSuccessToastHelper : function(component, event){
        document.getElementById('parentSuccessToast').style.display = "none";
        document.getElementById('parentSuccessMsg').innerHTML = "";
    },
    
    closeErrorToastHelper : function(component){
		document.getElementById('parentErrorToast').style.display = "none";
        document.getElementById('parentErrorMsg').innerHTML = "";
        
    },
    handlePerfiosAttr: function(component, event){
        var loanId = component.get('v.parentId');
        var action = component.get('c.getPerfiosFromBankAccount');
        console.log('action++'+action);
        action.setParams({
            fetchLAId : loanId 
        });
        
        action.setCallback(this,function(response){	
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                console.log('onlod documents');
                var data = response.getReturnValue();
                if(!$A.util.isEmpty(data) &&  data.Perfios_Flag__c == true)
                	component.set('v.isPerfiosFlag',true);
            }
            else if(state == 'ERROR')
                console.log('Error while creating Contact Record!!');
        });
        $A.enqueueAction(action);
    },
    //added for bug id 21851 start
    getHideAadhaarSectionHelper:function(component)
    {
        var action = component.get("c.getHideAadhaarSection");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log('hide aadhaaar>>>'+response.getReturnValue());
               		component.set('v.hideAadhaarSection',response.getReturnValue());  
            }         
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
    },//added for bug id 21851 stop
})