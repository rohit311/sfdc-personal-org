public class ContactController {
    @AuraEnabled
    public static void createContact(Contact newContact){
        System.debug('### newContact : ' + newContact);
        upsert newContact;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(){
        System.debug('here');
        return [SELECT Id, Name, Title, Phone, Email FROM Contact ORDER BY Name LIMIT 5];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        System.debug('here');
        throw new AuraHandledException('Forced error');
        return [SELECT FirstName, LastName, Email FROM Contact];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> fetchContacts(String conName){
        System.debug('here '+conName );
        String clause = '%'+conName+'%';
        return [SELECT Id, Name, Title, Phone, Email FROM Contact WHERE Name LIKE :clause];
    }

    @AuraEnabled
    public static void saveContacts(List<Contact> contactList) {

      if(contactList != null && contactList.size() > 0) {
        update contactList;
      }

    }
}