public class MailingDemo {

    public void sendEmailDemo(){
        Messaging.reserveMassEmailCapacity(2);
        
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        
        String[] toarray=new String[]{'scorpiorohit311@gmail.com'};
            String[] ccarray=new String[]{'rohit_chavan@persistent.com'};
            mail.setToAddresses(toarray);
            mail.setCcAddresses(ccarray);
            mail.setReplyTo('rohit_chavan@persistent.com');
            
            mail.setSenderDisplayName('Salesforce Support');
        
            mail.setSubject('Test E-mail');
        
            mail.setBccSender(false);
        
            mail.setPlainTextBody('this is a sample email.');
            mail.setHtmlBody('<p> Do not reply to this mail.</p>');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
           
    }
}