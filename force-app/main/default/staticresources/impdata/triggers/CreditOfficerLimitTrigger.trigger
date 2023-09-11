trigger CreditOfficerLimitTrigger on Credit_Officer_Limit__c (before insert,before update) 
{
    if((trigger.isBefore && trigger.isInsert) || (trigger.isBefore && trigger.isUpdate))
    {
        boolean executeLogic = false;
        if(Label.CheckCOLCityCount != null && string.isNOtBlank(Label.CheckCOLCityCount))
            executeLogic = boolean.valueOf(Label.CheckCOLCityCount);
        if(executeLogic)
        {
            CreditOfficerLimitTriggerHandler COLTriggerHandler = new CreditOfficerLimitTriggerHandler(trigger.new,trigger.oldMap); 
            COLTriggerHandler.appendRuralServingCities();
            COLTriggerHandler = null;
        }
    }
}