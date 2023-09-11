public class OAA_Controller {

   public Opportunity opp{get;set;}
    
    public OAA_Controller(){
        opp=[SELECT Probability,CloseDate,TotalOpportunityQuantity FROM Opportunity Limit 1];
        
    }
    
    public void submit(){
        update opp;
        
        Approval.ProcessSubmitRequest request=new Approval.ProcessSubmitRequest();
        User submitter=[SELECT Id FROM USER WHERE Alias='rchav'];
        request.setComments('submitting for approval');
        request.setObjectId(opp.Id);
        
        request.setSubmitterId(submitter.Id);
        
        request.setProcessDefinitionNameOrId('Order_Number_Approval');
        
        request.setSkipEntryCriteria(false);
        
        Approval.ProcessResult result=Approval.process(request);
        
        System.assert(result.isSuccess());
        
        
    }
}