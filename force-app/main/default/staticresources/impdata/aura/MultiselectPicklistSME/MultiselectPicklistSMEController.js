({
    
    scriptsLoaded : function(component, event, helper) {
       console.log('load successfully1');
      
       $(".select2Class").select2({
            placeholder: "Select Multiple values"
        });
        
    },
    
    doInit: function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                var reason =[];
                var Selectedvalues= component.get("v.mySelectedvalues");
                if(Selectedvalues)
                    reason = Selectedvalues.split(";");
                var selectedId='#'+component.get("v.picklistId");
                var data = component.get("v.options");
                $(selectedId).empty();
                for(var i=0; i < data.length; i++){
                    if(!$A.util.isEmpty(reason) && reason.includes(data[i]))
                        $(selectedId).append('<option value="'+data[i]+'" selected="selected">'+data[i]+'</option>');
                    else
                        $(selectedId).append('<option value="'+data[i]+'">'+data[i]+'</option>');
                }
            }), 300
        );
    },
    
    bindData : function(component, event, helper) {
        debugger;
         var data = event.getParam('arguments');
          var selectedId=data.selectedId;
        var selectedSkills = $('[id$='+selectedId+']').select2("val");
        var values = '';
        if(selectedSkills)
        for(var i=0;i< selectedSkills.length;i++){
            values = values+ selectedSkills[i]+';';
            console.log('hival'+selectedSkills[i]);
        }
       console.log('bindDatavalues'+values);
        component.set("v.mySelectedvalues",values);
        return values;
    },
    setRejectReason : function(component, event, helper) {
        debugger;
        var data = event.getParam('arguments');
        console.log('setRejectReason'+data.reason);
        var selectedId='#'+data.selectedId;
        var reason =[];
        if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.reason))
        reason = data.reason.split(";");
    
        console.log('setRejectReason1'+reason);
        var data = component.get("v.options");
         $(selectedId).empty();
        for(var i=0; i < data.length; i++){
            if(!$A.util.isEmpty(reason) && reason.includes(data[i]))
                $(selectedId).append('<option value="'+data[i]+'" selected="selected">'+data[i]+'</option>');
            else
                $(selectedId).append('<option value="'+data[i]+'">'+data[i]+'</option>');
        }
     
    },
   
        
        
        
    })