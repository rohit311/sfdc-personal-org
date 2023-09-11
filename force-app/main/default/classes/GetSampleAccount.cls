global class GetSampleAccount{

    public Id con {get;set;}
    public Id acc {get;set;}
    
    public Account accObj {get;set;}
    
    /**
    * get all sibling Contacts
    */ 
    public List <Contact> getAllContact(){
    
    
        if(acc != null)
        {
            accObj = [SELECT NAME FROM Account WHERE Id = : acc ];
            return [SELECT Id, Name, FirstName, LastName FROM Contact Where AccountId =: acc ];
        }
            
        return null;
    }
}