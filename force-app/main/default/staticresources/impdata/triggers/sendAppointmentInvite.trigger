trigger sendAppointmentInvite on Lead (after update) {
      //Added by leena for Bug 17550 - Need to put profile condition in PO/Lead and Lead Applicant triggers
 string Pid = Userinfo.getProfileID();
 string Ids = Label.PO_Trigger_restrictedUserId;
 set < string > restrictedIdsSet = new set < string > ();
 if (ids != null) {
        restrictedIdsSet.addAll(Ids.split(';'));
    }
if (!restrictedIdsSet.contains(Pid)) 
{
    for(Lead lead:Trigger.new){
    for(Integer i=0;i<Trigger.new.size();i++)
      if(Trigger.new[i].Appt_Date__c != null && Trigger.new[i].email != null){
        if((Trigger.new[i].Appt_Date__c != Trigger.old[i].Appt_Date__c) ||
            (Trigger.new[i].email != null && Trigger.new[i].email != Trigger.old[i].email)){
            //System.debug('Trigger.new[i].Appt_Date__c@@@@'+Trigger.new[i].Appt_Date__c.year() + Trigger.new[i].Appt_Date__c.month() + Trigger.new[i].Appt_Date__c.day());
            //Integer endDate = Trigger.new[i].Appt_Date__c.addHours(3).year() + Trigger.new[i].Appt_Date__c.addHours(3).month() + Trigger.new[i].Appt_Date__c.addHours(3).day();
            DateTime endDateTime = Trigger.new[i].Appt_Date__c.addHours(1);
            String day = (String.valueOf(Trigger.new[i].Appt_Date__c.day()).length()==1?'0'+String.valueOf(Trigger.new[i].Appt_Date__c.day()):String.valueOf(Trigger.new[i].Appt_Date__c.day()));
            System.debug('Month## '+day);
            String startDate = String.valueOf(Trigger.new[i].Appt_Date__c.year()) + (String.valueOf(Trigger.new[i].Appt_Date__c.month()).length()==1?'0'+String.valueOf(Trigger.new[i].Appt_Date__c.month()):String.valueOf(Trigger.new[i].Appt_Date__c.month())) + (String.valueOf(Trigger.new[i].Appt_Date__c.day()).length()==1?'0'+String.valueOf(Trigger.new[i].Appt_Date__c.day()):String.valueOf(Trigger.new[i].Appt_Date__c.day())) + 'T'+ (String.valueOf(Trigger.new[i].Appt_Date__c.hour()).length()==1?'0'+String.valueOf(Trigger.new[i].Appt_Date__c.hour()):String.valueOf(Trigger.new[i].Appt_Date__c.hour()))+ (String.valueOf(Trigger.new[i].Appt_Date__c.minute()).length()==1?'0'+String.valueOf(Trigger.new[i].Appt_Date__c.minute()):String.valueOf(Trigger.new[i].Appt_Date__c.minute())) + (String.valueOf(Trigger.new[i].Appt_Date__c.second()).length()==1?'0'+String.valueOf(Trigger.new[i].Appt_Date__c.second()):String.valueOf(Trigger.new[i].Appt_Date__c.second()))+'Z';    
            String endDate = String.valueOf(endDateTime.year()) + (String.valueOf(endDateTime.month()).length()==1?'0'+String.valueOf(endDateTime.month()):String.valueOf(endDateTime.month())) + (String.valueOf(endDateTime.day()).length()==1?'0'+String.valueOf(endDateTime.day()):String.valueOf(endDateTime.day())) + 'T'+ (String.valueOf(endDateTime.hour()).length()==1?'0'+String.valueOf(endDateTime.hour()):String.valueOf(endDateTime.hour()))+ (String.valueOf(endDateTime.minute()).length()==1?'0'+String.valueOf(endDateTime.minute()):String.valueOf(endDateTime.minute())) + (String.valueOf(endDateTime.second()).length()==1?'0'+String.valueOf(endDateTime.second()):String.valueOf(endDateTime.second()))+'Z';    
            String currentDate = String.valueOf(datetime.now().year()) + (String.valueOf(datetime.now().month()).length()==1?'0'+String.valueOf(datetime.now().month()):String.valueOf(datetime.now().month())) + (String.valueOf(datetime.now().day()).length()==1?'0'+String.valueOf(datetime.now().day()):String.valueOf(datetime.now().day())) + 'T'+ (String.valueOf(datetime.now().hour()).length()==1?'0'+String.valueOf(datetime.now().hour()):String.valueOf(datetime.now().hour()))+ (String.valueOf(datetime.now().minute()).length()==1?'0'+String.valueOf(datetime.now().minute()):String.valueOf(datetime.now().minute())) + (String.valueOf(datetime.now().second()).length()==1?'0'+String.valueOf(datetime.now().second()):String.valueOf(datetime.now().second()))+'Z';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
            String[] toAddresses = new String[] {Trigger.new[i].email};         
            mail.setToAddresses(toAddresses);        
            mail.setSubject('Sample Meeting Invitation');        
            mail.setPlainTextBody('Meeting Request for Deal Finalization. From Bajaj Finserv Lending'); 
            //mail.setHtmlBody(body);               
            String body = 'BEGIN:VCALENDAR\nPRODID:-//Microsoft Corporation//Outlook 12.0 MIMEDIR//EN\nVERSION:2.0\nMETHOD:PUBLISH\nX-MS-OLK-FORCEINSPECTOROPEN:TRUE\nBEGIN:VEVENT\nCLASS:PUBLIC\nCREATED:'+currentDate+'\nDTEND:'+endDate+'\nDTSTAMP:20110330T203709Z\nDTSTART:'+startDate+'\nLAST-MODIFIED:'+startDate+'\nLOCATION:Online\nPRIORITY:5\nSEQUENCE:0\nSUMMARY;LANGUAGE=en-us:Meeting\nTRANSP:OPAQUE\nUID:4036587160834EA4AE7848CBD028D1D200000000000000000000000000000000\nX-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//E\n    N"><HTML><HEAD><META NAME="Generator" CONTENT="MS Exchange Server ve\n  rsion 08.00.0681.000"><TITLE></TITLE></HEAD><BODY><!-- Converted f\n    rom text/plain format --></BODY></HTML>\nX-MICROSOFT-CDO-BUSYSTATUS:BUSY\nX-MICROSOFT-CDO-IMPORTANCE:1\nEND:VEVENT\nEND:VCALENDAR';
            Blob invite = Blob.valueOf(body);                
            System.debug('invite ## '+invite.toString() );
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();        
            attach.filename = 'meeting.ics';        
            attach.ContentType = 'text/calendar;method=REQUEST';        
            attach.inline = true;        
            attach.body = invite;       
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            if(!Test.isRunningTest())
            Messaging.SendEmailResult[] er = Messaging.sendEmail(new Messaging.Email[] { mail });
        }
      }  
    }

}
    
}