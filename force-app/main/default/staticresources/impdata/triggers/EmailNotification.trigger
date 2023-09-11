trigger EmailNotification on De_Dupe__c (after delete) {
    Map<De_Dupe__c,id> dedupeOppMap = new Map<De_Dupe__c,id>();
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    
    for (De_Dupe__c de: Trigger.old) {
        if(de.Loan_Application__c!=null && (de.Source_Or_Target__c=='Source'||de.Source_Or_Target__c=='Target'))
            dedupeOppMap.put(de, de.Loan_Application__c);
        system.debug('dedupeOppMap size inn trigger.old'+dedupeOppMap.size());        
        system.debug('dedupeOppMap inn trigger.old'+dedupeOppMap);
        system.debug('dedupeOppMap values inn trigger.old'+dedupeOppMap.values());
        system.debug('dedupeOppMap keyset inn trigger.old'+dedupeOppMap.keySet());
    }
    list<opportunity>  oppList = new list<opportunity>();
    oppList= [select id,name, StageName, OwnerId, LastModifiedById, Loan_Application_Number__c from opportunity where id in : dedupeOppMap.values() and stagename in ('Approved', 'Post Approval Sales','Branch Ops','Moved To Finnone')];
    system.debug('opplist.size '+opplist.size());
    if(oppList!=null && oppList.size()>0){
        for (opportunity opp: oppList){
            system.debug('inside for opplsits');
            String body = 'Hi, </br>The following dedupe/s got deleted for the Opportunity: '+opp.Name;
            String  acclink =  URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id;
            body = body + '</br><a href="'+acclink+'"> Click here to view the Loan application</a><br/><br/>';
            body = body + '</br>Loan Application Number: '+opp.Loan_Application_Number__c;     
            body = body + '</br>SFDC id: '+opp.id;                                 
            body = body + '</br>Stage Name: '+opp.StageName;                                 
            body = body + '</br>Owner ID: '+opp.OwnerId;
            body = body + '</br>Last Modified By ID: '+opp.LastModifiedById;        
            body = body + '</br>Time Stamp: '+Datetime.now();
            for (De_Dupe__c de: dedupeOppMap.keySet()) {
                system.debug('inside dedude forloop');
                body = body + '</br></br></br>	Dedupe: '+de.Name;
                body = body + '</br>	Source_Or_Target: '+de.Source_Or_Target__c;
            }
            body = body + '</br></br>Regards.<br/>';
            String Sub = 'Dedupes got deleted';
            body = body.replace('"', '\\"');
            List < String > emailList = new List < String > ();
            system.debug('############# mail sending logic');
            
            String[] toAddress = Label.midofficeexceptionmails.split(';');
            if (toAddress.size() > 0) {
                for (String emails: toAddress) { 
                    emailList.add(emails);
                }
                if(!test.isRunningTest())
                    SOLsendEmail.LogixEmailForDG(emailList, Sub, body);
                system.debug('mail sentt');
            }
        }
    }    
}