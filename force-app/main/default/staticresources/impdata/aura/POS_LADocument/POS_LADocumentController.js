({
    doInit : function(component, event, helper){
        console.log('inside init of');
        helper.getUploadedAttachments(component);
        helper.getDocumentList(component);
    },
    showSpinner : function(component, event, helper){
        $A.util.removeClass(component.find("spinner"),"slds-hide");
    },
    hideSpinner : function(component, event, helper){
        $A.util.addClass(component.find("spinner"),"slds-hide");
    },
    deleteAttachment : function(component, event, helper){
            var id = event.getSource().get("v.value");
            helper.deleteAttachment(component, id);
       
    },
    viewAttachment : function(component, event, helper){
        var id = event.getSource().get("v.value");
        alert(id);
    },
    showUploadedDocs : function(component, event, helper){
        helper.getUploadedAttachments(component);
    },
    setLoanParam : function(component, event, helper){
                var Loan = event.getParam("Loan");
       		    component.set("v.loan",Loan);
        		component.set("v.loanId",Loan.Id)
       			console.log('loan Id is'+Loan.Id);
        		helper.getUploadedAttachments(component);
       		    helper.getDocumentList(component);

    },
      setPOParam : function(component, event, helper){
                var poId = event.getParam("POId");
       		    component.set("v.loanId",poId);
       			console.log('PO ID is'+component.get("v.loanId"));
         	    helper.getUploadedAttachments(component);
       		    helper.getDocumentList(component);

    },
   
   /*  setFilename : function(component, event, helper){
                var filename = component.get("v.Filename");
       		    component.set("v.",Loan);
       			console.log('loan Id is'+Loan);

    },
    */
 
})