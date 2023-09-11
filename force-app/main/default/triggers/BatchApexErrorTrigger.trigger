trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {

    List<BatchLeadConvertErrors__c> batchErrosList = new List<BatchLeadConvertErrors__c>();
    
    for(BatchApexErrorEvent batchRec : trigger.new){
        BatchLeadConvertErrors__c batchErrorRec = new BatchLeadConvertErrors__c();
        batchErrorRec.AsyncApexJobId__c = batchRec.AsyncApexJobId;
        batchErrorRec.Records__c = batchRec.JobScope;
        batchErrorRec.StackTrace__c = batchRec.StackTrace;
        
        batchErrosList.add(batchErrorRec);        
    }
    
    if(batchErrosList.size() > 0){
        insert batchErrosList;
    }
    
}