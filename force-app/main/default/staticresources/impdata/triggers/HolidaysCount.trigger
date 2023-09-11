/**
 * @author Persistent Systems Ltd.
 * @date 29/01/2013
 * @description Trigger for Stamping the Holiday count for closed,open cases,Basis Originator Holiday count 
 * Stamping of holiday count if case is open need to consider from Case created date to today.
 * Stamping of holiday count if case is Closed  need to consider from Case created date to closed date.
 * Stamping of holiday count basis Originator if case is open need to consider from Last update from Originator date to today.
 * Stamping of holiday count basis Originator if case is Closed  need to consider from Last update from Originator date to closed date.
 
 */
trigger HolidaysCount on Case (before update) {

        List<CRM_Holiday__c> listOfholidays = [select Description__c,Holiday_Date__c,Remarks__c
                                                 from CRM_Holiday__c LIMIT 50000 ];
                                               
        for (case aCase : Trigger.new){
            Integer noOfHolidays = 0;
            Integer i= 0;
            //DateTime endDate = system.today();
            DateTime endDate;
             if(aCase.status == 'CLOSED'){
                 system.debug('@@@@@@@@@@@closed case with listOfholidays size as '+listOfholidays.size());
               endDate = aCase.ClosedDate;
               if(aCase.ClosedDate == null){
               endDate = system.today();
               system.debug('@@@@@@@@@@@endDate '+endDate );
               }
                
             } 
             system.debug('@@@@@@@@@@@Holidaysize'+listOfholidays.size());    
             if(listOfholidays.size()>0){
             system.debug('@@@@@@@@@@@Holidayloop');
                    //Stamping of holiday count if case is open need to consider from Case created date to today.
                     //Stamping of holiday count if case is Closed  need to consider from Case created date to closed date.
                    for(CRM_Holiday__c CRMHolidayObj : listOfholidays){
                     system.debug('@@@@@@@@@@@Holidayloop');
                      system.debug('@@@@@@@@@@@Hlidaydate'+CRMHolidayObj.Holiday_Date__c);
                      system.debug('@@@@@@@@@@@aCase.CreatedDate'+aCase.CreatedDate);
                        if((CRMHolidayObj.Holiday_Date__c >= aCase.CreatedDate) && (CRMHolidayObj.Holiday_Date__c <= endDate )){
                system.debug('@@@@@@@@@@@holidaycheckcondition'+'CRMHolidayObj.Holiday_Date__c'+CRMHolidayObj.Holiday_Date__c+'CRMHolidayObj.Holiday_Date__c'+CRMHolidayObj.Holiday_Date__c);
                            noOfHolidays ++;
                        }
                    }
                 }
                 system.debug('@@@@@@@@@@@noOfHolidays'+noOfHolidays);
             aCase.Holiday_Count__c = String.valueof(noOfHolidays);
              if(listOfholidays.size()>0){
                    //Stamping of holiday count if case is open need to consider from Last update from Originator date to today.
                     //Stamping of holiday count if case is Closed  need to consider from Last update from Originator date to closed date.
                    for(CRM_Holiday__c CRMHolidayObj : listOfholidays){
                        if((CRMHolidayObj.Holiday_Date__c >= aCase.Last_update_from_Originator__c)&& (CRMHolidayObj.Holiday_Date__c <= endDate ) ){
                            i++;
                        }
                    }
                 }
             aCase.Holiday_Count_Basis_Originator__c = String.valueof(i);
                  
        }
}