({
    startSearch: function (component, key) {
        console.log('Kye is '+key);
        
        if(key == 'Employer')
        {
             component.set("v.CityList", null);
             var keyword = component.find("employer").get("v.value");
             if (keyword.length > 2 && !component.get('v.empsearching')) {
                console.log("keyword empsearching" + keyword+"key"+key);
                component.set('v.empsearching', true);
                component.set('v.oldSearchKeyword', keyword);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
        if(key == 'City')
        {
            var keyword = component.find("City").get("v.value");
            if (keyword.length > 2 && !component.get('v.areasearching')) {
                component.set('v.areasearching', true);
                component.set('v.oldAreaKeyword', keyword);
                console.log('Key is '+key);
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
    },
     searchHelper: function (component, key, keyword) {
        console.log('executeApex>>' + keyword + '>>key>>' + key);
        
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord': keyword
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
            }
        });
    },
    executeApex: function(component, method, params,callback){
           var action = component.get("c."+method); 
           action.setParams(params);
           action.setCallback(this, function(response) {
                  var state = response.getState();
                  if(state === "SUCCESS"){
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    handleSearchResult: function (component, key, result) {
        if(key == 'Employer')
        {
            component.set('v.empsearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldSearchKeyword') !== component.find("employer").get("v.value")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                this.openCloseSearchResults(component, key, true);
            }
        }
        if(key == 'City')
        {
            component.set('v.areasearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldAreaKeyword') !==  component.find("City").get("v.value")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                this.openCloseSearchResults(component, key, true);
            }
        }
    },
      openCloseSearchResults: function (component, key, open) {
             var resultPanel = component.find(key + "SearchResult");
             $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
             $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    isCitySelected :  function (component, key) {
       
        if(component.get("v.isCitySelected")==true){
           
             return true;
         }
		return false;        
       
            return true;
        
    },
     isEmployerSelected:  function (component, key ) {
         
         if(component.get("v.isEmployerSelected")==true){
           
             return true;
         }
		return false;        
       
         
    }
    
})