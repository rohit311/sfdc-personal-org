trigger updatefields on CIBIL__c (before insert,before update) {
UpdateCibil.UpdateCibilFields(Trigger.new);
}//end of trigger