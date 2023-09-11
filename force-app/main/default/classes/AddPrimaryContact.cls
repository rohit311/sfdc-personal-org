global class AddPrimaryContact implements Queueable{

    String state; 
    Contact conObj;
    public AddPrimaryContact(Contact conObj,String state){
        this.conObj = conObj;
        this.state = state;
    }

     public void execute(QueueableContext context) { 
     System.debug('here');
     List<Account> accList = new List<Account>();
     List<Contact> conList = new List<Contact>();
     
     accList = [SELECT BillingState FROM Account WHERE BillingState = :state LIMIT 200];
         for(Account acc : accList){
          Contact con = new Contact();
          con = conObj.clone(false,false,false,false);
          con.AccountId = acc.Id;
          conList.add(con);
         }
         insert conList;
     
     }

}