({
    doInit : function(component, event, helper) {
        component.set("v.Spinner",true);
        helper.fetchData(component, event);
    },
    handleFieldsChange : function(component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.SelectedFieldsList", selectedValues);
        if(component.get("v.sortParams")[1] != ''){
        	$A.enqueueAction(component.get('c.setqueryForSort'));
        }
        helper.setQuery(component, event);
        console.log(component.get("v.SelectedFieldsList"));
    },
    fetchFields : function(component, event, helper){
        var sortParams = component.get("v.sortParams");
        sortParams[1] = '';
        component.set("v.sortParams",sortParams);
        component.set("v.Spinner",true);
        component.set("v.queryStr","");
        component.set("v.Obj",component.find("objSel").get("v.value"));
        component.set("v.SelectedFieldsList",[]);
        helper.getFields(component, event);
        
    },
    setqueryForSort : function(component, event, helper){
        
        if(component.get("v.queryStr") != ''){
            var query = component.get("v.queryStr").split(component.get("v.sortParams")[0]);
            if(component.get("v.sortParams") != null){
                component.set("v.queryStr",query[0] +component.get("v.sortParams")[0]+ component.get("v.sortParams")[1]+' '+component.get("v.sortParams")[2]+' '+component.get("v.sortParams")[3]);
            }
        }
        else{
            component.set("v.queryStr","");
            
        }
    },
    fetchData : function(component, event, helper){
        helper.getData(component, event);
        
        
        
    }
})