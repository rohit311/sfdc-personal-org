({
	    startSearch: function (component, key) {
         
         console.log ('startSearch');
        var keyword = component.get("v." + key + "SearchKeyword");
        console.log("keyword" + keyword+"key"+key);
       
        if(key == 'source')
        {
            if (keyword.length > 2 && !component.get('v.sourcesearching')) {
                console.log("keyword sourcesearching" + keyword+"key"+key);
                component.set('v.sourcesearching', true);
                component.set('v.oldSearchKeyword', keyword);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
    },
    
    
    searchHelper: function (component, key, keyword) {
        console.log('executeApex>>' + keyword + '>>key>>' + key);
        console.log ('searchHelper');
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord': keyword
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
            }
        });
    },

    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    
    handleSearchResult: function (component, key, result) {
      
        
        console.log ('handleSearchResult');
        console.log ('key ='+key);
        if(key == 'source')
        {
            component.set('v.sourcesearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                this.openCloseSearchResults(component, key, true);
            }
            
        }
    },
    
        executeApex: function(component, method, params,callback){
        
        console.log ('executeApex:helper');
        console.log('params'+JSON.stringify(params));
        console.log('method name is '+method)
        var action = component.get("c."+method); 
        

        action.setParams(params);
		
        action.setCallback(this, function(response) {
            
			console.log ('after database operations');
            console.log ('response='+response);
            var state = response.getState();
            console.log('state is '+state);
            
			if(state === "SUCCESS"){
                console.log ('after db ops state SUCCESS');
                console.log('response.getReturnValue()123'+response.getReturnValue());
                callback.call(this,null, response.getReturnValue());
            }
            
			else if(state === "ERROR") 
			{
                console.log ('after db ops state ERROR');
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message)
					{
                        errors.push(item.message);
                    }
                }
                callback.call(this,errors, response.getReturnValue());
            }
        });
        
		
		$A.enqueueAction(action);
    }

})