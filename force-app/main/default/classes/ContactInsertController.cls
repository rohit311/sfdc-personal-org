public class ContactInsertController {

    public String title1{get;set;}
    public String lastname{get;set;}
    
    public PageReference saveContact(){
         Account acc=[SELECT id FROM Account WHERE Name='Smith Enterprises' LIMIT 1];
        system.debug(acc);
        Contact c=new Contact(LastName=lastname,Title=title1,AccountId=acc.id);
        
       
        insert c;
        return null;
    }
}