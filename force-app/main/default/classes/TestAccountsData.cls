@isTest
public class TestAccountsData {

    static testMethod void testAccountData()
    {
        List<Account> accList= Test.loadData(Account.sObjectType, 'testAccounts');
        
        System.assert(accList!=null && accList.size() == 3);
    }
}