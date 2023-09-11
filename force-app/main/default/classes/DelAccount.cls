public class DelAccount {

    public PageReference DelAcc() {
    Account delA=[Select ID from Account where ID=:DelID];
    Delete delA;
        return null;
    }
public String DelID{get;set;}
public List<Account> Ac{get{
List<Account> a=[Select ID,Name from Account limit 100];
return a;
}set;}
}