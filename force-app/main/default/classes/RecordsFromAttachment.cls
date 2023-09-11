Global class RecordsFromAttachment implements Messaging.InboundEmailHandler{

    Global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope)
    {
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
         Messaging.InboundEmail.textAttachment[] tAttachments = email.TextAttachments;
        
         String fileAttachments = '';
        
         for(integer i=0; i < tAttachments.size(); i++)
        {
            System.debug(' attacments... ' + tAttachments[i]);
            fileAttachments = String.valueOf(tAttachments[i]);
        }
     
        String csvBody1 = '';
         String[] lineByCsvBody = new String[]{};
         List<Contact> conList=new List<Contact>();    
        if(tAttachments!=null && tAttachments.size()>0)
            {
                for(Messaging.InboundEmail.textAttachment ttt : tAttachments)
                {
                    csvBody1 = ttt.body;
                    lineByCsvBody = csvBody1.split('\n');//for getting the individual lines
                    for(String str:lineByCsvBody)
                    {
                        String[] ConArray=str.split(',');//for each word of the line
                    Contact con=new Contact(LastName=ConArray[1],FirstName=ConArray[0],Level__c=ConArray[2]);
                    conList.add(con);
                    }
                     
                   System.debug('lines  ->'+csvBody1);
                }
                insert conList;
            }
        
        
        return result;
    }
    
}