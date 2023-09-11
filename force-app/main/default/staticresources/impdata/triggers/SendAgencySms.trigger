/** 
* File Name: SendAgencySms
* Description: This trigger is used to send sms
* agency mobile and send email to agency
* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 
* @author : Wipro
* Modification Log 
* =============================================================== 
* Ver   Date        Author      Modification 
* --- ---- ------ ------------- ---------------------------------
* 1.0   01-Jun-10  Raji Created 
* 
* 3.0   18- Feb-16 Vikas jadhav   NULL check and commented Opp which is not used and 
* 4.0   7 march -16 commented repeated loop of Remarks NULL check
* 5.0   Indentation, Added fields for the email bodies. @YS 15th Oct 2016
*/ 
trigger SendAgencySms on Verification__c (after insert,after update) 
{
  if (!ControlRecursiveCallofTrigger_Util.hasSendAgencySms()) 
  {
        ControlRecursiveCallofTrigger_Util.setSendAgencySms();
        List<String> phone =new List<String>();
    
        // Start of invisible monitoring variables
        Set<String> phoneForInvisibleMonitoring = new Set<String>();
        String ACMMobile, ASMMobile, DSAMobile;
        boolean SMSFlag = false;
        Map<String,String> MapOfAddToBody = new Map<String,String>();
        List<String> listmsg = new List<String>();
        List<String> contactNum = new List<String>();
        List<String> prodList = new List<String>(); //Responsys API Integration added by Krish
        String Subject='Verification Agency Mail';
        Boolean isRSA = false;
        // End of invisible monitoring variables

        //--------------- Mortgage Re-Engg Start---------------------
        String senderEmailId ='',replyTo='';
        List<Id> propList = new List<Id>();
        Map<Id,Property_Details__c> propMap = new Map<Id,Property_Details__c>(); 
        
        if (LaonApplicationCreation__c.getValues('Mortgage Products') != NULL) 
        {
            String MortgageVerEmailId = LaonApplicationCreation__c.getValues('Mortgage Products').Sal_Line_Manager_email__c;
            if (MortgageVerEmailId != NULL) 
            {
                system.debug('***MortgageVerEmailId***' + MortgageVerEmailId);
                String[] arr = MortgageVerEmailId.split(';');
                if(arr != NULL && arr.size()>0)
                {
                  senderEmailId = arr[0];
                }
             }
              
             String MortgageRepEmailId = LaonApplicationCreation__c.getValues('Mortgage Products').Sales_Level_1__c;
             if (MortgageRepEmailId != NULL) 
             {
               system.debug('***MortgageRepEmailId***' + MortgageRepEmailId);
                String[] arr = MortgageRepEmailId.split(';');
                if(arr != NULL && arr.size()>0 && arr[0] != NULL)
                {
                    replyTo = arr[0];
                }
             }
    }
        System.debug('senderEmailId='+senderEmailId);       
        
        //--------------- Mortgage Re-Engg End-----------------------
    List<String> emailArray = new List<String>();
    List<Id> Oppty = new List<Id>();
    String ph = NULL, mess = NULL;
    String loanNumber;
    Integer flag = 0,flagEmail,flagLoan;
    Map<String,String>vermap1=new  Map<String,String>();
    Map<String,List<Verification__c>> vermap = new Map<String,List<Verification__c>>();
    list<Verification__c> verfylist=new list<Verification__c>();
    List<Applicant__C> lstApplicant = new List<Applicant__c>();
    List < verification__c > verList = new List < verification__c> (); //Responsys Dynamic Parameters Bug 15653
    /*Responsys Dynamic Parameters Bug 15653 s*/
    List < Opportunity > LoanList = new List < Opportunity> ();
    List < Id > oppId = new List < Id> ();
    List < Id > veridList = new List < Id> ();//prod adhoc
    for(Verification__c ver: trigger.new){
      oppId.add(ver.Loan_Application__c);
      if(ver.Initiated_by_invisible_monitoring__c != null && ver.Initiated_by_invisible_monitoring__c == true)
        veridList.add(ver.Verification_Agency__c);//prod adhoc
    }
   
    map<Id,Verification_Agency_Master__c> verAgencyMap = new Map<Id,Verification_Agency_Master__c>();//([SELECT Id,Mail_Id__c  FROM Verification_Agency_Master__c where Id IN: veridList]);//prod adhoc
    for(Verification_Agency_Master__c veragency :[SELECT id,Mail_Id__c  FROM Verification_Agency_Master__c where Id IN: veridList])
    {
      verAgencyMap.put(veragency.id,veragency);
    }
    List<Opportunity> LoanListId = new List<Opportunity>(); 
    Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();

    LoanListId = [SELECT id,/*20939 s*/Loan_Application_Number__c,ACM__r.Email,CPA__r.Email,Account.Flow__c/*20939 e*/ from Opportunity where Id IN: oppId];
    for(Opportunity opp:LoanListId){
      oppMap.put(opp.id,opp);
    }
    system.debug('oppMap'+oppMap);
    /*Responsys Dynamic Parameters Bug 15653 e*/
    //setting replyTo for the attachment upload thr Email purpose @YS 17th Oct 2016
    if(replyTo == NULL ||  replyTo.trim() == '')
    {  
      replyTo = Label.Verification_Inbound_Email_Id;
    }
    
    for (Verification__c ver: trigger.new)
    {
        //Start of invisible monitoring changes
        //if(ver.Initiated_by_invisible_monitoring__c == true)
            //ControlRecursiveCallofTrigger_Util.resetSendAgencySms();
        //End of invisible monitoring changes

      //psbl start
      loanNumber=ver.Loan_Application_Number__c;
      System.debug('loanNumber 1 ==> ' + loanNumber);
     // mess = 'Dear Sir, Bajaj Finserv Lending  has initiated a new verification for Loan application no ' + loanNumber;//Commenting for Responsys Dynamic Parameters Bug 15653
      flag = 0;
      flagEmail = 0;
      flagloan = 0;
      
      //making the Loan array
      for(Id loadApplicationId : Oppty)
      {
        if(ver.Loan_Application__c == loadApplicationId)
        {
          flagloan=1;
        }
      }
         
         if(flagLoan==0 && String.isnotempty(ver.Loan_Application__c))
         {
           Oppty.add(ver.Loan_Application__c);
         }
   
          for(String strPhone : phone)
          {
            if(ver.agency_mobile__c !=NULL && ver.agency_mobile__c== strPhone)
            {
                  flag=1;
            }
          }//end of for
          
            //sending sms to agency   
           //Start of invisible monitoring changes
           if(flag==0 && ver.agency_mobile__c != NULL)
           {
              //Commenting below code for Responsys Dynamic Parameters Bug 15653
              /*ph=ver.agency_mobile__c;
              phone.add(ph);
              phoneForInvisibleMonitoring.add(ph);
              System.debug('Verification agency mobile 1 ==> ' + ph);*/
              
              if(ver.Initiated_by_invisible_monitoring__c == false) 
              {
                  //sendsms.message(ph,mess);//Commenting  for Responsys Dynamic Parameters Bug 15653
                  LoanList.add(oppMap.get(ver.Loan_Application__c)); //Responsys Dynamic Parameters Bug 15653
                  verList.add(ver);//Responsys Dynamic Parameters Bug 15653 
                  //System.debug('Not due to invisible monitoring !!');
              }
              else
              {
                System.debug('Due to invisible monitoring !!');
              }    
           }
           //End of invisible monitoring changes
/*Opp=[Select Id,Name,Loan_Application_Number__c,ASM_email_id__c, Sales_Manager_E_Mail__c from Opportunity
where Id in:Oppty];*/
   
          
         //getting agency mobile
          for(String strEmail : emailArray)
         {
              if(ver.Agency_Email__c != NULL && ver.Agency_Email__c==strEmail)
              {
                  flagemail=1;
                }
          } 
        //getting agency email
         if(flagEmail==0 && ver.Agency_Email__c !=NULL)
         {
           emailArray.add(ver.Agency_Email__c);
        }   
          // Verifying the code needhi
            system.debug('before null check '+oppty);
            if(oppty!= null && oppty.size() > 0 ) {
            system.debug('hhhhhhhhhhhhhhhhhhhllllllllllllll'+oppty);
            verfylist=[select id,Agency_Email__c,Verification_Agency__r.name,Loan_Application__c,Applicant__r.RSA_Flag__c,Applicant__r.Applicant_Type__c from Verification__c where Loan_Application__c in :Oppty];
            lstApplicant = [select id,RSA_flag__c,Loan_Application__c from Applicant__c where Loan_Application__c in :Oppty and Applicant_Type__c = 'Primary'];
            system.debug('##########'+verfylist);
            }
            // needhi end
        if(ver.Agency_Email__c !=NULL)
        {
            List<Verification__c> tempver=new List<Verification__c>();
             
             if(vermap.containsKey(ver.Agency_Email__c))
              {
                tempver=vermap.get(ver.Agency_Email__c);
              }
        
              //tempver.add(ver); Done BY Rajendra Deleted this line cause it is adding verification multiple times in same list please do not uncomment it
             /* Changes added By Rajendra to restring Email to Verification Agency */ 
             
            for(Verification__c vr:verfylist)
            {
                System.Debug('vr.id ' + vr.id + ' Ver.ID ' + ver.ID + ' vr.Applicant__r.RSA_Flag__c ' + vr.Applicant__r.RSA_Flag__c + ' vr.Applicant__r.Applicant_Type__C' + vr.Applicant__r.Applicant_Type__C);
                System.debug('Ver details ' + vr.Applicant__r.RSA_Flag__c + ' Applicant Type ' + vr.Applicant__r.Applicant_type__c);
                if(vr.Id == ver.Id)
                {
                    System.Debug('Zali dewa match --> lstApplicant is ' + lstApplicant);
                    for(Applicant__c tempApp: lstApplicant)
                    {
                        if(tempApp.Loan_Application__c == vr.Loan_Application__c)
                        
                            if(tempApp.RSA_Flag__c == true)
                                isRSA = true;
                        
                    }
                    /*if((ver.Applicant__r.RSA_Flag__c == true && ver.Applicant__r.Applicant_Type__C == 'Primary') || (vr.Applicant__r.RSA_Flag__c == true && vr.Applicant__r.Applicant_Type__C == 'Primary'))
                    {
                        isRSA = true;
                        System.Debug('Now isRSA flag is true ' + isRSA);
                        break;
                        System.debug('This is more than god');
                    }*/
                }
            }
            System.Debug('RSA flag value before check is ' + isRSA);
            if(!isRSA){
                System.debug('isRSA -->' + isRSA);
                tempver.add(ver);            
             vermap.put(ver.Agency_Email__c,tempver);
         }/* Changes by rajendra Ended here */
        }
        system.debug('vermap - '+vermap);
        //not for psbl
    }//end of for
    GeneralCommunicationHandler.sendSMS(LoanList,verList, 'Verification Initiate'); //Responsys Dynamic Parameters Bug 15653 
    Integer count = 0;
    system.debug('before NULL check '+oppty);
    if(oppty!= NULL && oppty.size() > 0 ) 
    {
      system.debug('Oppty : '+oppty);
      verfylist=[select /*20939 s*/Status__c,Remarks__c,/*20939 e*/id,Agency_Email__c,Verification_Agency__r.name,Loan_Application__c from Verification__c where Loan_Application__c in :Oppty];
      system.debug('verfylist :'+verfylist);
    }
    for(Verification__c v:verfylist)
    {
      if(v.Agency_Email__c != NULL)
      {
        vermap1.put(v.Agency_Email__c,v.Verification_Agency__r.name);
      }
      system.debug('Verification Map : '+vermap1);
    }
    
    
        //--------------- Mortgage Re-Engg Start---------------------
          for(Verification__c v:Trigger.New)
          {
            
            Set<String> propVerSet  = new Set<String>{
                   'PROPERTY VERIFICATION','2ND OPINION LEGAL',
                                'VETTING REPORT','SPECIAL VALUATION',
                                'LEGAL','VALUATION','NOC', 'OCR', 'MODT',
                                'LEGAL & PROPERTY DOCUMENTS','TSR',
                                'LAND/BUILDING & PLOT VALUATION',
                                'SOCIETY SHARE CERTIFICATE','BT TRANSACTION',
                                'ENCUMBRANCE CERTIFICATE VERIFICATION',
                                'REGISTRATION TRANSACTION'
              };
              
            //value added in if by akshata for verification billing phase 2 : uat bug 13426
            // added null check by pankaj
            if(v.Verification_Type__c!=null && propVerSet.contains(v.Verification_Type__c.toUpperCase()) && v.Property_Details__c != NULL)
            {
                  propList.add(v.Property_Details__c);  
            }
        }
            
            if(propList.size()>0)
            {
              for(Property_Details__c p:[Select id, BT_Bank_Name__c, Name,Address__c,Property_Type__c,Property_Transaction_Type__c,Current_Property_Owner__c,Property_Plan__c,Latest_Ownership_Document__c,
                              Date_and_Time_for_Technical__c,Contact_Person_for_Technical__c,Contact_Person_for_Number__c, SRO_Name__c, Sale_deed_Regn_No__c From Property_Details__c where Id IN:propList])
                {
                    propMap.put(p.Id,p);
                }
            }
            
            System.debug('propMap='+propMap.size());
        //--------------- Mortgage Re-Engg End-----------------------

    if(trigger.isInsert ) 
    {
    
        /* Added By Ankush Bug ID 14128 start */  
        Integer mandatoryIndex = 1;   //15506 Pro Doc Invisible Monitoring 
        Map<String,Map<String,Object>> mapJSONEmail = new Map<String,Map<String,Object>>(); //15506 Pro Doc Invisible Monitoring
        Boolean allowExceptMndtEmail =false; //15506 Pro Doc Invisible Monitoring
        /* Added By Ankush Bug ID 14128 End */
            
                               
        for(String mail : vermap.keyset())
        {
            //Fetching all contact Ids of all verifications 
            //for all verifications, as lookup fields are not accessible 
            //in trigger. Hence applying this approach. 
            //Doing to resolve #10830 Bank Account type's NULL error. 
            Set<Id> setVerificationIds = new Set<Id>();
            Map<String, Id> mapVerifNameToContactId = new Map<String, Id>();
            Map<Id, Contact> mapContacts = new Map<Id, Contact>();

            for(Verification__c objVerify : vermap.get(mail) )
            {
                if(objVerify.Verification_Type__c == 'Bank Statements')
                {
                    System.debug('Verification code : ' + objVerify.Name + '---Contact : ' +  objVerify.Contact__c);
                    setVerificationIds.add(objVerify.Contact__c);
                    mapVerifNameToContactId.put(objVerify.Name, objVerify.Contact__c);
                }
            }
            System.debug('Verification set:'+ setVerificationIds);
            if(setVerificationIds!=null){
                mapContacts = new Map<Id, Contact>([select id, Bank_Account_type__c from Contact where id in : setVerificationIds]);
                System.debug('Contact map :'+ mapContacts );
            }
            string LineBreak='<br/>'; //added by mahima- 13017 to reduuce line breaks <br/>
    /*String mailage='',mailData='',mailBody='',mailBodyBank='<br></br>',mailBodyITR='<br></br>',mailBodyRes='<br></br>',mailBodyOff='<br></br>',mailBodySal='<br></br>',mailBodyTel='<br></br>',mailBodyTra='<br></br>', mailBodyROC='<br></br>',mailBodyPAN='<br></br>', mailBodyCA='<br></br>',mailBodyMVR='<br></br>',mailBodyTRC='<br></br>',mailBodyFRC='<br></br>',mailBodySRC='<br></br>',
     mailBodyFCU='<br></br>',mailBodyPay='<br></br>',mailBodyVal='<br></br>',mailBodyProp='<br></br>',mailBodyLeg='<br></br>',consolidated='',mailBodyValuation='<br></br>';*/

    
            //Below code block added by mahima- 13017 to reduuce line breaks <br/>
            String mailage='',mailData='',mailBody='',mailBodyBank='',mailBodyITR='',mailBodyRes='',mailBodyOff='',mailBodySal='',mailBodyTel='',mailBodyTra='', mailBodyROC='',mailBodyPAN='', mailBodyCA='',mailBodyMVR='',mailBodyTRC='',mailBodyFRC='',mailBodySRC='',
            mailBodyFCU='',mailBodyPay='',mailBodyVal='',mailBodyProp='',mailBodyLeg='',consolidated='',mailBodyValuation='';       
           
            String mailOthers  = '<br></br>';
            String[] toAddress=new String[1];
            
            system.debug('%%%%%%%%%%%%%%%%'+vermap.get(mail));
            String remarks   = '';
            String accountNo = '';
            String bankName  = '';
            String verificationRate  = '';
            
            String loan_app_number = '';
            String ver_category = '';
            String ver_Product  = '';
            String accFlow = ''; //20939 RCU
        for(Verification__c verify : vermap.get(mail))
        {
            if(oppMap.get(verify.Loan_Application__c) != null)
            accFlow = oppMap.get(verify.Loan_Application__c).Account.Flow__c; //20939 s
            Subject += 'LAN No:'+verify.Loan_Application_No__c+' Verification Id:'+verify.Name+'#';
                        
                if(verify.Name_of_the_Bank__c != 'NULL' || verify.Name_of_the_Bank__c != NULL)
                {
                    bankName  =  verify.Name_of_the_Bank__c;
                }
                else{
                    bankName  = '';
                }
            
                if(verify.Account_No__c != 'NULL' || verify.Account_No__c != NULL)
                {
                accountNo = verify.Account_No__c ;
                }else{
                    accountNo = '';
                }
                
                if(verify.Remarks__c !='NULL' || verify.Remarks__c != NULL)
                {
                    remarks = verify.Remarks__c;
                }
                else{
                    remarks = '';
                }
                
                
                if( verify.VerificationRate__c  != NULL )
                {
                    verificationRate = ''+ verify.VerificationRate__c ;
                }
                else{
                    verificationRate  = '';
                }
                
                if(verify.Loan_Application_No__c != null){
                    loan_app_number = verify.Loan_Application_No__c;
                }
                else{
                    loan_app_number = '';
                }
                
                if(verify.VerificationCategory__c != NULL){
                    ver_category = verify.VerificationCategory__c;
                }else{
                    ver_category  = '';
                }
                
                if(verify.Product__c != NULL){
                    ver_Product = verify.Product__c;
                }else{
                    ver_Product = '';
                }
                
                /* Added By Ankush Bug ID 14128 start */
                //15506 Pro Doc Invisible Monitoring Start
                if(verify.Verification_Type__c != 'ITR' && verify.Verification_Type__c != 'FINANCIAL VERIFICATION' && verify.Verification_Type__c != 'Profile Verification'){
                    allowExceptMndtEmail = true; 
                }
                //15506 Pro Doc Invisible Monitoring End
                /* Added By Ankush Bug ID 14128 End */
                
    
                if( verify.Verification_Type__c == 'Bank Statements')
                {
                    String accountType = 'Not Specified';
                    if(mapVerifNameToContactId != NULL && mapVerifNameToContactId.get(verify.Name) != NULL && mapContacts != NULL &&
                        mapContacts.get( mapVerifNameToContactId.get(verify.Name) ) != NULL &&  mapContacts.get( mapVerifNameToContactId.get(verify.Name) ).Bank_Account_type__c != NULL)
                    {
                        accountType  = mapContacts.get( mapVerifNameToContactId.get(verify.Name) ).Bank_Account_type__c  ;
                    }
                    System.debug('Account type : '+ accountType);
                    
                    mailBodyBank +='<b><u>Verification Type: Bank Verification</u></b>'+'<br><br>';
                    mailBodyBank +=  '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency    <b/></th>'
                            +'<th><b>  Loan Application No    </b></th>'
                            +'<th><b>  Applicant Name       </b></th>'
                            +'<th><b>  Applicant Type       </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks              </b></th>'                        
                            +'<th><b>  Bank Name                </b></th>'
                            +'<th><b>  Branch               </b></th>'
                            +'<th><b>  Account No               </b></th>'
                            +'<th><b>  Product                  </b></th>'
                            +'<th><b>  Account Type             </b></th>'
                            +'</tr>';
                    
                
                    mailBodyBank += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Applicant_Type__c                   +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                                    +'</td>'
                            +'<td>'+ bankName                                   +'</td>'
                            +'<td>'+ verify.Branch__c                           +'</td>'
                            +'<td>'+ accountNo                                  +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'<td>'+ accountType                                +'</td>'
                        +'</tr></table>';
                    mailBodyBank += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
                }
                //for ITR
                if( verify.Verification_Type__c.equalsIgnoreCase('ITR'))
                {
                   
                   //15506 Pro Doc Invisible Monitoring start
                    /* Added By Ankush Bug ID 14128 start, Implemented New Mail Login as per Requirnment */
                    string mandSubject = verify.Verification_Type__c + ' verification raised for Loan Application Number ' + verify.Loan_Application_No__c;
                    System.Debug('SendAgencySMS Profile verification condition is matched');                
                                   
                
                    Map<String,Object> mapJSONElement = MandatoryVerificationHandler.SendEmailForMandatoryVerification(verify,mandSubject);
                    System.debug('mapJSONElement'+mapJSONElement);
                   
                   
                    //Run for Batch
                    if(System.isBatch() && mapJSONElement!=null && mapJSONElement.size()>0){
                        mapJSONEmail.put('mandatory'+mandatoryIndex,mapJSONElement);
                        mandatoryIndex++; 
                    }
                    
                    //15506 Pro Doc Invisible Monitoring End
                    /* Added By Ankush Bug ID 14128 start, Implemented New Mail Login as per Requirnment */
                
                    /*
                    mailBodyITR += '<b><u>Verification Type: ITR Verification</u></b>'+'<br><br>';
                    mailBodyITR += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency          <b/></th>'
                            +'<th><b>  Loan Application No          </b></th>'
                            +'<th><b>  Applicant Name               </b></th>'
                            +'<th><b>  Verification Code            </b></th>'
                            +'<th><b>  Verification Type            </b></th>'  
                            +'<th><b>  Verification Category        </b></th>'  
                            +'<th><b>  Verification Rate            </b></th>'                            
                            +'<th><b>  Remarks                      </b></th>'                        
                            +'<th><b>  Assessment Year              </b></th>'
                            +'<th><b>  Acknowledgment No            </b></th>'
                            +'<th><b>  Date of ITR                  </b></th>'
                            +'<th><b>  Product                      </b></th>'
                            +'</tr>'; 
                          
                    mailBodyITR += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                            +'</td>'
                            +'<td>'+ verify.Assessment_year__c                  +'</td>'
                            +'<td>'+ verify.Acknowledgement_No__c               +'</td>'
                            +'<td>'+ verify.Date_of_ITR_Filing__c               +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                            
                    mailBodyITR += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/> */
                }
                
                /* Added By Ankush Bug ID 14128 start */
                //15506 Pro Doc Invisible Monitoring Start
                /* New Profile Verification Condition */
                if( verify.Verification_Type__c.equalsIgnoreCase('Profile Verification')){
             
                    string mandSubject = verify.Verification_Type__c + ' Raised for Loan Application Number ' + verify.Loan_Application_No__c;
                    System.Debug('SendAgencySMS Profile verification condition is matched');
                                           
                    Map<String,Object> mapJSONElement = MandatoryVerificationHandler.SendEmailForMandatoryVerification(verify,mandSubject);
                    System.debug('mapJSONElement'+mapJSONElement);
                 
                    //Run for Batch
                    if(System.isBatch() && mapJSONElement!=null && mapJSONElement.size()>0){
                        mapJSONEmail.put('mandatory'+mandatoryIndex,mapJSONElement);
                        mandatoryIndex++; 
                    }
               
                    System.Debug('Email sent and no exception occured.');
                   /* Added By Ankush Bug ID 14128 End */
                   //15506 Pro Doc Invisible Monitoring End  
               }
                
               //for FCU
                if( verify.Verification_Type__c == 'FCU')
                {
                    mailBodyFCU += '<b><u>Verification Type: FCU Verification</u></b>'+'<br>'+'<br>';
                    mailBodyFCU += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'  
                            +'</tr>';
                          
                    mailBodyFCU +='<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                            +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                    mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
            //for Office
            if( verify.Verification_Type__c == 'Office verification')
            {
                String ofcAddress = '';
                
                if(verify.Address__c != NULL)
                {
                  ofcAddress = verify.Address__c;
                }
                else if(verify.Contact_Office_Address__c != NULL )
                {
                  ofcAddress = verify.Contact_Office_Address__c;
                }else if(verify.Employer_Address__c != NULL)
                {
                  ofcAddress = verify.Employer_Address__c;
                }
                
                    String empName = (verify.Employer_Name__c == null ? '' : verify.Employer_Name__c); 
                    String phNum = '';
                    if(verify.Phone_number__c != null) {
                        phNum = '' + verify.Phone_number__c;
                    }
                    String mobNum = '';
                    if(verify.Mobile_Number__c != null){
                        mobNum = '' + verify.Mobile_Number__c;
                    } 
                
                    mailBodyoff += '<b><u>Verification Type: Office Verification</u></b>'+'<br>'+'<br>';
                    mailBodyoff += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'
                            +'<th><b>  Name Of the Employer     </b></th>'
                            +'<th><b>  Office Landline Number   </b></th>'
                            +'<th><b>  Mobile Number            </b></th>'
                            +'<th><b>  Office Address           </b></th>'
                            +'</tr>';
                           
                    mailBodyoff += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                           +'</td>'
                            +'<td>'+ remarks                                    +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'<td>'+ empName                                    +'</td>'
                            +'<td>'+ phNum                                      +'</td>'
                            +'<td>'+ mobNum                                     +'</td>'
                            +'<td>'+ ofcAddress                                 +'</td>'
                            +'</tr></table>';
                    mailBodyoff += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
            //for payslip
            if( verify.Verification_Type__c == 'Pay Slips' || verify.Verification_Type__c == 'Salary Slip Format')
            {
               /*List<Bank_Account__c> lstBankAcct = [select id, Salary_Credit_Date1__c, applicant__c,
                                     Salary_Credit_Date2__c, Salary_Credit_Date3__c
                                  from 
                                      Bank_Account__c 
                                  where 
                                      applicant__c 
                                  in 
                                      (
                                   select 
                                      applicant__c 
                                  from 
                                      Verification__c 
                                  where 
                                      applicant__r.Applicant_Type__c='Primary' 
                                  and 
                                      id =:  verify.Id
                                  )
                                 ];
               
               String creditDate1 = 'Not specified.';
               String creditDate2 = 'Not specified.';
               String creditDate3 = 'Not specified.';
               if(lstBankAcct != NULl & lstBankAcct.size() > 0  )
               {
                 //there is only one primary applicant, hence only one applicant's bank acct is considered.
                 //Considering first Bank account as by default.
                 if(lstBankAcct[0].Salary_Credit_Date1__c != NULL)
                 {
                   creditDate1 = '' + lstBankAcct[0].Salary_Credit_Date1__c;
                 }
                 if(lstBankAcct[0].Salary_Credit_Date2__c != NULL)
                 {
                   creditDate2 = '' + lstBankAcct[0].Salary_Credit_Date2__c;
                 }
                 if(lstBankAcct[0].Salary_Credit_Date3__c != NULL)
                 {
                   creditDate3 = '' + lstBankAcct[0].Salary_Credit_Date3__c;
                 } 
                } */
                remarks = remarks == null ? '' : remarks; 
                
                String employerName = (verify.Employer_Name__c == null ? '' : verify.Employer_Name__c);
                String designation =  (verify.Designation__c == null ? '' : verify.Designation__c);
                String telNum  = '';
                if(verify.Telephone_Number__c != null){
                    telNum = '' + verify.Telephone_Number__c;
                } 
                
                String mobNum  = '';
                if(verify.Mobile_Number__c != null){
                    mobNum = '' + verify.Mobile_Number__c;
                }
                
                String netSal  = '';
                if(verify.Net_Salary__C != null){
                    netSal  = '' + verify.Net_Salary__C;
                } 
                
                
                String month = (verify.Month__c == null ? '' : verify.Month__c);
                
                mailBodyPay += '<b><u>Verification Type: PaySlip Verification</u></b>'+'<br>'+'<br>';
                    mailBodyPay += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'
                            +'<th><b>  Name Of the Employer     </b></th>'
                            +'<th><b>  Designation              </b></th>'
                            +'<th><b>  Telephone Number         </b></th>'
                            +'<th><b>  Mobile Number            </b></th>'
                            +'<th><b>  Bank Name                </b></th>'
                            +'<th><b>  Bank Account Number      </b></th>'
                            +'<th><b>  Branch Name              </b></th>'
                            +'<th><b>  Month                    </b></th>'
                            +'<th><b>  Salary Credit Date       </b></th>'
                            +'<th><b>  Net Salary               </b></th>'
                            +'</tr>';
                            
                           /* commented for CR.+'<th><b>  Salary Credit Date2      </b></th>'
                            +'<th><b>  Salary Credit Date3      </b></th>' */
                            
                    mailBodyPay += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                           +'</td>'
                            +'<td>'+ remarks                                    +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'<td>'+ employerName                               +'</td>'
                            +'<td>'+ designation                                +'</td>'
                            +'<td>'+ telNum                                     +'</td>'
                            +'<td>'+ mobNum                                     +'</td>'
                            +'<td>'+ bankName                                   +'</td>'
                            +'<td>'+ accountNo                                  +'</td>'
                            +'<td>'+ verify.Branch__c                           +'</td>'
                            +'<td>'+ month                                      +'</td>'
                            +'<td>'+ verify.Salary_Credit_Date__c               +'</td>'
                            +'<td>'+ netSal                                     +'</td>'
                           /* +'<td>'+ creditDate2                                +'</td>'
                            +'<td>'+ creditDate3                                +'</td>' */
                            +'</tr></table>';
                    mailBodyPay += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/> 
                        
            }
            //for Residence verification
            if( verify.Verification_Type__c == 'Residence verification')
             {
                    mailBodyRes += '<b><u>Verification Type: Residence Verification</u></b>'+'<br>'+'<br>';
                    mailBodyRes += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'
                            +'<th><b>  Mobile Number            </b></th>'
                            +'<th><b>  Address                  </b></th>'
                            +'</tr>';
                           
                    mailBodyRes += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                          +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'                          
                            +'<td>'+ verify.Mobile_Number__c                    +'</td>'
                            +'<td>'+ verify.Address__c                          +'</td>'
                            +'</tr></table>';
                    mailBodyRes += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/> 
            }
            //for Tele verification
            if( verify.Verification_Type__c == 'Tele Verification' || verify.Verification_Type__c == 'TELE' || 'TELE PD' == verify.Verification_Type__c)
            {
                    mailBodyTel += '<b><u>Verification Type: Tele Verification</u></b>'+'<br>'+'<br>';
                    mailBodyTel += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'<th><b>   Mobile No               </b></th>'
                                +'<th><b>   Address                 </b></th>'
                                +'</tr>';
                                   
                    mailBodyTel += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                          +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'    
                            +'<td>'+ verify.Mobile_Number__c                    +'</td>'
                            +'<td>'+ verify.Address__c                          +'</td>'
                            +'</tr></table>';
                    mailBodyTel += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/> 
            }
            //for Trade Verification
            if( verify.Verification_Type__c == 'TSR')
                {
                  mailBodyTra +='<b><u>Verification Type: TSR</u></b>'+'<br><br>';         
                  mailBodyTra += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'<th><b>  Propery Address          </b></th>'
                                +'</tr>';

            String properyAddress ='';
            if(verify.Property_Details__c != NULL && propMap != NULL && propMap.get(verify.Property_Details__c) != NULL && propMap.get(verify.Property_Details__c).Address__c != NULL)
            {
              properyAddress = propMap.get(verify.Property_Details__c).Address__c;
            }
                                
                    mailBodyTra += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                          +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'<td>'+ properyAddress                +'</td>'
                            +'</tr></table>';
                    mailBodyTra += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/> 
            }
            //for ROC Verification
            if( verify.Verification_Type__c == 'ROC')
                {
                    mailBodyROC  += '<b><u>Verification Type: ROC Verification</u></b>'+'<br>'+'<br>';         
                    mailBodyROC += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'
                            +'</tr>';
                          
                    mailBodyROC += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                          +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                    mailBodyROC += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
            if( verify.Verification_Type__c == 'PAN'  || verify.Verification_Type__c == 'PAN CARD')
                {
                  mailBodyPAN += '<b><u>Verification Type: PAN Verification</u></b>'+'<br>'+'<br>';
                  mailBodyPAN += '<table border=1>'
                          +'<tr>'
                          +'<th><b>  Loan Application No    </b></th>'
                          +'<th><b>  Loan Application Name   </b></th>'
                          +'<th><b>  Contact Name       </b></th>'
                          +'<th><b>  Verification Code    </b></th>'
                          +'<th><b>  Verification Type    </b></th>'
                          +'<th><b>  Verification Category  </b></th>'
                          +'<th><b>  Verification Rate    </b></th>'
                          +'<th><b>  Verification Agency    </b></th>'
                          +'<th><b>  Remarks          </b></th>'
                          +'<th><b>  Product          </b></th>'
                          +'<th><b>  PAN Number        </b></th>'                          
                          +'</tr>';
                          
                mailBodyPAN +='<tr>'
                      +'<td>'+ loan_app_number        +'</td>'
                      +'<td>'+ verify.Loan_Application_Name__c      +'</td>'
                      +'<td>'+ verify.Contact_Name__c               +'</td>'
                      +'<td>'+ verify.Name                          +'</td>'
                      +'<td>'+ verify.Verification_Type__c          +'</td>'
                      +'<td>'+ ver_category       +'</td>'
                      +'<td>'+ verificationRate           +'</td>'
                      +'<td>'+ vermap1.get(mail)                    +'</td>'
                      +'<td>'+ remarks                    +'</td>'
                      +'<td>'+ ver_Product                    +'</td>'
                      +'<td>'+ verify.PAN_Number__c                 +'</td>'
                      +'</tr></table>';
                mailBodyPAN += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
            //for CA Verification
            if( verify.Verification_Type__c == 'CA')
                {
                    mailBodyCA += '<b><u>Verification Type: CA Verification</u></b>'+'<br>'+'<br>';
                    mailBodyCA += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'
                            +'</tr>';
                          
                    mailBodyCA += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                          +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                    mailBodyCA += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
            //for Mine Visit Report Verification
            if( verify.Verification_Type__c == 'Mine Visit Report')
                {
                    mailBodyMVR += '<b><u>Verification Type: Mine Visit Report Verification</u></b>'+'<br><br>';
                    mailBodyMVR += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'
                            +'</tr>';
                        
                    mailBodyMVR += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                          +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                    mailBodyMVR += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
            //for Trade Reference Check
            if( verify.Verification_Type__c == 'Trade Reference Check')
               {
                    mailBodyTRC += '<b><u>Verification Type: Trade Reference Check Verification</u></b>'+'<br><br>';
                    mailBodyTRC += '<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'
                            +'</tr>';
                          
                    mailBodyTRC +='<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';  
                    mailBodyTRC += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
            if( verify.Verification_Type__c == 'SPECIAL VALUATION')
                {
                    mailBodyFCU += '<b><u>Verification Type: SPECIAL VALUATION Verification</u></b>'+'<br><br>';
                    mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
                          
                    mailBodyFCU +='<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                    mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
          if( verify.Verification_Type__c == '2nd OPINION LEGAL')
                {
                    mailBodyFCU +='<b><u>Verification Type: 2nd OPINION LEGAL Verification</u></b>'+'<br><br>';
                    mailBodyFCU +='<table border=1>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
                          
                    mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                      +'</tr></table>';
                    mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }    
           if( verify.Verification_Type__c == 'OCR')
            {
                mailBodyFCU +='<b><u>Verification Type: OCR Verification</u></b>'+'<br><br>';
                mailBodyFCU +='<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
                          
                mailBodyFCU +='<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
          if( verify.Verification_Type__c == 'NOC')
                {
                  mailBodyFCU += '<b><u>Verification Type: NOC Verification</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
            
              mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                      +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
          if( verify.Verification_Type__c == 'CERTIFIED TRUE COPY DOCS')
                {
                  mailBodyFCU += '<b><u>Verification Type: CERTIFIED TRUE COPY DOCS Verification</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
            
              mailBodyFCU += '<tr>'  
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
        if( verify.Verification_Type__c == 'ENCUMBRANCE CERTIFICATE VERIFICATION')
        {
                  String salesDeedRegNumber = '';
                  String SROName = '';
                  String properyAddress='';
                  
                  if(propMap != NULL && propMap.size() > 0 && propMap.get(verify.Property_Details__c) != NULL && propMap.get(verify.Property_Details__c).Sale_deed_Regn_No__c != NULL)
                  { 
                     salesDeedRegNumber = '' + propMap.get(verify.Property_Details__c).Sale_deed_Regn_No__c;
                  }
                  if (propMap != NULL && propMap.size() > 0 && propMap.get(verify.Property_Details__c) != NULL && propMap.get(verify.Property_Details__c).SRO_Name__c != NULL) 
                  {
                    SROName = propMap.get(verify.Property_Details__c).SRO_Name__c;
                  }
                    if(verify.Property_Details__c != NULL && propMap.size() > 0 && propMap != NULL && propMap.get(verify.Property_Details__c).Address__c != NULL)
                    {
                      properyAddress = propMap.get(verify.Property_Details__c).Address__c;
                    }
                  
                  mailBodyFCU += '<b><u>Verification Type: ENCUMBRANCE CERTIFICATE Verification</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'<th><b>  Sale deed Registration No    </b></th>'
                                +'<th><b>  SRO Name                     </b></th>'
                                +'<th><b>  Property Address             </b></th>'
                                +'</tr>';
            
              mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'<td>'+ salesDeedRegNumber                         +'</td>'
                            +'<td>'+ SROName                                    +'</td>'
                            +'<td>'+ properyAddress                             +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        if( verify.Verification_Type__c == 'FORM 3 CA/CB/CD')
                {
                  mailBodyFCU += '<b><u>Verification Type: FORM 3 CA/CB/CD Verification</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
              mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        if( verify.Verification_Type__c == 'SOCIETY SHARE CERTIFICATE')
        {
                  mailBodyFCU += '<b><u>Verification Type: SOCIETY SHARE CERTIFICATE Verification</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
            
              mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
        if( verify.Verification_Type__c == 'FORM 16')
        {
                  mailBodyFCU += '<b><u>Verification Type: FORM 16 Verification</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
            
                mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
        if( verify.Verification_Type__c == 'KYC')
        {
                  mailBodyFCU += '<b><u>Verification Type: KYC Verification</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
            
                mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        if( verify.Verification_Type__c == 'VAT')
        {
                mailBodyFCU += '<b><u>Verification Type: VAT Verification</u></b>'+'<br><br>';
                mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
            
                mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        if( verify.Verification_Type__c.equalsIgnoreCase('FINANCIAL VERIFICATION'))
        {
            /* Added By Ankush Bug ID 14128 start, Implemented New Mail Login as per Requirnment */
            //15506 Pro Doc Invisible Monitoring Start
            System.Debug('SendAgencySMS Financial verification condition is matched');
            string mandSubject = verify.Verification_Type__c + ' raised for Loan Application Number ' + verify.Loan_Application_No__c;
            Map<String,Object> mapJSONElement = MandatoryVerificationHandler.SendEmailForMandatoryVerification(verify,mandSubject);
            System.debug('mapJSONElement'+mapJSONElement);
                
            //For Batch 
            if(System.isBatch() && mapJSONElement!=null && mapJSONElement.size()>0){
                mapJSONEmail.put('mandatory'+mandatoryIndex,mapJSONElement);
                mandatoryIndex++; 
            }
            //15506 Pro Doc Invisible Monitoring End  
            /* Added By Ankush Bug ID 14128 End */      
              
                  /*
                  mailBodyFCU += '<b><u>Verification Type: FINANCIAL VERIFICATION</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  PAN Number               </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
                          
                mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.PAN_Number__c                       +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/> */
        }
        if( verify.Verification_Type__c == 'BUSINESS PROOF')
        {
                mailBodyFCU += '<b><u>Verification Type: BUSINESS PROOF Verification</u></b>'+'<br><br>';
                mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
                          
                mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        if( verify.Verification_Type__c == 'PERMANENT ADDRESS VERIFICATION')
        {
                  /*List<Applicant__c> lstApplicant = [select 
                                      Resi_Address__c 
                                     from 
                                         Applicant__c 
                                       where 
                                         Id 
                                       in
                                      (select 
                                          applicant__c 
                                     from 
                                         Verification__c 
                                     where 
                                         applicant__r.Applicant_Type__c='Primary' 
                                     and 
                                         id =: verify.Id
                                    )
                                  ];*/
                 /*code changed by akshata for bug 12174 verification agency billing phase 2 bug id 13138 */
                List<Account> lstAcct = [select id,/*Current_Residence_Address1__c, Current_Residence_Address2__c,
                                                Current_Residence_Address3__c*/Permanent_City__c,Permanent_Residence_Address1__c,Permanent_Residence_Address2__c ,
                                                Permanent_Residence_Address3__c, Permanent_State__c, Permanent_PinCode__c
                                        from
                                            Account
                                        where
                                            id in (SELECT AccountId FROM Opportunity where id =: verify.Loan_Application__c) 
                                        ];
                                  
                String permanentAddress = 'Not Specified';
                if(lstAcct != NULL && lstAcct.size() > 0)
                {           
                    if(lstAcct[0].Permanent_Residence_Address1__c!= NULL)
                    {
                      permanentAddress =  lstAcct[0].Permanent_Residence_Address1__c;
                    }
                    if(lstAcct[0].Permanent_Residence_Address2__c!= NULL)
                    {
                      permanentAddress += ' ' + lstAcct[0].Permanent_Residence_Address2__c;
                    }
                    if(lstAcct[0].Permanent_Residence_Address3__c!= NULL)
                    {
                      permanentAddress += ' ' + lstAcct[0].Permanent_Residence_Address3__c;
                    }
                    if(lstAcct[0].Permanent_PinCode__c!= NULL)
                    {
                      permanentAddress += ', ' + lstAcct[0].Permanent_PinCode__c;
                    }
                    
                }  
                    mailBodyFCU +='<b><u>Verification Type: PERMANENT ADDRESS VERIFICATION Verification</u></b>'+'<br><br>';
                    mailBodyFCU +='<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'<th><b>  Contact Name             </b></th>'
                                +'<th><b>  Contact Number           </b></th>'
                                +'<th><b>  Permanent Address        </b></th>'
                                +'</tr>';
            
                    mailBodyFCU +='<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Mobile_Number__c          +'</td>'
                            +'<td>'+ permanentAddress                           +'</td>'
                            +'</tr></table>';
                    mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        if( verify.Verification_Type__c == 'LEGAL & PROPERTY DOCUMENTS')
        {
            String propertyAddress ='', transactionType = '' ;
            String btBankName = '';
                        
            if(propMap != NULl && propMap.get(verify.Property_Details__c) != NULL )
            {
                if(propMap.get(verify.Property_Details__c).Property_Transaction_Type__c != NULL)
                {
                    transactionType = propMap.get(verify.Property_Details__c).Property_Transaction_Type__c;
                }
                
                if(verify.Property_Details__c != NULL &&  propMap.get(verify.Property_Details__c) != NULL && propMap.get(verify.Property_Details__c).BT_Bank_Name__c != NULL) 
                {
                    btBankName = propMap.get(verify.Property_Details__c).BT_Bank_Name__c;
                }
                
                if(verify.Property_Details__c != NULL && propMap != NULL && propMap.get(verify.Property_Details__c).Address__c != NULL)
                {
                    propertyAddress = propMap.get(verify.Property_Details__c).Address__c;
                }
            }
                  mailBodyFCU += '<b><u>Verification Type: LEGAL & PROPERTY DOCUMENTS Verification</u></b>'+'<br><br>';
                  mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'<th><b>  Property Address         </b></th>'
                                +'<th><b>  Transaction Type         </b></th>'
                                +'<th><b>  BT Bank Name             </b></th>'
                                +'</tr>';
            
                          
                mailBodyFCU += '<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'<td>'+ propertyAddress                            +'</td>'
                            +'<td>'+ transactionType                            +'</td>'
                            +'<td>'+ btBankName                                 +'</td>'
                            +'</tr></table>'; 
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        if( verify.Verification_Type__c == 'Vetting Report')
        {
                    System.debug('replyTo ' + replyTo);
                    System.debug('Subject ' + subject);
                  
                    mailBodyFCU +='<b><u>Verification Type: Vetting Report</u></b>'+'<br><br>';
                    mailBodyFCU +='<table border=1>'
                          +'<tr>'
                          +'<th><b>  Loan Application No    </b></th>'
                          +'<th><b>  Loan Application Name  </b></th>'
                          +'<th><b>  Contact Name       </b></th>'
                          +'<th><b>  Verification Code    </b></th>'
                          +'<th><b>  Verification Type    </b></th>'
                          +'<th><b>  Verification Category  </b></th>'
                          +'<th><b>  Verification Rate    </b></th>'
                          +'<th><b>  Verification Agency    </b></th>'
                          +'<th><b>  Remarks          </b></th>'
                          +'<th><b>  Property Address    </b></th>'
                          +'<th><b>  Product          </b></th>'
                          +'</tr>';
                  
                String propertyAddress='';
                if(verify.Property_Details__c != NULL && propMap != NULL && propMap.get(verify.Property_Details__c).Address__c != NULL)
                {
                  propertyAddress = propMap.get(verify.Property_Details__c).Address__c;
                }
                    
                mailBodyFCU +='<tr>'
                      +'<td>'+ loan_app_number        +'</td>'
                      +'<td>'+ verify.Loan_Application_Name__c      +'</td>'
                      +'<td>'+ verify.Contact_Name__c            +'</td>'
                      +'<td>'+ verify.Name                +'</td>'
                      +'<td>'+ verify.Verification_Type__c        +'</td>'
                      +'<td>'+ ver_category        +'</td>'
                      +'<td>'+ verificationRate          +'</td>'
                      +'<td>'+ vermap1.get(mail)              +'</td>'
                      +'<td>'+ remarks              +'</td>'
                      +'<td>'+ propertyAddress             +'</td>'
                      +'<td>'+ ver_Product              +'</td>'
                      +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
        if( verify.Verification_Type__c == 'LAND/BUILDING & PLOT VALUATION')
        {
                    String propertyAddress='';
                    mailBodyFCU +='<b><u>Verification Type: LAND/BUILDING & PLOT VALUATION Verification</u></b>'+'<br><br>';
                    mailBodyFCU +='<table border=1>'
                                    +'<tr>'
                                    +'<th><b>  Verification Agency      <b/></th>'
                                    +'<th><b>  Loan Application No      </b></th>'
                                    +'<th><b>  Applicant Name           </b></th>'
                                    +'<th><b>  Verification Code        </b></th>'
                                    +'<th><b>  Verification Type        </b></th>'  
                                    +'<th><b>  Verification Category    </b></th>'  
                                    +'<th><b>  Verification Rate        </b></th>'                            
                                    +'<th><b>  Remarks                  </b></th>'  
                                    +'<th><b>  Product                  </b></th>'
                                    +'<th><b>  Property Address         </b></th>'
                                    +'</tr>';
                          
              mailBodyFCU +='<tr>'
                            +'<td>'+ vermap1.get(mail)                          +'</td>'
                            +'<td>'+ loan_app_number              +'</td>'
                            +'<td>'+ verify.Contact_Name__c                     +'</td>'
                            +'<td>'+ verify.Name                                +'</td>'
                            +'<td>'+ verify.Verification_Type__c                +'</td>'
                            +'<td>'+ ver_category             +'</td>'
                            +'<td>'+ verificationRate                 +'</td>'
                            +'<td>'+ remarks                       +'</td>'
                            +'<td>'+ ver_Product                          +'</td>'
                            +'<td>'+ propertyAddress                            +'</td>'
                            +'</tr></table>';
                mailBodyFCU += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        
        if( verify.Verification_Type__c == 'Financiar Reference Check')
        {
                mailBodyFRC +='<b><u>Verification Type: Financiar Reference Check Verification</u></b>'+'<br><br>';
                mailBodyFRC +='<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                          +'</tr>';
                          
                mailBodyFRC += '<tr>'
                        +'<td>'+ vermap1.get(mail)                          +'</td>'
                        +'<td>'+ loan_app_number              +'</td>'
                        +'<td>'+ verify.Contact_Name__c                     +'</td>'
                        +'<td>'+ verify.Name                                +'</td>'
                        +'<td>'+ verify.Verification_Type__c                +'</td>'
                        +'<td>'+ ver_category             +'</td>'
                        +'<td>'+ verificationRate                 +'</td>'
                        +'<td>'+ remarks                       +'</td>'
                        +'<td>'+ ver_Product                          +'</td>'
                        +'</tr></table>';
                mailBodyFRC += LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
        //Added by mahima- 13017- CA dedupe- start
        //for Financial Verification (CA DDUPE)
        if( verify.Verification_Type__c=='Financial Verification (CA DDUPE)')
        {
            mailBodyFRC+='<b><u>Verification Type: Financial Verification (CA DDUPE) </u></b>'+'<br>'+'<br>';
            
            mailBodyFRC+='<table border=1>'
                        +'<tr>'
                        +'<th><b>   Loan Application No </b></th>'
                        +'<th><b>   Customer Name       </b></th>'
                        +'<th><b>   Verification Type   </b></th>'
                        +'<th><b>   Product             </b></th>'
                        +'<th><b>   PAN Number          </b></th>'
                        +'<th><b>   Status              </b></th>';
            
            mailBodyFRC+='<tr>'
                        +'<td>  '   +loan_app_number  +'  </td>'
                        +'<td>  '   +verify.Contact_Name__c         +'  </td>'
                        +'<td>  '   +verify.Verification_Type__c    +'  </td>'
                        +'<td>  '   +ver_Product              +'  </td>'
                        +'<td>  '   +verify.PAN_Number__c           +'  </td>'
                        +'<td>  '   +verify.Status__c               +'  </td>'
                        +'</tr></table>';
            mailBodyFRC+=LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }
    //Added by mahima- 13017- CA dedupe- end
    
      // Bug 15858 - December_2017_CS/CWA Program start
        if( verify.Verification_Type__c=='Financial Verification (CS DDUPE)') {
            mailBodyFRC+='<b><u>Verification Type: Financial Verification (CS DDUPE) </u></b>'+'<br>'+'<br>';
            mailBodyFRC+='<table border=1>'
                        +'<tr>'
                        +'<th><b>   Loan Application No </b></th>'
                        +'<th><b>   Customer Name       </b></th>'
                        +'<th><b>   Verification Type   </b></th>'
                        +'<th><b>   Product             </b></th>'
                        +'<th><b>   PAN Number          </b></th>'
                        +'<th><b>   Status              </b></th>';
            mailBodyFRC+='<tr>'
                        +'<td>  '   +loan_app_number  +'  </td>'
                        +'<td>  '   +verify.Contact_Name__c         +'  </td>'
                        +'<td>  '   +verify.Verification_Type__c    +'  </td>'
                        +'<td>  '   +ver_Product              +'  </td>'
                        +'<td>  '   +verify.PAN_Number__c           +'  </td>'
                        +'<td>  '   +verify.Status__c               +'  </td>'
                        +'</tr></table>';
            mailBodyFRC+=LineBreak; 
        }
        if( verify.Verification_Type__c=='Financial Verification (CWA DDUPE)') {
            mailBodyFRC+='<b><u>Verification Type: Financial Verification (CWA DDUPE) </u></b>'+'<br>'+'<br>';
            mailBodyFRC+='<table border=1>'
                        +'<tr>'
                        +'<th><b>   Loan Application No </b></th>'
                        +'<th><b>   Customer Name       </b></th>'
                        +'<th><b>   Verification Type   </b></th>'
                        +'<th><b>   Product             </b></th>'
                        +'<th><b>   PAN Number          </b></th>'
                        +'<th><b>   Status              </b></th>';
            mailBodyFRC+='<tr>'
                        +'<td>  '   +loan_app_number  +'  </td>'
                        +'<td>  '   +verify.Contact_Name__c         +'  </td>'
                        +'<td>  '   +verify.Verification_Type__c    +'  </td>'
                        +'<td>  '   +ver_Product              +'  </td>'
                        +'<td>  '   +verify.PAN_Number__c           +'  </td>'
                        +'<td>  '   +verify.Status__c               +'  </td>'
                        +'</tr></table>';
            mailBodyFRC+=LineBreak;
        } // Bug 15858 - December_2017_CS/CWA Program end
    //for Seller Reference Check
    
        if( verify.Verification_Type__c == 'Seller Reference Check')
        {
                  mailBodySRC +='<b><u>Verification Type: Seller Reference Check Verification</u></b>'+'<br><br>';
                  mailBodySRC +='<table border=1>'
                                +'<tr>'
                                +'<th><b>  Verification Agency      <b/></th>'
                                +'<th><b>  Loan Application No      </b></th>'
                                +'<th><b>  Applicant Name           </b></th>'
                                +'<th><b>  Verification Code        </b></th>'
                                +'<th><b>  Verification Type        </b></th>'  
                                +'<th><b>  Verification Category    </b></th>'  
                                +'<th><b>  Verification Rate        </b></th>'                            
                                +'<th><b>  Remarks                  </b></th>'  
                                +'<th><b>  Product                  </b></th>'
                                +'</tr>';
                          
                mailBodySRC +='<tr>'
                        +'<td>'+ vermap1.get(mail)                          +'</td>'
                        +'<td>'+ loan_app_number              +'</td>'
                        +'<td>'+ verify.Contact_Name__c                     +'</td>'
                        +'<td>'+ verify.Name                                +'</td>'
                        +'<td>'+ verify.Verification_Type__c                +'</td>'
                        +'<td>'+ ver_category             +'</td>'
                        +'<td>'+ verificationRate                 +'</td>'
                        +'<td>'+ remarks                       +'</td>'
                        +'<td>'+ ver_Product                          +'</td>'
                        +'</tr></table>';
                mailBodySRC+=LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }
        /*if( verify.Verification_Type__c == 'Salary Slip Format')
        {
                mailBodySRC +='<b><u>Verification Type: Salary Slip Format Verification</u></b>'+'<br><br>';
                mailBodySRC +='<table border=1>'
                            +'<tr>'
                            +'<th><b>  Verification Agency      <b/></th>'
                            +'<th><b>  Loan Application No      </b></th>'
                            +'<th><b>  Applicant Name           </b></th>'
                            +'<th><b>  Verification Code        </b></th>'
                            +'<th><b>  Verification Type        </b></th>'  
                            +'<th><b>  Verification Category    </b></th>'  
                            +'<th><b>  Verification Rate        </b></th>'                            
                            +'<th><b>  Remarks                  </b></th>'  
                            +'<th><b>  Product                  </b></th>'
                            +'</tr>';
                        
                mailBodySRC +='<tr>'
                        +'<td>'+ vermap1.get(mail)                          +'</td>'
                        +'<td>'+ loan_app_number              +'</td>'
                        +'<td>'+ verify.Contact_Name__c                     +'</td>'
                        +'<td>'+ verify.Name                                +'</td>'
                        +'<td>'+ verify.Verification_Type__c                +'</td>'
                        +'<td>'+ ver_category             +'</td>'
                        +'<td>'+ verificationRate                 +'</td>'
                        +'<td>'+ remarks                       +'</td>'
                        +'<td>'+ ver_Product                          +'</td>'
                        +'</tr></table>';
                mailBodySRC+=LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
        }    */
                    /*** START : Others #8315 ****/
                    else if( verify.Verification_Type__c == 'Others')
                    {
                        mailOthers +='<b><u>Verification Type: Others Verification</u></b>'+'<br><br>';
                        mailOthers +='<table border=1>'
                                        +'<tr>'
                                        +'<th><b>   Loan Application No     </b></th>'
                                        +'<th><b>   Loan Application Name   </b></th>'
                                        +'<th><b>   Contact Name            </b></th>'
                                        +'<th><b>   Verification Code       </b></th>'
                                        +'<th><b>   Verification Type       </b></th>'
                                        +'<th><b>   Verification Category   </b></th>'
                                        +'<th><b>   Verification Rate       </b></th>'
                                        +'<th><b>   Mobile No               </b></th>'
                                        +'<th><b>   Verification Agency     </b></th>'
                                        +'<th><b>   Remarks                 </b></th>'
                                        +'</tr>';
                                        
                        mailOthers +='<tr>'
                                        +'<td>'+ loan_app_number              +'</td>'
                                        +'<td>'+ verify.Loan_Application_Name__c            +'</td>'
                                        +'<td>'+ verify.Contact_Name__c                     +'</td>'
                                        +'<td>'+ verify.Name                                +'</td>'
                                        +'<td>'+ verify.Verification_Type__c                +'</td>'
                                        +'<td>'+ ver_category             +'</td>'
                                        +'<td>'+ verificationRate                 +'</td>'
                                        +'<td>'+ verify.Mobile_Number__c                    +'</td>'
                                        +'<td>'+ vermap1.get(mail)                          +'</td>'
                                        +'<td>'+ verify.Remarks__c                          +'</td>'
                                        +'</tr></table>';
                        mailOthers+=LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
                        System.debug('mailOthers :' + mailOthers);
                    }
                    /*** END : Others #8315 ****/
        
            // Start of invisible monitoring changes
            if( verify.Verification_Type__c == 'PHYSICAL PD')
            {
                    mailBodySRC +='<b><u>Verification Type: Physical PD Verification</u></b>'+'<br><br>';
                    mailBodySRC +='<table border=1>'
                          +'<tr>'
                          +'<th><b>  Loan Application No    </b></th>'
                          +'<th><b>  Loan Application Name  </b></th>'
                          +'<th><b>  Contact Name       </b></th>'
                          +'<th><b>  Verification Code     </b></th>'
                          +'<th><b>  Verification Type    </b></th>'
                          +'<th><b>  Verification Category  </b></th>'
                          +'<th><b>  Verification Rate    </b></th>'
                          +'<th><b>  Mobile No        </b></th>'
                          +'<th><b>  Office Address      </b></th>'
                          +'<th><b>  Verification Agency    </b></th>'
                          +'<th><b>  Remarks          </b></th>'
                          +'</tr>';
                          
                    mailBodySRC +='<tr>'
                      +'<td>'+ loan_app_number        +'</td>'
                      +'<td>'+ verify.Loan_Application_Name__c      +'</td>'
                      +'<td>'+ verify.Contact_Name__c            +'</td>'
                      +'<td>'+ verify.Name                +'</td>'
                      +'<td>'+ verify.Verification_Type__c        +'</td>'
                      +'<td>'+ ver_category        +'</td>'
                          +'<td>'+ verificationRate          +'</td>'
                      +'<td>'+ verify.Mobile_Number__c          +'</td>'
                      +'<td>'+ verify.Address__c              +'</td>'
                      +'<td>'+ vermap1.get(mail)              +'</td>'
                      +'<td>'+ remarks              +'</td>'
                      +'</tr></table>';
                      mailBodySRC+=LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
            }        
            // End of invisible monitoring changes
   

            //--------------- Mortgage Re-Engg Start---------------------
              if(verify.Verification_Type__c == 'Property Verification' || verify.Verification_Type__c == 'Legal' || verify.Verification_Type__c == 'BT Transaction' || verify.Verification_Type__c == 'Registration Transaction' || verify.Verification_Type__c == 'MODT')
              {
                      mailBodyFCU += '<b><u>Verification Type: '+verify.Verification_Type__c+' Verification</u></b>'+'<br>'+'<br>';
                      mailBodyFCU += '<table border=1>'
                              +'<tr>'
                              +'<th><b>  Loan Application No    </b></th>'
                              +'<th><b>  Loan Application Name  </b></th>'
                              +'<th><b>  Contact Name       </b></th>'
                              +'<th><b>  Verification Code    </b></th>'
                              +'<th><b>  Verification Type    </b></th>'
                              +'<th><b>  Verification Category  </b></th>'
                             +'<th><b>  Verification Rate    </b></th>'
                              +'<th><b>  Verification Agency    </b></th>'
                              +'<th><b>  Property Address    </b></th>'
                              +'<th><b>  Transaction Type    </b></th>'
                              +'<th><b>  Remarks          </b></th>'
                              +'<th><b>  Product          </b></th>';
                              
                              if(verify.Verification_Type__c == 'Legal') 
                              {
                                mailBodyFCU += '<th><b>  BT Bank Name    </b></th>';
                              }
                              
                      mailBodyFCU  += '</tr>';

                    String properyAddress='';

                    if(verify.Property_Details__c != NULL && propMap != NULL && propMap.get(verify.Property_Details__c) != NULL && propMap.get(verify.Property_Details__c).Address__c != NULL)
                    {
                        System.debug('in if -->'+propMap.get(verify.Property_Details__c).Address__c);
                      properyAddress = propMap.get(verify.Property_Details__c).Address__c;
                    }
                    
                    String transactionType ='';
                    
                    if(verify.Property_Details__c != NULL &&  propMap.get(verify.Property_Details__c) != NULL && propMap.get(verify.Property_Details__c).Property_Transaction_Type__c != NULL) 
                    {
                      transactionType = propMap.get(verify.Property_Details__c).Property_Transaction_Type__c;
                    }
                    
                    String btBankName = '';
                    if(verify.Property_Details__c != NULL &&  propMap.get(verify.Property_Details__c) != NULL && propMap.get(verify.Property_Details__c).BT_Bank_Name__c != NULL) 
                    {
                      btBankName = propMap.get(verify.Property_Details__c).BT_Bank_Name__c;
                    }
            
            
                      mailBodyFCU += '<tr>'
                              +'<td>'+ loan_app_number        +'</td>'
                              +'<td>'+ verify.Loan_Application_Name__c      +'</td>'
                              +'<td>'+ verify.Contact_Name__c            +'</td>'
                              +'<td>'+ verify.Name                +'</td>'
                              +'<td>'+ verify.Verification_Type__c        +'</td>'
                              +'<td>'+ ver_category        +'</td>'
                              +'<td>'+ verificationRate          +'</td>'
                              +'<td>'+ vermap1.get(mail)              +'</td>'
                              +'<td>'+ properyAddress                +'</td>'
                              +'<td>'+ transactionType              +'</td>'
                              +'<td>'+ remarks              +'</td>'
                              +'<td>'+ ver_Product              +'</td>';
                              
                              if(verify.Verification_Type__c == 'Legal') 
                              {
                                mailBodyFCU += +'<td>'+ btBankName        +'</td>';
                              }
                              
                              mailBodyFCU += '</tr></table>';
                    mailBodyFCU+=LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
                  }
                  if(verify.Verification_Type__c == 'Valuation')
                  {
                      mailBodyValuation += '<b><u>Verification Type: '+verify.Verification_Type__c+' Verification</u></b>'+'<br><br>';
                      mailBodyValuation += '<table border=1>'
                                  +'<tr>'
                                  +'<th><b>  Loan Application No    </b></th>'
                                  +'<th><b>  Loan Application Name  </b></th>'
                                  +'<th><b>  Contact Name       </b></th>'
                                  +'<th><b>  Verification Code    </b></th>'
                                  +'<th><b>  Verification Type    </b></th>'
                                  +'<th><b>  Verification Category  </b></th>'
                                  +'<th><b>  Verification Rate    </b></th>'
                                  +'<th><b>  Contact Number       </b></th>'
                                  +'<th><b>  Office Address       </b></th>'
                                  +'<th><b>  Verification Agency    </b></th>'
                                  +'<th><b>  Remarks          </b></th>'
                                  +'<th><b>  Product          </b></th>'
                                  +'</tr>';
                      
                      mailBodyValuation += '<tr>'
                                  +'<td>'+ loan_app_number        +'</td>'
                                  +'<td>'+ verify.Loan_Application_Name__c      +'</td>'
                                  +'<td>'+ verify.Contact_Name__c            +'</td>'
                                  +'<td>'+ verify.Name                +'</td>'
                                  +'<td>'+ verify.Verification_Type__c        +'</td>'
                                  +'<td>'+ ver_category        +'</td>'
                                  +'<td>'+ verificationRate          +'</td>'
                                  +'<td>'+ verify.Builder_Contact_Number__c      +'</td>'
                                  +'<td>'+ verify.Contact_Office_Address__c      +'</td>'
                                  +'<td>'+ vermap1.get(mail)              +'</td>'
                                  +'<td>'+ remarks              +'</td>'
                                  +'<td>'+ ver_Product              +'</td>'
                                  +'</tr></table>';
                                  
                      mailBodyValuation += '<br><br><b>Technical Submission Sheet</b><br>'
                                  +'<table border=1>'
                                  +'<tr>'
                                  +'<th><b>  Property Name          </b></th>'
                                  +'<th><b>  Property Address        </b></th>'
                                  +'<th><b>  Property Type          </b></th>'
                                  +'<th><b>  Transaction Type        </b></th>'
                                  +'<th><b>  Property Owner          </b></th>'
                                  +'<th><b>  Property Plan          </b></th>'
                                  +'<th><b>  Latest Ownership Document    </b></th>'
                                  +'<th><b>  Date and Time for Technical    </b></th>'
                                  +'<th><b>  Contact Person for Technical  </b></th>'
                                  +'<th><b>  Contact Person for Number    </b></th>'
                                  +'</tr>';
                  
                      if(propMap.size()>0 && propMap.containsKey(verify.Property_Details__c) && propMap.get(verify.Property_Details__c) != NULL)
                      {
                      //for(Property_Details__c prop:propMap.get(verify.Property_Details__c)){
                      mailBodyValuation +='<tr>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Name                +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Address__c              +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Property_Type__c          +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Property_Transaction_Type__c    +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Current_Property_Owner__c      +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Property_Plan__c          +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Latest_Ownership_Document__c    +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Date_and_Time_for_Technical__c    +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Contact_Person_for_Technical__c  +'</td>'
                                +'<td>'+ propMap.get(verify.Property_Details__c).Contact_Person_for_Number__c    +'</td>'
                                +'</tr>';
                      //}
                      }
                      mailBodyValuation += '</table><br><br>';
                      mailBodyValuation+=LineBreak; //added by mahima- 13017 to reduuce line breaks <br/>
                      mailBodyValuation += '<br></br>Please follow below format for updating verification status <b></b>Append status in Subject<b> </b> Example: Verification Agency Mail LAN No:XXXXXXX Verification Id:XXXXXX Status:Positive.';
                  }
            //--------------- Mortgage Re-Engg End-----------------------
        }
            system.debug('@@@@@@@@@@@@'+mailBodySRC);
            system.debug('@@@@@@@@@@@@'+mailBody);
            List<string> eList=new  List<string>();       
            eList.add(mail);
        
            //Mortgage added mailBodyValuation+
            mailBody=mailBodyValuation+mailBodyBank+mailBodyITR+mailBodyFCU+mailBodyoff+mailBodyPay+mailBodyRes+mailBodyTel+ mailBodyTra+mailBodyROC+mailBodyPAN+mailBodyCA+mailBodyMVR+mailBodyTRC+mailBodyFRC+mailBodySRC;
            mailBody += mailOthers; 
            mailBody  =  mailBody.trim();
            
            /************************************************************************************************************************
                Description : Following logic is modified to send email to verification agencies by checking for future method or 
                                batch class invocations. 
                Purpose   : Invisible monitoring verification agency emails through batch class.
                Changes by   : Niraj Dharmadhikari
            *************************************************************************************************************************/
                        
            /* Added By Ankush Bug ID 14128 start */
            System.debug('mailBody.contains(Verification Type) '+mailBody.contains('Verification Type'));
        
            //15506 Pro Doc Invisible Monitoring
            // Added if Condition to Restricy sending blank mail.
            if(mailBody.contains('Verification Type')){
                MapOfAddToBody.put(mail,mailBody);
            }    
            system.debug('MapOfAddToBody ????'+MapOfAddToBody);
            System.debug('Mail >>'+mail+' Mail Body >>'+mailBody);
            System.debug('allowExceptMndtEmail  >>'+allowExceptMndtEmail);
            //15506 Pro Doc Invisible Monitoring - Condition Added && allowExceptMndtEmail
            /* Added By Ankush Bug ID 14128 End */
            /* Added By Ankush Bug ID 14128 - Added Conditions allowExceptMndtEmail */
            
            System.debug(' replyTo >>>'+replyTo);
            if((!System.isFuture()) && (!System.isBatch()) && allowExceptMndtEmail)
            {
                //Mortgage
                //Added Condition to Check isRSA flag value to stop Property related verification emails. Changes done By Rajendra
                //20939 added below condition
                system.debug('accflow is'+accFlow);
                if(accFlow != 'Mobility V2'){
                    if(mailBodyValuation.length()>9 && senderEmailId != '' && replyTo != '' && !isRSA)
                    {
                         
                        SOLsendEmail.LogixSingleEmailSendMortgage(senderEmailId,replyTo,eList,Subject,mailBody);
                    }
                    else
                    {
                        System.debug('In Side Else >>>');
                        SOLsendEmail.LogixSingleEmailSend('noreply@bajajfinserv.in',eList,Subject,mailBody, replyTo);
                       //SOLsendEmail.LogixSingleEmailSend('noreply@bajajfinserv.in',eList,Subject,mailBody);
                    }
                }
          
                
            }
      }
      
      /* Added By Ankush Bug ID 14128 Start */
      //15506 Pro Doc Invisible Monitoring start

      if(mapJSONEmail.size() > 0){
          String jsonString = JSON.serialize(mapJSONEmail);
          System.debug('### JSON String '+jsonString);
          MapOfAddToBody.put('mandatory',jsonString);
       }
      //15506 Pro Doc Invisible Monitoring end
      /* Added By Ankush Bug ID 14128 End */
      
    }
    /******* START :  Adding code for sending mail if it is "Reopen Case" @YS 18th Oct. 2016  ****/
    else if(trigger.isUpdate)
    {
      List<verification__c> veriToUpdate = new List<Verification__c>(); //20939
      for(Verification__c objVerification : verfyList){
        system.debug('trigger.old map'+objVerification.id+'--'+trigger.oldmap);
        Verification__c oldVerification = new Verification__c();
        if(trigger.oldMap.get(objVerification.id) != null)
            oldVerification = trigger.oldMap.get(objVerification.id);
        /*Bug 20939 RCU s*/
        Opportunity Loan = oppMap.get(objverification.Loan_Application__c);
        system.debug('Loan is'+objVerification+'--'+oldVerification);
        if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
            if(objVerification.Status__c != oldVerification.Status__c){
                objVerification.Verification_updated_time__c = System.today();
                veriToUpdate.add(objVerification);
                string templateName = 'SAL RSA Verification Status Update';
                Id whatId = objVerification.id;
                string fromName = 'noreply@bajajfinserv.in';
                string replyTo1 = '';
                string[]toAddresses = new String[]{};
                if (Loan.ACM__c != null && Loan.ACM__r.Email != null)
                    toAddresses.add(Loan.ACM__r.Email);
                if (Loan.ACM__c != null && Loan.CPA__r.Email != null)
                    toAddresses.add(Loan.CPA__r.Email);
                String[]CC;
                string[]bcc;
                String Priority = 'Normal';
                BAFL_EmailServicesLogix.Attachment[]Attachments = new BAFL_EmailServicesLogix.Attachment[]{};
                string Subject1 = 'LAN No: '+ Loan.Loan_Application_Number__c +', SAL PL, RSA Status';
                String CostCenter = 'bajaj';
                system.debug('before calling'+toAddresses);
                if (!Test.isRunningTest())
                    GeneralUtilities.SendEmailUsingBAFLLogix(templateName ,whatID,fromName,replyTo1,toAddresses,CC,bcc,'Normal',Subject1,'bajaj');    
                
            }
        }
        /*Bug 20939 RCU e*/
      }
      System.debug('@ in update block'); 
      
      //for all verification is updating.
      for(Verification__c objVerification : trigger.new)
      {
        System.debug('Obj verification : ' + objVerification);
        
        Verification__c oldVerification = trigger.oldMap.get(objVerification.id);
        System.debug(objVerification.Reviewer_s_Comment__c + ' ' + oldVerification.Reviewer_s_Comment__c);
        //comment for Reopen should be present and changed
        //adding 'Vetting Report' only for testing...
        if((objVerification.Verification_Type__c == 'Valuation' || objVerification.Verification_Type__c == 'Legal' )  &&  (oldVerification.Reviewer_s_Comment__c !=  objVerification.Reviewer_s_Comment__c) )
        {
          System.debug('demo start : ');
          List<Attachment> objAttachments = [select id from Attachment where parentId =: objVerification.id and createdDate = today order by CreatedDate desc LIMIT 1];
          List<Id> lstAttach = new List<Id>();
          if(objAttachments != NULL && objAttachments.size() > 0 )
          {
            for(Attachment a : objAttachments)
            {
              lstAttach.add(a.Id);
            }
          }
          
          Subject += 'LAN No:'+objVerification.Loan_Application_No__c+' Verification Id:'+objVerification.Name+'#';
          replyTo = Label.Verification_Inbound_Email_Id;
          
          
          String mailBodyFCU='<br><br>', mailBodyValuation = '<br><br>' ;
          /** sending actual mail */
          List<String>  toAddresses = new List<String>();
          for(String mail : vermap.keyset())
          {
            toAddresses.add(mail);
            
            //--------------- Mortgage Re-Engg Start---------------------
                if(objVerification.Verification_Type__c == 'Legal') 
                {
                        mailBodyFCU += '<b><u>Verification Type: '+objVerification.Verification_Type__c+' Verification</u></b>'+'<br>'+'<br>';
                        mailBodyFCU += '<table border=1>'
                                +'<tr>'
                                +'<th><b>  Loan Application No    </b></th>'
                                +'<th><b>  Loan Application Name  </b></th>'
                                +'<th><b>  Contact Name       </b></th>'
                                +'<th><b>  Verification Code    </b></th>'
                                +'<th><b>  Verification Type    </b></th>'
                                +'<th><b>  Verification Category  </b></th>'
                            +'<th><b>  Verification Rate    </b></th>'
                                +'<th><b>  Verification Agency    </b></th>'
                                +'<th><b>  Property Address    </b></th>'
                                +'<th><b>  Transaction Type    </b></th>'
                                +'<th><b>  Remarks          </b></th>'
                                +'<th><b>  Product          </b></th>'
                                +'</tr>';
  
              String properyAddress='';
              if(objVerification.Property_Details__c != NULL && propMap != NULL && propMap.get(objVerification.Property_Details__c).Address__c != NULL)
              {
                properyAddress = propMap.get(objVerification.Property_Details__c).Address__c;
              }
              
              String transactionType ='';
              
              if(objVerification.Property_Details__c != NULL &&  propMap.get(objVerification.Property_Details__c) != NULL && propMap.get(objVerification.Property_Details__c).Property_Transaction_Type__c != NULL) 
              {
                transactionType = propMap.get(objVerification.Property_Details__c).Property_Transaction_Type__c;
              }
              
                        mailBodyFCU += '<tr>'
                                +'<td>'+ objVerification.Loan_Application_No__c    +'</td>'
                                +'<td>'+ objVerification.Loan_Application_Name__c  +'</td>'
                                +'<td>'+ objVerification.Contact_Name__c      +'</td>'
                                +'<td>'+ objVerification.Name            +'</td>'
                                +'<td>'+ objVerification.Verification_Type__c    +'</td>'
                                +'<td>'+ objVerification.VerificationCategory__c  +'</td>'
                              +'<td>'+ objVerification.VerificationRate__c    +'</td>'
                                +'<td>'+ vermap1.get(mail)              +'</td>'
                                +'<td>'+ vermap1.get(mail)              +'</td>'
                                +'<td>'+ properyAddress                +'</td>'
                                +'<td>'+ transactionType              +'</td>'
                                +'<td>'+ objVerification.Remarks__c          +'</td>'
                                +'<td>'+ objVerification.Product__c          +'</td>'
                                +'</tr></table>';
                    }
                    if(objVerification.Verification_Type__c == 'Valuation')
                    {
                        mailBodyValuation += '<b><u>Verification Type: '+objVerification.Verification_Type__c+' Verification</u></b>'+'<br><br>';
                        mailBodyValuation += '<table border=1>'
                                    +'<tr>'
                                    +'<th><b>  Loan Application No    </b></th>'
                                    +'<th><b>  Loan Application Name  </b></th>'
                                    +'<th><b>  Contact Name       </b></th>'
                                    +'<th><b>  Verification Code    </b></th>'
                                    +'<th><b>  Verification Type    </b></th>'
                                    +'<th><b>  Verification Category  </b></th>'
                                +'<th><b>  Verification Rate    </b></th>'
                                    +'<th><b>  Contact Number       </b></th>'
                                    +'<th><b>  Office Address       </b></th>'
                                    +'<th><b>  Verification Agency    </b></th>'
                                    +'<th><b>  Remarks          </b></th>'
                                    +'<th><b>  Product          </b></th>'
                                    +'</tr>';
                        
                        mailBodyValuation += '<tr>'
                                    +'<td>'+ objVerification.Loan_Application_No__c    +'</td>'
                                    +'<td>'+ objVerification.Loan_Application_Name__c  +'</td>'
                                    +'<td>'+ objVerification.Contact_Name__c      +'</td>'
                                    +'<td>'+ objVerification.Name            +'</td>'
                                    +'<td>'+ objVerification.Verification_Type__c    +'</td>'
                                    +'<td>'+ objVerification.VerificationCategory__c  +'</td>'
                                    +'<td>'+ objVerification.VerificationRate__c    +'</td>'
                                    +'<td>'+ objVerification.Builder_Contact_Number__c  +'</td>'
                                    +'<td>'+ objVerification.Contact_Office_Address__c  +'</td>'
                                    +'<td>'+ vermap1.get(mail)              +'</td>'
                                    +'<td>'+ objVerification.Remarks__c          +'</td>'
                                    +'<td>'+ objVerification.Product__c          +'</td>'
                                    +'</tr></table>';
                                    
                        mailBodyValuation += '<br><br><b>Technical Submission Sheet</b><br>'
                                    +'<table border=1>'
                                    +'<tr>'
                                    +'<th><b>  Property Name          </b></th>'
                                    +'<th><b>  Property Address        </b></th>'
                                    +'<th><b>  Property Type          </b></th>'
                                    +'<th><b>  Transaction Type        </b></th>'
                                    +'<th><b>  Property Owner          </b></th>'
                                    +'<th><b>  Property Plan          </b></th>'
                                    +'<th><b>  Latest Ownership Document    </b></th>'
                                    +'<th><b>  Date and Time for Technical    </b></th>'
                                    +'<th><b>  Contact Person for Technical  </b></th>'
                                    +'<th><b>  Contact Person for Number    </b></th>'
                                    +'</tr>';
                      
                        if(propMap.size()>0 && propMap.containsKey(objVerification.Property_Details__c) && propMap.get(objVerification.Property_Details__c) != NULL)
                        {
                        //for(Property_Details__c prop:propMap.get(verify.Property_Details__c)){
                        mailBodyValuation +='<tr>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Name                +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Address__c            +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Property_Type__c          +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Property_Transaction_Type__c    +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Current_Property_Owner__c      +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Property_Plan__c          +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Latest_Ownership_Document__c    +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Date_and_Time_for_Technical__c  +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Contact_Person_for_Technical__c  +'</td>'
                                  +'<td>'+ propMap.get(objVerification.Property_Details__c).Contact_Person_for_Number__c    +'</td>'
                                  +'</tr>';
                        //}
                        }
                        mailBodyValuation += '</table><br><br>';
                        mailBodyValuation += '<br></br>Please follow below format for updating verification status <b></b>Append status in Subject<b> </b> Example: Verification Agency Mail LAN No:XXXXXXX Verification Id:XXXXXX Status:Positive.';                                           
                    }
                    
                    String mailBody=mailBodyValuation+mailBodyFCU;
                    System.debug('@update-sendagencysms-Body :' + mailBody);
                    System.debug('@update-sendagencysms-ReplyTo'+ replyTo);
                    System.debug('@update-sendagencysms-ReplyTo'+ replyTo);
                    System.debug('@update-sendagencysms-toAddresses'+ toAddresses);
                    System.debug('@update-sendagencysms-lstAttach'+ lstAttach);
                    GeneralUtilities.sendMailWithAttachment(toAddresses, replyTo, subject, mailBody,new List<String>(), new List<String>(), lstAttach, 'noreply@bajajfinserv.in');
              //--------------- Mortgage Re-Engg End-----------------------
          }
        }
      }
      /*20939 s*/
      if(veriToUpdate != null && veriToUpdate.size() > 0)
          upsert veriToUpdate;
      /*20939 e*/
    }
    /******* END   :  Adding code for sending mail if it is "Reopen Case" @YS 18th Oct. 2016  ****/
    /*Responsys Dynamic Parameters Bug 15653 s*/
    List<Opportunity> oppList = new List<Opportunity>();
    List<Verification__c> verList1 = new List<Verification__c>();
    /*Responsys Dynamic Parameters Bug 15653 e*/
    // Start of invisible monitoring changes
    if(trigger.isInsert) 
    {
          set<ID> LoanIDSet = new set<ID>(); 
          for(Verification__c ver: trigger.New) 
          {
              LoanIDSet.add(ver.Loan_Application__c);
              /*Responsys Dynamic Parameters Bug 15653 s
              mess='Dear Sir, Bajaj Finserv Lending has initiated a new verification for Loan application no ' + ver.Loan_Application_Number__c + '\nType of verification : ' + ver.Verification_Type__c;
              ph = ver.agency_mobile__c;
              if(ph != NULL) 
              {
                  //sendsms.message(ph,mess);
                  listmsg.add(mess);
                  contactNum.add(ph);
              }  
              Responsys Dynamic Parameters Bug 15653 e*/
            // prod adhoc start
            Opportunity Loan = oppMap.get(ver.Loan_Application__c);
            if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
                Map<String,Object> allMap = GeneralUtilities.fetchStaticRescMap();
                Map<String,Object> rcuMap = new Map<String,Object>();
                if(allMap != null && allMap.containsKey('RCU Processes'))
                    rcuMap = (Map<String,Object>)allMap.get('RCU Processes');   
                    String rcuEmail = (String)rcuMap.get('RCU Email ID'); 

                if(ver.Initiated_by_invisible_monitoring__c!= null &&  ver.Initiated_by_invisible_monitoring__c == true){
                    string templateName = 'Invisible monitoring identified mail';
                    Id whatId = ver.id;
                    List<String> attIds = new List<String>();
                    string fromName = 'noreply@bajajfinserv.in';
                    replyTo = '';
                    string[]toAddresses = new String[]{};
                    String[]CC = new String[]{};
                    System.debug('pk agency'+ver.Verification_Agency__c+verAgencyMap);
                        if (ver.Verification_Agency__c != null && verAgencyMap.containsKey(ver.Verification_Agency__c))
                            toAddresses.add(verAgencyMap.get(ver.Verification_Agency__c).Mail_Id__c);
                    CC.addAll(rcuEmail.split(';'));
                    system.debug('toaddresses'+toAddresses);
                    
                    string[]bcc;
                    String Priority = 'Normal';
                    BAFL_EmailServicesLogix.Attachment[]Attachments = new BAFL_EmailServicesLogix.Attachment[]{};
                    Subject = 'LAN No: '+ Loan.Loan_Application_Number__c +', Invisible Monitoring verification, SAL PL';
                    String CostCenter = 'bajaj';
                    system.debug('before calling'+toAddresses);
                    if (!Test.isRunningTest())
                        GeneralUtilities.SendEmailUsingBAFLLogix(templateName ,whatID,fromName,replyTo,toAddresses,CC,bcc,'Normal',Subject,'bajaj');    

                }
                }
                // prod adhoc end

          }
        
          //List<Opportunity> oppList;
          if(LoanIDSet != NULL && LoanIDSet.size() > 0) 
          {
              oppList = [SELECT /*Responsys s*/Product__c,/*Responsys e*/ Loan_Application_Number__c, ACM__r.Mobile_number__c, ASM_Mobile__c, Sourc_Mobile__c FROM Opportunity WHERE ID IN : LoanIDSet];
 
          }
    }
    // End of invisible monitoring changes     
     
       /************************************************************************************************************************
            Description : Following logic is modified to send email to verification agencies by checking for future method or 
                          batch class invocations. 
            Purpose   : Invisible monitoring verification agency emails through batch class.
            Changes by   : Niraj Dharmadhikari
       *************************************************************************************************************************/ 
       if(System.isFuture() || System.isBatch() || Test.isRunningTest()) 
       {
          /*Responsys Dynamic Parameters Bug 15653 s*/
          GeneralCommunicationHandler.sendSMS(oppList, 'Verification Initiate-Int');
          GeneralCommunicationHandler.sendSMS(oppList,verList1, 'Verification Initiate1');
          /*Responsys Dynamic Parameters Bug 15653 e*/
          System.Queueable job = new FutureCalloutHandler('noreply@bajajfinserv.in',MapOfAddToBody,Subject,listmsg,contactNum);
          System.enqueueJob(job);
       }
     
  } // end of if of recursive call condition
}// end of trigger