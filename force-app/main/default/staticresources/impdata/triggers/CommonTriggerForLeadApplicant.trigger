trigger CommonTriggerForLeadApplicant on Lead_Applicants__c (before update,after update) 
{
  if (!ControlRecursiveCallofTrigger_Util.hasleadApplicantupdatecount()) 
  {
    ControlRecursiveCallofTrigger_Util.setleadApplicantupdatecount();
    string strDedupeID = '';
    for(Lead_Applicants__c leadapplicantObj:trigger.new)
    {
      if(trigger.isupdate && trigger.isbefore)
      {
        if(Label.PO_Dedupe_Mandatory_Fields_For_Lead_Applicant != null && Label.PO_Dedupe_Non_Mandatory_Fields_For_Lead_Applicant != null)
        {
          strDedupeID = '';
          boolean isReInitiationNeeded = false;
          system.debug('inside label');
          String blankfieldsList = 'Manadatory fields ';
          if(string.isNotBlank(Label.PO_Dedupe_Mandatory_Fields_For_Lead_Applicant))
          {
            system.debug('inside label if');
            List<string> lstFields = Label.PO_Dedupe_Mandatory_Fields_For_Lead_Applicant.split(',');
            for(string strField : lstFields)
            {
              system.debug('inside for loop'+ strField + 'and'+trigger.newmap.get(leadapplicantObj.id).get(strField) + 'also'+trigger.oldmap.get(leadapplicantObj.id).get(strField));

              if(trigger.newmap.get(leadapplicantObj.id).get(strField)!=null && trigger.newmap.get(leadapplicantObj.id).get(strField) != '' && trigger.newmap.get(leadapplicantObj.id).get(strField)  != trigger.oldmap.get(leadapplicantObj.id).get(strField))
              {
                isReInitiationNeeded = true;
                system.debug('isReInitiationNeeded  '+isReInitiationNeeded);
                break;
              }
            }

            if(isReInitiationNeeded)
              strDedupeID = DedupePOHandler_Revamp.checkDedupeForReInitiation_LeadApplicant(leadapplicantObj);
            else 
            {
              //case to check Non Mandatory Fields.
              List<string> lstNonMdtFields = Label.PO_Dedupe_Non_Mandatory_Fields_For_Lead_Applicant.split(',');
              for(string strField : lstNonMdtFields)
              {
                if(trigger.newmap.get(leadapplicantObj.id).get(strField)!=null &&trigger.newmap.get(leadapplicantObj.id).get(strField)  != trigger.oldmap.get(leadapplicantObj.id).get(strField))
                {
                  isReInitiationNeeded = true;
                  system.debug('isReInitiationNeeded  '+isReInitiationNeeded );
                  break;
                }
              }
              if(isReInitiationNeeded)
                strDedupeID = DedupePOHandler_Revamp.checkDedupeForReInitiation_LeadApplicant(leadapplicantObj);
            }  
          }
          if(string.isNotBlank(strDedupeID))
          {
            system.debug('inside last part');
            leadapplicantObj.De_Dupe__c = strDedupeID;
            leadapplicantObj.movedTodedupe_c__c= true;
          }
        }
      }//before update 
    }
  }
  //Bug 22141 S
    if(Trigger.isUpdate && Trigger.isAfter){
        system.debug('inside 22141');
        if(System.Label.MobileValidationOn=='true'){
            List<String> fieldsChanged = new List<String>();
             List<string> ListOfFields = new List<string>();
             List<string> ListofProducts = new List<string>();
            if(Label.FraudValidationsforProducts!=null && string.isNotBlank(Label.FraudValidationsforProducts)&&label.FraudFieldsforLeadApplicant != null && string.isNotBlank(Label.FraudFieldsforLeadApplicant)){
                ListOfFields = Label.FraudFieldsforLeadApplicant.split(',');
                ListofProducts = Label.FraudValidationsforProducts.split(',');
            }            
            //22141 new Start 
            List<Lead_Applicants__c> requiredLeadApp = new List<Lead_Applicants__c>();
            List<Id> requiredLeadAppIds = new List<Id>();
            Datetime storedDate;
            if(Label.MobileValidationStartdate !=null && string.isNotBlank(Label.MobileValidationStartdate)){
                String Datevalue = System.Label.MobileValidationStartdate;
                storedDate = (datetime.valueOf(Datevalue));
            }
            requiredLeadApp = [select id,(select id,CIBIL_Fired_time__c from cibils__r Limit 1) from Lead_Applicants__c where Id in :trigger.new ];
            
            if(requiredLeadApp!=null && requiredLeadApp.size()>0){
                for(Lead_Applicants__c leadAppObj : requiredLeadApp){
                    if(leadAppObj.cibils__r!=null && leadAppObj.cibils__r.size()>0 && leadAppObj.cibils__r[0].CIBIL_Fired_time__c!=null){
                        Datetime cibilFiredDate = leadAppObj.cibils__r[0].CIBIL_Fired_time__c;
                        system.debug('sotred date'+storedDate+'cibildate'+cibilFiredDate);
                            if(cibilFiredDate>storedDate){
                                requiredLeadAppIds.add(leadAppObj.id);
                        }
                    }               
                }
            }
            system.debug('required lead applicant Ids are'+requiredLeadAppIds);
            // 22141 new End
            
            for(Lead_Applicants__c leadApplicant:trigger.new){ 
                if(ListofProducts!= null && ListofProducts.size()>0 && ListOfFields!=null && ListOfFields.size()>0 && requiredLeadAppIds!=null && requiredLeadAppIds.size()>0 && requiredLeadAppIds.contains(leadApplicant.Id)){
                    for(string strField : ListOfFields)
                    {   
                        if(trigger.newmap.get(leadApplicant.id).get(strField)!=null && trigger.newmap.get(leadApplicant.id).get(strField)  != trigger.oldmap.get(leadApplicant.id).get(strField))
                        {
                            fieldsChanged.add(strField);
                        }
                    }
                    if(fieldsChanged!=null){
                       string leadId = (String)trigger.newmap.get(leadApplicant.id).get('Lead__c');
                       
                       List<Lead> leadlist = [Select id,Product__c from Lead where id = :leadId];
                       if(!CommonUtility.isEmpty(leadlist)){
                       lead leadObj = leadlist[0];
                       if(leadObj.product__c != null){
                       String productName = leadobj.product__c; 
                       productName = productName.toUppercase(); 
                       if(ListofProducts.contains(productname))
                           FraudValidationUtility.utilityMethod('Lead_Applicants__c',trigger.newMap.get(leadApplicant.Id),productName,fieldsChanged,'');
                    
                    
                    }
                   } 
                   }
                }             
            }
        }   
    } 
}