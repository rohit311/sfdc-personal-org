({
	activateTab: function (component, tabId, onstageclick) {
		console.log('tabId>>>' + tabId);
		component.set("v.disablePrev", false);
		component.set("v.disableNext", false);
		
		//Rohit EKYC start
		$A.util.removeClass(component.find("AadharTab"), "slds-is-current slds-is-active");
		//Rohit EKYC stop
		$A.util.removeClass(component.find("commercialTab"), "slds-is-current slds-is-active");
		$A.util.removeClass(component.find("InsuranceTab"), "slds-is-current slds-is-active");
		$A.util.removeClass(component.find("LineEligibilityTab"), "slds-is-current slds-is-active");
		$A.util.removeClass(component.find("feesTab"), "slds-is-current slds-is-active");
		$A.util.removeClass(component.find("DisbursementTab"), "slds-is-current slds-is-active");

        //Rohit EKYC start
        $A.util.addClass(component.find("AadharTab"), "slds-is-incomplete");
        //Rohit EKYC stop
		$A.util.addClass(component.find("commercialTab"), "slds-is-incomplete");
		$A.util.addClass(component.find("InsuranceTab"), "slds-is-incomplete");
		$A.util.addClass(component.find("LineEligibilityTab"), "slds-is-incomplete");
		$A.util.addClass(component.find("feesTab"), "slds-is-incomplete");
		$A.util.addClass(component.find("DisbursementTab"), "slds-is-incomplete");

		$A.util.removeClass(component.find(tabId), "slds-is-incomplete");
		$A.util.addClass(component.find(tabId), "slds-is-current slds-is-active");
		$A.util.addClass(component.find(tabId), "applyposition");
        
        //Rohit EKYC start
        this.showHideDiv(component, "AadharTabContent", false);
        //Rohit EKYC stop
		this.showHideDiv(component, "commercialTabContent", false);
		this.showHideDiv(component, "InsuranceTabContent", false);
		this.showHideDiv(component, "LineEligibilityTabContent", false);
		this.showHideDiv(component, "feesTabContent", false);
		this.showHideDiv(component, "DisbursementTabContent", false);
		this.showHideDiv(component, tabId + "Content", true);
       
		if (onstageclick) {
			var activepath = component.get("v.activePath");
			var pathList = component.get("v.pathList");
			var currentPos = 1;
			var prevPos = 1;
			var pathscroll = false;
			for (var i = 0; i < pathList.length; i++) {
				if (pathList[i] == activepath) {
					prevPos = i + 1;
				}
				if (pathList[i] == tabId) {
					currentPos = i + 1;
				}
			}
			if (prevPos < currentPos) {
				pathscroll = true;
			}
			var scrollContainer = $(".offer-pg-cont");
			var items = $(".stage_item");
			var item = this.fetchItem(component, scrollContainer, items, pathscroll);
			if (item) {
				var currentleft = scrollContainer.scrollLeft();
				var addleft = item.position().left + scrollContainer.scrollLeft();
				//alert('scrollcontainer>>'+currentleft+'>>addleft>>'+addleft+'>>item position>>'+item.position().left);
				if (pathscroll && (addleft > currentleft))
					scrollContainer.animate({
						"scrollLeft": item.position().left + scrollContainer.scrollLeft()
					}, 400);
				else if (pathscroll == false && (addleft < currentleft))
					scrollContainer.animate({
						"scrollLeft": item.position().left + scrollContainer.scrollLeft()
					}, 400);

			}
		}
        
        //if (component.get("v.theme") == 'Theme4t') {
			var pos = $('#' + tabId).offset();
			console.log('position' + pos.left + 'top' + pos.top);
			$("#tooltip").detach().appendTo('#' + tabId);
			//$("#tooltip").parent().css({position: 'relative'});
			// console.log('tooltipparent'+$("#tooltip").parent());
		console.log('tooltipleft csss' + $('#tooltip').css('left'));	
        $("#tooltip").css(pos);
       // $("#tooltip").css({marginLeft : pos.left});
      //  $("#tooltip").left(300);
        $("#tooltip").scrollLeft(300);
    /*   var tooltipleft =   $("#tooltip").position().left;
        console.log('tooltipleft>>'+tooltipleft);
       var tooltipleft1 = $("#tooltip").position().left + item.position().left + scrollContainer.scrollLeft();
        console.log('tooltipleft1>>'+tooltipleft+'>>item postion>>'+item.position().left+'>>scrollContainer.scrollLeft()>>'+scrollContainer.scrollLeft());
        $("#tooltip").css({top: 45, left: tooltipleft1});*/
			console.log('tooltipleft final' + $('#tooltip').css('left'));
      //  console.log( $('#tooltip').css(pos));
      
    /*
			$A.util.removeClass(component.find("tooltip"), "slds-hide");
			$A.util.addClass(component.find("tooltip"), "slds-show");
			setTimeout(function () {
				$A.util.removeClass(component.find("tooltip"), "slds-show");
				$A.util.addClass(component.find("tooltip"), "slds-hide");
			}, 50);*/
		//}
        
		component.set("v.activePath", tabId);
        //Rohit replaced commercialTab to AadharTab
		if (tabId == 'AadharTab') {
            if(component.get("v.hideAadhaarSection") == false){//added if condition for 21851     
			component.set("v.disablePrev", true);
			component.set("v.StageNum", 1);
            }
		} else if (tabId == 'DisbursementTab') {
			component.set("v.disableNext", true);
            //added if else condition for 21851 start
                if(component.get("v.hideAadhaarSection") == false){
                     component.set("v.StageNum",6);
                }
                else if(component.get("v.hideAadhaarSection") == true){
                    component.set("v.StageNum",5);
                }   //added if else condition for 21851 end
		}  else if (tabId == 'commercialTab') {
            //added if else condition for 21851 start
            
                if(component.get("v.hideAadhaarSection") == false){
                    
                     component.set("v.StageNum",2);
                }
                else if(component.get("v.hideAadhaarSection") == true){
                    component.set("v.disablePrev", true);
                    component.set("v.StageNum",1);
                }   //added if else condition for 21851 end           
		}else if (tabId == 'InsuranceTab') {
            //added if else condition for 21851 start
                if(component.get("v.hideAadhaarSection") == false){
                     component.set("v.StageNum",3);
                }
                else if(component.get("v.hideAadhaarSection") == true){
                    component.set("v.StageNum",2);
                }   //added if else condition for 21851 end
            
		} else if (tabId == 'LineEligibilityTab') {
            //added if else condition for 21851 start
                if(component.get("v.hideAadhaarSection") == false){
                     component.set("v.StageNum",4);
                }
                else if(component.get("v.hideAadhaarSection") == true){
                    component.set("v.StageNum",3);
                }   //added if else condition for 21851 end     
		} else if (tabId == 'feesTab') {
            //added if else condition for 21851 start
                if(component.get("v.hideAadhaarSection") == false){
                     component.set("v.StageNum",5);
                }
                else if(component.get("v.hideAadhaarSection") == true){
                    component.set("v.StageNum",4);
                }   //added if else condition for 21851 end
		}

	},
	fetchItem: function (component, container, items, isNext) {
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
				return i == 0 ? $(items[items.length - 1]) : $(items[i - 1]);
			}
		}

		//nothing found
		return null;
	},
	showHideDiv: function (component, divId, show) {
		$A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
		$A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
	},
	fetchPricingPickListVal: function (component, fieldName, elementId) {
		console.log('inside pricinf');
		var action = component.get("c.getSelectPicklistOPtions");
		action.setParams({
			"objObject": component.get("v.loanApplication"),
			"fld": fieldName
		});
		action.setCallback(this, function (response) {
			if (response.getState() == "SUCCESS") {
				var allValues = response.getReturnValue();
				console.log('allValues+' + allValues);
				component.set("v.loanTypeList", allValues);
			}
		});
		$A.enqueueAction(action);
	},
	showSpinner: function (component) {
		this.showHideDiv(component, "waiting", true);
	},
	hideSpinner: function (component) {
		this.showHideDiv(component, "waiting", false);
	},
	showHideDiv: function (component, divId, show) {
		//console.log('divId>>' + divId + '  ' + show);
		$A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
		$A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");

	},
    
    /*Bug 18669 Start*/
     getEKYCRec : function(component,randomNum){
        console.log('randomNum inside helper '+randomNum);
        this.executeApex(component, "getEkycRec", {ranNum: randomNum}, function(error, result){
            console.log('inside execute apex');
            if(!error && result){
                var data = result;
                console.log('data'+JSON.stringify(data));
                console.log('data.bio_Ekyc__c : '+data.bio_Ekyc__c);
				if(data.bio_Ekyc__c == true){
                    console.log('inside biometric field condition');
					//component.set("v.kyc",data);
					component.set("v.kyc",data);
				}
            }
        });
    },
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()'+response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
    /*Bug 18669 End*/
    
})