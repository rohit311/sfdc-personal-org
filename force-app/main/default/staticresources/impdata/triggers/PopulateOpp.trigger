trigger PopulateOpp on Bank_Transaction__c (before insert) {
	List<Bank_Account__c> bankAcc = new List<Bank_Account__c>();
	List<Id> bankAccId = new List<Id>();

	for(Bank_Transaction__c trans:trigger.new){
		bankAccId.add(trans.Bank_Account__c);
	}
	Map<Id,Bank_Account__c> bankaccMap = new Map<Id,Bank_Account__c>([Select id, Loan_Application__c,Send_Email_For_Perfios__c, Perfios_Flag__c From Bank_Account__c where  Send_Email_For_Perfios__c = true and id in :bankAccId]);
	System.debug('**********bankaccMap: '+bankaccMap);
	for(Bank_Transaction__c trans:trigger.new){
		if(bankaccMap.get(trans.Bank_Account__c) != null && bankaccMap.get(trans.Bank_Account__c).Send_Email_For_Perfios__c){
			trans.Loan_Application__c = bankaccMap.get(trans.Bank_Account__c).Loan_Application__c;
		}
	}
}