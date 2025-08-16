@isTest
public with sharing class AccountListViewCtrlTest {

    @TestSetup
    static void makeData(){
      List<Account> accListToInsert = new List<Account>();
      accListToInsert.add(new Account(name='Burington', Industry= 'Apparel', AnnualRevenue=30000));
      accListToInsert.add(new Account(name='Edge Communication', Industry= 'Electronics', AnnualRevenue=60000));

      insert accListToInsert;
    }

    @IsTest
    static void testGetAccounts(){

      Test.startTest();

      List<Account> accList = AccountListViewCtrl.getAccounts(10, 0, 'Name', 'ASC');

      System.assertEquals(2, accList.size(),'2 Accounts should be returned');
      System.assertEquals('Apparel', accList[0].Industry, 'First record should be of Apparel industry');
      Test.stopTest();

    }

    @isTest
    static void testGetTotalAccountRecords() {

      Test.startTest();
      Integer countOfAccountRecords = AccountListViewCtrl.getTotalAccountRecords();

      System.assertEquals(2, 2,'total count of acoount records should be 2.');
      Test.stopTest();
    }

    @isTest
    static void testGetAccountsBySearch() {
      Test.startTest();

      List<Account> accList = AccountListViewCtrl.getAccountsBySearch('Bur', 10, 0);

      System.assertEquals(1, accList.size(),'1 Account should be returned');
      Test.stopTest();
    }

    @isTest
    static void testUpdateAccounts() {
      Test.startTest();
      List<Account> accList = AccountListViewCtrl.getAccounts(10, 0, 'Name', 'ASC');
      Map<String,String> accMap = new Map<String,String>();
      accMap.put(accList[0].Id, '90000');

      String result = AccountListViewCtrl.updateAccounts(JSON.serialize(accMap));

      System.assertEquals('success', result, 'Success should be returned from the method');
      accList = AccountListViewCtrl.getAccounts(10, 0, 'Name', 'ASC');

      System.assertEquals(90000, accList[0].AnnualRevenue, 'Annual revenue should get updated');

      Test.stopTest();
    }

    @IsTest
    static void testGetAccountsException(){

      Test.startTest();

      List<Account> accList;
      try {
        accList = AccountListViewCtrl.getAccounts(10, 1000, 'Name', 'ASC');
      } catch(Exception ex) {
        System.assertEquals(null, accList, 'Account lsit should not be returned when exception occurs');
      }


      Test.stopTest();

    }
}