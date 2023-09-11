trigger SBS_Calculation on Product_Offerings__c (before insert,before update) {
    ID Pid=Userinfo.getProfileID();
    system.debug('***SBS_Calculation Trigger***');
    system.debug('Profle Id**********************'+Pid);
     //Added by leena for Bug 17550 - Need to put profile condition in PO/Lead and Lead Applicant triggers
     string Pid1=Userinfo.getProfileID();
     string Ids = Label.PO_Trigger_restrictedUserId;
     set < string > restrictedIdsSet = new set < string > ();
     if (ids != null) {
            restrictedIdsSet.addAll(Ids.split(';'));
        }
    if(Pid!='00e90000000tgyE' && pid!='00e90000000nWfu'&& (!restrictedIdsSet.contains(Pid1)))
    {
        system.debug('inside profile******************* '+SBS_Utilities.SBSCalculationTriggerCalled);
        if(!SBS_Utilities.SBSCalculationTriggerCalled){
        String productOfferingType=  '';//added for flexi
        //id leadId;//added for flexi
        SBS_Utilities sbutility = new SBS_Utilities();
        List<Product_Offerings__c> prodOfferingList = new List<Product_Offerings__c>();
        String productValues='';
        Set<Id> ownerIds = new Set<Id>();
        Boolean salLineflag = false;
        Boolean autoTopUp = false;
    
    //Map<Id,Sourcing_Channel__c> ASMAssignedMap = new Map<Id,Sourcing_Channel__c>();
    for(Product_Offerings__c productOffering: Trigger.new){
        //System.debug('Trigger.new=='+Trigger.new);
        // added for flexi
        /*if(productOffering.Lead__c !=null) {
            leadId =  productOffering.Lead__c;
        }*/
        // flexi end

        
                String prod = productOffering.Products__c;
                if (ProductSMS__c.getValues('SalariedLineAsignmentProducts') != null) {
                            String products = ProductSMS__c.getValues('SalariedLineAsignmentProducts').Produtc__c;
                            if (products != null) {
                                system.debug('***products***' + products);
                                String[] arr = products.split(';');
                                for (String str: arr) {
                                   if(!CommonUtility.isEmpty(str) && !CommonUtility.isEmpty(prod)){
                                       if(str.ToUpperCase() == prod.ToUpperCase())
                                           salLineflag = true; 
                                   }
                                }
                            }
                }
                //DG Auto TopUP start
                if(ProductSMS__c.getValues('DGAutoTopUp') != null && ProductSMS__c.getValues('DGAutoTopUp').Produtc__c != null)
                {
                    List<String> product  = new List<String>();
                    product = ProductSMS__c.getValues('DGAutoTopUp').Produtc__c.split(';');
                    for(String pro : product)
                    {
                        if((productOffering.Product_Offering_Source__c == 'DIPOS' || productOffering.Product_Offering_Source__c == 'DGAUTOTOPUP' ) && pro.toUpperCase() == productOffering.Products__c.toUpperCase())
                        {
                            autoTopUp = true;
                        }
                    }
                        
                }
                //DG Auto TopUp end
        
                
        if(productoffering.Offer_Amount__c != null){
            
            if(productoffering.Offer_ROI__c!=null && !ControlRecursiveCallofTrigger_Util.hasskipEmiCalc()){
                //DG Auto TopUP condition added
                 if(salLineflag == true || autoTopUp ==true){
                       productoffering.EMI_Amount__c = Math.round(sbutility.PMT(double.valueof((productoffering.Offer_ROI__c==null?productoffering.Revised_Offer_ROI__c:productoffering.Offer_ROI__c)/1200),integer.valueof((productoffering.Availed_Tenor__c==null?0:productoffering.Availed_Tenor__c)),
                    double.valueof((productoffering.Final_Amount__c==null?0:productoffering.Final_Amount__c)))); 
                  system.debug('in Line Assignment');
                 }else{
                    
                        system.debug('inside else');
                        productoffering.EMI_Amount__c = sbutility.PMT(double.valueof((productoffering.Offer_ROI__c==null?productoffering.Revised_Offer_ROI__c:productoffering.Offer_ROI__c)/1200),integer.valueof((productoffering.Tenor__c==null?0:productoffering.Tenor__c))*12,
                        double.valueof((productoffering.Final_Amount__c==null?0:productoffering.Final_Amount__c)));
                  
                }
            }
          
          
          /*
           productoffering.EMI_Amount__c = sbutility.PMT(double.valueof(productoffering.Offer_ROI__c/1200),integer.valueof(productoffering.Tenor__c*12),
             double.valueof(productoffering.Final_Amount__c)); 
          
           productoffering.EMI_Amount__c =  sbutility.PMT(double.valueOf((productoffering.Offer_ROI__c==null?0:productoffering.Offer_ROI__c)/1200),
                                           integer.valueOf((productoffering.Tenor__c==null?0:productoffering.Tenor__c))*12,
                                           double.valueOf((productoffering.Availed_Amount__c == null?productoffering.Offer_Amount__c:productoffering.Availed_Amount__c)*(-100000)));
            */     
           System.debug('productoffering.EMI_Amount__c###'+productoffering.EMI_Amount__c);
           productValues = productValues + ',\''+productOffering.Products__c +';\'';
           ownerIds.add(productOffering.ownerId);
       }
    }
    productValues = productValues.replaceFirst(',','');
    System.debug('productValues###'+productValues);
    // To check if ASM is owner and send email alert and SMS
    
    /*for(Sourcing_Channel__c sc:[Select s.Reporting_Manager__c,s.Reporting_Manager__r.Mobile_number__c From Sourcing_Channel__c s where s.Reporting_Manager__c in:ownerIds]){
        ASMAssignedMap.put(sc.Reporting_Manager__c, sc);
    }*/
    String query;
    //harsit-----optimization START
    //merged the both queries into one and seperating the records by proccessing through for loop
    if(productValues.length()>0) {
         query = 'Select s.id,s.Start_Date__c, s.Scheme_Group__c, s.Scheme_Code__c,s.Existing_Product__c,';
         query +='s.Products__c, s.Product__c, s.PF__c, s.Name, s.Min_ROI__c,s.Property_type__c,'; 
         query +='  s.Min_Loan_amount__c, s.Max_Loan_Amount__c, s.MIn_PF__c,s.Employment_type__c, ';
         query +=' s.FinnOne_Scheme_Code__c, s.End_Date__c, s.Credit_Program_Code__c,s.ROI__c, ';
         query +=' s.Branch__c From Scheme_Master__c s where (s.Products__c INCLUDES ('+productValues+')';
         query +=' and Active__c = true and s.Scheme_Code__c NOT IN (\'%dummy%\')) OR (s.Scheme_Code__c like \'%dummy%\') ';
    }
    System.debug('query###'+query);    
    //List<Scheme_Master__c> schemeList = Database.query;
    /*List<Scheme_Master__c> dummyScheme = [select s.id,s.Start_Date__c, s.Scheme_Group__c, s.Scheme_Code__c,s.Existing_Product__c, 
                                         s.Products__c, s.Product__c, s.PF__c, s.Name, s.Min_ROI__c,s.Property_type__c, 
                                         s.Min_Loan_amount__c, s.Max_Loan_Amount__c, s.MIn_PF__c,s.Employment_type__c, 
                                         s.FinnOne_Scheme_Code__c, s.End_Date__c, s.Credit_Program_Code__c,s.ROI__c, 
                                         s.Branch__c From Scheme_Master__c s where s.Scheme_Code__c like '%dummy%'];    */                                
    
    //List<String> ASMPhNoList = new List<String>();
    //List<String> ASMMsgList = new List<String>();
    Map<Id,String> productOfferingIdsMap = new Map<Id,String>();
    
   // List<Lead> leadList = [Select id , Product_Offering_Type__c from Lead where id=:leadId]; //added for flexi
    //List<Lead> leadList = [Select id from Lead where id=:leadId]; //added for flexi
    
    List<Scheme_Master__c> schemeList = new List<Scheme_Master__c>();
    List<Scheme_Master__c> dummyScheme = new List<Scheme_Master__c>();
    List<Scheme_Master__c> allSchemes = new List<Scheme_Master__c>();
    Boolean isQueryExecute = false;
    //harsit-----optimization END
    //if( query != null)
        //schemeList = Database.query(query);
    
    for(Product_Offerings__c productOffering: Trigger.new){
        
        
        
        
        Boolean schemeMatched = false;
        Integer schemeMatchedCount = 0;
        //System.debug('Trigger.new=='+Trigger.new);
        //SBS_Utilities.setSBSCalculationTriggerCalled();
    
    // added for flexi
    /*if(leadList.size() > 0) {
            productOfferingType = leadList[0].Product_Offering_Type__c;
        }    
        system.debug('### productOfferingType ### '+productOfferingType);*/
    
    // end flexi
    
    // Condition matched for scheme master
    /*
        Offer amount should be within min. and max range, Offer ROI (if entered) whould be within scheme master range,
        PF% (If entered) whould be within scheme master PF% limit, Employment and property type(If entered) should match with scheme master
        If all conditions are matched, then appropriate scheme is assigned to the product, Or else dummy scheme is mapped
    */
     //changes for lead-product offering type field
        if(query!= null  && productOffering.Product_Offering_Type1__c=='SBS' && productOffering.Product_Offering_Type1__c!='FLEXI'){// added for flexi
          //harsit----optimization START
            // query will execute once in case of po type 'SBS'
            if((CommonUtility.isEmpty(dummyScheme) || CommonUtility.isEmpty(schemeList)) && !isQueryExecute){
                allSchemes = Database.query(query); // This query is in for loop, but it will execute once
                isQueryExecute = true;
                if(!CommonUtility.isEmpty(allSchemes)){
                    for(Scheme_Master__c scm : allSchemes){
                        if(scm.Scheme_Code__c != null && scm.Scheme_Code__c.containsIgnoreCase('dummy')){
                            dummyScheme.add(scm);
                        }else{
                            schemeList.add(scm);
                        }
                    }
                }
            }
        //harsit----optimization END
        for(Scheme_Master__c schemeMaster : schemeList){
            if(schemeMaster.Scheme_Code__c == null || !schemeMaster.Scheme_Code__c.contains('dummy')){
                /*System.debug('productOffering.PF__c%%'+productOffering.PF__c);
                System.debug('schemeMaster.PF__c%%'+schemeMaster.PF__c);
                System.debug('schemeMaster.Min_PF__c%%'+schemeMaster.Min_PF__c);
                System.debug('productOffering.Offer_Amount__c$$$'+productOffering.Offer_Amount__c); */
                
                System.debug('schemeMaster.Min_Loan_amount__c%%'+schemeMaster.Min_Loan_amount__c);
                System.debug('schemeMaster.Max_Loan_amount__c%%'+schemeMaster.Max_Loan_amount__c);
                
                 System.debug('productOffering.Availed_Amount__c%'+productOffering.Availed_Amount__c);
                  System.debug('productOffering.Offer_Amount__c%'+productOffering.Offer_Amount__c);
                if ( ((productOffering.Availed_Amount__c==null?productOffering.Offer_Amount__c:productOffering.Availed_Amount__c)
                         >= schemeMaster.Min_Loan_amount__c 
                    && (productOffering.Availed_Amount__c==null?productOffering.Offer_Amount__c:productOffering.Availed_Amount__c)
                         <= schemeMaster.Max_Loan_amount__c
                         
                    &&  productOffering.Products__c == 'SBS CS FAS') ||
                
                    (((productOffering.Availed_Amount__c==null?productOffering.Offer_Amount__c:productOffering.Availed_Amount__c)
                         >= schemeMaster.Min_Loan_amount__c 
                    && (productOffering.Availed_Amount__c==null?productOffering.Offer_Amount__c:productOffering.Availed_Amount__c)
                         <= schemeMaster.Max_Loan_amount__c)
                    && (schemeMaster.Existing_Product__c == null || productOffering.Existing_Product__c == schemeMaster.Existing_Product__c)
                    && (schemeMaster.Employment_type__c == null || productOffering.Employment_type__c == schemeMaster.Employment_type__c)
                    && (schemeMaster.Property_type__c == null || productOffering.Property_type__c == schemeMaster.Property_type__c)) )                    
                    { 
                       productOffering.SBS_Scheme__c = schemeMaster.id; 
                       productOffering.PF__c = schemeMaster.PF__c;
                       if(!productOffering.Rate_Approved__c)
                           productOffering.Offer_ROI__c = schemeMaster.ROI__c;
                       schemeMatched = true;
                       schemeMatchedCount = schemeMatchedCount +1;
                       break;
                    }
                }
            }
        if(productoffering.Offer_Amount__c != null){
          
            if(productoffering.Offer_ROI__c!=null){
                    
                        productoffering.EMI_Amount__c = sbutility.PMT(double.valueof((productoffering.Offer_ROI__c==null?productoffering.Revised_Offer_ROI__c:productoffering.Offer_ROI__c)/1200),integer.valueof((productoffering.Tenor__c==null?0:productoffering.Tenor__c))*12,
                        double.valueof((productoffering.Final_Amount__c==null?0:productoffering.Final_Amount__c))); 
                    
            }
            
 
           
             /*      
               productoffering.EMI_Amount__c =  (sbutility.PMT(double.valueOf((productoffering.Offer_ROI__c==null?0:productoffering.Offer_ROI__c)/1200),
                                           integer.valueOf((productoffering.Tenor__c==null?0:productoffering.Tenor__c)),
                                           double.valueOf(productoffering.Final_Amount__c))).round();
             */
        } 
        
        if(productoffering.Tenor__c == null) {
            productoffering.EMI_Amount__c = null;
        }                     
    
        System.debug('schemeMatched ##'+schemeMatched+ '--name--' +productOffering.name);    
        // if no scheme matched or multiple scheme records found        
        if(!schemeMatched || schemeMatchedCount != 1){
            if(Trigger.isInsert){
            //map dummy scheme to the product
            
            if(dummyScheme!=null && dummyScheme.size()>0 && dummyScheme.get(0) != null){
                productOffering.SBS_Scheme__c = dummyScheme.get(0).id; 
            }
            }else if(Trigger.isUpdate){
                
                if(!schemeMatched && (!SBS_Utilities.SBSProductTriggerCalledFromLead)){
                    productOffering.addError('No matching Scheme available for product '+productOffering.name);
                    //new Exception();
                }                    
                else if (schemeMatchedCount != 1){
                     productOfferingIdsMap.put(productOffering.id,'Mutiple Scheme records found');
                }
                if(SBS_Utilities.SBSProductTriggerCalledFromLead && (!schemeMatched || schemeMatchedCount != 1)){
                    if(dummyScheme!=null && dummyScheme.size()>0 && dummyScheme.get(0) != null){
                    productOffering.SBS_Scheme__c = dummyScheme.get(0).id; 
                    }
                }
            }
        } 
       }    
       
       //CIBIL Watch Start
       
       
        // @Gaurav: Added conditions for SOL Product.
        // Bug ID: 11266
        // Assign Online Telecallers Queue as Owner of PO for SOL Products.
        // 31 Jan 2017 - Start
       

        system.debug('---CIBIL Watch Start ---');
        if(Trigger.isInsert &&  productOffering.Products__c != null && 
            (productOffering.Products__c == 'SAL' || 
             productOffering.Products__c == 'SPL' || 
             productOffering.Products__c == 'SOL') ){
            
            Lead objLead;
            system.debug('---productOffering.Lead__c---'+productOffering.Lead__c);
            if(productOffering.Lead__c!=null){
                objLead = new Lead();
                objLead = [Select id,DNC_Flag__c from Lead where id=:productOffering.Lead__c LIMIT 1];
            }
            if(objLead != null){
                //if(Trigger.isInsert){
                    //system.debug('---Inside isUpdate---');
                    system.debug('---Now checking condition to assign queue as owner of PO---');
                                        
                    if(objLead.DNC_Flag__c != null && 
                        objLead.DNC_Flag__c=='No' && 
                        productOffering.Enquiry_Date__c != null && 
                        productOffering.Enquiry_Date__c.date() == system.today() && 
                        productOffering.Product_Offering_Source__c != null && 
                        productOffering.Product_Offering_Source__c=='Cibil 2' && 
                        LaonApplicationCreation__c.getValues('SAL Owners Queue') != null &&
                        LaonApplicationCreation__c.getValues('SAL Owners Queue').SAL_SPL_Verifier_Queue__c != null){

                        system.debug('---productOffering.Product_Offering_Source__c---'+productOffering.Product_Offering_Source__c);
                        system.debug('---objLead.DNC_Flag__c---'+objLead.DNC_Flag__c);
                        system.debug('---Inside condition, Enq date- today, assigning SAL Owners Queue as owner of PO---');
                        productOffering.ownerId = LaonApplicationCreation__c.getValues('SAL Owners Queue'). SAL_SPL_Verifier_Queue__c;

                    }
                    else if(objLead.DNC_Flag__c != null && objLead.DNC_Flag__c=='No' && 
                            productOffering.Products__c=='SOL' &&
                            LaonApplicationCreation__c.getValues('SOL Line Owners Queue') != null &&
                            LaonApplicationCreation__c.getValues('SOL Line Owners Queue').SAL_SPL_Verifier_Queue__c != null){
                    
                            system.debug('---Inside condition, assigning SOL queue as owner of PO---');
                            productOffering.ownerId = LaonApplicationCreation__c.getValues('SOL Line Owners Queue').SAL_SPL_Verifier_Queue__c;
                    
                    }       
                    
                    
                    
                    
                    /*
                    //Call center sales process Start
                    else{
                        if(objLead.DNC_Flag__c=='No'){
                            system.debug('---Inside Call center sales process condition---');
                            system.debug('---Assign PO to SAL Tele-Calling Team---');
                            productOffering.ownerId='00G90000000tVfE';
                        }
                    }
                    //Call center sales process End
                    */
                //}
                /*
                if(Trigger.isUpdate){
                    system.debug('---Inside isUpdate---');
                    if(objLead.DNC_Flag__c=='No' && productOffering.Enquiry_Date__c!=null && productOffering.Enquiry_Date__c.date()==system.today() && productOffering.Product_Offering_Source__c=='Cibil 2'){
                        system.debug('---Inside condition---');
                        productOffering.ownerId='00G90000000tVfE';
                    }
                    
                    /*
                    //Call center sales process Start
                    else{
                        if(objLead.DNC_Flag__c=='No'){
                            system.debug('---Inside Call center sales process condition---');
                            system.debug('---Assign PO to SAL Tele-Calling Team---');
                            productOffering.ownerId='00G90000000tVfE';
                        }
                    }
                    //Call center sales process End
                 */   
                
                
                
                
                
                // @Gaurav: Added conditions for SOL Product.
                // Bug ID: 11266
                // Assign Online Telecallers Queue as Owner of PO for SOL Products.
                // 31 Jan 2017 - End
                
                
            }

        }//CIBIL Watch End          
    }
    SBS_Utilities.setSBSCalculationTriggerCalled();
  }
  }   
}