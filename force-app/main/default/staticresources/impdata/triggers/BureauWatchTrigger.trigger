trigger BureauWatchTrigger on Loan__c (before update) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        for(Loan__c loanObj : Trigger.New) {
            if(loanObj.CreatedDate != System.now() && loanObj.CreatedDate.format('HH:mm:ss') != System.now().format('HH:mm:ss')) {
                loanObj.Is_Created_By_API__c = false;
            }
        }
    }
}