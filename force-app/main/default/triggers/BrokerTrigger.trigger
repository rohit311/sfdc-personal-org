trigger BrokerTrigger on Broker__c (before insert) {

    //BrokerTriggerHandler.insertProperty(trigger.new[0].Name);
    new BrokerTriggerHandler().run(); 
}