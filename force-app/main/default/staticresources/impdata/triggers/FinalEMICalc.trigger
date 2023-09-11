trigger FinalEMICalc on Existing_Loan_Details__c(before insert, after insert, before update, after update, after delete) {
 // Created for EMI calculation of SOLCAM
 List < Sol_Cam__c > Solcam = new List < Sol_Cam__c > ();
 List < OnLineSal_Products__c > mycs1 = new List < OnLineSal_Products__c > ();
 Boolean isOLPrd = false;
 if (!Trigger.Isdelete) { // Bug 19239 - Categorisation of unsecured loan obligation -- Start // added only if condition  to avoid null pointer in case of before delete
  if (Trigger.New[0].Applicant__c != null) {
   Solcam = [select id, Existing_Loan_Details_Created__c, Product__c from Sol_cam__c where Applicant__c =: Trigger.New[0].Applicant__c];

   //Bug Id : 17501 SHL change
   boolean isSHOLProductLineProduct = false;
   transient string SHOLProductLineProducts = Label.SHOL_ProductLine_Products;
   if (SHOLProductLineProducts != null && SHOLProductLineProducts != '') {
    set < string > setSHOLProdName = new set < string > ();
    setSHOLProdName.addAll(SHOLProductLineProducts.split(';'));
    if (setSHOLProdName != null && setSHOLProdName.size() > 0 && Solcam != null && Solcam.size() > 0 && Solcam[0].Product__c != null) {
     if (setSHOLProdName.contains(Solcam[0].Product__c))
      isSHOLProductLineProduct = true;
    }
   }
   if (!CommonUtility.isEmpty(Solcam) && (('SOL').equalsIgnoreCase(Solcam[0].Product__c) || isSHOLProductLineProduct))
    isOLPrd = true;
  }
 } // Bug 19239 - Categorisation of unsecured loan obligation -- End  
 Decimal roi, Tennor, nEMI;

 //harsit----Optimization START
 //Moved the following commented code in isBefore block, because prodMap is used only in 'before' case
 /*Map < String, OnLineSal_Products__c > prodMap = new Map < String, OnLineSal_Products__c > ();
 myCS1 = [select id, Average_Tenor__c, ROI__c, Product__c from OnLineSal_Products__c];
 for (OnLineSal_Products__c obj: myCS1) {
  prodMap.put(obj.Product__c, obj);
 }*/
 //harsit----Optimization END
 if (Trigger.Isbefore) {
  //harsit----Optimization START
  Map < String, OnLineSal_Products__c > prodMap = new Map < String, OnLineSal_Products__c > ();
  myCS1 = [select id, Average_Tenor__c, ROI__c, Product__c from OnLineSal_Products__c];
  for (OnLineSal_Products__c obj: myCS1) {
   prodMap.put(obj.Product__c, obj);
  }
  //harsit----Optimization END
  for (Existing_Loan_Details__c eld: Trigger.new) {

   if (Trigger.isInsert && isOLPrd && !CommonUtility.isEmpty(eld.Emi__c) && CommonUtility.isEmpty(eld.Final_Emi__c))
    eld.Final_Emi__c = eld.Emi__c;


   if (eld.Status__c == 'Live') {
    String LT = eld.Loan_Type__c;
    system.debug('$$$$$$$$$$$$$' + LT);
    Pattern j = Pattern.compile('[^a-zA-Z]');
    system.debug('$$$$$$$$$$$$$' + LT);
    if (Pattern.matches('[a-zA-Z]+', LT)) {
     //myCS1 = [select id,Average_Tenor__c,ROI__c from OnLineSal_Products__c where Product__c =:LT];

     //if( myCS1.size()>0){
     // Tennor= myCS1[0].Average_Tenor__c;
     //roi= myCS1[0].ROI__c;
     //}
     system.debug('prodMap==========>' + prodMap);
     if (prodMap.get(LT) != null) {
      Tennor = prodMap.get(LT).Average_Tenor__c;
      roi = prodMap.get(LT).ROI__c;
     }
    } else {
     LT = j.matcher(lt).replaceall('');
     //myCS1 = [select id,Average_Tenor__c,ROI__c from OnLineSal_Products__c where Product__c =:LT];

     //if( myCS1.size()>0){
     // Tennor= myCS1[0].Average_Tenor__c;
     //roi= myCS1[0].ROI__c;
     //}
     if (prodMap.get(LT) != null) {
      Tennor = prodMap.get(LT).Average_Tenor__c;
      roi = prodMap.get(LT).ROI__c;
     }
    }
    system.debug('inside else===>nEMI' + nEMI + '========>ROI' + roi + '=========>tennor' + Tennor);
    if (roi != null && Tennor != null) {
     if (roi == 0 && Tennor != 0) {
      nEMI = (eld.Loan_Amount__c) / Integer.valueof(Tennor);
      eld.Derived_EMI__c = nEMI;
      system.debug('inside if===>eld.Derived_EMI__c' + eld.Derived_EMI__c);
     } else {
      if (eld.Loan_Amount__c != null && roi != null && Tennor != null)
       nEMI = (eld.Loan_Amount__c * roi / 1200) / (1 - Math.pow((1 + double.valueof(roi / 1200)), -Integer.valueof(Tennor)));
      eld.Derived_EMI__c = nEMI;
      system.debug('inside else===>nEMI' + nEMI + '========>ROI' + roi + '=========>tennor' + Tennor);
      system.debug('inside else===>eld.Derived_EMI__c' + eld.Derived_EMI__c);
     }
    }
    //For Gold loan policy
    if (eld.Loan_Type__c == 'Gold Loan') {
     system.debug('***eld.POS__c*' + eld.POS__c);
     if (eld.POS__c != null)
      eld.Derived_EMI__c = (eld.POS__c / 12).setScale(2);
     system.debug('**eld.Derived_EMI__c*' + eld.Derived_EMI__c);
    }
    if (eld.Emi__c == null || eld.Emi__c ==0) {
     system.debug('first condition'+ eld.Derived_EMI__c);
     eld.Emi__c = eld.Derived_EMI__c;//changed for mobility v2
    }
    if (eld.Final_Emi__c == null && eld.Emi__c == null) {
     system.debug('first condition');
     eld.Final_Emi__c = eld.Derived_EMI__c;
    }
    // Code added by Pramod Nishane Dated- 26 May 2016 removed eld.Final_Emi__c==null condition original condition else if((eld.Final_Emi__c==null) && (eld.Emi__c!=null || eld.Emi__c!=0)) now .
    else if (!isOLPrd && (eld.Emi__c != null || eld.Emi__c != 0)) {
     system.debug('second condition');
     eld.Final_Emi__c = eld.Emi__c;
    }



   }
  }
 }
 if (Trigger.IsAfter && SolCam.size() > 0 && Solcam[0].Existing_Loan_Details_Created__c == False) {
  if (SolCam.size() > 0) {
   Solcam[0].Existing_Loan_Details_Created__c = True;
   update Solcam[0];
  }
 }

 /*Code added by Rakesh Shinde. Date : 14 Jan 2016
    BRD: PRO DSS Changes at PO. Added logic to sum up Monthly Obligation of Existing Loan Details record to PO
    */
 if (Trigger.IsAfter) {
  Map < String, Decimal > mapExLoanDetailIDAndObligation = new Map < String, Decimal > ();
  List < Product_Offerings__c > lstProdOffering = new List < Product_Offerings__c > ();
  List < Existing_Loan_Details__c > lstExtLoanDetails = new List < Existing_Loan_Details__c > ();
  List < String > lstProdOfferingId = new List < String > ();
  // Bug 19239 - Categorisation of unsecured loan obligation
  List < Id > setLoanId = new List < Id > ();
 List < String > lstOfLonidToSkip = Label.Dummy_Opportunity.toUpperCase().Split(';'); // Bug 21760  added to skip dummy loan for production limit hit
  //Start Bug 19239 - Categorisation of unsecured loan obligation
  if (Trigger.IsUpdate || Trigger.IsInsert) {
   for (Existing_Loan_Details__c eld: Trigger.new) {
    if (eld.Product_Offering__c != null)
     lstProdOfferingId.add(eld.Product_Offering__c);

    system.debug('current session Existing_Loan_Details__c  ::' + eld);
    system.debug('current sessions Loan details  ::' + eld.Loan_Application__c);
    if (Trigger.IsUpdate) {
     if (trigger.oldmap.get(eld.id).id == eld.id) {
      if ((trigger.oldmap.get(eld.id).Status__c != eld.Status__c) ||
       (trigger.oldmap.get(eld.id).Secured_Unsecured__c != eld.Secured_Unsecured__c) ||
       (trigger.oldmap.get(eld.id).financers__c != eld.financers__c) ||
       (trigger.oldmap.get(eld.id).POS__c != eld.POS__c) ||
       (trigger.oldmap.get(eld.id).Loan_Type__c != eld.Loan_Type__c)
      )
       if( lstOfLonidToSkip != null && !lstOfLonidToSkip.contains(string.valueOf(eld.Loan_Application__c).toUpperCase())) //Bug 21760  added to skip dummy loan for production limit hit
       setLoanId.add(eld.Loan_Application__c); // Bug 19239 - Categorisation of unsecured loan obligation                     
     }
    } else if (Trigger.IsInsert){// For Trigger isInsert
        System.Debug(' Loan appln id ffor use is--- ' + eld.Loan_Application__c );
      if( lstOfLonidToSkip != null && !lstOfLonidToSkip.contains(string.valueOf(eld.Loan_Application__c).toUpperCase())) // Bug 21760 added to skip dummy loan for limit hit
     setLoanId.add(eld.Loan_Application__c); // Bug 19239 - Categorisation of unsecured loan obligation  
         else 
          System.Debug('Dummy Loan appln id from custom label is--- ' + eld.Loan_Application__c );
     }     
   }
  } else
  if (Trigger.IsDelete) {
   for (Existing_Loan_Details__c eld: Trigger.old){
    System.Debug(' Loan appln id ffor use is--- ' + eld.Loan_Application__c );
    if( lstOfLonidToSkip != null && !lstOfLonidToSkip.contains(string.valueOf(eld.Loan_Application__c).toUpperCase())) // Bug 21760 added to skip dummy loan for production limit hit
    setLoanId.add(eld.Loan_Application__c); // Bug 19239 - Categorisation of unsecured loan obligation
    else
     System.Debug('Dummy Loan appln id from custom label is--- ' + eld.Loan_Application__c );
   }
 }
  //END Bug 19239 - Categorisation of unsecured loan obligation


  if (lstProdOfferingId != null && lstProdOfferingId.size() > 0) {
   lstExtLoanDetails = [select Mthly_Oblig__c, Product_Offering__c from Existing_Loan_Details__c where Product_Offering__c in: lstProdOfferingId AND Obligation__c = 'Yes'
    AND Status__c = 'Live'
   ];
  }

  for (Existing_Loan_Details__c eld: lstExtLoanDetails) {
   Decimal sumMonthlyObligation = 0;
   if (eld.Mthly_Oblig__c > 0 && eld.Product_Offering__c != null) {
    if (mapExLoanDetailIDAndObligation.containskey(eld.Product_Offering__c))
     sumMonthlyObligation = mapExLoanDetailIDAndObligation.get(eld.Product_Offering__c);

    sumMonthlyObligation = sumMonthlyObligation + eld.Mthly_Oblig__c;
    mapExLoanDetailIDAndObligation.put(eld.Product_Offering__c, sumMonthlyObligation);
   }
   system.debug('mapExLoanDetailIDAndObligation::' + mapExLoanDetailIDAndObligation);
   /*system.debug('tenor::'+eld.Tenor__c) ;
   system.debug('EMI::'+eld.EMI__c) ;
   system.debug('tenorLeft::'+eld.Tenor_Left__c) ;
   system.debug('Obligation::'+eld.Mthly_Oblig__c) ;*/
   system.debug('Record::' + eld);
  }
  for (String strPOId: mapExLoanDetailIDAndObligation.keyset()) {
   Product_Offerings__c objProdOffering = new Product_Offerings__c(Id = strPOId, Monthly_Obligation__c = mapExLoanDetailIDAndObligation.get(strPOId));
   lstProdOffering.add(objProdOffering);
  }
  if (lstProdOffering != null && lstProdOffering.size() > 0)
   update lstProdOffering;

  // Bug 19239 - Categorisation of unsecured loan obligation -- start 
  List < String > lstOfProduct = new List < String > ();
  lstOfProduct = Label.Secured_Unsecured_Product_Categorization.split(',');
  system.debug('required product list is -- ' + lstOfProduct);
  system.debug('required loan id  -- ' + setLoanId);
  
  List < Opportunity > reqOpportunity = [Select id, Name, Product__c, (select id, Name, Total_Unsecured_POS_from_Bajaj__c, Total_Unsecured_POS_outside_Bajaj__c from SurrogateCAMS__r where Applicant__c = null Order by LastModifiedDate desc Limit 5200),
   (select id, Name, POS__c, financers__c, Status__c, Secured_Unsecured__c, Loan_Type__c from Existing_Loan_Details__r where Status__c = 'Live'
    AND Secured_Unsecured__c = 'Unsecured'
    AND Loan_Type__c != 'Credit Card' Limit 5200
   ), Loan_Application_Number__c from Opportunity
   where id IN: setLoanId AND Product__c IN: lstOfProduct Limit 5200
  ];
  
  List < SurrogateCAM__c > lstOfConsolScam = new List < SurrogateCAM__c > ();
  if (reqOpportunity != null && reqOpportunity.size() > 0) {
   for (Opportunity op: reqOpportunity) {
    integer bajajInsidePos = 0;
    integer bajajOutsidePos = 0;
    if (op.Existing_Loan_Details__r != null && op.Existing_Loan_Details__r.size() > 0) {
     for (Existing_Loan_Details__c extnloandetil: op.Existing_Loan_Details__r) {
      if (extnloandetil.financers__c != null && extnloandetil.financers__c.ContainsIgnoreCase('Bajaj') && extnloandetil.POS__c != null)
       bajajInsidePos += Integer.ValueOf(extnloandetil.POS__c);
      else if ( /*extnloandetil.financers__c != null && */ extnloandetil.POS__c != null) // as per rohan comment, blank financier is outside of bajaj
       bajajOutsidePos += Integer.ValueOf(extnloandetil.POS__c);
     }
    }
    if (op.SurrogateCAMS__r != null && op.SurrogateCAMS__r.size() > 0 && op.SurrogateCAMS__r[0] != null) {

     op.SurrogateCAMS__r[0].Total_Unsecured_POS_from_Bajaj__c = bajajInsidePos;
     op.SurrogateCAMS__r[0].Total_Unsecured_POS_outside_Bajaj__c = bajajOutsidePos;
     lstOfConsolScam.add(op.SurrogateCAMS__r[0]);

    }
   }
  }
  if (lstOfConsolScam != null && lstOfConsolScam.size() > 0)
   update lstOfConsolScam;
  // Bug 19239 - Categorisation of unsecured loan obligation -- End           
 }
}