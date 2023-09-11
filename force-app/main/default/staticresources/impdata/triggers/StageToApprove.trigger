trigger StageToApprove on SOL_CAM__c (after update) {
List<Opportunity> Loan = new List<Opportunity>();
//List<SOL_CAM__c> sol= new List<SOL_CAM__c>();

if(Trigger.New[0].Product__c == 'LASOL'){
Loan=[select Product__c, StageName,Approval_Stages__c,Approver__c from Opportunity where id=:Trigger.New[0].Loan_Application__c];
//sol=[select Loan_Amount_Selected_by_Customer__c, Tenure_Selected_By_Customer__c from SOL_CAM__c where id=:Trigger.New[0].Loan_Application__c]
}
  if(Loan.size()>0 && Loan[0].Product__c=='LASOL' && Loan[0].StageName=='Auto Approved' && Trigger.New[0].Loan_Amount_Selected_by_Customer__c!=null &&Trigger.New[0].Tenure_Selected_By_Customer__c!=null)
        {
            Loan[0].StageName='Auto Approved Accepted';
            Loan[0].Approval_Stages__c='Auto Approved Accepted';
            Loan[0].Approver__c='System Administrator';
            update Loan[0];
        }

}