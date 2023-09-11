public with sharing class BrokerTriggerHandler extends TriggerHandler{
	private List<Broker__c> brokerList = new List<Broker__c>();
    
    public BrokerTriggerHandler(){
        brokerList = (List<Broker__c>)Trigger.new;
    }
    
    public override void beforeInsert() {
        System.debug('in beforeInsert');
        //TriggerHandler.bypassTrigger('PropertyTriggerHandler');
        BrokerTriggerHandler.insertProperty(brokerList[0].Name);
    }
    
    public static void insertProperty(String brokerName){
        Property__c prop = new Property__c(Name = brokerName);
        insert prop;
    }
}