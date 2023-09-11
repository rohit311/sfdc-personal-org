public class AmountCheckClass {

  public  void submitAndProcessApprovalRequest(){
        
        Expense__c e=new Expense__c(Name='testExp',Amount__c=27,Client__c='pqr Co.',Reimbursed__c=true,Date__c=Date.today());
        insert e;
        
        User submitter=[SELECT Id FROM USER WHERE Alias='rchav'];
        
        //approval request creation
        Approval.ProcessSubmitRequest req=new Approval.ProcessSubmitRequest();
        req.setComments('submitting for approval');
        req.setObjectId(e.Id);
        
        req.setSubmitterId(submitter.id);
 
        req.setProcessDefinitionNameOrId('AmountVerification');
        req.setSkipEntryCriteria(false);
        
        Approval.ProcessResult result=Approval.process(req);
        
        System.assert(result.isSuccess());
        
        System.assertEquals('Pending',result.getInstanceStatus());
      
      //Approving the submitted request
      List<Id> newWorkItemId=result.getNewWorkitemIds();
      
      Approval.ProcessWorkItemRequest req2=new Approval.ProcessWorkitemRequest();
      req2.setComments('Approved...');
      req2.setAction('Approve');
      req2.setNextApproverIds(new Id[]{UserInfo.getUserId()});
      
      req2.setWorkitemId(newWorkItemId.get(0));
      
      Approval.ProcessResult result2=Approval.process(req2);
      
      System.assert(result2.isSuccess());
    }
}