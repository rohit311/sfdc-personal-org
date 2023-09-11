/**
 * @author Persistent Systems Ltd.
 * @date 08/02/2012
 * @description Trigger for Storing TAT Utilisation and TAT calculation
 * Trigger for sending an E-mail to customer once the case is close 
 * Trigger for sending an E-mail to customer once the case is Raised  
 before update , before insert
 */
trigger CaseOwnershipTrigger on Case (after insert , after update){
     //DepartmentController dept;
    Map<Id,Id> mapOfUserCase = new map<Id,Id>();
    Map<Id,String> mapOfQueueCase = new map<Id,String>();
    List<String> contactNum=new List<String>(); 
    List<String> listmsg=new List<String>(); 
    public boolean npsflag=false; //bug 15628 NPS
    //added by Suraj ...NPS timed enhancement ...start
    public set<ID> smstobesent1; 
    Datetime d1 = datetime.now();
    Integer endHour,startHour,spclHour;
    endHour=Integer.valueOf(Label.NPS_timed_end_hour);
    startHour=Integer.valueOf(Label.NPS_timed_start_hour_NF);
    spclHour=Integer.valueOf(Label.NPS_timed_hour);
    //added by Suraj ...NPS timed enhancement ...end
    public set<ID> caseID; //nps
    public string smstext='Greetings from BFL! Thank you for interacting with our branch. Kindly rate us on a scale (1-3) , 1 Not satisfied  ,2 Average, 3 Highly Satisfied. Type BRANCH space your rating , send it to 9227564444';
    public string smstext2;
    public string smstext3='We would need your feedback on effort taken for service request resolution. Type EFFORT HIGH OR EFFORT LOW and send it to 9227564444 to indicate your rating';
    public string smstext4='Thank you for calling BFL, We will revert to you within 24 Working hours.';
    public string smstext5;
    list<SMS_Sent__c> SMSToBeSent = new list<SMS_Sent__c>();
    Map<String,String> queueMap = new Map<String,String>();
    List<BackOfficeQueue__c> queues =   BackOfficeQueue__c.getall().values();
      for(BackOfficeQueue__c g:queues){
            if(g.Use_for_Request_Page__c==true)
                queueMap.put(g.Back_Office_Queue_ID__c,g.Name);
                }
    System.debug('Queue map '+queueMap);
    List<Case> CaseLst=[select id,Loan_info__r.Loan_Number__c,customer_info__r.Owner.Phone,Service_Officer_Mobile__c,
        Cust_Phone_Number__c,Process_Type__c,status,CaseNumber,Relationship_Manager__c,ClosedDate,/*bug 15628*/
        Customer_info__r.Payment_Received__c, Customer_info__r.Relationship_Manager_Mobile__c,Category__c ,type__c,
        Sub_Type__c,origin,Loan_Account_Number__c,CreatedDate,LastModifiedDate,NPS_Score__c,Owner.Name,owner.type,
        OnHold__c,ownerid,Case_Opened_By_Cashier__c,Customer_info__r.Email__c,remarks__c,Requester_Email_Id__c,
        TAT__c,NRM_Approval_Status__c,NRM_Status_Updated_By__c,NRM_Remarks__c,NRM_status_updated_on__c ,Customer_info__c,
        Loan_INFO__c,Customer_name__c,Customer_EmailID__c,IFA_email__c,IFA_mobile__c,Customer_info__r.Is_RBI_OR_SNR_MNGR_Escalated__c
        from case where id in :Trigger.new];
    if(Trigger.isAfter && Trigger.isInsert){
        
        CaseOwnedHistory__c newOwner = new CaseOwnedHistory__c();
        List<CaseOwnedHistory__c> listOfHistory = new List<CaseOwnedHistory__c>();
        
        
    //for(Case obj : Trigger.new){
    for(Case obj : CaseLst){
            //for service refinement start
            
            if(System.Label.Service_Refinement_Switch == 'true')
            {
                //Case obj = [select  Loan_info__r.Loan_Number__c,customer_info__r.Owner.Phone,customer_info__r.Payment_Received__c, customer_info__r.Relationship_Manager_Mobile__c,Service_Officer_Mobile__c from case where id =: obj.id];
               
                if((obj.status =='New' || obj.status=='In Process')){
               
                    ProductSMS__C prodsms = new ProductSMS__C();
                    System.debug(obj.Process_Type__c+' == DigitalLounge');
                    if(obj.Process_Type__c == 'Digital Lounge' || obj.Process_Type__c == 'DigitalLounge') 
                        prodsms = ProductSMS__C.getValues('SR DL Creation SMS');
                    else
                        prodsms = ProductSMS__C.getValues('SR '+obj.Process_Type__c+' Creation SMS');
                        //System.debug('SR '+obj.Process_Type__c+' Creation SMS');
                 
                    //System.debug(prodsms);
                 
                    if(prodsms !=null && obj.Customer_name__c!=null && obj.CaseNumber!=null && obj.Loan_INFO__r.Loan_Number__c!=null && obj.Cust_Phone_Number__c!=null){
                        
                        String smsmsg = prodsms.SMS_Text__c;
                        //System.debug(smsmsg);
                        smsmsg = smsmsg.replace('**Customer Name**', obj.Customer_name__c);
                        smsmsg = smsmsg.replace('**SRN**', obj.CaseNumber);
                        smsmsg = smsmsg.replace('**LAN**', obj.Loan_INFO__r.Loan_Number__c);
                        smsmsg = smsmsg.replace('**Customer Mobile**', obj.Cust_Phone_Number__c);
                        
                        String toString = prodsms.receipientsapinames__c;
                        String[] toNames;
                           
                        if(toString !=null)
                           toNames= toString .split('\\;');
                        //System.debug('toName:::'+toNames);
                        //System.debug('toString :::'+toString );
                        for(String to : toNames){
                            //System.debug('#to :'+to);
                            SMS_Sent__c serviceRefinementSMS = new SMS_Sent__c();
                            serviceRefinementSMS.Name = 'Case Creation SMS';
                            serviceRefinementSMS.Case__c = obj.Id;
                            serviceRefinementSMS.SMS_Text_Sent__c = smsmsg;
                            serviceRefinementSMS.SMS_Type__c = 'CRM SMS';
                            serviceRefinementSMS.SMS_Sent_Time__c = system.now();
                            System.debug('##to :'+to);
                            
                            if(to=='Service Officer' && obj.Service_Officer_Mobile__c!=null){
                                listmsg.add(smsmsg);
                                contactNum.add(obj.Service_Officer_Mobile__c);
                                serviceRefinementSMS.SMS_Sent_Number__c = obj.Service_Officer_Mobile__c;
                                serviceRefinementSMS.SMS_Receiver__c = 'Service Officer';
                                SMSToBeSent.add(serviceRefinementSMS);
                                //System.debug('## ToMobile:'+obj .Service_Officer_Mobile__c);
                                System.debug('service refinement sms sent');
                            }
                            else if(to == 'RM' && obj.customer_info__r.Relationship_Manager_Mobile__c!=null){
                                listmsg.add(smsmsg);
                                contactNum.add(obj.customer_info__r.Relationship_Manager_Mobile__c);
                                serviceRefinementSMS.SMS_Sent_Number__c = obj.customer_info__r.Relationship_Manager_Mobile__c;
                                serviceRefinementSMS.SMS_Receiver__c = 'Relationship Manager';
                                SMSToBeSent.add(serviceRefinementSMS);
                                //System.debug('## ToMobile:'+obj.customer_info__r.Relationship_Manager_Mobile__c);
                                System.debug('service refinement sms sent');
                            }
                            
                            else if(to== 'Tele RM' && obj.customer_info__r.Owner.Phone!=null && obj.customer_info__r.Payment_Received__c == true){
                                System.debug('###to :'+to);
                                listmsg.add(smsmsg);
                                contactNum.add(obj.customer_info__r.Owner.Phone);
                                serviceRefinementSMS.SMS_Sent_Number__c = obj.customer_info__r.Owner.Phone;
                                serviceRefinementSMS.SMS_Receiver__c = 'TeleRM';
                                SMSToBeSent.add(serviceRefinementSMS);
                                //System.debug('## ToMobile:'+obj.customer_info__r.Owner.Phone);
                                System.debug('service refinement sms sent');
                            }
                        }
                    }
                    else{ 
                        System.debug('Insufficient Data : Please check for Customer_name__c, CaseNumber, Loan_INFO__c, Cust_Phone_Number__c or custom setting record');
                    }
                }  
            }
            else{ 
                System.debug('service refinement sms not sent because switch is off');
            }
            //service refinement end
            
            newOwner = new CaseOwnedHistory__c();
            newOwner.Case__c = obj.Id;
          
            //if(newOwner.owner.type != BajajFinservCRMConstants.QUEUE_TYPE)
            //newOwner.User__c = obj.OwnerId;
            System.debug('Owner type '+obj.ownerId);
            
            if(string.valueof(obj.OwnerId).startsWith('00G')){ 
                
                if(obj.OwnerId!=null && (queueMap.containsKey(string.valueof(obj.OwnerId)) || queueMap.containsKey(string.valueof(obj.OwnerId).substring(0, 15)))){              
                    System.debug('Queue Name '+queueMap.get(string.valueof(obj.OwnerId).substring(0, 15)) +' '+obj.OwnerId); 
                
                    newOwner.Queue_Name__c = queueMap.get(string.valueof(string.valueof(obj.OwnerId).substring(0, 15)));      
                }
            }else{ 
            system.debug('--obj.OwnerId---------'+obj.OwnerId);                  
            newOwner.User__c = obj.OwnerId;
            }
            
            newOwner.Got_Ownership__c = DateTime.now();
            listOfHistory.add(newOwner);
            // SMS sent to Customer
            //if(obj.Category__c == BajajFinservCRMConstants.COMPLAINT || obj.Category__c == BajajFinservCRMConstants.REQUEST){
            if(obj.Type__c=='Call Back' && obj.Sub_Type__c=='HTS-Call back'){
                    // Util.sendMail(obj.Customer_EmailID__c, label.fromAddress, label.fromDisplayName,label.EmailSubjectRequestRaised,label.EmailBodyRequestRaised+' ' +obj.CaseNumber+'\n'+ label.TATTime +' '+obj.TAT__c+' days\n'+ label.ThankyouMessage);
                  //  sendsms.message(obj.Cust_Phone_Number__c,'Thank you for calling BFL, We will revert to you within 24 Working hours.');
                    listmsg.add(smstext4);
                    contactNum.add(obj.Cust_Phone_Number__c);
                }
            
            
             
             
                
                if(obj.TAT__c> 0 && obj.Sub_Type__c!='HTS-Call back'){
                if(obj.Customer_EmailID__c!=null)
                if(!test.isRunningTest()){
                    Util.sendMail(obj.Customer_EmailID__c, label.fromAddress, label.fromDisplayName,label.EmailSubjectRequestRaised,label.EmailBodyRequestRaised+' ' +obj.CaseNumber+'\n'+ label.TATTime +' '+obj.TAT__c+' days\n'+ label.ThankyouMessage);
                  } // sendsms.message(obj.Cust_Phone_Number__c,'Greetings from BFL ! Your service request number '+ obj.CaseNumber + ' is under process . The request will be resolved in '+ obj.TAT__c + ' working days.');
                    smstext5='Greetings from BFL ! Your service request number '+ obj.CaseNumber + ' is under process . The request will be resolved in '+ obj.TAT__c + ' working days.';
                    listmsg.add(smstext5);
                    contactNum.add(obj.Cust_Phone_Number__c);
                }
                
                if(obj.Origin == 'IFA-Email' || obj.Origin == 'IFA -SMS'){
                    system.debug('IFA testing*****');
                if(obj.IFA_email__c!=null){
                    if(!test.isRunningTest()){
                    Util.sendMail(obj.IFA_email__c, label.fromAddress, label.fromDisplayName,label.EmailSubjectRequestRaised,label.EmailBodyRequestRaised+' ' +obj.CaseNumber+'\n'+ label.TATTime +' '+'48'+' hours\n'+ label.ThankyouMessage);
                    }// sendsms.message(obj.Cust_Phone_Number__c,'Greetings from BFL ! Your service request number '+ obj.CaseNumber + ' is under process . The request will be resolved in '+ obj.TAT__c + ' working days.');
                    system.debug('IFA testing Email*****');
                }
                    smstext5='Greetings from BFL ! Your service request number '+ obj.CaseNumber + ' is under process . The request will be resolved in '+ '48' + ' hours';
                    listmsg.add(smstext5);
                    contactNum.add(obj.IFA_mobile__c);
                }
                
            
           // Rest Service call To CDPC
            /*if(obj.Type__c == 'Card Error' || obj.Type__c == 'Card Related Complaint' || obj.Type__c == 'Card info' ||
                obj.Type__c == 'Transaction Info' || obj.Type__c == 'CD Customer' || obj.Type__c == 'Card Related Enquiry' ||
                obj.Type__c == 'Block Card' || obj.Type__c == 'Issue Card' || obj.Type__c == 'Waiver' ){*/
                
            //Below lines from 38 to 42 has comment in production org for not having any functionalites related to EMi in production     
            /*if(obj.Type__c == 'EMI Card'){
                    
                      EMIRestServiceToCDPC.login(obj.Customer_EMI_Card_Number__c ,obj.EMI_User_Name__c,obj.Cust_Phone_Number__c,obj.Category__c , obj.Type__c , obj.Sub_Type__c);  
            }*/
                    
        //}
           
      //}
    }
        if(listOfHistory.size() > 0){
                insert listOfHistory;
        } 
    }

     if(Trigger.isAfter && Trigger.isUpdate){
        //for service refinement start
        System.debug('Update Trigger'); 
        if(System.Label.Service_Refinement_Switch == 'true'){
           // List<Case> newSRCases=[select id,Loan_info__r.Loan_Number__c,Cust_Phone_Number__c,Process_Type__c,status,CaseNumber,Relationship_Manager__c,Customer_info__r.Payment_Received__c, Customer_info__r.Relationship_Manager_Mobile__c
                             //  from case where id in :Trigger.new];
            List<SMS_Sent__c> SMSAlreadySent = [Select Id,Name,Case__c From SMS_Sent__c where Case__c in :CaseLst and Name = 'Case Closure SMS'];
            set<Id> ClosedCaseIds = new set<Id>();
                
            for(SMS_Sent__c sms : SMSAlreadySent){
                ClosedCaseIds.add(sms.Case__c);
            } 
            for(Case obj : CaseLst){
                String smsmsg;
                if(obj.status =='Closed' && !ClosedCaseIds.contains(obj.id)){
                    ProductSMS__C prodsms = new ProductSMS__C();
                    prodsms = ProductSMS__C.getValues('SR Closure SMS');
                    if(prodsms !=null)
                        smsmsg = prodsms.SMS_Text__c;
                    else
                         System.debug('prodsms is null'); 
                   // System.debug('Closure Message : '+smsmsg); 
                   // System.debug(obj.Relationship_Manager__c+' '+obj.CaseNumber+'  '+obj.Customer_info__r.Relationship_Manager_Mobile__c+' '+obj.Cust_Phone_Number__c);
                  
                  
                  
                    if(obj.Process_Type__c == 'RM' || ((obj.Process_Type__c == 'Digital Lounge' || obj.Process_Type__c == 'DigitalLounge') && obj.Customer_info__r.Payment_Received__c==true)){
                        if(prodsms !=null && obj.Relationship_Manager__c!=null && obj.CaseNumber!=null && obj.Customer_info__r.Relationship_Manager_Mobile__c!=null && obj.Cust_Phone_Number__c!=null){
                         
                            smsmsg = smsmsg.replace('**SRN**', obj.CaseNumber);
                            smsmsg = smsmsg.replace('**RMName**', obj.Relationship_Manager__c);
                            smsmsg = smsmsg.replace('**RMMobile**', obj.Customer_info__r.Relationship_Manager_Mobile__c);
    
                            listmsg.add(smsmsg);
                            contactNum.add(obj.Cust_Phone_Number__c);
                               
                            SMS_Sent__c serviceRefinementSMS = new SMS_Sent__c();
                            serviceRefinementSMS.Name = 'Case Closure SMS';
                            serviceRefinementSMS.Case__c = obj.Id;
                            serviceRefinementSMS.SMS_Text_Sent__c = smsmsg;
                            serviceRefinementSMS.SMS_Type__c = 'CRM SMS';
                            serviceRefinementSMS.SMS_Sent_Time__c = system.now();
                            serviceRefinementSMS.SMS_Sent_Number__c = obj.Cust_Phone_Number__c;
                            serviceRefinementSMS.SMS_Receiver__c = 'Customer';
                            SMSToBeSent.add(serviceRefinementSMS);
                            System.debug('service refinement sms sent');
                        }  
                        else{ System.debug('FIELDS MISSING');}
                    }
                    else{System.debug('Condition not mathced');}
                }
            } 
        }   
        else{ 
            System.debug('service refinement sms for updation not sent because switch is off');
        }   
        //service refinement end
        
         //NPS Bottoms up Start Rasika
         //Start: NPS by rasika k
         //case trigger optimization set<id> lan =new set<ID>();
        set<ID> custID = new Set<ID>();
        set<string> type = new set<string>();
        set<string> subtype= new set<string>();
        for(case cs: trigger.new){
            //lan.add(cs.Loan_INFO__c);
            custID.add(cs.CUSTOMER_INFO__c);
            type.add(cs.Type__c);
            subtype.add(cs.Sub_Type__c);
        }
        // START LAS CRM 
        List < Group > qId = [select id from Group where type = 'Queue' AND Name = 'LAS Queue' limit 1];
        //System.debug('ani -- qID >>' + qID);
        // END LAS CRM

        Map<Id,CaseOwnedHistory__c> mapOfCaseHistory = new map<Id,CaseOwnedHistory__c>();
        List<CaseOwnedHistory__c> caseOwner = [select User__c,Queue_Name__c, Case__c,Lost_Ownership__c,
            Got_Ownership__c,Case_Hold_Start_Time__c,Total_Time_Owned__c
            FROM CaseOwnedHistory__c 
            WHERE Case__c in: Trigger.new
            ORDER BY CreatedDate DESC,Lost_Ownership__c
            ];

        System.debug('caseowner list :' + caseOwner );
        if(caseOwner.size() > 0){  
            System.debug('in case owner');
            Set<Id> setOfCases = new Set<Id>();
            for(CaseOwnedHistory__c obj : caseOwner){                
                if(!setOfCases.contains(obj.Case__c)){
                    setOfCases.add(obj.Case__c);
                    if(obj.User__c == null){
                        mapOfQueueCase.put(obj.Case__c,obj.Queue_Name__c); 
                    }else{
                        mapOfUserCase.put(obj.Case__c,obj.User__c);
                    }
                    mapOfCaseHistory.put(obj.Case__c,obj);
                }
            }
        }

        List<CaseOwnedHistory__c> historyList = new List<CaseOwnedHistory__c>();

        //  list<FeedbackHyperlink__c> fb = [select FeedbackSiteURL__c from FeedbackHyperlink__c LIMIT 10];
        list<feedback_question__c> feedbackquestionList=[select id,Question_Description__c,Rating__c from Feedback_Question__c  WHERE isActive__c = TRUE  LIMIT 10];


        //List<Case> NPSSRCases=[select Category__c ,type__c,Sub_Type__c,origin,Loan_Account_Number__c , id,Loan_info__r.Loan_Number__c,Cust_Phone_Number__c,status,CaseNumber,Relationship_Manager__c,LastModifiedDate,NPS_Score__c, Customer_info__r.Relationship_Manager_Mobile__c
        // from case where id in :Trigger.new];
        List<SMS_Sent__c> NPSSMSAlreadySent = [Select Id,Name,Case__c From SMS_Sent__c where Case__c in :CaseLst and Name = 'NPS Closer SMS'];
        set<Id> NPSClosedCaseIds = new set<Id>();

        for(SMS_Sent__c sms : NPSSMSAlreadySent)
        {
            NPSClosedCaseIds.add(sms.Case__c);
        } 

        boolean npsSMSflag;
        caseID = new set<ID>();
        boolean npsCatflag=false;
        boolean singleSms=false;

        StaticResource sr = [select id,body from StaticResource Where Name ='NPSExcludedTypes'];
        String contents = sr.body.toString();
        List<Case> oldCaseNps= [select ClosedDate,CaseNumber,CreatedDate,Customer_info__c,Category__c ,type__c,Sub_Type__c,origin,Loan_INFO__c , id,Loan_info__r.Loan_Number__c,Cust_Phone_Number__c,status,LastModifiedDate,NPS_Score__c, Customer_info__r.Relationship_Manager_Mobile__c
                                from case  where CUSTOMER_INFO__c =:custID AND type__c=: type AND Sub_Type__c=:subtype AND Loan_INFO__c!=null ORDER BY CreatedDate ASC]; // bug 15628: added ClosedDate
        System.debug('todays cases: '+oldCaseNps);

        Long hours;
        // 24 hours calculation logic
        Long dt1Long,dt2Long,milliseconds,seconds,minutes,days;
             //hours calculation ends        
            
        
        for(case obj: CaseLst){
            if(obj.status == 'Closed'){
                if(oldcaseNps!=null && oldcaseNps.size() > 0){
                    //forloop 1
                    for(case cs:oldcaseNps){

                        if(cs.CUSTOMER_INFO__c == obj.CUSTOMER_INFO__c && cs.Loan_INFO__c == obj.Loan_INFO__c
                        && cs.Type__c == obj.Type__c && cs.Sub_Type__c == obj.Sub_Type__c && (cs.id != obj.id && cs.status == 'Closed')){ //bug16582:Users are not able to close cases
                            if(obj.ClosedDate!=null) dt1Long = obj.ClosedDate.getTime(); // bug 15628: Added ClosedDate
                            if(cs.ClosedDate!=null) dt2Long = cs.ClosedDate.getTime(); // bug 15628: Added ClosedDate
                            if(dt2Long !=null && dt1Long!=null){
                                milliseconds = dt2Long - dt1Long;
                                seconds = milliseconds / 1000;
                                minutes = seconds / 60;
                                hours = minutes / 60;
                                days = hours / 24;
                            }   
                            System.debug('match: '+hours);
                            System.debug('case ID: '+cs.id);
                            if(Math.abs(hours) > 24 ){ // bug 15628
                                System.debug('hours: '+Math.abs(hours));
                                singleSms=true; 
                                break;

                            }//send sms
                            else{
                                /* commented for case trigger optimization if(oldcaseNps[0].id == obj.id){
                                    System.debug('One');
                                    singleSms=true; 
                                    break;
                                }else{*/
                                    System.debug('Two');
                                    singleSms=false; 
                                    break;
                                //}
                            }
                        }
                        else{
                            singleSms=true;  //send sms
                            System.debug('match Not: '+hours);
                            break;
                        }

                    }
                } else{
                    System.debug('List blank');
                    singleSms=true;  //send sms
                    //break;
                }
                //forloop 2
                //case trigger optimization
                case oldCaseValues = Trigger.oldMap.get(obj.ID); // NPS by rasika

                ProductSMS__C prodsms = new ProductSMS__C();
                prodsms = ProductSMS__C.getValues('NPS_Case_closer_SMS');

                // Add case Origin
                set<string> originSet = new Set<string>();
                string strOrigin = prodsms.Case_Origin__c;
                for(string s:strOrigin.Split(',')){
                    originSet.add(s.toUpperCase());
                }
                System.debug('origin set:'+originSet);
                string concatCTS =obj.Category__c+','+obj.Type__c+','+obj.sub_type__c;
                system.debug('CONCAT  : '+concatCTS.toUpperCase());

                if(contents!=null){
                    for(string str: contents.Split('\n')){

                        str = str.replace('[','');
                        str = str.replace(']','');

                        System.debug('New Val: '+str.toUpperCase());
                        System.debug('concatCTS.toUpperCase:'+concatCTS.toUpperCase());
                        if(concatCTS.toUpperCase() == str.toUpperCase().trim()){
                            npsCatflag=true;
                            system.debug('FLAG : '+npsCatflag);
                            break;
                        }
                    }
                }
                system.debug('npsCatflag: '+npsCatflag);
                if(obj.status =='Closed') {
                    if((!npsCatflag)&& (originSet.contains(obj.Origin.toUpperCase()))){
                        System.debug('IN  :NPS Closer Msg  sent');
                        npsflag=true;
                        caseID.add(obj.id);
                    } 

                } 
            }
            //forloop 3 
            Case oldCase = Trigger.oldMap.get(obj.Id);
            CaseOwnedHistory__c historyObj =  new CaseOwnedHistory__c();
            historyObj = mapOfCaseHistory.get(obj.Id);
            if(oldCase.OwnerId != obj.OwnerId || obj.Status == BajajFinservCRMConstants.CLOSED){
                historyObj.Lost_Ownership__c = DateTime.now(); 
                historyObj.Total_Time_Owned__c = DateTime.now().getTime() - historyObj.Got_Ownership__c.getTime();
                historyList.add(historyObj);
                if(obj.Status == BajajFinservCRMConstants.CLOSED){

                }else{
                    CaseOwnedHistory__c newHistory = new CaseOwnedHistory__c();
                    newHistory.Case__c = obj.Id;
                    if(obj.owner.type == BajajFinservCRMConstants.QUEUE_TYPE){                    
                        newHistory.Queue_Name__c = obj.Owner.Name;   
                    }else{                   
                        newHistory.User__c = obj.OwnerId;                    
                    }
                    newHistory.Got_Ownership__c = DateTime.now();
                    historyList.add(newHistory);            
                }
            }

            /*** start  - #15459  adding configurable condition for the code || NPS_Feedback_Flag ***/
            if((Label.NPS_Feedback_Flag != NULL && Label.NPS_Feedback_Flag == 'Y' ) &&   (oldCase.Status !=BajajFinservCRMConstants.CLOSED && obj.Status == BajajFinservCRMConstants.CLOSED && (obj.Origin=='Token' || obj.Origin=='Branch walk-in') && obj.Case_Opened_By_Cashier__c!=null) )
            {
                //sendsms.message(caseObj.Cust_Phone_Number__c,'Greetings from BFL! Thank you for interacting with our branch. Kindly rate us on a scale (1-3) , 1 Not satisfied  ,2 Average, 3 Highly Satisfied. Type BRANCH space your rating , send it to 9227564444');
                listmsg.add(smstext);
                contactNum.add(obj.Cust_Phone_Number__c);
            }
            /*** end  - #15459  adding configurable condition for the code || NPS_Feedback_Flag ***/

            /*** start  - #14647  adding configurable condition for the code || NPS_Feedback_Flag ***/
            //in else if, partner condition added by Suraj, policy servicing enhancement 
            else if( (Label.NPS_Feedback_Flag != NULL && Label.NPS_Feedback_Flag == 'Y' ) &&   (oldCase.Status !=BajajFinservCRMConstants.CLOSED && obj.Status == BajajFinservCRMConstants.CLOSED && oldCase.TAT__c!=null && obj.TAT__c!=null && oldCase.TAT__c > 0 && obj.TAT__c > 0  ) && obj.Origin!='Partner' )
            {
                //sendsms.message(caseObj.Cust_Phone_Number__c,'Greetings from BFL ! Your service request number '+ caseObj.CaseNumber + ' has been processed. For any further information please contact us on wecare@bajajfinserv.in ');                      
                smstext2='Greetings from BFL ! Your service request number '+ obj.CaseNumber + ' has been processed. For any further information please contact us on wecare@bajajfinserv.in ';
                listmsg.add(smstext2);
                contactNum.add(obj.Cust_Phone_Number__c);                       
                // sendsms.message(caseObj.Cust_Phone_Number__c,'We would need your feedback on effort taken for service request resolution. Type EFFORT HIGH OR EFFORT LOW and send it to 9227564444 to indicate your rating');                         
                listmsg.add(smstext3);
                contactNum.add(obj.Cust_Phone_Number__c);
            }

            // START - LAS CRM >> send sms on case closure
            //in else if, partner condition added by Suraj, policy servicing enhancement
            else if( (Label.NPS_Feedback_Flag != NULL && Label.NPS_Feedback_Flag == 'Y') && (oldCase.Status != BajajFinservCRMConstants.CLOSED && obj.Status == BajajFinservCRMConstants.CLOSED && obj.OwnerId == qId[0].id && obj.Cust_Phone_Number__c != null) && obj.Origin!='Partner')
            {
                System.debug('ani -- inside if **');
                listmsg.add('Greetings from BFL ! Your service request number ' + obj.CaseNumber + ' has been processed. For any further information please contact us on wecare@bajajfinserv.in ');
                contactNum.add(obj.Cust_Phone_Number__c);
                system.debug('ani -- listms >> ' + listmsg + ' >> cntct >>' + contactNum);
            }
            //END - LAS CRM   
            /*** End  - #14647  adding configurable condition for the code ***/
        }
        System.debug('sms test 123: '+ singleSms);
         smstobesent1= new set<ID>();  //added by Suraj ...NPS timed enhancement
         if(npsflag && singleSms && (!ControlRecursiveCallofTrigger_Util.hasNPSBottomUPMessageFlag())) {
                   ControlRecursiveCallofTrigger_Util.setNPSBottomUPMessageFlag();
                 
                 //added by Suraj ...NPS timed enhancement ...start
                 for(ID finalnps:caseID)
                 {
                     system.debug('nps case finalnps'+finalnps);
                     if(d1.hour()<startHour && d1.hour()>endHour)
                     {
                         system.debug('nps case time matched');
                         smstobesent1.add(finalnps);
                     }
                 }
                 if(smstobesent1!=null)
                 {
                     system.debug('nps case final cases'+smstobesent1);
                     NPS_send_feedback_SMS.sendCloserSms(smstobesent1);
                     //added by Suraj ...NPS timed enhancement ...end
                 }
             
             System.debug('IN NPS :after MSg sent ');
             
         }
          
        if(historyList.size() > 0){
        try{
            
                upsert historyList;
            }catch(exception e){system.debug(e+'eeeeeeeeeeeee');}
        }   
        

    
    }
   /* if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
    {
        String RBIlabel = Label.RBI_Escalations_Case_Orgin;
        List<String> OrginLst = RBIlabel.split(';');
        system.debug('originlst -->'+OrginLst);
        for(Case caseobj : CaseLst)
        {
            if(OrginLst != null && OrginLst.size() > 0 && (new Set<String>(OrginLst)).Contains(caseobj.origin) && caseobj.Customer_info__c != null)
            {
                caseobj.Customer_info__r.Is_RBI_OR_SNR_MNGR_Escalated__c = true;
            }
        }
    }*/
    
     if(listmsg.size()>0 && contactNum.size()>0)
         sendsms.sendBulkSMS(listmsg,contactNum); 
            
        if(SMSToBeSent != null && SMSToBeSent.size() > 0)
        insert SMSToBeSent;
         
}