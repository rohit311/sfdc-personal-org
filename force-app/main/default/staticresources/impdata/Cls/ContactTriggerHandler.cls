public class ContactTriggerHandler{ 
  list<Applicant__c> applist = new list<Applicant__c>();
    List<SOL_Policy__c> PolicyList = new List<SOL_Policy__c>(); 
    List<SOL_Policy__c> PolicyListUpdate = new List<SOL_Policy__c>();
    Date DOB;
    Date DOI;
    Integer DateDif;
  Date TDay = System.Today();
    set<id> contid = new set<id>();
    List<Contact> conOldList;

  List<Contact> contactList;
  Map<id,Contact> contmap=new Map<id,Contact>();
 
  public ContactTriggerHandler(List<Contact> conList,List<Contact> conOldList) {
    contactList = conList;
    this.conOldList = conOldList;

      for (Contact c : contactList){
       if(c.id != null){ //optimized by harsit garg---- added null check to decrease query count
      contid.add(c.id);
      contmap.put(c.id,c);
      }
    } 
 //Bug 22141 added cibil inner query
    if(contid.size() > 0){
        applist=[select Id,Contact_Name__c,Contact_Mobile__c,name_company__c,name_dob_city__c,ContactName__c,Contact_Name__r.Customer_Type__c, Contact_Name__r.Date_of_Birth__c,Contact_Name__r.Total_Work_Experience_Yrs__c,
                 Acct_cont_Mobile__c,Contact_Name__r.Residence_City__c,PAN_Number__c, Contact_Name__r.Name_of_the_company_Employer__c,Loan_Application__c,
                 Contact_Name__r.Employer__c,Loan_Application__r.Product__c,Loan_Application_Number__c,Mob_DOB__c,Pin_DOB__c,landline__c,Contact_Name__r.Bank_Account_No__c,Applicant_Type__c,Loan_Application__r.Repayment_Bank_Name__c,
                 (select id,CIBIL_Fired_time__c from cibils__r limit 1)
                 from Applicant__c where Contact_Name__c != null AND Contact_Name__c IN : contid limit 50000];
    }     
       
       
   //    System.debug('contids are'+contid);
       
       //addhealth();
  }
  
  public void checkMCP() {
  
  if(applist.size()>0 && applist[0].Loan_Application__r.Product__c =='LASOL'){
    for (Contact c : contactList){
    if(c.ApplicantType__c!='Primary' && applist.size()>0){
            system.debug('***********coooooo');
            if(c.Age_Round_Down__c!=null){ //Age Check Condition
                    system.debug('***********DOB'+c.Date_Of_Birth__c);
                    DOB = c.Date_Of_Birth__c;
                    system.debug('***********DOB'+DOB);
                    DateDif= DOB.monthsBetween(TDay)/12;
                    system.debug('**************DateDif'+DateDif);
                    Decimal DateDif1= DOB.daysBetween(TDay)/365.2425;
                    system.debug('**************DateDif1'+DateDif1);
                 }   
                  if(c.Age_Round_Down__c<25){ //Age Check Condition
                            SOL_Policy__c sp = new SOL_Policy__c();
                            sp.Policy_Name__c = 'Minimum Age';
                            system.debug('***********less ageRejected');
                            sp.Policy_Status__c='Reject';
                            sp.Loan_Application__c=applist[0].Loan_Application__c;
                            sp.Applicant_Name__c = applist[0].id;
                            sp.Created_From_Contact__c=True;
                            PolicyList.add(sp);
                 }
                 if(DateDif>=64 && c.ApplicantType__c=='Co-Applicant'){ //Age Check Condition
                            SOL_Policy__c sp = new SOL_Policy__c();
                            sp.Policy_Name__c = 'Co-Applicant Matuirty Date <65 ';
                            system.debug('***********less ageRejected');
                            sp.Policy_Status__c='Refer';
                            sp.Loan_Application__c=applist[0].Loan_Application__c;
                            sp.Applicant_Name__c = applist[0].id;
                            sp.Created_From_Contact__c=True;
                            PolicyList.add(sp);
                 }
                 if(DateDif>=72 && c.ApplicantType__c=='Security Provider'){ //Age Check Condition
                            SOL_Policy__c sp = new SOL_Policy__c();
                            sp.Policy_Name__c = 'Security Provider Matuirty Date <73 ';
                            system.debug('***********less ageRejected');
                            sp.Policy_Status__c='Refer';
                            sp.Loan_Application__c=applist[0].Loan_Application__c;
                            sp.Applicant_Name__c = applist[0].id;
                            sp.Created_From_Contact__c=True;
                            PolicyList.add(sp);
                 }
                 if(c.Year_of_Incorporation__c!=null){ //Existence Condition
                    DOI = c.Year_of_Incorporation__c;
                    system.debug('***********DOB'+DOI);
                     DateDif= DOI.monthsBetween(TDay)/12;
                    system.debug('**************DateDif'+DateDif);
                    Decimal DateDif1= DOI.daysBetween(TDay)/365.2425;
                    system.debug('**************DateDif1'+DateDif1);
                    
                    if(c.Round_Down_Age_of_Company__c<3.00 && c.ApplicantType__c=='Co-Applicant'){ 
                        SOL_Policy__c sp = new SOL_Policy__c();
                        sp.Policy_Name__c = 'Years of Existence<3';
                        system.debug('***********Years of Existence<3 ageRejected');
                        sp.Policy_Status__c='Reject';
                        sp.Loan_Application__c=applist[0].Loan_Application__c;
                        sp.Applicant_Name__c = applist[0].id;
                        sp.Created_From_Contact__c=True;
                        PolicyList.add(sp);
                    }
                    
               }
               if(c.Type_Of_Constitution__c!=null){//Check Entity Type
                    if( c.Type_Of_Constitution__c == 'HUF' || c.Type_Of_Constitution__c == 'Partnership'){
                        SOL_Policy__c sp = new SOL_Policy__c();
                        sp.Policy_Name__c = 'HUF & PartenrShip Entity';
                        sp.Policy_Status__c='Reject';
                        system.debug('***********HUF & PartenrShip Entity reject');
                        sp.Loan_Application__c=applist[0].Loan_Application__c;
                        sp.Applicant_Name__c = applist[0].id;
                        sp.Created_From_Contact__c=True;
                        PolicyList.add(sp);
                        
                    }
                    
                }
                 
        }
        
    }
     if(PolicyListUpdate.size()>0){
                Delete PolicyListUpdate;
                
     
    }
     if(PolicyList.size()>0){
                    
      system.debug(PolicyList+'qqqqqqqqqqqqqq');                   
       upsert PolicyList;
    
    }
 }
  }    
        
    public void copyMobile(){
  
    for (Contact cont : contactList){  
      if(cont.Mobile__c !=null){
        Decimal mob1=cont.Mobile__c; 
        Long mob2=mob1.round();
        String transformed=String.valueof(mob2);
        
        //converting the data type of mobile
        cont.Mobile_Phone__c=transformed;
      }   
      
      if(cont.Customer_Type__c=='Non Individual'){
        cont.Date_of_Birth__c=cont.Year_of_Incorporation__c;
      }
    }  
  }
  
  public void DNCReport(boolean isupdate, boolean isinsert, Map<id,Contact> oldmap, Map<id,Contact> newmap) {
    /* Variables For Fraud Dedupe Starts */ 
    List<String> PANno = new List<String>();
    List<String>VoterID = new List<String>();
    List<String>Mobile = new List<String>();
    List<String>Name = new List<String>();
    List<String>CompDOM = new List<String>();
    List<String>Passportno = new List<String>();
    List<String> NameAdd = new List<String>();
    List<String>Email = new List<String>();
    List<String>NameDaOB = new List<String>();
    List<ID> ConID = new List<ID>();
    List<ID> AppsID = new List<ID>();
    List<String>NaCompPin = new List<String>();
    List<String>DrivingL = new List<String>();
    List<String> AddoPin = new List<String>();
    List<Fraud_Match__c> frdMatch = new List<Fraud_Match__c>();
    List<Fraud_Database__c> FradData = new List<Fraud_Database__c>();
    
    //------------------------------------------------------------------------------------
      // requirement under kalyan (28.07.12 3pm)
      // this process will start only at the time : atleast on null value in 5 field
      // process for name address in fraud database
      list<string> nameAddProlst=new list<string>();
      string finalStir;
      List<string> pFirstname=new List<string>();
      string nAddchecker;
      integer totalmatches=0;
      integer totalNaddLength=0;
      boolean ifoundMatch=false;
      id FDid;
      List<Fraud_Database__c> fnFradDb=new List<Fraud_Database__c>();
      List<Fraud_Database__c> finalFDfound=new List<Fraud_Database__c>();
    //------------------------------------------------------------------------------------
    /* Variables For Fraud Dedupe Ends */ 
    
    set<id>appid=new set<id>();
    List<id>loanid= new List<id>();
   
//if (!ControlRecursiveCallofTrigger_Util.hasDNCFlag()) {
//   ControlRecursiveCallofTrigger_Util.setDNCFlag();
     
        
    system.debug('*&*&*&*&*&*&'+applist);
    
    for(Applicant__c a:applist)
    {
      appid.add(a.id);
      AppsID.add(a.id);
      loanid.add(a.Loan_Application__c);
    }  

  
    /* Fraud Dedupe Logic Starts */ 
  
    for(Contact c : contactList)
    {   
      ConID.add(c.Id); 
      if(c.PAN_Number__c!=null)
      PANno.add(c.PAN_Number__c);
      if(c.VoterID_Number__c!=null)
      VoterID.add(c.VoterID_Number__c);
      if(c.Mobile_Phone__c!=null)
      Mobile.add(c.Mobile_Phone__c);
      if(c.Name!=null)
      Name.add(c.Name);
      if(c.PassPort_Number__c!=null)
      Passportno.add(c.PassPort_Number__c);
      if(c.Driving_License_Number__c!=null)
      DrivingL.add(c.Driving_License_Number__c);
      system.debug('FFFFFFFFFFFF'+c.id+c);
      
        if(c.Address_1__c !=null){
          if(c.Address_2__c !=null){
            if(c.Address_3__c !=null){
              
              if(c.Pin_Code__c !=null){  
              String AddPin = String.valueof(c.Address_1__c)+String.valueof(c.Address_2__c)+String.valueof(c.Address_3__c)+String.valueof(c.Pin_Code__c);
              AddoPin.add(AddPin);
              system.debug('Address+Pin'+AddPin);
              }
              
              if(c.LastName !=null){
              if(c.FirstName !=null){
                String NameAddo = String.valueof(c.FirstName)+String.valueof(c.LastName)+String.valueof(c.Address_1__c)+String.valueof(c.Address_2__c)+String.valueof(c.Address_3__c);
                NameAdd.add(NameAddo);
                system.debug('Name + Address'+NameAddo);
                
                
              }
              }      
            }
          }
        }

        if(c.LastName != null && c.LastName != ' '){
          nameAddProlst.add(c.LastName);
          totalNaddLength=totalNaddLength+1;
        }

        if(c.FirstName != null && c.FirstName != ' '){
          nameAddProlst.add(c.FirstName );
          pFirstname.add(c.FirstName);
          string testname=c.FirstName;
          totalNaddLength=totalNaddLength+1;
        }

        if(c.Address_1__c != null && c.Address_1__c != ' '){
          nameAddProlst.add(c.Address_1__c);
          totalNaddLength=totalNaddLength+1;
        }

        if(c.Address_2__c != null && c.Address_2__c != ' '){
          nameAddProlst.add(c.Address_2__c);
          totalNaddLength=totalNaddLength+1;
        }

        if(c.Address_3__c != null && c.Address_3__c != ' '){
          nameAddProlst.add(c.Address_3__c);
          totalNaddLength=totalNaddLength+1;
        }
        
        if(c.LastName !=null){
          if(c.FirstName !=null){
            if(c.Middle_Name__c!=null){
              if(c.Date_of_Birth__c!=null){
                String NameDOB =String.valueof(c.FirstName)+String.valueof(c.Middle_Name__c)+String.valueof(c.LastName)+String.valueof(c.Date_of_Birth__c);
                NameDaOB.add(NameDOB);
                system.debug('Name + DOB'+NameDaOB);
              }
              
              if(c.Name_of_the_company_Employer__c !=null){
                String CompoDOB = String.valueof(c.FirstName)+String.valueof(c.Middle_Name__c)+String.valueof(c.LastName)+String.valueof(c.Name_of_the_company_Employer__c);
                CompDOM.add(CompoDOB);
                system.debug('Name + Comapnay '+CompoDOB);
              }
              
              if(c.Residence_City__c !=null){
                if(c.Pin_Code__c !=null){
                  String NamecompPin = String.valueof(c.FirstName)+String.valueof(c.Middle_Name__c)+String.valueof(c.LastName)+String.valueof(c.Residence_City__c)+String.valueof(c.Pin_Code__c);
                  NaCompPin.add(NamecompPin);
                  system.debug('Name + Comapnay + Pin '+NamecompPin);
                }
              }
            }
          }
        }
        
        if(isinsert)
        {
          system.debug('in side isinsert');
          String mob = string.valueof(c.mobile__c);
          String pan =string.valueof(c.PAN_Number__c);
  
          system.debug('mob------>'+mob );
          system.debug('Pan---->'+pan);
          system.debug('applistsize---->'+applist.size());
         
          if(applist.size()>0 && applist[0].Loan_Application__r.Product__c=='SOL')
            system.debug('product---->'+applist[0].Loan_Application__r.Product__c);
            SendDNCReport.PANDNC(mob,c.id,'None');
            
          if(contmap.get(c.id).Account.Product__c=='SOL') 
            system.debug('product---->'+applist[0].Loan_Application__r.Product__c);   
            SendDNCReport.PANDNC('None',c.id,pan);
        }
    
        if(isupdate)
        {
          system.debug('in side isupdate---->');
          String mob = string.valueof(c.mobile__c);
          String pan =string.valueof(c.PAN_Number__c);
          if(oldmap.get(c.id).Mobile__c != newmap.get(c.id).Mobile__c)
          SendDNCReport.mobnumber(mob,c.id,'None',loanid,AppsID);
          if(oldmap.get(c.id).PAN_Number__c != newmap.get(c.id).PAN_Number__c)
          SendDNCReport.mobnumber('None',c.id,pan,loanid,AppsID);
        }
        
    }// for   
 
        system.debug(totalNaddLength+'muraliiiiiiiiiiii');
        // thid process has to start only when at leat one field having null value 
        
    if(totalNaddLength < 5){
        try{
             system.debug('ggggggg');  
             fnFradDb=[select id,Fraudster_name__c,Name_Address_del__c,First_Name__c from Fraud_Database__c where First_Name__c IN : pFirstname];
             system.debug(fnFradDb[0].id+'ggggggg');
        }catch(exception e){}

        if(fnFradDb.size() >0){
     
            for(integer m=0; m <fnFradDb.size();m++ ){    
                  nAddchecker=fnFradDb[m].Name_Address_del__c;
                  system.debug('hhhhhhhhhhhhhhhhhhh'+nAddchecker);        
      
                    for(integer tt=0; tt<totalNaddLength; tt++) {   
   
                          system.debug(nameAddProlst[tt]+'VVVVVVVV');     
                          if(nAddchecker.contains(nameAddProlst[tt])){
        
                               totalmatches=totalmatches+1;
                               system.debug(totalmatches+'lllllllllll');
                     
                 if(totalmatches == totalNaddLength){                  
                  FDid=fnFradDb[m].id;
                  ifoundMatch =true;
                  system.debug(FDid+'i am final value');
                  break;
                }      
                           }
                    }// inner for             
            }// main for    
        }// size if
  
        if(ifoundMatch ==true ){
           List <Fraud_Match__c> tempFMList = new List <Fraud_Match__c>();
       for(Fraud_Database__c fdc :finalFDfound){
             Fraud_Match__c sss= new Fraud_Match__c(Fraud_Database__c=FDid,Contact__c=ConID[0]);
             tempFMList.add(sss);
             system.debug(sss+'completed');
           }
       Insert tempFMList;
        } 
      }//end of main if for this process
    //------------------------------------------------------------------------- 
 
    try{
      FradData =[Select id from Fraud_Database__c where ((Pan_Number__c in: PANno) or (Voter_ID__c in: VoterID) or(Passport_No__c in:Passportno)or(Mobile_Number__c in:Mobile) or(Driving_License_No__c in:DrivingL)
             or(Address_Pin_Code_del__c in:AddoPin) or(Name_Address_del__c in:NameAdd)or (Name_DOB_del__c in:NameDaOB) or (Name_Company_Name_del__c in:CompDOM) or (Name_City_Pincode_del__c in:NaCompPin))];
 
      frdMatch =[select id from Fraud_Match__c where Contact__c in:ConID];
    }catch(exception e){}
    if(frdMatch.size()>0)
    {
      delete frdMatch;
    }
    if(FradData.size()>0)
    {
      List <Fraud_Match__c> tempFM = new List<Fraud_Match__c>();
      for(Fraud_Database__c frd : FradData)
      {
        Fraud_Match__c fm = new Fraud_Match__c();
        fm.Fraud_Database__c=frd.id;
        fm.Contact__c=ConID[0];
        tempFM.add(fm);        
      }
      Insert tempFM;
    }

    /** Fraud Dedupe Logic Ends Here**/ 
    /*** DNC and PAN Verification Starts Here **/ 
       //} end of if block of recusrsive call
  }
  
  public void fraudDATACheck(boolean isupdate, boolean isinsert, Map<id,Contact> oldmap, Map<id,Contact> newmap){
    list<Segment_Master__c> segmnetset=new  list<Segment_Master__c>();
    list<Segment_Master__c> segmnetset1=new  list<Segment_Master__c>();
    list<Segment_Master__c> segmnetListUpdate=new  list<Segment_Master__c>();
    list<Segment_Master__c> employList=new  list<Segment_Master__c>();
    map<string,string> domineMap=new map<string,string>();
    set<string> dominenames=new set<string>(); 
    set<id> appForCib=new set<id>();
    set<string> tanSet=new set<string>();
    map<id,CIBIL__c> applCibil=new map<id,CIBIL__c>();
    map<id,integer> appAndWexp=new map<id,integer>();
    map<id,id> appWithCont=new map<id,id>();
    set<Contact> finalContactsForCil=new set<Contact>();
    list<TAN__c> tanList=new list<TAN__c>();
    Map<Id,string> nameForDomin=new Map<Id,string>();
    Map<Id,string> BankMap=new Map<Id,string>();
    set<TAN__c> tanSetUpdate=new set<TAN__c>();
    set<id> segmentEmailPass=new set<id>();
    Map<id,Contact> employWithcont=new Map<id,Contact>();
    set<id> employid=new set<id>();
    Map<string,TAN__c> tanEmp=new Map<string,TAN__c>();
    list<string> domineNameafterSplit=new list<string>();
    set<id> employIdset=new set<id>();
    map<id,string> repaymentBankName=new map<id,string>();
    set<string> productset=new set<string>();


    if(Limits.getDMLStatements()<149 && Limits.getSoslQueries()<97){
      
      for(Contact cc : contactList){ 
        if(cc.Office_Email_Id_for_Fraud__c !=null){        
          dominenames.add('%'+cc.Office_Email_Id_for_Fraud__c.split('@')[1]+'%');       
        }//if tan is there
        
        // keep all tan into set
        if(cc.TAN_Number__c!=null){
          tanSet.add(cc.TAN_Number__c);
        }     

        // employ with contact map 
        if(cc.Employer__c!=null)    
          employWithcont.put(cc.Employer__c,cc);
        system.debug(cc.Employer__c+'MuraliKrishna');
      }//for
    
            for(Applicant__c a:applist)
            {        
                // added for cibil varification
                if(a.Applicant_Type__c=='Primary'){
                    System.debug('****in primary a id: '+a.Id + '***a.Loan_Application__r.Repayment_Bank_Name__c: '+a.Loan_Application__r.Repayment_Bank_Name__c);
                    repaymentBankName.put(a.Contact_Name__c,a.Loan_Application__r.Repayment_Bank_Name__c); 
                    appForCib.add(a.id);
                    appWithCont.put(a.Contact_Name__c,a.id);
                    //keeping work exper with app id
                    if(a.Contact_Name__r.Total_Work_Experience_Yrs__c!=null)        
                      appAndWexp.put(a.id,(integer)a.Contact_Name__r.Total_Work_Experience_Yrs__c);
                }
                
        if(a.Loan_Application__r.Product__c=='SAL' || a.Loan_Application__r.Product__c=='SPL' || a.Loan_Application__r.Product__c=='SBS CS SAL'){
                     productset.add(a.Loan_Application__r.Product__c);
                }  
                      
            }   
        
      if(!productset.isempty()){           
        productset.clear();
        // single query from segmentmaster based on contact email id domain name
        if(!dominenames.isempty())
          segmnetset=[select id,Domain_Name__c,name,BANK_NAMES__c from Segment_Master__c where Parameter_fields__c='Employer' and Domain_Name__c like :dominenames and Active_Flag__c=true];
        
        system.debug(segmnetset.size()+'YYYYYYYYYYYY'+segmnetset);
        segmnetset1=[select id,Domain_Name__c,name,BANK_NAMES__c from Segment_Master__c where Parameter_fields__c='Employer' and id=:employWithcont.keySet()];
 
        if(!tanSet.isempty())
          tanList=[select id,name,Branch__c,Employer__c,CM_approved__c from TAN__c where name IN :tanSet and Active__c=true];
      
        system.debug(tanList.size()+'Tannnnnnnnnnnnnnnnn'+tanList);
        //empty the set for heap size issues and use the same set for process also.
        tanSet.clear();
      
    
        for(TAN__c ta:tanList){
          tanEmp.put(ta.name,ta);
        }
        
        // tanList clear the list for next use 
        tanList.clear();
        Map<id,Segment_Master__c> bankNmaeSeg=new Map<id,Segment_Master__c>();
     
        for(Segment_Master__c sm1:segmnetset1){
          bankNmaeSeg.put(sm1.id,sm1);
        }  
  
        for(Segment_Master__c sm:segmnetset1){
        
          if(sm.Domain_Name__c!=null)  
            if(sm.Domain_Name__c.contains(';')){ 
              domineNameafterSplit=sm.Domain_Name__c.split(';');
            }else{  
              domineNameafterSplit.add(sm.Domain_Name__c);        
            }
            
          for(integer g=0;g<domineNameafterSplit.size();g++){
            if(domineNameafterSplit[g]!=null){
              domineMap.put(domineNameafterSplit[g],'PASS');
            }           
          }
           
          domineNameafterSplit.clear();  
          nameForDomin.put(sm.id,sm.name.toLowerCase());
          BankMap.put(sm.id,sm.BANK_NAMES__c);
        }
 
      for(Contact cc : contactList){
   
        system.debug(nameForDomin.get(cc.Employer__c)+'HHHHHHHHHHHHHH'+BankMap.get(cc.Employer__c));
   
        if(cc.ApplicantType__c == 'Primary'){
          cc.Bank_Name1__c = repaymentBankName.get(cc.Id);
          System.debug('**************cc.Bank_Name1__c: '+cc.Bank_Name1__c);
        }
            
        if(cc.Employer__c==null){
                    cc.Bank_Name_Status1__c='Employer Required';
                } 
            
        if(!isupdate){  
          if(cc.Employer__c!=null && cc.Bank_Name1__c!=null && bankNmaeSeg.get(cc.Employer__c)==null && cc.Bank_Name_Status1__c!='CM Approve Pending'){
                                                
                  if(bankNmaeSeg.get(cc.Employer__c).BANK_NAMES__c.contains(cc.Bank_Name1__c.toUpperCase())){                                   
                     cc.Bank_Name_Status1__c='PASS';               
                     }else{cc.Bank_Name_Status1__c='CM Approve Pending';}        
                 }  
              }   
        
        if(isupdate){
        system.debug('1111111111111');
        if(oldmap.get(cc.id).Bank_Name_Status1__c=='CM Approve Pending' && newmap.get(cc.id).Bank_Name_Status1__c=='PASS' && cc.Employer__c!=null ){
          system.debug('1111111111111');  
                    
          if(bankNmaeSeg.get(cc.Employer__c).BANK_NAMES__c==null){    
                           bankNmaeSeg.get(cc.Employer__c).BANK_NAMES__c=cc.Bank_Name1__c;
                           employList.add(bankNmaeSeg.get(cc.Employer__c));
                    }else{
                           system.debug(bankNmaeSeg.get(cc.Employer__c).BANK_NAMES__c+'FFFFFFFFF'+cc.Bank_Name1__c);
                           bankNmaeSeg.get(cc.Employer__c).BANK_NAMES__c=bankNmaeSeg.get(cc.Employer__c).BANK_NAMES__c+';'+cc.Bank_Name1__c;
                          
                           employList.add(bankNmaeSeg.get(cc.Employer__c));
                           system.debug(employList+'YYYYYYYYY');
                    }                                            
             
        }  
          
                system.debug('bankNmaeSeg.get(cc.Employer__c).......'+bankNmaeSeg.get(cc.Employer__c));
        if(((cc.Employer__c!=null && cc.Bank_Name1__c!=null &&  bankNmaeSeg.get(cc.Employer__c)!=null ) || ( oldmap.get(cc.id).Employer__c!=newmap.get(cc.id).Employer__c  && cc.Bank_Name1__c!=null && bankNmaeSeg.get(cc.Employer__c)!=null )) && cc.Bank_Name_Status1__c!='FAIL'){
                   
          if(bankNmaeSeg.get(cc.Employer__c).BANK_NAMES__c!=null ) {                              
            if(bankNmaeSeg.get(cc.Employer__c).BANK_NAMES__c.contains(cc.Bank_Name1__c.toUpperCase())){    
              system.debug('bankNmaeSeg.get(cc.Employer__c).......'+bankNmaeSeg.get(cc.Employer__c));                               
              cc.Bank_Name_Status1__c='PASS';               
            }else{
              cc.Bank_Name_Status1__c='CM Approve Pending';
            }
                    }else{
            cc.Bank_Name_Status1__c='CM Approve Pending';
          }                             
                }            
                              
              }     
            
      if(isupdate){            
                 if(oldmap.get(cc.id).Office_Email_Id_for_Fraud__c!=newmap.get(cc.id).Office_Email_Id_for_Fraud__c){
                    cc.Email_Domain_Status__c=' ';
                 }    
            }
    
        system.debug('MMMMMMMMM'+cc.Bank_Name_Status1__c);     
              
      if(isinsert){  
                if(cc.Office_Email_Id_for_Fraud__c !=null && cc.Email_Domain_Status__c!='FAIL'){   
                    cc.Email_Domain_Status__c=domineMap.get(cc.Office_Email_Id_for_Fraud__c.split('@')[1])!=null ? domineMap.get(cc.Office_Email_Id_for_Fraud__c.split('@')[1]) : 'CM Approve Pending';                       
                    System.debug('***************cc.Email_Domain_Status__c: '+cc.Email_Domain_Status__c);
                }
      }else{  
        if(oldmap.get(cc.id).Email_Domain_Status__c=='CM Approve Pending' && ( newmap.get(cc.id).Email_Domain_Status__c=='PASS' || newmap.get(cc.id).Email_Domain_Status__c=='FAIL' )){
                //dont do any thing
        }else{
          if(cc.Office_Email_Id_for_Fraud__c !=null && cc.Email_Domain_Status__c!='FAIL'){   
            cc.Email_Domain_Status__c=domineMap.get(cc.Office_Email_Id_for_Fraud__c.split('@')[1])!=null ? domineMap.get(cc.Office_Email_Id_for_Fraud__c.split('@')[1]) : 'CM Approve Pending';                       
            System.debug('***************cc.Email_Domain_Status__c: '+cc.Email_Domain_Status__c);
          }
        }
      }    
                  
      if(isupdate){
                if(oldmap.get(cc.id).TAN_Found_In_Master__c=='CM Approve Pending' && newmap.get(cc.id).TAN_Found_In_Master__c=='PASS'){
                    tanEmp.get(cc.TAN_Number__c).CM_approved__c=true;       
                    tanSetUpdate.add(tanEmp.get(cc.TAN_Number__c));
                }
        
        // CM Approve Pending for email domine name
                if(oldmap.get(cc.id).Email_Domain_Status__c=='CM Approve Pending' && newmap.get(cc.id).Email_Domain_Status__c=='PASS'){       
                    if(cc.Employer__c !=null){             
                        segmentEmailPass.add(cc.Employer__c);             
                    }        
                }
        
        
            }
      
      //process for tan 
            if(tanEmp.get(cc.TAN_Number__c)!=null){ 
                if(tanEmp.get(cc.TAN_Number__c).CM_approved__c==true )
                    cc.TAN_Found_In_Master__c='PASS';
            }
                      
      if(tanEmp.get(cc.TAN_Number__c)!=null && cc.TAN_Found_In_Master__c!='FAIL'){ 
                if(tanEmp.get(cc.TAN_Number__c).CM_approved__c==false)            
                    cc.TAN_Found_In_Master__c='CM Approve Pending';
            }  
                       
            if(tanEmp.get(cc.TAN_Number__c)!=null && cc.Office_City__c!=null && cc.Employer__c!=null){  
                if(tanEmp.get(cc.TAN_Number__c)!=null && (tanEmp.get(cc.TAN_Number__c).Branch__c.toUpperCase()!=cc.Office_City__c.toUpperCase() || tanEmp.get(cc.TAN_Number__c).Employer__c!=cc.Employer__c))
                    cc.TAN_Found_In_Master__c='MISMATCH WITH EMPLOY / CITY';
            } 
       
            if(tanEmp.get(cc.TAN_Number__c)==null && cc.TAN_Number__c!=null){
                system.debug('entereeeeeeeeeeeeeeee');
                TAN__c tanobj=new TAN__c(); 
                tanobj.name=cc.TAN_Number__c;             
                tanobj.Employer__c=cc.Employer__c;                           
                tanobj.Branch__c=cc.Office_City__c;
                tanobj.Active__c=true;
                tanobj.CM_approved__c=false; 
                             
                if(tanobj.Branch__c!=null && cc.Office_City__c!=null)             
                    tanList.add(tanobj);
                              
                if(cc.Office_City__c==null){
                    cc.TAN_Number__c='';
                    cc.TAN_Found_In_Master__c='Office City Required';
                }else{             
                    cc.TAN_Found_In_Master__c='CM Approve Pending';
                }
            }
            system.debug('MMMMMMMMM2'+cc.Bank_Name_Status1__c); 
      
      } // end of for loop
   
    if(!employList.isempty())
      update employList;
   
        if(!segmentEmailPass.isempty()){       
            List<Segment_Master__c> segList=new List<Segment_Master__c>(); 
            List<Segment_Master__c> segmentEmployList=new List<Segment_Master__c>();  
            // below records relating to records which have bean seleted for PASS
            segList=[select id,Domain_Name__c from Segment_Master__c where id =: segmentEmailPass];                
            // below records queired based on contact employ ids
            segmentEmployList=[select id,Domain_Name__c from Segment_Master__c where id =: employWithcont.keySet() ];
                  
            //employWithcont      
            for(segment_Master__c sepro:segList){         
                            
        if(sepro.Domain_Name__c==null){
                            
                    if(employWithcont.get(sepro.id)!=null)
                        sepro.Domain_Name__c=employWithcont.get(sepro.id).Office_Email_Id_for_Fraud__c.contains('@') ? employWithcont.get(sepro.id).Office_Email_Id_for_Fraud__c.split('@')[1] : ' ';
                
        }else{
                                
          if(employWithcont.get(sepro.id)!=null)
                                   
                        if(employWithcont.get(sepro.id).Office_Email_Id_for_Fraud__c.contains('@')){                              
                            sepro.Domain_Name__c= !sepro.Domain_Name__c.containsIgnoreCase(employWithcont.get(sepro.id).Office_Email_Id_for_Fraud__c.split('@')[1]) ? sepro.Domain_Name__c+';'+employWithcont.get(sepro.id).Office_Email_Id_for_Fraud__c.split('@')[1] : ' ';   
                        }
                            
                }
                        
            }
                  
            if(!segList.isempty())
                update segList;
                  
        }
               
        if(!tanSetUpdate.isempty()){
            list<TAN__c> TanListUpdate=new list<TAN__c>();
             
            for(TAN__c tn: tanSetUpdate){
                TanListUpdate.add(tn);
            }
                               
            update TanListUpdate;
        }
   
        if(!tanList.isempty())
            upsert tanList;
  
    //clear after process completed.
    tanList.clear();
         
        // code for cibil validation
        List<CIBIL__c> cibilrecordList=new List<CIBIL__c>();
        if(!appForCib.isempty()){
            cibilrecordList= [SELECT Applicant__c,Date_Opened1__c,Date_Opened__c,Date_Opened2__c,Date_Opened3__c,Date_Opened4__c,Date_Opened5__c,
                              Date_Opened6__c,Date_Opened7__c,Date_Opened8__c,Date_Opened9__c,Date_Opened10__c,
                              Date_Opened11__c,Date_Opened12__c,Date_Opened13__c,Date_Opened14__c,Date_Opened15__c,
                              Date_Opened16__c,Date_Opened17__c,Date_Opened18__c,Date_Opened19__c,
                              Date_of_Enquiry__c,CIBIL_Fired_time__c,Date_of_Enquiry1__c,Date_of_Enquiry2__c,Date_of_Enquiry3__c,
                              Date_of_Enquiry4__c,Date_of_Enquiry5__c,Date_of_Enquiry6__c,Date_of_Enquiry7__c,Date_of_Enquiry8__c,
                              Date_of_Enquiry9__c,Date_of_Enquiry10__c,Date_of_Enquiry11__c,Date_of_Enquiry12__c,Date_of_Enquiry13__c,
                              Date_of_Enquiry14__c,Date_of_Enquiry15__c,Date_of_Enquiry16__c,Date_of_Enquiry17__c,Date_of_Enquiry18__c,
                              Date_of_Enquiry19__c FROM CIBIL__c  where Applicant__c =:appForCib];
        }

    // keeping cibil with applicant 
        for(CIBIL__c cib:cibilrecordList){  
            applCibil.put(cib.Applicant__c,cib);  
        }
                  
   // main process starts  
    date finaldate;
    set<id> recordIDsForCext=new  set<id>();
   for(Contact cx : contactList){
          system.debug('I have entered');
     //cibil checking 
       if(applCibil.get(appWithCont.get(cx.id))!=null){
     finaldate= applCibil.get(appWithCont.get(cx.id)).Date_Opened__c !=null ? (
              applCibil.get(appWithCont.get(cx.id)).Date_Opened1__c != null ? (
                applCibil.get(appWithCont.get(cx.id)).Date_Opened2__c !=null ?  (
                  applCibil.get(appWithCont.get(cx.id)).Date_Opened3__c !=null ? (
                     applCibil.get(appWithCont.get(cx.id)).Date_Opened4__c !=null ? (
                        applCibil.get(appWithCont.get(cx.id)).Date_Opened5__c !=null ? (
                            applCibil.get(appWithCont.get(cx.id)).Date_Opened6__c !=null ? (
                               applCibil.get(appWithCont.get(cx.id)).Date_Opened7__c !=null ? (
                                  applCibil.get(appWithCont.get(cx.id)).Date_Opened8__c !=null ?  (
                                     applCibil.get(appWithCont.get(cx.id)).Date_Opened9__c !=null ?  (
                                       applCibil.get(appWithCont.get(cx.id)).Date_Opened10__c !=null ?  (
                                           applCibil.get(appWithCont.get(cx.id)).Date_Opened11__c !=null ?  (
                                              applCibil.get(appWithCont.get(cx.id)).Date_Opened12__c !=null ?  (
                                                 applCibil.get(appWithCont.get(cx.id)).Date_Opened13__c !=null ?  ( 
                                                     applCibil.get(appWithCont.get(cx.id)).Date_Opened14__c !=null ?  ( 
                                                         applCibil.get(appWithCont.get(cx.id)).Date_Opened15__c !=null ?  ( 
                                                             applCibil.get(appWithCont.get(cx.id)).Date_Opened16__c !=null ? (  
                                                                   applCibil.get(appWithCont.get(cx.id)).Date_Opened17__c !=null ? ( 
                                                                       applCibil.get(appWithCont.get(cx.id)).Date_Opened18__c !=null ? ( 
                                                                          applCibil.get(appWithCont.get(cx.id)).Date_Opened19__c !=null ? 
                                                        
                                                               //  final value after filtering
                                                                          applCibil.get(appWithCont.get(cx.id)).Date_Opened19__c 
                                                      
                                                                                                                                   
                                                                           : applCibil.get(appWithCont.get(cx.id)).Date_Opened18__c 
                                                                       )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened17__c 
                                                                    )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened16__c      
                                                                 )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened15__c 
                                                             )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened14__c 
                                                        )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened13__c 
                                                    )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened12__c   
                                                )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened11__c   
                                            )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened10__c   
                                        )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened9__c   
                                    )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened8__c        
                                 )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened7__c                                                                  
                               )  : applCibil.get(appWithCont.get(cx.id)).Date_Opened6__c 
                            ) : applCibil.get(appWithCont.get(cx.id)).Date_Opened5__c 
                        ) : applCibil.get(appWithCont.get(cx.id)).Date_Opened4__c     
                     ) : applCibil.get(appWithCont.get(cx.id)).Date_Opened3__c 
                  ) : applCibil.get(appWithCont.get(cx.id)).Date_Opened2__c 
               ) :  applCibil.get(appWithCont.get(cx.id)).Date_Opened1__c                           
           ) : applCibil.get(appWithCont.get(cx.id)).Date_Opened__c     
      ) : system.today();
     
     If(applCibil.get(appWithCont.get(cx.id)).Date_Opened19__c!=null){
           recordIDsForCext.add(appWithCont.get(cx.id));
     }
     
     
     //oldest enquiry date
      date enquerycheck,finalCampdate; string stampingInfo;
      string tempString;
     tempString= applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry__c != null ? (     
                   applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry1__c != null ? ( 
                     applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry2__c !=null ?  (                                               
                         applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry3__c !=null ?  (  
                           applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry4__c !=null ?  (  
                              applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry5__c !=null ?  (  
                                applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry6__c !=null ?  (  
                                   applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry7__c !=null ?  (  
                                      applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry8__c !=null ?  (  
                                        applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry9__c !=null ?  (  
                                          applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry10__c !=null ?  (  
                                             applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry11__c !=null ?  (  
                                               applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry12__c !=null ?  (  
                                                 applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry13__c !=null ?  (  
                                                   applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry14__c !=null ?  (  
                                                     applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry15__c !=null ?  (  
                                                       applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry16__c !=null ?  (  
                                                         applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry17__c !=null ? (   
                                                            applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry18__c != null ? (
                                                               applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry19__c !=null ? 
                                                                        
                                                                           applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry19__c      
                                                                                                                                                                                                                                     
                                                                              
                                                                          : applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry18__c
                                                                     )  :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry17__c        
                                                                 ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry16__c       
                                                            ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry15__c        
                                                       ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry14__c   
                                                   ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry13__c        
                                               ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry12__c   
                                          ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry11__c        
                                     ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry10__c       
                                ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry9__c        
                           ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry8__c   
                        ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry7__c        
                     ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry6__c       
                  ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry5__c        
               ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry4__c                
             ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry3__c        
          ) :  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry2__c
        ):  applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry1__c   
      ): applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry__c
     ): ' '; 
     
     system.debug(tempString+'TTTTTTTTTTTTT'+finaldate + '  ' + applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry19__c);
     if(applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry19__c!='NO DATA'){
        tempString=applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry19__c;
     }  
     
     if(tempString!=' ' && tempString!=null){
        system.debug(tempString.length()+'RRRRRR');
      if(tempString.length()==8){
         enquerycheck=date.parse(string.valueof(string.valueof(tempString.split('')[2])+string.valueof(tempString.split('')[3])+'/'+tempString.split('')[0])+string.valueof(tempString.split('')[1])+'/'+string.valueof(tempString.split('')[4])+string.valueof(tempString.split('')[5])+string.valueof(tempString.split('')[6])+string.valueof(tempString.split('')[7]));
      }
     
     }
     tempString=' ';
     
    if(applCibil.get(appWithCont.get(cx.id)).Date_of_Enquiry__c!=null && finaldate!=null && enquerycheck!=null){ 
         
        if(finaldate.daysBetween(enquerycheck)<0){
           finalCampdate=enquerycheck;  
        }else{
           finalCampdate=finaldate;
        }       
    }
     
    // system.debug(finalCampdate+'GGGGGGGGGGGGGG'+applCibil.get(appWithCont.get(cx.id)).CIBIL_Fired_time__c);
   //  system.debug(date.newinstance(applCibil.get(appWithCont.get(cx.id)).CIBIL_Fired_time__c.year(),applCibil.get(appWithCont.get(cx.id)).CIBIL_Fired_time__c.month(),applCibil.get(appWithCont.get(cx.id)).CIBIL_Fired_time__c.day())+'TrRRRRRRRR');  
   
     if(finalCampdate!=null){
     
     if(applCibil.get(appWithCont.get(cx.id)).CIBIL_Fired_time__c!=null){
          if((finalCampdate).daysBetween(date.newinstance(applCibil.get(appWithCont.get(cx.id)).CIBIL_Fired_time__c.year(),applCibil.get(appWithCont.get(cx.id)).CIBIL_Fired_time__c.month(),applCibil.get(appWithCont.get(cx.id)).CIBIL_Fired_time__c.day())) /365 > =3){
      
            stampingInfo='Oldest CIBIL Loan/Enquiry more than 3 years';
          
          }else{
          stampingInfo='Oldest CIBIL Loan/Enquiry in last 3 years';
       
          }
       }else{stampingInfo=' ';}
      
     }else{stampingInfo=' ';}
        
      System.debug('**************stampingInfo: '+stampingInfo);
      cx.CIBIL_Report__c=stampingInfo;
     
    }    
         //end of record check
                                   
  }
  
   //enquiry  check
   
   
   
   }//end of product check

  }//end of limit check

}

 // Bug Id : 16618 - NSDL PAN Check -- end   
 
public void Update_Contact_PAN( Map<id,Contact> oldmap, List<Contact> newConList) {

                          Set<ID> Conids = new Set<ID>();         // current Contact's  id.
                        List<Contact> ConList = new List<Contact>();  
                     System.debug('inside Update_Contact_PAN ');                           
        
      for(Contact updatedCon : newConList){
           if( (oldmap.get(updatedCon.id).Customer_Type__c != null && oldmap.get(updatedCon.id).Customer_Type__c.equalsIgnoreCase('Individual') && 
             ((oldmap.get(updatedCon.id).Date_of_Birth__c == null )||(!String.valueOf(oldmap.get(updatedCon.id).Date_of_Birth__c).equalsIgnoreCase(String.valueOf(updatedCon.Date_of_Birth__c )) )))     ||
             (oldmap.get(updatedCon.id).Customer_Type__c != null && oldmap.get(updatedCon.id).Customer_Type__c.equalsIgnoreCase('Corporate') &&
             ((oldmap.get(updatedCon.id).Year_of_Incorporation__c == null )||(!String.valueOf(oldmap.get(updatedCon.id).Year_of_Incorporation__c).equalsIgnoreCase(String.valueOf(updatedCon.Year_of_Incorporation__c )) )))  ||
              (((oldmap.get(updatedCon.id).PAN_Number__c) == null && updatedCon.PAN_Number__c != null ) ||(oldmap.get(updatedCon.id).PAN_Number__c != null && !oldmap.get(updatedCon.id).PAN_Number__c.equalsIgnoreCase(updatedCon.PAN_Number__c))) ){        
                                  Conids.add(updatedCon.id);
                                  ConList.add(updatedCon);
                  }      
                }  


  if (  Conids.size() > 0) {
   System.debug('taken required updated contact list');   
    List<TAT_Master__c> TATMsterlst = new List<TAT_Master__c>();
  //  List<Applicant__c> Applcntlst = new List<Applicant__c>();   
    List<Account> updatedAccList = new List<Account>();
    List<Opportunity> updatedOppoList = new List<Opportunity>();
    
  //  List<ID> Accids = new List<ID>();
List<Applicant__c> AppList  = [ Select Id, PAN_Number__c, Applicant_type__c, Contact_Name__c, ContactName__c, Contact_Name__r.PAN_Number__c,Loan_Application__r.StageName,
                                (Select Name, TypeP__c, Applicant__c, PAN_Number__c, PAN_Source__c, PAN_Check_Status__c, Comment__c, Credit_Observation__c, Override_Flag__c, NSDL_Response__c, Title__c, Name__c, Date_Of_Birth__c, Last_Modified_Date__c From TAT_Masters__r) 
                               ,Contact_Name__r.Account.PANNumber__c, Loan_Application__r.PAN_Number__c,Contact_Customer_Type__c,Loan_Application__c
                                    From Applicant__c 
                                    Where Contact_Name__c =: Conids AND ( Loan_Application__r.StageName = 'Underwriting' OR Loan_Application__r.StageName = 'Re-Appraise- Loan amount' ) ]; 
                                    
      Set<Id> aidlst = new Set<Id>();
      Set<Id> lnlst = new Set<Id>();
      for(Applicant__c a : AppList){
        
        aidlst.add(a.Contact_Name__r.Account.Id);
        lnlst.add(a.Loan_Application__c);
        }
      
      List<Account> tempAccList = [select id,PANNumber__c from Account where id =: aidlst] ;  
      List<Opportunity> tempOppoList = [select id,PAN_Number__c from Opportunity where id =: lnlst] ;     
        System.debug('going for update to account ' + tempAccList );  
         System.debug('going for update to  opportunity' + tempOppoList );      
        for ( Contact cont : ConList ) {
            
              for ( Applicant__c app : AppList ) {
              
              System.debug('app' +app.Applicant_type__c +'  cobtact ' +app.Contact_Customer_Type__c);
               if(app.Applicant_type__c != null && app.Contact_Customer_Type__c != null)
               {
              if( 
                  (app.Applicant_type__c.equalsIgnoreCase('Primary') && app.Contact_Customer_Type__c.equalsIgnoreCase('Individual')) ||
                  (app.Applicant_type__c.equalsIgnoreCase('Primary Financial Co-Applicant') && app.Contact_Customer_Type__c.equalsIgnoreCase('Corporate')) ){
                              //app.Contact_Name__r.Account.PANNumber__c = cont.PAN_Number__c;
                             // app.Loan_Application__r.PAN_Number__c = cont.PAN_Number__c;
                         
                           for(Opportunity op : tempOppoList ) {
                                System.debug('app.Contact_Name__c --> ' + app.Contact_Name__c);
                                System.debug('cont.Id --> ' + cont.Id);
                                System.debug('op.Id --> ' + op.Id);
                                System.debug('app.Loan_Application__c --> ' + app.Loan_Application__c);
                              if (app.Contact_Name__c == cont.Id && op.Id == app.Loan_Application__c) {                        
                                System.debug('old opportunity pan to '+op.PAN_Number__c);                   
                                op.PAN_Number__c = cont.PAN_Number__c;
                                System.debug('Updated opportunity pan from opportunity update '+ cont.PAN_Number__c);
                                updatedOppoList.add(op);
                              }
                          }
                          
                          for(Account ac : tempAccList ){    
                              System.debug('old opportunity pan related to acc. '+ ac.PANNumber__c);                   
                              ac.PANNumber__c = cont.PAN_Number__c;
                              System.debug('Updated Account pan to '+cont.PAN_Number__c);
                              updatedAccList.add(ac);
                          }
                         //     Applcntlst.add(app);
                      }
              }
                       
                        for( TAT_Master__c Tmaster : app.TAT_Masters__r ){
                              if( Tmaster.PAN_Source__c != null && Tmaster.PAN_Source__c.equalsIgnoreCase('Input')){
                                Tmaster.PAN_Number__c = cont.PAN_Number__c;
                                Tmaster.Comment__c= null;
                                Tmaster.PAN_Check_Status__c =null;
                                Tmaster.Name__c =null;
                                Tmaster.NSDL_Response__c =null;
                              //  Tmaster.Last_Modified__c = null;
                                Tmaster.Credit_Observation__c = null;
                                Tmaster.Last_Modified_Date__c = null;
                                Tmaster.Override_Flag__c = false;
                             TATMsterlst.add(Tmaster);
                           }  
                        }
                    }
                }
      
              //   update Applcntlst;
              
               if( updatedAccList != null && updatedAccList.size() > 0) update updatedAccList;
                 
                 if( updatedOppoList != null && updatedOppoList.size() > 0) update updatedOppoList;
                  System.debug('Updated Opportunity list '+ updatedOppoList );
                
                 
                 if( TATMsterlst != null && TATMsterlst.size() > 0) update TATMsterlst;
                 
             //    System.debug('Updated opportunity pan value to new value of account pan ' + updatedAccList[0].PANNumber__c);
            }
                 
          // Bug Id : 16618 - NSDL PAN Check -- end       
}
    /*Retrigger BRE 20939 s */
    public void reTriggerBRE(){
      
        Map<String,List<Map<String,String>>> oldValueNewValueMap=new Map<String,List<Map<String,String>>>();      
      
        List<id> AccountIdsMob= new List<Id>(); //Retrigger added by priya
        for(Contact contact1: contactList){
             AccountIdsMob.add(contact1.AccountId);
        }
        Map<Id, Opportunity> oppMap;
        if(!CommonUtility.isEmpty(AccountIdsMob)){
            List<Opportunity> oppLst = [select Account.Flow__c,id,Account.Offer_Inhanced__c, product__C,Account.IS_OTP_FLOW__c, CreatedDate,
                                        (select id,name,Old_Loan_Application__c,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policys__r),
                                        (Select  id,product__c,Type_of_Year__c from PLBS__r where Type_of_Year__c='Current' or Type_of_Year__c='Previous' or Type_of_Year__c='PrevSummary' or Type_of_Year__c='CurrSummary')
                                        from Opportunity where AccountId in : AccountIdsMob];
            if(!CommonUtility.isEmpty(oppLst)){
                oppMap = new Map<Id, Opportunity>();
                for(Opportunity opp : oppLst)
                    oppMap.put(opp.Account.Id,opp);
            }
        }
        System.debug('Yes= '+oppMap+AccountIdsMob);
        Map<String,Object> allMap = new Map<String,Object>();
        allMap = GeneralUtilities.fetchRetriggerRescMap();
        Map<String,SOL_Policy__c> solPolicyToUpdateMap = new map<String,SOL_Policy__c>();
        for(Contact con: contactList){
            Opportunity Loan = new Opportunity();
            if(oppMap != null && oppMap.containsKey(con.AccountId) && oppMap.get(con.AccountId) != null){
                Loan = oppMap.get(con.AccountId);
        }
        system.debug('in mobility'+Loan.Account.Flow__c);
        if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
            Map<String,Object> appFields = new Map<String,Object>();
            Map<String, SOL_Policy__c> solPolicyMAPToUpdate=new Map<String, SOL_Policy__c>();
                if(!commonutility.isEmpty(allMap)){
                    appFields = (Map<String,Object>)allMap.get('Contact');
                    System.debug('Hi'+appFields );
                    if(!commonutility.isEmpty(appFields)){
                        Contact oldApp = new Contact();
                            for(Contact con1 : conOldList){
                                if(con.Id == con1.Id)
                                oldApp = con1;
                        }
                        solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(oldApp,con,Loan,appFields,solPolicyToUpdateMap);
                    }
                }
            }
        }
        if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() > 0){
            update solPolicyToUpdateMap.values();
        }
    }
    /*Retrigger BRE 20939 e */
//Bug 22141 S
    
public void fraudValidateMethod( Map<id,Contact> oldmap, Map<id,Contact> newmap) {
    if(System.Label.MobileValidationOn=='true'){
        List<string> ListOfFields = new List<string>();
        List<string> ListofProducts = new List<string>();
        if(label.FraudFieldsforContact != null && string.isNotBlank(Label.FraudFieldsforContact) && Label.FraudValidationsforProducts!=null && string.isNotBlank(Label.FraudValidationsforProducts)){
            ListOfFields = Label.FraudFieldsforContact.split(',');
            ListofProducts = Label.FraudValidationsforProducts.split(',');
        }
        List<Id> requiredContactId = new List<Id>();        
        List<String> fieldsChanged = new List<String>();
        Datetime storedDate;
        if(Label.MobileValidationStartdate !=null && string.isNotBlank(Label.MobileValidationStartdate)){
            String Datevalue = System.Label.MobileValidationStartdate;
            storedDate = (datetime.valueOf(Datevalue));
        }
        system.debug('stored date'+storedDate);
        if(applist!=null && applist.size()>0){
            for(Applicant__c appObj:applist){
                if(appObj.cibils__r!=null && appObj.cibils__r.size()>0&&appObj.cibils__r[0].CIBIL_Fired_time__c!=null && appObj.Contact_Name__c!=null){
                    Datetime cibilFiredDate = appObj.cibils__r[0].CIBIL_Fired_time__c;
                    if(cibilFiredDate>storedDate){
                        requiredContactId.add(appObj.Contact_Name__c);
                    }
                    
                }
            }
        }
        system.debug('required contact id'+requiredContactId);
        if(requiredContactId != null && !requiredContactId.isEmpty()) { // Bug Id : 23971
        List<Contact>contactwithchilds = [select id,mobile__c,Customer_Type__c,(select id,product__c,Applicant_Type__c from contact__r) from contact where id in :contid];
        for(Contact contactobj:contactwithchilds){ 
            system.debug('contact obj is'+contactobj.id); 
            system.debug('validation is'+requiredContactId.contains(contactobj.id));
            system.debug('ListofProducts'+ListofProducts + 'contactobj.Customer_Type__c==Individual'+ (contactobj.Customer_Type__c));
            if(ListofProducts != null && ListofProducts.size()>0 && requiredContactId!=null && requiredContactId.size()>0 && requiredContactId.contains(contactobj.id)&& contactobj.Customer_Type__c=='Individual'){
              system.debug('inside loop obj is'+contactobj);
              for(string strField : ListOfFields)
                {   
                    system.debug('newmap.get(contactobj.id).get(strField)'+newmap.get(contactobj.id).get(strField)+'oldmap.get(contactobj.id).get(strField)'+oldmap.get(contactobj.id).get(strField));
                    if(newmap.get(contactobj.id).get(strField)!=null && newmap.get(contactobj.id).get(strField)  != oldmap.get(contactobj.id).get(strField))
                    {
                        fieldsChanged.add(strField);
                    }
                }
                if(fieldsChanged!=null && contactobj.contact__r!=null && contactobj.contact__r.size()>0){ // Added for handling error at Loan Conversion Event,
                    
                    String productName = contactobj.contact__r[0].product__c;//Since Contact is created before applicant ie. No applicant present here
                    productName = productName.toUppercase(); 
                    system.debug('inside call'+productName+'fieldsChanged'+fieldsChanged);
                    if(ListofProducts.contains(productname))
                      FraudValidationUtility.utilityMethod('Contact',contactobj,productName,fieldsChanged,contactobj.contact__r[0].ID);
                
                
                }
                
            }
                                    
        }       
    }
    }
    
}
  
    // 3493 s
    public void resetOtpOnOfficeEmailChange ( Map<Id,Contact> newMap, Map<Id,Contact> oldMap){
		
        List <Id> actsId = new List <Id>();
        
        System.debug ('control check');
		for (String recId : newMap.keyset()) actsId.add(newMap.get(recId).AccountId);
        
        List <Account> acts = [SELECT Id , Flow__c FROM Account WHERE Id IN :actsId];
        
        for (Id recId : newMap.keyset())
        {
            Boolean flag = false ;
            if ( newMap.get(recId).Office_Email_Id__c != oldMap.get(recId).Office_Email_Id__c )
                for (Account a:acts) if ( a.Id == newMap.get(recId).AccountId && a.Flow__c == 'Mobility V2') flag =true ; 
            if (flag==true)
                newMap.get(recId).One_Time_Password__c = '';
        }
            
		
										
      								}
    // 3493 e																	}
//Bug 22141 E
}