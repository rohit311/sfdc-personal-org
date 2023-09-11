trigger ProductOfferingCRUD on Product_Offerings__c(before insert, after insert, before update, after update, before delete, after delete) {
 //system workflow Enhancement Pramod S
 //system workflow Enhancement Pramod S
 public Date SOLStampdate;
 public boolean SOLStampFlag {
  get;
  set;
 }
 SOLStampdate = null;
 SOLStampFlag = false;
 if (LaonApplicationCreation__c.getValues('Sales Hierarchy Stamping') != null) {
  String SOLDate = LaonApplicationCreation__c.getValues('Sales Hierarchy Stamping').Sales_Hierarchy_Stamping_Date__c;
  if (SOLDate != null) {
   system.debug('***SOLDate***' + SOLDate);
   SOLStampdate = date.parse(SOLDate);
  }
 }
 //code added by Pramod Nishane dated 15 Jully 2016 for CR 7843 S
 public String digiLoungeProducts {
  get;
  set;
 }
 public Set < String > digiProds = new Set < String > ();
 if (LaonApplicationCreation__c.getValues('Digital Lounge System Workflow Prods') != null) {
  digiLoungeProducts = LaonApplicationCreation__c.getValues('Digital Lounge System Workflow Prods').Products__c;
  if (digiLoungeProducts != null) {
   String[] arr = digiLoungeProducts.split(';');
   for (String str: arr) {
    digiProds.add(str.ToUpperCase());
   }
  }
 }
 //code added by Pramod Nishane dated 15 Jully 2016 for CR 7843 E
 system.debug('***SOLStampdate***' + SOLStampdate);
 //system workflow Enhancement Pramod E
 //harsit----optimization START
 //moving the initilaization of 'handler' object in each block individually. So that..the object will create only if it is needed...it will save the query count.
 //ProductOfferingCRUDHandler handler = new ProductOfferingCRUDHandler(Trigger.oldmap, Trigger.new, Trigger.newMap);
 //Added by leena for Bug 17550 - Need to put profile condition in PO/Lead and Lead Applicant triggers
   //BUG 23901 start
    string Pid = Userinfo.getProfileID();
    string Ids = Label.PO_Trigger_restrictedUserId;
    set < string > restrictedIdsSet = new set < string > ();
    if (ids != null) {
        restrictedIdsSet.addAll(Ids.split(';'));
    }
    if (restrictedIdsSet.contains(Pid)) 
        return;
//BUG 23901 end
 ProductOfferingCRUDHandler handler;
 //harsit---optimization end
 if (trigger.isInsert && Trigger.isAfter) {
    //harsit---optimization START
    handler = new ProductOfferingCRUDHandler(Trigger.oldmap, Trigger.new, Trigger.newMap);
    //harsit---optimization END
    handler.OnAfterInsert(Trigger.new);
    // Start of general communication framework
    System.debug('Calling communicationHandler OnAfterInsert ..................');
    ProductOfferingCRUDHandler.communicationHandler(true,Trigger.oldMap,trigger.New);
    // End of general communication framework
 }
 if (trigger.isUpdate && Trigger.isBefore) {
  if (!ControlRecursiveCallofTrigger_Util.hasBeforeCRUDUpdate()) {
   ControlRecursiveCallofTrigger_Util.setBeforeCRUDUpdate();
   //harsit---optimization START
   handler = new ProductOfferingCRUDHandler(Trigger.oldmap, Trigger.new, Trigger.newMap);
   //harsit---optimization END
   handler.OnBeforeUpdate(Trigger.oldMap, trigger.new);
    // 18161 AllocationPOCleaning AP 
   handler.AllocationPOCleaning(trigger.new);
   handler.checkModeOfPayment(Trigger.new);//Open ECS Auto update - Bug 16615
  }
     //21756
     ProductOfferingCRUDHandler.updatePOOwnerCIBIL(Trigger.new, Trigger.oldMap, true);
 }
 if ((trigger.isInsert && Trigger.isAfter) || (trigger.isUpdate && Trigger.isAfter)) {
     System.debug('In trigger.isInsert && Trigger.isAfter');
     // MOB Trigger Mail - S
        //List<Product_Offerings__c> fetchedListPOTriggerNew = [select id, name, Existing_Customer_Segmentation__c, Existing_LAN__c, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Offer_Amount__c, Customer_Segment__c, Cibil_Score__c, Lead_Source__c, Lead_Name__c, Lead__r.name, Lead__r.company, Lead__r.SBS_Branch__r.Name, Lead__r.MobilePhone, Owner.Name, Owner.Email, Owner.Profile.Name from Product_Offerings__c where Id in :Trigger.newMap.keySet()];
        ProductOfferingMailHandler poMailHandlerObj = new ProductOfferingMailHandler(Trigger.oldMap,Trigger.newMap);
        poMailHandlerObj.RMAssignSendMail();
     // MOB Trigger Mail - E
     
           /*Code added by : Varsha
             Bug id        : 8306
             Description   : Elite Card 
             Pre-pod       : 10-03-2017
           */
          //harsit---merged this if block into the below one
          /*
           if (!ControlRecursiveCallofTrigger_Util.haspoCRUDAfterInsertUpdate()) {
           ControlRecursiveCallofTrigger_Util.setpoCRUDAfterInsertUpdate();
           handler.sendMailtoELITECardHolder(Trigger.new);
           System.debug ('First mail should be received!');
           }  */
           /*End of Elite*/
     
  if (!ControlRecursiveCallofTrigger_Util.haspoCRUDAfterInsertUpdate()) {
   ControlRecursiveCallofTrigger_Util.setpoCRUDAfterInsertUpdate();
   //harsit---optimization START
   handler = new ProductOfferingCRUDHandler(Trigger.oldmap, Trigger.new, Trigger.newMap);
   //harsit---optimization END
    //Bug 19469 - Changes in Salaried and self-employed FOS calculator (Desktop) S
            if(trigger.isUpdate && Trigger.isAfter)
                handler.checkProcessingType();
    //Bug 19469 - Changes in Salaried and self-employed FOS calculator (Desktop E
   handler.sendMailtoELITECardHolder(Trigger.new);
   handler.sharingDatawithLeadCustomer(Trigger.oldMap, trigger.new, Trigger.newMap);
   if(Trigger.New != null){
   for (Integer i = 0; i < trigger.new.size(); i++) {
    //code added by Pramod Nishane dated 15 Jully 2016 for CR 7843 S
    if (digiProds != null && digiProds.size() > 0 && trigger.new[i].Products__c != null && digiProds.contains(trigger.new[i].Products__c.ToUpperCase())) {
     //code added by Pramod Nishane dated 15 Jully 2016 for CR 7843 E
     system.debug('in Digi Lounge Condition');
     //system workflow Enhancement Pramod S
     if (SOLStampdate != null && SOLStampdate < trigger.new[i].createddate) {
      SOLStampFlag = true;
     }
     system.debug('***SOLStampFlag***' + SOLStampFlag);
     if (SOLStampFlag) {
      handler.sharingCustomerDatatoTeleAssistTeam(Trigger.oldMap, trigger.new, Trigger.newMap);
      handler.sharingPODatatoTeleRM(Trigger.oldMap, trigger.new, Trigger.newMap);
     }
     //system workflow Enhancement Pramod E
    }
   }
   }
    if(Trigger.isUpdate && Trigger.isAfter) {
        handler.OnAfterUpdate(Trigger.OldMap, Trigger.New); // Added for 18812
    }
  }
    // Start of general communication framework
     System.debug('Calling communicationHandler  ..................');
    ProductOfferingCRUDHandler.communicationHandler(false,Trigger.oldMap,trigger.New);
    // End of general communication framework
      //code added by leena for Bug 14956 - October BRD - CIBIL watch SMS Email alert enhancement start
    if(Trigger.isUpdate && Trigger.isAfter)
    {
    System.debug('Calling communicationHandler  ..................');
    ProductOfferingCRUDHandler.communicationHandlerforCIBIL2(Trigger.oldMap,trigger.New);
    }
     //code added by leena for Bug 14956 - October BRD - CIBIL watch SMS Email alert enhancement start
 }
 //Communication for SAL Line starts 
 if (Trigger.isUpdate && Trigger.isAfter) {
  for (Product_Offerings__c po: Trigger.new) {
   if (Trigger.oldMap.get(po.id).Line_Activated__c != true && po.Line_Activated__c == true && po.Products__c == 'SAL') {
    ProductSMS__C prodsms = new ProductSMS__C();
    prodsms = ProductSMS__C.getValues('SAL LA LineAccepted');
    String smsmsg = prodsms.SMS_Text__c;
    if (po.Unsecured_W_O_BT_Line_Assigned__c != null) smsmsg = smsmsg.replace('*LINE ASSIGNED*', string.valueof(po.Unsecured_W_O_BT_Line_Assigned__c));
    smsmsg = smsmsg.replace('*DATE*', system.today().format());
    if (po.Unsecured_W_O_BT_Line_Available__c != null) smsmsg = smsmsg.replace('*LINE AVAILABLE*', string.valueof(po.Unsecured_W_O_BT_Line_Available__c));
    List < String > message = new List < string > ();
    List < string > mobileno = new List < string > ();
    if (po.Customer_Mobile__c != null) {
     message.add(smsmsg);
     mobileno.add(po.Customer_Mobile__c);
    }
    System.debug('***message' + message);
    System.debug('***mobileno' + mobileno);


    //Send SMS to customer

    if (message.size() > 0 && mobileno.size() > 0) sendsms.sendBulkSMS(message, mobileno);

   }
   System.debug('************po' + Trigger.oldMap.get(po.id).Line_Activated__c + '@@@@' + po.Line_Activated__c + '####' + po.Products__c);
   if (Trigger.oldMap.get(po.id).Line_Activated__c != false && po.Line_Activated__c == false && po.Products__c == 'SAL') {
    ProductSMS__C prodsms = new ProductSMS__C();
    prodsms = ProductSMS__C.getValues('SAL LA LineDeactivate');
    String smsmsg = prodsms.SMS_Text__c;
    List < String > message = new List < string > ();
    List < string > mobileno = new List < string > ();
    if (po.Customer_Mobile__c != null) {
     message.add(smsmsg);
     mobileno.add(po.Customer_Mobile__c);
    }
    if (po.Sourcing_Channel__r.Sourc_Mobile__c != null) {
     message.add(smsmsg);
     mobileno.add(po.Sourcing_Channel__r.Sourc_Mobile__c);
    }
    System.debug('***message' + message);
    System.debug('***mobileno' + mobileno);


    //Send SMS to customer and BFL

    if (message.size() > 0 && mobileno.size() > 0) sendsms.sendBulkSMS(message, mobileno);



   }
   if (Trigger.oldMap.get(po.id).Unsecured_W_O_BT_Line_Available__c != po.Unsecured_W_O_BT_Line_Available__c && po.Products__c == 'SAL') {
    ProductSMS__C prodsms = new ProductSMS__C();
    prodsms = ProductSMS__C.getValues('SAL LA MonthlyLineAvailable');
    String smsmsg = prodsms.SMS_Text__c;
    if (po.Unsecured_W_O_BT_Line_Available__c != null) smsmsg = smsmsg.replace('*LINE AVAILABLE*', string.valueof(po.Unsecured_W_O_BT_Line_Available__c));
    List < String > message = new List < string > ();
    List < string > mobileno = new List < string > ();
    if (po.Customer_Mobile__c != null) {
     message.add(smsmsg);
     mobileno.add(po.Customer_Mobile__c);
    }
    if (po.Sourcing_Channel__r.Sourc_Mobile__c != null) {
     message.add(smsmsg);
     mobileno.add(po.Sourcing_Channel__r.Sourc_Mobile__c);
    }
    System.debug('***message' + message);
    System.debug('***mobileno' + mobileno);


    //Send SMS to customer and BFL

    if (message.size() > 0 && mobileno.size() > 0) sendsms.sendBulkSMS(message, mobileno);
   }
  }

 }
 //Communication for SAL Line ends
 /* if PO uploaded via cibil watch, change owner to SME call center queue */
 //Production issue -12159-Added DNC_Flag__c condition in following if condition -Anjali
    if(Trigger.isInsert && Trigger.isBefore){
        List <QueueSobject> queuerec = [SELECT Queue.Name, QueueId from QueueSobject where Queue.Name = 'SME CIBIL Watch Queue' limit 1];
         if(queuerec.size() > 0){
            for(Product_Offerings__c productOffering: Trigger.new){
                   //BUG-17470 HPRO S
                Boolean isPROProductLineProduct = false;
                transient set < string > setPROProdName = new set < string > ();
                if(!commonUtility.isEmpty(Label.PRO_ProductLine_Products))
                    setPROProdName.addAll(Label.PRO_ProductLine_Products.split(';'));
                    if(setPROProdName.size() > 0 && productOffering != null && productOffering.Products__c != null){
                    isPROProductLineProduct = setPROProdName.contains(productOffering.Products__c.toUpperCase());
                }
                //BUG-17470 HPRO E
                if(((productOffering.Product_Offering_Source__c !=null && productOffering.Product_Offering_Source__c.touppercase() == 'CIBIL 2') || (productOffering.Lead_Source__c !=null && productOffering.Lead_Source__c.touppercase() == 'CIBIL 2')) && ( productOffering.Lead__r.DNC_Flag__c != null && productOffering.Lead__r.DNC_Flag__c !='Yes') && (productOffering.Products__c == 'PSBL' || productOffering.Products__c == 'Home Loan' || productOffering.Products__c == 'LAP' || productOffering.Products__c == 'DOCTORS' || isPROProductLineProduct ))
                {
                    productOffering.ownerId =queuerec[0].QueueId;
                }
            }
        }
        //21756
        ProductOfferingCRUDHandler.updatePOOwnerCIBIL(Trigger.new, Trigger.oldMap, false);
    }
    system.debug('before insPORRAssign');
    //ID - Revamp S
    if ((Trigger.isBefore || Trigger.isAfter) && (Trigger.isInsert || Trigger.isupdate)){
        //handler = new ProductOfferingCRUDHandler(Trigger.oldmap, Trigger.new, Trigger.newMap);
        ProductOfferingCRUDHandler.insPORRAssign(Trigger.oldmap, Trigger.new, Trigger.newMap);
    
    }
    //ID - revamp E

 
}