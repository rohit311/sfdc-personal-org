trigger LASOLRejectionPolicy on Salaried__c (after update) {
Date TDay=System.Today();
Date DOB;
Date DOI;
decimal i=0;
decimal j=0;
decimal k=0;
decimal m=0;
//integer datedif1;
Decimal DateDif;
string ITRvalue;
contact con = new contact();
List<string> splitstring= new List<string>();
Decimal MonthlySal=0;
list<string> citycategory = new list<string>();
List<SOL_Policy__c> PolicyList = new List<SOL_Policy__c>(); 
List<SOL_Policy__c> PolicyListUpdate = new List<SOL_Policy__c>();
list<Demographic_Mapping__c>demolist=new list<Demographic_Mapping__c>();
map<string,boolean> demomap=new map<string,boolean>();
Set<ID>OppID = new Set<ID>();
List<Opportunity> Loan = new List<Opportunity>();
List<SOL_CAM__c> solcam=new List<SOL_CAM__c>();
//if (!ControlRecursiveCallofTrigger_Util.hasLASOLRejectionPolicy()) {
//ControlRecursiveCallofTrigger_Util.setLASOLRejectionPolicy();
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
		if(!usrIds.contains(Uid)){ 
				for(Salaried__c sal : Trigger.New)
				{
				system.debug('sal.Loan_Application__c***************'+sal.Loan_Application__c);
				OppID.add(sal.Loan_Application__c);
				system.debug('OppID***************'+OppID);
				citycategory.add(sal.City__c);
				}
				Loan =[select id,Branch_Type1__c,StageName,Reject_Reason__c,Product__c,Branch_Name__r.Branch_Type__c from opportunity where id in: OppID order by createddate DESC limit 1];
				system.debug('Loan***************'+Loan);
				//List<Applicant__c> Applicants = [select id,Loan_Application_Number__c,Name,Contact_Name__c,applicant_type__c from Applicant__c where Loan_Application__c in: OppID and applicant_type__c='Primary' ];
				//system.debug('**********Applicants '+Applicants );
				//system.debug('city***************'+citycategory);
				//solcam=[select id,EMI_Bounce_In_Last_3_Months__c,Credit_Card_Monthly_Obligation__c from SOL_CAM__c where Loan_Application__c in: OppID];
				//demolist=[select id, Special_category__c,City__c from Demographic_Mapping__c where City__c=:citycategory];
				//for(Demographic_Mapping__c d :demolist)
				  //  demomap.put(d.City__c,d.Special_category__c);
				system.debug('demomap**************'+demomap);
				    system.debug('Loan.size()***********'+Loan.size());
				    // system.debug('Loan[0].Product__c*********'+Loan[0].Product__c);
				      if(Loan.size()>0 ){
				      
				      if(Loan[0].Product__c =='LASOL'){
				        system.debug('***********NewProduct');  
				        PolicyListUpdate =[Select id,Name from SOL_Policy__c where Created_From_Salaried__c=:True and Loan_Application__c=:Loan[0].Id]; //SOL_Policy__c
				        
				        for(Salaried__c sal : Trigger.New){ 
				         if(trigger.isUpdate)
				             if(Loan.size()>0){
				                if(sal.Date_Of_Birth__c!=null){ //Age Check Condition
				                
				               
				                    DOB = sal.Date_Of_Birth__c;
				                    //integer temp;
				                   // integer age= year.valueOf(system.Today());
				                    //-year(DOB)-temp;
				                    //=(if(OR(MONTH(TDay) < MONTH(DOB),AND(MONTH(TDay) == MONTH(DOB),DAY(TDay) < DAY(DOB))), 1,0));
				                    
				                   /* if(MONTH(TDay) < MONTH(DOB) || ( (MONTH(TDay) == MONTH(DOB)) && (DAY(TDay) < DAY(DOB)) ))
				                    {
				                    temp = 1;
				                    }
				                    else
				                    {
				                    temp=0;
				                    }*/
				                    
				                    system.debug('***********DOB'+DOB);
				                    DateDif= DOB.monthsBetween(TDay)/12;
				                   // datedif1=FLOOR(datedif);
				                    //system.debug('***********monthsBetween'+monthsBetween(TDay)/12);
				                    system.debug('**************DateDif'+DateDif);
				                    Decimal DateDif1= DOB.daysBetween(TDay)/365.2425;
				                    
				                    system.debug('**************DateDif1'+DateDif1);
				                    
				                    if(Loan.size()>0 && sal.Age_Round_Down__c<25.00){ //Age Check Condition
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'Minimum Age';
				                        system.debug('***********less ageRejected');
				                        sp.Policy_Status__c='Reject';
				                        sp.Loan_Application__c=Loan[0].id;
				                       // sp.Applicant_Name__c = Applicants[0].id;
				                        sp.Created_From_Salaried__c=True;
				                        PolicyList.add(sp);
				                    }
				                     if(Loan.size()>0 && sal.Age_Round_Down__c>=64.00){ //Age Check Condition
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'Age at Loan Maturity';
				                        sp.Policy_Status__c='Refer';
				                        system.debug('***********More age Referer');
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;
				                        PolicyList.add(sp);
				                    }
				               }
				               
				               if(sal.Date_of_Incorporation__c!=null){ //Existence Condition
				                    DOI = sal.Date_of_Incorporation__c;
				                    system.debug('***********DOB'+DOI);
				                    DateDif= DOI.monthsBetween(TDay)/12;
				                    system.debug('**************DateDif'+DateDif);
				                    Decimal DateDif1= DOI.daysBetween(TDay)/365.2425;
				                    system.debug('**************DateDif1'+DateDif1);
				                    
				                    if(Loan.size()>0 && sal.Round_Down_Age_of_Company__c<3.00){ 
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'Years of Existence<3';
				                        system.debug('***********Years of Existence<3 ageRejected');
				                        sp.Policy_Status__c='Reject';
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;
				                        PolicyList.add(sp);
				                    }
				                    
				               }
				               if(sal.Employment_Type__c!=null){ //Negetive Profile check
				                    /*if(Loan.size()>0 && sal.Employment_Type__c == 'Politician'){
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'Negetive Profile :Politician';
				                        sp.Policy_Status__c='Reject';
				                        system.debug('***********Politician reject');
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;//question to jaipal
				                        PolicyList.add(sp);
				                        
				                    }*/
				                    if(Loan.size()>0 && sal.Employment_Type__c == 'Professional'&& sal.Professional_Sub_Type__c == 'Advocate'){
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'Negetive Profile ';
				                        sp.Policy_Status__c='Reject';
				                        system.debug('***********Advocate reject');
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;//question to jaipal
				                        PolicyList.add(sp);
				                        
				                    }
				                    
				               }
				               if(sal.Nature_of_Business__c!=null){ //Nature_of_Business__c check
				                    if(Loan.size()>0 && sal.Nature_of_Business__c == 'Stock Broker'){
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'Nature of Business ';
				                        sp.Policy_Status__c='Reject';
				                        system.debug('***********Politician reject');
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;//question to jaipal
				                        PolicyList.add(sp);
				                        
				                    }
				                    
				               }
				                if(sal.Entity_Type__c!=null){//Check Entity Type
				                    if(Loan.size()>0 && (sal.Entity_Type__c == 'HUF' || sal.Entity_Type__c == 'Partnership')){
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'HUF & PartenrShip Entity';
				                        sp.Policy_Status__c='Reject';
				                        system.debug('***********HUF & PartenrShip Entity reject');
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;
				                        PolicyList.add(sp);
				                        
				                    }
				                    
				                }
				               if(sal.Securities_in_DEMAT__c!=null){//Check Securites are not in dematerialized form
				                    if(Loan.size()>0 && sal.Securities_in_DEMAT__c == 'No'){
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'Securites are not in dematerialized form';
				                        sp.Policy_Status__c='Reject';
				                        system.debug('Securites are not in dematerialized form');
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;
				                        PolicyList.add(sp);
				                        
				                    }
				                    
				               }
				               if(sal.ITR_Filed__c!=null){//Check ITR Not Filed
				                    if(Loan.size()>0 && (sal.ITR_Filed__c== 'Not filed' || sal.ITR_Filed__c== 'FY 2009- 10')){
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'ITR Not Filed';
				                        sp.Policy_Status__c='Reject';
				                        system.debug('*************ITR Not Filed');
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;
				                        PolicyList.add(sp);
				                        
				                    }
				                    
				               }
				                   system.debug('@@@@@@@@@@@@ in investment' + sal.Equity_Shares__c + '---' +sal.Mutual_Funds__c);
				               if(sal.Equity_Shares__c!=null || sal.Mutual_Funds__c!=null){//Check Investment details
				             system.debug('@@@@@@@@@@@@ in investment' + sal.Equity_Shares__c + '---' +sal.Mutual_Funds__c);
				              if(sal.Equity_Shares__c == 'Less than 3 Lacs' && sal.Mutual_Funds__c == 'Less than 3 Lacs'){
				                i=3;  // (0+3)/2  + (0+3)/2 = 3 ---- this is the pattern followed by all..we are adding medians of both.
				              }
				              else if(sal.Equity_Shares__c == 'Less than 3 Lacs' && sal.Mutual_Funds__c == 'Greater than 3 Lacs and less than 6 Lacs'){
				                i=6;  // (0+3)/2  + (3+6)/2 = 6
				              }
				              else if(sal.Equity_Shares__c == 'Less than 3 Lacs' && sal.Mutual_Funds__c == 'Greater than 6 Lacs and less than 9 Lacs'){
				                i=9;  
				              }
				              else if(sal.Equity_Shares__c == 'Less than 3 Lacs' && sal.Mutual_Funds__c == 'Greater than 9 Lacs'){
				                i=10.5;  
				              }else{ 
				                        i=0;  
				                   }
				              
				              
				              if(sal.Equity_Shares__c == 'Greater than 3 Lacs and less than 6 Lacs' && sal.Mutual_Funds__c == 'Less than 3 Lacs'){
				                 j=6;  
				                   }
				              else if(sal.Equity_Shares__c == 'Greater than 3 Lacs and less than 6 Lacs' && sal.Mutual_Funds__c == 'Greater than 3 Lacs and less than 6 Lacs'){
				                 j=9;  
				                   }
				              else if(sal.Equity_Shares__c == 'Greater than 3 Lacs and less than 6 Lacs' && sal.Mutual_Funds__c == 'Greater than 6 Lacs and less than 9 Lacs'){
				                 j=12;  
				                   }
				              else if(sal.Equity_Shares__c == 'Greater than 3 Lacs and less than 6 Lacs' && sal.Mutual_Funds__c == 'Greater than 9 Lacs'){
				                 j=13.5;  
				              }else{ 
				                         j = 0;
				                   }
				              
				                system.debug('#########in elseeeef#');
				              if(sal.Equity_Shares__c == 'Greater than 6 Lacs and less than 9 Lacs' && sal.Mutual_Funds__c == 'Less than 3 Lacs'){
				                 m=9;  
				              }
				              else if(sal.Equity_Shares__c == 'Greater than 6 Lacs and less than 9 Lacs' && sal.Mutual_Funds__c == 'Greater than 3 Lacs and less than 6 Lacs'){
				                 m=12;  
				              }
				              else if(sal.Equity_Shares__c == 'Greater than 6 Lacs and less than 9 Lacs' && sal.Mutual_Funds__c == 'Greater than 6 Lacs and less than 9 Lacs'){
				                 m=15;  
				              }
				              else if(sal.Equity_Shares__c == 'Greater than 6 Lacs and less than 9 Lacs' && sal.Mutual_Funds__c == 'Greater than 9 Lacs'){
				                 m=16.5;  
				              }else{ 
				                 m=0;
				              }
				            
				            
				              if(sal.Equity_Shares__c == 'Greater than 9 Lacs' && sal.Mutual_Funds__c == 'Less than 3 Lacs'){
				                  k=10.5;  
				              }
				              else if(sal.Equity_Shares__c == 'Greater than 9 Lacs' && sal.Mutual_Funds__c == 'Greater than 3 Lacs and less than 6 Lacs'){
				                  k=13.5;  
				                   }
				              else if(sal.Equity_Shares__c == 'Greater than 9 Lacs' && sal.Mutual_Funds__c == 'Greater than 6 Lacs and less than 9 Lacs'){
				                  k=16.5;  
				              }
				              else if(sal.Equity_Shares__c == 'Greater than 9 Lacs' && sal.Mutual_Funds__c == 'Greater than 9 Lacs'){
				                  k=18;  
				              }
				              else{ 
				                          k = 0;
				                   }
				              
				            system.debug('##########'+i+j+k+m);
				              
				              if(sal.Equity_Shares__c !=null && (sal.Mutual_Funds__c==null || sal.Mutual_Funds__c == 'Select Investment Value*')){
				                system.debug('#########in if#');
				                if(sal.Equity_Shares__c == 'Less than 3 Lacs'){
				                  i=1.5;  
				                }
				                else if(sal.Equity_Shares__c == 'Greater than 3 Lacs and less than 6 Lacs'){
				                  j=4.5; 
				                }
				                else if(sal.Equity_Shares__c == 'Greater than 6 Lacs and less than 9 Lacs'){
				                  m=7.5;  
				                }
				                else if(sal.Equity_Shares__c == 'Greater than 9 Lacs'){
				                  k=9;  
				                }else{ 
				                  i=0;j=0; m=0;k=0;
				                }
				                }  
				            system.debug('##########'+i+j+k+m);
				                if(sal.Mutual_Funds__c !=null && (sal.Equity_Shares__c==null || sal.Equity_Shares__c == 'Select Investment Value*')){
				                  system.debug('#########in if funds#');
				                if(sal.Mutual_Funds__c == 'Less than 3 Lacs'){
				                  i=1.5;  
				                }
				                else if(sal.Mutual_Funds__c == 'Greater than 3 Lacs and less than 6 Lacs'){
				                  j=4.5; 
				                }
				                else if(sal.Mutual_Funds__c == 'Greater than 6 Lacs and less than 9 Lacs'){
				                  m=7.5;  
				                }
				                else if(sal.Mutual_Funds__c == 'Greater than 9 Lacs'){
				                    system.debug('#########in igreater 9#');
				                  k=9;  
				                    system.debug('#########in igreater #'+k);
				                }else{ 
				                   system.debug('#########in igreaterelse   #'+k);
				                  i=0;j=0; m=0;k=0;
				                }
				                
				                  system.debug('#########in #'+k);
				                
				                }
				                system.debug('##########'+i+j+k+m);
				              decimal total = i+j+k+m; 
				              
				              system.debug('########## Loan.size() : '+Loan.size());
				              system.debug('########## total : '+ total);
				              
				              if(Loan.size()>0 && total < 8 ){ 
				                        SOL_Policy__c sp = new SOL_Policy__c();
				                        sp.Policy_Name__c = 'Investment Not Matched';
				                        sp.Policy_Status__c='Reject';
				                        system.debug('*************Investment Not Machehed');
				                        sp.Loan_Application__c=Loan[0].id;
				                        sp.Created_From_Salaried__c=True;
				                        PolicyList.add(sp);
				                        
				                    }
				            } 
				                    
				               
				             }  
				        } 
				         /*if(trigger.isUpdate)
				            for(Applicant__c aa:Applicants ){ 
				                system.debug('***********Co---apppp');
				                 if(aa.applicant_type__c=='Co-Applicant'){
				                 system.debug('***********Co---apppp');
				                  system.debug('***********DOB'+con.Date_Of_Birth__c);
				                 if(con.Date_Of_Birth__c!=null){ //Age Check Condition
				                      system.debug('***********DOB'+con.Date_Of_Birth__c);
				                    DOB = con.Date_Of_Birth__c;
				                    system.debug('***********DOB'+DOB);
				                    DateDif= DOB.monthsBetween(TDay)/12;
				                    system.debug('**************DateDif'+DateDif);
				                    Decimal DateDif1= DOB.daysBetween(TDay)/365.2425;
				                    system.debug('**************DateDif1'+DateDif1);
				                 }   
				                  if(Applicants .size()>0 && DateDif<25.00){ //Age Check Condition
				                            SOL_Policy__c sp = new SOL_Policy__c();
				                            sp.Policy_Name__c = 'Minimum Age';
				                            system.debug('***********less ageRejected');
				                            sp.Policy_Status__c='Reject';
				                            sp.Loan_Application__c=Loan[0].id;
				                            sp.Created_From_Salaried__c=True;
				                            PolicyList.add(sp);
				                        }
				                 
				                 break;
				                 }
				            
				            }*/
				           // if(Trigger.Isupdate && Trigger.oldmap.get(sal.id).Percentage_Completion__c != Trigger.Newmap.get(sal.id).Percentage_Completion__c && sal.Percentage_Completion__c=='60'){
				             //String sms =sal.Cust_Reference_No__c+' is your Mobile Verification Code. Pl use this in the online application .'+sal.Cust_Reference_No__c+' is your Reference Number Thank you, Bajaj Finserv Lending.';
				            // List<String> toAdd = new List<String>();
				             //toAdd.add(sal.Office_Email_ID__c);
				             //String Sub =  'Application Reference Number for Personal Loan';
				            // String Body = '<table border="1"><tr><th><b>Application Reference Number</b></th></tr><tr><td><center>'+sal.Cust_Reference_No__c+'</center></td></tr></table><br></br>Dear '+sal.First_Name__c+'<br></br>Thank you for completing the Personal Details section in the online application form.<br></br>Your Application Reference Number is '+sal.Cust_Reference_No__c+'<br></br>You can use this number to access, review, complete, submit and track the status of your Personal Loan online application.<br></br>For any query or clarification that you may need, please call us on 18001033535 or write to us at personalloans@bajajfinserv.in quoting this reference number.<br></br>Sincerely,<br></br>Bajaj Finserv Lending<br></br>This is a system generated alert and does not require a signature. We request you not to reply to this message. This e-mail is confidential and may also be privileged. Please do not copy or use it for any purpose, nor disclose its contents to any other person. If you are not the intended recipient, please notify us, or write in with your queries, at wecare@bajajfinserv.in';
				             //SOLsendEmail.LogixEmail(toAdd,Sub,Body);
				             //sendsms.message(sal.Mobile__c,sms);
				             //}
				     
				         
				         if(PolicyListUpdate.size()>0){
				            Delete PolicyListUpdate;    
				         }
				         if(PolicyList.size()>0){
				            Insert PolicyList;
				         }  
				        } 
				        //loan check condection         
				    }
				    
			 }
				//}
          }