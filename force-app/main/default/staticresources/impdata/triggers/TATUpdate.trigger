/**
 * @author Persistent Systems Ltd.
 * @date 08/02/2012
 * @description Trigger TAT calculation
 */
trigger TATUpdate on Case(before insert, before update) {


 Map < String, Integer > mapOfTAT = new Map < String, Integer > ();

 //START REMI 
 Map < String, Integer > mapOfTATREMI = new Map < String, Integer > ();
 //END REMI 

 Map < Id, Id > mapOfLoanCustomer = new Map < Id, Id > ();
 Map < Id, Loan_INFO__c > mapOfLoanInfo = new Map < Id, Loan_INFO__c > ();
 Map < Id, List < Loan_INFO__c >> mapOfCustomerLoanList = new Map < Id, List < Loan_INFO__c >> ();
 Map < String, Opportunity > mapOfOpport = new Map < String, Opportunity > ();
 List < String > LANNumberList = new List < String > ();
 Set < String > categorySet = new Set < String > ();
 public Set < String > setOfKeywords = new Set < String > ();
 public Set < String > setOfKeywordsEscalation = new Set < String > ();
 public Set < String > setOfKeywordsNewEscalation = new Set < String > ();
 List < Case > updateList = new List < Case > ();
 for (Case caseObj: Trigger.new) {
  categorySet.add(caseObj.Category__c);
 }

//added by Suraj..Service Merchant repeat cases tagging.. start
    if(trigger.isInsert || Trigger.isUpdate){
        repeat_case_SM handlerObj = new repeat_case_SM();
        system.debug('beforecheckhnadler::::');
        handlerObj.updateSMcase(trigger.new);
   }
   //added by Suraj..Service Merchant repeat cases tagging.. end
   
   
 //start request service enhancement
 if (trigger.isInsert && Trigger.isBefore) {
  if (BackOfficeQueue__c.getValues('Duplicate Request') != null && BackOfficeQueue__c.getValues('Duplicate Request').Number_of_Days__c != null) {
   Decimal numberofdays;
   Decimal custmsettingvalue;
   //   String origin = BackOfficeQueue__c.getValues('Duplicate Request').Case_Origin__c;
   //   String[] originList = origin.split(',');

   For(Case caseObj: Trigger.New) {
    List < Case > caseList = [select id, createdDate, Status, CaseNumber, Old_case_Aging__c, Type__c, Sub_Type__c from
     case where Type__c = :
      caseObj.Type__c and FTR__c = 'YES'
      and Sub_Type__c = : caseObj.Sub_Type__c and Loan_INFO__c = : caseObj.Loan_INFO__c order by createdDate DESC limit 1
    ];
    if (caseObj.Origin == 'Branch walk-in') {
     if (caseList != null && caseList.size() > 0) {
      Date oldCaseCreatedDate = date.newinstance(caseList[0].CreatedDate.year(), caseList[0].CreatedDate.month(), caseList[0].CreatedDate.day());
      system.debug('myDate------>' + oldCaseCreatedDate);
      numberofdays = oldCaseCreatedDate.daysBetween(date.TODAY());
      system.debug('numberofdays------>' + numberofdays);
      custmsettingvalue = BackOfficeQueue__c.getValues('Duplicate Request').Number_of_Days__c;
      system.debug('custmsettingvalue------>' + custmsettingvalue);
      if (numberofdays <= custmsettingvalue) {
       // QueuesObject queueObj = [Select Queue.Id from QueueSObject where Queue.Name = 'Back_Office_Repeat_Queue'];
       if (caseObj.Repeat_Cases__c == 'Non-Repeated' || caseObj.Repeat_Cases__c == null) caseObj.addError('Same type of request  ' + caseList[0].CaseNumber + ' has already been raised in last 30 days do still want to go ahead ...Please set Repeat Cases value to "REPEATED"  or else Cancel');
       else {
        caseObj.Old_Case__c = caseList[0].id;
        caseObj.Close_Date_Of_Old_Case__c = caseList[0].createdDate;
        caseObj.Status_of_Old_Case__c = caseList[0].Status;
        caseObj.Old_case_Aging__c = String.valueOf(numberofdays);
        //  caseObj.ownerId = queueObj.id;
       }
      }
     }
    }
   }
  }
 }
 // end of enhancement
 //Creating picklist in TATMaster
 /*
   List<TAT_Master__c> listOfTats = [select Type__c,Sub_Type__c,Revised_TAT_In_days__c,Category__c
                                     FROM TAT_Master__c where Category__c in : categorySet
                                     LIMIT 50000 ];
                                     */
 //REMI Modified Query
 List < TAT_Master__c > listOfTats = [select REMI_Sub_type__c, REMI_Type__c, TypeP__c, Sub_typeP__c, Revised_TAT_In_days__c, CategoryP__c
  FROM TAT_Master__c where CategoryP__c in : categorySet
  LIMIT 50000
 ];
 System.debug('listOfTats====' + listOfTats);
 //REMI Modified Query

 //Comment end Creating picklist in TATMaster                               
 public List < GrievanceRedressal__c > gr = [select Keywords__c from GrievanceRedressal__c limit 100];
 public List < EscalationKeyword__c > escalationWords = [select Keywords__c, HighPriorityKeywords__c from EscalationKeyword__c limit 100];


 public List < Id > listOfLoanNum = new List < Id > ();
 public List < Id > listOfCust = new List < Id > ();
 public List < Id > listOfBranch = new List < Id > ();
 //For branch token
 public List < Branch_Master__c > branchlist = new List < Branch_Master__c > ();
 public List < Branch_Master__c > newBranchList = new List < Branch_Master__c > ();
 for (Case caseObj: Trigger.new) {
  listOfLoanNum.add(caseObj.Loan_INFO__c);
  listOfCust.add(caseObj.Customer_info__c);
  listOfBranch.add(caseObj.Branch_Master__c);
 }

 public List < Loan_INFO__c > listofLoans = [select id, Loan_Number__c, CUSTOMER_INFO__c, Name, Loan_Status__c
  from Loan_INFO__c
  WHERE id in : listOfLoanNum
 ];
 for (Loan_INFO__c loanInfo: listofLoans) { //Map for Loan Info to Customer info
  mapOfLoanCustomer.put(loanInfo.Id, loanInfo.CUSTOMER_INFO__c);
  if (loanInfo.Loan_Number__c != null) LANNumberList.add(loanInfo.Loan_Number__c);

 }

 List < Opportunity > oppObj = [SELECT Id, Name, LAN__c FROM Opportunity WHERE LAN__c in : LANNumberList];

 if (oppObj != null && oppObj.size() > 0) {
  for (Opportunity Opp: oppObj)
   mapOfOpport.put(Opp.LAN__c, Opp);
 }
 System.debug('mapOfLoanCustomer====' + mapOfLoanCustomer);

 public List < CUSTOMER_INFO__c > listofcustomers = [Select Name, Loan_INFO__c, Id, (Select id, Name, Loan_Status__c, Loan_Number__c From Loan_Info__r) From CUSTOMER_INFO__c where id in : listOfCust];
 for (CUSTOMER_INFO__c custInfo: listofcustomers) { //Map for Customer info to List of Loan Info 
  mapOfCustomerLoanList.put(custInfo.Id, custInfo.Loan_Info__r);
  for (Loan_INFO__c loanInfo: custInfo.Loan_Info__r)
   mapOfLoanInfo.put(loanInfo.Id, loanInfo);
 }
 System.debug('mapOfCustomerLoanList====' + mapOfCustomerLoanList);

 System.debug('categorySet====' + categorySet);

 //Creating picklist in TATMaster
 /*   
   if(listOfTats.size() > 0){
       for(TAT_Master__c obj : listOfTats){
           if(obj.Type__c != null && obj.Sub_Type__c != null && obj.Revised_TAT_In_days__c != null && !mapOfTAT.containsKey(obj.Type__c.trim() + obj.Sub_Type__c.trim())){
               System.debug('obj.Category__c===='+obj.Category__c); 
               System.debug('obj.Type__c===='+obj.Type__c); 
               System.debug('obj.Sub_Type__c===='+obj.Sub_Type__c); 
               System.debug('obj.Revised_TAT_In_days__c===='+obj.Revised_TAT_In_days__c); 
               mapOfTAT.put(obj.Type__c.trim() + obj.Sub_Type__c.trim(),Integer.valueOf(obj.Revised_TAT_In_days__c));
           }
       }                            
   }  
   */
 //Comment end


 if (listOfTats.size() > 0) {
  for (TAT_Master__c obj: listOfTats) {
   if (obj.TypeP__c != null && obj.Sub_typeP__c != null && obj.Revised_TAT_In_days__c != null && !mapOfTAT.containsKey(obj.TypeP__c.trim() + obj.Sub_typeP__c.trim())) {
    System.debug('obj.CategoryP__c====' + obj.CategoryP__c);
    System.debug('obj.TypeP__c====' + obj.TypeP__c);
    System.debug('obj.Sub_typeP__c====' + obj.Sub_typeP__c);
    System.debug('obj.Revised_TAT_In_days__c====' + obj.Revised_TAT_In_days__c);
    mapOfTAT.put(obj.TypeP__c.trim() + obj.Sub_typeP__c.trim(), Integer.valueOf(obj.Revised_TAT_In_days__c));
   }
   //START REMI
   if (obj.REMI_Type__c != null && obj.REMI_Sub_type__c != null && obj.Revised_TAT_In_days__c != null && !mapOfTATREMI.containsKey(obj.REMI_Type__c.trim() + obj.REMI_Sub_type__c.trim())) {
    System.debug('obj.CategoryP__c====' + obj.CategoryP__c);
    System.debug('obj.REMI_Type__c====' + obj.REMI_Type__c);
    System.debug('obj.REMI_Sub_type__c====' + obj.REMI_Sub_type__c);
    System.debug('obj.Revised_TAT_In_days__c====' + obj.Revised_TAT_In_days__c);
    mapOfTATREMI.put(obj.REMI_Type__c.trim() + obj.REMI_Sub_type__c.trim(), Integer.valueOf(obj.Revised_TAT_In_days__c));
   }
   //STOP REMI
  }
 }



 // Update TAT value and Customer lookup is populated while case creation   
 if (Trigger.isInsert) {
  for (Case caseObj: Trigger.new) {

   system.debug('==============> tat' + caseObj.TAT__c);
   if (caseObj.Type__c != null && caseObj.Sub_Type__c != null) caseObj.TAT__c = mapOfTAT.get(caseObj.Type__c.trim() + caseObj.Sub_Type__c.trim());

   //START REMI
   if (caseObj.REMI_Type__c != null && caseObj.REMI_Sub_type__c != null) {
    caseObj.TAT__c = mapOfTATREMI.get(caseObj.REMI_Type__c.trim() + caseObj.REMI_Sub_type__c.trim());
   }
   //STOP REMI

   system.debug('==============> tat' + caseObj.TAT__c);
   caseObj.UserInfo__c = UserInfo.getUserId();

   //Below code is for When we create a case from Loan Info, Customer should be automatically get mapped to the case. 

   if (caseObj.Customer_info__c == null && caseObj.Loan_INFO__c != null) {
    if (!util.isEmpty(listofLoans)) {
     if (listofLoans.size() > 0) {
      //caseObj.Customer_info__c=listofLoans.get(0).CUSTOMER_INFO__c;
      system.debug('mapOfLoanCustomer.get(caseObj.Loan_INFO__c)===' + mapOfLoanCustomer.get(caseObj.Loan_INFO__c));
      caseObj.Customer_info__c = mapOfLoanCustomer.get(caseObj.Loan_INFO__c);
     }
    }
   }


   //Below code is for When we create a case from Customer and only 1 loan is mapped to the customer, then loan should get mapped to the case automatically

   if (caseObj.Loan_INFO__c == null && caseObj.Customer_info__c != null) {
    system.debug('@@@@@@@@@@@@@' + listofcustomers);
    if (!Util.isEmpty(listofcustomers)) {
     List < Loan_INFO__c > loanList = mapOfCustomerLoanList.get(caseObj.Customer_info__c);
     system.debug('loanList@@@@@' + loanList);
     caseObj.All_Loan_Info__c = '';
     for (Loan_INFO__c loan: loanList) {
      caseObj.All_Loan_Info__c += loan.Id + ';';
     }
     for (Loan_INFO__c loan: loanList) {
      system.debug('mapOfLoanInfo.get(loan.Id)@@@@@' + mapOfLoanInfo.get(loan.Id));
      if (mapOfLoanInfo.get(loan.Id).Loan_Status__c == 'Active') {
       caseObj.Loan_info__c = loan.Id;
       break;
      }
     }
     system.debug('caseObj.Loan_info__c@@' + caseObj.Loan_info__c);
     /*if(listofcustomers.get(0).Loan_Info__r.size() == 1)
     {
        caseObj.Loan_info__c=listofcustomers.get(0).Loan_Info__r.get(0).id;
     }*/
    }
   }

   // Get expected resolution Date and Time
   if (caseObj.TAT__c != null) {
    caseObj.Expected_Resolution_Date__c = DateTime.now().addDays(Integer.valueOf(caseObj.TAT__c));
   }

   String lowerCaseVal = '';
   if (caseObj.Description != null) {
    lowerCaseVal = caseObj.Description.toLowerCase();
   }


   for (GrievanceRedressal__c g: gr) {
    setOfKeywords.add(g.Keywords__c);
   }

   for (EscalationKeyword__c g: escalationWords) {
    if (g.Keywords__c != null) setOfKeywordsEscalation.add(g.Keywords__c);

    if (g.HighPriorityKeywords__c != null) setOfKeywordsNewEscalation.add(g.HighPriorityKeywords__c);
   }



   for (String s: setOfKeywords) {
    if (caseObj.Description != null) {
     if (lowerCaseVal.contains(s.toLowerCase())) {
      caseObj.isGrievanceRedressal__c = true;
      break;
     } else {
      caseObj.isGrievanceRedressal__c = false;
     }
    }
   }

   /* for(String s: setOfKeywordsEscalation){
       if(caseObj.Description != null){
           if(lowerCaseVal.contains(s.toLowerCase())){
               caseObj.isGrievanceRedressal__c = false;
               caseObj.isEscalation__c = true;
               break;
           }
       }
   }*/
   system.debug('^^^^masetOfKeywordsEscalationtch^' + setOfKeywordsEscalation);
   system.debug('^^^^mlowerCaseVal^' + lowerCaseVal);
   for (String s: setOfKeywordsNewEscalation) {
    if (caseObj.Description != null) {
     if (lowerCaseVal.contains(s.toLowerCase())) {
      caseObj.isGrievanceRedressal__c = false;
      caseObj.isHighPriorityEscalation__c = true;
      break;
     }
    }
   }
   system.debug('^^^^caseObj.isHighPriorityEscalation__c^' + caseObj.isHighPriorityEscalation__c);

   for (String s: setOfKeywordsEscalation) {
    if (caseObj.Description != null) {
     if (lowerCaseVal.contains(s.toLowerCase())) {
      system.debug('^^^^old match ^' + caseObj.isHighPriorityEscalation__c);
      caseObj.isGrievanceRedressal__c = false;
      caseObj.isEscalation__c = true;
      if (caseObj.isHighPriorityEscalation__c == true) caseObj.isHighPriorityEscalation__c = false;
      break;
     }
    }
   }
   system.debug('^^^final^ caseObj.isEscalation__c^' + caseObj.isEscalation__c);
   system.debug('^^final^^caseObj.isHighPriorityEscalation__c^' + caseObj.isHighPriorityEscalation__c);
   //high priority escalation  
   if (caseObj.FTR__c == 'No') {
    caseObj.Status = 'Closed';
    caseObj.Reason = 'Resolved by Self ( FTR )';
   }
   //For branch token
   system.debug('***********caseObj.Token__c&&&&&' + caseObj.Token__c + '&&caseObj.Origin &&&' + caseObj.Origin);
   if (caseObj.Token__c == null && caseObj.Origin == 'Token') {
    String currentDate = system.today().format();
    String[] datenumber = currentDate.split('/');
    system.debug('text size' + datenumber.size());
    String newToken = datenumber[1] + '-' + datenumber[0] + '-';
    system.debug('***********newToken&&&&&' + newToken);
    branchlist = [select Branch_Code__c, Next_Token_Number__c, Name from Branch_Master__c where id in : listOfBranch];

    String currToken = '0001';
    String nextToken = '0001';

    system.debug('***********branchlist&&&&&' + branchlist);
    String branchCity;
    List < User > userList = new List < User > ();
    if (branchlist != null && branchlist.size() > 0) {
     branchCity = branchlist[0].Name;
     userList = [Select Id, profile.Name, Branch_City__c, City__c from User where(Branch_City__c includes(: branchCity) or City__c = : branchCity) and profile.Name = 'Cashier -CRM user'
      and IsActive = true Limit 1
     ];
    }
    if (branchlist != null && branchlist.size() > 0) {
     for (Branch_Master__c br: branchlist) {
      if (br.Next_Token_Number__c != null) {
       nextToken = br.Next_Token_Number__c;
      } else {
       nextToken = '0001';
      }
      currToken = nextToken;
      Integer indexStr = Integer.valueOf(nextToken) + 1;
      nextToken = String.valueOf(indexStr);
      if (nextToken.length() == 3) {
       nextToken = '0' + nextToken;
      }
      if (nextToken.length() == 2) {
       nextToken = '00' + nextToken;

      }
      if (nextToken.length() == 1) {
       nextToken = '000' + nextToken;
      }
      system.debug('***********newToken&&&&&' + nextToken + '***currToken::' + currToken);
      system.debug('***********nextToken&&&&&' + nextToken);
      br.Next_Token_Number__c = nextToken;
      newToken = newToken + currToken;
      newBranchList.add(br);
      //caseObj.Status='New';  
      caseObj.Case_Opened_By_Cashier__c = system.now();
      system.debug('***********newToken&&&&&' + newToken);
      caseObj.Token__c = newToken;
      if (userList != null && userList.size() > 0) {
       caseObj.OwnerId = userList[0].id;
      }
     }
    }

   }
   //CRM 4666 S
   system.debug('--------listofLoans in before insert-----------' + listofLoans);
   if (listofLoans.size() > 0) {
    // if (listofLoans[0].Loan_Number__c != null) {
    Loan_INFO__c loaninfoTemp = new Loan_INFO__c();
    if (caseObj.Loan_INFO__c != null) loaninfoTemp = mapOfLoanInfo.get(caseObj.Loan_INFO__c);
    //List < Opportunity > oppObjTemp = [SELECT Id, Name, LAN__c FROM Opportunity WHERE LAN__c = : listofLoans[0].Loan_Number__c limit 1];
    List < Opportunity > oppObjTemp = new List < Opportunity > ();
    if (loaninfoTemp != null && loaninfoTemp.Loan_Number__c != null && mapOfOpport.get(loaninfoTemp.Loan_Number__c) != null) oppObjTemp.add(mapOfOpport.get(loaninfoTemp.Loan_Number__c));

    system.debug('------oppObjTemp ---------------' + oppObjTemp);
    if (oppObjTemp.size() > 0) {
     system.debug('assigning opp to Case');
     caseObj.Opportunity__c = oppObjTemp[0].Id;
    } else {
     caseObj.Opportunity__c = null;
    }
    // } else {
    //     caseObj.Opportunity__c = null;
    // }
   } else {
    caseObj.Opportunity__c = null;
   }
   //CRM 4666 E
  }
  if (newBranchList != null && newBranchList.size() > 0) upsert newBranchList;
 }
 if (Trigger.isupdate && Trigger.isbefore) {
  set < Id > testId = new set < Id > ();
  for (Case caseObj: Trigger.new) {

   system.debug('***********mapOfTAT.get(caseObj.Type__c + caseObj.Sub_Type__c)&&&&&' + mapOfTAT.get(caseObj.Type__c + caseObj.Sub_Type__c));
   if (caseObj.Type__c != null && caseObj.Sub_Type__c != null) caseObj.TAT__c = mapOfTAT.get(caseObj.Type__c.trim() + caseObj.Sub_Type__c.trim());

   //START REMI
   if (caseObj.REMI_Type__c != null && caseObj.REMI_Sub_type__c != null) {
    caseObj.TAT__c = mapOfTATREMI.get(caseObj.REMI_Type__c.trim() + caseObj.REMI_Sub_type__c.trim());
   }
   //END REMI

   caseObj.UserInfo__c = UserInfo.getUserId();
   testID.add(caseObj.Id);

   if (caseObj.Customer_info__c == null && caseObj.Loan_INFO__c != null) {
    if (!util.isEmpty(listofLoans)) {
     if (listofLoans.size() > 0) {
      //caseObj.Customer_info__c=listofLoans.get(0).CUSTOMER_INFO__c;
      system.debug('mapOfLoanCustomer.get(caseObj.Loan_INFO__c)===' + mapOfLoanCustomer.get(caseObj.Loan_INFO__c));
      caseObj.Customer_info__c = mapOfLoanCustomer.get(caseObj.Loan_INFO__c);
     }
    }
   }

   if (caseObj.Loan_INFO__c == null && caseObj.Customer_info__c != null) {
    system.debug('@@@@@@@@@@@@@' + listofcustomers);
    if (!Util.isEmpty(listofcustomers)) {
     List < Loan_INFO__c > loanList = mapOfCustomerLoanList.get(caseObj.Customer_info__c);
     caseObj.All_Loan_Info__c = '';
     for (Loan_INFO__c loan: loanList) {
      caseObj.All_Loan_Info__c += loan.Id + ';';
     }
     for (Loan_INFO__c loan: loanList) {
      if (mapOfLoanInfo.get(loan.Id).Loan_Status__c == 'Active') {
       caseObj.Loan_info__c = loan.Id;
       break;
      }
     }
     system.debug('caseObj.Loan_info__c@@' + caseObj.Loan_info__c);
     /*if(listofcustomers.get(0).Loan_Info__r.size() == 1)
     {
        caseObj.Loan_info__c=listofcustomers.get(0).Loan_Info__r.get(0).id;
     }*/
    }
   }
   //Get expected resolution Date and Time
   if (caseObj.TAT__c != null) {
    caseObj.Expected_Resolution_Date__c = DateTime.now().addDays(Integer.valueOf(caseObj.TAT__c));
   }

   //For Branch token
   system.debug('&&&&&&&caseObj.Origin &&&&' + caseObj.Origin + '%%%%%%caseObj.Token__c%%%%%%%' + caseObj.Token__c);
   if (caseObj.Token__c != null && caseObj.Origin == 'Token' && caseObj.Status != 'Closed') {
    system.debug('&&&&&&&caseObj.Origin &&&&%%%' + caseObj.Case_Opened_By_Cashier__c);
    caseObj.Token_status__c = 'Token Taken';
    if (caseObj.Case_Opened_By_Cashier__c == null) {
     caseObj.Case_Opened_By_Cashier__c = system.now();
    }
    system.debug('******Done**');


   }
   //CRM 4666 S
   system.debug('--------listofLoans in before update -----------' + listofLoans);
   if (listofLoans.size() > 0) {
    // if (listofLoans[0].Loan_Number__c != null) {
    Loan_INFO__c loaninfoTemp = new Loan_INFO__c();
    if (caseObj.Loan_INFO__c != null) loaninfoTemp = mapOfLoanInfo.get(caseObj.Loan_INFO__c);
    //List < Opportunity > oppObjTemp = [SELECT Id, Name, LAN__c FROM Opportunity WHERE LAN__c = : listofLoans[0].Loan_Number__c limit 1];
    List < Opportunity > oppObjTemp = new List < Opportunity > ();
    if (loaninfoTemp != null && loaninfoTemp.Loan_Number__c != null && mapOfOpport.get(loaninfoTemp.Loan_Number__c) != null) oppObjTemp.add(mapOfOpport.get(loaninfoTemp.Loan_Number__c));

    system.debug('------oppObjTemp ---------------' + oppObjTemp);
    if (oppObjTemp.size() > 0) {
     system.debug('assigning opp to Case');
     caseObj.Opportunity__c = oppObjTemp[0].Id;
    } else {
     caseObj.Opportunity__c = null;
    }
    // } else {
    //     caseObj.Opportunity__c = null;
    // }
   } else {
    system.debug('loan info removed---------------------');
    caseObj.Opportunity__c = null;
   }
   //CRM 4666 E     

  }
 }

 //service officer enhancement
 if ((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)) {
  set < id > custId = new set < id > ();
  for (Case caseObj: Trigger.New) {
   custID.add(caseObj.Customer_info__c);
  }
  system.debug('%%%%%%%%%%%' + custId);
  Map < id, Customer_info__c > custMap = new Map < id, Customer_info__c > ([SELECT Id, owner.email, Service_Officer__c, Service_Officer__r.Name, Service_Officer__r.email, Service_Officer__r.phone FROM Customer_info__c WHERE Id IN: custID]);
  system.debug('^^^^^^^' + custMap);
  for (Case caseObj: Trigger.New) {
   if (caseObj.Customer_info__c != null) {
    Customer_info__c custInfo = custMap.get(caseObj.Customer_info__c);
    caseObj.Service_Officer_Name__c = custInfo.Service_Officer__r.Name;
    caseObj.Service_Officer_Email_Id__c = custInfo.Service_Officer__r.email;
    caseObj.Service_Officer_Mobile__c = custInfo.Service_Officer__r.phone;
    caseObj.Customer_Owner_email__c = custInfo.owner.email;
   }
  }
  //Bug # 12160 S
  if (ATOSParameters__c.getValues('Swapping_Mandate_SMS')!=null && ATOSParameters__c.getValues('Swapping_Mandate_SMS').Value__c != null && ATOSParameters__c.getValues('Swapping_Mandate_SMS').Value__c == 'ON') {
   List < string > messages = new List < string > ();
   List < string > mobileNumbers = new List < string > ();
   Set < String > swapDonelbl = new Set < String > ();
   Set < String > swapNotDonelbl = new Set < String > ();
   Set < String > swapTypelbl = new Set < String > ();
   Set < String > swapSubTypelbl = new Set < String > ();

   if (Label.Case_Swapping_Done != null) {
    String[] arr = Label.Case_Swapping_Done.split(';');
    for (String str: arr) {
     swapDonelbl.add(str.ToUpperCase());
    }
   }
   if (Label.Case_Swapping_Not_Done != null) {
    String[] arr = Label.Case_Swapping_Not_Done.split(';');
    for (String str: arr) {
     swapNotDonelbl.add(str.ToUpperCase());
    }
   }
   if (Label.Swapping_Mandate_Type_Label != null) {
    String[] arr = Label.Swapping_Mandate_Type_Label.split(';');
    for (String str: arr) {
     swapTypelbl.add(str.ToUpperCase());
    }
   }
   if (Label.Swapping_Mandate_Sub_Type_Label != null) {
    String[] arr = Label.Swapping_Mandate_Sub_Type_Label.split(';');
    for (String str: arr) {
     swapSubTypelbl.add(str.ToUpperCase());
    }
   }
   for (Case caseObj: Trigger.New) {
    //sending msg to registred customer mobile no. for Swapping Done cases
    if (caseobj.Type__c != null && caseobj.Sub_Type__c != null && swapTypelbl != null && swapTypelbl.size() > 0 && swapSubTypelbl != null && swapSubTypelbl.size() > 0 && swapTypelbl.contains(caseobj.Type__c.toUpperCase()) && swapSubTypelbl.contains(caseobj.Sub_Type__c.toUpperCase())) {
     if (!caseObj.Swap_Msg_Sent__c && caseobj != null && caseobj.Customer_Mobile__c != null && swapDonelbl != null && swapDonelbl.size() > 0 && caseObj.Sub_Closer__c != null && caseObj.Effective_Date__c != null && caseObj.Mandate_SMS_Sent__c != null && caseObj.Mandate_SMS_Sent__c == true && swapDonelbl.contains(caseObj.Sub_Closer__c.toUpperCase())) {
      mobileNumbers.add(String.valueOf(caseobj.Customer_Mobile__c));
      if (Label.Swapping_Done_Msg_String != null) {
       String msgLbl = Label.Swapping_Done_Msg_String;
       String effDate = string.valueOf(caseObj.Effective_Date__c);
       msgLbl = msgLbl.replaceAll('EFFECTIVEDATE', effDate);
       messages.add(msgLbl);
       caseObj.Swap_Msg_Sent__c = true;
      }
     } else if (!caseObj.Swap_Msg_Sent__c && caseobj != null && caseobj.Customer_Mobile__c != null && swapNotDonelbl != null && swapNotDonelbl.size() > 0 && caseObj.Sub_Closer__c != null && caseObj.Mandate_SMS_Sent__c != null && caseObj.Mandate_SMS_Sent__c == true && swapNotDonelbl.contains(caseObj.Sub_Closer__c.toUpperCase())) {
      mobileNumbers.add(String.valueOf(caseobj.Customer_Mobile__c));
      if (Label.Swapping_Not_Done_Msg_String != null) {
       messages.add(Label.Swapping_Not_Done_Msg_String);
       caseObj.Swap_Msg_Sent__c = true;
      }
     }
    }
    if (messages.size() > 0 && mobileNumbers.size() > 0) {
     sendsms.sendBulkSMS(messages, mobileNumbers);
    }
   }
  }
  //Bug # 12160 E
 }
 // end of enhancement
 // 
  
}