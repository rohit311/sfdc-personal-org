/**
 * @author Persistent Systems Ltd.
 * @date 08/02/2012
 * @description Trigger for Calucating over all feedback given by customer . 
 
 */
trigger CustomerRatingMeter on Feedback__c(after insert, after update) {

 List < Id > feedbackId = new List < Id > ();
 List < Id > feedbackId1 = new List < Id > ();
 //Bug# 12490 S
 Set < Id > caseId = new Set < Id > ();
 Set < Id > feedbkIds = new Set < Id > ();
 //Bug# 12490 E
 system.debug('*******Trigger.new:' + Trigger.new);
 for (Feedback__c obj: Trigger.new) {

  feedbackId.add(obj.Customer_ID__c);
  feedbackId1.add(obj.Welcome_Letter__c);
  //Bug# 12490 S
  if (obj.Case__c != null) {
   caseId.add(obj.Case__c);
  }
  feedbkIds.add(obj.Id);
  //Bug# 12490 E
 }
 //Bug# 12490 S
 /**
  * Block to check if expected set of condition and call future method with set of case Ids.
  * parameter CaseId and set of CaseIds
  */
 if (Trigger.isInsert && Trigger.isAfter) {
  system.debug('in');
  if (caseId != null && caseId.size() > 0 && feedbkIds != null && feedbkIds.size() > 0) {
   system.debug('Before');
   NPSEmailHandler.NPSEmailSend(feedbkIds, caseId);
   system.debug('After');
  }
 }
 //Bug# 12490 E
 system.debug('*******feedbackId:' + feedbackId);
 List < Customer_info__c > cinfo = new List < Customer_info__c > ();
 cinfo = [select Id, (select Avg_Rating__c from Feedbacks__r WHERE Avg_Rating__c != NULL)
  FROM Customer_info__c
  WHERE Id in : feedbackId
 ];
 system.debug('####cinfo###' + cinfo);
 if (cinfo.size() > 0) {
  system.debug('#### in cinfo###');
  // List<Feedback__c> listOfFeedback = (Customer_info__c)cinfo[0].getRecords();
  Integer rating = 0;
  List < Feedback__c > listOfFeedback = cinfo.get(0).Feedbacks__r;
  //D2C S
  if (listOfFeedback.size() > 0) {
   for (Feedback__c f: listOfFeedback) {
    if (f.Avg_Rating__c != null) {
     rating += Integer.valueOf(f.Avg_Rating__c);
    }
   }
   system.debug('#######rating #######' + rating + '@@@@@@@listOfFeedback@@@@@@@@@' + listOfFeedback.size());
   cinfo[0].Feedback_Avg_Rating__c = rating / listOfFeedback.size();
   upsert cinfo[0];
  }
  /*cinfo[0].Feedback_Avg_Rating__c = rating / listOfFeedback.size();
  upsert cinfo[0];*/
 }
}