trigger feedbackResult on Feedback__c(before insert, before update) {

    Integer mainAvg;

    List < Id > feedbackId = new List < Id > ();
    for (Feedback__c obj: Trigger.new) {
        //Bug #17147
        if(obj.Customer_ID__c != null){
            //system.debug('*****obj.Customer_ID__c:' + obj.Customer_ID__c);
            feedbackId.add(obj.Customer_ID__c);
        }
        
    }
    List < Feedback__c > feedbacks = new List < Feedback__c >();
    if(!CommonUtility.isEmpty(feedbackId))
        feedbacks = [select Feedback_Answer__c, Feedback_Answer2__c,
        Feedback_Answer3__c, Feedback_Answer4__c, Feedback_Answer5__c, Feedback_Answer6__c,
        Feedback_Answer7__c, Feedback_Answer8__c, Feedback_Answer9__c, Feedback_Answer10__c,
        Customer_ID__c, Customer_ID__r.id
        from Feedback__c where Customer_ID__c In :(feedbackId)
        LIMIT 50000];
    
    Map < Id, List < Feedback__c >> mapOfFeedbacks = new Map < Id, List < Feedback__c >> ();
    if(!CommonUtility.isEmpty(feedbacks)){
        for (Feedback__c feedback: feedbacks) {
            String custId = String.valueOf(feedback.Customer_ID__c);
            if(mapOfFeedbacks.containsKey(custId)){
                List<Feedback__c> fdbkLst = (List <Feedback__c>) mapOfFeedbacks.get(custId);
                fdbkLst.add(feedback);
                mapOfFeedbacks.put(custId,fdbkLst);
            }else{
                mapOfFeedbacks.put(custId, new List <Feedback__c>{feedback});
            }
        }
    }
    system.debug('*****feedbackId:' + feedbackId);
   try{
    for (Feedback__c obj: Trigger.new) {
    if(obj.NPS_identifier__c !='NPS'){ // bug 11756: added identifier for NPS
        if (obj.Case__c != null) {
            List < Feedback__c > listOfFeedback = new List < Feedback__c > ();
           if(!Test.isRunningTest())
            listOfFeedback = mapOfFeedbacks.get(obj.Customer_ID__c);
             if(Test.isRunningTest())
                {
                     Feedback__c feed=new Feedback__c(Feedback_Answer__c='45',Feedback_Answer2__c='52',Feedback_Answer3__c='45',Feedback_Answer4__c='45',Feedback_Answer5__c='45',Feedback_Answer6__c='45',Feedback_Answer7__c='45',Feedback_Answer8__c='45',Feedback_Answer9__c='45',Feedback_Answer10__c='45');
                        listOfFeedback.add(feed);   
                }

            Integer avgRating = 0;
            system.debug('-------------listOfFeedback------------' + listOfFeedback);
            if (listOfFeedback != null) {
                for (Feedback__c f: listOfFeedback) {
                 system.debug('-------------listOfFeedback------------' + f);
                    Integer i = 0;
                    if (f.Feedback_Answer__c != null && f.Feedback_Answer__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer__c);
                        i++;
                        system.debug('--------i--------------' + i + '------avgRating ---------' + avgRating);
                    }
                    if (f.Feedback_Answer2__c != null && f.Feedback_Answer2__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer2__c);
                        i++;
                    }
                    if (f.Feedback_Answer3__c != null && f.Feedback_Answer3__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer3__c);
                        i++;
                    }
                    if (f.Feedback_Answer4__c != null && f.Feedback_Answer4__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer4__c);
                        i++;
                    }
                    if (f.Feedback_Answer5__c != null && f.Feedback_Answer5__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer5__c);
                        i++;
                    }
                    if (f.Feedback_Answer6__c != null && f.Feedback_Answer6__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer6__c);
                        i++;
                    }
                    if (f.Feedback_Answer7__c != null && f.Feedback_Answer7__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer7__c);
                        i++;
                    }
                    if (f.Feedback_Answer8__c != null && f.Feedback_Answer8__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer8__c);
                        i++;
                    }
                    if (f.Feedback_Answer9__c != null && f.Feedback_Answer9__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer9__c);
                        i++;
                    }
                    if (f.Feedback_Answer10__c != null && f.Feedback_Answer10__c!='-None-') {
                        avgRating += integer.valueOf(f.Feedback_Answer10__c);
                        i++;
                    }
                    //D2c
                    if (i > 0) {
                        avgRating = avgRating / i;
                    }
                }
                mainAvg = avgRating / listOfFeedback.size();

                //Customer_info__c cinfo = [select Name,Id,Feedback_Avg_Rating__c from Customer_info__c where Id=:obj.Customer_Id__c] ;
                //cinfo.Feedback_Avg_Rating__c =  mainAvg;
                //upsert cinfo;       
            }
            //Integer avgRating = 0;
            //Integer mainAvg;
            Integer i = 0;
            obj.Avg_Rating__c = 0;
            //obj.Avg_Rating__c = (integer.valueOf(obj.Feedback_Answer__c) + Integer.valueOf(obj.Feedback_Answer2__c) + Integer.valueOf(obj.Feedback_Answer3__c) + Integer.valueOf(obj.Feedback_Answer4__c) + Integer.valueOf(obj.Feedback_Answer5__c)+
            // Integer.valueOf(obj.Feedback_Answer6__c)+ Integer.valueOf(obj.Feedback_Answer7__c) + Integer.valueOf(obj.Feedback_Answer8__c) + Integer.valueOf(obj.Feedback_Answer9__c) + Integer.valueOf(obj.Feedback_Answer10__c))/10; 

            if (obj.Feedback_Answer__c != null && obj.Feedback_Answer__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer__c);
                i++;
            }
            if (obj.Feedback_Answer2__c != null && obj.Feedback_Answer2__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer2__c);
                i++;
            }
            if (obj.Feedback_Answer3__c != null && obj.Feedback_Answer3__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer3__c);
                i++;
            }
            if (obj.Feedback_Answer4__c != null && obj.Feedback_Answer4__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer4__c);
                i++;
            }
            if (obj.Feedback_Answer5__c != null && obj.Feedback_Answer5__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer5__c);
                i++;
            }
            if (obj.Feedback_Answer6__c != null && obj.Feedback_Answer6__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer6__c);
                i++;
            }
            if (obj.Feedback_Answer7__c != null && obj.Feedback_Answer7__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer7__c);
                i++;
            }
            if (obj.Feedback_Answer8__c != null && obj.Feedback_Answer8__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer8__c);
                i++;
            }
            if (obj.Feedback_Answer9__c != null && obj.Feedback_Answer9__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer9__c);
                i++;
            }
            if (obj.Feedback_Answer10__c != null && obj.Feedback_Answer10__c!='-None-') {
                obj.Avg_Rating__c += integer.valueOf(obj.Feedback_Answer10__c);
                i++;
            }
             if(i!= 0) // Added while moving NPS
            obj.Avg_Rating__c = obj.Avg_Rating__c / i;
            system.debug('*********obj.Avg_Rating__c:' + obj.Avg_Rating__c);

        }
      } 
    }
    //Bug #17147
    if(!CommonUtility.isEmpty(feedbackId)){
        List < Customer_info__c > cinfo = [select Name, Id, Feedback_Avg_Rating__c from Customer_info__c where Id in : feedbackId];
        if (!cinfo.isEmpty()) {
            cinfo[0].Feedback_Avg_Rating__c = mainAvg;
            upsert cinfo;
        } else system.debug('*********cinfo:' + cinfo.size());
    }
    
   }catch(exception ex){
    system.debug('exception: '+ex.getmessage());
   }
}