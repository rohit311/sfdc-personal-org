trigger UpdateLOanApplication on SOL_Policy__c (after insert) {
    List<Opportunity> Loan = new List<Opportunity>();
    //Bug:25832 : Bug 24640
    List<Salaried__c> salaried = new List<Salaried__c>();
    if (!ControlRecursiveCallofTrigger_Util.hasSolPolicyLoan()) {
        ControlRecursiveCallofTrigger_Util.setSolPolicyLoan();
        ControlRecursiveCallofTrigger_Util.setalreadyExecutedProcessFlow();
        Loan = [select id, StageName from Opportunity where id=: Trigger.New[0].Loan_Application__C];
        //Bug:25832 : Bug 24640
        salaried = [select id, name, Process_type__c, Loan_Application__c, Product_Offerings__c from Salaried__c where id=: Trigger.New[0].Salaried__c];
        For(SOL_Policy__c policy : Trigger.New)
        {
            if(Loan.size()>0 && policy.Policy_Status__c=='Rejected' && Loan[0].StageName=='Incomplete Application')
            {
                Loan[0].StageName='Auto Rejected';
                Update Loan[0];
            }
            /*Bug:25832 : Bug 24640 : S*/
            if(Loan != null && Loan.size() > 0 && salaried != null && salaried.size() > 0 && salaried[0].Process_type__c == 'Pre approved' && policy.Policy_Status__c == 'Rejected' && salaried[0].Loan_Application__c != null)
            {
                Loan[0].StageName='MCP Reject';
                Update Loan[0];
            }
            /*Bug:25832 : Bug 24640 : E*/
        } 
    }
}