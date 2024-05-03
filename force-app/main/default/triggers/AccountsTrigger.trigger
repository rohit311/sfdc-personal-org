trigger AccountsTrigger on Account (after delete, after insert, after update, after undelete, before delete, before insert, before update) {
    //fflib_SObjectDomain.triggerHandler(Accounts.class);

    /*if (Trigger.isAfter && Trigger.isUpdate) {
      List<Opportunity> oppsList = [SELECT dom__c, CreatedDate, StageName FROM Opportunity WHERE AccountId IN :Trigger.new];
      List<Opportunity> oppsToUpdate = new List<Opportunity>();
      DateTime daysBefore30 = System.now() - 30;

      for (Opportunity oppRec : oppsList) {
        System.debug('condition : '+(oppRec.CreatedDate < daysBefore30));
        if (oppRec.CreatedDate < daysBefore30 && oppRec.stageName != 'Closed Won') {
          oppRec.dom__c = System.now();
          oppsToUpdate.add(oppRec);
        }
      }

      if (oppsToUpdate.size() > 0) {
        update oppsToUpdate;
      }
    }
    else if (Trigger.isBefore && Trigger.isUpdate) {
      Map<Id, Double> amountMap = new Map<Id,Double>();
      List<AggregateResult> results = [SELECT AccountId, SUM(AMOUNT)totalAmount FROM Opportunity WHERE AccountId IN :Trigger.new GROUP BY AccountId];
      System.debug('Sample debug');
      if (results.size() > 0) {
        for (AggregateResult res : results) {
          amountMap.put((Id)res.get('AccountId'), (Double)res.get('totalAmount'));
        }

        for (Account accRec : Trigger.new) {
          if (amountMap.containsKey(accRec.Id)) {
            accRec.Total_Opportunity_Amount__c = amountMap.get(accRec.Id);
          }
        }
      }
    }*/
}