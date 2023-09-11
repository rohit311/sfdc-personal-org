trigger DeleteRecords on CommercialCibil_Profile_Summary__c (before delete) {
	List<Id> profileIdList = new List<Id>();
	List<Id> detailIdList = new List<Id>();
	List<Id> summaryIdList = new List<Id>();
	List<Id> facilityDetailIdList = new List<Id>();
	List<CommercialCibil_Credit_Facility_Details__c> facilityDetailList = new List<CommercialCibil_Credit_Facility_Details__c>();
	List<CommercialCibil_Details__c> detailList = new List<CommercialCibil_Details__c>();
	List<CommercialCibil_Credit_Type_Summary__c> summaryList = new List<CommercialCibil_Credit_Type_Summary__c>();
	List<CommercialCibil_24_Month_History__c> monthHistoryList = new List<CommercialCibil_24_Month_History__c>();

	System.debug('**********trigger.old: '+trigger.old);
	
	for(CommercialCibil_Profile_Summary__c obj: trigger.old){
		System.debug('*********obj.Id: '+obj.Id);
		profileIdList.add(obj.Id);
	}

    detailList = [select id from CommercialCibil_Details__c where CommercialCibil_Profile_Summary__c in :profileIdList];
    for(CommercialCibil_Details__c obj: detailList)
       detailIdList.add(obj.Id);
       
    summaryList = [select id from CommercialCibil_Credit_Type_Summary__c where CommercialCibil_Profile_Summary__c in :profileIdList];
    for(CommercialCibil_Credit_Type_Summary__c obj: summaryList)
       summaryIdList.add(obj.Id);
       
    facilityDetailList = [select id from CommercialCibil_Credit_Facility_Details__c where CommercialCibil_Credit_Type_Summary__c in :summaryIdList or CommercialCibil_Details__c in :detailIdList or CommercialCibil_Profile_Summary__c in :profileIdList];
    for(CommercialCibil_Credit_Facility_Details__c obj: facilityDetailList)
       facilityDetailIdList.add(obj.Id);  
    
    monthHistoryList = [select id from CommercialCibil_24_Month_History__c where CommercialCibil_Credit_Facility_Details__c in :facilityDetailIdList];    
    
    if(facilityDetailList != null && facilityDetailList.size() > 0)
       delete facilityDetailList;
       
    if(detailList != null && detailList.size() > 0)
       delete detailList;
       
    if(summaryList != null && summaryList.size() > 0)
       delete summaryList;
       
    if(monthHistoryList != null && monthHistoryList.size() > 0)
       delete monthHistoryList;         
}