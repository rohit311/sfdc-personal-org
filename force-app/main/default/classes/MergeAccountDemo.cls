public class MergeAccountDemo {

    
    public void mergeAccounts()
    {
        List<Account> accList = new List<Account>{new Account(Name = 'Acme Master'),new Account(Name = 'Acme')};
            insert accList;
        
        Account masterAccount = [SELECT Id,Name FROM Account WHERE Name = 'Acme Master' LIMIT 1];
        Account mergeAccount = [SELECT Id,Name FROM Account WHERE Name = 'Acme' LIMIt 1];
        
        Contact conRec = new Contact(FirstName = 'Joe',LastName = 'Merged');
        conRec.AccountId = mergeAccount.Id;
        insert conRec;
        
        try{
            merge masterAccount mergeAccount;
        }catch(DmlException ex)
        {
            System.debug('An unexpected eror occured - '+ex.getMessage());
        }
        
        masterAccount = [SELECT Id,Name, (SELECT FirstName,LastName FROM Contacts) FROM Account WHERE Name = 'Acme Master'];
        
        System.assert(masterAccount.getSObjects('Contacts').size()>0);
        System.assertEquals('Joe',masterAccount.getSObjects('Contacts')[0].get('FirstName'));
        System.assertEquals('Merged',masterAccount.getSObjects('Contacts')[0].get('LastName'));
    }
}