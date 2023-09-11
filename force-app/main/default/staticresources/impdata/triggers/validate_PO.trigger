trigger validate_PO on Product_Offerings__c (before insert,before update) {
    
    
    // Vikas  added Flag  to On/Off trigger , Useing label to set flag ---  Validate_PO_Flag
    
    if (label.Validate_PO_Flag == 'True') {
        
                     // 15856 Changes for PRO
                             boolean flag = false;   
        //Added by leena for Bug 17550 - Need to put profile condition in PO/Lead and Lead Applicant triggers to avoid them validation
        String Pid = Userinfo.getProfileID();
        system.debug('Pid ====>'+Pid );
        string Ids = Label.PO_Trigger_restrictedUserId;
        set < string > restrictedIdsSet = new set < string > ();
        if (ids != null) {
            restrictedIdsSet.addAll(Ids.split(';'));
        }
        system.debug('restrictedIdsSet====>'+restrictedIdsSet);
        
        if (!restrictedIdsSet.contains(Pid)) 
        {
            system.debug('inside validate_PO -- not restricted user and having switch on');
            
            // if we are inserting/updating Bulk po having same mob no which is not already in SFDC.
            List<Product_Offerings__c> currentContextDuplicatePO = new List<Product_Offerings__c>();
            List<Product_Offerings__c> currentContextPO = new List<Product_Offerings__c>(); // Store Current context PO's 
            List<String> ReqPoLst  = new List<String>();  // Store Current context PO's mobile no.
            
            Map< String,List<Product_Offerings__c>>   ReqMap = new Map< String,List<Product_Offerings__c>>(); // for showing error
            
            
            for(Product_Offerings__c productOffering: Trigger.new){
                
                if( productOffering.Products__c != null && productOffering.Mobile_Web__c != null && 
                   (productOffering.Products__c.equalsIgnoreCase('PRO') || productOffering.Products__c.equalsIgnoreCase('DOCTORS') )){              
                     if(Trigger.isbefore && Trigger.isInsert){  
                          ReqPoLst.add(productOffering.Mobile_Web__c);
                          flag = true;
                          }
                        if(Trigger.isbefore && Trigger.isUpdate && ((trigger.oldmap.get(productOffering.id).Mobile_Web__c != null ) && !trigger.oldmap.get(productOffering.id).Mobile_Web__c.equalsIgnoreCase(productOffering.Mobile_Web__c) )){  
                          ReqPoLst.add(productOffering.Mobile_Web__c);
                          flag = true;
                          }  
                          currentContextPO.add(productOffering);
                             
                     List<Product_Offerings__c> ReqPoList3  = new List<Product_Offerings__c>();   // for taking map values
                                                     
                       if(ReqMap.containsKey(productOffering.Mobile_Web__c)) {
                           ReqPoList3 = ReqMap.get(productOffering.Mobile_Web__c);  
                           currentContextDuplicatePO.add(productOffering);     // all current po's having same mobile number.              
                       }
                       
                       ReqPoList3.add(productOffering);
                       ReqMap.put(productOffering.Mobile_Web__c,ReqPoList3);
                   }
            }  
            
            if(currentContextDuplicatePO != null && currentContextDuplicatePO.size() > 0){        
                system.debug('Current context PO Having same mobile no -- ' + currentContextDuplicatePO);
                for( Product_Offerings__c currentContextPOhavingSameMobNo : currentContextDuplicatePO ){    
                    currentContextPOhavingSameMobNo.Mobile_Web__c.addError('Multiple PO within current context have Same mobile no'); 
                } 
                flag = false;               
            }
            
          //  system.debug('Current context PO list size -- ' + ReqPoLst.size());
            system.debug('Current context PO list -- ' + ReqPoLst );
            
            if(flag && ReqPoLst != null && ReqPoLst.size() > 0){  
                 
                 Date filterDtbyDays = Date.today().addDays(Integer.valueOf('-'+Label.Differential_CreatedDate_Filter));           
                List<Product_Offerings__c> prodOffList  = [ SELECT id, Products__c, Mobile_Web__c FROM Product_Offerings__c WHERE Data_Mart_Status__c = 'LIVE'  AND 
                                                                  CreatedDate >= :filterDtbyDays  AND 
                                                                      Mobile_Web__c IN :ReqPoLst  AND 
                                                                      Mobile_Web__c != null       AND
                                                                      ( Products__c = 'PRO' OR  Products__c = 'DOCTORS' ) 
                                                                      LIMIT 50000];
                
                if(prodOffList != null && prodOffList.size() > 0){                                 
                    System.debug( prodOffList.size() + ' - Existing PO having same mob no --> ' + prodOffList );
                    
                    
                    List<Product_Offerings__c> ReqPoList  = new List<Product_Offerings__c>(); 
                    
                    
                    for(Product_Offerings__c productOffering: currentContextPO){
                        
                        if(Trigger.isbefore && Trigger.isInsert){
                            if( productOffering.Products__c != null && (productOffering.Products__c.equalsIgnoreCase('PRO') || productOffering.Products__c.equalsIgnoreCase('DOCTORS') )){
                                for( Product_Offerings__c po : prodOffList ){
                                    if( po.Mobile_Web__c ==  productOffering.Mobile_Web__c ){
                                        System.debug('newvalue.Mobile_Web__c  -->' + productOffering.Mobile_Web__c );
                                        System.debug('oldvalue.Mobile_Web__c  -->' + po.Mobile_Web__c );
                                        System.debug('you are inserting PO of type either PRO or DOCTORS with same mobile no of existing PO of type PRO or DOC' );
                                        ReqPoList.add(productOffering);
                                        
                                    }
                                } 
                            }
                        }
                        if(Trigger.isbefore && Trigger.isupdate){
                            if( productOffering.Products__c != null && (productOffering.Products__c.equalsIgnoreCase('PRO') || productOffering.Products__c.equalsIgnoreCase('DOCTORS')) ){
                                if( (trigger.oldmap.get(productOffering.id).Mobile_Web__c == null && productOffering.Mobile_Web__c != null) || 
                                    ( (trigger.oldmap.get(productOffering.id).Mobile_Web__c != null ) && 
                                      !trigger.oldmap.get(productOffering.id).Mobile_Web__c.equalsIgnoreCase(productOffering.Mobile_Web__c) )){              
                                    for( Product_Offerings__c po : prodOffList ){
                                        if( (po.Mobile_Web__c ==  productOffering.Mobile_Web__c) && ( po.ID != productOffering.ID ) ){
                                            system.debug('currtn PO'+ po.ID  + 'Old Matched PO' +  productOffering.ID );
                                            System.debug('newvalue.Mobile_Web__c  -->' + productOffering.Mobile_Web__c );
                                            System.debug('oldvalue.Mobile_Web__c  -->' + po.Mobile_Web__c );
                                            System.debug('you are updating PO of type either PRO or DOCTORS with same mobile no of existing PO of type PRO or DOC' );
                                            ReqPoList.add(productOffering);
                                            
                                        }
                                    } 
                                }
                            }
                        }
                        
                        
                    }
                    
                    if( ReqPoList != null && ReqPoList.size() > 0){
                        system.debug('Existing PO Having same mobile no Current context PO ' + ReqPoList);
                        for ( Product_Offerings__c errorPO : ReqPoList ){
                            errorPO.Mobile_Web__c.addError('Duplicate PO record with this Mobile Number is available in SFDC ');            
                        }               
                    }  
                }
                
            }  
            
        }
    }
}