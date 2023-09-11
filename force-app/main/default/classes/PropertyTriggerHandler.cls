public class PropertyTriggerHandler extends TriggerHandler{

    public PropertyTriggerHandler(){
        System.debug('in Property__c trigger');
    }
    
    public override void beforeInsert(){
        System.debug('in before Insert - Property__c trigger');
    }
    
    public override void afterInsert(){
        System.debug('in after Insert - Property__c trigger');
    }
    
}