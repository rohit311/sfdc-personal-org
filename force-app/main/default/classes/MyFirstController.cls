public class MyFirstController{
public Account account;
public Contact con;

public Contact getCon()
{
       if(con==null)
       {
          this.con=[select id from Contact where id=:ApexPages.currentPage().getParameters().get('id')];

       }
       return this.con;
}
public Account getAccount()
{
     if(account==null)
     {
    this.account=[select id from Account where id=:ApexPages.currentPage().getParameters().get('id')];
    return this.account;

       }
       
        return null;
}

public PageReference save()
{
    update account;
    update con;
    return null;
}


}