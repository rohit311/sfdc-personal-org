public class day4_assign2_controller
{

public Map<Employee__c,List<Leave__c>> linemap=new Map<Employee__c,List<Leave__c>> ();
public Date startdate{get;set;}
public Date enddate{get;set;}
public Decimal empid{get;set;}

public List<Case> results {
        get {
            //returns a list of cases

            return results;
        } 
        set; 
    }

List<SelectOption> items{set;}


public List<SelectOption> getItems() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        List<Employee__c> empList = [select id, Name__c from Employee__c];
        for(Employee__c emp:empList) {
            countryOptions.add(new SelectOption(emp.id,emp.Name__c));
        }
        
 
        return countryOptions;
    }

public  Map<Employee__c,List<Leave__c>> getLinemap()
{
return linemap;

}
public  day4_assign2_controller()
{


}

public Map<Employee__c,List<Leave__c>>  getAllRecord_forstart()
{
 List<Employee__c>ilst=[Select id,Name,Country__c,State__c,Id__c,Name__c From Employee__c where eDate__c>=:startdate];
 List<Leave__c> lnlst=[Select id,EmployeeToLeave__c,From__c,FromDate__c,Reason__c From Leave__c];
 
 for(Employee__c inv:ilst)
 {
 List<Leave__c> temp=new List<Leave__c>();
 linemap.put(inv,temp);
    for(Leave__c l:lnlst)
    {
         if(inv.id==l.EmployeeToLeave__c)
         {
             temp.add(l);
         }
    } 
 
 }
 
 return linemap;
}




public Map<Employee__c,List<Leave__c>>  getAllRecord_forend()
{
 List<Employee__c>ilst=[Select id,Name,Country__c,State__c,Id__c,Name__c From Employee__c where eDate__c<=:enddate];
 List<Leave__c> lnlst=[Select id,EmployeeToLeave__c,From__c,FromDate__c,Reason__c From Leave__c];
 
 for(Employee__c inv:ilst)
 {
 List<Leave__c> temp=new List<Leave__c>();
 linemap.put(inv,temp);
    for(Leave__c l:lnlst)
    {
         if(inv.id==l.EmployeeToLeave__c)
         {
             temp.add(l);
         }
    } 
 
 }
 
 return linemap;
}


public Map<Employee__c,List<Leave__c>>  getAllRecord()
{
 List<Employee__c>ilst=[Select id,Name,Country__c,State__c,Id__c,Name__c From Employee__c where id__c = :empid];
 List<Leave__c> lnlst=[Select id,EmployeeToLeave__c,From__c,FromDate__c,Reason__c From Leave__c];
 
 for(Employee__c inv:ilst)
 {
 List<Leave__c> temp=new List<Leave__c>();
 linemap.put(inv,temp);
    for(Leave__c l:lnlst)
    {
         if(inv.id==l.EmployeeToLeave__c)
         {
             temp.add(l);
         }
    } 
 
 }
 
 return linemap;
}



public PageReference go1()
{
        
if(startdate>enddate)
   {
  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid dates');
ApexPages.addMessage(myMsg);

   }
   else if(startdate!=null)
   {
      linemap=getAllRecord_forstart();
   }
   else if(enddate!=null)
   {
         linemap=getAllRecord_forend();
   }
   else
   { 
       linemap=getAllRecord();
   
   }
return null;

}

}