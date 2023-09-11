trigger Lead_Sharing_to_PO_Owner on Product_Offerings__c (after insert,after update) {
             //Added by leena for Bug 17550 - Need to put profile condition in PO/Lead and Lead Applicant triggers
if (CreditCardController.handleRecursion) { // CC Code changes SME
 string Pid = Userinfo.getProfileID();
 string Ids = Label.PO_Trigger_restrictedUserId;
 set < string > restrictedIdsSet = new set < string > ();
 if (ids != null) {
        restrictedIdsSet.addAll(Ids.split(';'));
    }
if (!restrictedIdsSet.contains(Pid)) 
{
            list <LeadShare> leadShareList = new List<LeadShare>();
            
              if (Trigger.isInsert) {
            
                for( Product_Offerings__c pld : trigger.new ) {
                 
                    if(pld.Lead__c!= null) {
                    
                                // Create a new leadShare object for each lead .
                                 LeadShare ldShare = new LeadShare();
                                   
                                // Give Read write access to that user for this particular lead record.
                                ldShare.LeadAccessLevel = 'edit' ;
                                // Assign lead Id of lead record.
                                 ldShare.leadId = pld.Lead__c;
                                // Assign user id to grant read write access to this particular lead record.
                                ldShare.UserOrGroupId = pld.ownerid;
                                System.debug('pld.ownerid insert '+pld.ownerid);
                               
                                leadShareList.add( ldShare );
                                
                                }
                    
                        
                    }
            
            
            if( !leadShareList.isEmpty()) {
                try {
                   insert leadShareList; 
                   
                }catch( Exception e ) {
                    //trigger.new[0].Name.addError('Error::::::'+e.getMessage());
                     }
                }
            
            } else if (Trigger.isUpdate){
                
                    
                
                //List<ID> sharestodelete = new List<ID>();
                
                for( Product_Offerings__c pld : trigger.new ) {
                    
                    if(pld.Lead__c!= null) {
                        
                      // System.debug (Trigger.oldMap.get(pld.id).ownerid+'  <-- old new -- >'+Trigger.newmap.get(pld.id).ownerid+'pld.Lead__c'+pld.Lead__c+'trigger.new'+trigger.new) ;
                       
                        if(Trigger.oldmap.get(pld.id).ownerid != Trigger.newmap.get(pld.id).ownerid ){
                                //Owner has changed
                                LeadShare ldShare = new LeadShare();
                                // Give Read write access to that user for this particular lead record.
                                ldShare.LeadAccessLevel = 'edit' ;
                                // Assign lead Id of lead record.
                                 ldShare.leadId = pld.Lead__c;
                                // Assign user id to grant read write access to this particular lead record.
                                ldShare.UserOrGroupId = pld.ownerid;
                                
                                System.debug('pld.ownerid update '+pld.ownerid);
                                
                                leadShareList.add( ldShare );
                                
                                //sharestodelete.add(Trigger.oldmap.get(pld.)
                        }
                        
                }
                
                
            }
            if( !leadShareList.isEmpty()) {
                try {
                    Upsert leadShareList; 
                   
                }catch( Exception e ) {
                    //trigger.new[0].Name.addError('Error::::::'+e.getMessage());
                     }
                }
            
            
            
            }
}

// CC Code changes SME start
 if (Trigger.isUpdate && Trigger.isAfter) {
  // Check if parameters are changed mobile pin code and date of birth
  // US_16142__CIBIL Check if below parameters are changed :-- Type_of_Degree__c || Cibil_Score__c
  Set < Id > poIds = new Set < Id > ();
  // US_16142__CIBIL Validation for Credit Card-Standalone start
    Integer min_reng = Integer.valueOf(Label.cibil_Range.substringBefore('-'));
    Integer max_reng = Integer.valueOf(Label.cibil_Range.substringAfter('-'));
    System.debug('cibil min_reng to fire cibil validation and flushing CC desposion value is -->' + min_reng);
    System.debug('cibil max_reng to fire cibil validation and flushing CC desposion value is -->' + max_reng);
    Integer oldCibilsc = 0;
    Integer newCibilsc = 0;
// US_16142__CIBIL Validation for Credit Card-Standalone end
  Map < Id, Id > poIdWithLeadId = new Map < Id, Id > ();
  for (Product_Offerings__c l: Trigger.oldMap.values()) {
   Product_Offerings__c newValue = Trigger.newMap.get(l.Id);
   System.debug('newValue degree -->' + newValue.Degree__c);
   System.debug('old Degree__c -->' + l.Degree__c);
   System.debug('newValue Specialisation__c-->' + newValue.Specialisation__c);
   System.debug('old Specialisation__c -->' + l.Specialisation__c);
   // US_16142__CIBIL Validation for Credit Card-Standalone start
           
            if(l.Cibil_Score__c == '000-1' || l.Cibil_Score__c == null || l.Cibil_Score__c == '')
               oldCibilsc = 0;
             else
               oldCibilsc = Integer.valueOf(l.Cibil_Score__c);
               
            if(newValue != null && ( newValue.Cibil_Score__c == '000-1' || newValue.Cibil_Score__c == null || newValue.Cibil_Score__c == '' ))
               newCibilsc = 0;
             else if (newValue != null)
               newCibilsc = Integer.valueOf(newValue.Cibil_Score__c);
               
               System.debug('old cibil score was -->' + oldCibilsc);
               System.debug('newCibilsc cibil score is -->' + newCibilsc);
        
        // US_16142__CIBIL Validation for Credit Card-Standalone end
   //if (newValue != null && (newValue.Degree__c != l.Degree__c || newValue.Specialisation__c != l.Specialisation__c)) {
   if (newValue != null && ( (newValue.Type_of_Degree__c != l.Type_of_Degree__c) ||
         ( (oldCibilsc <= max_reng && oldCibilsc >= min_reng && ( newCibilsc > max_reng || newCibilsc < min_reng)) || 
           (newCibilsc <= max_reng && newCibilsc >= min_reng && ( oldCibilsc > max_reng || oldCibilsc < min_reng))    ))){ // US_16142__CIBIL Validation for Credit Card-Standalone modified condition for cibil update To_OR_From valid range maintained in cibil_Range label
        if (String.isNotBlank(newValue.Id) && String.isNotBlank(newValue.Lead__c)) {
        poIds.add(newValue.Id);       
        poIdWithLeadId.put(newValue.Id, newValue.Lead__c);
      }
   }
  }
  System.debug('poIds -->' + poIds.size());
  if (poIds.size() > 0) {
   // fetch SOL Policy of type CC and check application number is not generated, TODO replace Name with CC Application number field
   List < SOL_Policy__c > solPLst = [Select Id, Product_Offerings__c,Product_Offerings__r.Credit_Card_Type__c From SOL_Policy__c where Product_Offerings__c IN: poIds AND Flow_Identifier__c =: CreditCardController.CC_SME_IDENTIFIER AND CC_Number__c = null];
   System.debug('solPLst -->' + solPLst.size());
   if (solPLst != null && solPLst.size() > 0) {
       CreditCardController.handleRecursion = false;
    Set < Id > leadIds = new Set < Id > ();
    Set<Product_Offerings__c> pd = new Set<Product_Offerings__c>();
    List < Lead > leadToUpdate = new List < Lead > ();
    
    for (SOL_Policy__c sp: solPLst) {
     if (poIdWithLeadId.get(sp.Product_Offerings__c) != null) {
      leadIds.add(poIdWithLeadId.get(sp.Product_Offerings__c));
      sp.Product_Offerings__r.Credit_Card_Type__c = null;
      pd.add(sp.Product_Offerings__r);
     }
    }
    System.debug('leadIds -->' + leadIds);
    if (leadIds.size() > 0) {
     List < Lead > lLst = [Select Id, CC_Disposition__c,Name from Lead where Id IN: leadIds];
     for (Lead l: lLst) {
      //l.Customer_Interest__c = null;
      l.CC_Disposition__c = null;/*US : 2702*/
      //l.CC_Variant__c = null;
      leadToUpdate.add(l);
     }
    }
    if (leadToUpdate.size() > 0 && pd.size() >0) {
        update leadToUpdate;
        update new List<Product_Offerings__c> (pd);
        // delete SOL Policy
        delete solPLst;
    }
   }
  }
 } // CC Code changes SME end

}
}