public class Chapter7_1_controller
{
private Account account{get;set;}

public Chapter7_1_controller()
{
 account=[SELECT id,name FROM Account where id=:ApexPages.currentPage().getParameters().get('id')];
}


public Account getAccount() {
return account;
}


public PageReference save() {
update account;
return null;
}
}