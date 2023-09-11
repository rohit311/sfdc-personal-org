trigger SOLRejectionCheck1 on SOL_CAM__c (after update) {
List<SOL_Policy__c> solPolicy = new List<SOL_Policy__c>();
List<SOL_Policy__c> RejsolPolicy = new List<SOL_Policy__c>();
List<SOL_Policy__c> RefersolPolicy = new List<SOL_Policy__c>();
List<SOL_Policy__c> solPolicyupdate = new List<SOL_Policy__c>();
List<SOL_Policy__c> ReferPolicyBranch = new List<SOL_Policy__c>();
List<User> UnderFinID= new List<User>();
List<Opportunity> Loan = new List<Opportunity>();
List<Opportunity> Loanlist = new List<Opportunity>();
List<SOL_CAM__c> solcam= new List<SOL_CAM__c>();
List<ID> oppID = new List<ID>();
List<ID> solcamID= new List<ID>();
Decimal MaxAmt,EMI,MaxAmtEmail,MaxAmtTenure;
Integer EmailTenour,EMIAmount;
String strConvertedDate;
DateTime TransTime = System.now();
    TransTime=TransTime.addHours(5);
    TransTime=TransTime.addMinutes(30);
    strConvertedDate =TransTime.format('dd/MM/yyyy hh:mm:ss a','GST');
if(!ControlRecursiveCallofTrigger_Util.hasPreUpdate()){
/*if (!ControlRecursiveCallofTrigger_Util.hasSOLCAMRejectionTri()) {
ControlRecursiveCallofTrigger_Util.setSOLCAMRejectionTri();*/
for(SOL_CAM__c sol : Trigger.New)
{
oppID.add(sol.Loan_Application__c);
solcamID.add(sol.id);
}
solcam=[select id,ROI__c,Applicant__r.Contact_Name__r.Mobile__c,Loan_Application__r.Customer_email_id__c,Loan_Application__r.Loan_Application_Number__c,Loan_Application__r.Customer_Reference_Number__c,Credit_Card_Monthly_Obligation__c , EMI_Bounce_In_Last_3_Months__c ,Current_Employer_Less_than_6_Months__c from  SOL_CAM__c where id=:solcamID[0]];

if(solcam.size()>0){
if(solcam[0].Credit_Card_Monthly_Obligation__c==true && solcam[0].EMI_Bounce_In_Last_3_Months__c==true){
Loan = [Select id,Approver__c,Customer_email_id__c,Name,Customer_Reference_Number__c,Office_MobileRef1__c,OwnerID,StageName,Product__c from opportunity where id in:OppID Limit 1];
system.debug(solcam[0].Credit_Card_Monthly_Obligation__c+'credit mont+++'+solcam[0].Current_Employer_Less_than_6_Months__c+'current');
if(Loan.size()>0 && Loan[0].Product__c=='SOL'){
solPolicy =[Select id,Name,Policy_Status__c,Policy_Name__c from SOL_Policy__c where Loan_Application__c in:oppId];
        for(SOL_Policy__c policy : solPolicy)
        {
        if(policy.Policy_Status__c=='Reject')
        RejsolPolicy.add(policy);
        if(policy.Policy_Status__c=='Refer')
        RefersolPolicy.add(policy);
        if(policy.Policy_Name__c=='PAN Number Starts with C or D' || policy.Policy_Name__c=='Current employment less than 6 and Residence not owned')
        ReferPolicyBranch.add(policy);
        }
        system.debug('******Rejected LIst******'+RejsolPolicy);
            for(SOL_CAM__c sol : Trigger.New)
            {
                 if(RejsolPolicy.size()>0 && Loan.size()>0 && Loan[0].StageName=='Incomplete Application'&& (Trigger.oldmap.get(sol.id).Total_Monthly_Obligation__c != Trigger.Newmap.get(sol.id).Total_Monthly_Obligation__c ||
                 Trigger.Newmap.get(sol.id).Credit_Card_Monthly_Obligation__c!=Trigger.oldmap.get(sol.id).Credit_Card_Monthly_Obligation__c || Trigger.Newmap.get(sol.id).EMI_Bounce_In_Last_3_Months__c!=Trigger.oldmap.get(sol.id).EMI_Bounce_In_Last_3_Months__c || 
                 Trigger.Newmap.get(sol.id).Current_Employer_Less_than_6_Months__c!=Trigger.oldmap.get(sol.id).Current_Employer_Less_than_6_Months__c))
                 {
                    system.debug('inside auto reject**************solreject');
                  Loan[0].StageName='Auto Rejected';
                  String sms ='We regret to inform that Personal Loan application number '+solcam[0].Loan_Application__r.Loan_Application_Number__c+' has been rejected due to non-conformance to our internal policies. Thank you, Bajaj Finserv Lending';
                     List<String> toAdd = new List<String>();
                     toAdd.add(solcam[0].Loan_Application__r.Customer_email_id__c);
                     String Sub =  'Rejection of your application for personal loan';
                     String Body ='<table border=\\"1\\"><tr><th><b>Application Reference Number</b></th></tr><tr><td><center>'+solcam[0].Loan_Application__r.Customer_Reference_Number__c+'</center></td></tr></table><br></br>Dear '+sol.Name_OF_Applicant__c+'<br></br>We have scrutinized your application and the documents submitted by you on '+strConvertedDate+'. The information provided by you does not satisfy our internal policies on loan approvals. We regret to inform you that we will not be able to process your application for a personal loan. <br></br>If you wish to, you can however avail of our other products provided you meet the eligibility criteria.<br></br>Sincerely,<br></br>Bajaj Finserv Lending<br></br>Approval of your loan request is at the sole discretion of Bajaj Finserv Lending and is governed by the Terms & Conditions applicable to your loan request.<br></br>This is a system generated alert and does not require a signature. We request you not to reply to this message. This e-mail is confidential and may also be privileged. Please do not copy or use it for any purpose, nor disclose its contents to any other person. If you are not the intended recipient, please notify us, or write in with your queries, at wecare@bajajfinserv.in';
                     SOLsendEmail.LogixEmail(toAdd,Sub,Body);
                     sendsms.message(String.valueof(solcam[0].Applicant__r.Contact_Name__r.Mobile__c),sms);          
                     Loanlist.add(Loan[0]);
                   //update Loan[0];
                 }
               /* else if(ReferPolicyBranch.size()>0 && Trigger.oldmap.get(sol.id).Total_Monthly_Obligation__c != Trigger.Newmap.get(sol.id).Total_Monthly_Obligation__c && 
                 (Trigger.Newmap.get(sol.id).Credit_Card_Monthly_Obligation__c==true || Trigger.Newmap.get(sol.id).EMI_Bounce_In_Last_3_Months__c ==true || 
                 Trigger.Newmap.get(sol.id).Current_Employer_Less_than_6_Months__c==true))
                 {
                  Loan[0].StageName='Branch CPA - Doc Check';
                  update Loan[0];
                 }*/
                 else if(RefersolPolicy.size()>0 && Loan.size()>0 && Loan[0].StageName=='Incomplete Application'&& Trigger.oldmap.get(sol.id).Total_Monthly_Obligation__c != Trigger.Newmap.get(sol.id).Total_Monthly_Obligation__c && 
                 (Trigger.Newmap.get(sol.id).Credit_Card_Monthly_Obligation__c==true || Trigger.Newmap.get(sol.id).EMI_Bounce_In_Last_3_Months__c ==true || 
                 Trigger.Newmap.get(sol.id).Current_Employer_Less_than_6_Months__c==true))
                 {
                 UnderFinID=[Select Id,Profile.Name from User where Product__c includes('SOL') and ProfileId=:'00e90000000qwYZ' and IsActive=true Limit 1];
                  if(UnderFinID.size()>0){
                  Loan[0].OwnerID=UnderFinID[0].id;
                  Loan[0].Approver__c=UnderFinID[0].Profile.Name;
                  }
                     Loan[0].StageName='Refer';
                     String sms ='To proceed with your eXpress personal loan application, Our eXpress personal loan manager will be calling you to get some clarifications and/ or documents. Thank you, Bajaj Finserv Lending';
                     List<String> toAdd = new List<String>();
                     toAdd.add(Loan[0].Customer_email_id__c);
                     string sub='Appointment for collecting Documents and seeking Clarifications';
                     String Body ='Dear '+Loan[0].Name+'<br></br><br></br>To proceed with your application number '+Loan[0].Customer_Reference_Number__c+', we need some clarifications and documents. Our xPress Personal loan manager will get in touch with you on your office phone number '+Loan[0].Office_MobileRef1__c+' for the same.<br></br><br></br>Sincerely,<br></br>Bajaj Finserv Lending<br></br><br></br>Approval of your loan request is at the sole discretion of Bajaj Finserv Lending and is governed by the Terms & Conditions applicable to your loan request.<br></br><br></br>This is a system generated alert and does not require a signature. We request you not to reply to this message. This e-mail is confidential and may also be privileged. Please do not copy or use it for any purpose, nor disclose its contents to any other person. If you are not the intended recipient, please notify us, or write in with your queries, at wecare@bajajfinserv.in';  
                     SOLsendEmail.LogixEmail(toAdd,Sub,Body);
                     sendsms.message(String.valueof(Loan[0].Office_MobileRef1__c),sms); 
                // update Loan[0];
                  Loanlist.add(Loan[0]);
                 }
                else if(Loan.size()>0 && Loan[0].StageName=='Incomplete Application' && solPolicy.size()==0 && Loan[0].StageName!='Refer' && Loan[0].StageName!='Auto Rejected' && Loan[0].StageName!='Branch CPA - Doc Check' && (Trigger.oldmap.get(sol.id).Total_Monthly_Obligation__c != Trigger.Newmap.get(sol.id).Total_Monthly_Obligation__c || Trigger.oldmap.get(sol.id).EMI_Bounce_In_Last_3_Months__c != Trigger.Newmap.get(sol.id).EMI_Bounce_In_Last_3_Months__c || Trigger.oldmap.get(sol.id).Credit_Card_Monthly_Obligation__c != Trigger.Newmap.get(sol.id).Credit_Card_Monthly_Obligation__c
                 || Trigger.oldmap.get(sol.id).Current_Employer_Less_than_6_Months__c != Trigger.Newmap.get(sol.id).Current_Employer_Less_than_6_Months__c) && 
                (sol.Final_Loan_Amount_For_Tennor12__c>0 || sol.Final_Loan_Amount_For_Tennor24__c>0 ||sol.Final_Loan_Amount_For_Tennor36__c>0 
                ||sol.Final_Loan_Amount_For_Tennor48__c>0 ||sol.Final_Loan_Amount_For_Tennor60__c>0 )&& 
                (Trigger.Newmap.get(sol.id).Credit_Card_Monthly_Obligation__c==true && Trigger.Newmap.get(sol.id).EMI_Bounce_In_Last_3_Months__c ==true &&
                 Trigger.Newmap.get(sol.id).Current_Employer_Less_than_6_Months__c==true))
                  {
                     Loan[0].StageName='Auto Approved';
                     List<Decimal> FinalMaxAmt= new List<Decimal>();
                     if(sol.Final_Loan_Amount_For_Tennor12__c!=null)
                    FinalMaxAmt.add(sol.Final_Loan_Amount_For_Tennor12__c);
                     if(sol.Final_Loan_Amount_For_Tennor24__c!=null)
                    FinalMaxAmt.add(sol.Final_Loan_Amount_For_Tennor24__c);
                     if(sol.Final_Loan_Amount_For_Tennor36__c!=null)
                    FinalMaxAmt.add(sol.Final_Loan_Amount_For_Tennor36__c);
                     if(sol.Final_Loan_Amount_For_Tennor48__c!=null)
                    FinalMaxAmt.add(sol.Final_Loan_Amount_For_Tennor48__c);
                     if(sol.Final_Loan_Amount_For_Tennor60__c!=null)
                    FinalMaxAmt.add(sol.Final_Loan_Amount_For_Tennor60__c);
                     MaxAmt= FinalMaxAmt[0];
                    MaxAmtTenure= FinalMaxAmt[0];
                    if(FinalMaxAmt.size()>1){
                            For (integer i =0;i<FinalMaxAmt.size();i++)
                            {
                               
                                if(FinalMaxAmt[i] > MaxAmt)
                                {
                                    MaxAmt= FinalMaxAmt[i]; 
                                    MaxAmt=MaxAmt/25000;
                                    MaxAmt= math.floor(MaxAmt);
                                    MaxAmt=MaxAmt*25000;
                                }  
                                  if(FinalMaxAmt[i] > MaxAmtTenure)
                                  {
                                  MaxAmtTenure=FinalMaxAmt[i];
                                  }        
                            }  
                            }
                            else
                            {
                            MaxAmt=FinalMaxAmt[0];
                            MaxAmtTenure=FinalMaxAmt[0];
                            }   
                          MaxAmtEmail = Math.Round(MaxAmt);       
                        if(MaxAmtTenure== sol.Final_Loan_Amount_For_Tennor12__c)
                        EmailTenour=12;
                        if(MaxAmtTenure== sol.Final_Loan_Amount_For_Tennor24__c)
                        EmailTenour=24;
                        if(MaxAmtTenure== sol.Final_Loan_Amount_For_Tennor36__c)
                        EmailTenour=36;
                        if(MaxAmtTenure== sol.Final_Loan_Amount_For_Tennor48__c)
                        EmailTenour=48;
                        if(MaxAmtTenure== sol.Final_Loan_Amount_For_Tennor60__c)
                        EmailTenour=60;
                       if(EmailTenour!=null && MaxAmt!=null && sol.ROI__c!=null)
                            EMI= (MaxAmt* sol.ROI__c/1200) / (1 - Math.pow((1 + double.valueof(sol.ROI__c/1200)), -Integer.valueof(EmailTenour)));
                       if(EMI!=null)
                        EMIAmount=Integer.valueOf(EMI);
                      String sms ='Congratulations. Your Personal Loan application '+solcam[0].Loan_Application__r.Loan_Application_Number__c+' for '+MaxAmt+' with '+EmailTenour+' months tenor and '+sol.Monthly_Loan_EMI__c+' EMI has been approved in principal. Thank you, Bajaj Finserv Lending';
                     List<String> toAdd = new List<String>();
                     toAdd.add(solcam[0].Loan_Application__r.Customer_email_id__c);
                     String Sub =  'Personal Loan approval details';
                     String Body ='<table border=\\"1\\"><tr><th><b>Application Reference Number</b></th></tr><tr><td><center>'+solcam[0].Loan_Application__r.Customer_Reference_Number__c+'</center></td></tr></table><br></br>Dear '+sol.Name_OF_Applicant__c+'<br></br>Congratulations. Your Personal Loan application has been approved in principle and is in final stages of verification.<br></br>Your loan details are given below.<br></br><table border=1><tr><th><b><center>Applicant Name</center></b></th>'+'<td><center>'+sol.Name_OF_Applicant__c+'</center></td></tr><tr><th><b><center>Application Number</center></b></th>'+'<td><center>'+solcam[0].Loan_Application__r.Loan_Application_Number__c+'</center></td></tr><tr><th><b><center>Loan Amount</center></b></th>'+'<td><center>'+MaxAmtEmail+'</center></td></tr><tr><th><b><center>Tenor</center></b></th>'+'<td><center>'+EmailTenour+'</center></td></tr><tr><th><b><center>EMI</center></b></th>'+'<td><center>'+EMIAmount+'</center></td></tr><tr><th><b><center>Your best rate</center></b></th>'+'<td><center>'+sol.ROI__c+'</center></td></tr></table><br></br><i>Please note that further processing of your loan application is subject to your acceptance of our Terms & Conditions.</i><br></br>We will soon contact you on the final approval of your loan application. In case of any query please get in touch with your Personal Loan Manager at '+'18001033535'+'<br></br>Sincerely,<br></br>Bajaj Finserv Lending<br></br>Approval of your loan request is at the sole discretion of Bajaj Finserv Lending and is governed by the Terms & Conditions applicable to your loan request.<br></br>This is a system generated alert and does not require a signature. We request you not to reply to this message. This e-mail is confidential and may also be privileged. Please do not copy or use it for any purpose, nor disclose its contents to any other person. If you are not the intended recipient, please notify us, or write in with your queries, at wecare@bajajfinserv.in';
                      SOLsendEmail.LogixEmail(toAdd,Sub,Body);
                     sendsms.message(String.valueof(solcam[0].Applicant__r.Contact_Name__r.Mobile__c),sms);          
                    // update Loan[0];
                      Loanlist.add(Loan[0]);
              }
          
          if(Loan.size()>0 && Loan[0].Product__c=='SOL' && Loan[0].StageName=='Auto Approved' && sol.Loan_Amount_Selected_by_Customer__c!=null && sol.Tenure_Selected_By_Customer__c!=null)
        {
            Loan[0].StageName='Auto Approved Accepted';
            Loan[0].Approval_Stages__c='Auto Approved Accepted';
            Loan[0].Approver__c='System Administrator';
            //update Loan[0];
             Loanlist.add(Loan[0]);
        }
                 
  }
	   if(Loanlist.size()>0)   {
	   	update loanlist;
	   }  
   }
  } 
}
//}
}
}