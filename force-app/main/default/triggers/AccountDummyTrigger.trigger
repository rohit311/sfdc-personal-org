trigger AccountDummyTrigger on Account (before update) {

  for (Account acc : Trigger.new) {
    if (Trigger.oldMap.get(acc.Id).Dummy_Timestamp__c != Trigger.newMap.get(acc.Id).Dummy_Timestamp__c && acc.Dummy_Timestamp__c != null) {
      // populate the date
      acc.Age__c = String.valueOf(Date.valueOf(acc.Dummy_Timestamp__c).daysBetween(System.today()));
    }
  }

}