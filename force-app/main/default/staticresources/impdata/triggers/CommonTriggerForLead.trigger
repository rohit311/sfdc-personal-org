trigger CommonTriggerForLead on Lead (before update,after update,after insert,before insert) 
{
    if (CreditCardController.handleRecursion) { // CC Code changes SME
    list<Product_Offerings__c> products=new list<Product_Offerings__c>();
    set<id> leadidset=new set<id>();
    //Added by leena for Bug 17550 - Need to put profile condition in PO/Lead and Lead Applicant triggers
    string Pid = Userinfo.getProfileID();
    string Ids = Label.PO_Trigger_restrictedUserId;
    set < string > restrictedIdsSet = new set < string > ();
    if (ids != null) 
        restrictedIdsSet.addAll(Ids.split(';'));
    if (!restrictedIdsSet.contains(Pid))     
    {
        if (!ControlRecursiveCallofTrigger_Util.hasleadupdatecont()) 
        {
            ControlRecursiveCallofTrigger_Util.setleadupdatecont();
            string strDedupeID = '';
            for(lead ll:trigger.new)
            {
                if(trigger.isupdate && trigger.isbefore)
                {
                    if(trigger.newmap.get(ll.id).SBS_Branch__c != trigger.oldmap.get(ll.id).SBS_Branch__c)      
                        leadidset.add(ll.id);         
                    //Code Added By Rajendra for PO Dedupe Revamp 
                    if(Label.PO_Dedupe_Mandatory_Fields != null && Label.PO_Dedupe_Non_Mandatory_Fields != null)
                    {
                        strDedupeID = '';
                        boolean isReInitiationNeeded = false;
                        if(string.isNotBlank(Label.PO_Dedupe_Mandatory_Fields))
                        {
                            List<string> lstFields = Label.PO_Dedupe_Mandatory_Fields.split(',');
                            for(string strField : lstFields)
                            {
                                if(trigger.newmap.get(ll.id).get(strField)!=null && trigger.newmap.get(ll.id).get(strField)  != trigger.oldmap.get(ll.id).get(strField))
                                {
                                    isReInitiationNeeded = true;
                                    break;
                                }
                            }
                            system.debug('isReInitiationNeeded  '+isReInitiationNeeded );
                            if(isReInitiationNeeded){
                            System.debug('ll adi' +ll.FirstName  +'  '+ll.LastName);
                                strDedupeID = DedupePOHandler_Revamp.checkDedupeForReInitiation(ll);}
                            else 
                            {
                                //case to check Non Mandatory Fields.
                                List<string> lstNonMdtFields = Label.PO_Dedupe_Non_Mandatory_Fields.split(',');
                                for(string strField : lstNonMdtFields)
                                {
                                    if(trigger.newmap.get(ll.id).get(strField)!=null &&trigger.newmap.get(ll.id).get(strField)  != trigger.oldmap.get(ll.id).get(strField))
                                    {
                                        isReInitiationNeeded = true;                            
                                        break;
                                    }
                                }
                                system.debug('isReInitiationNeeded  '+isReInitiationNeeded );
                                if(isReInitiationNeeded)
                                    strDedupeID = DedupePOHandler_Revamp.checkDedupeForReInitiation(ll);
                            }  
                        }
                        if(string.isNotBlank(strDedupeID))
                        {
                            ll.De_Dupe__c = strDedupeID;
                            ll.movedTodedupe_c__c= true;
                        }
                    }//Ened PO Dedupe Revamp here   
                }//before update 

                if(Trigger.isInsert)
                {
                    if(ll.DNC_Flag__c == 'Yes' || ll.DNC_Flag__c == 'No')
                    leadidset.add(ll.id);    
                    System.Debug('Before insert ll.ID ' + ll.ID)  ;
                    System.Debug('Trigger.isBefore ' + Trigger.isBefore );
                    try
                    {
                        if(ll.Employment_Type__c != null)        
                        leadidset.add(ll.id);           
                    }
                    catch(Exception ex)
                    {
                        ll.addError(ex.getMessage());
                    }   
                }
                if(trigger.isupdate)
                {
                    try
                    {
                        System.debug('Update on lead is called');
                        if(Trigger.oldMap.get(ll.id).Employment_Type__c != Trigger.newmap.get(ll.id).Employment_Type__c)
                            leadidset.add(ll.id);      
                    }
                    catch(Exception ex)
                    {
                        System.debug('error---');
                        // Trigger.old[i].addError('-----'+ex.getMessage());
                    } 
                }
            }//end of for

            /*products=[select id,name from Product_Offerings__c where Lead__c=:leadidset];
            if(products !=null){
            update products;
            } */
        }
        
        // Bug 22141 : Code for MobileValidation(to call fraudvalidationutility) 
        
        List<String> fieldsChanged = new List<String>();
        List<string> ListofProducts = new List<string>();
        List<string> ListOfFields = new List<string>();
        List<Lead> requiredLead = new List<Lead>();
        List<Id> requiredLeadIds = new List<Id>();
        if(System.Label.MobileValidationOn=='true'){
            if(Trigger.isUpdate && Trigger.isAfter){
            
                if(Label.FraudValidationsforProducts !=null && string.isNotBlank(Label.FraudValidationsforProducts) && label.FraudFieldsforLead != null && string.isNotBlank(Label.FraudFieldsforLead)){
                    ListofProducts = Label.FraudValidationsforProducts.split(',');
                    ListOfFields = Label.FraudFieldsforLead.split(',');
                }
                
                Datetime storedDate;
                if(Label.MobileValidationStartdate !=null && string.isNotBlank(Label.MobileValidationStartdate)){
                    String Datevalue = System.Label.MobileValidationStartdate;
                    storedDate = (datetime.valueOf(Datevalue));
                }
            
                requiredLead = [select id,(select id,CIBIL_Fired_time__c from cibils__r Limit 1) from Lead where Id in :trigger.new ];
                
                if(requiredLead!=null && requiredLead.size()>0){
                     for(Lead leadObj : requiredLead){
                        if(leadObj.cibils__r!=null && leadObj.cibils__r.size()>0 && leadObj.cibils__r[0].CIBIL_Fired_time__c!=null){
                            Datetime cibilFiredDate = leadObj.cibils__r[0].CIBIL_Fired_time__c;
                            system.debug('sotred date'+storedDate+'cibildate'+cibilFiredDate);
                                if(cibilFiredDate>storedDate){
                                    requiredLeadIds.add(leadObj.id);
                            }
                        }               
                    }
                }
                system.debug('lead value is'+requiredLeadIds);
            }
        }        
        if(Trigger.isUpdate && Trigger.isAfter){
            for(lead ll:trigger.new){
                if(System.Label.MobileValidationOn=='true'){
                // to be moved outside loop...to add Id.valueOf
                    if(ListofProducts !=null && ListofProducts.size()>0 && ListOfFields != null && ListOfFields.size()>0&& requiredLeadIds!=null && requiredLeadIds.size()>0 && requiredLeadIds.contains(ll.id)){           
                        for(string strField : ListOfFields)
                        {   
                            if(trigger.newmap.get(ll.id).get(strField)!=null && trigger.newmap.get(ll.id).get(strField)  != trigger.oldmap.get(ll.id).get(strField))
                            {
                                fieldsChanged.add(strField);
                            }
                        }
                        System.Debug('ll cibil extension ' + ll.CIBIL_Extension__r);
                        if(fieldsChanged!=null){ // && trigger.newmap.get(ll.id).get('movedToCibilTemp__c')==true
                            string productname = (String)trigger.newmap.get(ll.id).get('product__c');
                            if(productname!=null){
                                productname = productname.toUppercase();
                                system.debug('inside call');
                                if(ListofProducts.contains(productname)){
                                    FraudValidationUtility.utilityMethod('Lead',trigger.newMap.get(ll.Id),productname,fieldsChanged,'');
                                }
                            }
                            

                        }
                        
                    }
                }
                // Bug 22141 E                                    
              
            }     
        }
        
        if (Trigger.isUpdate && Trigger.isAfter) { // Moved logic from sendAppointmentInvite trigger to avoid multiple trigger on Lead
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
     // CC Code changes SME start
    if(Trigger.isUpdate && Trigger.isAfter) {
        // Check if parameters are changed mobile pin code and date of birth
        Set<Id> poIds = new Set<Id>();
        // US_16142__CIBIL Validation for Credit Card-Standalone start
            Integer min_reng = Integer.valueOf(Label.cibil_Range.substringBefore('-'));
            Integer max_reng = Integer.valueOf(Label.cibil_Range.substringAfter('-'));
            System.debug('cibil min_reng is -->' + min_reng);
            System.debug('cibil max_reng is -->' + max_reng);
            Integer oldCibilsc = 0;
            Integer newCibilsc = 0;
        // US_16142__CIBIL Validation for Credit Card-Standalone end
        Map<Id,Id> poIdWithLeadId = new Map<Id, Id>();
        for (Lead l : Trigger.oldMap.values()) {
            Lead newValue = Trigger.newMap.get(l.Id);
            // US_16142__CIBIL Validation for Credit Card-Standalone start
            
            if(l.Cibil_Score__c == '000-1' || l.Cibil_Score__c == null || l.Cibil_Score__c == '')
               oldCibilsc = 0;
             else
               oldCibilsc = Integer.valueOf(l.Cibil_Score__c);
               
            if(newValue != null && ( newValue.Cibil_Score__c == '000-1' || newValue.Cibil_Score__c == null  || newValue.Cibil_Score__c == ''))
               newCibilsc = 0;
             else if (newValue != null)
               newCibilsc = Integer.valueOf(newValue.Cibil_Score__c);
               
               System.debug('old cibil score was -->' + oldCibilsc);
               System.debug('newCibilsc cibil score is -->' + newCibilsc);
               
           
          // US_16142__CIBIL Validation for Credit Card-Standalone end
            //if (newValue != null && (newValue.MobilePhone != l.MobilePhone || newValue.DOB__c != l.DOB__c || newValue.Resi_Pin_Code__c != l.Resi_Pin_Code__c)) {
            if (newValue != null && (newValue.MobilePhone != l.MobilePhone || newValue.DOB__c != l.DOB__c || newValue.Resi_Pin_Code__c != l.Resi_Pin_Code__c ||
                                    ( (oldCibilsc <= max_reng && oldCibilsc >= min_reng && ( newCibilsc > max_reng || newCibilsc < min_reng)) || 
                                      (newCibilsc <= max_reng && newCibilsc >= min_reng && ( oldCibilsc > max_reng || oldCibilsc < min_reng))     ))) { // US_16142__CIBIL Validation for Credit Card-Standalone modified condition for cibil update To_OR_From valid range maintained in cibil_Range label
                poIds.add(newValue.Recent_PO_for_cibil_requested__c);
                poIdWithLeadId.put(newValue.Recent_PO_for_cibil_requested__c,newValue.Id);
            }
        }
        System.debug('poIds -->' + poIds.size());
        if (poIds.size() > 0) {
            // fetch SOL Policy of type CC and check application number is not generated, TODO replace Name with CC Application number field
            List<SOL_Policy__c> solPLst = [Select Id,Product_Offerings__c,Product_Offerings__r.Credit_Card_Type__c From SOL_Policy__c where Product_Offerings__c IN: poIds AND Flow_Identifier__c =: CreditCardController.CC_SME_IDENTIFIER AND CC_Number__c = null];
            System.debug('solPLst -->' + solPLst.size());
            if (solPLst != null && solPLst.size() > 0) {
                CreditCardController.handleRecursion = false;
                Set<Id> leadIds = new Set<Id>();
                Set<Product_Offerings__c> pd = new Set<Product_Offerings__c>();
                List<Lead> leadToUpdate = new List<Lead>();
                
                for (SOL_Policy__c sp : solPLst) {
                    if (sp.Product_Offerings__c != null && poIdWithLeadId.get(sp.Product_Offerings__c) != null) {
                        leadIds.add(poIdWithLeadId.get(sp.Product_Offerings__c));
                        sp.Product_Offerings__r.Credit_Card_Type__c = null;
                        pd.add(sp.Product_Offerings__r);
                    }
                }
                System.debug('leadIds -->' + leadIds);
                if (leadIds.size() > 0) {
                    List<Lead> lLst = [Select Id,CC_Disposition__c, Name from Lead where Id IN:leadIds];
                    for (Lead l : lLst) {
                        //l.Customer_Interest__c = null;
                        l.CC_Disposition__c = null;/*US : 2702*/
                        //l.CC_Variant__c = null;
                        leadToUpdate.add(l);
                    }
                }
                if (leadToUpdate.size() > 0 && pd.size() > 0) {
                     update leadToUpdate;
                     update new List<Product_Offerings__c> (pd);
                     // delete SOL Policy
                     delete solPLst;
                }
            }
        }
    }
    //CC Code changes SME End
        
    }
}