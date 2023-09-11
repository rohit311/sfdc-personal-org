public class democall_controller {

public String firstname{get;set;}
public String Lastname{get;set;}
public PageReference demo1()
{
Contact cnew=new Contact(Firstname=firstname,LastName=lastname);
insert cnew;
return null;
}
}