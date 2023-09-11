trigger SOLProcessInitiator on Applicant__c (after insert, before update) {
Date TDay=System.Today();
Date DOB;

Set<ID>OppID = new Set<ID>();
List<Opportunity> Loan = new List<Opportunity>();
List<SOL_Policy__c> PolicyList = new List<SOL_Policy__c>(); 
List<SOL_Policy__c> PolicyListUpdate = new List<SOL_Policy__c>();
List<ID> AppID = new List<ID>();
Boolean cibil = False;
Integer CibilScore=0;
List<Applicant__c> apps=new List<Applicant__c>();
List<Opportunity>UpLoan = new List<Opportunity>();

List<SOL_CAM__c> Sol = new List<SOL_CAM__c>();
public set<id> conid=new set<id>();

Boolean newSOLFlow;
if(label.SOL_Online_Flow_Control=='SOLV1'){
  newSOLFlow = false;
}else if(label.SOL_Online_Flow_Control=='SOLV2'){
  newSOLFlow = true;
}


if(trigger.isinsert){
 if(!test.isRunningTest())
ControlRecursiveCallofTrigger_Util.SOLProcessInitator= false;
}


if (!ControlRecursiveCallofTrigger_Util.hasSOLProcessInitator()) {
ControlRecursiveCallofTrigger_Util.setSOLProcessInitator();
for(Applicant__c App : Trigger.new)
{
AppID.add(App.Id);
}
Loan = [select id, StageName,Product__c,LAN__c,Quality_Check_Status__c from Opportunity where id=:Trigger.New[0].Loan_Application__c];



system.debug('**********Loan'+Loan);
if(Loan.size()>0 && (Loan[0].Product__c=='SOL'  && !newSOLFlow))
{
sol = [select id,Applicant__c,Cibil_Score__c from SOL_Cam__c where Applicant__c in:AppId];
PolicyListUpdate =[Select id,Name from SOL_Policy__c where Created_From_Applicant__c=:True and Loan_Application__c=:Loan[0].Id];
apps=[select id,name,Update_CIBIL_Error__c,Type_of_Borrower__c,Re_Initiate_De_Dupe__c,Integrate_with_CIBIL__c,Contact_Name__c,Contact_Name__r.Name,Contact_Name__r.Customer_Profile__c,
                      Contact_Name__r.Designation__c,Contact_Name__r.Employer_Name__c,Contact_Name__r.Qualification__c,Contact_Name__r.Address_1__c,
                      PD_Status__c,Bank_Status__c,Contact_Name__r.Address_2__c,FCU_Status__c,ITR_Status__c,Office_SE_Status__c,Office_SAL_Status__c,
                      Office_Status__c,Pay_Slips_Status__c,Residence_Status__c,Trade_Status__c,TVR_Status__c,Select_Applicant__c,Applicant_Type__c,Contact_Name__r.Customer_Type__c,Contact_Name__r.ApplicantType__c,
                      Contact_Name__r.Date_of_Birth__c,Contact_Name__r.FathersHusbands_Name__c,Contact_Name__r.PAN_Number__c,Contact_Name__r.Year_of_Incorporation__c,Contact_Name__r.Account.TIN_Number__c,
                      Contact_Name__r.Bank_Account_No__c,Contact_Name__r.VoterID_Number__c,Contact_Name__r.ROC_Regn_No__c,Contact_Name__r.Address_3__c,Contact_Name__r.AppCity__c,
                      Contact_Name__r.Pin_Code__c,Contact_Name__r.Phone,Contact_Name__r.MobilePhone,Contact_Name__r.Email,Contact_Name__r.Address_Line_One__c,Contact_Name__r.Address_2nd_Line__c,Contact_Name__r.Address_3rd_Line__c,
                      Contact_Name__r.Permanent_Land_Mark__c,Contact_Name__r.Office_City__c,Contact_Name__r.Office_Pin_Code__c,Contact_Name__r.Office_STD_Code__c,Contact_Name__r.Office_Phone_Number__c,
                      Contact_Name__r.Mobile_Phone__c,Contact_Name__r.Office_Email_Id__c,Contact_Name__r.Middle_Name__c,Employer__c,Company_Type__c,Company_Name__c,Contact_Name__r.Company_Type__c,
                      DIN_No_if_applicable__c,Contact_Name__r.FirstName,Contact_Name__r.LastName,Contact_Name__r.Permanant_Address_Line_1__c,Contact_Name__r.Permanant_Address_Line_2__c,Contact_Name__r.Permanant_Address_Line_3__c,
                      Contact_Name__r.Permanent_STD__c,Contact_Name__r.Permanent_Pin_Code__c,Contact_Name__r.Year_in_Present_Job__c,Contact_Name__r.Year_in_Previous_Job__c,Contact_Name__r.Name_of_the_company_Employer__c,
                      Contact_Name__r.Nature_of_Business__c,Contact_Name__r.Employment_Status__c,Contact_Name__r.Gender__c,Contact_Name__r.Age__c,Contact_Name__r.Employment_Type__c,Contact_Name__r.STD_Code__c,Contact_Name__r.Phone_Number__c,
                      Contact_Name__r.Name_of_Employer__c,Contact_Name__r.PAN_Card_Status__c,Contact_Name__r.PAN__c,Designation__c,Contact_Name__r.Type_Of_Constitution__c,Contact_Name__r.Marital_Status__c,Contact_Mobile__c,Contact_Name__r.Residence_City__c , Contact_Name__r.Sex__c  
                      from Applicant__c where Loan_Application__c=:Loan[0].Id];   
    if(trigger.isinsert )
    {
         
    
                    De_dupe__c dedupe=new De_dupe__c();
                    dedupe.Applicant__c=apps[0].id;
                    //dedupe.Customer_First_Name__c=apps[0].Contact_Name__r.FirstName;
                    dedupe.Applicant_Type__c='P'; 
                    dedupe.Customer_Type__c='I';
                    dedupe.Loan_Application__c=Loan[0].Id;
                    dedupe.Employer_Name__c=apps[0].Contact_Name__r.Employer_Name__c;
                    dedupe.DOB__c=apps[0].Contact_Name__r.Date_of_Birth__c;
                    dedupe.Fathers_Husband_s_Name__c=apps[0].Contact_Name__r.FathersHusbands_Name__c;
                    dedupe.PAN__c=apps[0].Contact_Name__r.PAN_Number__c;
                    dedupe.Company_Date_of_Incorporation__c =apps[0].Contact_Name__r.Year_of_Incorporation__c;
                    dedupe.Company_TIN_No__c=apps[0].Contact_Name__r.Account.TIN_Number__c;
                    dedupe.AccNo__c=String.valueof(apps[0].Contact_Name__r.Bank_Account_No__c);
                    dedupe.VoterID__c=apps[0].Contact_Name__r.VoterID_Number__c;
                    dedupe.Credit_Card_No__c=apps[0].Contact_Name__r.ROC_Regn_No__c;
                    //dedupe.Existing_LAN_1__c=String.valueof(Loan.LINK_LAN__c);
                    dedupe.Existing_LAN_2__c=Loan[0].LAN__c; 
                    dedupe.Address1_Residence__c=apps[0].Contact_Name__r.Address_1__c;
                    dedupe.Address2_Residence__c=apps[0].Contact_Name__r.Address_2__c;
                    dedupe.Address3_Residence__c=apps[0].Contact_Name__r.Address_3__c;
                    dedupe.City_Residence__c=apps[0].Contact_Name__r.AppCity__c;
                    dedupe.PIN__c=string.valueof(apps[0].Contact_Name__r.Pin_Code__c);
                    if(apps[0].Contact_Name__r.Phone != null)
                    dedupe.Landline2_Residence__c=string.valueof(Integer.valueof(apps[0].Contact_Name__r.Phone));
                    if(apps[0].Contact_Name__r.MobilePhone != null)
                    dedupe.Mobile_Residence__c=string.valueof(apps[0].Contact_Name__r.MobilePhone);
                    dedupe.Email_Residence__c=apps[0].Contact_Name__r.Email;
                    dedupe.Address1_Office__c=apps[0].Contact_Name__r.Address_Line_One__c;
                    dedupe.Address2_Office__c=apps[0].Contact_Name__r.Address_2nd_Line__c;
                    dedupe.Address3_Office__c=apps[0].Contact_Name__r.Address_3rd_Line__c;
                    dedupe.Area_Office__c=apps[0].Contact_Name__r.Address_Line_One__c;
                    dedupe.Landmark_Office__c=apps[0].Contact_Name__r.Permanent_Land_Mark__c;
                    dedupe.City_Office__c=apps[0].Contact_Name__r.Office_City__c;
                    dedupe.Pin_Office__c=apps[0].Contact_Name__r.Office_Pin_Code__c;
                    dedupe.STD_Office__c=string.valueof(apps[0].Contact_Name__r.Office_STD_Code__c);
                    dedupe.Landline1_Office__c=apps[0].Contact_Name__r.Office_Phone_Number__c;
                    dedupe.Landline2_Office__c=apps[0].Contact_Name__r.Office_Phone_Number__c;
                    dedupe.Mobile_Office__c=apps[0].Contact_Name__r.Mobile_Phone__c;
                    dedupe.Email_Office__c=apps[0].Contact_Name__r.Office_Email_Id__c;
                    dedupe.Email_Office__c=apps[0].Contact_Name__r.Office_Email_Id__c;
                    dedupe.De_Dupe_Decision__c = 'None';
                   dedupe.De_Dupe_result__c = 'None';
                   if(apps[0].Contact_Name__r.Customer_Type__c == 'Corporate')
                     dedupe.First_Name__c=apps[0].Contact_Name__r.Name;
                   else
                    {                
                         string name1=apps[0].Contact_Name__r.Name;
                         if(name1.contains(' ')){
                         list<string> splitname = name1.split(' ');
                         if(splitname [0]!=null)
                         dedupe.First_Name__c=splitname[0];
                         if(splitname[1]!=null)
                         dedupe.last_Name__c=splitname[1];
                         }
                         
                         dedupe.Middle_Name__c=apps[0].Contact_Name__r.Middle_Name__c;
                    }
                                    
                    dedupe.Datafix_Updated__c='New records';
                    dedupe.Application_Status__c='Complete';
                    if(loan[0].Quality_Check_Status__c == 'Dedupe')
                    dedupe.Application_ID__c = 'Dedupe';
                   insert dedupe;
                   
          
                
    }
    if(Trigger.Isupdate)
    {
       if(apps.size()>0)
      {
        if(apps[0].Contact_Name__r.PAN_Card_Status__c!=null && apps[0].Contact_Name__r.PAN_Card_Status__c=='Not in ITD Database')
          {
            SOL_Policy__c sp = new SOL_Policy__c();
            sp.Policy_Name__c = 'PAN Not in ITD Database';
            sp.Policy_Status__c='Reject';
            sp.Loan_Application__c=Loan[0].Id;
            sp.Created_From_Applicant__c=True;
           // PolicyList.add(sp);
          }
           
          if(apps[0].Contact_Name__r.PAN_Card_Status__c!=null && apps[0].Contact_Name__r.PAN_Card_Status__c=='Fake PAN')
          {
            SOL_Policy__c sp = new SOL_Policy__c();
            sp.Policy_Name__c = 'Fake PAN';
            //sp.Policy_Status__c='Reject';
            sp.Policy_Status__c='Rejected';
            sp.Loan_Application__c=Loan[0].Id;
            sp.Created_From_Applicant__c=True;
           
            PolicyList.add(sp);
          }
          
          if(apps[0].Contact_Name__r.PAN__c!=null && (apps[0].Contact_Name__r.PAN__c.startsWith('C')|| apps[0].Contact_Name__r.PAN__c.startsWith('D')))
             {
            SOL_Policy__c sp = new SOL_Policy__c();
            sp.Policy_Name__c = 'PAN Number Starts with C or D';
            sp.Policy_Status__c='Refer';
            sp.Loan_Application__c=Loan[0].Id;
            sp.Created_From_Applicant__c=True;
            
            PolicyList.add(sp);
          }
          
       }
    }

for(Applicant__c App : Trigger.new)
  {
  if(App.CIBIL_Score__c!=null){
  if(App.CIBIL_Score__c=='000-1')
  cibil = True;
  else
  CibilScore=Integer.valueof(App.CIBIL_Score__c);
  }
  if(Loan.size()>0 && App.CIBIL_Score__c!= null &&(CibilScore<700 || cibil==True))
  {
           SOL_Policy__c sp = new SOL_Policy__c();
            sp.Policy_Name__c = 'CIBIL Score';
            sp.Policy_Status__c='Rejected';
            sp.Loan_Application__c=Loan[0].Id;
            sp.Created_From_Applicant__c=True;
            PolicyList.add(sp);
           
  }
  

  if(PolicyListUpdate.size()>0)
  Delete PolicyListUpdate;
  if(PolicyList.size()>0)
  Insert PolicyList;
  
 
  
 if(Trigger.Isupdate && App.Cibil_Score__c!=null)
 {
 
 if(sol.size()>0 && Trigger.oldmap.get(App.id).CIBIL_Score__c !=  Trigger.Newmap.get(App.id).CIBIL_Score__c)
 {
 if(App.Cibil_Score__c=='000-1')
 sol[0].cibil_Score__c=1;
 else
 sol[0].cibil_Score__c = Integer.valueof(App.Cibil_Score__c);
 
 update sol[0];
 }
 }
  }
  }
  else if(Loan.size()>0 && Loan[0].Product__c=='LASOL'){
    system.debug('**********Test new product LASOL');
    sol = [select id,Applicant__c,Cibil_Score__c from SOL_Cam__c where Applicant__c in:AppId];
    PolicyListUpdate =[Select id,Name from SOL_Policy__c where Created_From_Applicant__c=:True and Loan_Application__c=:Loan[0].Id];
    apps=[select id,name,Update_CIBIL_Error__c,Type_of_Borrower__c,Re_Initiate_De_Dupe__c,Integrate_with_CIBIL__c,Contact_Name__c,Contact_Name__r.Name,Contact_Name__r.Customer_Profile__c,
                          Contact_Name__r.Designation__c,Contact_Name__r.Employer_Name__c,Contact_Name__r.Qualification__c,Contact_Name__r.Address_1__c,
                          PD_Status__c,Bank_Status__c,Contact_Name__r.Address_2__c,FCU_Status__c,ITR_Status__c,Office_SE_Status__c,Office_SAL_Status__c,
                          Office_Status__c,Pay_Slips_Status__c,Residence_Status__c,Trade_Status__c,TVR_Status__c,Select_Applicant__c,Applicant_Type__c,Contact_Name__r.Customer_Type__c,Contact_Name__r.ApplicantType__c,
                          Contact_Name__r.Date_of_Birth__c,Contact_Name__r.FathersHusbands_Name__c,Contact_Name__r.PAN_Number__c,Contact_Name__r.Year_of_Incorporation__c,Contact_Name__r.Account.TIN_Number__c,
                          Contact_Name__r.Bank_Account_No__c,Contact_Name__r.VoterID_Number__c,Contact_Name__r.ROC_Regn_No__c,Contact_Name__r.Address_3__c,Contact_Name__r.AppCity__c,
                          Contact_Name__r.Pin_Code__c,Contact_Name__r.Phone,Contact_Name__r.MobilePhone,Contact_Name__r.Email,Contact_Name__r.Address_Line_One__c,Contact_Name__r.Address_2nd_Line__c,Contact_Name__r.Address_3rd_Line__c,
                          Contact_Name__r.Permanent_Land_Mark__c,Contact_Name__r.Office_City__c,Contact_Name__r.Office_Pin_Code__c,Contact_Name__r.Office_STD_Code__c,Contact_Name__r.Office_Phone_Number__c,
                          Contact_Name__r.Mobile_Phone__c,Contact_Name__r.Office_Email_Id__c,Contact_Name__r.Middle_Name__c,Employer__c,Company_Type__c,Company_Name__c,Contact_Name__r.Company_Type__c,
                          DIN_No_if_applicable__c,Contact_Name__r.FirstName,Contact_Name__r.LastName,Contact_Name__r.Permanant_Address_Line_1__c,Contact_Name__r.Permanant_Address_Line_2__c,Contact_Name__r.Permanant_Address_Line_3__c,
                          Contact_Name__r.Permanent_STD__c,Contact_Name__r.Permanent_Pin_Code__c,Contact_Name__r.Year_in_Present_Job__c,Contact_Name__r.Year_in_Previous_Job__c,Contact_Name__r.Name_of_the_company_Employer__c,
                          Contact_Name__r.Nature_of_Business__c,Contact_Name__r.Employment_Status__c,Contact_Name__r.Gender__c,Contact_Name__r.Age__c,Contact_Name__r.Employment_Type__c,Contact_Name__r.STD_Code__c,Contact_Name__r.Phone_Number__c,
                          Contact_Name__r.Name_of_Employer__c,Contact_Name__r.PAN_Card_Status__c,Contact_Name__r.PAN__c,Designation__c,Contact_Name__r.Type_Of_Constitution__c,Contact_Name__r.Marital_Status__c,Contact_Mobile__c,Contact_Name__r.Residence_City__c , Contact_Name__r.Sex__c  
                          from Applicant__c where Loan_Application__c=:Loan[0].Id];
        system.debug('%%%%%%%%%%%%%%%%%%%%apps'+apps);
        
        for(Applicant__c aa:apps){
            conid.add(aa.Contact_Name__c);
        }
        system.debug('*************'+conid);
        List<Contact> conList=[Select PAN_Card_Status__c,ApplicantType__c,CIBIL_Score__c,Customer_Type__c from Contact where id in :conid];
        system.debug('%%%%%%%%%%%%%%%%%%%%apps'+conList);   
        if(trigger.isinsert)
        {
             
        
                        De_dupe__c dedupe=new De_dupe__c();
                        dedupe.Applicant__c=apps[0].id;
                        //dedupe.Customer_First_Name__c=apps[0].Contact_Name__r.FirstName;
                        dedupe.Applicant_Type__c='P'; 
                        dedupe.Customer_Type__c='I';
                        dedupe.Loan_Application__c=Loan[0].Id;
                        dedupe.Employer_Name__c=apps[0].Contact_Name__r.Employer_Name__c;
                        dedupe.DOB__c=apps[0].Contact_Name__r.Date_of_Birth__c;
                        dedupe.Fathers_Husband_s_Name__c=apps[0].Contact_Name__r.FathersHusbands_Name__c;
                        dedupe.PAN__c=apps[0].Contact_Name__r.PAN_Number__c;
                        dedupe.Company_Date_of_Incorporation__c =apps[0].Contact_Name__r.Year_of_Incorporation__c;
                        dedupe.Company_TIN_No__c=apps[0].Contact_Name__r.Account.TIN_Number__c;
                        dedupe.AccNo__c=String.valueof(apps[0].Contact_Name__r.Bank_Account_No__c);
                        dedupe.VoterID__c=apps[0].Contact_Name__r.VoterID_Number__c;
                        dedupe.Credit_Card_No__c=apps[0].Contact_Name__r.ROC_Regn_No__c;
                        //dedupe.Existing_LAN_1__c=String.valueof(Loan.LINK_LAN__c);
                        dedupe.Existing_LAN_2__c=Loan[0].LAN__c; 
                        dedupe.Address1_Residence__c=apps[0].Contact_Name__r.Address_1__c;
                        dedupe.Address2_Residence__c=apps[0].Contact_Name__r.Address_2__c;
                        dedupe.Address3_Residence__c=apps[0].Contact_Name__r.Address_3__c;
                        dedupe.City_Residence__c=apps[0].Contact_Name__r.AppCity__c;
                        dedupe.PIN__c=string.valueof(apps[0].Contact_Name__r.Pin_Code__c);
                        if(apps[0].Contact_Name__r.Phone != null)
                        dedupe.Landline2_Residence__c=string.valueof(Integer.valueof(apps[0].Contact_Name__r.Phone));
                        if(apps[0].Contact_Name__r.MobilePhone != null)
                        dedupe.Mobile_Residence__c=string.valueof(apps[0].Contact_Name__r.MobilePhone);
                        dedupe.Email_Residence__c=apps[0].Contact_Name__r.Email;
                        dedupe.Address1_Office__c=apps[0].Contact_Name__r.Address_Line_One__c;
                        dedupe.Address2_Office__c=apps[0].Contact_Name__r.Address_2nd_Line__c;
                        dedupe.Address3_Office__c=apps[0].Contact_Name__r.Address_3rd_Line__c;
                        dedupe.Area_Office__c=apps[0].Contact_Name__r.Address_Line_One__c;
                        dedupe.Landmark_Office__c=apps[0].Contact_Name__r.Permanent_Land_Mark__c;
                        dedupe.City_Office__c=apps[0].Contact_Name__r.Office_City__c;
                        dedupe.Pin_Office__c=apps[0].Contact_Name__r.Office_Pin_Code__c;
                        dedupe.STD_Office__c=string.valueof(apps[0].Contact_Name__r.Office_STD_Code__c);
                        dedupe.Landline1_Office__c=apps[0].Contact_Name__r.Office_Phone_Number__c;
                        dedupe.Landline2_Office__c=apps[0].Contact_Name__r.Office_Phone_Number__c;
                        dedupe.Mobile_Office__c=apps[0].Contact_Name__r.Mobile_Phone__c;
                        dedupe.Email_Office__c=apps[0].Contact_Name__r.Office_Email_Id__c;
                        dedupe.Email_Office__c=apps[0].Contact_Name__r.Office_Email_Id__c;
                        dedupe.De_Dupe_Decision__c = 'None';
                       dedupe.De_Dupe_result__c = 'None';
                       if(apps[0].Contact_Name__r.Customer_Type__c == 'Corporate')
                         dedupe.First_Name__c=apps[0].Contact_Name__r.Name;
                       else
                        {                
                             string name1=apps[0].Contact_Name__r.Name;
                             if(name1.contains(' ')){
                             list<string> splitname = name1.split(' ');
                             if(splitname [0]!=null)
                             dedupe.First_Name__c=splitname[0];
                             if(splitname[1]!=null)
                             dedupe.last_Name__c=splitname[1];
                             }
                             
                             dedupe.Middle_Name__c=apps[0].Contact_Name__r.Middle_Name__c;
                        }
                                        
                        dedupe.Datafix_Updated__c='New records';
                        dedupe.Application_Status__c='Complete';
                        if(loan[0].Quality_Check_Status__c == 'Dedupe')
                        dedupe.Application_ID__c = 'Dedupe';
                       insert dedupe;
                       
              
                    
        }
        if(Trigger.Isupdate){
            system.debug('######apps.size'+apps.size());
           if(conList.size()>0){
            system.debug('######IN if');
            system.debug('##########apps[0].Contact_Name__r.PAN_Card_Status__c'+apps[0].Contact_Name__r.PAN_Card_Status__c);
            if(conList[0].PAN_Card_Status__c!=null && conList[0].PAN_Card_Status__c=='Not in ITD Database'){
                system.debug('######IN Pan Verification');
                SOL_Policy__c sp = new SOL_Policy__c();
                sp.Policy_Name__c = 'PAN Not in ITD Database';
                sp.Policy_Status__c='Reject';
                sp.Loan_Application__c=Loan[0].Id;
                sp.Created_From_Applicant__c=True;
               // PolicyList.add(sp);
              }
               
              if(apps[0].Contact_Name__r.PAN_Card_Status__c!=null && apps[0].Contact_Name__r.PAN_Card_Status__c=='Fake PAN'){
                system.debug('######IN Pan Verification');
                SOL_Policy__c sp = new SOL_Policy__c();
                sp.Policy_Name__c = 'Fake PAN';
                sp.Policy_Status__c='Reject';
                sp.Loan_Application__c=Loan[0].Id;
                sp.Created_From_Applicant__c=True;
                PolicyList.add(sp);
              }  
           }
        }
    
    for(Applicant__c App : Trigger.new)
      {
      system.debug('%%%%%%%%%%%%%%%%%%%%Inapplicant');  
      if(App.CIBIL_Score__c!=null){
      if(App.CIBIL_Score__c=='000-1')
      cibil = True;
      else
      CibilScore=Integer.valueof(App.CIBIL_Score__c);
      }
        
      if(Loan.size()>0 && App.Applicant_Type__c=='Primary' && App.CIBIL_Score__c!= null &&(CibilScore>0 && CibilScore<600  ))
      {
                system.debug('%%%%%%%%%%%%%%%%%%%%Primari');
               SOL_Policy__c sp = new SOL_Policy__c();
                sp.Policy_Name__c = 'CIBIL Score';
                system.debug('%%%%%%%%%%%%%%%%%%%%Reject');
                sp.Policy_Status__c='Reject';
                sp.Loan_Application__c=Loan[0].Id;
                sp.Created_From_Applicant__c=True;
                PolicyList.add(sp);
      }
       else if(Loan.size()>0  && App.Applicant_Type__c=='Primary' && App.CIBIL_Score__c!= null &&(CibilScore>=600 && CibilScore<700 ))
      {
               SOL_Policy__c sp = new SOL_Policy__c();
               system.debug('%%%%%%%%%%%%%%%%%%%%Refer');
                sp.Policy_Name__c = 'CIBIL Score';
                sp.Policy_Status__c='Refer';
                sp.Loan_Application__c=Loan[0].Id;
                sp.Created_From_Applicant__c=True;
                PolicyList.add(sp);
      }
      for(integer i=0;i<conList.size();i++){
           if(App.Applicant_Type__c!='Primary' && conList[i].ApplicantType__c =='Co-Applicant'){
            system.debug('%%%%%%%%%%%%%%%%%%%%Primarynot');
             if(Loan.size()>0 && App.CIBIL_Score__c!= null && conList[i].Customer_Type__c=='Individual' && conList[i].ApplicantType__c =='Co-Applicant'&& (CibilScore>0 && CibilScore<600 )){
                   SOL_Policy__c sp = new SOL_Policy__c();
                    sp.Policy_Name__c = 'CIBIL Score';
                    system.debug('%%%%%%%%%%%%%%%%%%%%Reject');
                    sp.Policy_Status__c='Reject';
                    sp.Loan_Application__c=Loan[0].Id;
                    sp.Created_From_Applicant__c=True;
                    PolicyList.add(sp);
            }
             else if(Loan.size()>0 && App.CIBIL_Score__c!= null && conList[i].Customer_Type__c=='Individual' && conList[i].ApplicantType__c=='Co-Applicant'  && (CibilScore>=600 && CibilScore<700 )){
                   SOL_Policy__c sp = new SOL_Policy__c();
                   system.debug('%%%%%%%%%%%%%%%%%%%%Refer');
                    sp.Policy_Name__c = 'CIBIL Score';
                    sp.Policy_Status__c='Refer';
                    sp.Loan_Application__c=Loan[0].Id;
                    sp.Created_From_Applicant__c=True;
                    PolicyList.add(sp);
          }
          
          /*if(Loan.size()>0 && App.CIBIL_Score__c!= null && conList[i].Customer_Type__c=='Individual' && conList[i].ApplicantType__c=='Security Provider'&& (CibilScore<600 || cibil==True)){
                   SOL_Policy__c sp = new SOL_Policy__c();
                    sp.Policy_Name__c = 'CIBIL Score';
                    system.debug('%%%%%%%%%%%%%%%%%%%%Reject');
                    sp.Policy_Status__c='Reject';
                    sp.Loan_Application__c=Loan[0].Id;
                    sp.Created_From_Applicant__c=True;
                    PolicyList.add(sp);
            }
             else if(Loan.size()>0 && App.CIBIL_Score__c!= null && conList[i].Customer_Type__c=='Individual' &&(CibilScore>=600 && conList[i].ApplicantType__c!='Security Provider' && CibilScore<=700 || cibil==True)){
                   SOL_Policy__c sp = new SOL_Policy__c();
                   system.debug('%%%%%%%%%%%%%%%%%%%%Refer');
                    sp.Policy_Name__c = 'CIBIL Score';
                    sp.Policy_Status__c='Refer';
                    sp.Loan_Application__c=Loan[0].Id;
                    sp.Created_From_Applicant__c=True;
                    PolicyList.add(sp);
          }*/
            
          }
      }
       
        
      if(PolicyListUpdate.size()>0)
      Delete PolicyListUpdate;
      if(PolicyList.size()>0)
      Insert PolicyList;
     if(Trigger.Isupdate && App.Cibil_Score__c!=null)
     {
     if(sol.size()>0 && Trigger.oldmap.get(App.id).CIBIL_Score__c !=  Trigger.Newmap.get(App.id).CIBIL_Score__c){
     if(App.Cibil_Score__c=='000-1')
     sol[0].cibil_Score__c=1;
     else
     sol[0].cibil_Score__c = Integer.valueof(App.Cibil_Score__c);
     
     update sol[0];
     }
     }
      }
      
      
     }
}
}