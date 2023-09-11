public class NewOpportunityController{

Account account;
Contact contact;
Opportunity opportunity;
public OpportunityContactRole role;

public Account getAccount()
{
   if(account==null)
     account=new Account();
     
     return account; 
}

public Contact getContact()
{
       if(contact==null)
       contact=new Contact();
       
    return contact;
}

public Opportunity getOpportunity()
{
          if(opportunity==null)
             opportunity=new Opportunity();
       
       return opportunity;
  
}

public OpportunityContactRole  getRole()
{
      if(role==null)
         role=new OpportunityContactRole();
         
   return role;

}


public PageReference step1()
{
return Page.opptystep1;

}

public PageReference step2()
{

return Page.opptystep2;
}

public PageReference step3()
{

return Page.opptystep3;
}
public PageReference cancel()
{
PageReference opportunitypage=step1();
opportunitypage.setRedirect(true);
return opportunitypage;

}

}