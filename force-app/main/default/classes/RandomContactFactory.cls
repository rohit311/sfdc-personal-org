public class RandomContactFactory {

public static List<Contact> generateRandomContacts(Integer i,String lname)
{
    List<Contact> con=new List<Contact>();
    for(Integer j=0;j<i;j++)
    {
        Contact c=new Contact(FirstName='Test'+j);
        con.add(c);
    }
    return con;
   
}    
    
}