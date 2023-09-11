/**
 *@author Persistent Systems Ltd.
 *@date 3rd August 2016
 *@description : Common Util class for communication framework. This class contains methods for sending SMS and Email to customer
 *               and internal team.
 */
global class GeneralCommunicationHandler {
 private static List < StaticResource > srcQueried = new List < StaticResource > (); //retrigger BRE added by Priya 20939

 private static Boolean checkResp = true;
 private static String jsonString;
 private static Boolean SPLReferredFlag;
 /*Responsys Dynamic Parameters Bug 15653 s*/
 //List<Rack_Rate__c> rrMaster = new List<Rack_Rate__c>();
 static List < Rack_Rate__c > rrMaster = [SELECT name, Products__c, SMS_Text__c, Additional_SMS_Text__c, Campaign_Name__c, ReceipientsAPINames__c, resendFlag__c, SMS_Type__c, Dynamic_Parameters__c, isPriority__c, Event__c, Used_For__c from Rack_Rate__c where Used_For__c = 'Responsys'
  OR Used_For__c = 'Value First'  OR Used_For__c = 'Axiom'
 ];
 private static Boolean respObjFlag = false;
 private static Boolean oldFlowFlag = false;
 private static List < SMS_Sent__c > smsDynamic = new List < SMS_Sent__c > ();
 private static Set < String > setProdRes = new Set < String > ();
 private static String jsonStringRes;
 private static Map < String, Object > jsonBodyRes;
 private static Set < id > relIdSet = new Set < id > ();
 private static String relWhere;
 /*Responsys Dynamic Parameters Bug 15653 e*/
 private static Map < String, String > receipientsMap;
 private static Map < String, Object > jsonBody;

 // Start of changes by Niraj
 private static String relatedObjName;
 private static List < sObject > sObjRelatedList;
 private static String childRelationshipName;
 private static String parentRelationshipName;
 //private static Map<String,String> smsTobeSendMap = new Map<String,String>();
 // End of changes by Niraj

 @InvocableMethod
 public static void sendSMSorEmailFromPB(List < CommunicationWrapper > parameters) {
  //Code modified by harsit garg to make it generic invocable method---  start

  /*List<Product_Offerings__c> POList;
  if(idList != null && idList.size() > 0) {
      POList = [SELECT id,Products__c,Field_Remarks__c FROM Product_Offerings__c WHERE ID IN : idList];
  }
  GeneralCommunicationHandler.sendSMS(POList,'Follow up-Int');*/
  //Bug 23563 - February 2019 - Automated NI NC Communication start
  List < sobject > lstAutoNIPRO = new List < sobject > ();
  List < sobject > lstAutoNCPRO = new List < sobject > ();
  List < sobject > lstAutoNCDOctors = new List < sobject > ();
  List < sobject > lstAutoNIDOctors = new List < sobject > ();
  List < sobject > lstAutoNCPSBL = new List < sobject > ();
  List < sobject > lstAutoNIPSBL = new List < sobject > ();
  List < id > lstIDAutoNIPRO = new List < id > ();
  List < id > lstIDAutoNCPRO = new List < id > ();
  List < id > lstIDAutoNCDOctors = new List < id > ();
  List < id > lstIDAutoNIDOctors = new List < id > ();
  List < id > lstIDAutoNCPSBL = new List < id > ();
  List < id > lstIDAutoNIPSBL = new List < id > ();
  //Bug 23563 - February 2019 - Automated NI NC Communication end
  //  Bug 20190 BOL SMS Communication to Customer start
  List < sobject > list1 = new List < sobject > ();
  List < sobject > list2 = new List < sobject > ();
  List < sobject > list3 = new List < sobject > ();
  List < sobject > list4 = new List < sobject > ();
  List < sobject > list5 = new List < sobject > ();
  List < sobject > list6 = new List < sobject > ();
  List < sobject > list7 = new List < sobject > ();
  List < sobject > list8 = new List < sobject > ();
  List < id > list1id = new List < id > ();
  List < id > list2id = new List < id > ();
  List < id > list3id = new List < id > ();
  List < id > list4id = new List < id > ();
  List < id > list5id = new List < id > ();
  List < id > list6id = new List < id > ();
  List < id > list7id = new List < id > ();
  List < id > list8id = new List < id > ();

  for (CommunicationWrapper c: parameters) {
   system.debug('value of event ' + c.custSetting);
   if (c.emailOrSmS == 'R') {

    if (c.custSetting == 'MCP FAIL BOL')
     list1id.add(c.objId);

    if (c.custSetting == 'OFFER AVAILABLE BOL') {
     list2id.add(c.objId);
     system.debug('inside my method' + 'OFFER AVAILABLE BOL' + c.objId + list2id);
    }

    if (c.custSetting == 'TELE DISPOSITION NONCONTACTABLE BOL')
     list3id.add(c.objId);

    if (c.custSetting == 'FIELD DISPOSITION NONCONTACTABLE BOL')
     list4id.add(c.objId);

    if (c.custSetting == 'MCP FAIL PRO')
     list5id.add(c.objId);

    if (c.custSetting == 'OFFER AVAILABLE PRO') {
     list6id.add(c.objId);
     system.debug('inside OFFER AVAILABLE PRO');
    }

    if (c.custSetting == 'TELE DISPOSITION NONCONTACTABLE PRO')
     list7id.add(c.objId);

    if (c.custSetting == 'FIELD DISPOSITION NONCONTACTABLE PRO')
     list8id.add(c.objId);

    if (list1id != null && list1id.size() > 0) {
     list1 = [SELECT id, Products__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: list1id];

     sendSMSPO(list1, 'MCP FAIL BOL', false);
    }
    if (list2id != null && list2id.size() > 0) {
     list2 = [SELECT id, Products__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: list2id];
     system.debug('calling method' + list2);
     sendSMSPO(list2, 'OFFER AVAILABLE BOL', false);

    }
    if (list3id != null && list3id.size() > 0) {
     list3 = [SELECT id, Products__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: list3id];
     sendSMSPO(list3, 'TELE DISPOSITION NONCONTACTABLE BOL', false);
    }
    if (list4id != null && list4id.size() > 0) {
     list4 = [SELECT id, Products__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: list4id];
     sendSMSPO(list4, 'FIELD DISPOSITION NONCONTACTABLE BOL', false);
    }

    if (list5id != null && list5id.size() > 0) {
     list5 = [SELECT id, Products__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: list5id];
     sendSMSPO(list5, 'MCP FAIL PRO', false);
    }

    if (list6id != null && list6id.size() > 0) {
     list6 = [SELECT id, Products__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: list6id];
     system.debug(list6 + ' value ' + list6);
     sendSMSPO(list6, 'OFFER AVAILABLE PRO', false);
    }

    if (list7id != null && list7id.size() > 0) {
     list7 = [SELECT id, Products__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: list7id];
     sendSMSPO(list7, 'TELE DISPOSITION NONCONTACTABLE PRO', false);
    }

    if (list8id != null && list8id.size() > 0) {
     list8 = [SELECT id, Products__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: list8id];
     sendSMSPO(list8, 'FIELD DISPOSITION NONCONTACTABLE PRO', false);
    }
   }
  }
  //  Bug 20190 BOL SMS Communication to Customer end    
  //Bug 23563 - February 2019 - Automated NI NC Communication start

  for (CommunicationWrapper c: parameters) {
   system.debug('emailOrSmS ===>' + c.emailOrSmS + 'offerProduct====>' + c.offerProduct + 'telecalldisposStatus====>' + c.telecalldisposStatus + 'filedDisposStatus1' + c.filedDisposStatus1);
   if (c.emailOrSmS == 'NINC') {
    if (c.offerProduct == 'PRO') {
     if ((c.telecalldisposStatus!=null && c.ISChangedtelecall && c.telecalldisposStatus == 'Not Interested') || (c.filedDisposStatus1!=null && c.ISChangedfiled1 && c.filedDisposStatus1 == 'Not Interested')) {
      lstIDAutoNIPRO.add(c.objId);
     }
     if ((c.telecalldisposStatus!=null && c.ISChangedtelecall && c.telecalldisposStatus == 'Non Contactable') || (c.filedDisposStatus1!=null && c.ISChangedfiled1 && c.filedDisposStatus1 == 'Not Contactable')) {
      lstIDAutoNCPRO.add(c.objId);
     }
    }
    if (c.offerProduct == 'DOCTORS') {
     if (c.telecalldisposStatus!=null && c.telecalldisposStatus == 'Not Interested') {
      lstIDAutoNIDOctors.add(c.objId);
     }
     if (c.telecalldisposStatus!=null && c.telecalldisposStatus == 'Non Contactable') {
      lstIDAutoNCDOctors.add(c.objId);
     }
    }
    if (c.offerProduct == 'PSBL') {
     if (c.telecalldisposStatus!=null && c.telecalldisposStatus == 'Not Interested') {
      lstIDAutoNIPSBL.add(c.objId);
     }
     if (c.telecalldisposStatus!=null && c.telecalldisposStatus == 'Non Contactable') {
      lstIDAutoNCPSBL.add(c.objId);
     }
    }
   }

  }
  if (lstIDAutoNIPRO != null && lstIDAutoNIPRO.size() > 0) {
   lstAutoNIPRO = [SELECT id, Products__c, Customer_ID1__r.Customer_ID__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: lstIDAutoNIPRO];
   system.debug('custom setting selected is===>CUST NOT INTERESTED PRO');
   sendSMSPO(lstAutoNIPRO, 'CUST NOT INTERESTED PRO', false);
  }
  if (lstIDAutoNCPRO != null && lstIDAutoNCPRO.size() > 0) {
   lstAutoNCPRO = [SELECT id, Products__c, Customer_ID1__r.Customer_ID__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: lstIDAutoNCPRO];
   system.debug('custom setting selected is===>CUST NOT CONTACTABLE PRO');
   sendSMSPO(lstAutoNCPRO, 'CUST NOT CONTACTABLE PRO', false);

  }
  if (lstIDAutoNIDOctors != null && lstIDAutoNIDOctors.size() > 0) {
   lstAutoNIDOctors = [SELECT id, Products__c, Customer_ID1__r.Customer_ID__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: lstIDAutoNIDOctors];
   system.debug('custom setting selected is===>CUST NOT INTERESTED DOCTORS');
   sendSMSPO(lstAutoNIDOctors, 'CUST NOT INTERESTED DOCTORS', false);
  }
  if (lstIDAutoNCDOctors != null && lstIDAutoNCDOctors.size() > 0) {
   lstAutoNCDOctors = [SELECT id, Products__c, Customer_ID1__r.Customer_ID__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: lstIDAutoNCDOctors];
   system.debug('custom setting selected is===>CUST NOT CONTACTABLE DOCTORS');
   sendSMSPO(lstAutoNCDOctors, 'CUST NOT CONTACTABLE DOCTORS', false);
  }

  if (lstIDAutoNIPSBL != null && lstIDAutoNIPSBL.size() > 0) {
   lstAutoNIPSBL = [SELECT id, Products__c, Customer_ID1__r.Customer_ID__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: lstIDAutoNIPSBL];
   system.debug('custom setting selected is===>CUST NOT INTERESTED PSBL');
   sendSMSPO(lstAutoNIPSBL, 'CUST NOT INTERESTED PSBL', false);
  }

  if (lstIDAutoNCPSBL != null && lstIDAutoNCPSBL.size() > 0) {
   lstAutoNCPSBL = [SELECT id, Products__c, Customer_ID1__r.Customer_ID__c, Lead_Customer_Mobile__c, Field_Remarks__c FROM Product_Offerings__c WHERE id IN: lstIDAutoNCPSBL];
   system.debug('custom setting selected is===>CUST NOT CONTACTABLE PSBL');
   sendSMSPO(lstAutoNCPSBL, 'CUST NOT CONTACTABLE PSBL', false);
  }
  //Bug 23563 - February 2019 - Automated NI NC Communication end 
  try {
   system.debug('in invocable method' + parameters[0]);
   if (!CommonUtility.IsEmpty(parameters) && !CommonUtility.IsEmpty(parameters[0])) {

    List < sObject > sObjList;

    String objectName = getObjectNameebyRecordID(parameters[0].objId);
    if (!CommonUtility.isEmpty(objectName)) {
     if (objectName.equalsIgnoreCase('Product_Offerings__c')) {
      List < Product_Offerings__c > POList = [SELECT id, Products__c, Field_Remarks__c FROM Product_Offerings__c WHERE ID =: parameters[0].objId];
      if (!CommonUtility.isEmpty(POList)) {
       /*if(parameters[0].emailOrSmS.equalsIgnoreCase('sms'))
           GeneralCommunicationHandler.sendSMS(POList,parameters[0].custSetting);*/
       sObjList = POList;
      }
     } else if (objectName.equalsIgnoreCase('Opportunity')) {
      List < Opportunity > oppList = [SELECT Id, (SELECT id FROM salaried__r) FROM Opportunity WHERE ID =: parameters[0].objId];
      if (!CommonUtility.isEmpty(oppList)) {
       if (!CommonUtility.isEmpty(parameters[0].onlineFlow) && parameters[0].onlineFlow.equalsIgnoreCase('yes')) {
        List < Salaried__c > salList = oppList[0].salaried__r;
        System.debug('salList:' + salList);
        if (!CommonUtility.isEmpty(salList)) {
         /*if(parameters[0].emailOrSmS.equalsIgnoreCase('email'))
             GeneralCommunicationHandler.sendEmail(salList,parameters[0].custSetting);
         else if(parameters[0].emailOrSmS.equalsIgnoreCase('sms'))
             GeneralCommunicationHandler.sendSms(salList,parameters[0].custSetting);
         else if(parameters[0].emailOrSmS.equalsIgnoreCase('both')){
             GeneralCommunicationHandler.sendSms(salList,parameters[0].custSetting);
             GeneralCommunicationHandler.sendEmail(oppList,parameters[0].custSetting);
         }*/
         sObjList = salList;
        }
       } else {
        /*if(parameters[0].emailOrSmS.equalsIgnoreCase('email'))
            GeneralCommunicationHandler.sendEmail(oppList,parameters[0].custSetting);
        else if(parameters[0].emailOrSmS.equalsIgnoreCase('sms'))
            GeneralCommunicationHandler.sendSms(oppList,parameters[0].custSetting);
        else if(parameters[0].emailOrSmS.equalsIgnoreCase('both')){
            GeneralCommunicationHandler.sendSms(oppList,parameters[0].custSetting);
            GeneralCommunicationHandler.sendEmail(oppList,parameters[0].custSetting);
        }*/
        sObjList = oppList;
       }
      }
     } /* BFL Homes added by priya start */
     else if (objectName.equalsIgnoreCase('Property_Details__c')) {
      List < Property_Details__c > PDList = [SELECT id FROM Property_Details__c WHERE ID =: parameters[0].objId];
      if (!CommonUtility.isEmpty(PDList)) {
       sObjList = PDList;
      }
     }
     /* BFL Homes added by priya end*/
    }
    if (!CommonUtility.isEmpty(sObjList) && !CommonUtility.isEmpty(parameters[0].emailOrSmS)) {
     if (parameters[0].emailOrSmS.equalsIgnoreCase('email'))
      sendEmail(sObjList, parameters[0].custSetting);
     else if (parameters[0].emailOrSmS.equalsIgnoreCase('sms'))
      sendSms(sObjList, parameters[0].custSetting);
     else if (parameters[0].emailOrSmS.equalsIgnoreCase('both')) {
      System.debug('in both');
      sendSms(sObjList, parameters[0].custSetting);
      sendEmail(sObjList, parameters[0].custSetting);
     }
    }
   }
  } catch (Exception e) {
   System.debug('exception ' + e);
   System.debug('Exception occured at line --> ' + e.getLineNumber() + ' Root cause --> ' + e.getCause() + '>> trace >>' + e.getStackTraceString());
  }
  //Code modified by harsit garg ---  end
 }
 public static void sendSMS(List < sObject > sObjList, String custSet, Boolean oldFlow) {
  oldFlowFlag = oldFlow;
  sendSMS(sObjList, custSet);
  oldFlowFlag = false;
 }
 // Start of changes by Niraj
 public static void sendSMS(List < sObject > sObjList, List < sObject > sObjRelList, String custSet) {
  try {
   system.debug('inside rel send sms' + custSet);
   relIdSet = new Set < Id > ();
   if (sObjList != null && sObjList.size() > 0 && sObjRelList != null && sObjRelList.size() > 0) {
    relatedObjName = sObjRelList[0].getSObjectType().getDescribe().getName();
    sObjRelatedList = sObjRelList;
    for (sObject sObj: sObjRelatedList) {
     relIdSet.add(sObj.id);
    }
    system.debug('relIdSet' + relIdSet);
    relWhere = 'Where Id IN: relIdSet';
    sendSMS(sObjList, custSet);
   }
  } catch (Exception ex) {
   System.debug('exception:' + ex.getMessage());
  }
  relWhere = null;
  relatedObjName = null;
  childRelationshipName = null;
  parentRelationshipName = null;

 }
 // End of changes by Niraj

 /**
  *@author Persistent Systems Ltd.
  *@date 3rd August 2016
  *@description : Common Util method for sending SMS to customer and internal team. This method is bulkified which can be called from triggers.
  *               This method checks for valid custom setting record which is active and matching with the product. 
  *               It also inserts a record in SMS_Sent__c object to keep track of all the SMS's sent to avoid duplicate SMS.
  *@param sObjList : A list of sObject which can be PO or Opportunity.
  *@param custSet : General name for custom setting record which is appended with Product in the method. 
  *                 E.g. If custom setting record is SHL Sales Login-Cust then need to pass "Sales Login-Cust" in custSet.  
  */

 public static void sendSMS(List < sObject > sObjList, String custSet) {
  try {
   List < Sms_sent__c > respSMS = new List < SMS_sent__c > ();
   List < String > msgs = new List < String > ();
   List < String > contactNos = new List < String > ();
   Rack_Rate__c masterRec = new Rack_Rate__c();
   system.debug('Inside send SMS and custom setting record is : ' + custSet);
   /*Responsys Dynamic Parameters Bug 15653 s*/
   String custSetName;
   String productList = '';
   if (AtosParameters__c.getValues('ResponsysAPI') != null && AtosParameters__c.getValues('ResponsysAPI').Product__c != null)
    productList = AtosParameters__c.getValues('ResponsysAPI').Product__c;

   System.debug('\n\nproductList : ' + productList);
   setProdRes.addAll(productList.split(';'));
   /*Responsys Dynamic Parameters Bug 15653 e*/
   if (sObjList != null && sObjList.size() > 0) {
    String objName = sObjList[0].getSObjectType().getDescribe().getName();
    List < SMS_Sent__c > allsms = new List < SMS_Sent__c > ();
    List < SMS_Sent__c > relatedSMSLst;
    Map < String, Object > inputMap;
    String Product;

    Set < ID > VAMSet = new Set < ID > ();
    for (sObject sObj: sObjList) {
     VAMSet.add(sObj.id);
    }
    System.debug('objName --> ' + objName + ' --- VAMSet --->> ' + VAMSet);
    string query = GenerateDynamicSOQL('CommunicationMapping,ResponsysAPIIntegration', objName, ' WHERE ID IN : VAMSet');
    System.debug('query --> ' + query);
    try {
     if (VAMSet.size() > 0) {
      sObjList = Database.query(query);
     }
    } catch (DMLException e) {
     System.debug('Exception occured at line --> ' + e.getLineNumber() + ' Root cause --> ' + e.getCause());
    }

    String productAPI;

    Map < String, Object > jsonField = new Map < String, Object > ();
    //Responsys Dynamic Parameters Bug 15653 changed jsonBody to jsonBodyRes
    if (!CommonUtility.isEmpty(jsonBodyRes) && jsonBodyRes.containsKey(objName) && !CommonUtility.isEmpty(jsonBodyRes.get(objName)))
     jsonField = (Map < String, Object > ) jsonBodyRes.get(objName);

    if (!CommonUtility.isEmpty(jsonField) && jsonField.containsKey('**Product**') && !CommonUtility.isEmpty(jsonField.get('**Product**')))
     productAPI = String.valueOf(jsonField.get('**Product**'));
     system.debug('productAPI===>'+productAPI);
    /*Responsys Dynamic Parameters Bug 15653 s*/
    if (checkResp) {
     if (!CommonUtility.isEmpty(jsonField) && jsonField.containsKey('**ResponsysObj**') && !CommonUtility.isEmpty(jsonField.get('**ResponsysObj**')))
      respObjFlag = Boolean.valueOf(jsonField.get('**ResponsysObj**'));
    } else {
     respObjFlag = true;
    }
    //system.debug('No of soql'+limits.getQueries());
    //system.debug('No of soql'+limits.getQueries());
    system.debug('rrMaster.size()' + rrMaster.size() + jsonField.get('**ResponsysObj**'));
    /*Responsys Dynamic Parameters Bug 15653 e*/
    for (sObject sObj: sObjList) {

     // Start of logic to avoid sending repeated SMS
     /*Boolean SMSSentFlag = false;
     if(objName.equalsIgnoreCase('Opportunity')) {
         Opportunity oppTemp;
         oppTemp = (Opportunity) sObj;
         Product = oppTemp.Product__c;
         relatedSMSLst = oppTemp.SMSes_Sent__r;
         /*for(SMS_Sent__c SMSSent : oppTemp.SMSes_Sent__r) {
             if(SMSSent.Name.equalsIgnoreCase(Product + ' ' + custSet)) {
                 SMSSentFlag = true;
                 break;
             }
         }
     } else if(objName.equalsIgnoreCase('Product_Offerings__c')) {
         Product_Offerings__c POTemp;
         POTemp = (Product_Offerings__c) sObj;
         Product = POTemp.Products__c;
         relatedSMSLst = POTemp.SMSes_Sent__r;
         /*for(SMS_Sent__c SMSSent : POTemp.SMSes_Sent__r) {
             if(SMSSent.Name.equalsIgnoreCase(Product + ' ' + custSet)) {
                  SMSSentFlag = true;
                  break;
              }
          }
     } else if(objName.equalsIgnoreCase('Salaried__c')){
       Salaried__c salTemp = (Salaried__c)sObj;
       Product = salTemp.Product_Type__c;
       relatedSMSLst = salTemp.SMSes_Sent__r;
       /*for(SMS_Sent__c SMSSent : salTemp.SMSes_Sent__r) {
             if(SMSSent.Name.equalsIgnoreCase(Product + ' ' + custSet)) {
                 SMSSentFlag = true;
                 break;
             }
         }
     }*/

     System.debug('jsonField --> ' + jsonField);
System.debug('sObj --> ' + sObj);
     if (!CommonUtility.isEmpty(productAPI))
      product = (String) getFieldValue(sObj, productAPI);
     relatedSMSLst = sObj.getSObjects('SMSes_sent__r');

     // End of logic to avoid repeated SMS
     system.debug('relatedSMSLst' + relatedSMSLst);
     System.debug('Product --> ' + Product);
     /*OnLine PLTB Start,If/else codition added - Anshita */
     String pltbStr;
     if (ProductSMS__c.getValues(custSet) != null && ProductSMS__c.getValues(custSet).Produtc__c != null) {
      pltbStr = ProductSMS__c.getValues(custSet).Produtc__c;
     }
     ProductSMS__c prodSMS = new ProductSMS__c();
     /*Responsys Dynamic Parameters Bug 15653 s*/
     String recName;
     recName = Product + ' ' + custSet;

     system.debug('inside respObjFlag' + respObjFlag);
     /*Responsys Dynamic Parameters Bug 15653 e*/
     if (pltbStr != null && pltbStr == 'Call Centre') {
      prodSMS = ProductSMS__c.getValues(custSet);
     } else {
      /*Responsys Dynamic Parameters Bug 15653 s*/
      system.debug('inside respObjFlag' + respObjFlag);
      if (!oldFlowFlag && respObjFlag) {
       if (rrMaster != null && rrMaster.size() > 0) {
        for (Rack_Rate__c rr: rrMaster) {
         Set < String > rrProd = new Set < String > ();
         if (rr.Products__c != null)
          rrProd.addAll(rr.Products__c.split(';'));
          system.debug('rr.Event__c===>'+rr.Event__c);
           system.debug('recName ===>'+recName );
           system.debug('custSet===>'+custSet);
           system.debug('rrProd===>'+rrProd);
            system.debug('product===>'+product);
         if ((rr.Event__c == recName || rr.Event__c == custSet) && rrProd.contains(product)) {
          masterRec = rr;
         }
        }
       }
      }
      /*Responsys Dynamic Parameters Bug 15653 e*/
      else {
       /*BFL Homes phase 2 added by priya start */
       if (ProductSMS__c.getValues(Product + ' ' + custSet) != null) {
        //17949--S
        if (ProductSMS__c.getValues(Product + ' ' + custSet) != null)
         prodSMS = ProductSMS__c.getValues(Product + ' ' + custSet);
        else
         prodSMS = ProductSMS__c.getValues(custSet);
        //17949--E

       }
       //prodSMS = ProductSMS__c.getValues(Product + ' ' + custSet);      
       else if (ProductSMS__c.getValues(custSet) != null)
        prodSMS = ProductSMS__c.getValues(custSet);
      }
     }

     System.debug('masterRec' + masterRec);
     System.debug('prodSMS --> ' + prodSMS);
     /*Online PLTB End - Anshita*/
     /*BFL Homes phase 2 added by priya end  added BFl homes condtion in if*/
     //Responsys API added OR condition in if
     if ((!CommonUtility.isEmpty(objName) && prodSMS != null && prodSMS.Make_Active__c == true && ((Product != null && prodSMS.Produtc__c.contains(Product)) || prodSMS.Produtc__c.contains('BFL Homes') || prodSMS.Produtc__c.contains('Call Centre'))) || (!CommonUtility.isEmpty(objName) && masterRec != null)) { //Added Condition for call centre,Online PLTB CR       
      system.debug('inside bfl');
      List < SMS_sent__c > smsTobeSend = new List < SMS_sent__c > ();
      inputMap = new Map < String, Object > ();
      inputMap.put('smsList', relatedSMSLst);
      //inputMap.put('custSetName', Product + ' ' + custSet);
      //Responsys Dynamic Parameters Bug 15653 added if else
      if (!oldFlowFlag && respObjFlag) {
       inputMap.put('rrMasterRec', masterRec);
      } else {
       if (prodSMS != null && prodSMS.Make_Active__c == true && ((Product != null && prodSMS.Produtc__c.contains(Product)) || prodSMS.Produtc__c.contains('BFL Homes') || prodSMS.Produtc__c.contains('Call Centre')))
        inputMap.put('prodSMS', prodSMS);
      }
      inputMap.put('sObj', sObj);
      inputMap.put('objName', objName);
      inputMap.put('type', 'sms');
      if (!oldFlowFlag && respObjFlag) {
       inputMap.put('smsType', masterRec.SMS_Type__c);
      } else {
       if (prodSMS != null && prodSMS.Make_Active__c == true && ((Product != null && prodSMS.Produtc__c.contains(Product)) || prodSMS.Produtc__c.contains('BFL Homes') || prodSMS.Produtc__c.contains('Call Centre')))
        inputMap.put('smsType', prodSMS.SMS_Type__c);
      }
      /*Responsys Dynamic Parameters Bug 15653 s*/
      inputmap.put('Product', Product);
      /*Responsys Dynamic Parameters Bug 15653 e*/
      // Start of changes by Niraj
      system.debug('inputMap===>' + inputMap);
      if (relatedObjName != null && childRelationshipName != null) {
       List < sObject > tempList = sObj.getSObjects(childRelationshipName);
       for (sObject sObjTemp: tempList) {
        inputMap.put('sObj', sObjTemp);
        smsTobeSend.addAll(updateSMSSent(inputMap));
       }
      } else {
       system.debug('inputMap===>' + inputMap);
       smsTobeSend = updateSMSSent(inputMap);
      }
      // End of changes by Niraj

      if (!CommonUtility.isEmpty(smsTobeSend)) {
       //Commenting code for Responsys API Integration

       /*for(SMS_sent__c sms:smsTobeSend){
           // Start of changes by Niraj
           /*if(!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent')
               sendsms.message(sms.SMS_Sent_Number__c,sms.SMS_Text_Sent__c);*/
       /*system.debug('Number --> ' + sms.SMS_Sent_Number__c);
                                    //system.debug('Message --> ' + smsTobeSendMap.get(sms.SMS_Sent_Number__c));
                                    system.debug('Message --> ' + sms.SMS_Text_Sent__c + sms.Additional_SMS_Text_Sent__c);
                                    //&& smsTobeSendMap.get(sms.SMS_Sent_Number__c) != null
                                    if(!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent' && sms.SMS_Sent_Number__c != null){
                                        //sendsms.message(sms.SMS_Sent_Number__c,smsTobeSendMap.get(sms.SMS_Sent_Number__c));
                                        String msgText = sms.SMS_Text_Sent__c;
                                        if(sms.Additional_SMS_Text_Sent__c != null)
                                            msgText = msgText + sms.Additional_SMS_Text_Sent__c;
                                        sendsms.message(sms.SMS_Sent_Number__c, msgText);
                                    }
                                    allsms.add(sms);
                                    // End of changes by Niraj
                                }*/
       /*Responsys API Integration - added by Krish start*/
       system.debug('sms:smsTobeSend' + smsTobeSend);
       Set < String > events = new Set < String > ();
       for (SMS_Sent__c sms: smsTobeSend) {
        system.debug('sms:Event__c' + sms.Event__c);
    system.debug('sms:isPriority__c' + sms.isPriority__c);
         system.debug('masterRec.used_for__c' + masterRec.used_for__c);   
           
           if(masterRec.used_for__c == 'Axiom'){
               system.debug('inside optimised axiom call');
                 if (!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent' && sms.SMS_Sent_Number__c != null) {
                     upsert sms;
                     sendsms.sendSmsAxiom(sms.id); //otp nishit
                     
                 }
           }
           else
               
        if (sms.Event__c != null) {
         if (sms.isPriority__c) {
          system.debug('masterRec.used_for__c' + masterRec.used_for__c);
          if (masterRec.used_for__c == 'Responsys') {
           if (!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent' && sms.SMS_Sent_Number__c != null) {
            //contactNosRes.add(sms.SMS_Sent_Number__c);
            //dynParList.add(sms.SMS_parameters__c);
            respSMS.add(sms);
           }
          } 
             //Axiom- Nishit starts
             /*else if(masterRec.used_for__c == 'Axiom'){
                 if (!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent' && sms.SMS_Sent_Number__c != null) {
                     String msgText = sms.SMS_Text_Sent__c;
                     if (sms.Additional_SMS_Text_Sent__c != null)
                         msgText = msgText + sms.Additional_SMS_Text_Sent__c;
                     msgText= msgText.replace(' ','+');
                     msgText= msgText.replace(',','%2C');
                     sendsms.sendSmsAxiom(msgText, sms.SMS_Sent_Number__c, true); //otp nishit
                     upsert sms;
                 }
             }*/
             //Axiom-nishit ends
             
             else {
           
           if (!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent' && sms.SMS_Sent_Number__c != null) {
            String msgText = sms.SMS_Text_Sent__c;
            if (sms.Additional_SMS_Text_Sent__c != null)
             msgText = msgText + sms.Additional_SMS_Text_Sent__c;
            msgs.add(msgText);
            contactNos.add(sms.SMS_Sent_Number__c);
           }
          }
         }
           /* else{ // This will work if isPriority is unchecked
                if(masterRec.used_for__c == 'Axiom'){
                    if (!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent' && sms.SMS_Sent_Number__c != null) {
                        String msgText = sms.SMS_Text_Sent__c;
                        if (sms.Additional_SMS_Text_Sent__c != null)
                            msgText = msgText + sms.Additional_SMS_Text_Sent__c;
                        msgText= msgText.replace(' ','+');
                        msgText= msgText.replace(',','%2C');
                        sendsms.sendSmsAxiom(msgText, sms.SMS_Sent_Number__c, false ); //NON OTP nishit
                        upsert sms;
                    }
                }
            }*/
            
        } else {
         
           /*Gulshan Axiom-  starts
              if(masterRec.used_for__c == 'Axiom'){
                 if (!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent' && sms.SMS_Sent_Number__c != null) {
                     String msgText = sms.SMS_Text_Sent__c;
                     if (sms.Additional_SMS_Text_Sent__c != null)
                         msgText = msgText + sms.Additional_SMS_Text_Sent__c;
                     msgText= msgText.replace(' ','+');
                     msgText= msgText.replace(',','%2C');
                     sendsms.sendSmsAxiom(msgText, sms.SMS_Sent_Number__c, true); //otp nishit
                     upsert sms;
                 }
             }
          else  
          {
            //Gulshan Axiom- ends*/
            if (!CommonUtility.isEmpty(sms.Status__c) && sms.Status__c == 'Sent' && sms.SMS_Sent_Number__c != null) {
           String msgText = sms.SMS_Text_Sent__c;
          if (sms.Additional_SMS_Text_Sent__c != null)
           msgText = msgText + sms.Additional_SMS_Text_Sent__c;
          msgs.add(msgText);
          contactNos.add(sms.SMS_Sent_Number__c);
         }
        //}   
        }
        allsms.add(sms);

       }
       /*Responsys API Integration - added by Krish end*/
      }

     }
    }
    Set < id > idSet = new Set < Id > ();
    if (respSMS.size() == 0) {
     if ((msgs.size() > 0 && contactNos.size() > 0)) {
      sendsms.sendBulkSMS(msgs, contactNos);

     }
     if (allsms.size() > 0)
      upsert allsms;
    } else {
     upsert respSMS;
     for (SMS_Sent__c sms: respSMS) {
      idSet.add(sms.Id);
     }
     sendsms.sendrespSMS(idSet);
    }
    /*if(contactNosRes.size()>0){
        sendsms.sendresponsysSMS(contactNosRes,dynParList,masterRec.Campaign_Name__c);
        
    }*/


   }
  } catch (Exception e) {
   system.debug('Exception in sendsms' + e.getMessage() + e.getLineNumber());
  }
 }
 /**
  *@author Persistent Systems Ltd.
  *@date 16th August 2016
  *@description : Common Util method for generating dynamic text from the text which is passed as a parameter to the method.
  *@param sObj : A record of sObj from which the data is to be taken. E.g. Loan application number, customer name etc which 
  *              will get replaced with the actual values from the record.
  *@param text : General text which is stored in custom setting record and which gets replaced with dynamic values. 
  */
 public static string GenerateDynamicSOQL(string StaticResourceName, String ObjectName, String WhereClause) {
  String query = 'SELECT ';
  try {
   Set < String > srcNames = new Set < String > ();
   srcnames.addAll(StaticResourceName.split(','));
   //Optimized below code for retrigger BRE 20939 s
   List < StaticResource > srList = new List < StaticResource > ();

   if (srcQueried == null || srcQueried.size() == 0) {
    srcQueried = [SELECT name, Body
     FROM StaticResource
     WHERE Name IN: srcNames LIMIT 2
    ];
   }
   srList = srcQueried;
   //Optimized below code for retrigger BRE 20939 e
   if (srList != null && srList.size() > 0) {
    /*Responsys Dynamic Parameters Bug 15653 s*/
    for (StaticResource sr: srList) {
     if (sr.Name == 'CommunicationMapping')
      jsonString = sr.Body.toString();
     else if (sr.Name == 'ResponsysAPIIntegration')
      jsonStringRes = sr.Body.toString();
    }
    /*Responsys Dynamic Parameters Bug 15653 e*/
   }

   jsonBody = (Map < String, Object > ) JSON.deserializeUntyped(jsonString);
   jsonBodyRes = (Map < String, Object > ) JSON.deserializeUntyped(jsonStringRes); //Responsys Dynamic Parameters Bug 15653 s
   Map < String, Object > jsonField = (Map < String, Object > ) jsonBodyRes.get(ObjectName);

   Map < String, Object > receipients = (Map < String, Object > ) jsonBodyRes.get('Receipients');
   receipientsMap = new Map < String, String > ();
   System.debug('receipients --> ' + receipients);
   for (String key: receipients.keySet()) {
    String value = String.valueOf(receipients.get(key));
    receipientsMap.put(key, value);
   }

   System.debug('jsonField --> ' + jsonField);
   Set < String > FieldNames = new Set < String > ();
   for (String obj: jsonField.keySet()) {
       if (!obj.containsIgnoreCase('ResponsysObj')){
           if(!obj.containsIgnoreCase('Child relationship name')){
               FieldNames.add(String.valueOf(jsonField.get(obj)));
           }
       }
   }

   for (String field: FieldNames) {
    query += field + ',';
   }
      System.debug('query emailer --> ' + query);

   /** 
           Check whether SMSes_Sent__r exists or not in the selected object. 
           If the child relationship exists then append SMSes_Sent__r child list in the query
           else remove extra comma from end. 
   **/
   String fieldAPIName = 'SMSes_Sent__r'; // Field API name
   List < Schema.ChildRelationship > childRelationships = Schema.getGlobalDescribe().get(ObjectName).getDescribe().getChildRelationships();
   boolean fieldPresent = false;
   for (Schema.ChildRelationship child: childRelationships) {
    if (child.getRelationshipName() == fieldAPIName) {
     System.debug('Child relationship is : ' + child.getRelationshipName());
     fieldPresent = true;
     break;
    }
   }

   // Start of changes by Niraj        
   if (relatedObjName != null) {
    Map < String, Object > relatedjsonField = (Map < String, Object > ) jsonBody.get(relatedObjName);
    System.debug('relatedjsonField --> ' + relatedjsonField);
    Set < String > relatedFieldNames = new Set < String > ();
    for (String str: relatedjsonField.keySet()) {
     if (!str.containsIgnoreCase('Child relationship name')) {
      if (!str.containsIgnoreCase('ResponsysObj'))
       relatedFieldNames.add(String.valueOf(relatedjsonField.get(str)));
     } else {
      childRelationshipName = String.valueOf(relatedjsonField.get(str));
     }

     if (str.containsIgnoreCase('Parent relationship name')) {
      parentRelationshipName = String.valueOf(relatedjsonField.get(str));
     }
    }


    query += ' (SELECT ';
    for (String field: relatedFieldNames) {
     query += field + ',';
    }
    query = query.removeEnd(',');
    if (relWhere != null && relWhere != '')
     query += ' FROM ' + childRelationshipName + ' ' + relWhere + '),';
    else
     query += ' FROM ' + childRelationshipName + '),';

   }
   // End of changes by Niraj

   if (fieldPresent) {
    query += ' (SELECT Name, SMS_Type__c, Status__c, SMS_Receiver__c,SMS_Sent__c,Email_sent__c FROM SMSes_Sent__r)';
   } else {
    query = query.removeEnd(',');
   }
   query += ' FROM ' + ObjectName + ' ' + WhereClause;
   System.debug('query --> ' + query);
  } catch (Exception e) {
   system.debug('Exception in generate SOQL' + e.getMessage() + e.getLineNumber());
  }

  return query;
 }

 /**
  *@author Persistent Systems Ltd.
  *@date 3rd August 2016
  *@description : Common Util method for generating dynamic text from the text which is passed as a parameter to the method.
  *@param sObj : A record of sObj from which the data is to be taken. E.g. Loan application number, customer name etc which 
  *              will get replaced with the actual values from the record.
  *@param text : General text which is stored in custom setting record and which gets replaced with dynamic values. 
  */
 public static String generateSMSText(sObject sObj, String text) {

  String objName = sObj.getSObjectType().getDescribe().getName();
  system.debug('generateSMSText objName --> ' + objName);

  Map < String, Object > jsonField = new Map < String, Object > ();
  String product;
  String companyName, customerCareEmail, customerCareNo;

  //Map<String, Object> jsonBody = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
  if (!CommonUtility.isEmpty(jsonBody) && jsonBody.containsKey(objName) && !CommonUtility.isEmpty(jsonBody.get(objName)))
   jsonField = (Map < String, Object > ) jsonBody.get(objName);

  System.debug('jsonField --> ' + jsonField);

  if (!CommonUtility.isEmpty(jsonField) && jsonField.containsKey('**Product**') && !CommonUtility.isEmpty(jsonField.get('**Product**')))
   product = (String) getFieldValue(sObj, (String) jsonField.get('**Product**'));

  /*if(objName.equalsIgnoreCase('Opportunity')) {
      Opportunity Loan = (Opportunity) sObj;
      product = Loan.Product__c;
  } else if(objName.equalsIgnoreCase('Product_Offerings__c')) {
      Product_Offerings__c PO = (Product_Offerings__c) sObj;
      product = PO.Products__c;
  }else if(objName.equalsIgnoreCase('Salaried__c')){
      Salaried__c sal = (Salaried__c) sObj;
      product = sal.Product_Type__c;              
  }*/

  if (!CommonUtility.isEmpty(product)) {
   ProductSMS__c companyCode;
   String productRecords = Label.Product_company_custom_settings;
   if (!CommonUtility.isEmpty(productRecords)) {
    List < String > productRecordLst = productRecords.split(';');
    for (String custSet: productRecordLst) {
     companyCode = ProductSMS__c.getValues(custSet);
     if (!CommonUtility.isEmpty(companyCode) && !CommonUtility.isEmpty(companyCode.Produtc__c) && companyCode.Produtc__c.contains(product)) {
      for (String tempProduct: companyCode.Produtc__c.split(',')) {
       if (tempProduct.equalsIgnoreCase(product)) {
        companyName = companyCode.Company_name__c;
        customerCareEmail = companyCode.Customer_Care_Email__c;
        customerCareNo = companyCode.Customer_Care_Number__c;
        break;
       }
      }
     }
    }
   }
  }


  /*String companyName,customerCareEmail,customerCareNo;
  ProductSMS__c companyCode = ProductSMS__c.getValues('BFL Products');
  if(companyCode.Produtc__c.contains(product)) {
      companyName = companyCode.Company_name__c;
      customerCareEmail = companyCode.Customer_Care_Email__c;
      customerCareNo = companyCode.Customer_Care_Number__c;
  } else {
      companyCode = ProductSMS__c.getValues('HFC Products');
      if(companyCode.Produtc__c.contains(product)) {
          companyName = companyCode.Company_name__c;
          customerCareEmail = companyCode.Customer_Care_Email__c;
          customerCareNo = companyCode.Customer_Care_Number__c;
      } else{
          companyCode = ProductSMS__c.getValues('DG Products');
          if(companyCode.Produtc__c.contains(product)) {
              companyName = companyCode.Company_name__c;
              customerCareEmail = companyCode.Customer_Care_Email__c;
              customerCareNo = companyCode.Customer_Care_Number__c;
          }
      }   
  }*/

  system.debug('companyName --> ' + companyName);

  /*jsonBody = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
  Map<String, Object> jsonField = (Map<String, Object>)jsonBody.get(objName);
  System.debug('jsonField --> ' + jsonField);*/

  for (String key: jsonField.keySet()) {
   String fieldName = String.valueOf(jsonField.get(key));
   System.debug('Key --> ' + key + ' fieldName --> ' + fieldName);
   String fieldValue;
   // Start of changes by Niraj
   if (!key.containsIgnoreCase('Child relationship name')) {
    if (!key.containsIgnoreCase('ResponsysObj'))
     fieldValue = String.valueOf(getFieldValue(sObj, fieldName));
   }
   // End of changes by Niraj
   System.debug('fieldValue --> ' + fieldValue);

   // Start of new logic
   String fieldTypeName;
   // Start of changes by Niraj
   if (!key.containsIgnoreCase('Child relationship name')) {
    if (!key.containsIgnoreCase('ResponsysObj'))
     fieldTypeName = String.valueOf(getFieldType(sObj, fieldName));
   }
   // End of changes by Niraj
   system.debug('fieldTypeName --> ' + fieldTypeName);
   if (!CommonUtility.isEmpty(fieldTypeName) && text != null) {
    if (fieldTypeName.equalsIgnoreCase('Phone')) {
     if (fieldValue != null) {
      fieldValue = fieldValue.replaceAll('[^0-9]', '');
      text = text.replace(key, fieldValue);
     }
    } else
    if (fieldTypeName.equalsIgnoreCase('DateTime') && text.contains('Date') && key.contains('Date')) {
     if (fieldValue != null) {
      DateTime dt = DateTime.valueofGmt(fieldValue);
      String str = dt.format('dd/MM/yyyy h:mm a', UserInfo.getTimeZone().toString());
      Integer index = str.indexOf(' ');
      System.debug('Date str --> ' + str);
      text = text.replace(key, str.substring(0, index));
     }
    } else
    if (fieldTypeName.equalsIgnoreCase('DateTime') && text.contains('Time') && key.contains('Time')) {
     if (fieldValue != null) {
      DateTime dt = DateTime.valueofGmt(fieldValue);
      String str = dt.format('dd/MM/yyyy h:mm a', UserInfo.getTimeZone().toString());
      Integer index = str.indexOf(' ');
      System.debug('Time str --> ' + str);
      text = text.replace(key, str.substring(index + 1, str.length()));
     }
    } else
     // Start of changes by Niraj
     if (fieldTypeName.equalsIgnoreCase('Date')) {
      if (fieldValue != null) {
       DateTime dt = DateTime.valueofGmt(fieldValue);
       String str = dt.format('dd/MM/yyyy', UserInfo.getTimeZone().toString());
       text = text.replace(key, str);
      }
     }
    // End of changes by Niraj                              
    else {
     /*20939 s*/
     if (key == '**bitlyLink**') {
      if (text.contains('**vf')) {
       String vfPage = text.substringAfter('**vf').substringBefore('**vfe');
       system.debug('vfpage' + vfPage);
       String encryptId = CommonUtility.encryptURLParam(fieldValue);
       String bitlyLink = CommonUtility.googleShortenUrl(Label.BflsiteuserURL + '/' + vfPage + '?id=' + encryptId);
       text = text.replace('**vf' + vfPage + '**vfe', bitlyLink);
      }
     }
     /*20939 e*/
     if (fieldValue != null) {
      text = text.replace(key, fieldValue);
     }
    }
   }
   // End of new logic
   System.debug('Latest text --> ' + text);
  }
  /*20939 s*/
  if (text.contains('**OTP**')) {
   String otp = '';
   otp = GeneralUtilities.generateOTPPwd(5);
   text = text.replace('**OTP**', otp);

  }
  /*20939 e*/
  if (text != null) {
   text = text.replace('**Company Name**', (companyName != null ? companyName : 'unknown'));
   text = text.replace('**Customer Care Email**', (customerCareEmail != null ? customerCareEmail : 'unknown'));
   text = text.replace('**Customer Care No**', (customerCareNo != null ? customerCareNo : 'unknown'));
   text = text.replace('**Month**', system.now().format('MMMM'));
  }
  system.debug('Text generated --> ' + text);
  return text;
 }

 /**
 *@author Persistent Systems Ltd.
 *@date 3rd August 2016
 *@description : Following method is used to get the values of fields dynamically. This method will also consider relational
                 object fields and will retrieve the values of those fields. 
 *@param sObj : A record of sObj from which the data is to be taken.
 *@param field : API name of the field which is to be retrieved. This API name is stored in custom setting record of ProductSMS__c in ReceipientsAPINames__c. 
 */
 public static Object getFieldValue(SObject sObj, String field) {

  if (sObj == null) {
   return null;
  }

  if (field.contains('.')) {
   String nextField = field.substringAfter('.');
   String relation = field.substringBefore('.');
   return getFieldValue((SObject) sObj.getSObject(relation), nextField);
  } else {
   system.debug('field name sp' + field);

   return sObj.get(field);



  }

 }

 /**
 *@author Persistent Systems Ltd.
 *@date 3rd August 2016
 *@description : Following method is used to get the data type of fields dynamically. This method will also consider relational
                 object fields and will retrieve the data type of those fields. 
 *@param sObj : A record of sObj from which the data is to be taken.
 *@param field : API name of the field whose date type is to be retrieved. This API name is stored in custom setting record of ProductSMS__c in ReceipientsAPINames__c. 
 */
 public static Object getFieldType(SObject sObj, String field) {
  if (sObj == null) {
   return null;
  }

  if (field.contains('.')) {
   String nextField = field.substringAfter('.');
   String relation = field.substringBefore('.');
   return getFieldType((SObject) sObj.getSObject(relation), nextField);
  } else {
   String objName = sObj.getSObjectType().getDescribe().getName();
   String fieldTypeName = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(field).getDescribe().getType().name();
   return fieldTypeName;
  }

 }

 /**
  *@author Persistent Systems Ltd.
  *@date 16th August 2016
  *@description : Following method is used to get the name of the Object by the corresponding Record ID or prefix.
  *@param recordIdOrPrefix : A record Id or prefix of sObj from which the Object name is to be taken.
  */

 public static String getObjectNameebyRecordID(Id recordIdOrPrefix) {

  String objectName = '';
  try {
   String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0, 3);

   Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();

   for (Schema.SObjectType stype: gd.values()) {
    Schema.DescribeSObjectResult r = stype.getDescribe();
    String prefix = r.getKeyPrefix();

    if (prefix != null && prefix.equals(myIdPrefix)) {
     objectName = r.getName();
     System.debug('Object Name! ' + objectName);
     break;
    }
   }
  } catch (Exception e) {
   System.debug(e);
  }
  return objectName;

 }




 /**
  *@author Persistent Systems Ltd.
  *@date 3rd August 2016
  *@description : Common Util method for sending Email to customer and internal team. This method is bulkified which can be called from triggers.
  *               This method checks for valid custom setting record which is active and matching with the product. 
  *               It also inserts a record in SMS_Sent__c object to keep track of all the Email's sent to avoid duplicate Email.
  *@param sObjList : A list of sObject which can be PO or Opportunity.
  *@param custSet : General name for custom setting record which is appended with Product in the method. 
  *                 E.g. If custom setting record is SHL Sales Login-Cust then need to pass "Sales Login-Cust" in custSet.  
  */
 public static void sendEmail(List < sObject > sObjList, String custSet) {
  system.debug('Inside send Email and custom setting record is : ' + custSet);
  if (sObjList != null && sObjList.size() > 0) {

   String objName = sObjList[0].getSObjectType().getDescribe().getName();
   List < SMS_Sent__c > allsms = new List < SMS_Sent__c > ();
   String Product;
   Map < String, Object > inputMap;
   List < SMS_Sent__c > relatedSMSLst;

   Set < ID > VAMSet = new Set < ID > ();
   for (sObject sObj: sObjList) {
    VAMSet.add(sObj.id);
   }
   System.debug('objName --> ' + objName);
   String query = GenerateDynamicSOQL('CommunicationMapping,ResponsysAPIIntegration', objName, ' WHERE ID IN : VAMSet');
   System.debug('query --> ' + query);
   try {
    if (VAMSet.size() > 0) {
     sObjList = Database.query(query);
    }
   } catch (DMLException e) {
    System.debug('Exception occured at line --> ' + e.getLineNumber() + ' Root cause --> ' + e.getCause());
   }

   Map < ID, Map < String, List < String >>> mapOfTemplateToAddress = new Map < ID, Map < String, List < String >>> ();
   List < String > templateList = new List < String > ();
   Map < ID, sObject > mapOfIdToSobj = new Map < ID, sObject > ();

   String productAPI;

   Map < String, Object > jsonField = new Map < String, Object > ();
   if (!CommonUtility.isEmpty(jsonBody) && jsonBody.containsKey(objName) && !CommonUtility.isEmpty(jsonBody.get(objName)))
    jsonField = (Map < String, Object > ) jsonBody.get(objName);

   if (!CommonUtility.isEmpty(jsonField) && jsonField.containsKey('**Product**') && !CommonUtility.isEmpty(jsonField.get('**Product**')))
    productAPI = String.valueOf(jsonField.get('**Product**'));
   //code added by leena--start
   String[] ccarray = new String[] {};
   //code added by leena--end
   for (sObject sObj: sObjList) {

    // Start of logic to avoid repeated Email

    System.debug('jsonField --> ' + jsonField);

    if (!CommonUtility.isEmpty(productAPI))
     product = (String) getFieldValue(sObj, productAPI);

    relatedSMSLst = sObj.getSObjects('SMSes_Sent__r');
    ID whatID = sObj.Id;
    mapOfIdToSobj.put(whatID, sObj);

    /*Boolean EmailSentFlag = false;
                ID whatID;
                if(objName.equalsIgnoreCase('Opportunity')) {
                    Opportunity oppTemp;
                    oppTemp = (Opportunity) sObj;
                    Product = oppTemp.Product__c;
                    whatID = oppTemp.id;
                    mapOfIdToSobj.put(whatID,sObj);
                    System.debug('Opp whatid --> ' + whatID);
                    relatedSMSLst = oppTemp.SMSes_Sent__r;
                    
                } else if(objName.equalsIgnoreCase('Product_Offerings__c')) {
                        Product_Offerings__c POTemp;
                        POTemp = (Product_Offerings__c) sObj;
                        Product = POTemp.Products__c;
                        whatID = POTemp.id;
                        mapOfIdToSobj.put(whatID,sObj);
                        relatedSMSLst = POTemp.SMSes_Sent__r;
                        
                 }else if(objName.equalsIgnoreCase('Salaried__c')){
                   //code added by Harsit for 'SHOL Communication' -- start
                   Salaried__c salTemp = (Salaried__c)sObj;
                      Product = salTemp.Product_Type__c;
                      whatID = salTemp.Id;
                      mapOfIdToSobj.put(whatID,sObj);
                      relatedSMSLst = salTemp.SMSes_Sent__r;
                      
          //code added by Harsit for 'SHOL Communication' -- end
                 }*/
    // End of logic to avoid repeated Email

    System.debug('Product --> ' + Product);
    /*BFL Homes phase 2 added by priya start */
    ProductSMS__c prodEmail = new ProductSMS__c();
    if (Product != null)
     prodEmail = ProductSMS__c.getValues(Product + ' ' + custSet);
    else
     prodEmail = ProductSMS__c.getValues(custSet);
    /*20939 s*/
    if (prodEmail == null)
     prodEmail = ProductSMS__c.getValues(custSet);
    /*20939 e*/
    /*BFL Homes phase 2 added by priya end  added BFl homes condtion in if*/
    System.debug('prodEmail --> ' + prodEmail);
    //Responsys API Integration added OR in if
    if ((!CommonUtility.isEmpty(objName) && prodEmail != null && prodEmail.Is_Email_Active__c == true && ((Product != null && prodEmail.Produtc__c.contains(Product)) || prodEmail.Produtc__c.contains('BFL Homes')))) {
     System.debug('prodemail');
     inputMap = new Map < String, Object > ();
     inputMap.put('smsList', relatedSMSLst);
     //inputMap.put('custSetName', Product + ' ' + custSet);
     //Responsys API Integration added if else condition
     if (prodEmail != null && prodEmail.Is_Email_Active__c == true && prodEmail.Produtc__c.contains(Product))
      inputMap.put('prodSMS', prodEmail);
     inputMap.put('sObj', sObj);
     inputMap.put('objName', objName);
     inputMap.put('type', 'email');
     system.debug('inputmap sp' + inputmap);
     List < SMS_sent__c > emailTobeSend = updateSMSSent(inputMap);
     System.debug('email to be send: ' + emailTobeSend);
     if (!CommonUtility.isEmpty(emailTobeSend)) {

      String templateName;
      if (prodEmail != null && prodEmail.Is_Email_Active__c == true && prodEmail.Produtc__c.contains(Product))
       templateName = prodEmail.VFEmailTemplate__c;
      String[] toAddresses = new String[] {};

      for (SMS_sent__c sms: emailTobeSend) {
       System.debug(' \n\nsms : ' + sms);
       if (!CommonUtility.isEmpty(sms.Email_sent_at__c))
        toAddresses.add(sms.Email_sent_at__c);
       allsms.add(sms);
      }

      BAFL_EmailServicesLogix.Attachment[] Attachments = new BAFL_EmailServicesLogix.Attachment[] {};

      System.debug('toAddresses --> ' + toAddresses + ' whatId --> ' + whatId);
      if (whatID != null && toAddresses != null) {
       Map < String, List < String >> tempMap = new Map < String, List < String >> ();
       tempMap.put(templateName, toAddresses);
       mapOfTemplateToAddress.put(whatID, tempMap);
       System.debug('mapOfTemplateToAddress --> ' + mapOfTemplateToAddress);
      }

      if (templateName != null) {
       templateList.add(templateName);
      }

     } else {
      system.debug('Email for ' + custSet + ' is already sent...');
     }
     List < String > emailCCrec = new List < String > (); //Responsys API Integration
     //Responsys API Integration added if else
     if (prodEmail != null && prodEmail.EmailCCReceipients__c != null) {
      emailCCrec = prodEmail.EmailCCReceipients__c.split(',');
     }
     //code added by leena--start
     //Responsys API Integration change for loop
     for (string ccstr: emailCCrec) {
      String ccemailvalue = String.valueOf(getFieldValue(sObj, ccstr));
      ccarray.add(ccemailvalue);
     }
     //code added by leena--end                      
    }

   }

   ID templateId;
   List < EmailTemplate > tempID;
   system.debug('templateList: ' + templateList);
   if (templateList != null && templateList.size() > 0) {
    tempID = [SELECT Id, HTMLValue, Name, Subject FROM EmailTemplate WHERE Name IN: templateList];
    for (ID whatID: mapOfTemplateToAddress.keySet()) {
     Map < String, List < String >> tempMap = mapOfTemplateToAddress.get(whatID);
     for (String template: tempMap.keySet()) {
      for (EmailTemplate et: tempID) {
       if (template.equalsIgnoreCase(et.Name)) {
        templateId = et.Id;
        String[] toAddress = tempMap.get(template);
        //code added by leena--start
        String[] CC = ccarray;
        //code added by leena--end

        String[] bcc = new String[] {};
        System.debug('Template matched :: id --> ' + templateId + ' Name --> ' + et.Name + ' WhatID --> ' + whatID);
        String fromName = 'noreply@bajajfinserv.in';
        String replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
        String EmailSubject = et.Subject;
        System.debug('et.Subject --> ' + et.Subject);
        if (objName.equalsIgnoreCase('Opportunity')) {
         System.debug('EmailSubject --> ' + EmailSubject);
         if (EmailSubject != null) {
          Opportunity opp = (Opportunity) mapOfIdToSobj.get(whatID);
          /*String companyName,customerCareEmail,customerCareNo;
          ProductSMS__c companyCode = ProductSMS__c.getValues('BFL Products');
          if(companyCode.Produtc__c.contains(opp.Product__c)) {
              companyName = companyCode.Company_name__c;
              customerCareEmail = companyCode.Customer_Care_Email__c;
              customerCareNo = companyCode.Customer_Care_Number__c;
          } else {
              companyCode = ProductSMS__c.getValues('HFC Products');
              if(companyCode.Produtc__c.contains(opp.Product__c)) {
                  companyName = companyCode.Company_name__c;
                  customerCareEmail = companyCode.Customer_Care_Email__c;
                  customerCareNo = companyCode.Customer_Care_Number__c;
              } else{
                  
              }   
          }*/
          String companyName, customerCareEmail, customerCareNo;
          ProductSMS__c companyCode;
          String productRecords = Label.Product_company_custom_settings;
          if (!CommonUtility.isEmpty(productRecords)) {
           List < String > productRecordLst = productRecords.split(';');
           for (String custSetName: productRecordLst) {
            companyCode = ProductSMS__c.getValues(custSetName);
            if (!CommonUtility.isEmpty(companyCode) && companyCode.Produtc__c.contains(opp.Product__c)) {
             companyName = companyCode.Company_name__c;
             customerCareEmail = companyCode.Customer_Care_Email__c;
             customerCareNo = companyCode.Customer_Care_Number__c;
            }
           }
          }

          System.debug('EmailSubject --> ' + EmailSubject);
          EmailSubject = EmailSubject.replace('*APPLICATION NO*', (opp.Loan_Application_Number__c != null ? opp.Loan_Application_Number__c : 'unknown'));
          EmailSubject = EmailSubject.replace('*CUSTOMER NAME*', (opp.Account.Name != null ? opp.Account.Name : 'unknown'));
          EmailSubject = EmailSubject.replace('*COMPANY NAME*', (companyName != null ? companyName : 'unknown'));

          System.debug('EmailSubject --> here is ===> ' + EmailSubject);
         } else {
          EmailSubject = 'STATUS OF YOUR LOAN APPLICATION';
         }
        } else {
         //if(objName.equalsIgnoreCase('Product_Offerings__c')) {}
        }
        System.debug('Sending email using new logic...');
        System.debug('whatID --> ' + whatID);
        System.debug('templateId --> ' + templateId);
        System.debug('fromName --> ' + fromName);
        System.debug('toAddress --> ' + toAddress);
        System.debug('EmailSubject --> ' + EmailSubject);
        if(custSet == 'HFC Digital Sampling'){
            String labelEmail = System.label.HFC_RCU_Email;
            List<String> addEmail = labelEmail.split(',');
            for(String str : addEmail){
                toAddress.add(str);
            }
        }
           System.debug('HFC Digital toAddress --> ' + toAddress);
        if (!Test.isRunningTest())
         GeneralUtilities.SendEmailUsingBAFLLogix(whatID, templateId, fromName, replyTo, toAddress, CC, bcc, 'Normal', EmailSubject, 'bajaj');
       }
      }
     }
    }
    system.debug('allsms size --> ' + allsms.size());
    if (allsms.size() > 0)
     upsert allsms;
   }
  }
 }

 /**
     Description
     -----------
     -----------
     
     It is the common method used to insert/update the SMS_Sent__c record for the corresponding sObj.
     Pass the following parameters in the inputMap:
   1) prodSMS ----- ProductSMS cust setting record
   2) type -------- email|sms
   3) sObj -------- sObject
   4) objName ----- object API name (opportunity | Product_Offerings__c | Salaried__c)
   5) smsList ----- List<SMS_sent__c> of the corressponding sObject
 **/

 public static List < SMS_sent__c > updateSMSSent(Map < String, Object > inputMap) {
  /*Responsys Dynamic Parameters Bug 15653 s*/
  String Product;
  Rack_Rate__c rrMasterRec = new Rack_Rate__c();
  /*Responsys Dynamic Parameters Bug 15653 e*/
  Boolean SMSSentRecordPresent = false;
  SMS_Sent__c sms;
  String custSetName;
  ProductSMS__c prodSMS;
  String typeOfComm;
  List < SMS_Sent__c > allsms = new List < SMS_Sent__c > ();
  Map < String, SMS_Sent__c > alreadySentSMS = new Map < String, SMS_Sent__c > ();
  Map < String, Object > smsInputMap;
  sObject sObj;
  String objName;

  if (!commonUtility.isEmpty(inputMap)) {

   if (inputMap.containsKey('prodSMS') && !commonutility.isEmpty(inputMap.get('prodSMS'))) {
    prodSMS = (ProductSMS__c) inputMap.get('prodSMS');
    custSetName = prodSMS.Name;
   }
   /*Responsys Dynamic Parameters Bug 15653 s*/
   if (inputMap.containsKey('Product') && !commonutility.isEmpty(inputMap.get('Product'))) {
    Product = (String) inputMap.get('Product');
   }
   if (inputMap.containsKey('rrMasterRec') && !commonutility.isEmpty(inputMap.get('rrMasterRec'))) {
    rrMasterRec = (Rack_Rate__c) inputMap.get('rrMasterRec');
    custSetName = rrMasterRec.Event__c;
   }
   // system.debug('custSetName' + custSetName);
   /*Responsys Dynamic Parameters Bug 15653 e*/
   if (inputMap.containsKey('type') && !commonutility.isEmpty(inputMap.get('type')))
    typeOfComm = (String) inputMap.get('type');
   if (inputMap.containsKey('sObj') && !commonutility.isEmpty(inputMap.get('sObj')))
    sObj = (sObject) inputMap.get('sObj');
   if (inputMap.containsKey('objName') && !commonutility.isEmpty(inputMap.get('objName')))
    objName = (String) inputMap.get('objName');
   //Responsys API Integration changed added OR in if condition 
   if ((!CommonUtility.isEmpty(custSetName) && !CommonUtility.isEmpty(prodSMS) && !CommonUtility.isEmpty(typeOfComm) && !CommonUtility.isEmpty(sObj) && !CommonUtility.isEmpty(objName)) || (!CommonUtility.isEmpty(custSetName) && !CommonUtility.isEmpty(rrMasterRec) && !CommonUtility.isEmpty(typeOfComm) && !CommonUtility.isEmpty(sObj) && !CommonUtility.isEmpty(objName))) {
    if (inputMap.containsKey('smsList') && !commonutility.isEmpty(inputMap.get('smsList'))) {
     System.debug('smslist:' + (List < SMS_Sent__c > ) inputMap.get('smsList'));
     for (SMS_Sent__c SMSSent: (List < SMS_Sent__c > ) inputMap.get('smsList')) {
      if (SMSSent.Name.equalsIgnoreCase(custSetName)) {
       //SMSSentFlag = true;
       if (!CommonUtility.isEmpty(SMSSent.SMS_Receiver__c))
        alreadySentSMS.put(SMSSent.SMS_Receiver__c, SMSSent);
       SMSSentRecordPresent = true;
      }
     }

    }

    System.debug('SMSSentRecordPresent:' + SMSSentRecordPresent);
    if (typeOfComm.equalsIgnoreCase('sms')) {
     String receipientType;
     String message;
     /*Responsys Dynamic Parameters Bug 15653 s*/
     String event;
     Boolean resend = false;
     String dynParaJsn;
     Boolean isPriority = false;
     /*Responsys Dynamic Parameters Bug 15653 e*/
     //Responsys Dynamic Parameters Bug 15653 added if else
     if (!oldFlowFlag && respObjFlag) {
      if (rrMasterRec != null) {
       event = rrMasterRec.campaign_name__c;
       isPriority = rrMasterRec.isPriority__c;
       resend = rrMasterRec.resendFlag__c;
       /*Below commenting done by Rohan for Responsys switching Logic*/
       /* if(product != null && setProdRes.contains(Product) && !rrMasterRec.isPriority__c){*/
       system.debug('setProdRes' + setProdRes + rrMasterRec.used_for__c);
       if (product != null && setProdRes.contains(Product) && rrMasterRec.used_for__c == 'Responsys') {
        system.debug('dyn_para' + rrMasterRec.dynamic_parameters__c);
        if (rrMasterRec.dynamic_parameters__c != null)
         dynParaJsn = generateDynamicParam(sObj, rrMasterRec.dynamic_parameters__c);
       } else if (rrMasterRec.isPriority__c && rrMasterRec.used_for__c == 'Responsys') {
        if (rrMasterRec.dynamic_parameters__c != null)
         dynParaJsn = generateDynamicParam(sObj, rrMasterRec.dynamic_parameters__c);
       } else {
        message = generateSMSText(sObj, rrMasterRec.SMS_Text__c);
        if (rrMasterRec.Additional_SMS_Text__c != null && rrMasterRec.Additional_SMS_Text__c != '') {
         message += generateSMSText(sObj, rrMasterRec.Additional_SMS_Text__c);
        }
       }
      }
     } else {
      if (prodSMS != null) {
       message = generateSMSText(sObj, prodSMS.SMS_Text__c);
       // Start of changes by Niraj
       if (prodSMS.Additional_SMS_Text__c != null && prodSMS.Additional_SMS_Text__c != '') {
        message += generateSMSText(sObj, prodSMS.Additional_SMS_Text__c);
       }
       // End of changes by Niraj
      }

     }

     // Bug id : 13016 - New Role Creation for Credit, added by Needhi 
     /* BFL Homes  phase 2 if condition added by priya */
     List < String > mobileRecipientsList = new List < String > ();
     //Responsys Dynamic Parameters Bug 15653 added if else
     if (!oldFlowFlag && respObjFlag) {
      if (rrMasterRec != null) {
       if (rrMasterRec.ReceipientsAPINames__c != null && rrMasterRec.ReceipientsAPINames__c != '') {
        mobileRecipientsList = rrMasterRec.ReceipientsAPINames__c.split(',');

       }
      }
     } else {
      if (prodSMS != null) {
       if (prodSMS.ReceipientsAPINames__c != null && prodSMS.ReceipientsAPINames__c != '') {
        mobileRecipientsList = prodSMS.ReceipientsAPINames__c.split(',');
        System.debug('1 receipient***' + mobileRecipientsList);
        if (!String.isBlank(prodSMS.ReceipientsAPINames1__c)) {
         mobileRecipientsList.addAll(prodSMS.ReceipientsAPINames1__c.split(','));
        }
       }
      }
     }
     /*for (String s : mobileRecipientsList) {
         System.debug('s -->' + s);
     }*/
     System.debug('2 receipient***' + mobileRecipientsList);
     for (String receipient: mobileRecipientsList) {
      System.debug('Receipient --> ' + receipient);
      String phone = String.valueOf(getFieldValue(sObj, receipient));
      System.debug('Phone --> ' + phone);
      if (phone != null) {
       phone = phone.replaceAll('[^0-9]', '');
       System.debug('Phone --> ' + phone);
       smsInputMap = new Map < String, Object > ();
       smsInputMap.put('sendTo', phone);
       smsInputMap.put('message', message);
       //Responsys API added if else
       if (!oldFlowFlag && respObjFlag) {
        if (rrMasterRec != null)
         smsInputMap.put('smsType', rrMasterRec.SMS_Type__c);
       } else {
        if (prodSMS != null)
         smsInputMap.put('smsType', prodSMS.SMS_Type__c);
       }
       smsInputMap.put('event', event); //Responsys API Integration
       if (!SMSSentRecordPresent || resend) {
        smsInputMap.put('receipient', receipient);
        smsInputMap.put('objName', objName);
        smsInputMap.put('sObj', sObj);
        smsInputMap.put('name', custSetName);
        /*Responsys Dynamic Parameters Bug 15653 s*/
        smsInputMap.put('isPriority', isPriority);
        smsInputMap.put('dynParaJsn', dynParaJsn);
        smsInputMap.put('Product', Product);
        /*Responsys Dynamic Parameters Bug 15653 e*/
        sms = createORUpdateSMSSentRecord(smsInputMap, 'sms');
        if (!CommonUtility.isEmpty(sms))
         allsms.add(sms);

       } else {
        System.debug('record is present with same custom setting name');
        receipientType = getReciepientTypeByAPI(receipient);
        if (alreadySentSMS.containsKey(receipientType) && !commonUtility.isEmpty(alreadySentSMS.get(receipientType))) {
         sms = alreadySentSMS.get(receipientType);
         if ((!respObjFlag || oldFlowFlag || !setProdRes.contains(Product)) && sms.SMS_Sent__c == false) {
          System.debug('present but sms not sent');
          smsInputMap.put('sms', sms);
          sms = createORUpdateSMSSentRecord(smsInputMap, 'sms');
          if (!CommonUtility.isEmpty(sms))
           allsms.add(sms);
         }
        } else {
         smsInputMap.put('receipient', receipient);
         smsInputMap.put('objName', objName);
         smsInputMap.put('sObj', sObj);
         smsInputMap.put('name', custSetName);
         /*Responsys Dynamic Parameters Bug 15653 s*/
         smsInputMap.put('isPriority', isPriority);
         smsInputMap.put('dynParaJsn', dynParaJsn);
         smsInputMap.put('Product', Product);
         /*Responsys Dynamic Parameters Bug 15653 e*/
         sms = createORUpdateSMSSentRecord(smsInputMap, 'sms');
         if (!CommonUtility.isEmpty(sms))
          allsms.add(sms);
        }
       }
      }

     }
     /* BFL Homes phase 2 added by priya start  */
     List < String > mobileRecipientsList1 = new List < String > ();
     //System.debug('receipient***'+prodSMS.Mobile_Number__c);
     /*Responsys Dynamic Parameters Bug 15653 added if else*/
     if (!oldFlowFlag && respObjFlag) {
      if (rrMasterRec != null) {
       //if(rrMasterRec.Mobile_Number__c != null &&  rrMasterRec.Mobile_Number__c != ''){
       //mobileRecipientsList1 = rrMasterRec.Mobile_Number__c.split(',');
       //}
      }
     } else {
      if (prodSMS != null) { //Responsys added if condition
       if (prodSMS.Mobile_Number__c != null && prodSMS.Mobile_Number__c != '') {
        mobileRecipientsList1 = prodSMS.Mobile_Number__c.split(',');
       }
      }
     }
     for (String receipient: mobileRecipientsList1) {
      System.debug('Receipient --> ' + receipient);
      String phone = String.valueOf(receipient);
      System.debug('Phone --> ' + phone);
      if (phone != null) {
       phone = phone.replaceAll('[^0-9]', '');
       System.debug('Phone --> ' + phone);
       smsInputMap = new Map < String, Object > ();
       smsInputMap.put('sendTo', phone);
       smsInputMap.put('message', message);
       smsInputMap.put('smsType', prodSMS.SMS_Type__c);
       if (!SMSSentRecordPresent) {
        System.debug('not sent');
        smsInputMap.put('receipient', receipient);
        smsInputMap.put('objName', objName);
        smsInputMap.put('sObj', sObj);
        smsInputMap.put('name', custSetName);
        sms = createORUpdateSMSSentRecord(smsInputMap, 'sms');
        if (!CommonUtility.isEmpty(sms))
         allsms.add(sms);

       } else {
        System.debug('record is present with same custom setting name');
        receipientType = getReciepientTypeByAPI(receipient);
        if (alreadySentSMS.containsKey(receipientType) && !commonUtility.isEmpty(alreadySentSMS.get(receipientType))) {
         sms = alreadySentSMS.get(receipientType);
         if (sms.SMS_Sent__c == false) {
          System.debug('present but sms not sent');
          smsInputMap.put('sms', sms);
          sms = createORUpdateSMSSentRecord(smsInputMap, 'sms');
          if (!CommonUtility.isEmpty(sms))
           allsms.add(sms);
         }
        } else {
         smsInputMap.put('receipient', receipient);
         smsInputMap.put('objName', objName);
         smsInputMap.put('sObj', sObj);
         smsInputMap.put('name', custSetName);
         sms = createORUpdateSMSSentRecord(smsInputMap, 'sms');
         if (!CommonUtility.isEmpty(sms))
          allsms.add(sms);
        }
       }
      }
     }
     // }

     /* BFL Homes phase 2 added by priya end  */

    } else if (typeOfComm.equalsIgnoreCase('email')) {
     String receipientType;
     List < String > recNames = new List < String > (); //Responsys API Integration
     if (prodSMS != null && !CommonUtility.isEmpty(prodSMS.EmailToReceipients__c))
      recNames = prodSMS.EmailToReceipients__c.split(',');
     /*else if(newProdSMS != null && !CommonUtility.isEmpty((String)newProdSMS.get('email_receipient_names'))){
         String reciever = (String)newProdSMS.get('email_receipient_names');
         recNames = reciever.split(',');
     }*/
     //Responsys API changed for loop and commenting below line
     //if(!CommonUtility.isEmpty(prodSMS.EmailToReceipients__c)){
     for (String receipient: recNames) {
      String email = String.valueOf(getFieldValue(sObj, receipient));
      if (email != null) {
       smsInputMap = new Map < String, Object > ();
       smsInputMap.put('sendTo', email);
       if (!SMSSentRecordPresent) {
        System.debug('not sent');
        smsInputMap.put('receipient', receipient);
        smsInputMap.put('objName', objName);
        smsInputMap.put('sObj', sObj);
        smsInputMap.put('name', custSetName);
        sms = createORUpdateSMSSentRecord(smsInputMap, 'email');
        if (!CommonUtility.isEmpty(sms))
         allsms.add(sms);
       } else {
        System.debug('record is present with same custom setting name');
        receipientType = getReciepientTypeByAPI(receipient);
        if (alreadySentSMS.containsKey(receipientType) && !commonUtility.isEmpty(alreadySentSMS.get(receipientType))) {
         sms = alreadySentSMS.get(receipientType);
         if (sms.Email_sent__c == false) {
          System.debug('present but email not sent');
          smsInputMap.put('sms', sms);
          sms = createORUpdateSMSSentRecord(smsInputMap, 'email');
          if (!CommonUtility.isEmpty(sms))
           allsms.add(sms);

         }
        } else {
         smsInputMap.put('receipient', receipient);
         smsInputMap.put('objName', objName);
         smsInputMap.put('sObj', sObj);
         smsInputMap.put('name', custSetName);
         sms = createORUpdateSMSSentRecord(smsInputMap, 'email');
         if (!CommonUtility.isEmpty(sms))
          allsms.add(sms);
        }
       }
      }
     }
     //}
    }
   }
  }
  return allsms;
 }

 public static String getReciepientTypeByAPI(String receipient) {
  for (String key: receipientsMap.keySet()) {
   if (receipient.containsIgnoreCase(key)) {
    String receipientName = receipientsMap.get(key);
    if (receipientName != null) {
     system.debug('key-->' + key);
     system.debug('receipientName-->' + receipientName);
     return receipientName;
    }

   }
  }
  return '';
 }

 public static SMS_Sent__c createORUpdateSMSSentRecord(Map < String, Object > inputMap, String emailOrSMS) {
  System.debug('input map: ' + inputMap + ':' + emailOrSMS);
  SMS_sent__c sms;
  sobject sobj;
  String sendTo, receipient, message, smsType, objName, name;
  String event; //Responsys APi Integration 
  String dynParaJsn, Product; //Responsys Dynamic Parameters Bug 15653 
  Boolean isPriority; //Responsys Dynamic Parameters Bug 15653 
  if (!CommonUtility.isEmpty(inputMap)) {
   if (inputMap.containsKey('sms') && !commonUtility.isEmpty(inputMap.get('sms')))
    sms = (SMS_Sent__c) inputMap.get('sms');
   if (inputMap.containsKey('sendTo') && !commonUtility.isEmpty(inputMap.get('sendTo')))
    sendTo = (String) inputMap.get('sendTo');
   if (inputMap.containsKey('receipient') && !commonUtility.isEmpty(inputMap.get('receipient')))
    receipient = (String) inputMap.get('receipient');
   if (inputMap.containsKey('message') && !commonUtility.isEmpty(inputMap.get('message')))
    message = (String) inputMap.get('message');
   if (inputMap.containsKey('smsType') && !commonUtility.isEmpty(inputMap.get('smsType')))
    smsType = (String) inputMap.get('smsType');
   if (inputMap.containsKey('objName') && !commonUtility.isEmpty(inputMap.get('objName')))
    objName = (String) inputMap.get('objName');
   if (inputMap.containsKey('sObj') && !commonUtility.isEmpty(inputMap.get('sObj')))
    sObj = (sObject) inputMap.get('sObj');
   if (inputMap.containsKey('name') && !commonUtility.isEmpty(inputMap.get('name')))
    name = (String) inputMap.get('name');
   /*Responsys API s*/
   if (inputMap.containsKey('event') && !commonUtility.isEmpty(inputMap.get('event')))
    event = (String) inputMap.get('event');
   /*Responsys API e*/
   /*Responsys Dynamic Parameters Bug 15653 s*/
   if (inputMap.containsKey('dynParaJsn') && !commonUtility.isEmpty(inputMap.get('dynParaJsn')))
    dynParaJsn = (String) inputMap.get('dynParaJsn');
   if (inputMap.containsKey('isPriority') && !commonUtility.isEmpty(inputMap.get('isPriority')))
    isPriority = (Boolean) inputMap.get('isPriority');
   if (inputMap.containsKey('Product') && !commonUtility.isEmpty(inputMap.get('Product')))
    Product = (String) inputMap.get('Product');
   /*Responsys Dynamic Parameters Bug 15653 e*/
   // Start of changes by Niraj
   /*String parentRelationshipName;  
   if(inputMap.containsKey('Parent relationship name') && !commonUtility.isEmpty(inputMap.get('Parent relationship name'))){
       parentRelationshipName = String.valueOf(inputMap.get('Parent relationship name'));
   }*/
   // End of changes by Niraj    
      try{
          System.debug('Sobj Emailer --> ' + sObj.Id + ' ' + objName);
      }
      catch(exception e){
          System.debug('exception occured at --> ' + e.getMessage() + ' ' + e.getLineNumber() + ' ' + e.getStackTraceString());
      }
   if (CommonUtility.isEmpty(sms) && !CommonUtility.isEmpty(name) && !CommonUtility.isEmpty(objName) &&
    !CommonUtility.isEmpty(sobj) && !CommonUtility.isEmpty(receipient)) {

    sms = new SMS_Sent__c();
    sms.Name = name;
    if (objName.equalsIgnoreCase('Opportunity')) {
     // Start of changes by Niraj  
     if (parentRelationshipName != null) {
      sms.LoanApplication__c = String.valueOf(getFieldValue(sObj, parentRelationshipName));
     } else {
      sms.LoanApplication__c = sObj.Id;
     }
     // End of changes by Niraj    
    } else if (objName.equalsIgnoreCase('Product_Offerings__c')) {
     // Start of changes by Niraj  
     if (parentRelationshipName != null) {
      sms.Product_Offerings__c = String.valueOf(getFieldValue(sObj, parentRelationshipName));
     } else {
      sms.Product_Offerings__c = sObj.Id;
     }
     // End of changes by Niraj
    } else if (objName.equalsIgnoreCase('Salaried__c')) {
     sms.Salaried__c = sObj.Id;
     sms.LoanApplication__c = ((Salaried__c) sObj).Loan_Application__c;
    } else if (objName.equalsIgnoreCase('Call_Memo__c')) {
     // Start of changes for SMS trigger to call center leads - 19985 
     if (parentRelationshipName != null) {
      sms.Customer_Interaction__c = String.valueOf(getFieldValue(sObj, parentRelationshipName));
     } else {
      sms.Customer_Interaction__c = sObj.Id;
     }
     // End of changes for SMS trigger to call center leads - 19985
    }
    /* BFL homes phase 2 added by priya start */
    else if (objName.equalsIgnoreCase('Property_Details__c')) {
     sms.Property_Details__c = sObj.Id;
    } /* BFL homes phase 2 added by priya end */
    else if (objName.equalsIgnoreCase('Applicant__c')) {
     sms.Applicant__c = sObj.Id;
    }
    System.debug('receipient:' + receipient);
    sms.SMS_Receiver__c = getReciepientTypeByAPI(receipient);
    System.debug('sms.SMS_Receiver__c:' + sms.SMS_Receiver__c);
   }

   if (emailOrSMS.equalsIgnoreCase('sms')) {
    if (!CommonUtility.isEmpty(message) || !CommonUtility.isEmpty(dynParaJsn)) {
     // Start of changes by Niraj
     /*if(sendTo != null && message != null) {
        smsTobeSendMap.put(sendTo,message);    
     }*/
     if (message != null) {
      if (message.length() > 255) {
       sms.SMS_Text_Sent__c = message.substring(0, 255).trim();
       sms.Additional_SMS_Text_Sent__c = message.substring(255, message.length()).trim();
      } else {
       sms.SMS_Text_Sent__c = message.trim();
      }
     } else if (dynParaJsn != null) {
      sms.SMS_Parameters__c = dynParaJsn;
     }
    }
    // End of changes by Niraj
    if (isPriority != null)
     sms.isPriority__c = isPriority; /*Responsys Dynamic Parameters Bug 15653 e*/

    sms.SMS_Type__c = smsType;

    //Rohit added for 19133 start
    if (sendTo == '0') {
     sendTo = '0000000000';
    }
    //Rohit added for 19133 stop

    sms.SMS_Sent_Number__c = sendTo;


    Datetime currtime = system.now();
    Integer hour = currtime.hour();
    system.debug('hour : ' + hour);
    system.debug('dynParaJsn : ' + dynParaJsn);
    system.debug('message : ' + message);

    if (Product != null && setProdRes.contains(Product) && respObjFlag && !oldFlowFlag) {
     if (isPriority && dynParaJsn != null) {
      sms.Event__c = event; //Responsys API Integration
      sms.Status__c = 'Sent';
      sms.SMS_Sent_Time__c = system.now();
      sms.SMS_Sent__c = true;
     } else if (dynParaJsn != null) {
      sms.Event__c = event; //Responsys API Integration
      sms.Status__c = 'Pending';
      sms.SMS_Sent_Time__c = system.now();
     } else if (message != null) {
      system.debug('inside valuefirst');
      sms.Status__c = 'Sent';
      sms.SMS_Sent_Time__c = system.now();
      sms.SMS_Sent__c = true;
     }
     /*
                   else{
                       system.debug('inside resp');
                       sms.Event__c = event; //Responsys API Integration
                       sms.Status__c = 'Pending'; 
                       
                   }*/
    } else {
     system.debug('inside valuefirst1');
     sms.SMS_Sent_Time__c = system.now();
     sms.SMS_Sent__c = true;
     if (hour > 9 && hour < 21) {
      system.debug('SMS sent....');
      sms.Status__c = 'Sent';
     } else {
      sms.Status__c = 'Pending';
     }

    }

   } else if (emailOrSMS.equalsIgnoreCase('email')) {
    sms.Email_sent_at__c = sendTo;
    sms.Email_sent__c = true;
    sms.Email_sent_time__c = system.now();
   } else
    return null;
  }
  return sms;
 }

 //code added by Harsit -- start
 global class CommunicationWrapper {
  @InvocableVariable(required = true)
  public String objId;
  @InvocableVariable(required = true)
  public String custSetting;
  @InvocableVariable(required = true)
  public String emailOrSmS; //use 'email' (for only email), 'sms' (for only sms) and 'both'( for both) as a value for the same variable in process builder
  @InvocableVariable
  public String onlineFlow;
  //Bug 23563 - February 2019 - Automated NI NC Communication start
  @InvocableVariable
  public String telecalldisposStatus;
  @InvocableVariable
  public Boolean ISChangedtelecall;
  @InvocableVariable
  public String filedDisposStatus1;
  @InvocableVariable
  public Boolean ISChangedfiled1;
  @InvocableVariable
  public String offerProduct;
  //Bug 23563 - February 2019 - Automated NI NC Communication end
 }
 //code added by Harsit ----- end
 /*Responsys Dynamic Parameters Bug 15653 s*/
 public static String generateDynamicParam(sObject sObj, String params) {
  String objName = sObj.getSObjectType().getDescribe().getName();
  Map < String, Object > jsonField = new Map < String, Object > ();
  Map < String, String > dynPar = new Map < String, String > ();
  List < String > paramList = new List < String > ();
  if (params != null)
   paramList = params.split(',');
  if (!CommonUtility.isEmpty(jsonBodyRes) && jsonBodyRes.containsKey(objName) && !CommonUtility.isEmpty(jsonBodyRes.get(objName)))
   jsonField = (Map < String, Object > ) jsonBodyRes.get(objName);
  for (String par: paramList) {
   /*20939 s*/
   if (par.contains('bitlyLink')) {
    //Map<String,Object> bitlyMap = (Map<String,Object>)JSON.deserializeuntyped(par);
    String vfPage = par.split(':')[1];
    String idParam = String.valueof(sObj.get(String.valueof(jsonField.get('P_BITLY'))));
    system.debug('bitly link is' + Label.BflsiteuserURL + '/' + vfPage + '?id=' + idParam);
    String encryptId = CommonUtility.encryptURLParam(idParam);
    String bitlyLink = CommonUtility.googleShortenUrl(Label.BflsiteuserURL + '/' + vfPage + '?id=' + encryptId);
    dynPar.put('P_BITLY', bitlyLink);
   } else if (par.contains('P_OTP')) {
    String otp = '';
    otp = GeneralUtilities.generateOTPPwd(5);
    dynPar.put('P_OTP', otp);
   }
   /*20939 e*/
   else {
    for (String key: jsonField.keySet()) {
     if (String.valueof(jsonField.get(key)).contains(',')) {
      List < String > keys = new List < String > ();
      keys = String.valueof(jsonField.get(key)).split(',');
      for (String key1: keys) {
       if (par == key1) {
        String fieldVal = String.valueof(getFieldValue(sObj, key1));
        if (fieldVal != null) {
         String fieldTypeName = String.valueOf(getFieldType(sObj, key1));
         if (fieldTypeName.equalsIgnoreCase('DateTime')) {
          DateTime dt = DateTime.valueofGmt(fieldVal);
          fieldVal = dt.format('dd/MM/yyyy h:mm a', UserInfo.getTimeZone().toString());
         } else
         if (fieldTypeName.equalsIgnoreCase('Date')) { // Added Date condition for SMS N Functionality - 17923
          DateTime dt = DateTime.valueofGmt(fieldVal);
          fieldVal = dt.format('dd/MM/yyyy', UserInfo.getTimeZone().toString());
         }
         dynPar.put(key, fieldVal);
        }
       }
      }
     } else {
      if (par == String.valueOf(jsonField.get(key))) {
       String fieldVal = String.valueof(getFieldValue(sObj, (String) jsonField.get(key)));
       if (fieldVal != null) {
        String fieldTypeName = String.valueOf(getFieldType(sObj, (String) jsonField.get(key)));
        if (fieldTypeName.equalsIgnoreCase('DateTime')) {
         DateTime dt = DateTime.valueofGmt(fieldVal);
         fieldVal = dt.format('dd/MM/yyyy h:mm a', UserInfo.getTimeZone().toString());
        } else
        if (fieldTypeName.equalsIgnoreCase('Date')) { // Added Date condition for SMS N Functionality - 17923
         DateTime dt = DateTime.valueofGmt(fieldVal);
         fieldVal = dt.format('dd/MM/yyyy', UserInfo.getTimeZone().toString());
        }
        dynPar.put(key, fieldVal);
       }
      }
     }
    }
   }
  }
  //Bug 23563 - February 2019 - Automated NI NC Communication start
  /*if (dynPar.containsKey('P_MOBILE')) {
   dynPar.put('P_MOBILE', String.valueOf(dynPar.get('P_MOBILE')).replaceAll('[^0-9]', ''));
  }*/
  //Bug 23563 - February 2019 - Automated NI NC Communication end
  return JSON.serialize(dynPar);
 }
 public static void sendSMSPO(List < sObject > sObjList, String custSet, Boolean checkFlag) {
  checkResp = checkFlag;
  sendSMS(sObjList, custSet);
  checkResp = false;
 }
 public static void sendSMSPO(List < sObject > sObjList, List < sObject > sObjRelList, String custSet, Boolean checkFlag) {
  try {
   system.debug('inside rel send sms' + custSet);
   if (custSet.contains('Referred Success-Referee')) {
    SPLReferredFlag = true;
   }
   relIdSet = new Set < Id > ();
   if (sObjList != null && sObjList.size() > 0 && sObjRelList != null && sObjRelList.size() > 0) {
    checkResp = checkFlag;
    relatedObjName = sObjRelList[0].getSObjectType().getDescribe().getName();
    system.debug('relatedobj' + relatedObjName);
    sObjRelatedList = sObjRelList;
    for (sObject sObj: sObjRelatedList) {
     relIdSet.add(sObj.id);
    }
    system.debug('relIdSet' + relIdSet);
    relWhere = 'Where Id IN: relIdSet';
    sendSMS(sObjList, custSet);
   }
  } catch (Exception ex) {
   System.debug('exception:' + ex.getMessage());
  }
  relWhere = null;
  relatedObjName = null;
  childRelationshipName = null;
  parentRelationshipName = null;
  checkResp = false;
 }
 /*Responsys Dynamic Parameters Bug 15653 e*/
}