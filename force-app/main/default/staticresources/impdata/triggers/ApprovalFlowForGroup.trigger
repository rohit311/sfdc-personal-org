trigger ApprovalFlowForGroup on Builder_Group__c(after insert) {  
    for (Builder_Group__c a : Trigger.new) {
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(a.id);
        Approval.ProcessResult result = Approval.process(app);
   }
}