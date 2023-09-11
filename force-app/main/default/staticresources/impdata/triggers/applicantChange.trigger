trigger applicantChange on Applicant__c (after insert,after update,Before update,before insert) { //Bug:23567 Added before insert) {
     List<id> LoanIdsMob= new List<Id>(); //Retrigger 20939
    static Set<id> LoanIdsSet = new Set<id>(); // 24313
     static List<Opportunity> oppLstSt;// 24313
    system.debug('inside appChange');
    system.debug('isUpdate='+Trigger.isUpdate);
    //Added by mahima to restric integration user access- start--
    ID Pid=Userinfo.getProfileID();
    string Ids= Label.dedupe_App_restrictedUserId;
    //List<string> restrictedIds= new list<string>();
    set<string> restrictedIdsSet= new set<string>();
    //Bug:23567**Start**Karvy Enhancement
    if(Label.Enable_new_flow_for_sourcing_Channel.equalsIgnoreCase('TRUE')){
        if(Trigger.isInsert && Trigger.isBefore){
            //createApproveLoanforSourcingChannel src = new createApproveLoanforSourcingChannel();
            createApproveLoanforSourcingChannel.autoCreateLoanforSourcingChannel(Trigger.new);
        }
        if(Trigger.isInsert && Trigger.isAfter){
            createApproveLoanforSourcingChannel.insertDedupeForSourcingChannel(Trigger.new);
        }
    }
    //Bug:23567**End**Karvy Enhancement
    if( ids!=null)
    {
        restrictedIdsSet.addAll(Ids.split(','));
    }
    if( !restrictedIdsSet.contains(Pid))
    {
      //Added by mahima to restric integration user access- end--  
        if(Trigger.isUpdate)
        {
            system.debug('New='+trigger.new +'OLd='+trigger.old);
        
            system.debug('Condition val =' + ControlRecursiveCallofTrigger_Util.hasapplicantChangeT());
        }
        if (!ControlRecursiveCallofTrigger_Util.hasapplicantChangeT()) 
        {
            ControlRecursiveCallofTrigger_Util.setapplicantChangeT();   

            ID Pid=Userinfo.getProfileID();
            system.debug('Profle Id'+Pid);
            integer forcount=0;
            integer primecount=0;
            if(Pid!='00e90000000tgyE' && pid!='00e90000000nWfu')
            {
                System.debug('Inside if');
                Map<Id,String> primaryApplicantMap = new Map<Id,String>();
                List<account> AccountList = new List<account>();
                List<Contact> updatedContactList = new List<Contact>();
                Opportunity opp;

                for(Integer i=0;i<trigger.new.size();i++)
                {
                    System.debug('Inside for');
                    if(primaryApplicantMap.containsKey(trigger.new[i].loan_application__c) && trigger.new[i].Applicant_Type__c!= null && trigger.new[i].Applicant_Type__c.contains('Primary'))
                    {
                        // trigger.new[i].addError('There are multiple primary applicants');           
                    }
                    else
                    {    
                        if(trigger.new[i].Applicant_Type__c != null && trigger.new[i].Applicant_Type__c.contains('Primary'))    
                            primaryApplicantMap.put(trigger.new[i].loan_application__c,trigger.new[i].Applicant_Type__c);
                    }
                    
                    system.debug('isUpdate='+Trigger.isUpdate);
                    system.debug('New='+trigger.new );
                    system.debug('OLd='+trigger.old);
                    
                    // Change in applicant type
                    System.debug('Trigger update::'+Trigger.isUpdate);
                   
                    if(Trigger.isUpdate && trigger.new[i].Applicant_Type__c != trigger.old[i].Applicant_Type__c
                        /*&& trigger.new[i].Product__c.contains('SBS')*/)
                    {
                        //changedApplicantsList.add(trigger.new[i]);
                        Contact contact = new Contact(id = trigger.new[i].Contact_Name__c,
                        ApplicantType__c = trigger.new[i].Applicant_Type__c);
                        updatedContactList.add(contact); 
                          if(trigger.new[i].Applicant_Type__c != null){  
                              if( trigger.new[i].Applicant_Type__c.contains('Primary'))
                                {
                                    opp = new Opportunity(id = trigger.new[i].loan_application__c);
                            }    } 
                    }
                }
                /**
                for(Integer ii=0;ii<trigger.new.size();ii++){
                forcount=forcount+1;
                if(trigger.new[ii].Applicant_Type__c != null && trigger.new[ii].Applicant_Type__c.contains('Primary')){
                primecount=primecount+1;
                }
                if(forcount >1){
                if(primecount >1){
                trigger.new[ii].addError('There are multiple primary applicants');}
                }
                system.debug('find next time');
                }**/

                if(updatedContactList.size()>0)
                {
                    upsert updatedContactList;
                    Set<Id> primaryContactIds = new Set<Id>();    
                
                    for(Contact con:updatedContactList)
                    {
                        if(con.ApplicantType__c == 'Primary')
                        {
                            primaryContactIds.add(con.id);
                        }
                    }   
                    
                    System.debug('updatedContactList$$'+updatedContactList);    
                    List<Contact> contactLst = [select id,name,firstname,lastname,Type_Of_Constitution__c,
                    Date_of_Birth__c,Marital_Status__c,Middle_Name__c,Address_1st_Line__c,
                    Regi_Address_2nd_Line__c,Regi_Address_3rd_Line__c,Address_1__c,Address_2__c,
                    Address_3__c,accountid,
                    account.sourcing_channel__c from Contact where id in :primaryContactIds];

                    for(Contact con:updatedContactList)
                    {
                        if(con.ApplicantType__c == 'Primary')
                        {
                            Account account = new Account( 
                            id = contactLst.get(0).accountid,               
                            name = contactLst.get(0).name,
                            Last_Name__c = contactLst.get(0).lastname,
                            First_Name__c = contactLst.get(0).firstname,
                            Type_of_Constitution__c = contactLst.get(0).Type_Of_Constitution__c,
                            Date_of_Birth__c = contactLst.get(0).Date_of_Birth__c,
                            Marital_Status__c = contactLst.get(0).Marital_Status__c,
                            Middle_Name__c = contactLst.get(0).Middle_Name__c,
                            Address_1st_Line__c = contactLst.get(0).Address_1st_Line__c,
                            Address_2nd_Line__c = contactLst.get(0).Regi_Address_2nd_Line__c,
                            Address_3rd_Line__c = contactLst.get(0).Regi_Address_3rd_Line__c,
                            /*Current_Residence_Address1__c = con.Residence_Address_1__c,
                            Current_Residence_Address2__c = con.Residence_Address2__c,
                            Current_Residence_Address3__c = con.Residence_Address_3__c*/
                            Current_Residence_Address1__c = contactLst.get(0).Address_1__c,
                            Current_Residence_Address2__c = contactLst.get(0).Address_2__c,
                            Current_Residence_Address3__c = contactLst.get(0).Address_3__c,
                            sourcing_channel__c = contactLst.get(0).account.sourcing_channel__c);
                            AccountList.add(account);

                            opp.name = contactLst.get(0).name;
                        }    
                    } 
                }
                
                if(accountList.size()>0)
                    upsert accountList;
                
                System.debug('Opportunity name'+opp);    
                if(opp != null)
                {        
                    upsert opp; 
                    System.debug('Opp Name'+opp.name);   
                }           
            }
            if(trigger.isUpdate && Trigger.isAfter){
        /*Retrigger BRE 20939 s */
        for(Applicant__c cam:trigger.new){
            LoanIdsMob.add(cam.Loan_Application__c);
          LoanIdsSet.add(cam.Loan_Application__c);//24313
            }
            
            Map<Id, Opportunity> oppMap;
            System.debug('loanIDs'+LoanIdsMob);
            if(!CommonUtility.isEmpty(LoanIdsSet)){
           /*    oppLst = [select Account.Flow__c,id,Account.Offer_Inhanced__c, product__C,Account.IS_OTP_FLOW__c, CreatedDate,
                                            (select id,name,Old_Loan_Application__c,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policys__r),
                                            (Select  id,product__c,Type_of_Year__c from PLBS__r where Type_of_Year__c='Current' or Type_of_Year__c='Previous' or Type_of_Year__c='PrevSummary' or Type_of_Year__c='CurrSummary')
                                            from Opportunity where id in : LoanIdsMob]; */
               oppLstSt = GeneralUtilities.getOpportunities(LoanIdsSet);//Bug 24313
                List<Opportunity> oppLst = oppLstSt;//24313 
                if(!CommonUtility.isEmpty(oppLst)){
                    oppMap = new Map<Id, Opportunity>();
                    for(Opportunity opp : oppLst)
                        oppMap.put(opp.Id,opp);
                }
                System.debug('Yes'+oppMap);
            }
            Map<String,Object> allMap = new Map<String,Object>();
            allMap = GeneralUtilities.fetchRetriggerRescMap();
            Map<String,SOL_Policy__c> solPolicyToUpdateMap = new map<String,SOL_Policy__c>();
            for(Applicant__c cam:trigger.new){
                System.debug('Applicant::'+cam);
                Opportunity Loan = new Opportunity();
                if(oppMap != null && oppMap.containsKey(cam.Loan_Application__c) && oppMap.get(cam.Loan_Application__c) != null){
                    Loan = oppMap.get(cam.Loan_Application__c);
                }
                
                    system.debug('in mobility'+Loan.Account.Flow__c);
                    if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
                        Map<String, SOL_Policy__c> solPolicyMAPToUpdate=new Map<String, SOL_Policy__c>();
                        Map<String,Object> appFields = new Map<String,Object>();
                        if(!commonutility.isEmpty(allMap)){
                            appFields = (Map<String,Object>)ALLMap.get('Applicant__c');
                            System.debug('Hi'+appFields );
                            if(!commonutility.isEmpty(appFields)){
                                solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(Trigger.oldmap.get(cam.Id),cam,Loan,appFields,solPolicyToUpdateMap);
                            }
                        }
                    }
                }
                if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() > 0){
                      update solPolicyToUpdateMap.values();  
                }
            }
            /*Retrigger BRE 20939 e */
        }
        //Deepak-- Service Guarantee Phase 2
        //Following code will update the EKYC_for_time__c and Off_mail_date__c field
        if(trigger.isUpdate && Trigger.isBefore){
            for(Applicant__c applicant: trigger.new ){
                if(applicant.Product__c != null && GeneralUtilities.servGuaranteeProd(applicant.Product__c)){
                    if(applicant.EKYC_for_time__c == null && applicant.eKYC_Processing__c == true){
                         applicant.EKYC_for_time__c = datetime.now();
                    }    
                     if(applicant.Office_Email_Id_Verified__c == True && applicant.Off_mail_date__c == null){
                         applicant.Off_mail_date__c = datetime.now();
                    }
                }    
            }
        }
        
        }
        
        //bug 17820
        for(Integer i=0;i<trigger.new.size();i++)
        {
            if(!Commonutility.isEmpty(trigger.new) && !Commonutility.isEmpty(trigger.old) && trigger.new[i].Applicant_Type__c != null && trigger.old[i].Applicant_Type__c != null)  {
                if(Trigger.isUpdate && Trigger.isBefore && trigger.new[i].Applicant_Type__c != trigger.old[i].Applicant_Type__c && !trigger.new[i].Applicant_Type__c.equals('Primary') && trigger.old[i].Applicant_Type__c.equals('Primary') )
                {
                    for(applicant__c app: trigger.new){
                        app.Submitted_to_Branch_Ops__c = null;
                        app.File_Inward_Time__c = null;
                        app.PNW_Barcode__c =  null;
                        app.Initial_Submitted_to_Branch_Ops__c = null;
                        app.TCS_Outward__c = null;
                        app.File_Scanning__c = null;
                    }
                }
            }
        
    }
}