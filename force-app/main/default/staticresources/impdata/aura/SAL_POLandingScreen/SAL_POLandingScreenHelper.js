({
    savePODetailData: function(component, objPO ,leadObj,scam){   
        var isInValidMsg = true;
        /*var poProduct = component.find("productTypeId");
        if(poProduct.get("v.validity").valid)
            console.log('poProduct'+isInValidMsg);
        else{
            poProduct.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }*/
        console.log('objPO is : '+JSON.stringify([objPO]));
        console.log('leadObj inside savePODetailData before : '+JSON.stringify([leadObj]));
        console.log('scam is : '+JSON.stringify([scam]));
        
        leadObj.Employer__c = component.get('v.segId');
        var action = component.get('c.savePO');  
        action.setParams({
            "jsonPOrecord": JSON.stringify([objPO])+';'+JSON.stringify([leadObj])+';'+JSON.stringify([scam])
        });
        console.log('leadObj inside savePODetailData after: '+JSON.stringify([leadObj]));
        action.setCallback(this,function(response){
            console.log('leadObj inside savePODetailData : '+JSON.stringify([leadObj]));
            var state = response.getState();
            //alert("state++"+state);
            if(state == 'SUCCESS')
            {
                console.log(response.getReturnValue());
                component.set("v.productOffering",JSON.parse(response.getReturnValue()));//Added JSON.parse forBug 17749
                this.displayToastMessage(component,event,'Success','Data Saved Successfully','success');
                this.showhidespinner(component,event,false);
            }
            else
            {
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Failed To Save Data','error');
            }
        });
        
        if(isInValidMsg == true)
        {            
            $A.enqueueAction(action);
        }
        else
            this.displayToastMessage(component,event,'Info','Please Fill All Required Fields','info'); 
        
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
    /*Bug 18576 Start*/
    openCloseSearchResults: function (component, key, open) {
		var resultPanel = component.find(key + "SearchResult");
		$A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
		$A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
	},
	startSearch: function (component, key) {
        console.log('inside startSearch');
        var keyword = component.get("v." + key + "SearchKeyword");
		if (keyword.length > 2 && !component.get('v.searching')) {
			component.set('v.searching', true);
			component.set('v.oldSearchKeyword', keyword);
			this.searchHelper(component, key, keyword);
		} else if (keyword.length <= 2) {
			component.set("v." + key + "List", null);
			this.openCloseSearchResults(component, key, false);
		}
	},
	searchHelper: function (component, key, keyword) {
        console.log('searchHelper'+keyword);
		this.executeApex(component, "fetch" + this.toCamelCase(key), {
			'searchKeyWord': keyword
		}, function (error, result) {
			if (!error && result) {
				this.handleSearchResult(component, key, result);
			}
		});
	},
	handleSearchResult: function (component, key, result) {
        console.log('inside handleSearchResult');
		component.set('v.searching', false);
		if (component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
			component.set("v." + key + "List", null);
			this.startSearch(component, key);
		} else {
			component.set("v." + key + "List", result);
            this.showHideMessage(component, key, !result.length);
			this.openCloseSearchResults(component, key, true);
		}
	},
	toCamelCase: function (str) {
		return str[0].toUpperCase() + str.substring(1);
	},
	executeApex: function (component, method, params, callback) {
		var action = component.get("c." + method);
		action.setParams(params);
		console.log('calling method' + method);
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log('response.getReturnValue()' + JSON.stringify(response.getReturnValue()));
				callback.call(this, null, response.getReturnValue());
			} else if (state === "ERROR") {
				console.log('error');
				console.log(response.getError());

				var errors = ["Some error occured. Please try again. "];
				var array = response.getError();
				for (var i = 0; i < array.length; i++) {
					var item = array[i];
					if (item && item.message) {
						errors.push(item.message);
					}
				}
				console.log('calling method failed ' + method);
				callback.call(this, errors, response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},
	showHideMessage: function (component, key, show) {
		component.set("v.message", show ? 'No Result Found...' : '');
		this.showHideDiv(component, key + "Message", show);
	},
	showHideDiv: function (component, divId, show) {

		$A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
	}
    /*Bug 18576 End*/
    
})