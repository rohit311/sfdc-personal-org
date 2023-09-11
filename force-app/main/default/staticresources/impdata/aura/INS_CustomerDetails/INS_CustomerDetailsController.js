({
	initCustDetails : function(component, event, helper) {
		helper.loadCustData(component, event, helper);
    },
    getDpndntPkl : function(component, event, helper){
        helper.getDpndntPklHelper(component, event, helper);
    },
    chSubDisp : function(component, event, helper){
        var selectedDisp = component.get("v.selectedDisp");
       	var selectedSubDisp = component.get("v.selectedSubDisp");
        if(selectedDisp && selectedSubDisp && (selectedDisp=="Appointment" && selectedSubDisp == "Meeting (F2F)") || (selectedDisp=="Follow Up" && (selectedSubDisp == "Telephonic" || selectedSubDisp == "Meeting"))){
            component.set("v.shwMeetInp", true);
        }
        else{
            component.set("v.shwMeetInp", false);
        }
        var appntFields = helper.returnAppFields();
        console.log("appntFields: "+appntFields);
        if(!component.get("v.shwMeetInp")){
            for(var i = 0; i< appntFields.length; i++){
                // console.log("appntFields: "+component.get(appntFields[i]));
                component.set(appntFields[i], "");
            }
        }
    },
    toggletab : function(component, event, helper) {
        helper.toggleAccordion(component, event);
    },
    backToMainCmp: function(component,event,helper){
        helper.backToMainHelper(component,event,helper);
    },
    setTabData: function(component,event,helper){
         helper.setTabDataHelper(component,event,helper);
    },
    submitDetails: function(component,event,helper){
        helper.saveDemogDetHelper(component,event,helper);
    },
    saveInteraction: function(component, event, helper){
        helper.saveIntHelper(component, event, helper);
    },
    sendInsProductDetails: function(component, event, helper){
		helper.sendInsProductDetailsHelper(component, event, helper);
    },
	getProdFeatures: function(component, event, helper){
		helper.getProdFeaturesHelper(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        helper.closeModelCall(component, event);
    },
    setPrefAddr: function(component,event,helper){
        var selected = event.getSource().getLocalId();
        component.set("v.prefAddr",selected);
    },
    handleShowModal: function(component, evt, helper) {
        console.log("INSIDE MODAL!");
        var modalBody;
        var recId= "BAGIC- Family Health Care Gold";
        
        $A.createComponent("c:ModalTest", {recordId:recId},
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Contact Quick Edit",
                       body: modalBody, 
                       showCloseButton: true,
                       closeCallback: function() {
                           alert('You closed the modal!');
                       }
                   })
               }                               
           });
    },
	next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
   }

})