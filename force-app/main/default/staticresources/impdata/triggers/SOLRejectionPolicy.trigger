trigger SOLRejectionPolicy on Salaried__c (after update) {
Date TDay=System.Today();
Date DOB;
Decimal MonthlySal=0;
list<string> citycategory = new list<string>();
List<SOL_Policy__c> PolicyList = new List<SOL_Policy__c>(); 
List<SOL_Policy__c> PolicyListUpdate = new List<SOL_Policy__c>();
list<Demographic_Mapping__c>demolist=new list<Demographic_Mapping__c>();
map<string,boolean> demomap=new map<string,boolean>();
Set<ID>OppID = new Set<ID>();
List<Opportunity> Loan = new List<Opportunity>();
List<SOL_CAM__c> solcam=new List<SOL_CAM__c>();
ID Uid=Userinfo.getUserID();
String lblUserIDS = '';
lblUserIDS = label.DBA_User_ID;
Set<String> usrIds = new Set<String>(); 
  system.debug('lblUserID**********************'+lblUserIDS);
 for(String labelUsrids: lblUserIDS.split(';')){
                usrIds.add(labelUsrids);
   }
     system.debug('Uid**********************'+Uid);
    system.debug('usrIds**********************'+usrIds);
  if(!usrIds.contains(Uid) ){
    if(System.Label.SOL_Online_Flow_Control=='SOLV1'){
    if (!ControlRecursiveCallofTrigger_Util.hasSOLRejectionPolicy()) {
      ControlRecursiveCallofTrigger_Util.setSOLRejectionPolicy();
      for(Salaried__c sal : Trigger.New){    
          system.debug('checksalaloanapplication***************'+sal.Loan_Application__c);
          if(sal.Loan_Application__c!=null){
              OppID.add(sal.Loan_Application__c);
              citycategory.add(sal.City__c);
           }
      }
      system.debug('OppID***************'+OppID);
      system.debug('Loan ***************'+Loan );
      system.debug('city***************'+citycategory);
      
      if(OppID!=null){
          Loan =[select id,Branch_Type1__c,StageName,Reject_Reason__c,Product__c,Branch_Name__r.Branch_Type__c from opportunity where id in: OppID order by createddate DESC limit 1];
          system.debug('Loan ***************'+Loan );
          system.debug('city***************'+citycategory);
          system.debug('OppID***************'+OppID);
          solcam=[select id,EMI_Bounce_In_Last_3_Months__c,Credit_Card_Monthly_Obligation__c from SOL_CAM__c where Loan_Application__c in: OppID];
          system.debug('solcam***************'+solcam);
          demolist=[select id, Special_category__c,City__c from Demographic_Mapping__c where City__c=:citycategory];
      
          for(Demographic_Mapping__c d :demolist)
            demomap.put(d.City__c,d.Special_category__c);
        }
      system.debug('demomap**************'+demomap);
      system.debug('Loan ***************'+Loan );
      system.debug('city***************'+citycategory);
      system.debug('OppID***************'+OppID);
      system.debug('solcam***************'+solcam);
      
      if(Loan.size()>0 && Loan[0].Product__c=='SOL')
      {
      PolicyListUpdate =[Select id,Name from SOL_Policy__c where Created_From_Salaried__c=:True and Loan_Application__c=:Loan[0].Id];
      for(Salaried__c sal : Trigger.New)
      {
         if(trigger.isUpdate)
         if(sal.Telecalling_Disposition__c=='Rejected' && trigger.oldMap.get(sal.id).Telecalling_Disposition__c!='Rejected')
         {
              Loan[0].StageName='Rejected';
              update loan[0];
         }
        if(Loan.size()>0 && Loan[0].Branch_Type1__c=='Tier I' && sal.month1_sal__c!=null && sal.month2_sal__c!=null)
        {
        if(sal.mon1_variable_pay__c==null || sal.mon2_variable_pay__c==null)   
         MonthlySal=(Integer.valueof(sal.month1_sal__c) + Integer.valueof(sal.month2_sal__c))/2;
         else 
          MonthlySal=((Integer.valueof(sal.month1_sal__c)-(Integer.valueof(sal.mon1_variable_pay__c)*0.07)) + (Integer.valueof(sal.month2_sal__c) - (Integer.valueof(sal.mon2_variable_pay__c) *0.07)))/2;
         system.debug('*&*&*&*&*&*&*&*&*&'+MonthlySal);
         system.debug('*&*&*&*&*&*&*&*&*& Tier1'+sal.City__c);
         system.debug('*&*&*&*&*&*&*&*&*& Tier1'+demomap.containsKey(sal.City__c));
         system.debug('*&*&*&*&*&*&*&*&*& Tier1'+demomap);
         system.debug('*&*&*&*&*&*&*&*&*& Tier1'+demomap.get(sal.City__c));
         if(MonthlySal<35000) 
        {
          system.debug('inside reject2******************');
          SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Minimum Salary Norms';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
        }
       else if(((MonthlySal>=35000 && MonthlySal<40000) && demomap.containsKey(sal.City__c) && demomap.get(sal.City__c)!=true))
        {
          system.debug('inside reject1******************');
          SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Minimum Salary Norms';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
        }
      }
        else if(Loan.size()>0 && Loan[0].Branch_Type1__c=='Tier II' && sal.month1_sal__c!=null && sal.month2_sal__c!=null)
        {
         if(sal.mon1_variable_pay__c==null || sal.mon2_variable_pay__c==null)   
         MonthlySal=(Integer.valueof(sal.month1_sal__c) + Integer.valueof(sal.month2_sal__c))/2;
         else 
          MonthlySal=((Integer.valueof(sal.month1_sal__c)-(Integer.valueof(sal.mon1_variable_pay__c)*0.07)) + (Integer.valueof(sal.month2_sal__c) - (Integer.valueof(sal.mon2_variable_pay__c) *0.07)))/2;
         system.debug('*&*&*&*&*&*&*&*&*& TierII'+MonthlySal);
           Decimal expWithCurrentEmployer = Decimal.valueOf(sal.Join_dt_curr_emp_year__c)+(Decimal.valueOf( sal.Join_dt_curr_emp_month__c)/12);
          system.debug('*&*&*&*&*&*&*&*&*&'+expWithCurrentEmployer);
          system.debug('*&*&*&*&*&*&*&*&*&'+MonthlySal);
        if(MonthlySal<30000 )
        {
          SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Minimum Salary Norms';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
        }
        else if(MonthlySal>=30000 && MonthlySal<35000 && expWithCurrentEmployer < 2.0 )
        {
          SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Minimum Salary Norms';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
        }     
       }
       if(Loan.size()>0)
       {
          if(sal.Date_Of_Birth__c!=null){
          DOB = sal.Date_Of_Birth__c;
          Integer DateDif= DOB.monthsBetween(TDay)/12;
          Decimal DateDif1= DOB.daysBetween(TDay)/365.2425;
          if(Loan.size()>0 && DateDif1<25.00)
          {
          SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Minimum Age';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
          }
           if(Loan.size()>0 && DateDif>55)
          {
          SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Age at Loan Maturity';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
          }
         }
      system.debug('****Total work experience***:'+sal.Total_Employment_vintage_Year__c+' | '+sal.Total_Employment_vintage_Month__c);
      system.debug('****Exp with current exmployer ***:'+sal.Join_dt_curr_emp_year__c+' | '+sal.Join_dt_curr_emp_month__c);
      system.debug('****Employer*****:'+sal.Employer__c+sal.Total_Employment_vintage_Year__c+' -month1 sal:'+sal.month1_sal__c+' -month2 sal:'+sal.month2_sal__c);
      system.debug('****variable pay****:'+sal.mon1_variable_pay__c+' | '+sal.mon2_variable_pay__c); 
        
        if(sal.month1_sal__c !=null && sal.month2_sal__c !=null)
        {
        Decimal smaller = math.min(Decimal.valueof(sal.month1_sal__c),Decimal.valueof(sal.month2_sal__c));
        Decimal s = smaller*.2;
        Decimal Diff = Decimal.valueof(sal.month1_sal__c) - Decimal.valueof(sal.month2_sal__c);
        Decimal ss = math.abs(Diff);
        if(ss>=s && (sal.mon1_variable_pay__c== null || Decimal.valueof(sal.mon1_variable_pay__c)==0) &&(sal.mon2_variable_pay__c==null || Decimal.valueof(sal.mon2_variable_pay__c)==0))
        {
        SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Net Salary (Variable Salary)';
          sp.Policy_Status__c='Refer';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
        }
       }
       
       /*if(sal.Residence_Type__c!=null && sal.Join_dt_curr_emp_year__c!='YY' && sal.Join_dt_curr_emp_month__c!='MM' && sal.Residence_Type__c!='Owned by Self/Spouse' && sal.Residence_Type__c!='Owned by Parents' && Integer.valueof(sal.Join_dt_curr_emp_month__c)<6 && Integer.valueof(sal.Join_dt_curr_emp_year__c)==0)
       {
       SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Current employment less than 6 and Residence not owned';
          sp.Policy_Status__c='Refer';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
       }*/
       
        if(sal.Residence_Type__c!=null && (sal.Residence_Type__c=='Rented-Staying Alone' || sal.Residence_Type__c=='Rented-with friends' || sal.Residence_Type__c=='Paying Guest' || sal.Residence_Type__c=='Hostel'))
        {
          SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Residence Type';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
        }
        if(sal.Total_Employment_vintage_Year__c!=null && sal.Total_Employment_vintage_Year__c!='YY' && (Integer.valueof(sal.Total_Employment_vintage_Year__c)<3))
        {
        SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Total Work Experience';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
        }
        if(sal.Mode_of_crediting_salary__c!=null && (sal.Mode_of_crediting_salary__c=='Cash' || sal.Mode_of_crediting_salary__c=='Cheque'))
        {
        SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Salary in Cash / Cheque';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
        }
        
       if(sal.EMI_bounce__c!=null && (sal.EMI_bounce__c=='Yes'))
       {
         SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'EMI Bounce In Last 3 Months';
          sp.Policy_Status__c='Rejected';
          
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          if(solcam.size()>0){    
          solcam[0].EMI_Bounce_In_Last_3_Months__c=true;
          update solcam; 
           }  
          PolicyList.add(sp);
       }
       
        if(sal.EMI_bounce__c!=null && (sal.EMI_bounce__c=='No'))
       {
         if(solcam.size()>0){
          solcam[0].EMI_Bounce_In_Last_3_Months__c=true;
          update solcam;    
         // PolicyList.add(sp);
           }   
       }
      /*Note :Since we have removed the Credit card field from the VF 
               page ,so we are not consedireng  Credit card poly over here from the belwo if condition -Done changes on 25-April-2014*/
               if(sal.Total_Monthly_Obligations__c!=null && sal.Total_Monthly_Obligations__c==0)
               {
                SOL_Policy__c sp = new SOL_Policy__c();
                  sp.Policy_Name__c = 'Monthly Obligation';
                  sp.Policy_Status__c='Rejected';
                  sp.Loan_Application__c=Loan[0].id;
                  sp.Created_From_Salaried__c=True;
                      if(solcam.size()>0){    
                   solcam[0].Credit_Card_Monthly_Obligation__c =true;
                   update solcam;    
                      }     
                  PolicyList.add(sp);
               }
               /*Note :Since we have removed the Credit card field from the VF 
               page ,so we are not consedireng  Credit card poly over here from the belwo if condition -Done changes on 25-April-2014*/
               if(sal.Total_Monthly_Obligations__c!=null && sal.Total_Monthly_Obligations__c!=0)
               {
                     if(solcam.size()>0){ 
                   solcam[0].Credit_Card_Monthly_Obligation__c =true;
                   update solcam;    
                //  PolicyList.add(sp);
                     }
               }
       if(sal.Employer__c==label.EmployerOthers || sal.Employer__c==label.EmployerNotListed)
       {
        SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Employer Others / Not Listed';
          sp.Policy_Status__c='Refer';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          Loan[0].stagename='Refer';
          update Loan[0];
          PolicyList.add(sp);
       }
         if(sal.Total_Employment_vintage_Year__c!='YY' && Integer.valueof(sal.Total_Employment_vintage_Year__c)<3)
         {
          SOL_Policy__c sp = new SOL_Policy__c();
          sp.Policy_Name__c = 'Total Employment Vintage Lesser than 3 Years';
          sp.Policy_Status__c='Rejected';
          sp.Loan_Application__c=Loan[0].id;
          sp.Created_From_Salaried__c=True;
          PolicyList.add(sp);
         }
        }  
       if(Trigger.Isupdate && Trigger.oldmap.get(sal.id).Percentage_Completion__c != Trigger.Newmap.get(sal.id).Percentage_Completion__c && sal.Percentage_Completion__c=='60')
       {
       String sms =sal.Cust_Reference_No__c+' is your Reference Number to access, review, complete, submit and track your application and for all queries and clarifications. Thank you, Bajaj Finserv Lending';
       List<String> toAdd = new List<String>();
       toAdd.add(sal.Office_Email_ID__c);
       String Sub =  'Application Reference Number for Personal Loan';
       String Body = '<table border=\\"1\\"><tr><th><b>Application Reference Number</b></th></tr><tr><td><center>'+sal.Cust_Reference_No__c+'</center></td></tr></table><br></br>Dear '+sal.First_Name__c+'<br></br>Thank you for completing the Personal Details section in the online application form.<br></br>Your Application Reference Number is '+sal.Cust_Reference_No__c+'<br></br>You can use this number to access, review, complete, submit and track the status of your Personal Loan online application.<br></br>For any query or clarification that you may need, please call us on 18001033535 or write to us at personalloans@bajajfinserv.in quoting this reference number.<br></br>Sincerely,<br></br>Bajaj Finserv Lending<br></br>This is a system generated alert and does not require a signature. We request you not to reply to this message. This e-mail is confidential and may also be privileged. Please do not copy or use it for any purpose, nor disclose its contents to any other person. If you are not the intended recipient, please notify us, or write in with your queries, at wecare@bajajfinserv.in';
       SOLsendEmail.LogixEmail(toAdd,Sub,Body);
       sendsms.message(sal.Mobile__c,sms);
       }
      }
       if(PolicyListUpdate.size()>0)
        Delete PolicyListUpdate;
       if(PolicyList.size()>0)
       {
       Insert PolicyList;
       }
       }
    } 
    }
  }//End of DBA user 
}