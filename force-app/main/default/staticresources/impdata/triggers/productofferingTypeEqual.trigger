trigger productofferingTypeEqual on Product_Offerings__c(before update) {
 //system workflow Enhancement Pramod S
 public Date SOLStampdate;
 public boolean SOLStampFlag {
  get;
  set;
 }
 public String digiLoungeProducts {
  get;
  set;
 }
  public Set < String > digiProds = new Set < String > ();
 //Harsit---Optimization START
 //This handler object is using only if SOLStampFlag is true. So , it is better if we created the object only in that conditition
 //ASMRoundRobinHandler ASMRoundRobinHandlerObj = new ASMRoundRobinHandler(Trigger.new, Trigger.oldMap, Trigger.newMap);
    ASMRoundRobinHandler ASMRoundRobinHandlerObj;
 //Harsit---Optimization END
 //system workflow Enhancement Pramod E
 //Bug 4638 S
 String ph;
 String mess;
 List < string > messages = new List < string > ();
 List < string > mobileNumbers = new List < string > ();
 //Bug 4638 E
 //BUG 23901 start
 ID Pid = Userinfo.getProfileID();
 //Added by leena for Bug 17550 - Need to put profile condition in PO/Lead and Lead Applicant triggers
    string Pid1 = Userinfo.getProfileID();
    string Ids = Label.PO_Trigger_restrictedUserId;
    set < string > restrictedIdsSet = new set < string > ();
    if (ids != null) {
        restrictedIdsSet.addAll(Ids.split(';'));
    }
    if (restrictedIdsSet.contains(Pid1)) 
        return;
        //BUG 23901 end
 if (pid == '00e90000000nWfu') {
  for (Product_Offerings__c p: system.trigger.new) {

   if (p.Product_Offering_Type__c != null) {
    if (p.Product_Offering_Type__c != p.Product_Offering_Type1__c) {
     p.Product_Offering_Type1__c = p.Product_Offering_Type__c;
    }

   } //end of if        
  } // end of for

 }
 //Bug 4638 S 
 //system workflow Enhancement Pramod S
 SOLStampdate = null;
 SOLStampFlag = false;
 if (LaonApplicationCreation__c.getValues('Sales Hierarchy Stamping') != null) {
  String SOLDate = LaonApplicationCreation__c.getValues('Sales Hierarchy Stamping').Sales_Hierarchy_Stamping_Date__c;
  if (SOLDate != null) {
   system.debug('***SOLDate***' + SOLDate);
   SOLStampdate = date.parse(SOLDate);
  }
 }
 system.debug('***SOLStampdate***' + SOLStampdate);
 //code added by Pramod Nishane dated 15 Jully 2016 for CR 7843 S


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
 //system workflow Enhancement Pramod E
 if (trigger.isUpdate && Trigger.isBefore) {
  if (!ControlRecursiveCallofTrigger_Util.haspoTypeEqualUpdate()) {
   ControlRecursiveCallofTrigger_Util.setpoTypeEqualUpdate();
   system.debug('In 4638');
   Set < Id > asmIds = new Set < Id > ();
   Set < Id > sourcingIds = new Set < Id > ();
   Set < Id > leadIds = new Set < Id > ();
   Set < Id > rsmIds = new Set < Id > ();
    
    /** 
      Single query on Product_Offerings__c to reduce additional query on user, lead and scheme master by querrying relational object fields
    **/
    Map<Id, Product_Offerings__c> POMap; 
    //harsit---optimization START
    //preparing the map if needed....moved the code below
    /*if(Trigger.New != null && Trigger.New.size() > 0) {
        POMap = new Map<Id, Product_Offerings__c>([SELECT ASM__r.id, ASM__r.Name, ASM__r.Mobile_number__c,
                                                   RSM__r.id, RSM__r.Name, RSM__r.Mobile_number__c,
                                                   Sourcing_Channel__r.id, Sourcing_Channel__r.Name, Sourcing_Channel__r.Sourc_Mobile__c,
                                                   Lead__r.id, Lead__r.Name, Lead__r.Customer_Mobile__c, Lead__r.Customer_Name__c
                                                   FROM Product_Offerings__c 
                                                   WHERE Id IN : Trigger.New]);
    }*/
    //harsit---optimization END    
    Map < String, Product_Offerings__c > userMap = new Map < String, Product_Offerings__c > ();
    Map < String, Product_Offerings__c > userMapSourcing = new Map < String, Product_Offerings__c > ();
    Map < String, Product_Offerings__c > leadMap = new Map < String, Product_Offerings__c > ();
   
   for (Integer i = 0; i < trigger.new.size(); i++) {
    //code added by Pramod Nishane dated 15 Jully 2016 for CR 7843 S
    if (digiProds != null && digiProds.size() > 0 && !CommonUtility.isEmpty(trigger.new[i].Products__c) && digiProds.contains(trigger.new[i].Products__c.ToUpperCase())) {
     //code added by Pramod Nishane dated 15 Jully 2016 for CR 7843 E
     system.debug('in Digital Lounge Condition');
     //system workflow Enhancement Pramod S
     if (SOLStampdate != null && SOLStampdate < trigger.new[i].createddate) {
      SOLStampFlag = true;
     }
     system.debug('***SOLStampFlag***' + SOLStampFlag);
     if (SOLStampFlag) {
      //Harsit---Optimization START
      //will create the ASMRoundRobinHandlerObj in this IF block... and this object will create once because I added null condition here
      if(ASMRoundRobinHandlerObj == NULL){
        ASMRoundRobinHandlerObj = new ASMRoundRobinHandler(Trigger.new, Trigger.oldMap, Trigger.newMap);
      }
      ASMRoundRobinHandlerObj.assignASMRR();
      //ASMRoundRobinHandlerObj.updateOwnerToCustomerOwner();
      if (trigger.new[i].Product_Offering_Converted__c == true) {
       ASMRoundRobinHandlerObj.sendMailToTeleRM(trigger.new[i]);
      }
      //Harsit---Optimization END
     }
     //system workflow Enhancement Pramod E
     // start of query optimization changes by niraj
     if (trigger.new[i].ASM__c != null && trigger.new[i].Sourcing_Channel__c != null && trigger.new[i].Lead__c != null) {
      //asmIds.add(trigger.new[i].ASM__c);
      //sourcingIds.add(trigger.new[i].Sourcing_Channel__c);
      //leadIds.add(trigger.new[i].Lead__c);
      //harsit----optimization START
      //here..we will query to prepare the map, if the map is null.....So the query will be execute once.
      if(POMap == null){
        if(Trigger.New != null && Trigger.New.size() > 0) {
        POMap = new Map<Id, Product_Offerings__c>([SELECT ASM__r.id, ASM__r.Name, ASM__r.Mobile_number__c,
                                                   RSM__r.id, RSM__r.Name, RSM__r.Mobile_number__c,
                                                   Sourcing_Channel__r.id, Sourcing_Channel__r.Name, Sourcing_Channel__r.Sourc_Mobile__c,
                                                   Lead__r.id, Lead__r.Name, Lead__r.Customer_Mobile__c, Lead__r.Customer_Name__c
                                                   FROM Product_Offerings__c 
                                                   WHERE Id IN : Trigger.New]);
        }
      }
      //harsit----optimization END
      Product_Offerings__c tempPO = POMap.get(trigger.new[i].id);
      if(tempPO.ASM__c != null) {   
        userMap.put(tempPO.ASM__c, tempPO);
      } 
      if(tempPO.Sourcing_Channel__c != null) {  
        userMapSourcing.put(tempPO.Sourcing_Channel__c, tempPO);
      } 
      if(tempPO.Lead__c != null) {
        leadMap.put(tempPO.Lead__c, tempPO);
      }
      if (tempPO.RSM__c != null) {
       system.debug('RSM value in ->' + tempPO.RSM__c);
       //rsmIds.add(trigger.new[i].RSM__c);
       userMap.put(tempPO.RSM__c, tempPO);
      }
     }
     // end of query optimization changes by niraj
    }
   }
   
   
   // start of query optimization changes by niraj
   // following code is commented to reduce three querries into one single query
   /* 
   for (User userTemp: [select id, Name, Mobile_number__c from User where id IN: asmIds OR id IN: rsmIds]) {
    userMap.put(userTemp.Id, userTemp);
   }
   for (Sourcing_Channel__c userMapSourcingTemp: [select id, Name, Sourc_Mobile__c from Sourcing_Channel__c where id IN: sourcingIds]) {
    userMapSourcing.put(userMapSourcingTemp.Id, userMapSourcingTemp);
   }
   for (Lead leadtemp: [select id, Name, Customer_Mobile__c, Customer_Name__c from Lead where id IN: leadIds]) {
    leadMap.put(leadtemp.Id, leadtemp);
   }
   */
   // end of query optimization changes by niraj
   
   system.debug('leadMap------>>>>>>>>' + leadMap + 'userMapSourcing-------->>>>>>>>>' + userMapSourcing);

   system.debug('userMap size-------->>>>>>>>' + userMap.size() + 'userMap-------->>>>>' + userMap);
   if (userMapSourcing != null && userMapSourcing.size() > 0) {
    for (Product_Offerings__c poObj: Trigger.New) {
     if ((poObj.Salarird_Send_SMS__c == true && poObj.Salaried_SMS_Sent__c != true) && (poObj.Products__c == 'SAL' || poObj.Products__c == 'SPL')) {
      if (poObj.ASM__c != null && userMap.get(poObj.ASM__c) != null && poObj.Lead__c != null && leadMap.get(poObj.Lead__c) != null && poObj.Sourcing_Channel__c != null && userMapSourcing.get(poObj.Sourcing_Channel__c) != null) {
       system.debug('poObj.ASM__c->>>>>>>' + poObj.ASM__c + 'poObj.Sourcing_Channel__c------>>>>>>>' + poObj.Sourcing_Channel__c);
       if (userMap.get(poObj.ASM__c) != null && userMap.get(poObj.ASM__c).ASM__r.Mobile_number__c != null) { // added ASM__r in second condition by niraj
        system.debug('in ASM 1');
        mobileNumbers.add(userMap.get(poObj.ASM__c).ASM__r.Mobile_number__c); // added ASM__r in expression by niraj
        system.debug('in UserMap Mobile->>>>>>>>' + mobileNumbers);
        messages.add(poObj.ASM_SMS_Text__c);
       }
       if (poObj.RSM__c != null && userMap.get(poObj.RSM__c) != null && userMap.get(poObj.RSM__c).RSM__r.Mobile_number__c != null) { // added RSM__r in second condition by niraj
        system.debug('in RSM 1');
        mobileNumbers.add(userMap.get(poObj.RSM__c).RSM__r.Mobile_number__c); // added RSM__r in expression by niraj
        system.debug('in UserMap Mobile->>>>>>>>' + mobileNumbers);
        messages.add(poObj.ASM_SMS_Text__c);
       }
       if (userMapSourcing.get(poObj.Sourcing_Channel__c) != null && userMapSourcing.get(poObj.Sourcing_Channel__c).Sourcing_Channel__r.Sourc_Mobile__c != null) { // added Sourcing_Channel__r in second condition by niraj
        mobileNumbers.add(userMapSourcing.get(poObj.Sourcing_Channel__c).Sourcing_Channel__r.Sourc_Mobile__c); // added Sourcing_Channel__r in expression by niraj
        messages.add(poObj.ASM_SMS_Text__c);
       }
       system.debug('messages---------->>>>>>>>>' + messages);
       system.debug('mobileNumbers Size' + mobileNumbers.size() + 'mobileNumbers---------->>>>>>>>>>' + mobileNumbers);
       if (mobileNumbers.size() > 0 && messages.size() > 0) {
        poObj.Salaried_SMS_Sent__c = true;
        sendsms.sendBulkSMS(messages, mobileNumbers);
       }
      }
     }
    }
   }
  }
 }
 //Bug 4638 E
 

}