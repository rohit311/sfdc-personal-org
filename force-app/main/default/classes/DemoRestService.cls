@RestResource(urlMapping='/Demo/')
global class DemoRestService{

    @HttpPost
    global static Contact createContact(String fName,String lName){
        Contact conRec = new Contact(FirstName = fName,LastName = lName);
        insert conRec;
    
        return conRec;
    }
}