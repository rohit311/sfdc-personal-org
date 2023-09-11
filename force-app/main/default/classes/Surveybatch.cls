public class Surveybatch implements Database.Batchable<sObject>,Database.Stateful{
	public String query = 'SELECT first_name__c,survey_date__c,Contact__c FROM Customer__c WHERE survey_date__c = TODAY';
    private List<Customer__c> surveyedCustomers = new List<Customer__c>();
    private String emailTemplateId = [Select id from EmailTemplate where developerName = 'survey_template' limit 1].Id;
    
    public Surveybatch(){
    }
    
	public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   	}    
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<String> emailstoSendIds = new List<String>();
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        
        for(Customer__c cust:(List<Customer__c>)scope){            
            if(Limits.getHeapSize() < Limits.getLimitHeapSize()*0.8){//0.8 is just an example of threshold to skip current execution
            	emailstoSendIds.add(cust.Id);
                                
                Messaging.SingleEmailMessage semail = Messaging.renderStoredEmailTemplate(emailTemplateId, cust.Contact__c, cust.Id);
                emailsList.add(semail);
                
            }
            else{
                break;
            }
        }
        
        if(Limits.getEmailInvocations() < Limits.getLimitEmailInvocations()){           
            try{
            	Messaging.SendEmailResult [] sendmailResults = Messaging.sendEmail(emailsList);                               
                surveyedCustomers.addAll(fetchSurvayedCustomersForUpdate(emailstoSendIds));
            }
            catch(Exception ex){
                LogUtil.createlog('Exception',ex.getMessage());	
            }
        }
        else{
            LogUtil.createlog('Platform limit','Email limits reached');
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        if(surveyedCustomers.size() > 0){
            for(Customer__c cust:surveyedCustomers){
                cust.survey_date__c = null;
            }
            
            try{
            	update surveyedCustomers;
            }
            catch(Exception ex){
                LogUtil.createlog('Exception',ex.getMessage());	
            }
            
        }
    }
    
    private List<Customer__c> fetchSurvayedCustomersForUpdate(List<Id> customerIds){
        return [SELECT survey_date__c FROM Customer__c where ID IN :customerIds];
    }
}