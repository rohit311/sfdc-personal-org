({
    
    scriptsLoaded : function(component, event, helper) {
       console.log('load successfully1');
      
       $(".select2Class").select2({
            placeholder: "Select Multiple values"
        });
        helper.showhidespinner(component,event,false);
        
    },
    
    doInit: function(component, event, helper) {
               console.log('in do init of multi');
        helper.showhidespinner(component,event,true);

    },
    
    bindData : function(component, event, helper) {
        
        var selectedSkills = $('[id$=picklist]').select2("val");
        var values = '';
         console.log('bindData'+selectedSkills);
        for(var i=0;i< selectedSkills.length;i++){
            values = values+ selectedSkills[i]+';';
            console.log('hival'+selectedSkills[i]);
        }
       console.log('bindDatavalues'+values);
        component.set("v.mySelectedvalues",values);
        return values;
    },
    setRejectReason : function(component, event, helper) {
        var data = event.getParam('arguments');
        console.log('setRejectReason'+data.reason);
        var reason =[];
        if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.reason) && data.reason.includes(';'))
        	reason = data.reason.split(";");
        else if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.reason) && data.reason.includes(','))
        	reason = data.reason.split(",");
        else
            reason = data.reason;

            
    
         console.log('setRejectReason1'+reason);
        var data = component.get("v.options");
        setTimeout(function(){ 
        for(var i=0; i < data.length; i++){
            if(!$A.util.isEmpty(reason) && reason.includes(data[i]))
                $("#picklist").append('<option value="'+data[i]+'" selected="selected">'+data[i]+'</option>');
            else
                $("#picklist").append('<option value="'+data[i]+'">'+data[i]+'</option>');
        	}
       }, 3000);
    },
   
        
        
        
    })