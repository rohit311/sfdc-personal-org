public class EmployeeContr{

public List<Employee__c> emplist{get;set;}
public Employee__c e1{get;set;}

public String link{get;set;}

public EmployeeContr(){

emplist=EmployeeList();
link='https://ap2.salesforce.com/';
}


public List<Employee__c> EmployeeList()
{
emplist=[select id,Name__c,Country__c,State__c FROM Employee__c];
return emplist;
}

public PageReference save()
{
   update emplist;
   return null;
}
}