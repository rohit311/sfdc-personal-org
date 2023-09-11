trigger SOLDedupeCheck on De_Dupe__c(after update) {
     //Added by mahima to restric integration user access- start--
    ID Pid=Userinfo.getProfileID();
    string Ids= Label.dedupe_App_restrictedUserId;
    //List<string> restrictedIds= new list<string>();
    set<string> restrictedIdsSet= new set<string>();
    if( ids!=null)
    {
        restrictedIdsSet.addAll(Ids.split(','));
    }
    if( !restrictedIdsSet.contains(Pid))
    {
      //Added by mahima to restric integration user access- end--  
    
         boolean switchforDedupe = false;
         LaonApplicationCreation__c deDupeCustSett = LaonApplicationCreation__c.getValues('de-Dupe Switch');
          if(deDupeCustSett != null && deDupeCustSett.Integrate_Charges_API__c != null)
              switchforDedupe = deDupeCustSett.Integrate_Charges_API__c;
         List < Opportunity > AppOppty = New List < Opportunity > ();
         List < SOL_Policy__c > policy = new List < SOL_Policy__c > ();
         List < De_Dupe__c > DedupeTargetrecords = new List < De_Dupe__c > ();
         List < ID > OpID = new List < ID > ();
         Id appid;
         List < Contact > contact = New List < Contact > ();
         if (!ControlRecursiveCallofTrigger_Util.hasSOLDedupeCheck()) {
          ControlRecursiveCallofTrigger_Util.setSOLDedupeCheck();
          //List < Applicant__c > app = new List < Applicant__c > ();
          List < Opportunity > OppList = new List < Opportunity > ();

          for (De_Dupe__c De: Trigger.New) {
           system.debug('**********De.Loan_Application__c' + De.Loan_Application__c);
           OpID.add(De.Loan_Application__c);
           system.debug('**********De.Applicant__c' + De.Applicant__c);
           appid = (De.Applicant__c);
           system.debug('**********appid' + appid);
          }
          if (switchforDedupe)
           OppList = [select id, StageName, product__C, (select id, Created_From_Dedupe__c from SOL_Policys__r) from Opportunity where id in : OpID];
          if (switchforDedupe) {
           for (Opportunity opp: OppList) {
            for (SOL_Policy__c sol: opp.SOL_Policys__r) {
             if (sol.Created_From_Dedupe__c == true) {
              policy.add(sol);
             }
            }
           }
          }
        //harsit----optimzation START
          //app = [select id from Applicant__c where id = : appid];
        //harsit----optimzation END
        if (!switchforDedupe){
           AppOppty = [select (select id from SOL_Policys__r where Created_From_Dedupe__c = true),id, StageName, product__C from Opportunity where id in : OpID];
           for(Opportunity opp : AppOppty){
               if(opp.Sol_Policys__r != null && opp.Sol_Policys__r.size() > 0) 
                   policy.addAll(opp.Sol_Policys__r);
           }
           
             
         } else {
           for (Opportunity opp: OppList) {
            AppOppty.add(opp);
           }
          }
          system.debug('**********AppOppty' + AppOppty);
          DedupeTargetrecords = [select id, Name, Source_Or_Target__c, Applicant__r.Contact_Name__r.ApplicantType__c, Loan_Application_Number__c, Customer_Status__c from De_Dupe__c where Source_Or_Target__c = 'target'
           and id = : trigger.new[0].id
          ];
          system.debug('**********DedupeTargetrecords ' + DedupeTargetrecords);
          if (DedupeTargetrecords.size() > 0) {

           system.debug('**********DedupeTargetrecords[0].Loan_Application_Number__c' + DedupeTargetrecords[0].Applicant__r.Contact_Name__r.ApplicantType__c);

          }
          if (AppOppty.size() > 0 && AppOppty[0].Product__c == 'SOL') {


           for (De_Dupe__c De: Trigger.new) {
            if (De.Source_Or_Target__c == 'Source' && De.Customer_Status__c == 'Bad') {
             /* De.De_Dupe_Check_Done__c=True;
              AppOppty[0].StageName='Rejected';*/
             SOL_Policy__c sp = new SOL_Policy__c();
             sp.Policy_Name__c = 'Dedupe Bad';
             sp.Policy_Status__c = 'Refer';
             sp.Loan_Application__c = AppOppty[0].id;
             sp.Created_From_Salaried__c = True;
             if (policy.size() > 0) {
              Delete policy;
             }
             Insert sp;
            }
        //harsit----optimzation START
        //commenting this code because there is no updation on the application instance
            /*if (trigger.oldmap.get(de.id).Datafix_Updated__c != de.Datafix_Updated__c && de.Datafix_Updated__c == 'Processed records')
             update app;*/
        //harsit----optimzation END
           }
          } else if (AppOppty.size() > 0 && AppOppty[0].Product__c == 'LASOL') {
           system.debug('**********Test new product LASOL');
           if (DedupeTargetrecords.size() > 0) {
            if (DedupeTargetrecords[0].Applicant__r.Contact_Name__r.ApplicantType__c == 'Primary') {

             system.debug('**********Primary');
             for (De_Dupe__c De: Trigger.new) {

              if (de.Source_Or_Target__c == 'Target' && de.Customer_Status__c == 'B') {
               system.debug('**********Test new product LASOL');
               SOL_Policy__c sp = new SOL_Policy__c();
               sp.Policy_Name__c = 'Dedupe Bad';
               sp.Policy_Status__c = 'Refer';
               system.debug('**********Dedupe Bad');
               sp.Loan_Application__c = AppOppty[0].id;
               sp.Created_From_Dedupe__c = True;
               if (policy.size() > 0) {
                Delete policy;
               }
               Insert sp;
              }
            //harsit----optimzation START
            //commenting this code because there is no updation on the application instance
            /*if (trigger.oldmap.get(de.id).Datafix_Updated__c != de.Datafix_Updated__c && de.Datafix_Updated__c == 'Processed records')
               update app;*/
            //harsit----optimzation END
             }
            }

           }


          }
         }
    }
}