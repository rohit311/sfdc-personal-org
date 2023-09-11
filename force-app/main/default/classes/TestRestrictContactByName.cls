@isTest
public class TestRestrictContactByName {

    @isTest
    public static void TestContactWithInvalidLastName(){

    Contact c1=new Contact(LastName='INVALIDNAME');
    test.startTest();
    insert c1;
    test.stopTest();
    }
}