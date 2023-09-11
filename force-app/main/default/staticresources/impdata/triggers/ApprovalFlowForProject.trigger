trigger ApprovalFlowForProject on Project_Master__c (after insert) {  
    for (Project_Master__c a : Trigger.new) {
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(a.id);
        Approval.ProcessResult result = Approval.process(app);
   }
}