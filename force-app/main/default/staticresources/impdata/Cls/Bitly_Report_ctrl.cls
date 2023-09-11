public class Bitly_Report_ctrl{

public Opportunity loan{
get;
set;
}
public List < Fees_and_Charge__c > fees {
  get;
  set;
 }
 public Applicant__c applicantPrimary {
 get;
 set;
 }
 public Contact con{
 get;
 set;
 }
 public List < Applicant__c > applicantList = new List < Applicant__c > ();
 public decimal totalchrg{ // for Charge Type
 get;
 set;
 }
 public Decimal totalChrgdesc{
     get;set;
 }
 public decimal netDisAmt {
 get;
 set;
 }
 public list < Bank_Account__c > Bankacc;
 public Bank_Account__c bank {
  get;
  set;
}
public string DMAcctNo{
get;
set;
}
  //Bug# 13224 S
 public String schemeCode {
  get;
  set;
 }
 public decimal netDisAmtSecured {
  get;
  set;
 }
 public decimal emiAmt {
  get;
  set;
 }
 List < Tranche_Details__c > trancheObj = new List < Tranche_Details__c > ();
 //Bug# 13224 E
public Bitly_Report_ctrl(ApexPages.StandardController controller) {
  String loanId = Apexpages.currentPage().getParameters().get('id');
  System.debug('loan id: '+loanId );  
  con = new Contact();
  Bankacc = new list < Bank_Account__c >();  
  loan = new Opportunity();
 
  if(loanId!=null && loanId !=''){
     //Bug# 13224 added Product__c, Scheme_Master__r.is_Pure_Flexi__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.flexi_flag__c,Approved_Loan_Amount__c,Business_IRR__c,Scheme_Master__r.Active__c
    loan = [select Product__c, Scheme_Master__r.is_Pure_Flexi__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.flexi_flag__c,Approved_Loan_Amount__c,Business_IRR__c,Scheme_Master__r.Active__c,Type_Of_Loan__c,id,Bank_Name__c,A_C_No__c,Approved_Rate__c,Approved_Tenor__c ,First_Due_Date__c,EMI_CAM__c,Scheme_Master__r.name,Loan_Application_Number__c,Loan_Amount_with_Premium__c from Opportunity where id=: loanId ];
      //Bug# 13224 S
   emiAmt = 0.0;
   schemeCode = '';
    if (loan.Scheme_Master__r.Active__c) {
        if (loan.Scheme_Master__r.is_Pure_Flexi__c) {
            schemeCode = 'Pure Flexi';
            if(loan.Approved_Loan_Amount__c != null && loan.Business_IRR__c != null)
                emiAmt = ((loan.Approved_Loan_Amount__c * (loan.Business_IRR__c / 100)) / 360) * 30;
        } else if (loan.Scheme_Master__r.IsHybridFlexi__c && loan.Scheme_Master__r.flexi_flag__c) {
            schemeCode = 'Hybrid Flexi';
            if(loan.Approved_Loan_Amount__c != null && loan.Business_IRR__c != null)
                emiAmt = ((loan.Approved_Loan_Amount__c * (loan.Business_IRR__c / 100)) / 360) * 30;
        } else if ((!loan.Scheme_Master__r.IsHybridFlexi__c) && loan.Scheme_Master__r.flexi_flag__c) {
            schemeCode = 'Flexi';
            if(loan.EMI_CAM__c != null)
                emiAmt = loan.EMI_CAM__c;
        } else {
            schemeCode = 'Term Loan';
            if(loan.EMI_CAM__c != null)
                emiAmt = loan.EMI_CAM__c;
        }
    }
   //Bug# 13224 E
     
     if(loan.A_C_No__c !=null){
          DMAcctNo = string.valueOF(loan.A_C_No__c);
          DMAcctNo = DMAcctNo.right(4);
        }
     //Bug# 13224 added Pure_Flexi_EMI__c
    applicantList = [select id, Contact_Name__r.Name, name,Pure_Flexi_EMI__c,Descriptin__c,  Applicant_type__c from Applicant__c where Loan_Application__c = : loanId ];
  
   if (applicantList.size() > 0) {
   integer appsize = applicantList.size();
   for (integer i = 0; i < appsize; i++) {
    if (applicantList[i].Applicant_Type__c == 'Primary') {
     applicantPrimary = new Applicant__c();
     applicantPrimary = applicantList[i];
    }
   }
  }
  if (applicantPrimary != null) {
   con = [select Mobile__C,Email__c,Name from Contact where id = : applicantPrimary.Contact_Name__c limit 1];
  }
   Bankacc = [select id, Loan_Application__c,Bank_Name__c, IFSC_Bank_Name__c, Bank_Branch__c, IFSC_Code__c,Bank_Acct_Number__c from Bank_Account__c
    where Loan_Application__c = : loanId And Applicant__r.Applicant_type__c ='Primary'];
      if (bankacc.size() > 0) bank = bankacc[0];
       system.debug('nnnnnnnnnnnnnnnnnnn' + loan);
        totalchrg=0.00;
        netDisAmt =0.00;
        totalChrgdesc=0.00;
         //Bug# 13224 S
        netDisAmtSecured = 0.0;
        //Bug# 13224 E
  if (loan.id != null) {
      fees = new List < Fees_and_Charge__c > ();
    //charges api enahncement start added Finnone_ChargeId__c,Finnone_ChargeCode__c,Charge_Desc__c in query
   fees = [select id,Finnone_ChargeId__c,Finnone_ChargeCode__c,Charge_Desc__c, name, Charge_Type__c, Deducted_from_Disbursement__c,
    Service_Charge__c, Status__c, Change_Amount__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Charge__c, Instrument_type__c,
    Amount_after_Service_Change__c, Disbursement_Number__c from Fees_and_Charge__c where Loan_Application__c = : loanId  ];
    //Bug# 13224 S
    trancheObj = [select id, Tranche_Recommended_Amount__c from Tranche_Details__c where Loan_Application__c = : loanId order by CreatedDate asc limit 1];
    //Bug# 13224 E
     }
     System.debug('Fees: '+fees );
     if(fees!=null){
         for(Fees_and_Charge__c obj:fees){
             if(obj.Charge_Type__c!=null && obj.Change_Amount__c!=null){
               system.debug('****** Charge_Type__c: ' + obj.Charge_Type__c);
               if(obj.Deducted_from_Disbursement__c =='yes'){
                    totalchrg =Integer.valueOf( totalchrg + obj.Change_Amount__c);
                    
                    }
             }
            else {
              if (obj.Charge_Desc__c!=null && obj.Change_Amount__c!=null){
              system.debug('****** Change desc: ' + obj.Charge_Desc__c);
                if(obj.Deducted_from_Disbursement__c =='yes'){
                     totalchrg = Integer.valueOf(totalchrg + obj.Change_Amount__c);
                    
                     }

              }
            } 
         }
     }
     //Bug# 13224 S
   if (trancheObj != null && trancheObj.size() > 0) {
    if (trancheObj[0].Tranche_Recommended_Amount__c != null) {
     netDisAmtSecured = (trancheObj[0].Tranche_Recommended_Amount__c - totalchrg);
    }
   }
   //Bug# 13224 E
     if(loan.Loan_Amount_with_Premium__c !=null && totalchrg!=null)
        netDisAmt = Integer.valueOf(loan.Loan_Amount_with_Premium__c - totalchrg) ;
        
     system.debug('****** fees'+ fees );
    }
    system.debug('loan'+loan.Business_IRR__c);
  } 
}