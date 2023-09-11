({
	doInit : function(component, event, helper) {
        console.log('doinit log...')
       
        helper.setFieldData(component);
        //if (component.get("v.isInsurancePosLaFlow") == true && component.get("v.shouldBeDisable") == true && component.get("v.loanStage") != 'Post Approval Sales' ){
        if (component.get("v.shouldBeDisable") == true && component.get("v.loanStage") != 'Post Approval Sales' ){
        	console.log('---------------------<>1 ' + component.get("v.loanStage"));
            component.set("v.isReadOnly", true);
        }
	}, 
    
    assignInsuranceList : function(component, event, helper) {
        component.set("v.insuranceObjList",event.getParam("insuranceList"));
        var compEvents = $A.get("e.c:CalculateDisburseAmountEvent");
        console.log('CalculateDisburseAmountEvent ===>> '+compEvents);
        compEvents.fire();
	},
    
    disableInsuranceForm : function(component, event, helper) {
        if(event.getParam("loanStage") == 'Branch Ops' || event.getParam("loanStage") == 'Moved To Finnone') {
            component.set("v.isReadOnly", true);
        }
    }
})