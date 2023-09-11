trigger InsertSummaryTransaction on Bank_Account__c (after update) {
    static Set<id> LoanIdsSet = new Set<id>(); // 24313
    static List<Opportunity> oppLstSt;// 24313
    List<Bank_Transaction__c> newTrans = new List<Bank_Transaction__c>();
   if (!ControlRecursiveCallofTrigger_Util.hasAlreadyExecutedInsertSummaryTransaction()) {   
    ControlRecursiveCallofTrigger_Util.setAlreadyExecutedInsertSummaryTransaction();
    
    List<Bank_Transaction__c> allTrans = new List<Bank_Transaction__c>();
    List<Bank_Account__c> bankaccntlst = new List<Bank_Account__c>();
    List<Id> accId = new List<Id>();
 List<id> LoanIdsMob= new List<Id>(); //20939 trigger retrigger
    Id loanNumber;
    Salaried__c salObj = new Salaried__c();
    List<String> toAddress = new List<String>();
    for(Bank_Account__c acc: trigger.new){
        LoanIdsMob.add(acc.Loan_Application__c); //Retrigger added 20939
		LoanIdsSet.add(acc.Loan_Application__c); // 24313
        if(Trigger.oldmap.get(acc.id).Perfios_flag__c == false && acc.Perfios_flag__c == true){
            accId.add(acc.id);
            loanNumber = acc.Loan_Application__c;
        }
    }
/*Retrigger BRE added 20939 */
    Map<Id, Opportunity> oppMap;
    if(!CommonUtility.isEmpty(LoanIdsSet)){
       /* List<Opportunity> oppLst = [select Account.Flow__c,Account.Offer_Inhanced__c,id, product__C,Account.IS_OTP_FLOW__c, CreatedDate,
                                    (select id,name,Old_Loan_Application__c,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policys__r),
                                    (Select  id,product__c,Type_of_Year__c from PLBS__r where Type_of_Year__c='Current' or Type_of_Year__c='Previous' or Type_of_Year__c='PrevSummary' or Type_of_Year__c='CurrSummary')
                                    from Opportunity where id in : LoanIdsMob];*/
		oppLstSt = GeneralUtilities.getOpportunities(LoanIdsSet);//Bug 24313
        List<Opportunity> oppLst = oppLstSt;//Bug 24313
            							
        if(!CommonUtility.isEmpty(oppLst)){
            oppMap = new Map<Id, Opportunity>();
            for(Opportunity opp : oppLst)
                oppMap.put(opp.Id,opp);
        }
    }
    Map<String,Object> allMap = new Map<String,Object>();
    allMap = GeneralUtilities.fetchRetriggerRescMap();
    Map<String,SOL_Policy__c> solPolicyToUpdateMap = new map<String,SOL_Policy__c>();
    for(Bank_Account__c  bankacc:trigger.new){
        Opportunity Loan = new Opportunity();
        if(oppMap != null && oppMap.containsKey(bankacc.Loan_Application__c) && oppMap.get(bankacc.Loan_Application__c) != null){
            Loan = oppMap.get(bankacc.Loan_Application__c);
        }
        if((Trigger.isUpdate && Trigger.isAfter) || (trigger.isInsert && Trigger.isAfter)){
            system.debug('in mobility'+Loan.Account.Flow__c);
            if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
                List<SOL_Policy__c> solPolicyList = new List<SOL_Policy__c>();
                List<SOL_Policy__c> solPolicyToUpdate=new List<SOL_policy__c>();
                Map<String,Object> appFields = new Map<String,Object>();

                
                Map<String, SOL_Policy__c> solPolicyMAPToUpdate=new Map<String, SOL_Policy__c>();
               
                if(!commonutility.isEmpty(allMap)){
                    appFields = (Map<String,Object>)allMap.get('Bank_Account__c');
                    System.debug('Hi'+appFields );
                    if(!commonutility.isEmpty(appFields)){
              Bank_Account__c  oldApp=new Bank_Account__c  ();
                            if(Trigger.isUpdate && Trigger.isAfter){
                                oldApp = (Bank_Account__c )Trigger.oldmap.get(bankacc.Id);}
                        solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(oldApp,bankacc,Loan,appFields,solPolicyToUpdateMap);
               
                    }
                }
                System.debug('Final list to update '+solPolicyMAPToUpdate.values().size());
                
                //solPolicyToUpdate= solPolicyMAPToUpdate.values();
               
            }
            
        }
    }
    if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() >0){
        update solPolicyToUpdateMap.values();
    }
    /*Retrigger BRE added 20939 e */
    
    //BankTransactionhandler bankAccHdnlr = new BankTransactionhandler(accId);
    System.debug('********accId: '+accId);
    if(accId.size() > 0){
        allTrans = [select id,Value_Date__c,DB_No__c,DB_Amount__c,CRD_No__c,CRD_Amount__c,Month__c,Year__c,Bank_Account__c 
                    from Bank_Transaction__c where Bank_Account__c in :accId and Month__c = null and Year__c = null];
        //bankaccntlst =[select id,Loan_Application__c,Loan_Application__r.Customer_email_id__c from Bank_Account__c where id =:accId ]; 
        
        List<Salaried__c> salList = new List<Salaried__c>();
        if(loanNumber != null)
            salList = [Select id,name,Product_Type__c,Cust_Reference_No__c,First_Name__c,Middle_name__c,Last_Name__c ,Loan_Application__c,Loan_Application__r.Loan_Application_Number__c,Loan_Application__r.Loan_Amount__c,Loan_Application__r.Tenor__c,Loan_Application__r.EMI_CAM__c,Loan_Application__r.Requested_ROI__c,Loan_Application__r.Processing_Fees__c,
            Loan_Application__r.Commitment_Fees__c,Primary_Bank_Name__c,Mobile__c,Loan_Application__r.IFSC_Code__c,Loan_Application__r.A_C_No__c,
                       Loan_Application__r.Insurance_Premium_Amt__c,Loan_Application__r.Approved_Rate__c,Loan_Application__r.Approved_Tenor__c,
                       Loan_Application__r.Approved_Loan_Amount__c,Loan_Application__r.Customer_email_id__c 
                       from  Salaried__c where Loan_Application__c=:loanNumber limit 1];
                       
            if(salList != null && salList.size() > 0){
                salObj = salList[0];
            }
        for(Bank_Transaction__c trans: allTrans){
            Bank_Transaction__c transObj = findSummary(trans.Value_Date__c.Month(),trans.Value_Date__c.Year(),trans);
            System.debug('********transObj.DB_No__c: '+transObj.DB_No__c + '****trans.DB_No__c: '+trans.DB_No__c);
            System.debug('********transObj.DB_Amount__c: '+transObj.DB_Amount__c + '**trans.DB_Amount__c: '+trans.DB_Amount__c);
            System.debug('********transObj.CRD_No__c: '+transObj.CRD_No__c + '***trans.CRD_No__c : '+trans.CRD_No__c);
            System.debug('********transObj.CRD_Amount__c: '+transObj.CRD_Amount__c + '**trans.CRD_Amount__c: '+trans.CRD_Amount__c);
            
            if(transObj.DB_No__c != null && trans.DB_Amount__c < 0)
                transObj.DB_No__c = transObj.DB_No__c + 1;
                
            if(trans.DB_Amount__c != null){
                if(trans.DB_Amount__c < 0)    
                    trans.DB_Amount__c = trans.DB_Amount__c * -1;
                transObj.DB_Amount__c = transObj.DB_Amount__c + trans.DB_Amount__c;
            }  

            if(transObj.CRD_No__c != null && trans.CRD_Amount__c > 0) 
                transObj.CRD_No__c = transObj.CRD_No__c + 1;
                
            if(trans.CRD_Amount__c != null)     
                transObj.CRD_Amount__c = transObj.CRD_Amount__c + trans.CRD_Amount__c;
                
            System.debug('*************DB_No__c: '+transObj.DB_No__c);
            System.debug('*************DB_Amount__c: '+transObj.DB_Amount__c);
            System.debug('*************CRD_No__c: '+transObj.CRD_No__c);
            System.debug('*************CRD_Amount__c: '+transObj.CRD_Amount__c);
        }
        
        
        System.debug('*************newTrans: '+newTrans);
        
        if(newTrans.size() > 0){
           insert newTrans;
           System.debug('*************newTrans[0].Id: '+newTrans[0].Id);   
        } 
        if(System.Label.SOL_Online_Flow_Control=='SOLV2' && salObj!=null && salObj.Product_Type__c=='SOL'){
            //For SOL Communication module 
            String mailBody;
            //PageReference  pr;
            //pr = Page.PerfiosBankingIntegrationEmail;
            //pr.getParameters().put('salId',salObj.id);
            mailBody = '';
            if(!system.test.isRunningTest()){ 
                // mailBody = pr.getContent().toString();
                // mailBody = mailBody.replace('"','\\"');  
            }   
            String subject='Thank you, We have received your banking details';
            if(salObj!=null && salObj.Loan_Application__c!=null)
                toAddress =  new string[]{salObj.Loan_Application__r.Customer_email_id__c};
            System.debug('*************sending email  '+toAddress);  
            
            
            
            //Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            //email.setSenderDisplayName('Bajaj Finserv Lending'); 
            //email.setSubject(Subject); 
            //email.setToAddresses(toAddress); 
                 
            String emsg ='<html xmlns:v=\\"urn:schemas-microsoft-com:vml\\" xmlns:o=\\"urn:schemas-microsoft-com:office:office\\" xmlns:dt=\\"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882\\" xmlns=\\"http://www.w3.org/TR/REC-html40\\">';

            emsg += '<head>';
            emsg += '<meta http-equiv=\\"Content-Type\\" content=\\"text/html; charset=utf-8\\" />';
            emsg += ' <title>Bajaj Finserv :: Personal Loan Online Application</title>';
            emsg += '</head>';
            emsg += '<body bgcolor=\\"#FFFFFF\\" leftmargin=\\"0\\" topmargin=\\"0\\" marginwidth=\\"0\\" marginheight=\\"0\\" style=\\"color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 15px\\">';
            //emsg += ' <p align=\\"center\\">If you are not able to view the content given below properly, please <a target=\\"_blank\\" href= ';          
            //emsg += ' \\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/index.html\\">click here</a></p> ';

            emsg += '<table width=\\"780\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" style=\\"border: 1px #949494 solid\\" align=\\"center\\">';
            emsg += ' <tr>';
            emsg += ' <td valign=\\"top\\" colspan=\\"5\\">';
            emsg += ' <a href=\\"http://bit.ly/1mI5F6w\\" target=\\"_blank\\">';
            emsg += '<img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/bfl-logo.jpg\\" width=\\"401\\" height=\\"83\\" alt=\\"Bajaj Finserv\\" title=\\"Bajaj Finserv\\" align=\\"right\\" border=\\"0\\" /></a></td>';
            emsg += ' </tr>';

            emsg += ' <tr>';
            emsg += '<td colspan=\\"5\\" style=\\"padding:10px 0 0 10px;\\"> ';
            emsg += '<strong>Application Reference Number: </strong> '+salObj.Cust_Reference_No__c; 
            emsg += '</td>'; 
            emsg += '</tr>';
            emsg += ' <tr> ';
            emsg += ' <td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 0 10px;\\"><div>Dear '+salObj.First_Name__c +' '+ salObj.Middle_Name__c+' '+ salObj.Last_Name__c+',</div></td>';
            emsg += '</tr>';
    
            emsg += '<tr> ';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 0 10px;\\"><div>Congratulations. The banking integration initiated by you has been completed successfully. This would '; emsg += 'help us <br />disburse your loan faster.</div></td>';
            emsg += '</tr>';

            emsg += '<tr> ';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 0 10px;\\"><div>Your Application Reference Number is '+salObj.Cust_Reference_No__c+'.</div></td>';
            emsg += '</tr>';
            emsg += '<tr>';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 0 10px;\\"><div>You can use this number to check any detail regarding your Personal Loan online application.</div></td>';
            emsg += ' </tr>';
            emsg += '<tr>';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:12px 0 0 10px;\\">';
            emsg += ' <img src= \\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/call-us.jpg\\" alt=\\"In case of any query or clarification call us on';
            emsg += ' 1800 1033535 or\\" title=\\"In case of any query or clarification call us on 1800 1033535 or \\" width=\\"614\\" height=\\"17\\" border=\\"0\\" /></td>';
            emsg += ' </tr>';
            emsg += ' <tr>';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:0 0 10px 10px;\\"><a href=\\"mailto:personalloans@bajajfinserv.in\\">';
            emsg += '<img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/write-us.jpg\\" ';
            emsg += 'alt=\\"write to us at personalloans@bajajfinserv.in quoting your application reference number.\\"';
            emsg +=  'title=\\"write to us at personalloans@bajajfinserv.in quoting your application reference number.\\" width=\\"614\\" height=\\"20\\" border=\\"0\\" />';
            emsg += ' </a></td>';
            emsg += '</tr>';

            emsg += ' <tr> ';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 0 10px;\\">';
            emsg += 'Warm regards,<br />';
            emsg += 'Bajaj Finserv';
            emsg += '</td>';
            emsg += '</tr>';

            emsg += '<tr> ';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 0 10px;\\">';
            emsg += '<a href=\\"http://bit.ly/XgyQby\\" target=\\"_blank\\">';
            emsg += ' <img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/Visit-bajaj.jpg\\" ';
            emsg += 'alt=\\"Visit www.bajajfinserv.in\\" title=\\"Visit www.bajajfinserv.in\\" width=\\"184\\" height=\\"22\\" border=\\"0\\" /></a>';
            emsg += '</td>';
            emsg += '</tr>';

            emsg += '<tr> ';
            emsg += ' <td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 0 10px; font-size:13px;\\">';
            emsg += '<img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/first.jpg\\" alt=\\"This is a system generated alert and does not require a signature. We request you to not reply to this message. This e-mail\\" title=\\"This is a system generated alert and does not require a signature. We request you to not reply to this message. This e-mail\\" width=\\"760\\" height=\\"17\\" border=\\"0\\" />';
            emsg += '</td>';
            emsg += '</tr>';
            emsg += '<tr> ';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:0 0 0 10px; font-size:13px;\\">';
            emsg += '<img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/second.jpg\\" alt=\\"is confidential and may also be privileged. Please do not copy or use it for any purpose, nor disclose its contents to any other \\" title=\\"is confidential and may also be privileged. Please do not copy or use it for any purpose, nor disclose its contents to any other\\" width=\\"760\\" height=\\"18\\" border=\\"0\\" />';
            emsg += '</td>';
            emsg += '</tr>';
            emsg += '<tr> ';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:0 0 10px 10px; font-size:13px;\\">';
            emsg += ' <a href=\\"mailto:wecare@bajajfinserv.in\\"><img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/third.jpg\\" alt=\\"person. If you are not the intended recipient, please notify us, or write to us with your queries to wecare@bajajfinserv.in\\" title=\\"person. If you are not the intended recipient, please notify us, or write to us with your queries to wecare@bajajfinserv.in\\" width=\\"760\\" height=\\"17\\" border=\\"0\\" /></a>';
            emsg += ' </td>';
            emsg += '</tr>';

            emsg += '<tr>';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 0 10px;\\">';
            emsg += '<img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/lets-go.jpg\\" alt=\\"Let’s go for great\\" title=\\"Let’s go for great\\" width=\\"230\\" height=\\"26\\" border=\\"0\\" />';
            emsg += '</td>';
            emsg += '</tr>';
            emsg += ' <tr>';
            emsg += '<td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:5px 0 10px 10px;\\">';
            emsg += ' <a href=\\"http://bit.ly/Y3k7AA\\" target=\\"_blank\\"><img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/click-here.jpg\\" alt=\\"Click here to watch our Brand Film\\" title=\\"Click here to watch our Brand Film\\" width=\\"268\\" height=\\"34\\" border=\\"0\\" /></a>';
            emsg += ' </td>';
            emsg += ' </tr>';

            emsg += ' <tr>';
            emsg += '<td style=\\"padding:10px 14px 0 12px\\" colspan=\\"5\\">';
            emsg += ' <table width=\\"228px\\" border=\\"0\\" cellpadding=\\"0\\" cellspacing=\\"0\\" align=\\"left\\">';
            emsg += '    <tr>';
            emsg += '      <td valign=\\"top\\"><img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/connect-with.jpg\\" width=\\"131\\" height=\\"35\\" alt=\\"Connect with us\\" title=\\"Connect with us\\" align=\\"left\\" border=\\"0\\" /></td>';
            emsg += '<td valign=\\"top\\"><a href=\\"https://www.facebook.com/bajajfinserv?sk=app_190322544333196\\" target=\\"_blank\\">';
            emsg += '<img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/fb.jpg\\" width=\\"42\\" height=\\"35\\" alt=\\"Facebook\\" title=\\"Facebook\\" align=\\"left\\" border=\\"0\\" /></a></td>';
            emsg += '<td valign=\\"top\\"><a href=\\"https://twitter.com/Bajaj_Finserv\\" target=\\"_blank\\">';
            emsg += '<img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/tw.jpg\\" width=\\"40\\" height=\\"35\\" alt=\\"twitter\\" title=\\"twiter\\" align=\\"left\\" border=\\"0\\" /></a></td>';
            emsg += '<td valign=\\"top\\"><a href=\\"http://www.linkedin.com/company/1092003?trk=tyah\\" target=\\"_blank\\">';
            emsg += '<img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/in.jpg\\" width=\\"35\\" height=\\"35\\" alt=\\"LinkedIn\\" title=\\"LinkedIn\\" align=\\"left\\" border=\\"0\\" /></a></td>';
            emsg += '</tr>';
            emsg += ' </table>';
            emsg += '</td>';
            emsg += '</tr>';

            emsg += ' <tr> ';
            emsg += ' <td colspan=\\"5\\" valign=\\"top\\" style=\\"padding:10px 0 10px 10px;font-size:13px;\\">';
            emsg += '  <div>Terms and conditions apply | Finance at the sole discretion of Bajaj Finance Limited</div>';
            emsg += '</td>';
            emsg += '</tr>';

            emsg += ' <tr>';
            emsg += '  <td valign=\\"top\\" style=\\"padding: 0 10px 5px 0\\" colspan=\\"5\\">';
            emsg += '     <img src=\\"http://www.bajajfinserv.in/finance/mailer/2014/aug/aw-SOL-Transactional-Emailer-05/images/bfl-ltd.jpg\\" width=\\"179\\" height=\\"21\\" alt=\\"BAJAJ FINANCE LIMITED\\" title=\\"BAJAJ FINANCE LIMITED\\" align=\\"right\\" border=\\"0\\" /></td>';
            emsg += ' </tr>';
            emsg += '  <tr>';
            emsg += '   <td valign=\\"top\\"><img src=\\"images/spacer.gif\\" width=\\"379\\" height=\\"1\\" alt=\\"\\"></td>';
            emsg += '     <td valign=\\"top\\"><img src=\\"images/spacer.gif\\" width=\\"274\\" height=\\"1\\" alt=\\"\\"></td>';
            emsg += '    <td valign=\\"top\\"><img src=\\"images/spacer.gif\\" width=\\"42\\" height=\\"1\\" alt=\\"\\"></td>';
            emsg += '   <td valign=\\"top\\"><img src=\\"images/spacer.gif\\" width=\\"39\\" height=\\"1\\" alt=\\"\\"></td>';
            emsg += '    <td valign=\\"top\\"><img src=\\"images/spacer.gif\\" width=\\"46\\" height=\\"1\\" alt=\\"\\"></td>';
            emsg += '   </tr>';
            emsg += ' </table>';
            emsg += '</body>';
            emsg += '</html>'; 

            system.debug('------>'+emsg);
            //email.sethtmlbody(emsg);      
            //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
            SOLsendEmail.DiscrepencySendEmail(toAddress,'Thank you, We have received your banking details',emsg);
        }
    }   
    }
    
    public Bank_Transaction__c findSummary(Integer month, Integer year,Bank_Transaction__c transObj){
        Bank_Transaction__c returnTrans = new Bank_Transaction__c();
        boolean found = false;
        
        for(Bank_Transaction__c trans:newTrans){
            System.debug('********trans.Month__c: '+trans.Month__c+'***month: '+month+'***trans.Year__c: '+trans.Year__c+'***year: '+year);
            if(trans.Month__c == month && trans.Year__c == year){
                returnTrans = trans;
                found= true;
                break;
            }
        }
        System.debug('************found: '+found);
        if(found == false){
            returnTrans.Month__c = month;
            returnTrans.Year__c = year;
            returnTrans.DB_No__c = 0;
            returnTrans.DB_Amount__c = 0;
            returnTrans.CRD_No__c = 0;
            returnTrans.CRD_Amount__c = 0;
            String m = String.valueOf(month);
            if(m.length() == 1)
               m = '0' + m;
            returnTrans.Monthtext__c = m;
            returnTrans.Year_in_text__c = String.valueOf(year).substring(2,4);
            returnTrans.Bank_Account__c = transObj.Bank_Account__c;
            newTrans.add(returnTrans);
        }
        return returnTrans;
    }
}