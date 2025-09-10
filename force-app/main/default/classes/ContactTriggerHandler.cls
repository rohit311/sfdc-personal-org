public without sharing class ContactTriggerHandler {
   public static void beforeInsertHandler(List<Contact> contacts) {
    System.debug('In beforeInsertHandler');

    Set<Id> accountIds = getAccountIdsForActiveContacts(contacts);
    Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Address__c FROM Account WHERE Id IN :accountIds]);

    for (Contact conRec : contacts) {
        Boolean updateContactAddress = conRec.Is_Active__c && accountsMap.containsKey(conRec.AccountId);
        conRec.Contact_Address__c = updateContactAddress ? accountsMap.get(conRec.AccountId).Address__c : conRec.Contact_Address__c;
    }
   }

   public static void afterUpdateHandler(Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
    System.debug('In afterUpdateHandler');

    Map<Id, Account> accountsToUpdate = new Map<Id, Account>();

    for (Contact conRec : newMap.values()) {
      String oldAddress = String.valueOf(oldMap.get(conRec.Id).Contact_Address__c);
      String newAddress = String.valueOf(newMap.get(conRec.Id).Contact_Address__c);
      Boolean contactAddressIsUpdated = !oldAddress.equalsIgnoreCase(newAddress);

      if (contactAddressIsUpdated && conRec.Is_Active__c == true) {
        accountsToUpdate.put(conRec.AccountId, new Account(Id = conRec.AccountId, Address__c = conRec.Contact_Address__c));
      }
    }

    if (!accountsToUpdate.isEmpty()) {
      System.debug('Account updated');
      update accountsToUpdate.values();
    } else {
      return;
    }

    List<Contact> contactsToUpdate = [SELECT Contact_Address__c, Account.Address__c FROM Contact WHERE AccountId IN :accountsToUpdate.keySet() AND Is_Active__c = true];

    if (contactsToUpdate.size() == 0) {
      return;
    }

    for (Contact conRec : contactsToUpdate) {
      if (!conRec.Contact_Address__c.equalsIgnoreCase(conRec.Account.Address__c)) {
        conRec.Contact_Address__c = conRec.Account.Address__c;
      }
    }

    System.debug('Contacts updated !');
    update contactsToUpdate;

   }

   private static Set<Id> getAccountIdsForActiveContacts(List<Contact> contacts) {
    Set<Id> accountIds = new Set<Id>();

    for (Contact conRec : contacts) {
        if (conRec.Is_Active__c == true) {
        	accountIds.add(conRec.AccountId);
        }
    }

    return accountIds;
   }
}