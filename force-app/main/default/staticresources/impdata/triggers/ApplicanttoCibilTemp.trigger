trigger ApplicanttoCibilTemp on Applicant__c(after insert, after update, before update) {
    //Added by mahima to restric integration user access- start--
    ID Pid = Userinfo.getProfileID();
     List < Cibil_Temp__c > temps = new List < Cibil_Temp__c >();
    string Ids = Label.dedupe_App_restrictedUserId;
    //List<string> restrictedIds= new list<string>();
    set < string > restrictedIdsSet = new set < string > ();
    if (ids != null) {
        restrictedIdsSet.addAll(Ids.split(','));
    }
    if (!restrictedIdsSet.contains(Pid)) {
        //Added by mahima to restric integration user access- end--  
        //23567**S**
        list<Opportunity> loanDetails = new  list<Opportunity>();
        system.debug('flag in trigger applicanttocibiltemp****'+ControlRecursiveCallofTrigger_Util.getrestrictCibil());
        if(!ControlRecursiveCallofTrigger_Util.getrestrictCibil() && Trigger.New[0].Loan_Application__c!=null){
           loanDetails = [Select Id,Product__c,Sourcing_Channel__c,Sourcing_Channel__r.Name,Sour_Channel_Name__c From Opportunity WHERE
                                        id = : Trigger.New[0].Loan_Application__c];
            system.debug('Query executed****');
            ControlRecursiveCallofTrigger_Util.setrestrictCibil();
        }
   
        if(loanDetails!=null && loanDetails.size()>0 && ((loanDetails[0].Sourcing_Channel__c != null &&
           !(Label.Sourcing_Channel.containsIgnoreCase(loanDetails[0].Sour_Channel_Name__c))) || loanDetails[0].Sourcing_Channel__c==null )){
        //23567**E**
        system.debug('Sourcing channel restriction if***');
        if (((ATOSParameters__c.getValues('NewApplicantsTriggerFlow') == null) || (ATOSParameters__c.getValues('NewApplicantsTriggerFlow') != null && ATOSParameters__c.getValues('NewApplicantsTriggerFlow').NewTriggerOptimizationFlow__c == false)) && !ControlRecursiveCallofTrigger_Util.hasApplicant_to_CibilTemp()) {         
            //Bug #12062 S - added isAfter condition
            if (Trigger.isAfter) {
                ControlRecursiveCallofTrigger_Util.setApplicant_to_CibilTemp();
                List < sObject > sObjLstIn = new List < sObject > ();
                List < sObject > sObjLstUp = new List < sObject > ();
                
                list < Applicant__c > applist = new list < Applicant__c > ();
                list < Salaried__c > sallist = new list < Salaried__c > ();
                //List < Id > conIds = new List < Id > ();
                Boolean OTPFlowFlag;
                Boolean SOLV2Flow;
                Boolean digitalFlowFlag;
                Boolean isRMFlow;
                Boolean isReengineeringProduct;
                Set < String > prods = new Set < String > ();
                
                
                List < Opportunity > Loan = new List < Opportunity > ();
                List < SOL_Policy__c > PolicyList = new List < SOL_Policy__c > ();
                List < SOL_Policy__c > PolicyListUpdate = new List < SOL_Policy__c > ();
                Boolean cibil = False;
                Integer CibilScore = 0;
                List < Applicant__c > apps = new List < Applicant__c > ();
                List < SOL_CAM__c > Sol = new List < SOL_CAM__c > ();
                
                String labelProd = '';
                labelProd = label.digitalProducts;
                for (String s: labelProd.split(',')) {
                    prods.add(s.toUppercase());
                }
       
                Boolean newSOLFlow;
                if (label.SOL_Online_Flow_Control == 'SOLV1') {
                    newSOLFlow = false;
                } else if (label.SOL_Online_Flow_Control == 'SOLV2') {
                    newSOLFlow = true;
                }
                
                system.debug('for SOL product---->' + Trigger.New[0].product__c);
                
                //Bug Id : 17501 SHL change
                boolean isSHOLProductLineProduct = false;  
                transient string SHOLProductLineProducts = Label.SHOL_ProductLine_Products;
                if(SHOLProductLineProducts != null && SHOLProductLineProducts != '' )
                {
                    set < string > setSHOLProdName = new set < string > ();
                    setSHOLProdName.addAll(SHOLProductLineProducts.split(';'));
                    if (setSHOLProdName != null && setSHOLProdName.size() > 0 && Trigger.New != null && Trigger.New[0].product__c != null) 
                    {
                        if(setSHOLProdName.contains(Trigger.New[0].product__c))
                        isSHOLProductLineProduct = true; 
                    }
                }
                if ((label.SOL_Online_Flow_Control == 'SOLV2' && Trigger.New[0].product__c == 'SOL') ||
                    isSHOLProductLineProduct) {
                        //harsit----optimization start
                        //added the slaried query in opportunity query
                        Loan = [select id, StageName, Product__c, LAN__c, Quality_Check_Status__c,
                                (select id, name, percentage_completion__c, Employer__c, Product_Type__c from salaried__r)
                                from Opportunity where id = : Trigger.New[0].Loan_Application__c
                               ];
                        if (Loan.size() > 0 && !CommonUtility.isEmpty(Loan[0].salaried__r))
                            //salList = [select id, name, percentage_completion__c, Employer__c, Product_Type__c from salaried__c where Loan_application__c = : Loan[0].id];
                            salList = Loan[0].salaried__r;
                        //harsit------optimization end
                    }
                
                System.debug('this applicant is from lead/la process flow ');
                //System.debug('this applicant is from new loanappln process flow ');
                set < id > conid = new set < id > ();
                set < id > appid = new set < id > ();
                //set < id > loanid = new set < id > ();
                
                integer flag;
                
                for (Applicant__c a: trigger.new) {
                    appid.add(a.id);
                    
                    //harsit----optimization start
                    //code is of no use
                    /*loanid.add(a.Loan_Application__c);

if (a.Applicant_Type__c == 'Primary')
conIds.add(a.Contact_Name__c);*/
                    //harsit----optimization end
                }
                
                if (appid.size() > 0) {
                    system.debug('applicant is there');
                    //added Grouptype field for Multiple CIBIL Temp issue 
                    //harsit----optimization Start
                    //Added the query on SOL_CAM into the applicant query
                    //Field added a.Loan_Application__r.Link_Offer_id__c for cibil revamp 
                    applist = [Select a.Loan_Application__r.Link_Offer_id__c,a.Loan_Application__r.Account.Group_Type__c, a.Dedupe_Done__c, a.X60_Completion__c, a.Loan_Application__r.Product__c, Loan_Application__r.Loan_Application_Flow__c, a.Loan_Application__r.Account.IS_OTP_FLOW__c, a.Loan_Application__c, a.Name, a.movedToCibilTemp__c, a.Update_CIBIL_Error__c, a.Lead__c, a.Lead_Applicants__c, a.Integrate_with_CIBIL__c, a.Id, a.Contact_Name__c, a.Cibil_Temp__c, a.Cibil_Retrigger_Initiated__c, a.CIBIL_Score__c, a.CIBIL_Match_Check__c,
                               /*harsit----optimization START*/
                               Contact_Name__r.VoterID_Number__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.PassPort_Number__c, Contact_Name__r.Office_Phone_Number__c, Contact_Name__r.Middle_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Address_1__c, Contact_Name__r.Address_2__c, Contact_Name__r.Address_3__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.State__c, Contact_Name__r.AppCity__c, Contact_Name__r.Date_of_Birth__c, Contact_Name__r.Sex__c, Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Pin_Code__c,
                               /*harsit-----optimzation end*/
                               (Select Id,Applicant__c, Lead__c, Enable_Manual_Cibil__c From Cibil_Temps__r),
                               (select id, Applicant__c, Cibil_Score__c from SOL_CAMs__r)
                               From Applicant__c a where a.id in : appid
                              ]; 
                    
                    //sol = [select id, Applicant__c, Cibil_Score__c from SOL_Cam__c where Applicant__c in : appid];
                    //harsit----optimization End
                }
                /* Prajyot #10659 Secondary Cibil Match START */
                List < CIBIL__c > cibils = new List < CIBIL__c > ();
                List < string > tempIds = new List < string > ();
                List < string > cibilTemps = new List < string > ();
                List < CIBIL_Extension__c > cibilExts = new List < CIBIL_Extension__c > ();
                List < Cibil_Extension1__c > cibilExts1 = new List < Cibil_Extension1__c > ();
                List < CIBIL_secondary_match__c > secondMatch = new List < CIBIL_secondary_match__c > ();
                
                //harsit------optimization start
                //Merged the queries on cibil_temp,cibil,cibil_extension, and cibil_extension1 into one qyery by using the concept of subQuery
                /*List < Cibil_Temp__c > temps = [select id, SecondaryMatch_Record__c from Cibil_Temp__c where Applicant__c in : appid and SecondaryMatch_Record__c = true];
for (Cibil_Temp__c temp: temps) {
tempIds.add(temp.id);
}

cibils = [select id, Applicant__c, Applicant__r.PAN_Number__c, Cibil_Temp__c, Cibil_Temp__r.Loan_Application__r.LAN__c from CIBIL__C where Applicant__c in : appid and Cibil_Temp__c in : tempIds];
system.debug('appid=' + appid + ' tempIds=' + tempIds);
system.debug('CIBILS found=' + cibils);
cibilExts = [select id, Applicant__c, Applicant__r.PAN_Number__c, Cibil_Temp__c, Cibil_Temp__r.Loan_Application__r.LAN__c from CIBIL_Extension__c where Applicant__c in : appid and Cibil_Temp__c in : tempIds];
cibilExts1 = [select id, Applicant__c, Applicant__r.PAN_Number__c, Cibil_Temp__c, Cibil_Temp__r.Loan_Application__r.LAN__c from Cibil_Extension1__c where Applicant__c in : appid and Cibil_Temp__c in : tempIds];*/
 if(appid != null && appid.size() > 0){
 temps = [select id, SecondaryMatch_Record__c,
                                            (select id, Applicant__c, Applicant__r.PAN_Number__c, Cibil_Temp__c, Cibil_Temp__r.Loan_Application__r.LAN__c from CIBILs__r where Applicant__c in : appid),
                                            (select id, Applicant__c, Applicant__r.PAN_Number__c, Cibil_Temp__c, Cibil_Temp__r.Loan_Application__r.LAN__c from CIBIL_Extension__r where Applicant__c in : appid),
                                            (select id, Applicant__c, Applicant__r.PAN_Number__c, Cibil_Temp__c, Cibil_Temp__r.Loan_Application__r.LAN__c from Cibil_Extension1s__r where Applicant__c in : appid)
                                            from Cibil_Temp__c where Applicant__c in : appid and SecondaryMatch_Record__c = true
                                           ];
 }
            
            for (Cibil_Temp__c temp: temps) {
                if (!CommonUtility.isEmpty(temp.CIBILs__r))
                    cibils.addAll(temp.CIBILs__r);
                if (!CommonUtility.isEmpty(temp.CIBIL_Extension__r))
                    cibilExts.addAll(temp.CIBIL_Extension__r);
                if (!CommonUtility.isEmpty(temp.Cibil_Extension1s__r))
                    cibilExts1.addAll(temp.Cibil_Extension1s__r);
            }
            //harsit------optimization end               
            //secondMatch = [select id, Applicant__c, Applicant__r.PAN_Number__c,Cibil_Temp__c,Cibil_Temp__r.Loan_Application__r.LAN__c from CIBIL_secondary_match__c where Applicant__c in : appid and Cibil_Temp__c in : tempIds];
                
                /*
List<CIBIL__C> newCibil = new List<CIBIL__C>();
List<CIBIL_Extension__c> newExt = new List<CIBIL_Extension__c>();
List<Cibil_Extension1__c> newExt1 = new List<Cibil_Extension1__c>();
*/
                string dummyApllicant;
                if (CibilFiringLimit__c.getValues('Secondary CIBIL Applicant') != null) {
                    dummyApllicant = CibilFiringLimit__c.getValues('Secondary CIBIL Applicant').Secondary_CIBIL_Applicant__c;
                }
                system.debug('dummyApllicant=' + dummyApllicant);
                for (CIBIL__C cib: cibils) {
                    cib.Applicant__c = dummyApllicant;
                    cib.PAN__c = cib.Applicant__r.PAN_Number__c;
                    cib.Loan_Application_Number__c = cib.Cibil_Temp__r.Loan_Application__r.LAN__c;
                    //cib.Cibil_Temp__r.CIBIL_Id__c = cib.id; 
                    system.debug('LAN-' + cib.Cibil_Temp__r.Loan_Application__r.LAN__c);
                }
                //   system.debug('newCibil found='+newCibil);    
                upsert cibils;
                for (CIBIL_Extension__c ext: cibilExts) {
                    ext.Applicant__c = dummyApllicant;
                    ext.PAN__c = ext.Applicant__r.PAN_Number__c;
                    ext.Loan_Application_No__c = ext.Cibil_Temp__r.Loan_Application__r.LAN__c;
                    system.debug('LAN-' + ext.Cibil_Temp__r.Loan_Application__r.LAN__c);
                }
                upsert cibilExts;
                for (Cibil_Extension1__c ext1: cibilExts1) {
                    ext1.Applicant__c = dummyApllicant;
                    ext1.PAN__c = ext1.Applicant__r.PAN_Number__c;
                    ext1.Loan_Application_No__c = ext1.Cibil_Temp__r.Loan_Application__r.LAN__c;
                    system.debug('LAN-' + ext1.Cibil_Temp__r.Loan_Application__r.LAN__c);
                }
                upsert cibilExts1;
                
                /* Prajyot #10659 Secondary Cibil Match END */
                String products;
                Set < String > OTPProducts = new Set < String > ();
                System.debug('OTP Products' + OTPFlowProducts__c.getValues('OTP Product'));
                if (OTPFlowProducts__c.getValues('OTP Product') != null) {
                    products = OTPFlowProducts__c.getValues('OTP Product').Product__c;
                    
                    if (products != null) {
                        String[] arr = products.split(';');
                        for (String str: arr) {
                            OTPProducts.add(str);
                        }
                        system.debug('***OTPProducts***' + OTPProducts);
                    }
                }
                String reproducts;
                Set < String > ReenggProducts = new Set < String > ();
                System.debug('ReEngineeringProducts' + ATOSParameters__c.getValues('ReEngineeringProducts'));
                if (ATOSParameters__c.getValues('ReEngineeringProducts') != null) {
                    reproducts = ATOSParameters__c.getValues('ReEngineeringProducts').Value__c;
                    
                    if (reproducts != null) {
                        String[] arr = reproducts.split(';');
                        for (String str: arr) {
                            ReenggProducts.add(str);
                        }
                        system.debug('***ReenggProducts***' + ReenggProducts);
                    }
                }
                isReengineeringProduct = false;
                OTPFlowFlag = false;
                digitalFlowFlag = false;
                SOLV2Flow = false;
                for (Applicant__c app: applist) {
                    
                    //harsit-----optimization Start
                    if (!CommonUtility.isEmpty(app.SOL_CAMs__r))
                        sol.addAll(app.SOL_CAMs__r);
                    //harsit-----optimization end

                    if (app.Loan_Application__r.Product__c != null && ReenggProducts != null && ReenggProducts.size() > 0 && ReenggProducts.contains(app.Loan_Application__r.Product__c.ToUpperCase())) {
                        isReengineeringProduct = true;
                    }
                    if (app.Loan_Application__r.Product__c != null && OTPProducts != null && OTPProducts.size() > 0 && OTPProducts.contains(app.Loan_Application__r.Product__c.ToUpperCase()) && app.Loan_Application__r.Account.IS_OTP_FLOW__c == true)
                        OTPFlowFlag = true;
                    if (app.Loan_Application__r.Product__c != null && prods != null && prods.size() > 0 && prods.contains(app.Loan_Application__r.Product__c.ToUpperCase()))
                        digitalFlowFlag = true;
                    if (app.Loan_Application__r.Product__c != null && app.Loan_Application__r.Product__c == 'SOL' && app.Loan_Application__r.Account.IS_OTP_FLOW__c == true)
                        SOLV2Flow = true;
                    // if(app.movedToCibilTemp__c==false){ 
                    system.debug('Applicantnamess' + app.Name);
                    system.debug('-----movedtocibiltemp-----' + app.movedToCibilTemp__c);
                    ////if(app.movedToCibilTemp__c != true)
                    //  system.debug('product offering'+ app.Loan_Application__r.Product_Offereing_id__c);
                     //harsit----optimization START
                     //Here, instead the query on contact, I added the fields of contact in applicant query through look-up relationship. ANd, by using that fields, I created the dummy contact object and used it.
                
                    /*ID cid = app.Contact_Name__c;
                    Contact c;
                    List < Contact > contList = [Select VoterID_Number__c, Customer_Type__c, PassPort_Number__c, Office_Phone_Number__c, Middle_Name__c, PAN_Number__c, Address_1__c, Address_2__c, Address_3__c, FirstName, LastName, State__c, AppCity__c, Date_of_Birth__c, Sex__c, Mobile_Phone__c, Pin_Code__c From Contact where Id = : cid];
                    if (contList.size() > 0) {
                        for (integer i = 0; i < contList.size(); i++) {
                            c = contList[i];
                        }*/

                    Contact c;
                    if (!CommonUtility.isEmpty(app.Contact_Name__c)) {
                        c = new Contact(id = app.Contact_Name__c);
                        c.VoterID_Number__c = app.Contact_Name__r.VoterID_Number__c;
                        c.Customer_Type__c = app.Contact_Name__r.Customer_Type__c;
                        c.PassPort_Number__c = app.Contact_Name__r.PassPort_Number__c;
                        c.Office_Phone_Number__c = app.Contact_Name__r.Office_Phone_Number__c;
                        c.Middle_Name__c = app.Contact_Name__r.Middle_Name__c;
                        c.PAN_Number__c = app.Contact_Name__r.PAN_Number__c;
                        c.Address_1__c = app.Contact_Name__r.Address_1__c;
                        c.Address_2__c = app.Contact_Name__r.Address_2__c;
                        c.Address_3__c = app.Contact_Name__r.Address_3__c;
                        c.FirstName = app.Contact_Name__r.FirstName;
                        c.LastName = app.Contact_Name__r.LastName;
                        c.State__c = app.Contact_Name__r.State__c;
                        c.AppCity__c = app.Contact_Name__r.AppCity__c;
                        c.Date_of_Birth__c = app.Contact_Name__r.Date_of_Birth__c;
                        c.Sex__c = app.Contact_Name__r.Sex__c;
                        c.Mobile_Phone__c = app.Contact_Name__r.Mobile_Phone__c;
                        c.Pin_Code__c = app.Contact_Name__r.Pin_Code__c;
                    
                   //harsit----optimization END
                        //5211 S 
                        /*   Boolean createCibil = true;

if (app.Loan_Application__r.Loan_Application_Flow__c != null && app.Loan_Application__r.Loan_Application_Flow__c == 'RM'){
if(trigger.isupdate()){
createCibil = true;
}   
else if(trigger.isInsert()){
createCibil = false;
}   
}
*/
                        
                        isRMFlow = false;
                        if (app.Loan_Application__r.Loan_Application_Flow__c != null && app.Loan_Application__r.Loan_Application_Flow__c == 'RM' && app.Cibil_Temps__r != null) {
                            isRMFlow = true;
                        }
             
                  
                   
                      //cibil revamp start
                    if(Trigger.isAfter && Trigger.isInsert){
                     
                        if(app.Loan_Application__c != null && app.Loan_Application__r.Link_Offer_id__c != null){
                       
                            System.debug('@@@ Loan from Product Offering');
                            System.debug('@@@ Link_Offer_id__c is not blank');
                            System.debug(' CIBIL_Score__c = '+app.CIBIL_Score__c);
                            System.debug(' CIBIL_Match_Check__c = '+app.CIBIL_Match_Check__c);
                           
                            //if cibiltemp is not moved from PO to Loan Application then we will initiate cibil using following code
                            if( String.isBlank(app.CIBIL_Score__c) && (app.CIBIL_Match_Check__c == '--None--' || String.isBlank(app.CIBIL_Match_Check__c))){
                                CibilTempDetails.createCibilTempRecord(c, app, app.movedToCibilTemp__c);
                                System.debug('@@@ cibiltemp need to create in applicanttocibiltemp');
                            }
                        }
                        else{
                            //cibiltemp will get create for New/DSS flow, old flow and OTPv3 Flow when applicant get insert
                            System.debug('@@@ Fresh Applicant created');
                            //Bug 17088 - Multiple cibil is getting generated start
                            List<String>productSet=Label.OnlineProducts.split(',');
                           if(!productSet.contains(app.Loan_Application__r.Product__c)) {
                            CibilTempDetails.createCibilTempRecord(c, app, app.movedToCibilTemp__c);
                            }
                            System.debug('@@@ cibiltemp created in applicanttocibiltemp');
                        }
                    }        
                    //cibil revamp end   
                  
                     
                        system.debug('*****OTPFlowFlag: ' + OTPFlowFlag + ' ***digitalFlowFlag: ' + digitalFlowFlag + 'isReengineeringProduct' + isReengineeringProduct + 'SOLV2Flow-->' + SOLV2Flow + 'Product -->' + app.Loan_Application__r.Product__c);
                        // if (!OTPFlowFlag && !SOLV2Flow && !digitalFlowFlag && app.Loan_Application__r.Product__c != 'SHOL' && app.Loan_Application__r.Product__c != 'LASOL' && !isRMFlow && !isReengineeringProduct && !PODetails_SF1Controller.calledfromPOSF1)
                        //CibilTempDetails.createCibilTempRecord(c, app, app.movedToCibilTemp__c);
                        // else if(app.Loan_Application__r.Product__c=='SOL' && app.X60_Completion__c==true && solploicylist.isempty())
                        // CibilTempDetails.createCibilTempRecord(c,app,app.movedToCibilTemp__c );
                    }
                }
                

                //Start new code
                //if(!test.isrunningtest()){
                //Bug Id : 17501 SHL change
                if(SHOLProductLineProducts != null && SHOLProductLineProducts != '' )
                {
                    set < string > setSHOLProdName = new set < string > ();
                    setSHOLProdName.addAll(SHOLProductLineProducts.split(';'));
                    if (setSHOLProdName != null && setSHOLProdName.size() > 0 && trigger.new != null && trigger.new[0].product__c != null) 
                    {
                        if(setSHOLProdName.contains(trigger.new[0].product__c))
                        isSHOLProductLineProduct = true; 
                    }
                }
                
                if (trigger.new[0].product__c == 'SOL' || isSHOLProductLineProduct) {
                    system.debug('Test=' + isSHOLProductLineProduct);
                    if (trigger.new[0].product__c == 'SOL' && label.SOL_Online_Flow_Control == 'SOLV2' || isSHOLProductLineProduct) {
                        system.debug('----->Loan--- ' + trigger.new[0].product__c);
                        system.debug('Product is ' + Loan);
                        system.debug('label product  ' + label.SOL_Online_Flow_Control);
                        PolicyListUpdate = [Select id, Name from SOL_Policy__c where Created_From_Applicant__c = : True and Loan_Application__c = : Loan[0].Id];
                        apps = [select id, name, Update_CIBIL_Error__c, Type_of_Borrower__c, Re_Initiate_De_Dupe__c, Integrate_with_CIBIL__c, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Customer_Profile__c,
                                Contact_Name__r.Designation__c, Contact_Name__r.Employer_Name__c, Contact_Name__r.Qualification__c, Contact_Name__r.Address_1__c,
                                PD_Status__c, Bank_Status__c, Contact_Name__r.Address_2__c, FCU_Status__c, ITR_Status__c, Office_SE_Status__c, Office_SAL_Status__c,
                                Office_Status__c, Pay_Slips_Status__c, Residence_Status__c, Trade_Status__c, TVR_Status__c, Select_Applicant__c, Applicant_Type__c, Contact_Name__r.Customer_Type__c, Contact_Name__r.ApplicantType__c,
                                Contact_Name__r.Date_of_Birth__c, Contact_Name__r.FathersHusbands_Name__c, Contact_Name__r.PAN_Number__c, Contact_Name__r.Year_of_Incorporation__c, Contact_Name__r.Account.TIN_Number__c,
                                Contact_Name__r.Bank_Account_No__c, Contact_Name__r.VoterID_Number__c, Contact_Name__r.ROC_Regn_No__c, Contact_Name__r.Address_3__c, Contact_Name__r.AppCity__c,
                                Contact_Name__r.Pin_Code__c, Contact_Name__r.Phone, Contact_Name__r.MobilePhone, Contact_Name__r.Email, Contact_Name__r.Address_Line_One__c, Contact_Name__r.Address_2nd_Line__c, Contact_Name__r.Address_3rd_Line__c,
                                Contact_Name__r.Permanent_Land_Mark__c, Contact_Name__r.Office_City__c, Contact_Name__r.Office_Pin_Code__c, Contact_Name__r.Office_STD_Code__c, Contact_Name__r.Office_Phone_Number__c,
                                Contact_Name__r.Mobile_Phone__c, Contact_Name__r.Office_Email_Id__c, Contact_Name__r.Middle_Name__c, Employer__c, Company_Type__c, Company_Name__c, Contact_Name__r.Company_Type__c,
                                DIN_No_if_applicable__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Name__r.Permanant_Address_Line_1__c, Contact_Name__r.Permanant_Address_Line_2__c, Contact_Name__r.Permanant_Address_Line_3__c,
                                Contact_Name__r.Permanent_STD__c, Contact_Name__r.Permanent_Pin_Code__c, Contact_Name__r.Year_in_Present_Job__c, Contact_Name__r.Year_in_Previous_Job__c, Contact_Name__r.Name_of_the_company_Employer__c,
                                Contact_Name__r.Nature_of_Business__c, Contact_Name__r.Employment_Status__c, Contact_Name__r.Gender__c, Contact_Name__r.Age__c, Contact_Name__r.Employment_Type__c, Contact_Name__r.STD_Code__c, Contact_Name__r.Phone_Number__c,
                                Contact_Name__r.Name_of_Employer__c, Contact_Name__r.PAN_Card_Status__c, Contact_Name__r.PAN__c, Designation__c, Contact_Name__r.Type_Of_Constitution__c, Contact_Name__r.Marital_Status__c, Contact_Mobile__c, Contact_Name__r.Residence_City__c, Contact_Name__r.Sex__c
                                from Applicant__c where Loan_Application__c = : Loan[0].Id
                               ];
                        system.debug('app size------' + apps.size() + 'applicanr are ' + apps);
                        if (trigger.isinsert) {
                            system.debug('inside insert trigger');
                            
                            De_dupe__c dedupe = new De_dupe__c();
                            dedupe.Applicant__c = apps[0].id;
                            //dedupe.Customer_First_Name__c=apps[0].Contact_Name__r.FirstName;
                            dedupe.Applicant_Type__c = 'P';
                            dedupe.Customer_Type__c = 'I';
                            dedupe.Loan_Application__c = Loan[0].Id;
                            dedupe.Employer_Name__c = apps[0].Contact_Name__r.Employer_Name__c;
                            dedupe.DOB__c = apps[0].Contact_Name__r.Date_of_Birth__c;
                            dedupe.Fathers_Husband_s_Name__c = apps[0].Contact_Name__r.FathersHusbands_Name__c;
                            dedupe.PAN__c = apps[0].Contact_Name__r.PAN_Number__c;
                            dedupe.Company_Date_of_Incorporation__c = apps[0].Contact_Name__r.Year_of_Incorporation__c;
                            dedupe.Company_TIN_No__c = apps[0].Contact_Name__r.Account.TIN_Number__c;
                            dedupe.AccNo__c = String.valueof(apps[0].Contact_Name__r.Bank_Account_No__c);
                            dedupe.VoterID__c = apps[0].Contact_Name__r.VoterID_Number__c;
                            dedupe.Credit_Card_No__c = apps[0].Contact_Name__r.ROC_Regn_No__c;
                            //dedupe.Existing_LAN_1__c=String.valueof(Loan.LINK_LAN__c);
                            dedupe.Existing_LAN_2__c = Loan[0].LAN__c;
                            dedupe.Address1_Residence__c = apps[0].Contact_Name__r.Address_1__c;
                            dedupe.Address2_Residence__c = apps[0].Contact_Name__r.Address_2__c;
                            dedupe.Address3_Residence__c = apps[0].Contact_Name__r.Address_3__c;
                            dedupe.City_Residence__c = apps[0].Contact_Name__r.AppCity__c;
                            dedupe.PIN__c = string.valueof(apps[0].Contact_Name__r.Pin_Code__c);
                            if (apps[0].Contact_Name__r.Phone != null)
                                dedupe.Landline2_Residence__c = apps[0].Contact_Name__r.Phone.replaceAll('\\D', ''); //replaceAll('\\D','') BUGID..15049
                            if (apps[0].Contact_Name__r.MobilePhone != null)
                                dedupe.Mobile_Residence__c = string.valueof(apps[0].Contact_Name__r.MobilePhone);
                            dedupe.Email_Residence__c = apps[0].Contact_Name__r.Email;
                            dedupe.Address1_Office__c = apps[0].Contact_Name__r.Address_Line_One__c;
                            dedupe.Address2_Office__c = apps[0].Contact_Name__r.Address_2nd_Line__c;
                            dedupe.Address3_Office__c = apps[0].Contact_Name__r.Address_3rd_Line__c;
                            dedupe.Area_Office__c = apps[0].Contact_Name__r.Address_Line_One__c;
                            dedupe.Landmark_Office__c = apps[0].Contact_Name__r.Permanent_Land_Mark__c;
                            dedupe.City_Office__c = apps[0].Contact_Name__r.Office_City__c;
                            dedupe.Pin_Office__c = apps[0].Contact_Name__r.Office_Pin_Code__c;
                            dedupe.STD_Office__c = string.valueof(apps[0].Contact_Name__r.Office_STD_Code__c);
                            dedupe.Landline1_Office__c = apps[0].Contact_Name__r.Office_Phone_Number__c;
                            dedupe.Landline2_Office__c = apps[0].Contact_Name__r.Office_Phone_Number__c;
                            dedupe.Mobile_Office__c = apps[0].Contact_Name__r.Mobile_Phone__c;
                            dedupe.Email_Office__c = apps[0].Contact_Name__r.Office_Email_Id__c;
                            dedupe.Email_Office__c = apps[0].Contact_Name__r.Office_Email_Id__c;
                            dedupe.De_Dupe_Decision__c = 'None';
                            dedupe.De_Dupe_result__c = 'None';
                            if (apps[0].Contact_Name__r.Customer_Type__c == 'Corporate')
                                dedupe.First_Name__c = apps[0].Contact_Name__r.Name;
                            else {
                                String name1 = apps[0].Contact_Name__r.Name;
                                if (name1 != null) {
                                    if (name1.contains(' ')) {
                                        list < string > splitname = name1.split(' ');
                                        if (splitname[0] != null)
                                            dedupe.First_Name__c = splitname[0];
                                        if (splitname[1] != null)
                                            dedupe.last_Name__c = splitname[1];
                                    }
                                }
                                
                                dedupe.Middle_Name__c = apps[0].Contact_Name__r.Middle_Name__c;
                            }
                            
                            dedupe.Datafix_Updated__c = 'New records';
                            dedupe.Application_Status__c = 'Complete';
                            if (loan[0].Quality_Check_Status__c == 'Dedupe')
                                dedupe.Application_ID__c = 'Dedupe';
                            //insert dedupe;
                            sObjLstIn.add(dedupe);
                            system.debug('insert end here');
                        }
                        
                        if (Trigger.Isupdate) {
                            system.debug('update strts here');
                            system.debug('app size' + apps.size());
                            if (apps.size() > 0) {
                                if (apps[0].Contact_Name__r.PAN_Card_Status__c != null && apps[0].Contact_Name__r.PAN_Card_Status__c == 'Not in ITD Database') {
                                    SOL_Policy__c sp = new SOL_Policy__c();
                                    sp.Policy_Name__c = 'PAN Not in ITD Database';
                                    sp.Policy_Status__c = 'Reject';
                                    sp.Loan_Application__c = Loan[0].Id;
                                    sp.Created_From_Applicant__c = True;
                                    // PolicyList.add(sp);
                                }
                                
                                if (apps[0].Contact_Name__r.PAN_Card_Status__c != null && apps[0].Contact_Name__r.PAN_Card_Status__c == 'Fake PAN') {
                                    SOL_Policy__c sp = new SOL_Policy__c();
                                    sp.Policy_Name__c = 'Fake PAN';
                                    //sp.Policy_Status__c='Reject';
                                    sp.Policy_Status__c = 'Rejected';
                                    sp.Loan_Application__c = Loan[0].Id;
                                    sp.Created_From_Applicant__c = True;
                                    
                                    PolicyList.add(sp);
                                }
                                
                                if (apps[0].Contact_Name__r.PAN__c != null && (apps[0].Contact_Name__r.PAN__c.startsWith('C') || apps[0].Contact_Name__r.PAN__c.startsWith('D'))) {
                                    SOL_Policy__c sp = new SOL_Policy__c();
                                    sp.Policy_Name__c = 'PAN Number Starts with C or D';
                                    sp.Policy_Status__c = 'Refer';
                                    sp.Loan_Application__c = Loan[0].Id;
                                    sp.Created_From_Applicant__c = True;
                                    
                                    PolicyList.add(sp);
                                }
                            }
                        }
                    }
                    for (Applicant__c App: Trigger.new) {
                        if (App.CIBIL_Score__c != null) {
                            if (App.CIBIL_Score__c == '000-1')
                                cibil = True;
                            else
                                CibilScore = Integer.valueof(App.CIBIL_Score__c);
                        }
                        if (Loan.size() > 0 && App.CIBIL_Score__c != null && (CibilScore < 700 || cibil == True)) {
                            SOL_Policy__c sp = new SOL_Policy__c();
                            sp.Policy_Name__c = 'CIBIL Score';
                            sp.Policy_Status__c = 'Rejected';
                            sp.Loan_Application__c = Loan[0].Id;
                            sp.Created_From_Applicant__c = True;
                            PolicyList.add(sp);
                        }
                        
                        System.debug('Check for new SOL FLow ' + newSOLFlow);
                        if (newSOLFlow && Loan.size() > 0 && salList != null && salList.size() > 0 && salList[0].percentage_completion__c != null && salList[0].percentage_completion__c == '60' && Loan[0].stageName == 'Incomplete Application') {
                            System.debug('Check for Cibil Score for new flow ' + App.CIBIL_Score__c + ' ' + CibilScore);
                            if (App.CIBIL_Score__c != null && (CibilScore >= 700 && cibil != True) && Trigger.oldmap.get(App.id).CIBIL_Score__c != Trigger.Newmap.get(App.id).CIBIL_Score__c) {
                                
                                System.debug('Auto Approve Application ');
                                Loan[0].StageName = 'Auto Approved';
                                sObjLstUp.add(Loan[0]);
                                //update Loan[0];
                                
                            }
                        }
                        
                        
                        //Modified for #7095 Enhancement. Stamping of Cibil Score on Salaried record    
                        if (Trigger.Isupdate && App.Cibil_Score__c != null) {
                            if (Trigger.oldmap.get(App.id).CIBIL_Score__c != Trigger.Newmap.get(App.id).CIBIL_Score__c) {
                                
                                if (sol.size() > 0) {
                                    if (App.Cibil_Score__c == '000-1')
                                        sol[0].cibil_Score__c = 1;
                                    else
                                        sol[0].cibil_Score__c = Integer.valueof(App.Cibil_Score__c);
                                    sObjLstUp.add(sol[0]);
                                }
                                
                                if (!CommonUtility.isEmpty(salList)) {
                                    salList[0].CIBIL_Score__c = App.Cibil_Score__c;
                                    sObjLstUp.add(salList[0]);
                                }
                            }
                        }
                    }
                }
                
                if (PolicyListUpdate.size() > 0)
                    Delete PolicyListUpdate;
                if (PolicyList.size() > 0)
                    sObjLstIn.addAll((List < sObject > ) PolicyList);
                //}
                
                // End New Code
                if (!CommonUtility.isEmpty(sObjLstIn)) {
                    insert sObjLstIn;
                }
                
                if (!CommonUtility.isEmpty(sObjLstUp)) {
                    update sObjLstUp;
                }
              
  
            //harsit---optimization start
            // No use of the following method call. In this method, updating the contact objects without modifying it.
               
            // ApplicanttoCibilTemp_triggerHandler.updateCon(conIds);
            
            //harsit---optimization end
            /*List<Contact> conList = new List<Contact>();
if(conIds.size() > 0)
conList = [select id from Contact where id in :conIds];

System.debug('**********conList: '+conList);
if(conList != null && conList.size() > 0){
update conList;
}*/
        }
            //Bug #12062 E - added isAfter condition
            //Bug #12062 S
            if (Trigger.IsBefore && Trigger.isUpdate) {
                set < id > conId = new set < id > ();
                Set < String > ccCustTypelbl = new Set < String > ();
                Set < String > ccAppTypelbl = new Set < String > ();
                Map < Id, String > appContMap = new Map < Id, String > ();
                List < Contact > conLst = new List < Contact > ();
                if (Label.Credit_Card_Applicant_Type != null) {
                    String[] arr = Label.Credit_Card_Applicant_Type.split(';');
                    for (String str: arr) {
                        ccAppTypelbl.add(str.ToUpperCase());
                    }
                }
                if (Label.Credit_Card_Cust_Type != null) {
                    String[] arr = Label.Credit_Card_Cust_Type.split(';');
                    for (String str: arr) {
                        ccCustTypelbl.add(str.ToUpperCase());
                    }
                }
                List < string > messages = new List < string > ();
                List < string > mobileNumbers = new List < string > ();
                for (Applicant__c app: Trigger.New) {
                    conId.add(app.Contact_Name__c);
                }
                if (conId != null && conId.size() > 0) {
                    conLst = [select id, Customer_Type__c, Mobile__c from contact where id IN: conId];
                }
                for (Applicant__c app: Trigger.New) {
                    for (Contact cont: conLst) {
                        if (app.Contact_Name__c == cont.id) {
                            appContMap.put(app.id, cont.Customer_Type__c);
                        }
                    }
                }
                for (Applicant__c appObj: Trigger.New) {
                    if ((!appObj.CC_Msg_Sent__c) && appObj.Credit_Card_Check__c && appObj.Credit_Card_Photo_COllected__c && appObj.used_for_Domestic_Purpose_Credit_Card__c && appObj.Credit_Card_QC_DOne__c && appObj.Sales_Consent_on_Credit_Card__c && appObj.Email_ID__c != null) {
                        if (ccCustTypelbl != null && ccCustTypelbl.size() > 0 && ccAppTypelbl != null && ccAppTypelbl.size() > 0 && ccAppTypelbl.contains(appObj.Applicant_Type__c.ToUpperCase()) && appContMap.get(appObj.id) != null && ccCustTypelbl.contains(appContMap.get(appObj.id).ToUpperCase())) {
                            if (Label.Credit_Card_Msg_label != null) {
                                messages.add(Label.Credit_Card_Msg_label);
                            }
                            mobileNumbers.add(appObj.Contact_Mobile__c);
                            appObj.CC_Msg_Sent__c = true;
                        }
                    }
                }
                if (messages.size() > 0 && mobileNumbers.size() > 0) {
                    sendsms.sendBulkSMS(messages, mobileNumbers);
                }
            }
            //Bug #12062 E
        }
    }
    }//23567 (If ends)
}