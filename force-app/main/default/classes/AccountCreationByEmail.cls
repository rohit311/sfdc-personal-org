Global class AccountCreationByEmail implements Messaging.InboundEmailHandler{

    Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
    {
        Messaging.InboundEmailResult result=new Messaging.InboundEmailResult();
        Messaging.InboundEmail.textAttachment[] textAttachments=email.TextAttachments;
        
        String csvBody1 = '';
        String[] lineByCsvBody = new String[]{};
        List<Account> accList=new List<Account>();
        
        if(textAttachments!=null && textAttachments.size()>0)
        {
            for(Messaging.InboundEmail.textAttachment tAtch: textAttachments)
            {
               csvBody1=tAtch.body;
                lineByCsvBody = csvBody1.split('\n');//for getting the individual lines
                
                for(String str:lineByCsvBody)
                {
                    String[] ConArray=str.split(',');//for each word of the line
                    Account acc=new Account(Name=ConArray[0],Website=ConArray[1],Active__c=ConArray[2]);
                    accList.add(acc);
                }
                     insert accList;
                   System.debug('lines  ->'+csvBody1);
            }
        }
            
        
        return result;
    }
    
}