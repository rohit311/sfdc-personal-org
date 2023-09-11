public class ContactSearch {

   public static List<Contact> searchForContacts(String lname,String mailingp)
       {

           List<Contact> con=[select FirstName,Lastname from Contact where LastName=:lname AND MailingPostalCode=:mailingp];
           return con;
       }

  // 78
  public static void updateContactNames() {
    List<Contact> contactList = [SELECT FirstName FROM Contact LIMIT 100];

    for (Contact conRec : contactList) {
      conRec.LastName = 'Testing';
    }

    update contactList;
  }
}