//Purspose: Share Customer Interaction records to FOS stamped in Customer
trigger CallMemoTrigger on Call_Memo__c (after insert, after update) {

    if (Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)  ){
        List<Call_Memo__c> lstNewCM = new List<Call_Memo__c>();
        //CUSTOMER__r.Customer_Name__c,Payment_Link__c,CUSTOMER__r.Customer_Mobile_Number__c,FOS_Disposition__c, FOS_Subdisposition__c, CUSTOMER__r.Lead_Source__c- added for bug 25154
        lstNewCM = [select id,Insurance_Event_Start_Day__c,CUSTOMER__r.Mobile__c,CUSTOMER__r.Lead_Viewable__c,CUSTOMER__r.Insurance_Agent__r.Sales_Officer_Name__r.MobilePhone,CUSTOMER__r.Insurance_Agent__r.Sales_Officer_Name__r.Name,Insurance_Event_Start__c,CUSTOMER__r.Customer_Name__c,Payment_Link__c,CUSTOMER__r.Customer_Mobile_Number__c,FOS_Disposition__c, FOS_Subdisposition__c, CUSTOMER__r.Lead_Source__c,Customer__c,Customer__r.Insurance_Agent__c,RecordType.Name,ownerId from Call_Memo__c where id IN :Trigger.newMap.keySet()];
        System.debug('COUNT');
        //Method to share Customer Interaction records to FOS stamped in Customer
        CallMemoTriggerHandler.shareCMWithInsAgent(lstNewCM);
        
        // Added for SMS trigger to call center leads - 19985
        if(Trigger.isUpdate) {
            CallMemoTriggerHandler.updateSMSRecords(Trigger.new, Trigger.oldMap);   
        }
        CallMemoTriggerHandler.createSMSRecords(Trigger.new);
        // Added for SMS trigger to Lapse customer - 25154
        if (Trigger.isInsert){
				system.debug('INSERT ::');
                CallMemoTriggerHandler.PaymentLinkSMS(lstNewCM);
                CallMemoTriggerHandler.NotificationSMS(lstNewCM);
        }
        
    }
    
    
}