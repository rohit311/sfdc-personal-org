public without sharing class SFDCMobilePOController {
 public static Boolean allowFileUpload = false;

 @AuraEnabled
 //Bug 16111 - Change Signature of this method
 public static String generateAadharOTPforMobility(String adharNmbr, String Product, String HashCode, String parentObj, String parentId) { //HashCode,Product added for Bug - 15230 
  system.debug('adharNmbr' + adharNmbr + ' Product' + Product + ' HashCode' + HashCode + ' parentObj' + parentId + ' parentId' + parentId);
  return SOLDynamicController.generateAadharOTPforMobility(adharNmbr, Product, HashCode, parentObj, parentId); //HashCode,Product added for Bug - 15230 
 }

 @AuraEnabled
 public static String generateAadharOTPforMobility(String adharNmbr) {
  return SOLDynamicController.generateAadharOTPforMobility(adharNmbr);
 }

 @AuraEnabled
 public static Product_Offerings__c getProductOfferings(String poId) {
  return SFDCMobilePOUtility.getProductOffering(poId);
 }

 //Nikhil : Changed logic from Attachments to Files
 @AuraEnabled
 /*17556 s added isdeleteinsert*/
 public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, String uploadType, String longitude, String latitude, Boolean isDeleteInsert) {
  if (String.isBlank(fileId)) {
   /*17556 s added isdeleteinsert*/
   fileId = saveTheFile(parentId, fileName, base64Data, contentType, uploadType, longitude, latitude, isDeleteInsert);
  } else {
   appendToFile(fileId, base64Data);
  }
  return Id.valueOf(fileId);
 }

 private static void appendToFile(Id fileId, String base64Data) {
  base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
  //Nikhil : Changed logic from Attachments to Files
  /*Attachment attchObj = [SELECT Id, Body FROM Attachment WHERE Id =: fileId];
  attchObj.Body = EncodingUtil.base64Decode(EncodingUtil.base64Encode(attchObj.Body) + base64Data); 
  update attchObj;*/

  ContentVersion cv = [SELECT ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId =: fileId];
  cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(cv.VersionData) + base64Data);
  update cv;

 }

 //Nikhil : Changed logic from Attachments to Files
 /*17556 s added isdeleteinsert*/
 public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType, String uploadType, String longitude, String latitude, Boolean isDeleteInsert) {
  base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
  //Nikhil : Changed logic from Attachments to Files
  /*Attachment attchObj = new Attachment(
      parentId = parentId,
      Name = fileName,
      ContentType = contentType,
      Body = EncodingUtil.base64Decode(base64Data)
  );
  insert attchObj;
  return attchObj.Id;*/
  /*17556 s*/
    if(filename != null && (filename.toUpperCase().contains('PHOTOGRAPH|') || filename.toUpperCase().contains('CUSTOMER PHOTO') )){
   if (String.valueOf(parentId.getSObjectType()) == 'Opportunity') {
    List < Applicant__c > appList = [SELECT Applicant_Image__c, ID from Applicant__c where Loan_Application__c =: parentId AND Applicant_Type__c = 'Primary'];
    String imageString = '<!DOCTYPE html><html><body>' +
     ' <body><img src=' + 'data:image/jpeg;base64,' + base64Data + '/>' +
     '</body></html>';
    if (appList != null && appList.size() > 0) {
     appList[0].Applicant_Image__c = imageString;
     update appList[0];
    }
   }
  }
  /*17556 e*/
  allowFileUpload = true;
  /*17556 s*/
  if (isDeleteInsert) {
   System.debug('file name is ' + fileName);
   List < String > FileNameSplit = fileName.split('\\.');
   system.debug(FileNameSplit);
   List < Attachment > attList = [SELECT ID FROM Attachment WHERE parentId =: parentId AND name LIKE: ('%' + FileNameSplit[0] + '%')];
   system.debug('size ' + attList.size());
   if (!CommonUtility.isEmpty(attList)) {
    delete attList;
   }
   List < ContentDocumentLink > conDocList = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
    ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
    FROM ContentDocumentLink
    WHERE LinkedEntityId =: parentId AND ContentDocument.Title LIKE: ('%' + fileNameSplit[0] + '%')
   ];

   system.debug('size ' + conDocList.size());
   if (!CommonUtility.isEmpty(conDocList)) delete conDocList;

   system.debug('delete complete');
  }
  /*17556 e*/
  ContentVersion cv = new ContentVersion();
  cv.versionData = EncodingUtil.base64Decode(base64Data);
  cv.title = fileName;
     /*Digital Sampling*/
        System.debug('fileName -->'+fileName);
        if(contentType == 'Digital Sampling'){
            List<ContentVersion> cvLst = new List<ContentVersion>();
            List<ContentDocument> doclist;
            List<String> doctypelist = fileName.split('\\.');
            System.debug('doctypelist -->'+doctypelist);
            cv.Source_of_Document__c = contentType;
            if(doctypelist.size() > 0)
            {
                List<String> tempLst;
                if(doctypelist[0] != null)
                    tempLst = doctypelist[0].split(';');
                System.debug('tempLst -->'+tempLst);
                if(tempLst != null && tempLst.size() > 0){
                    cv.Document_Type__c = tempLst[0].trim();
                    cv.Document_Name__c = tempLst[1].trim();
                    cv.IsMajorVersion  = false;
                    cv.title = tempLst[1].trim() +' '+ Datetime.now().format('dd-MM-yyyy\' \'hh:mm:ss\' \'') + '.pdf';
                                        
                }
            }
            
        }
        /*Digital Sampling*/
  cv.pathOnClient = fileName;
  cv.origin = 'H';
  if (longitude != null && latitude != null) { // Bug Id : 22425
   cv.ImageLoc__Latitude__s = Decimal.valueOf(String.valueOf(latitude));
   cv.ImageLoc__Longitude__s = Decimal.valueOf(String.valueOf(longitude));
  }
  //Nikhil : Changed logic from Attachments to Files
  if (!CommonUtility.isEmpty(uploadType) && ('feed').equalsIgnoreCase(uploadType) && longitude != null && latitude != null) {
   cv.ImageLoc__Latitude__s = Decimal.valueOf(String.valueOf(latitude));
   cv.ImageLoc__Longitude__s = Decimal.valueOf(String.valueOf(longitude));

  }
  insert cv;

  /* bug id 13526 Start*/
  if (String.valueOf(parentId.getSObjectType()) == 'Verification__c' && !CommonUtility.isEmpty(cv.ImageLoc__Latitude__s) && !CommonUtility.isEmpty(cv.ImageLoc__Longitude__s)) {
   List < Verification__c > verificationObjList = [SELECT id, Image_Latitude_Longitude_Details__c, Geo_Tagging__c FROM Verification__c WHERE Id =: parentId];
   if (verificationObjList != null && verificationObjList.size() > 0 && verificationObjList[0].Geo_Tagging__c == true) {
    if (verificationObjList[0].Image_Latitude_Longitude_Details__c != null)
     verificationObjList[0].Image_Latitude_Longitude_Details__c = verificationObjList[0].Image_Latitude_Longitude_Details__c + '   \nLat - ' + String.valueOf(cv.ImageLoc__Latitude__s) + '     Long - ' + String.valueOf(cv.ImageLoc__Longitude__s);
    else
     verificationObjList[0].Image_Latitude_Longitude_Details__c = 'Lat - ' + String.valueOf(cv.ImageLoc__Latitude__s) + '   Long - ' + String.valueOf(cv.ImageLoc__Longitude__s);

    update verificationObjList[0];
   }
  }
  /* bug id 13526  End*/

  Id cdId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;

  ContentDocumentLink cdLnk = new ContentDocumentLink();
  cdLnk.ContentDocumentId = cdId;
  cdLnk.LinkedEntityId = parentId;
  cdLnk.ShareType = 'I';
  cdLnk.Visibility = 'AllUsers';
  insert cdLnk;

  //system.debug('sdasda->'+String.isBlank(longitude));
  //Nikhil : Changed logic from Attachments to Files
  if (!CommonUtility.isEmpty(uploadType) && ('feed').equalsIgnoreCase(uploadType) &&
   longitude != null && latitude != null) {
   savePremisePictureFeed(parentId, cv.Id, String.valueOf(longitude), String.valueOf(latitude));
  }

  return cdId;
 }
 //digital sampling start
    @AuraEnabled
    public static String CheckDuplicateDoc(List<ID> appIDs , Id parentId,String DocType,String DocName){
        String result = '';
        List<ContentVersion> cvLst = new List<ContentVersion>();
        system.debug('idlist -->'+appIDs);
        if(!CommonUtility.isEmpty(parentId)){
            List<Id> cdLst = new List<Id>();
            for(ContentDocumentLink cdLnk : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :parentId])
                cdLst.add(cdLnk.ContentDocumentId);
            cvLst = [SELECT ContentDocumentId, Document_no__c,ContentSize,Document_Name__c,Document_Type__c,Source_of_Document__c,Vendor_Remarks__c FROM ContentVersion
                     WHERE ContentDocumentId IN :(cdLst) AND Document_Type__c =:DocType AND Document_Name__c=:DocName AND Source_of_Document__c='Digital Sampling'];
        }
        string totalsize = calculateTotalSize(appIDs);
        system.debug('cvLst-->'+cvLst.size());
        Boolean flag = false;
        String vendorRemark = '';
        String DocIdPresent = '';
        if(cvlst.size() > 0){
            for(ContentVersion cv : cvlst)
            {  
                flag = true;
                System.debug('vendor remark -->'+cv.Vendor_Remarks__c);
                if(cv.Vendor_Remarks__c != null && cv.Vendor_Remarks__c != '')
                {
                    vendorRemark = 'vendor_remark_exists';
                    
                }
                if(cv.Document_no__c != null)
                {
                    DocIdPresent = 'DocIdPresent';
                }
            }
        }
        else{
            flag= false;
        }
        result = String.valueOf(flag)+';'+vendorRemark+';'+DocIdPresent+';'+totalsize;
        return result;
    }
    
    @AuraEnabled
    public static string calculateTotalSize(List<ID> appIDs)
    {
        List<ContentVersion> cvLst = new List<ContentVersion>();
        if(!CommonUtility.isEmpty(appIDs)){
            List<Id> cdLst = new List<Id>();
            for(ContentDocumentLink cdLnk : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: appIDs])
                cdLst.add(cdLnk.ContentDocumentId);
            cvLst = [SELECT ContentDocumentId, Title, CreatedDate,ContentSize,Document_Name__c,Document_Type__c,Source_of_Document__c FROM ContentVersion
                     WHERE ContentDocumentId IN :(cdLst) AND Source_of_Document__c='Digital Sampling'];
        }
        System.debug('cvlist in size -->'+cvlst.size());
        Decimal size = 0.0;
        if(cvLst.size() > 0){
            for(ContentVersion cv :cvLst){
                size = size + cv.ContentSize;
            }
            
        }
        System.debug('size-->'+size);
        
        return String.valueOf(size);
    }
    /*Digital Sampling End*/
 //Nikhil : Changed logic from Attachments to Files
 public static void savePremisePictureFeed(Id parentId, Id contentVersionId, String longitude, String latitude) {
  system.debug('longitude:::' + longitude + 'latitude:::' + latitude);
  //system.debug(parentId+''+fileName+''+data+''+contentType+''+longitude+''+latitude);    
  Id recID;
  //create and insert post
  try {
   FeedItem post = new FeedItem();
   post.ParentId = parentId;
   //post.Title = fileName;
   post.IsRichText = TRUE;
   post.Type = 'ContentPost';
   post.Body = '\n\nLongitude = ' + longitude + '\nLatitude = ' + latitude;
   post.Body += '\n\nLocation: http://maps.google.com/maps?q=' + latitude + ',' + longitude;
   insert post;
   //recID =post.id;


   //Nikhil : Changed logic from Attachments to Files
   /*List<Attachment> attchLst = [SELECT Id,Body,ContentType From Attachment where parentId = :parentId AND Name ='Premise_Picture.JPG'];
            
   Blob image;
   if(!CommonUtility.isEmpty(attchLst )){
       image = attchLst[0].Body;
       }  
            
   //create the Content version to store the Image
   ContentVersion contentVersion = new ContentVersion();
   contentVersion.PathOnClient = fileName;
   contentVersion.VersionData = image;//EncodingUtil.base64Decode(Bdata);
   contentVersion.Origin = 'H';
   insert contentVersion;
            
   system.debug('contentVersion inserted.'+contentVersion.Id);*/

   //create and associate a content attachment to the post
   FeedAttachment feedAttachment = new FeedAttachment();
   feedAttachment.FeedEntityId = post.id;
   feedAttachment.RecordId = contentVersionId;
   //feedAttachment.Title = fileName;
   feedAttachment.Type = 'Content';
   insert feedAttachment;

   system.debug('---post---' + post.id + ':::' + post.Body);
   system.debug('feedAttachment-->' + feedAttachment.Id);

  } catch (Exception e) {
   system.debug('Exception-->' + e.getMessage());
  }
 }

 @AuraEnabled
 public static List < Credit_Officer_Limit__c > fetchCreditDetails(String poId) {
  return SFDCMobilePOUtility.getCreditDetails(poId);
 }

 //16621
 //Bug 16111 - Change Signature of this method
 @AuraEnabled
 public static eKYC__c getKYCDetails(String aadharCardNumber, String otpCode, String HashCode, String parentObj, String parentId) { //Hashcode added for Bug - 15230
  return mobility_pro.geteKYCDetails(aadharCardNumber, otpCode, HashCode, parentObj, parentId); //Hashcode added for Bug - 15230
 }


 @AuraEnabled
 public static String saveKYC(String kycId, String leadId, String poId) {
  eKYC__c ekyc = [Select Id, Lead__c, Product_Offerings__c FROM eKYC__c where Id =: kycId];
  ekyc.Lead__c = leadId;
  ekyc.Product_Offerings__c = poId;
  update ekyc;
  return JSON.serialize(ekyc);

 }

 @AuraEnabled
 //Bug 16111 - Change Signature of this method

 public static Lead createLead(Lead lead, String ekyc) { // 
  if (ekyc != null && ekyc != '') {
   return SFDCMobilePOUtility.createLead(lead, (eKYC__c) JSON.deserialize(ekyc, eKYC__c.class));
  } else {
   return SFDCMobilePOUtility.createLead(lead, null);
  }

 }

 @AuraEnabled
 public static Lead createLead(Lead lead) {
  return SFDCMobilePOUtility.createLead(lead);
 }

 @AuraEnabled
 public static Product_Offerings__c createPO(Product_Offerings__c po) {
  return SFDCMobilePOUtility.createProductOffering(po);
 }

 @AuraEnabled
 public static List < String > getDisposition(String fldDisposition, String controllingField, String dependentField) {
  List < String > options = new List < String > ();
  Map < String, List < String >> dependentData = SFDCUtil.GetDependentOptions('Product_Offerings__c', controllingField, dependentField);
  if (dependentData.containsKey(fldDisposition)) {
   options = dependentData.get(fldDisposition);
  }
  return options;
 }

 @AuraEnabled
 public static String getDescribeObject(String objName) {
  return JSON.serializePretty(Schema.describeSObjects(new List < String > {
   objName
  }), true);
 }

 @AuraEnabled
 public static String saveDisposition(String PO) {
  return mobility_pro.UpdateData(PO);
 }

 @AuraEnabled
 public static List < String > getBranchDetails() {
  return NULL;
 }

 @AuraEnabled
 public static List < String > getSourcingChannelDetails() {
  return NULL;
 }

 @AuraEnabled
 public static List < Integer > getExperienceDetails() {
  List < Integer > experience = New List < Integer > ();
  Integer startingRange = Integer.ValueOf(Label.Experience_Range_Start);
  Integer maxRange = Integer.ValueOf(Label.Experience_Range_End);
  for (Integer i = startingRange; i <= maxRange; i++) {
   experience.add(i);
  }
  return experience;
 }

 @AuraEnabled
 public static List < ContentVersion > getAttachments(Id poId) {
  //Nikhil : Changed logic from Attachments to Files
  /*List<Attachment> attachmentList = new List<Attachment>();
  attachmentList = [SELECT Id, Name, ParentId, ContentType, CreatedDate FROM Attachment WHERE ParentId =: poId ORDER BY CreatedDate DESC];
  return attachmentList;*/
  List < ContentVersion > cvLst = new List < ContentVersion > ();
  if (!CommonUtility.isEmpty(poId)) {
   List < Id > cdLst = new List < Id > ();
   for (ContentDocumentLink cdLnk: [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: poId])
    cdLst.add(cdLnk.ContentDocumentId);
   cvLst = [SELECT ContentDocumentId, Title, CreatedDate FROM ContentVersion WHERE ContentDocumentId IN: (cdLst) LIMIT 25];
  }
  system.debug('cvLst-->' + cvLst);
  return cvLst;
 }

 @AuraEnabled
 public static void removeAttachment(Id attachId) {
  //Nikhil : Changed logic from Attachments to Files
  /*system.debug('@@@@@@@@');
  Attachment poAttachment = [SELECT Id, Name FROM Attachment WHERE Id =: attachId];
  delete poAttachment;*/
  // ControlRecursiveCallofTrigger_Util.setAllowFileDeleteTrue(); // to be uncommented after dependent enhancement's movement
  delete(new ContentDocument(Id = attachId));
 }
    //Bug 24237  added ASM_Employee_ID__c PSF_Employee_ID__c in soql
 @AuraEnabled
 public static List < Sourcing_Channel__c > fetchSource(String searchKeyWord) {
        return [SELECT Name, FinnOne_Code__c,ASM_Employee_ID__c,PSF_Employee_ID__c,Branch__r.Name,Reporting_Manager__r.Name FROM Sourcing_Channel__c WHERE Active__c = True AND Name LIKE: ('%' + searchKeyWord + '%')];
 }
     //Bug 24237 S
     @AuraEnabled
     public static User getCurrentUserData(String searchKeyWord) {
      return [SELECT id, Employee_ID__c FROM User WHERE id =: UserInfo.getUserId()];
     }
     //Bug 24237 E
 @AuraEnabled
 public static List < Branch_Master__c > fetchBranch(String searchKeyWord) {
  return [SELECT Name FROM Branch_Master__c WHERE Active_Inactive__c = True AND Name LIKE: (searchKeyWord + '%')];
 }

 @AuraEnabled
 public static List < Sector_Industry__c > fetchCollege(String searchKeyWord) {
  return [SELECT Name FROM Sector_Industry__c WHERE Name LIKE: (searchKeyWord + '%')];
 }

 @AuraEnabled
 public static List < String > getResidenceCity() {
  return SFDCMobilePOUtility.getPicklistValues('Lead', 'Resi_City__c');
 }

 @AuraEnabled
 public static List < String > getTypeofDegree() {
  return SFDCMobilePOUtility.getPicklistValues('Product_Offerings__c', 'Type_of_Degree__c');
 }

 // bugId:19080 S
 @AuraEnabled
 public static List < String > getDegreeOptions() {
  //return SFDCMobilePOUtility.getPicklistValues('Lead', 'Degree__c');
  //Changed below by Rohan for 18158 Bug ID: 19080
  return SFDCMobilePOUtility.getPicklistValues('Product_Offerings__c', 'Degree__c');

 }
 //BUGID 19377 S
 @AuraEnabled
 public static List < String > getDoctorDependentDegreeOptions() {
  List < String > lstDegreeVals = new List < String > ();
  if (!string.isBlank(Label.Prospect_Doctors_Degree_Values))
   lstDegreeVals = Label.Prospect_Doctors_Degree_Values.split(',');
  return lstDegreeVals;
 }
 // bugId:19080 E

 @AuraEnabled
 public static List < String > getResidentialType() {
  return SFDCMobilePOUtility.getPicklistValues('Lead', 'Residential_type__c');
 }

 @AuraEnabled
 public static List < String > getSpecialization() {
  return SFDCMobilePOUtility.getPicklistValues('Product_Offerings__c', 'Specialisation__c');
 }
 // Bug 14509 S
 @AuraEnabled
 public static List < String > getDegree() {
  return SFDCMobilePOUtility.getPicklistValues('Product_Offerings__c', 'Degree__c');
 }
 // bug 14509 E    
 @AuraEnabled
 public static List < String > getProfession() {
  return SFDCMobilePOUtility.getPicklistValues('Lead', 'Profession_Type__c');
 }

 @AuraEnabled
 public static List < String > gethighestDegreeTypeDetails() {
  return SFDCMobilePOUtility.getPicklistValues('Product_Offerings__c', 'TypeOfDegreeforCA_Architect__c');
 }


 @AuraEnabled
 public static List < String > getCollegeCityDetails() {
  return SFDCMobilePOUtility.getPicklistValues('Product_Offerings__c', 'Resi_Pick_City__c');
 }

 @AuraEnabled
 public static List < String > getPracticeType() {
  return SFDCMobilePOUtility.getPicklistValues('Product_Offerings__c', 'Practice_Type__c');
 }

 @AuraEnabled
 public static List < String > getFieldDisposition() {
  return SFDCMobilePOUtility.getPicklistValues('Product_Offerings__c', 'Field_Disposition_1__c');
 }

 //Bug 13114 S - Modify signature of createcibiltempmethod
 @AuraEnabled
 public static String createCibilTempRecord(Lead leadObj, Product_Offerings__c po, Boolean retrigger) {
  System.debug('Lead' + leadObj);
  System.debug('Product_Offerings__c' + po);
  return SFDCMobilePOUtility.createCibilTempRecord(leadObj, po, retrigger);
 }
 //Bug 13114 S - Modify signature of createcibiltempmethod


 @AuraEnabled
 public static String createDedupeRecord(Lead leadObj, Boolean retrigger) {
  return SFDCMobilePOUtility.createDedupeRecord(leadObj, retrigger);
 }

 // Start --> Added By Nihit Bug -19368
 @AuraEnabled
 public static String getConsent2() {
  StaticResource srObject = [select id, body from StaticResource Where Name = 'Ekyc_Integration'
   limit 1
  ];

  Map < String, object > ALLMap = (Map < String, object > ) JSON.deserializeUntyped(srObject.body.toString());
  String AadharConsent = (String) ALLMap.get('AadharConsent');
  return AadharConsent;

  /*StaticResource srObject = [select id,body from StaticResource Where Name = 'Ekyc_Integration'];
  String contents = srObject.body.toString(); 
        
  return contents;*/
 }
 // Stop --> Added By Nihit Bug -19368 
 // added for bug id 21851 start
 @AuraEnabled
 public static Boolean getHideAadhaarSection() {
  return Boolean.valueOf(CommonUtility.getAadhaarSectionStatus('Ekyc_Integration', 'hideAadhaarSection', ''));

 }
 //added for bug id 21851 stop

 @AuraEnabled
 public static String sendToSalesConvert(String leadId, String poId) {
  allowFileUpload = true; // Bug 15574 - Hemant Keni
  /* Mobility for SAL added by priya flow =pro*/
  Map < String, Object > params = new Map < String, Object > {
   'poId' => poId,
   'Sendtoname' => 'Sales',
   'flow' => 'pro'
  };
  return mobility_pro.sendtoSalesConvert(JSON.serialize(params));
 }

 @AuraEnabled
 public static String convertToLoanRemoteOne(String leadId, String poId) {
  allowFileUpload = true; // Bug 15574 - Hemant Keni
  /* Mobility for SAL added by priya flow =pro*/
  Map < String, Object > params = new Map < String, Object > {
   'PO_offerId' => poId,
   'Sendtoname' => 'Sales',
   'flow' => 'PRO',
   'leadId' => leadId,
   'isPOS' => 'true'
  };
  return SBS_ConvertToLoanApplication.convertToRemoteOne(JSON.serialize(params));
 }

 @AuraEnabled
 public static String convertToLoanRemoteTwo(String jsonStr) {

  return SBS_ConvertToLoanApplication.convertToRemoteTwo(jsonStr);
 }

 @AuraEnabled
 public static String convertToLoanFutureCalls(String jsonStr) {

  return SBS_ConvertToLoanApplication.futureCalls(jsonStr);
 }

 @AuraEnabled
 public static String submitApprover(String loanId, String poId, String approverId) {
  Map < String, Object > params = new Map < String, Object > {
   'ACMName' => approverId,
   'LoanId' => loanId,
   'poId' => poId
  };
  return mobility_pro.submitappr(JSON.serialize(params));
 }

 @AuraEnabled
 public static String getCIBILDataforDOL(String flow, String poId, String leadId, String cibilTempId) {
  Product_Offerings__c salariedObj;
  salariedObj = [SELECT UTM_Source__c, /*Bug 16621*/ Opportunity__r.Application_Number__c, Opportunity__r.StageName, Opportunity__r.Loan_Application_Number__c, Process_Master__c, Offer_PF__c, Offer_ROI__c, Product_Offering_Converted__c, /*Bug 16621*/ Mobile_Source__c, Total_work_experience__c, DOB__c, Lead__r.Customer_Type__c, Lead__r.Profession_Type__c,
   Lead__r.Cibil_Score__c, Lead__r.Employment_Type__c, Type_of_Degree__c, Data_Mart_Status__c, Offer_Amount__c, Tenor__c, Total_Employment_Vintage__c, Post_Graduate_Super_Specialist_Experienc__c, Monthly_EMI_Obligation__c, Resi_City__c, Specialisation__c, Products__c, Process_Type__c, Practice_Type__c, SBS_Branch__c, Full_Time_COP_Holder__c, Is_COP_Active__c, /*Bug 12946 S */ Monthly_Obligation__c, Monthly_Obligation_From_PO__c /* Bug 12946 E*/ , /*16207 Engineers proMobile start*/ Lead__r.SBS_Branch__r.Professional_Branch_Type__c, Sector_Industry__r.Name,
   Resi_Pick_City__c, TypeOfDegreeforCA_Architect__c, Lead__r.SBS_Branch__r.name, Net_Monthly_Salary_1__c,
   Net_Monthly_Salary_2__c, Requested_Tenor__c, Revised_Offer_ROI__c, Experience_in_Years__c, Existing_Customer_Segmentation__c,
   PLCS_Offer_Amount__c, Years_of_Experience__c, /*16207 Engineers proMobile end*/ /*Bug 13022 S*/ Product_Offering_Type1__c /*Bug 13022 E*/ /*Bug 14509 S*/ , Name, Degree__c, Lead__c /*Bug 14509 E*/ , CIBIL_Score__c, lead__r.Cibil_Temp__c, COP_Date__c from Product_Offerings__c where Id =: poId limit 1
  ];
  system.debug('poobject is' + salariedObj);
  return MobileUtility.getCIBILDataforDOL(Integer.valueOf(flow), poId, leadId, cibilTempId);
 }

 @AuraEnabled
 public static String checkForCibilScore(String cibilTempId) {
  return SFDCMobilePOUtility.checkForCibilScore(cibilTempId);
 }

 // Bug Id : 22896 --added for prod issue
 @AuraEnabled
 public static Boolean checkTatMaster(String leadId) {

  List < Lead > leadLst = [SELECT Id, Product__c, PAN__c, (SELECT Id FROM CIBILs__r),
   (SELECT Update_CIBIL_Error__c, CIBIL_Response__c, CIBIL_Score__c FROM Cibil_Temps__r) FROM Lead WHERE id =: leadId
  ];
  if (leadLst != null && leadLst.size() > 0) {
   List < CIBIL__c > cibilLst = leadLst[0].CIBILs__r;
   system.debug('Prod NSDl issue to create tat master record if cibilLst is available ' + cibilLst);
   List < Cibil_Temp__c > cibilTempLst = leadLst[0].Cibil_Temps__r;
   system.debug('Prod NSDl issue to create tat master record if cibilTempLst is available ' + cibilTempLst);
   if (!CommonUtility.isEmpty(cibilTempLst)) {
    Cibil_Temp__c cibilTempObj = cibilTempLst.get(0);
    if (!CommonUtility.isEmpty(cibilLst) && !CommonUtility.isEmpty(cibilTempObj.CIBIL_Score__c)) {
                List<TAT_Master__c> tatLst = [Select Id, PAN_Check_Status__c from TAT_Master__c where Lead__c = :leadId AND TypeP__c = :STRING_CONSTANTS.NSDL_IDENTIFIER];
     system.debug('Prod NSDl issue to create tat master record if tatLst is available ' + tatLst);
     if (tatLst == null || (tatLst != null && tatLst.size() == 0)) {
      system.debug('Calling NSDL through Apex for prod issue ');
      // saveTatMaster(JSON.stringify(callNSDLPanCheck(leadLst[0])));
      try {
       Tat_Master__c tatMasterRecord = callNSDLPanCheck(leadLst[0]);
       system.debug('tatMasterRecord ----->> ' + tatMasterRecord);

       upsert tatMasterRecord;
      } catch (DMLException dmlException) {
       System.debug('Error while upserting lead @ onloading lead through quick action--> ' + dmlException.getMessage());
      }
      system.debug('After Calling NSDL through Apex for prod issue ');
      system.debug('returning true and required lead record is ' + leadLst[0]);
      return true;
     }
    }
   }
  }
  system.debug('returning false ');
  return false;
 }

 // Bug 14509 - Add extra parameter as Product 
 @AuraEnabled
 public static List < Object > checkForExistingOffers(String firstName, String lastName, String mobile, String product) {
  Map < String, Object > params = new Map < String, Object > {
   'fields' => new Map < String,
   Object > {
    'Salaried__c' => new Map < String,
    Object > {
     'First_Name__c' => firstName,
     'Last_Name__c' => lastName,
     'Mobile__c' => mobile,
     'Product' => product
    }
   }
  };
  String jsonStr = mobility_pro.dedupeCheckforMobility(JSON.serialize(params));
  Map < String, Object > jsMap = (Map < String, Object > ) JSON.deserializeUntyped(jsonStr);
  if (!CommonUtility.isEmpty(jsMap) && (jsMap.containsKey('DedupeResult') && !CommonUtility.isEmpty(jsMap.get('DedupeResult')))) {
   return (List < Object > ) jsMap.get('DedupeResult');
  }
  return null;
 }
 // End of Bug 14509



 @AuraEnabled
 public static List < Object > POScheckForExistingOffers(String firstName, String lastName, String mobile, String product, String pan) {
  Map < String, Object > params = new Map < String, Object > {
   'fields' => new Map < String,
   Object > {
    'Salaried__c' => new Map < String,
    Object > {
     'First_Name__c' => firstName,
     'Last_Name__c' => lastName,
     'Mobile__c' => mobile,
     'Product' => product,
     'Pan__c' => pan
    }
   }
  };
  String jsonStr = mobility_pro.dedupeCheckforMobility(JSON.serialize(params));
  Map < String, Object > jsMap = (Map < String, Object > ) JSON.deserializeUntyped(jsonStr);
  if (!CommonUtility.isEmpty(jsMap) && (jsMap.containsKey('DedupeResult') && !CommonUtility.isEmpty(jsMap.get('DedupeResult')))) {
   return (List < Object > ) jsMap.get('DedupeResult');
  }
  return null;
 }



 @AuraEnabled
 public static String grabExistingOffer(String poId) {
  return SFDCMobilePOUtility.grabExistingOffer(poId);
 }

 @AuraEnabled
 public static String getCustomerDetails(String poId) {
  return SFDCMobilePOUtility.getCustomerDetails(poId);
 }

 @AuraEnabled
 public static Product_Offerings__c getPO(String poId) {
  List < Product_Offerings__c > poList = [SELECT ID, Products__c FROM Product_Offerings__c WHERE Id =: poId AND Lead__c != null];
  if (!CommonUtility.isEmpty(poList))
   return polist[0];
  return null;
 }

 @AuraEnabled
 public static Map < String, String > getAddressfromGeolocation(Double latitude, Double longitude) {
  return getCityName.getGeoAddress(latitude, longitude);
 }

 @AuraEnabled
 public static Boolean IsCPVDone(String poId) {
  Boolean IsCPV = false;
  List < Verification__c > verificationList = new List < Verification__c > ();
  verificationList = [select id from Verification__c where Product_Offerings__c =: poId];
  if (!CommonUtility.isEmpty(verificationList)) {
   IsCPV = true;
   system.debug('cpv done:' + IsCPV);
  }
  return IsCPV;

 }



 @AuraEnabled
 public static String deleteAllData(String poId) {
  system.debug(poId);
  return SBS_ConvertToLoanApplication.deleteAllData(poId);
 }
 //Bug-18339


 @AuraEnabled
 public static Product_Offerings__c getLANData(String poId) {
  return [SELECT Id, Opportunity__c, Opportunity__r.Loan_Application_Number__c FROM Product_Offerings__c WHERE Id =: poId];
 }


 @AuraEnabled
 public static String BRESTPCall(String poId) {
  return MobileUtility.BRESTPCall(poId);

 }



 @AuraEnabled
 public static List < SOL_Policy__c > DummyPolicyCreate(String poId, String reason) {
  system.debug(poId);
  List < SOL_Policy__c > spList = new List < SOL_Policy__c > ();

  spList = [SELECT Id FROM SOL_Policy__c WHERE Policy_Name__c = 'BRE Failure'];


  SOL_Policy__c sp = new SOL_Policy__c();
  if (!commonutility.isEmpty(spList))
   sp = spList[0];


  spList = new List < SOL_Policy__c > ();

  sp.Name = 'RULE_BRE_Failure';
  sp.Policy_Name__c = 'BRE Failure';
  sp.Reason__c = reason; //'Details could not be fetched';
  sp.Product_Offerings__c = poId;
  spList.add(sp);
  if (!commonUtility.isEmpty(spList)) {
   upsert spList;

  }
  List < Product_Offerings__c > poLst = [SELECT Id, Process_Master__c FROM Product_Offerings__c WHERE Id =: poId];
  if (!commonUtility.isEmpty(poLst)) {
   poLst[0].Process_Master__c = 'NON_STP_B';
  }
  update poLst;
  return spList;

 }
 @AuraEnabled
 public static Product_Offerings__c FetchSolPolicy(String poId) {
  //CC Code changes SME added where clause
  List < Product_Offerings__c > poLst = [SELECT Id, Process_Master__c, (select id, Name, Reason__c, Policy_Name__c from SOL_Policys__r Where Flow_Identifier__c !=: CreditCardController.CC_SME_IDENTIFIER AND Flow_Identifier__c !=: CreditCardController.CC_DOC_IDENTIFIER) FROM Product_Offerings__c WHERE Id =: poId];
  // List<SOL_Policy__c> SolPolRecords = [select id,Name,Reason__c,Policy_Name__c from SOL_Policy__c  WHERE Product_Offerings__c=: poId];
  if (!commonUtility.isEmpty(poLst))
   return poLst[0];
  else
   return new Product_Offerings__c();
 }

 @AuraEnabled
 public static Tat_Master__c callNSDLPanCheck(Lead lead) {
  System.debug('lead -->' + lead);
  Map < String, String > valueMap = new Map < String, String > {
   'leadId' => lead.Id,
   'product' => lead.Product__c,
   'panNumber' => lead.PAN__c
  };
  Tat_Master__c tatMasterRecord = nsdlPanCheck(valueMap);
  System.debug('tatMasterRecord -->' + tatMasterRecord);
  return tatMasterRecord;
 }

 /**
  * Method invoked from Submit details which will invoke NSDL API sync method
  */
 public static Tat_Master__c nsdlPanCheck(Map < String, String > nsdlDetails) {
  System.debug('nsdlPanCheck -->' + nsdlDetails.get('leadId') + nsdlDetails.get('product') + nsdlDetails.get('panNumber'));
  if (nsdlDetails != null && nsdlDetails.get('leadId') != null && nsdlDetails.get('product') != null && nsdlDetails.get('panNumber') != null) {
   Tat_Master__c tatMasterRecord = null;
   // fetch Tat Master record
   List < Tat_Master__c > tatMasterList = [
    Select Name, TypeP__c, Lead__c, PAN_Number__c, PAN_Source__c, PAN_Check_Status__c, Comment__c, Credit_Observation__c, Override_Flag__c, NSDL_Response__c, Name__c, Last_Modified_Date__c
    From TAT_Master__c Where Lead__c =: nsdlDetails.get('leadId') limit 1
   ];
   if ((tatMasterList == null || tatMasterList.size() == 0) && tatMasterRecord == null) {
    // Prepare Tat master record
    tatMasterRecord = new TAT_Master__c(
     Lead__c = nsdlDetails.get('leadId'),
     PAN_Number__c = nsdlDetails.get('panNumber'),
     PAN_Source__c = STRING_CONSTANTS.INPUT,
     TypeP__c = STRING_CONSTANTS.NSDL_IDENTIFIER
    );
   } else {
    tatMasterRecord = new Tat_Master__c();
    tatMasterRecord = tatMasterList[0];
    tatMasterRecord.PAN_Number__c = nsdlDetails.get('panNumber');
   }
   try {
    String response = calloutSync(nsdlDetails.get('panNumber'), nsdlDetails.get('product'));
    tatMasterRecord = parseResponse(response, tatMasterRecord);
    System.debug('tatMasterRecord --> ' + tatMasterRecord);
    return tatMasterRecord;
   } catch (Exception exceptionInstance) {
    System.debug('Error while --> ' + exceptionInstance.getMessage());
    return null;
   }
  }
  return null;
 }

 //@AuraEnabled public static void saveTatMaster(Tat_Master__c tatMasterRecord) {
 @AuraEnabled public static void saveTatMaster(String tatMasterRecord) {
  try {
   system.debug('tatMasterRecord ----->> ' + tatMasterRecord);
   //upsert tatMasterRecord;
   upsert(Tat_Master__c) JSON.deserialize(tatMasterRecord, Tat_Master__c.class);
  } catch (DMLException dmlException) {
   System.debug('Error while upsert --> ' + dmlException.getMessage());
  }
 }

 private static Map < String, Integer > monthsMap = new Map < String, Integer > {
  'JAN' => 1,
  'FEB' => 2,
  'MAR' => 3,
  'APR' => 4,
  'MAY' => 5,
  'JUN' => 6,
  'JUL' => 7,
  'AUG' => 8,
  'SEP' => 9,
  'OCT' => 10,
  'NOV' => 11,
  'DEC' => 12
 };

 /**
  * Parse the reponse string
  */
 @TestVisible
 private static TAT_Master__c parseResponse(String response, TAT_Master__c tatMasterRecord) {
  //response = 'CJKPK0366C^YOGESH^TUKARAM^KESARKAR^27-JUL-17^Existing and Valid';//'BJKPA8179C^NIKHIL^ANIL^AGAM^11-AUG-17^Existing and Valid';
  // response = 'null^null^null^null^Insufficient Balance-please recharge your account' (prod bug 22988--when API response fails)
  if (response != null && response != '' && response.split('\\^').size() >= 6) { // prod bug 22988 start added this if-else check
   List < String > splitStr = response.split('\\^');
   System.debug('splitStr -->' + splitStr.size());
   String finalDate = null;
   if (splitStr.size() > 1) {
    if (String.isNotBlank(splitStr[1]) || String.isNotBlank(splitStr[2]) || String.isNotBlank(splitStr[3])) {
     tatMasterRecord.Name__c = splitStr[1] + ' ' + splitStr[2] + ' ' + splitStr[3];
    }
    if (String.isNotBlank(splitStr[4])) {
     List < String > dateList = splitStr[4].split('-');
     if (dateList.size() == 3) {
      dateList[1] = String.valueOf(monthsMap.get(dateList[1]));
      System.debug('dateList[0] --> ' + dateList[0]);
      System.debug('dateList[1] --> ' + dateList[1]);
      System.debug('dateList[2] --> ' + dateList[2]);
      Date d = Date.parse(dateList[1] + '/' + dateList[0] + '/' + dateList[2]);
      System.debug('d --> ' + d);
      //Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
      //Datetime dt = datetime.newInstance(Integer.valueOf(dateList[2]), Integer.valueOf(dateList[1]), Integer.valueOf(dateList[0]));
      //System.debug('dt --> '+ dt);
      //finalDate = dt.format('dd/MM/yyyy');
      //System.debug('finalDate -->' + Date.parse(finalDate));
      //tatMasterRecord.Last_Modified_Date__c = Date.parse(finalDate);
      tatMasterRecord.Last_Modified_Date__c = d; //Date.parse(finalDate);
      System.debug('tatMasterRecord.Last_Modified_Date__c -->' + tatMasterRecord.Last_Modified_Date__c);
     }
    }
    if (String.isNotBlank(splitStr[5])) {
     tatMasterRecord.PAN_Check_Status__c = splitStr[5];
    }
   } else {
    System.debug('insode else -->');
    tatMasterRecord.PAN_Check_Status__c = 'Details could not be fetched';
   }
   System.debug('parseResponse tatMasterRecord --> ' + tatMasterRecord);
   return tatMasterRecord;
  } else { // prod bug 22988 start
   System.debug('insode else where unExpected response from NSDL API is returned-->');
   tatMasterRecord.PAN_Check_Status__c = 'Details could not be fetched';
   System.debug('Default TAT response if NSDL API return some unexpected --> ' + tatMasterRecord);
   return tatMasterRecord;
  } // prod bug 22988 End
 }

 /**
  * NSDL API callout
  */
 private static String calloutSync(String panNumber, String product) {
  try {
   tempuriOrg.BFL_PAN_Check_HTSSoap obj = new tempuriOrg.BFL_PAN_Check_HTSSoap();
   String response = obj.PANVerification(CommonUtility.encryptURLParamFrPan(panNumber), CommonUtility.encryptURLParamFrPan(product)); // Bug Id : 21606
   //String response = obj.PANVerification(panNumber, product); // Bug Id : 21606
   response = CommonUtility.decryptURLParamFrPan(response); // Bug Id : 21606
   system.debug('decrypted value1234:::' + response);
   System.debug('response -->' + response);
   if (String.isBlank(response)) {
    throw new CalloutException();
   }
   return response;
  } catch (CalloutException callExceptionInstance) {
   System.debug('callExceptionInstance.getMessage() -->' + callExceptionInstance.getMessage());
   return callExceptionInstance.getMessage();
  } catch (Exception exceptionInstance) {
   System.debug('exceptionInstance.getMessage() -->' + exceptionInstance.getMessage());
   return exceptionInstance.getMessage();
  }
 }

 @AuraEnabled
 public static List < String > POcallDocumentAPI(String oppId) {
  system.debug('POid is' + oppId);
  return SFDCMobilePOUtility.POcallDocumentAPI(oppId);
 }


 @AuraEnabled
 public static List < String > LANcallDocumentAPI(String oppId) {
  return SFDCMobileLoanController.callDocumentAPI(oppId);
 }




 @AuraEnabled
 public static Boolean getUserData() {
  return [SELECT IsActive, IsPortalEnabled, LastName FROM User WHERE id =: UserInfo.getUserId()].IsPortalEnabled;
 }

 @AuraEnabled
 public static List < SMS_Sent__c > callSendSms(string MobileNumber) {


  return smsSendPOS.sendEKYCSms(MobileNumber);

 }

 @AuraEnabled
 public static List < SMS_Sent__c > createSmsSentObj(string poId, String SmsObjList) {

  List < SMS_Sent__c > SmsSentInsertList = (List < SMS_Sent__c > ) JSON.deserialize(SmsObjList, List < SMS_Sent__c > .Class);
  system.debug('objects to be inserted before po lookup' + SmsSentInsertList);
  for (SMS_Sent__c SmsSentObj: SmsSentInsertList) {
   SmsSentObj.Product_Offerings__c = poId;
  }
  insert SmsSentInsertList;
  List < SMS_Sent__c > SmsSentReturnList = new List < SMS_Sent__c > ();
  // SmsSentReturnList  = [select id,Product_Offerings__c ,SMS Type from SMS_Sent__c where Product_Offerings__c  = :poId];
  return SmsSentReturnList;

 }



 //Bug 17531 - Rural Geo Fencing Start
 /*******************************************************
  * Method name: getDistanceFromBranch
  * Functionality: To capture response after calculating distance between image lat-long on verfication record and branch lat-long
  * Visibility: public
  * @param: String parentId (Image document's parent record id)
  * @return: String user-friendly message to show to user
  * Referred from: Lightning component : DocumentUploader --> DocumentUploaderHelper --> function calculateDistance
  *******************************************************/
 @AuraEnabled
 public static String getDistanceFromBranch(String parentId) {
  try {
   System.debug('parentId : ' + parentId);

   //Retrieve products from Geo Deviation Configuration
   Set < String > productSet = new Set < String > ();
   if (GeoDeviationUtility.getproductSet() != null && GeoDeviationUtility.getproductSet().size() > 0) {
    productSet = GeoDeviationUtility.getproductSet();
   }
   System.debug('productSet : ' + productSet);

   List < Verification__c > verificationObjList = [SELECT id, Image_Latitude_Longitude_Details__c, Geo_Tagging__c, Verification_Type__c, Applicant__c, Applicant__r.Applicant_Type__c, Loan_Application__c, Loan_Application__r.Product__c
    FROM Verification__c
    WHERE Id =: parentId
    AND Verification_Type__c = 'Residence verification'
    AND Applicant__r.Applicant_Type__c = 'Primary'
    AND Loan_Application__r.Product__c IN: productSet
   ];

   System.debug('verificationObjList  : ' + verificationObjList);

   //Check if verfication record follows geo-devation configuration and if getdeviationFlagConfig is set to true 
   if (GeoDeviationUtility.getdeviationFlagConfig() == true && verificationObjList != null && verificationObjList.size() > 0) {

    Map < String, String > responseMap = new Map < String, String > ();
    if (verificationObjList[0] != null && String.isNotBlank(verificationObjList[0].Image_Latitude_Longitude_Details__c)) {
     System.debug('Calculating distance.............');
     responseMap = calculateDistance.calculateDistanceMethod(verificationObjList[0].id);
     System.debug('responseMap : ' + responseMap);
    } else {
     return 'Not Applicable';
    }

    if (responseMap != null) {
     if (responseMap.get('success') != null)
      return responseMap.get('success');
     if (responseMap.get('HTTP error') != null)
      return responseMap.get('HTTP error');
     if (responseMap.get('Google API error') != null)
      return responseMap.get('Google API error');
     if (responseMap.get('Exception') != null)
      return 'Not Applicable';
    }

    return 'Not Applicable';
   } else {
    return 'Not Applicable';
   }
  } catch (Exception e) {
   System.debug('Exception occurred in getDistanceFromBranch : ' + e);
   return 'Not Applicable';
  }
 }
 //Bug 17531 - Rural Geo Fencing End

 /*Bug 18669 Start*/
 @AuraEnabled
 public static String getEncAadharNum(String aadharNum) {
  String encAadhar = CommonUtility.encryptURLParam(aadharNum);
  return encAadhar;
 }

 @AuraEnabled
 public static eKYC__c getEkycRecord(String ranNum) {
  return SFDCMobilePOUtility.getEkycRecord(ranNum);
 }
 /*Bug 18669 End*/
 //22425 CC Code changes SME s
 @AuraEnabled
 public static String getMCPResults(String poId) {
  system.debug(poId);
  List < SOL_Policy__c > spList = new List < SOL_Policy__c > ();
  spList = [SELECT Id FROM SOL_Policy__c WHERE Policy_Status__c = 'MCP FAIL'
   Limit 1
  ];
  if (!CommonUtility.isEmpty(spList)) {
   return 'fail';
  }
  return 'pass';
 }
 //22425  CC Code changes SME E     
 
 // Bug Id : 21804 start
    @AuraEnabled
    public static String autoQueueAllocation(String opp) {
        System.debug('opp -->' + opp);
        Id result = null;
        try {
            Id oppRecord = opp; //(Opportunity) JSON.deserialize(opp, Opportunity.class);
            Opportunity oppRecord1 = [select Product__c, Account.Queue_Master__c,Account.Queue_Master__r.QID__c/*Bug Id : 23549*/, Branch_City__c from Opportunity where id =: oppRecord LIMIT 1];
            AutoQueueAllocationUtility.Response res = AutoQueueAllocationUtility.autoAllocationQueue(oppRecord1, 'mobility_LA');
            System.debug('res --> ' + res);
            if (res != null) {
                String poolUser = Label.Pool_User;
                if (poolUser == res.credituserId) {
                    return JSON.serialize(res.credituserId);
                }
                List < Credit_Officer_Limit__c > colList = 
                    [select id, name, Designation__c, City__c, Credit_Officer_Name__r.Isactive, Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c
                     from Credit_Officer_Limit__c
                     where product__c =: oppRecord1.Product__c AND
                     Credit_Officer_Name__r.Isactive = true AND
                     Active_Flag__c = true AND
                     User_Type__c != 'OPs User'
                     AND City__c INCLUDES(: oppRecord1.Branch_City__c) AND Credit_Officer_Name__c =: res.credituserId
                    ];
                for (Credit_Officer_Limit__c col: colList) {
                    res.credituserId = null;
                    if (res.queueType != null && res.queueType == 'Branch Queue') {
                        if (
                            col.Designation__c == 'Credit Manager' || col.Designation__c == 'Area Credit Manager' || col.Designation__c == 'Regional Credit Manager' || col.Designation__c == 'Zonal Credit Manager' ||
                            col.Designation__c == 'National Credit Manager' || col.Designation__c == 'Business Head' || col.Designation__c == 'City Head' || col.Designation__c == 'Chief-Credit & Operations' ||
                            col.Designation__c == 'Chief Risk Officer' || col.Designation__c == 'National Risk Manager' || col.Designation__c == 'President'
                        ) {
                            result = col.Id;
                            break;
                        }
                    }
                    if (res.queueType != null && res.queueType == 'Centralized Queue') {
                        if (col.Designation__c == 'Centralized ACM' || col.Designation__c == 'Centralized RCM') {
                            result = col.Id;
                            break;
                        }
                    }
                }
                if (colList == null && colList.size() == 0) result = null;
            }
            System.debug('after result --> ' + result);
            return JSON.serialize(result);
        } catch (Exception exceptionInstance) {
            System.debug('Exception --> ' + exceptionInstance.getLineNumber() + '        ' + exceptionInstance.getStackTraceString());
            throw new AuraHandledException(exceptionInstance.getMessage());
        }
    }
    
    @AuraEnabled
    public static String submitApprover(String loanId, String poId, String approverId, Boolean isAutoCredit){
        Map<String, Object> params = new Map<String, Object>{'ACMName' => approverId, 'LoanId' => loanId, 'poId' => poId, 'isAutoCredit' => isAutoCredit};
            return mobility_pro.submitappr(JSON.serialize(params));
    } 
     // Bug Id : 21804 end
      //added by Gopika for Bug 24487 EMI CARD Start
@AuraEnabled
public static Boolean saveEmiDetails(Id idPOLA, String Identifier, String value) {
system.debug('Inside gopika method' + value);
if (Identifier == 'PO') {
Product_Offerings__c po = [Select id, Lead__r.EMI_Card__c from Product_Offerings__c where id =: idPOLA LIMIT 1];
system.debug('po is-->' + po);
Lead ld = po.Lead__r;
ld.EMI_Card__c = value;
update ld;
} else {
system.debug('idpola-->' + idPOLA);
Applicant__c app = [Select id, EMI_Card__c from Applicant__c where Loan_Application__r.Id =: idPOLA AND Applicant_Type__c='Primary' LIMIT 1];
system.debug('LAN is -->' + app);
if (value == 'Bundled')
app.EMI_Card__c = System.Label.EMI_FEES_VALUE;
else
app.EMI_Card__c = 'Not Interested';
update app;
}
return true;
}
@AuraEnabled
public static List < String > getEMICardValues() {
system.debug('values area');
List < String > lstVals = new List < String > ();
if (!string.isBlank(Label.EMI_CARD_PREFRENCE))
lstVals = Label.EMI_CARD_PREFRENCE.split(';');
system.debug('values area' + lstVals);
return lstVals;
}
@AuraEnabled
public static String getEMICardPreference(String IDofEMI, String identifier) {
try{
system.debug('Identifier' + identifier);
if (identifier == 'LAN') {
Applicant__c app = [Select id, EMI_Card__c from Applicant__c where Loan_Application__r.Id =: IDofEMI AND Applicant_Type__c='Primary' LIMIT 1];
system.debug('app.EMI_Card__c'+app.EMI_Card__c);
if (app.EMI_Card__c == System.Label.EMI_FEES_VALUE ||app.EMI_Card__c == 'EMI Fees')
return 'Bundled';
else
return 'Not Interested';
} else {
Product_Offerings__c po = [Select id, Lead__r.EMI_Card__c from Product_Offerings__c where id =: IDofEMI LIMIT 1];
return po.Lead__r.EMI_Card__c;
}
}catch(Exception e){
    system.debug('Exception occured at'+e);
    return null;
}
}
@AuraEnabled
public static String callupdateFees(String loanid) {
system.debug('Calling fetch charge');
try{
Opportunity Loan = [select Loan_Application_Number__c,(Select id,EMI_Card__c from Loan_Application__r where Applicant_Type__c='Primary' LIMIT 1),(Select id,Finnone_ChargeId__c,Charge_Desc__c,
Change_Amount__c,Deducted_from_Disbursement__c,Instrument_type__c from Fees_and_Charges__r) from Opportunity where id =: loanid LIMIT 1
];

List<Fees_and_Charge__c> updateFees = new List<Fees_and_Charge__c>();
List<Fees_and_Charge__c> feeList = Loan.Fees_and_Charges__r;
system.debug('List of fees and charges-->'+feeList);
Applicant__c app= Loan.Loan_Application__r ;
if(feeList!=Null&&feeList.size()>0){
for(Fees_and_Charge__c fees : feeList){
if(fees.Finnone_ChargeId__c==Decimal.valueOf('500671')&&fees.Charge_Desc__c.containsIgnoreCase('EMI CARD')){
system.debug('app.EMI_Card__c'+app.EMI_Card__c);
if(app!=Null&&app.EMI_Card__c!=Null&&app.EMI_Card__c!='Not Interested'){
fees.Change_Amount__c=Decimal.valueOf(app.EMI_Card__c);
fees.Instrument_type__c='Deduct from Disb';
fees.Deducted_from_Disbursement__c='Yes';
fees.Status__c='To be collected';
}
else{
fees.Change_Amount__c=0;
fees.Deducted_from_Disbursement__c='';
fees.Instrument_type__c='';
fees.Status__c='Y';
}
updateFees.add(fees);
}
}
if(updateFees!=Null&&updateFees.size()>0)
update updateFees;
return 'true';
}
else{
return 'true';
}
}catch(Exception e){
system.debug('Exception occured-->'+e);
return null;
}
}
@AuraEnabled
public static String getEmiCardPrefonSubmit(String poid){
Product_Offerings__c po= [Select Lead__r.Emi_Card__c from Product_Offerings__c where id=: poid];
if(po!=Null&&po.Lead__r!=Null&&po.Lead__r.Emi_Card__c!=Null){
return po.Lead__r.Emi_Card__c;
}
else{
return null;
}
}
//added by Gopika for Bug 24487 EMI CARD end
}