public class Util {

    @future
    public static void insertUsrWithRole(string uname,string al,string em,string lname)
    {
        Profile p=[SELECT Id FROM Profile WHERE Name='Identity User'];
        UserRole r=[SELECT Id FROM UserRole WHERE Name='COO'];
        
        User u=new User(alias=al,email=em,emailencodingkey='UTF-8',lastname=lname,
                        languagelocalekey='en_US',localesidkey='en_US',profileid=p.Id,
                       UserRoleid=r.Id,timezonesidkey='America/Los_Angeles',
                       username=uname);
        insert u;
    }
    
}