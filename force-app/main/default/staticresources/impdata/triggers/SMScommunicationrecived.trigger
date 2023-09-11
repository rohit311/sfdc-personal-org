trigger SMScommunicationrecived on SMS_Received__c (after insert) {
    String text;
    String mob;
    Boolean isSALUpdated = false;
    salaried__c sal = new salaried__c();
    list<salaried__c> sallist = new list<salaried__c>();
    //list<SMS_Sent__c> smssentlist = new list<SMS_Sent__c>();
    for(SMS_Received__c smsrcvd:trigger.new){
        system.debug('inside for loop');
         mob=smsrcvd.Name;
         system.debug('mobilength----->'+mob.length());
        if(smsrcvd.Received_Text__c!= null  && mob.length()==12 ){
            mob=mob.substring(2,mob.length());
            text=smsrcvd.Received_Text__c;  
            system.debug('text----->'+text);
        }
        if((text!=null || text!='' )&& mob!=null){
            //smssentlist =  [select SMS_Sent_Number__c from SMS_Sent__c where SMS_Sent_Number__c=:mob limit 5000];
            //if(!Test.isRunningTest()){ 
            List<String> prod = smsrcvd.Received_Text__c.split('_');
            String ProdType;
            if(prod.size()>1)
                ProdType = prod[1];
            else
                ProdType = smsrcvd.Received_Text__c;
            
                sallist = [select Customer_Replied_Date_Time__c,Mobile__c,Customer_Replied__c,Product_Type__c from salaried__c where Mobile__c=:mob AND Product_Type__c=:ProdType ORDER BY CreatedDate DESC NULLS LAST LIMIT 1 ];
            //}
            system.debug('sallist----->'+sallist);
            //if(smssentlist.size()>0){
            
                    if(sallist.size()>0){
                        for(integer i=0;i<sallist.size();i++){
                            //if(sallist[i].Product_Type__c == smsrcvd.Received_Text__c || (prod.size()>1 && sallist[i].Product_Type__c == prod[1])){
                                sallist[i].Customer_Replied__c = true;
                                isSALUpdated = true;
                                sallist[i].Customer_Replied_Date_Time__c = (System.now().format('MM/dd/yyyy h:m a'));
                            
                        }
                    }
            //}
        }    
    }
    System.debug('isSALUpdated ======='+isSALUpdated );
    if(sallist.size()>0 && isSALUpdated){
        System.debug('Salaried Updating =======');
        update sallist;
    }
}