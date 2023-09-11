public class DetailButtonController {
    
    private ApexPages.StandardController standardController;
 
    
    public DetailButtonController(ApexPages.StandardController controller) {
        this.standardController = standardController;
    }

    public PageReference doSomething(){
        Id recordId = standardController.getId();
        System.debug('ID --> '+recordId);
        String urlStr = 'https://rohit311-dev-ed.my.salesforce.com/'+recordId;
        PageReference MyObjectPR= new PageReference('/001');
        MyObjectPR.setRedirect(true);
        return MyObjectPR;
      
    }
    
}