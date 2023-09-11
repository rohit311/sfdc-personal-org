trigger updateopp on Deviation_Transaction__c (after insert,after update,after delete) {
List<Opportunity> opp = new List<Opportunity>();
List<Id> devId = new List<Id>();
List<Id> oppList = new List<Id>();
List<Id> oppIdList = new List<Id>();
List<Applicant__c> applist = new List<Applicant__c>();
List<Applicant__c> appupdatelist = new List<Applicant__c>();
List<Id> transIdList = new List<Id>();
List<Deviation_Transaction__c> transList = new List<Deviation_Transaction__c>();
if(trigger.isUpdate || trigger.isDelete)
{
    for(Deviation_Transaction__c dev : trigger.old)
    {
        devId.add(dev.Loan_Application__c); 
        //opp =[select id,name from Opportunity  where id =: dev.Loan_Application__c];
    }
    opp =[select id,name from Opportunity  where id in :devId];
   
}
if(trigger.isInsert)
{
        for(Deviation_Transaction__c dev : trigger.new)
        {
            devId.add(dev.Loan_Application__c);
            transIdList.add(dev.id);
         }
       opp =[select id,name,Account.IS_OTP_FLOW__c,product__c from Opportunity  where id in :devId];
     
       transList = [select id,Deviation_Master__r.Segmentation_Normal__c,Loan_Application__c from Deviation_Transaction__c where id in:transIdList];
        if(transList !=null && transList .size()>0){
               for(Deviation_Transaction__c trans:transList){
                     if(trans.Deviation_Master__r.Segmentation_Normal__c == true){
                                system.debug('******trans.Deviation_Master__r.Segmentation_Normal__c***'+trans.Deviation_Master__r.Segmentation_Normal__c); 
                                oppIdList.add(trans.Loan_Application__c);
                    } 
                  
               }
         }
          system.debug('******oppIdList***'+oppIdList); 
         String products;
          /***********    Getting OTP related products from custom settings    **********/
          if(OTPFlowProducts__c.getValues('OTP Product')!=null)   
                      products = OTPFlowProducts__c.getValues('OTP Product').Product__c;  
            Set<String> OTPProducts = new Set<String>();
            if(products!=null){ 
                String[] arr = products.split(';');
                for(String str:arr){
                   OTPProducts.add(str); 
                }
                system.debug('***OTPProducts***'+OTPProducts); 
            }
            //For OTP deviation segmentation flow
            if(oppIdList!=null && oppIdList.size()>0 && opp!=null && opp.size()>0){
               for(Id oppIdListId:oppIdList){
                     for(Opportunity oppobj:opp){                        
                           if(oppobj.id == oppIdListId){
                                if(oppobj.Account.IS_OTP_FLOW__c==true && (OTPProducts.contains(oppobj.product__c))){
                                       oppList.add(oppobj.id);
                                     system.debug('******in OTP floe ***'+oppList);   
                                }
                            }   
                        }
                }          
                system.debug('******oppList OTPflow SAL+SPL to normal***'+oppList);     
                if(oppList!=null && oppList.size()>0){
                     applist = [select id,SegmentaionResult__c,Sub_Segment__c,Loan_Application__c from Applicant__c where Loan_Application__c in :oppList and 
                                    Applicant_Type__c = 'Primary' and SegmentaionResult__c!='NORMAL' limit 1];
                     if(applist!=null && applist.size()>0){
                           for(Applicant__c app:applist){
                                system.debug('*******In if to normal***');
                                 app.SegmentaionResult__c ='NORMAL';
                                 app.Sub_Segment__c = '';  
                                 appupdatelist.add(app);
                           }
                     }
                }                                            
            }
}

 if(opp!=null && opp.size()>0)
        update opp;
  
 if(appupdatelist!=null && appupdatelist.size()>0)
        update appupdatelist;
}