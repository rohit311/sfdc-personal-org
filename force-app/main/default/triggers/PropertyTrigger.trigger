trigger PropertyTrigger on Property__c (before insert,after insert) {
    //System.debug('in Property__c trigger');
    new PropertyTriggerHandler().run();
}