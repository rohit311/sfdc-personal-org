trigger CL_calculateCashFlowSummary on CL_Cashflow__c (after insert, after update) {
    Set<String> oppIds = new Set<String>();
    Set<String> oppYearSet = new Set<String>();
    List<CL_Cashflow__c> cashFlowLst = new List<CL_Cashflow__c>();
    Set<String> oppNYearSet = new Set<String>();
    Map<String,CL_Cashflow__c> cashFlowSummaryMap = new Map<String,CL_Cashflow__c>();
    //try{
    for(CL_Cashflow__c c: Trigger.new){
        if(c.type__c == 'Latest Audited' && !oppNYearSet.contains(c.Current_Year__c + c.Loan_Application_Number__c))
            oppIds.add(c.Loan_Application_Number__c);
            oppNYearSet.add(c.Current_Year__c + c.Loan_Application_Number__c);
            
    }
    for(CL_Cashflow__c cflow : [select CL_PL_BS__c,Previous_Year_CL_PL_BS__c,type__c,Current_Year__c,
                            Loan_Application_Number__c from CL_Cashflow__c
                            where Loan_Application_Number__c in: oppIds and type__c = 'Latest Audited Summary']){
            cashFlowSummaryMap.put(cflow.Current_Year__c + cflow.Loan_Application_Number__c,cflow);
    }
    List<CL_PL_BS__c> tmpLst = [select id,loan_app__r.Loan_Application_Number__c,year__c from cl_pl_bs__c 
    where loan_app__r.Loan_Application_Number__c in: oppIds  and type__c ='Summary' order by year__c];
    
    for(Integer i=0;i<tmpLst.size();i++){
    //For(CL_PL_BS__c : {
        Boolean objCreated = false;
        CL_Cashflow__c cashFlowSum;
        if(cashFlowSummaryMap.size()>0 && cashFlowSummaryMap.containsKey(tmpLst.get(i).year__c + tmpLst.get(i).loan_app__r.Loan_Application_Number__c)){
            cashFlowSum = cashFlowSummaryMap.get(tmpLst.get(i).year__c + tmpLst.get(i).loan_app__r.Loan_Application_Number__c);
            objCreated = true;
        }
        
        else if (oppNYearSet.contains(tmpLst.get(i).year__c + tmpLst.get(i).loan_app__r.Loan_Application_Number__c)){
            cashFlowSum = new CL_Cashflow__c();
            objCreated = true;
            
        }
        if(objCreated){
        if(i>=0 && tmpLst.get(i).id != null)
            cashFlowSum.CL_PL_BS__c = tmpLst.get(i).id;
        if(i-1 >=0 && tmpLst.get(i-1).id != null)
            cashFlowSum.Previous_Year_CL_PL_BS__c = tmpLst.get(i-1).id;
            cashFlowSum.type__c = 'Latest Audited Summary';
            cashFlowLst.add(cashFlowSum);
         }   
            
    }
    if(cashFlowLst.size()>0)
        upsert cashFlowLst;
    
    /*}
    catch(Exception e){
    } */   
                
}