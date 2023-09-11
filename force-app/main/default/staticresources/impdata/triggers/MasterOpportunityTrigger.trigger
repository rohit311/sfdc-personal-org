trigger MasterOpportunityTrigger on Opportunity(
    before insert, after insert, 
    before update, after update 
    ) 
{

System.debug('\n\n\t  ---------- In MasterOpportunityTrigger Start ----------------------------- \n\n');

 if((ATOSParameters__c.getValues('NewOpportunityTriggerFlow') == null) || (ATOSParameters__c.getValues('NewOpportunityTriggerFlow') != null && ATOSParameters__c.getValues('NewOpportunityTriggerFlow').NewTriggerOptimizationFlow__c == true)){ 
    List<Opportunity> lstNewOppRecs = Trigger.New;
    List<Opportunity> lstOldOppRecs = Trigger.Old;
    Map<Id,Opportunity> mapNewOppRecs = Trigger.NewMap;
    Map<Id,Opportunity> mapOldOppRecs = Trigger.OldMap;
    ID pId = Userinfo.getProfileID();
    
    // Start of optimization changes - niraj
    //OpportunityTriggerUtilities oppUtility = new OpportunityTriggerUtilities(lstNewOppRecs, lstOldOppRecs, mapNewOppRecs, mapOldOppRecs, pId);
    OpportunityTriggerUtilities oppUtility;
    // End of optimization changes - niraj
    
    system.debug('Insert flag --> ' + ControlRecursiveCallofTrigger_Util.hasOpportunityTriggerInsertFlag());
    system.debug('Update flag --> ' + ControlRecursiveCallofTrigger_Util.hasOpportunityTriggerUpdateFlag());
    
     //US:30716**S**
    
     if(Trigger.isAfter && Trigger.isUpdate){
         String stageNames = Label.loan_stage_for_dedupe_retrigger;
     	 system.debug('Stage names****'+stageNames);
         if(!ControlRecursiveCallofTrigger_Util.getrestrictApplicant() && !CommonUtility.isEmpty(lstNewOppRecs) &&!CommonUtility.isEmpty(lstOldOppRecs)
			&& lstNewOppRecs[0].Product__c == 'FAS'	&& lstOldOppRecs[0].StageName =='Branch Ops'
            && lstNewOppRecs[0].StageName!= lstOldOppRecs[0].StageName && string.isNotBlank(stageNames) && 
            stageNames.contains(lstNewOppRecs[0].StageName) && Label.Sourcing_Channel.contains(lstNewOppRecs[0].Sour_Channel_Name__c)){
            system.debug('Inside if****');
            createApproveLoanforSourcingChannel.retriggerDedupeForFAS(lstNewOppRecs);
            ControlRecursiveCallofTrigger_Util.setrestrictApplicant();
            }
     }
     //US:30716**E**
    if (Trigger.isBefore)
    {
        system.debug('Trigger.isInsert >>>>>> '+Trigger.isInsert+' Trigger.isUpdate >>> '+Trigger.isUpdate);
        if (Trigger.isInsert && (!ControlRecursiveCallofTrigger_Util.hasOpportunityTriggerInsertFlag()))
        {
            // Start of optimization changes - niraj 
            oppUtility = new OpportunityTriggerUtilities(lstNewOppRecs, lstOldOppRecs, 
                                                               mapNewOppRecs, mapOldOppRecs, 
                                                               true, false, false,
                                                               pId);
            // End of optimization changes - niraj
            
            // Call class logic here!
            oppUtility.generateExternalId();
            if(pId!='00e90000000tgyE' && pId!='00e90000000nWfu')
            {
                oppUtility.salesHierarchyStamping();
            }
           // oppUtility.crisilSendSMS();
           // Start of Insurance Loan Application changes
            oppUtility.SalesStampingInsuranceLoan();
            // End of Insurance Loan Application changes
        } 
        if (Trigger.isUpdate && (!ControlRecursiveCallofTrigger_Util.hasOpportunityTriggerUpdateFlag()))
        {
            // Start of optimization changes - niraj 
            oppUtility = new OpportunityTriggerUtilities(lstNewOppRecs, lstOldOppRecs, 
                                                         mapNewOppRecs, mapOldOppRecs, 
                                                         true, true, false,
                                                         pId);
            // End of optimization changes - niraj
            
            // Call class logic here!
            oppUtility.generateExternalId();
            if(pId!='00e90000000tgyE' && pId!='00e90000000nWfu')
            {
                 oppUtility.SBS_LoanApprovalOwnerChange();
                 oppUtility.primaryApplicantType();
                 oppUtility.opptAuther();
                 oppUtility.deviationDelete();
                 oppUtility.salesHierarchyStamping();
                 oppUtility.updatePendingStatus();
                 oppUtility.salesApprovers();
            }
            oppUtility.stageToApprovePaid();
            oppUtility.apexBasedSharingForOppBU();
            oppUtility.beforeUpdateOT();
            oppUtility.crisilSendSMS();
            system.debug('calling this method');
            oppUtility.loanApprovers_BU_Trg();
            
            // Start of Insurance Loan Application changes
            oppUtility.CreditStampingInsuranceLoan();
            // End of Insurance Loan Application changes
            
            // Start of Insurance Loan Application changes
            oppUtility.updateInsuranceWallet();
            // End of Insurance Loan Application changes
            
        }
        if (Trigger.isDelete)
        {
            // Call class logic here!
        }
    }
    List<String> PANno = new List<String>();
    List<String>VoterID = new List<String>();
    List<Decimal>Mobile = new List<Decimal>();
    List<String>Name = new List<String>();
    String StrID=' ';
    List<Date>DOB = new List<Date>();
    List<User> usr;
    Set<ID>OppyID = new Set<ID>();
    list<ID>resowner = new list<ID>();
    list<ID>offowner = new list <ID>();
    Boolean BoolWIP=False,BoolNonWIP=False,BoolSHOL=false;
    List<SOL_Policy__c> solPolicyupdate = new List<SOL_Policy__c>();
    List<String> CompDOM = new List<String>(); 
    List<String>AddoPin = new List<String>();
    List<String>Passportno = new List<String>();
    List<String>Email = new List<String>(); 
    List<String>NameAdd = new List<String>();
    List<String>NameTelePhone = new List<String>();
    List<String>NameDaOB = new List<String>();
    List<String>Driving= new List<String>();
    List<Decimal>BankAccno = new List<Decimal>();
    map<string,id> creditmap=new map<string,id>();
    List<Applicant__c> RejAppy = new List<Applicant__c>();
    List<Opportunity> OldOppy = new List<Opportunity>();
    List<Opportunity> OldOppyWIP = new List<Opportunity>();
    /********Variables For Internal Dedupe Ends************/
    List<Deviation_Transaction__c> dt = new List<Deviation_Transaction__c>();
    List<User> UnderFinID= new List<User>();
    List<SOL_CAM__c> SOLCAM = new List<SOL_CAM__c>();
    List<ID>ResiID = new List<ID>();
    List<ID>OffID = new List<ID>();
    List<ID>TeleID = new List<ID>();
    List<ID>TradeID = new List<ID>();
    List<Verification__c> InsVerify = new List<Verification__c>();
    List<Applicant__c> apps= new List<Applicant__c>(); 
    List<Applicant__c> applist= new List<Applicant__c>(); 
    list<Credit_Officer_Limit__c> creditlist= new list<Credit_Officer_Limit__c>();
    List<Verification_Agency_Master__c> vam = new List<Verification_Agency_Master__c>();
    List<ID> oppID = new List<ID>();
    List<String>OppLocation= new List<String>();
    List<Contact> Cont = new List<Contact>();
    List<Verification__c> listOfOldVerification =  new List<Verification__c>(); 
    boolean Payment= false,FinalAmt=False,CustomerSelectData=False;
    set<id> contId=new set<id>();
    Set<String> prods = new Set<String>();
    if(trigger.isBefore && trigger.isUpdate){
        System.debug('In -- trigger.isBefore && trigger.isUpdate -- ');
        for(opportunity o : trigger.new){
            //System.debug(' :: opp : '+o);
            oppID.add(o.id);
            OppLocation.add(o.Branch_City__c);
            //Rohit removed query to inner if 19699 & 19709
           /*List<Salaried__c> salObjList = [SELECT Id,ASM_SM_Name__c,Telecaller_PSF_Name__c,Self_Sourcing__c, Percentage_Completion__c FROM Salaried__c WHERE Loan_Application__c=: o.Id];*/
            //system.debug('oppppp->'+opp.Product__c.touppercase());
            //stage to centralized underwritting start
            system.debug('o.StageNAme----->'+o.StageNAme);
            if((o.Product__c!='SOL' && o.StageNAme!='Centralized Underwriting' && o.StageNAme!='Branch CPA - Doc Check' && o.StageNAme!='Centralized CPA-Doc Check' && o.StageNAme!='Centralized Underwriting Final') || (o.Product__c=='SOL'  && o.StageNAme!='Centralized CPA-Doc Check' && o.StageNAme!='Centralized Underwriting Final')){
                if((o.Product__c=='SOL' || prods.contains(o.Product__c.toUpperCase()))  && (o.Payment_Successful__c==true) &&  o.StageName=='Auto Approved Accepted'){
                    System.debug('*****making Auto Approved Paid');
                    o.StageName='Auto Approved Paid';
                    
                    o.Approval_Stages__c='Auto Approved Paid';
                    o.RecordTypeID='01290000000Hh9X'; //Production RecId: 01290000000eGCE
                }// Auto approve Paid Stage
                else if((o.Product__c=='SOL' || prods.contains(o.Product__c.touppercase()))&&  o.StageName=='Auto Approved Paid' && (o.Payment_Successful__c==True)){
                    System.debug('*****making Centralized Underwriting');
                    //Rohit added query 19699 & 19709
                       List<Salaried__c> salObjList = [SELECT Id,ASM_SM_Name__c,Telecaller_PSF_Name__c,Self_Sourcing__c, Percentage_Completion__c FROM Salaried__c WHERE Loan_Application__c=: o.Id];
                       If(!CommonUtility.isEmpty(salObjList) && !CommonUtility.isEmpty(salObjList[0].Percentage_Completion__c) && (salObjList[0].Percentage_Completion__c== '100' || salObjList[0].Percentage_Completion__c== '100%')){
                        o.StageName='Centralized Underwriting';
                        if(o.Product__c!='SHOL'){ 
                            UnderFinID=[Select Id,Profile.Name from User where (Product__c includes('SOL') OR (Product__c includes (:o.product__c))) and ProfileId=:'00e90000000qwYZ' and IsActive=true Limit 1];  // Centralized Underwriting
                            //o.StageName='Centralized Underwriting';
                            o.Approval_Stages__c='Centralized Underwriting';
                            o.RecordTypeID='01290000000Hh9X'; //Production RecId: 01290000000eGCE
                        }else{
                                
                            UnderFinID=[Select Id,Profile.Name from User where (Product__c includes('SHOL') ) and (Branch_City__c includes(:o.Branch_City__c)) and ProfileId=:'00e90000000qwYZ' and IsActive=true Limit 1];  // Centralized Underwriting
                            ControlRecursiveCallofTrigger_Util.setalreadyExecutedProcessFlow();
                        }
                        system.debug('====> user'+UnderFinID.size());
                        if(UnderFinID.size()>0){
                            system.debug('====> user'+UnderFinID.size());
                            o.OwnerID=UnderFinID[0].id;
                            o.Approver__c=UnderFinID[0].Profile.Name;
                        }
                        system.debug('%%%%%%%%%Inside%%%%%%%%'+ResiID.size());
                    }
                }
        
            }
        //stage to centralized underwritting end
        
        //Bug 17001 - SM , PSF and SS tagging mandatory DG START
        if(o.Product__c=='SHOL'  && trigger.oldmap.get(o.Id).StageName == 'Branch CPA - Doc Check' && o.StageName == 'Centralized Underwriting Final'){
                //Rohit added query 19699 & 19709
                List<Salaried__c> salObjList = [SELECT Id,ASM_SM_Name__c,Telecaller_PSF_Name__c,Self_Sourcing__c, Percentage_Completion__c FROM Salaried__c WHERE Loan_Application__c=: o.Id];
                if(!CommonUtility.isEmpty(salObjList) && CommonUtility.isEmpty(salObjList[0].Self_Sourcing__c) 
            && CommonUtility.isEmpty(salObjList[0].ASM_SM_Name__c) && CommonUtility.isEmpty(salObjList[0].Telecaller_PSF_Name__c))
                o.addError('Kindly add the ASM/PSF/Self Sourcing details to proceed further');
            }
        //Bug 17001 - SM , PSF and SS tagging mandatory DG END
        
            //System.debug(' ** opp : '+o);
        }
        
    }
    OpportunityTriggerUtilities.oppRelatedObjectsMap1New = null;
    OpportunityTriggerUtilities.oppRelatedObjectsMap2New = null;
    OpportunityTriggerUtilities.oppRelatedObjectsMap3New = null;
    if (Trigger.IsAfter)
    {
        System.debug('In -- Trigger.IsAfter --');
        //Bug:23567**S
         if ((Trigger.isUpdate || Trigger.isInsert)){
         for(Opportunity opp : Trigger.New){
           if(Label.Enable_new_flow_for_sourcing_Channel.equalsIgnoreCase('TRUE') && opp.Sourcing_Channel__c != null &&  Label.Sourcing_Channel.containsIgnoreCase(opp.Sour_Channel_Name__c) && 
             (opp.Approval_Stages__c!=null && ((opp.Approval_Stages__c == 'Approved' && opp.StageName == 'Branch Ops') || (opp.StageName == 'Rejected' && opp.Approval_Stages__c == 'Rejected'))) //US: 30716 Added branch ops stage check
             && (mapOldOppRecs!= null && opp.StageName != mapOldOppRecs.get(opp.Id).StageName)){
              //createApproveLoanforSourcingChannel src = new createApproveLoanforSourcingChannel();
              system.debug('calling sanction letter method****');
              createApproveLoanforSourcingChannel.postAPIResponseANDSendSanctionLetter(trigger.new,trigger.oldMap);
            }
            }
         }//Bug:23567**E
        if (Trigger.isInsert && (!ControlRecursiveCallofTrigger_Util.hasOpportunityTriggerInsertFlag()))
        {
            ControlRecursiveCallofTrigger_Util.setOpportunityTriggerInsertFlag();
            system.debug('Insert flag --> ' + ControlRecursiveCallofTrigger_Util.hasOpportunityTriggerInsertFlag());
            // Start of optimization changes - niraj 
            oppUtility = new OpportunityTriggerUtilities(lstNewOppRecs, lstOldOppRecs, 
                                                         mapNewOppRecs, mapOldOppRecs, 
                                                         true, true, true,
                                                         pId);
            // End of optimization changes - niraj
           
            // Call class logic here!
            if(pId!='00e90000000tgyE' && pId!='00e90000000nWfu')
            {
                oppUtility.createDeviation();
                oppUtility.insertTAT();
                oppUtility.calling_sms_cls_trg();
                //oppUtility.afterInsertOT();
            }
            oppUtility.apexBasedSharingForOppAI();
            oppUtility.apexSharingRules();
            oppUtility.OppRecordSharing();  // Bug 13112 fix start (PO conversion)
            
          
        } 
        if (Trigger.isUpdate && (!ControlRecursiveCallofTrigger_Util.hasOpportunityTriggerUpdateFlag()))
        {
            ControlRecursiveCallofTrigger_Util.setOpportunityTriggerUpdateFlag();
            system.debug('Update flag --> ' + ControlRecursiveCallofTrigger_Util.hasOpportunityTriggerUpdateFlag());
            
            // Start of optimization changes - niraj 
            oppUtility = new OpportunityTriggerUtilities(lstNewOppRecs, lstOldOppRecs, 
                                                         mapNewOppRecs, mapOldOppRecs, 
                                                         true, true, true,
                                                         pId);
            // End of optimization changes - niraj
            
            // Call class logic here!
            if(pId!='00e90000000tgyE' && pId!='00e90000000nWfu')
            {
                system.debug('Inside class call');
                oppUtility.updateTAT();
                oppUtility.calling_sms_cls_trg();
            }
            //SAL Line 11695 Assignment S
         //   oppUtility.createPOLeadLine();
            //SAL Line 11695 Assignment E
            oppUtility.apexBasedSharingForOppAU();
            oppUtility.apexSharingRules();
            //oppUtility.afterUpdateOT();
            oppUtility.lasComboCreation();
            oppUtility.primaryApplicantType_B2C();
           oppUtility.retriggerBRE();  /*<-- Retrigger BRE added by 20939 s */
            System.debug('in trigger');
            oppUtility.primaryApplicantType_StampDutyAutomation();
          oppUtility.OppRecordSharing();  // Bug 13021 fix start 
        }
        if (Trigger.isDelete)
        {
            // Call class logic here!
        }
    }
    //Deepak-Service Guarantee Phase 2 start
    if(Trigger.IsAfter){
        Boolean serviceSAL = false;
        String templateName;
        String fromName = 'noreply@bajajfinserv.in';
        String replyTo = 'otpofficeemailverification@6hifw8v4ew6qa26r5whiw37rq2yorch4vylpptp0njgfwqxjc.o-51mo2mam.cs5.apex.sandbox.salesforce.com';
        String[] toAddress = new List<String>();
        String[] CCAddress = new List<String>();
        String[] bccAddress = new List<String>();
        system.debug('::Service Guarantee Phase 2:: (MASter opp Trigger)');
        if(Trigger.New != null && !Trigger.new.isEmpty()){
        for(Opportunity oppObj : trigger.new ){
          if((GeneralUtilities.servGuaranteeProd(oppObj.Product__c)) && (oppObj.StageName == 'Approved' || oppObj.StageName == 'Rejected' || oppObj.StageName == 'Sales Reject')) {
           serviceSAL = true;
          }
        }
        }
        if(serviceSAL == true){
            List<Bank_Account__c> listBankAcc = [select Perfiod_done_date_and_Time__c, Loan_Application__c,Applicant__r.Applicant_Type__c,Applicant__r.TimeFirstAction__c,Applicant__r.TimeTakenDecision__c,Perfios_Flag__c
                 from Bank_Account__c where Loan_Application__c In :trigger.new and Applicant__r.Applicant_Type__c = 'Primary'];
            if(trigger.isInsert){  //Condition work for MCP Rejection
                for(Opportunity oppObj : trigger.new ){
                    for(Bank_Account__c bankTemp:listBankAcc){
                        if(bankTemp.Loan_Application__c == oppObj.id){
                            GeneralUtilities.updateTimeFirstAction(bankTemp.Applicant__r);
                            GeneralUtilities.updateTimeForDecision(bankTemp.Applicant__r,bankTemp);
                            system.debug('::Time Stamped::');
                        }
                    }
                }
            }
              if(trigger.isUpdate && Trigger.New != null && !Trigger.new.isEmpty()){  
               for(Opportunity oppObj : trigger.new ){
                       for(Bank_Account__c bankTemp : listBankAcc){
                            if(bankTemp.Loan_Application__c == oppObj.id){
                                GeneralUtilities.updateTimeFirstAction(bankTemp.Applicant__r);
                                GeneralUtilities.updateTimeForDecision(bankTemp.Applicant__r,bankTemp);
                                system.debug('::Time Stamped::');
                                if(oppObj.stageName=='Approved' && bankTemp.Perfios_Flag__c == true && !ControlRecursiveCallofTrigger_Util.hasSGemailsent()){
                                    System.debug('##APPROVE MAIL SEND .. 1');
                                    templateName = 'Service Guarantee Approved';
                                    if(oppObj.Customer_email_id__c!=null){
                                        toAddress.add(oppObj.Customer_email_id__c);
                                        GeneralUtilities.SendEmailUsingBAFLLogix(templateName ,oppObj.id,fromName,replyTo,toAddress,CCAddress,bccAddress ,'Normal','Loan Approved Mail.','bajaj');   
                                        System.debug('##APPROVE MAIL SEND .. 2');
                                        ControlRecursiveCallofTrigger_Util.setSGemailsent();
                                    }
                                }
                                if(oppObj.stageName=='Rejected' && bankTemp.Perfios_Flag__c == true && !ControlRecursiveCallofTrigger_Util.hasSGemailsent() && Label.RejectionEmailSwitch != null && Label.RejectionEmailSwitch.equalsIgnoreCase('true')){ //Added label for ad hoc 21217 & 20825 Rohit
                                    System.debug('##REJECTED MAIL SEND');
                                    System.debug('##REJECTED MAIL SEND .. 1');
                                    templateName = 'Service Guarantee Rejected';
                                    System.debug('###customer email id'+oppObj.Customer_email_id__c);
                                    if(oppObj.Customer_email_id__c!=null){
                                        toAddress.add(oppObj.Customer_email_id__c);
                                        system.debug('tototot'+toAddress);
                                        GeneralUtilities.SendEmailUsingBAFLLogix(templateName ,oppObj.id,fromName,replyTo,toAddress,CCAddress,bccAddress ,'Normal','Loan Rejected Mail.','bajaj');   
                                        System.debug('##REJECTED MAIL SEND .. 2');
                                        ControlRecursiveCallofTrigger_Util.setSGemailsent();
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
    //Deepak- Service Guarantee Phase 2 end
    
    /********Variables For Internal Dedupe Starts************/
    
    
    prods.addAll(label.digitalProducts.toUppercase().split(','));
    
    if(Trigger.New != null && !Trigger.new.isEmpty() && Trigger.New[0].Product__c=='SHOL' )
     {
        prods.add('SHOL');
        BoolSHOL=true;
    }
    
    
    
    if(!(trigger.isbefore && trigger.isInsert)) {
    
    //prods.add('SOL');
    //String TeleVMailId {get;set;}
    //String TradeVMailId {get;set;}
    
    
    //Variables for Digital Grid
    List<Salaried__c> SalList = new List<Salaried__c>();
    
    // for fraud requirement.
    if (!ControlRecursiveCallofTrigger_Util.hasoppcontupdate() && trigger.isafter)
    {
        ControlRecursiveCallofTrigger_Util.setoppcontupdate();
        if(trigger.isupdate)
        {
            system.debug('Opp id****'+oppID);
            apps=[select id,Contact_Name__r.id,Loan_Application__c from Applicant__c where Loan_Application__c in: oppID and Applicant_Type__c='Primary'];
            
            for(Applicant__c apppp:apps)
            {
                if(trigger.oldmap.get(apppp.Loan_Application__c).Repayment_Bank_Name__c!=trigger.newmap.get(apppp.Loan_Application__c).Repayment_Bank_Name__c )
                {
                    contId.add(apppp.Contact_Name__r.id);
                }
            }
            // code for applicant
            if(!contId.isempty())
            {
                Cont=[select id from contact where id=:contId];
                if(!Cont.isempty())
                {
                        update Cont;
                }      
            }    
        }
        
    }
     
     if(Trigger.New != null && !Trigger.new.isEmpty())
    {
   if (!ControlRecursiveCallofTrigger_Util.hasSolPolicyLoan() && !ControlRecursiveCallofTrigger_Util.hasAlreadyExecutedProcessFlow() && (Trigger.New[0].Product__c=='SOL' || prods.contains(Trigger.New[0].Product__c.touppercase())) && trigger.isbefore) 
        {   
    
        ControlRecursiveCallofTrigger_Util.setalreadyExecutedProcessFlow();
        if(!CommonUtility.isEmpty(trigger.new[0].id)){
            // Internal Dedupe Check for Online Salaried Phase 2
            Solcam =[select id,Monthly_Net_Salary__c,Payment_Successful__c,Final_Loan_Amount_For_Tennor12__c,Final_Loan_Amount_For_Tennor24__c,Final_Loan_Amount_For_Tennor36__c,Final_Loan_Amount_For_Tennor48__c,Final_Loan_Amount_For_Tennor60__c,Loan_Amount_Selected_by_Customer__c,Tenure_Selected_By_Customer__c from sol_cam__c where loan_Application__c =:trigger.new[0].id];
            //Changes start for centralized Underwritting
             
            if(SOLCAM.size()>0){
                for(SOL_CAM__c sol : SOLCAM){
                    if(sol.Payment_Successful__c==True)
                    Payment= True;
                    if(sol.Final_Loan_Amount_For_Tennor12__c != null && sol.Final_Loan_Amount_For_Tennor24__c!=null && sol.Final_Loan_Amount_For_Tennor36__c!=null && sol.Final_Loan_Amount_For_Tennor48__c!=null && sol.Final_Loan_Amount_For_Tennor60__c!=null)
                        FinalAmt = True;
                    if(sol.Loan_Amount_Selected_by_Customer__c!=null && sol.Tenure_Selected_By_Customer__c!=null)
                        CustomerSelectData=true;
                }
            }
        }
        
        apps=[select id,name,Contact_Name__r.FirstName,Contact_Name__r.Middle_Name__c,ROC_Regn_No__c,Contact_Name__r.LastName,PAN_Number__c,PAN_Check__c,ROC_Check__c,CA_Check__c,
        Re_Initiate_De_Dupe__c,Contact_Name__r.Office_Email_Id__c,Contact_Name__r.Driving_License_Number__c,Integrate_with_CIBIL__c,Contact_Name__c,
        Contact_Name__r.Address_1st_Line__c,Contact_Name__r.Regi_Address_2nd_Line__c,
        Contact_Name__r.Regi_Address_3rd_Line__c,Contact_Name__r.AppCity__c,
        Contact_Name__r.Name,Contact_Name__r.Customer_Profile__c,Contact_Name__r.VoterID_Number__c,
        Contact_Name__r.Designation__c,Contact_Name__r.Employer_Name__c,Contact_Name__r.Date_of_Birth__c,
        Contact_Name__r.Qualification__c,Contact_Name__r.Address_1__c,Contact_Name__r.Employer__r.Name,Contact_Name__r.Others_Employer__c,Contact_Name__r.PAN_Number__c,
        PD_Status__c,Bank_Status__c,Contact_Name__r.Address_2__c,Contact_Name__r.Address_3__c,
        FCU_Status__c,ITR_Status__c,Office_SE_Status__c,Office_SAL_Status__c,Contact_Name__r.Name_of_the_company_Employer__c,
        Office_Status__c,Pay_Slips_Status__c,Contact_Name__r.Office_Phone_Number__c,Contact_Name__r.Name_of_Employer__c,
        Residence_Status__c,Trade_Status__c,TVR_Status__c,Contact_Name__r.Phone_Number__c,Contact_Name__r.Email__c,
        Contact_Name__r.Mobile__c,Contact_Name__r.Mobile_Phone__c,Contact_Name__r.Office_City__c,
        Contact_Name__r.Address_Line_One__c,Contact_Name__r.Address_2nd_Line__c,Contact_Name__r.Address_3rd_Line__c,
        Select_Applicant__c,Applicant_Type__c,Contact_Name__r.Pin_Code__c,Contact_Name__r.PassPort_Number__c,Contact_Name__r.Bank_Account_No__c,
        MVR_Check__c,Contact_Name__r.PAN_Card_Status__c,TR_Check__c,FR_Check__c,SR_Check__c,Contact_Name__r.Office_Contact_Number__c,Contact_Name__r.Permanent_Pin_Code__c,
        Contact_Name__r.Office_Pin_Code__c,Contact_Name__r.Office_State__c,Contact_Name__r.Joining_date_curr_Employer__c,SegmentaionResult__c
        from Applicant__c where Loan_Application__c in: oppID];  
        if(Trigger.Isupdate && Trigger.New[0].Product__c != null && !prods.contains(Trigger.New[0].Product__c.touppercase()))
        {
            solPolicyupdate = [Select id,Name from SOL_Policy__c where Created_From_Loan_Application__c=:True and Loan_Application__c =:Trigger.New[0].Id];
            if(apps.size()>0)
            { 
                for(Applicant__c conApp : apps)
                {
                    if(conApp.Contact_Name__r.PAN_Number__c!=null)
                        PANno.add(conApp.Contact_Name__r.PAN_Number__c);
                    if(conApp.Contact_Name__r.VoterID_Number__c!=null)
                        VoterID.add(conApp.Contact_Name__r.VoterID_Number__c);
                    if(conApp.Contact_Name__r.Mobile__c!=null)
                        Mobile.add(conApp.Contact_Name__r.Mobile__c);
                    if(conApp.Contact_Name__r.LastName !=null && conApp.Contact_Name__r.FirstName !=null && conApp.Contact_Name__r.Middle_Name__c!=null) 
                        Name.add(String.valueof(conApp.Contact_Name__r.FirstName)+String.valueof(conApp.Contact_Name__r.Middle_Name__c)+String.valueof(conApp.Contact_Name__r.LastName));
                    if(conApp.Contact_Name__r.Date_of_Birth__c!=null)
                        DOB.add(conApp.Contact_Name__r.Date_of_Birth__c);
                    if(conApp.Contact_Name__r.PassPort_Number__c!=null)
                        Passportno.add(conApp.Contact_Name__r.PassPort_Number__c);
                    if(conApp.Contact_Name__r.Office_Email_Id__c!=null)
                        Email.add(conApp.Contact_Name__r.Office_Email_Id__c);
                    if(conApp.Contact_Name__r.Driving_License_Number__c!=null)
                        Driving.add(conApp.Contact_Name__r.Driving_License_Number__c);
                    if(conApp.Contact_Name__r.Bank_Account_No__c!=null)
                        BankAccno.add(conApp.Contact_Name__r.Bank_Account_No__c);
                    
                    if(conApp.Contact_Name__r.LastName !=null && conApp.Contact_Name__r.FirstName !=null && conApp.Contact_Name__r.Middle_Name__c!=null && conApp.Contact_Name__r.Mobile_Phone__c!=null)
                        NameTelePhone.add(String.valueof(conApp.Contact_Name__r.FirstName)+String.valueof(conApp.Contact_Name__r.Middle_Name__c)+String.valueof(conApp.Contact_Name__r.LastName)+String.valueof(conApp.Contact_Name__r.Mobile_Phone__c));
                    
                    if(conApp.Contact_Name__r.LastName !=null && conApp.Contact_Name__r.FirstName !=null && conApp.Contact_Name__r.Middle_Name__c!=null && conApp.Contact_Name__r.Date_of_Birth__c!=null )
                        NameDaOB.add(String.valueof(conApp.Contact_Name__r.FirstName)+String.valueof(conApp.Contact_Name__r.Middle_Name__c)+ String.valueof(conApp.Contact_Name__r.LastName)+String.valueof(conApp.Contact_Name__r.Date_of_Birth__c));
                    
                    if(conApp.Contact_Name__r.LastName !=null && conApp.Contact_Name__r.FirstName !=null && conApp.Contact_Name__r.Address_1__c !=null && conApp.Contact_Name__r.Address_2__c !=null && conApp.Contact_Name__r.Address_3__c !=null )
                        NameAdd.add(String.valueof(conApp.Contact_Name__r.FirstName)+String.valueof(conApp.Contact_Name__r.Middle_Name__c)+String.valueof(conApp.Contact_Name__r.LastName)+String.valueof(conApp.Contact_Name__r.Address_1__c)+String.valueof(conApp.Contact_Name__r.Address_2__c)+String.valueof(conApp.Contact_Name__r.Address_3__c));
                    
                    if(conApp.Contact_Name__r.Pin_Code__c !=null && conApp.Contact_Name__r.Address_1__c !=null && conApp.Contact_Name__r.Address_2__c !=null && conApp.Contact_Name__r.Address_3__c !=null)
                        AddoPin.add(String.valueof(conApp.Contact_Name__r.Address_1__c)+String.valueof(conApp.Contact_Name__r.Address_2__c)+String.valueof(conApp.Contact_Name__r.Address_3__c)+String.valueof(conApp.Contact_Name__r.Pin_Code__c));
                    
                    if(conApp.Contact_Name__r.LastName !=null && conApp.Contact_Name__r.FirstName !=null && conApp.Contact_Name__r.Middle_Name__c!=null && conApp.Contact_Name__r.Name_of_the_company_Employer__c !=null && conApp.Contact_Name__r.Date_of_Birth__c !=null)
                        CompDOM.add(String.valueof(conApp.Contact_Name__r.FirstName)+String.valueof(conApp.Contact_Name__r.Middle_Name__c)+String.valueof(conApp.Contact_Name__r.LastName)+String.valueof(conApp.Contact_Name__r.Name_of_the_company_Employer__c)+String.valueof(conApp.Contact_Name__r.Date_of_Birth__c));
                }
            } 
            RejAppy = [select id,Loan_Application__c From Applicant__c where (((Contact_Name__r.PAN_Number__c in: PANno)or
            /*(Contact_Name__r.Office_Email_Id__c in: Email)or*/ (Contact_Name__r.VoterID_Number__c in: VoterID)or
            (Contact_Name__r.Mobile__c in: Mobile)or/*(Contact_Name__r.Date_of_Birth__c in: DOB)or*/
            (Contact_Name__r.PassPort_Number__c in: Passportno)or
            (Contact_Name__r.Bank_Account_No__c in: BankAccno)or (Address_Pin_Code__c in:AddoPin) or 
            (Customer_Name_Company_Name_DOB__c in:CompDOM) or (Name_Address__c in:NameAdd) or (Name_DOB__c in:NameDaOB) or 
            (Name_Telephone__c in: NameTelePhone)))]; 
            
            for(Applicant__c appys : RejAppy)
                OppyID.add(appys.Loan_Application__c);
            
            //Rohit commented for merging query 19699 & 19709
            /*OldOppy = [select id,Name,Loan_Application_Number__c,CreatedDate,Sent_To_Finnone__c,Product__c,Reject_Reason__c,StageName,Approved_time_after_Reappraisal__c from opportunity where id in: OppyID and Approved_time_after_Reappraisal__c!=null and id!=:Trigger.new[0].id order by createddate DESC ];*/
            OldOppyWIP = [select id,Name,Loan_Application_Number__c,CreatedDate,Sent_To_Finnone__c,Product__c,Reject_Reason__c,StageName,Approved_time_after_Reappraisal__c from opportunity where id in: OppyID and id!=:Trigger.new[0].id order by createddate DESC ];
            //Rohit start 19699 & 19709
            if(OldOppyWIP != null && OldOppyWIP.size()>0){
                OldOppy = new List<Opportunity>();
                for(Opportunity opp : OldOppyWIP){
                    if(opp.Approved_time_after_Reappraisal__c != null)
                        OldOppy.add(opp);
                }
            }
            //Rohit stop 19699 & 19709
            if(OldOppy.size()>0)
            {
                List<SOL_Policy__c> solPolicyList = new List<SOL_Policy__c>();
                for(Opportunity op : OldOppy)
                {
                    Date Decision = Date.valueof(op.Approved_time_after_Reappraisal__c); 
                    Integer DD = Decision.daysBetween(System.Today());
                    if((op.StageName=='Approved' && Trigger.New[0].Product__c=='SOL' && op.Sent_To_Finnone__c==False && DD<30 && DD<180))
                    {
                        system.debug('Inside Rejection Point');
                        Trigger.New[0].SFDC_Dedupe_Match__c=op.Loan_Application_Number__c;
                        // Trigger.New[0].StageName='Rejected';
                        SOL_Policy__c sp = new SOL_Policy__c();
                        sp.Policy_Name__c = 'Internal Dedupe - Approved and Not Disbursed';
                        sp.Policy_Status__c='Reject';
                        sp.Loan_Application__c=Trigger.New[0].id;
                        sp.Reference_Loan_Application__c=op.id;
                        sp.Created_From_Loan_Application__c=True;
                        solPolicyList.add(sp);
                        //Insert sp;
                    }
                    else if(op.StageName=='Rejected' && Trigger.New[0].Product__c=='SOL' && DD <= 180)
                    {
                        if(op.Reject_Reason__c!=null)
                        {
                            if((op.Reject_Reason__c.Contains('RFCU-Negative FCU check')) || (op.Reject_Reason__c.Contains('CIBIL - Loan Charge off > 10k')) ||
                            (op.Reject_Reason__c.Contains('CIBIL – 30dpd+ in Loan')) ||(op.Reject_Reason__c.Contains('CIBIL– Accnts seen as SMA,DBT,SUB,LSS')) ||
                            (op.Reject_Reason__c.Contains('RMD-Manipulated Documents')) ||(op.Reject_Reason__c.Contains('RDF-Defaulter of other banks/institutes')) ||
                            (op.Reject_Reason__c.Contains('RDBAFL-Defaulter of Bajaj Finance')) ||(op.Reject_Reason__c.Contains('RPD-Rejected on PD')))
                            {
                                Trigger.New[0].SFDC_Dedupe_Match__c=op.Loan_Application_Number__c;
                                //Trigger.New[0].StageName='Rejected';
                                SOL_Policy__c sp = new SOL_Policy__c();
                                sp.Policy_Name__c = 'Internal Dedupe - Rejected';
                                sp.Policy_Status__c='Reject';
                                sp.Loan_Application__c=Trigger.New[0].id;
                                sp.Reference_Loan_Application__c=op.id;
                                sp.Created_From_Loan_Application__c=True;
                                solPolicyList.add(sp);
                                //Insert sp;
                            }
                        }
                        if(op.Reject_Reason__c!=null)
                        {
                            if((op.Reject_Reason__c.Contains('RCPV-Negative CPV')) || (op.Reject_Reason__c.Contains('RTVR-Negative TVR'))||
                            (op.Reject_Reason__c.Contains('RNA-Negative Area')) ||(op.Reject_Reason__c.Contains('RNTS-Negative Profile')) ||
                            (op.Reject_Reason__c.Contains('RIRC-Insufficient repayment capacity')) ||(op.Reject_Reason__c.Contains('RRE-Rejected earlier')) ||
                            (op.Reject_Reason__c.Contains('RSF-Reject on sales feedback')) ||(op.Reject_Reason__c.Contains('ROT-Rejected for other reasons')) ||
                            (op.Reject_Reason__c.Contains('RP30-Case pending for more than 30 days')) ||(op.Reject_Reason__c.Contains('RNBAN-Banking not satisfactory')) ||
                            (op.Reject_Reason__c.Contains('ROGL-Residence outside city')) ||(op.Reject_Reason__c.Contains('RCB-High inward cheque bounce')) ||
                            (op.Reject_Reason__c.Contains('RNE-Loan amount Not Eligible')) ||(op.Reject_Reason__c.Contains('CIBIL – 30dpd+ in Card')) ||
                            (op.Reject_Reason__c.Contains('CIBIL - Unsecured enquiries between 4-8')) ||(op.Reject_Reason__c.Contains('CIBIL - Unsecured enquiries > 8')) ||
                            (op.Reject_Reason__c.Contains('CIBIL -Thin File Match')) ||(op.Reject_Reason__c.Contains('CIBIL- Current O/s on all Cards >10 Lacs')) ||
                            (op.Reject_Reason__c.Contains('CIBIL-Accnt not current on any product')))
                            {
                                Trigger.New[0].SFDC_Dedupe_Match__c=op.Loan_Application_Number__c;
                                // Trigger.New[0].StageName='Refer';
                                SOL_Policy__c sp = new SOL_Policy__c();
                                sp.Policy_Name__c = 'Internal Dedupe - Reject';
                                sp.Policy_Status__c='Refer';
                                sp.Loan_Application__c=Trigger.New[0].id;
                                sp.Reference_Loan_Application__c=op.id;
                                sp.Created_From_Loan_Application__c=True;
                                solPolicyList.add(sp);
                                //Insert sp;
                            }
                        }
                    }
                    else
                    {
                        if(Trigger.New[0].Product__c=='SOL')
                        {
                            BoolNonWIP=True;
                            StrID = StrID+op.Loan_Application_Number__c+',';
                        }  
                    }      
                    
                }
                insert solPolicyList;
            }
            if(OldOppyWIP.size()>0)
            {
                for(Opportunity  op : OldOppyWIP)
                {
                    
                    Integer CD = Date.Valueof(op.CreatedDate).daysBetween(System.Today());
                    if(op.StageName!='Approved' && Trigger.New[0].Product__c=='SOL'&& op.StageName!='Rejected' && CD<=30)
                    {
                        SOL_Policy__c sp = new SOL_Policy__c();
                        sp.Policy_Name__c = 'Internal Dedupe - WIP';
                        sp.Policy_Status__c='Reject';
                        sp.Loan_Application__c=Trigger.New[0].id;
                        sp.Reference_Loan_Application__c=op.id;
                        sp.Created_From_Loan_Application__c=True;
                        //Insert sp;
                    }
                    else if(op.StageName!='Approved' && Trigger.New[0].Product__c=='SOL' && op.StageName!='Rejected' && CD>30 && CD<=365)
                    {
                        Trigger.New[0].SFDC_Dedupe_Match__c=op.Loan_Application_Number__c;
                        // Trigger.New[0].StageName='Refer';
                        SOL_Policy__c sp = new SOL_Policy__c();
                        sp.Policy_Name__c = 'Internal Dedupe - WIP';
                        sp.Policy_Status__c='Refer';
                        sp.Loan_Application__c=Trigger.New[0].id;
                        sp.Reference_Loan_Application__c=op.id;
                        sp.Created_From_Loan_Application__c=True;
                        //Insert sp;
                    }
                    else
                    {
                        if(Trigger.New[0].Product__c=='SOL')
                        {
                            BoolWIP=True;
                            Integer maxsize = 131050;
                            if(StrID == null)// added condition for bug 21961 
                               StrID = StrID+op.Loan_Application_Number__c+',';
                            if(StrID != null && StrID.length() <= maxsize)// added condition for bug 21961
                                StrID = StrID+op.Loan_Application_Number__c+',';
                        }   
                    }      
                } 
            }
            if(BoolWIP==True || BoolNonWIP==True)
            {
                SOL_Policy__c sp = new SOL_Policy__c();
                sp.Policy_Name__c = 'Internal Dedupe - OK';
                sp.Policy_Status__c='OK';
                sp.Loan_Application__c=Trigger.New[0].id;
                sp.Old_Loan_Application__c=StrID;
                sp.Created_From_Loan_Application__c=True;
                Insert sp;
            }
        }
        /* Internal Dedupe Ends */
        
        if(solPolicyupdate.size()>0)
            Delete solPolicyupdate;
        /* Internal Dedupe Ends */
       
    }
    }//17243 
 }
 }// new if

  // Bug Id : 16618 - NSDL PAN Check -- start
          if(Trigger.isUpdate && Trigger.isAfter){
               System.debug('Inside opportunity trigger to change pan'); 
                                  List<ID> Oppoids = new List<ID>();         // current Oppo's  id.
                        List<Opportunity> OppoList = new List<Opportunity>();        
        
       for(Opportunity updatedopp : Trigger.new){
           System.debug('pan '+trigger.oldmap.get(updatedopp.id).PAN_Number__c);
           if(
                /* #18258
                 * (trigger.oldmap.get(updatedopp.id).PAN_Number__c == null && updatedopp.PAN_Number__c != null) || 
                (!trigger.oldmap.get(updatedopp.id).PAN_Number__c.equalsIgnoreCase(updatedopp.PAN_Number__c)) */
                (trigger.oldmap.get(updatedopp.id).PAN_Number__c == null && updatedopp.PAN_Number__c != null) ||
                (trigger.oldmap.get(updatedopp.id).PAN_Number__c!= null && !trigger.oldmap.get(updatedopp.id).PAN_Number__c.equalsIgnoreCase(updatedopp.PAN_Number__c))
            ){
                      System.debug('found loan in underwritting stage'); 
                      if(updatedopp.stagename == 'Underwriting' || updatedopp.stagename == 'Re-Appraise- Loan amount'){
                                  Oppoids.add(updatedopp.id);
                                  OppoList.add(updatedopp);
                  }    
                }  
              }
     System.debug('we have opportunities '+Oppoids); 
     System.debug('OppoList --> ' + OppoList);
  if (  Oppoids.size() > 0) {
         System.debug('we have opportunities '+Oppoids.size()); 
List<Applicant__c> AppList  = [ Select Id, PAN_Number__c, Applicant_type__c, Contact_Name__c, ContactName__c, Contact_Name__r.PAN_Number__c,
                                (Select Name, TypeP__c, Applicant__c, PAN_Number__c, PAN_Source__c, PAN_Check_Status__c, Comment__c, Credit_Observation__c, Override_Flag__c, NSDL_Response__c, Title__c, Name__c, Date_Of_Birth__c, Last_Modified_Date__c From TAT_Masters__r) 
                               ,Contact_Name__r.Account.PANNumber__c ,Contact_Customer_Type__c
                                    From Applicant__c 
                                    Where Loan_Application__c =: Oppoids ];               
   
         System.debug('Applicant list related to that opportunities ' + AppList  );
    List<Contact> updatedConoList = new List<Contact>();
    
     List<Id> lncon = new List<Id>();
      for(Applicant__c a : AppList){
        if( (a.Applicant_type__c.equalsIgnoreCase('Primary') && a.Contact_Customer_Type__c.equalsIgnoreCase('Individual')) ||
            (a.Applicant_type__c.equalsIgnoreCase('Primary Financial Co-Applicant') && a.Contact_Customer_Type__c.equalsIgnoreCase('Corporate'))  ){ 
        lncon.add(a.Contact_Name__c);
        }
      }
      
      List<Contact> tempConList = [select id,AccountId,PAN_Number__c from Contact where id =: lncon] ;        
            

            for ( Opportunity opp : OppoList ) {
                 for ( Contact cnt : tempConList ) {
                      if( opp.AccountId == cnt.AccountId ){
                          if (cnt.PAN_Number__c != opp.PAN_Number__c) {
                            cnt.PAN_Number__c = opp.PAN_Number__c;
                            updatedConoList.add(cnt);
                          }
                     }
                   }
                }
                
                 System.debug('Contact list need to be updated ' + updatedConoList);
                if( updatedConoList != null && updatedConoList.size()>0)
                  update updatedConoList;   
  }      

}
// Bug Id : 16618 - NSDL PAN Check --end

System.debug('\n\n\t  ---------- In MasterOpportunityTrigger End ----------------------------- \n\n');

}