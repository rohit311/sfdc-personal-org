trigger Calling_sms_welcome on Welcome_Letter__c(before update) {
 String ph;
 String mess;
 List < string > messages = new List < string > ();
 List < string > mobileNumbers = new List < string > ();
 String courierName;
 for (Welcome_Letter__c oppNew: Trigger.New) {
  if (oppNew.Relationship_Guide__c == True && oppNew.Airway_Bill_Number__c != null && oppNew.Test__c != True) {
   System.debug('inside 1stif loop');
   //Bug 6538 change in courier name by Akshata S
   //automate courier name by using create setting
   ProductSMS__c p = ProductSMS__c.getValues('CourierName');
   courierName = p.welcome_letter_courier_name__c;
   if (courierName != null) {
    mess = 'Dear Customer, your loan relationship guide has been dispatched via ' + courierName + ',' + 'AWB no' + oppNew.Airway_Bill_Number__c + '.';

   }
   //Bug 6538 change in courier name by Akshata E
   //mess='trigger test on 1st Condition';

   if (oppNew.MOBILE__c != null) {
    ph = oppNew.MOBILE__c;
    system.debug('Before');
    messages.add(mess);
    mobileNumbers.add(ph);
    //sendsms.message(ph,mess);
    system.debug('After');
    oppNew.Test__c = true;
   }

  }
  if (oppNew.Welcome_SMS_Status__c != true && oppNew.Relationship_Guide__c == True && oppNew.POD__c != Null && oppNew.Airway_Bill_Number__c != null) {
   System.debug('inside 2nd if loop');
   mess = 'Dear Customer, your loan relationship guide has been delivered. If you haven\'t received it please call us at – 020 39574151.';
   //mess= 'Dear Customer, your loan relationship guide has been delivered. Thank you for Choosing Bajaj Finserv-Lending.';
   if (oppNew.MOBILE__c != null) {
    ph = null;
    ph = oppNew.MOBILE__c;
    messages.add(mess);
    mobileNumbers.add(ph);
    //  sendsms.message(ph,mess);
    oppNew.Welcome_SMS_Status__c = true;
   }
  } else if (oppNew.Welcome_SMS_Status__c != true && oppNew.Relationship_Guide__c == True && oppNew.Delivered_to_branch__c == True && oppNew.Airway_Bill_Number__c != null) {
   System.debug('inside 3rd if loop');
   mess = 'Your loan relationship guide has been returned due to your unavailability & we will send it again. Please call at 020 39574151 for more details.';
   //mess = 'Dear Customer, your loan relationship guide is returned due to unavailability at your given address, the same will be delivered to you by our representative. Please call us at our toll free no-020 39574151 for more details. Thank you for Choosing Bajaj Finserv-Lending.';
   if (oppNew.MOBILE__c != null) {
    ph = null;
    ph = oppNew.MOBILE__c;
    messages.add(mess);
    mobileNumbers.add(ph);
    oppNew.Welcome_SMS_Status__c = true;
    //sendsms.message(ph,mess);

   }
  }


  //to Customer Mobile Number

 } //end of for            
 if (messages.size() > 0 && mobileNumbers.size() > 0)
  sendsms.sendBulkSMS(messages, mobileNumbers);

}