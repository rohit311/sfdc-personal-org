({
    goBack : function (component, event, helper){
        component.destroy();
        
    },
    saveRepay : function(component, event, helper){
      
        helper.saveRepay(component, event);
    },
    
    doInit : function(component, event, helper){
        // component.set(component.find('umrn').disabled,'true');
        component.set("v.disableSIFields",false);
        
        helper.fetchData(component, event);
        
        window.setTimeout(
            $A.getCallback(function() {
            }), 4000
        );
        //helper.selectRepay(component, event);
    },
    beforeSave : function(component, event, helper){
        this.showhidespinner(component,event,true);
    },
    handleSuccess : function(component, event, helper){
        helper.handleSuccess(component,event);
    },
    ifscOnBlur : function(component, event, helper){
        helper.handleOnBlur(component, event, "IFSC_Code__c");
    },
    micrOnBlur : function(component, event, helper){
        helper.handleOnBlur(component, event, "MICR__c");
    },
    selectRepay : function(component, event, helper){
        helper.selectRepay(component, event);
    },
    handleOnLoad : function(component, event, helper){
        helper.handleOnLoad(component, event);
    },
    copyperfiosDetails: function(component, event, helper){//added for 22017
        helper.copyperfiosDetails(component, event);
    },
    checkDuplicateBarcode:function(component, event, helper){
        helper.checkDuplicateBarcode(component, event);
    },
    //Added by swapnil
    HandleChangeECSFacility :  function(component, event, helper) {
        helper.HandleChangeECSFacility(component, event);
},
    
    populateECSEndDate :  function(component, event, helper) { //Bug 20391 : Bug 22065 : Added for point 10
        try{
            if( !$A.util.isEmpty(component.get("v.isDisbDashboard")) && component.get("v.isDisbDashboard") == true  ){
                if( !$A.util.isEmpty(component.find("open_valid")) && !$A.util.isEmpty(component.find("open_valid").get("v.value") )  ){
                    component.find("ECS_endDate").set( "v.value", component.find("open_valid").get("v.value") );
                }    
            }
        }catch(e){console.log(e);}
    }
    
})