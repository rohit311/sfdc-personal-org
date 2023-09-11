trigger UpdateBankSummary on Bank_Transaction__c (after insert,after update) {
if (!ControlRecursiveCallofTrigger_Util.hasAlreadyExecutedUpdateBankSummary()) {
//variable declaration
//3371
Set < String > DOCProducts = new Set < String > ();

Id LoanId;DateTime currentDate; Opportunity Loan;Integer summaryCount=0;String Product;integer flag=0;
Bank_Summary__c bankSummary= new  Bank_Summary__c();
List <Bank_Transaction__c> bankTransaction=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTransFirst=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTransSecond=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTransThird=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTransFourth=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTransFifth=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTransSixth=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTrans7th=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTrans8th=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTrans9th=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTrans10th=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTrans11th=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTrans12th=new List <Bank_Transaction__c> ();
List <Bank_Transaction__c> bankTrans13th=new List <Bank_Transaction__c> ();
List<Id> LoanIds=new List<Id>();
List<Opportunity> oppty=new List<Opportunity>();
for(Bank_Transaction__c bankTrans:trigger.new){
System.debug(bankTrans);
//LoanId=bankTrans.Loan_Application__c;
flag=0;
for(integer i=0;i<LoanIds.size();i++){
if(LoanIds[i]==bankTrans.Loan_Application__c)
flag=1;
}
if(flag==0)
LoanIds.add(bankTrans.Loan_Application__c);
//Loan=[select id,CreatedDate,pRODUCT__c from Opportunity where id=:LoanId];
//currentDate=bankTrans.Loan_Created_Date__c;
//Product=Loan.Product__C;
}
oppty=[Select Id,Product__C,CreatedDate from Opportunity where id in:LoanIds];
        for(integer i=0;i<oppty.size();i++){
    LOanId=oppty[i].Id;
   currentDate=oppty[i].CreatedDate;
//if(oppty[i].Product__c=='PSBL'){    
summaryCount=[Select count()
from Bank_Summary__c where Loan_Application__c=:LoanId];
DateTime currentDatecalc=currentDate;
integer currentMonthcalc =currentDatecalc.Month();
integer currentYearcalc =currentDatecalc.Year();
List<Integer> monthSet=new List<Integer>();
List<Integer> yearSet=new List<Integer>();

//3371
if (LaonApplicationCreation__c.getValues('Professional Loan Product') != null) {
            String Doc_LineProducts = LaonApplicationCreation__c.getValues('Professional Loan Product').ProfessionalLoan__c;
            if (Doc_LineProducts != null) {
                system.debug('***Doc_LineProducts***' + Doc_LineProducts);
                String[] arr = Doc_LineProducts.split(';');
                for (String str: arr) {
                    DOCProducts.add(str);
                }
            }
        }
    /*Start BUG-16959 added by sainath*/
    boolean isPSBLProductLineProduct = false;  
    transient string PSBLProductLineProducts = Label.PSBL_ProductLine_Products;
    if(PSBLProductLineProducts != null && PSBLProductLineProducts != '' )
    {
        set < string > setPSBLProdName = new set < string > ();
        setPSBLProdName.addAll(PSBLProductLineProducts.split(';'));
        if (setPSBLProdName != null && setPSBLProdName.size() > 0 && oppty[i] != null && oppty[i].Product__c != null) 
        {
            if(setPSBLProdName.contains(oppty[i].Product__c.toUpperCase()))
            isPSBLProductLineProduct = true; 
        }
    }
    /*End BUG-16959*/       

if(/*Bug: 16959 S*/ !isPSBLProductLineProduct /*Bug: 16959 E*/ && oppty[i].Product__c!='DOCTORS' && !DOCProducts.contains(oppty[i].Product__c.toUppercase()) && oppty[i].Product__c!='RDL')
{ currentMonthcalc=currentMonthcalc+1;  }

for(integer k=0;k<13;k++){
    if(currentMonthcalc==1){
currentMonthcalc=12;
currentYearcalc= currentYearcalc-1;
}else{
currentMonthcalc=currentMonthcalc-1;
currentYearcalc= currentYearcalc;
}
monthSet.add(currentMonthcalc);

String tmpYear = String.valueOf(currentYearcalc);
System.debug('tmpYear$$'+tmpYear.length());
if(tmpYear.length()== 4){
    currentYearcalc = Integer.valueOf(tmpYear.substring(2,tmpYear.length()));
}
yearSet.add(currentYearcalc);
system.debug('wwwwwwwwwwww'+currentYearcalc);
}//end of for
//Getting latest month data
System.debug('yearSet$$'+yearSet);
try{
bankTransaction=[Select Bounce_IW__c,Bounce_OW__c,CRD_No__c,CRD_Amount__c,
DB_No__c,DB_Amount__c,Month__c,Year__c from Bank_Transaction__c
where Loan_Application__c=:LoanId];

for(integer p=0;p<bankTransaction.size();p++){
  System.debug('monthSet[p] '+monthSet[p]);
  System.debug('yearSet[p] '+yearSet[p]);
  System.debug('bankTransaction[p] '+bankTransaction[p]);
 //getting first month data
  System.debug('bankTransaction[p].Month__c$$'+bankTransaction[p].Month__c);
  System.debug('bankTransaction[p].Year__c==yearSet[0]'+bankTransaction[p].Year__c+'---'+yearSet[0]);
  
  if(bankTransaction[p].Month__c==monthSet[0] && bankTransaction[p].Year__c==yearSet[0] )
   bankTransFirst.add(bankTransaction[p]);
  //getting sec month data
  if(bankTransaction[p].Month__c==monthSet[1] &&  bankTransaction[p].Year__c==yearSet[1] )
  bankTransSecond.add(bankTransaction[p]);
  //Getting latest month data-2
  if(bankTransaction[p].Month__c==monthSet[2] && bankTransaction[p].Year__c==yearSet[2] )
  bankTransThird.add(bankTransaction[p]);
  //Getting latest month data-3
  if(bankTransaction[p].Month__c==monthSet[3] &&  bankTransaction[p].Year__c==yearSet[3] )
  bankTransFourth.add(bankTransaction[p]);
  //Getting latest month data-4
  if(bankTransaction[p].Month__c==monthSet[4] &&  bankTransaction[p].Year__c==yearSet[4] )
  bankTransFifth.add(bankTransaction[p]);
  //Getting latest month data-5
  if(bankTransaction[p].Month__c==monthSet[5] &&  bankTransaction[p].Year__c==yearSet[5] )
  bankTransSixth.add(bankTransaction[p]); 
   //Getting latest month data-6
  if(bankTransaction[p].Month__c==monthSet[6] &&  bankTransaction[p].Year__c==yearSet[6] )
  bankTrans7th.add(bankTransaction[p]); 
  //Getting latest month data-7
  if(bankTransaction[p].Month__c==monthSet[7] &&  bankTransaction[p].Year__c==yearSet[7] )
  bankTrans8th.add(bankTransaction[p]); 
  //Getting latest month data-8
  if(bankTransaction[p].Month__c==monthSet[8] &&  bankTransaction[p].Year__c==yearSet[8] )
  bankTrans9th.add(bankTransaction[p]); 
  //Getting latest month data-9
  if(bankTransaction[p].Month__c==monthSet[9] &&  bankTransaction[p].Year__c==yearSet[9] )
  bankTrans10th.add(bankTransaction[p]); 
  //Getting latest month data-10
  if(bankTransaction[p].Month__c==monthSet[10] &&  bankTransaction[p].Year__c==yearSet[10] )
  bankTrans11th.add(bankTransaction[p]); 
  //Getting latest month data-11
  if(bankTransaction[p].Month__c==monthSet[11] &&  bankTransaction[p].Year__c==yearSet[11] )
  bankTrans12th.add(bankTransaction[p]); 
  //Getting latest month data-12
  if(bankTransaction[p].Month__c==monthSet[12] &&  bankTransaction[p].Year__c==yearSet[12] )
  bankTrans13th.add(bankTransaction[p]); 
 
  
  } //end of for
  system.debug('aaaaaa'+bankTransFirst.size());
  system.debug('bbbbbb'+bankTransSecond.size());
  system.debug('cccccc'+bankTransThird.size());
  system.debug('dddddd'+bankTransFourth.size());
  system.debug('eeeeeee'+bankTransFifth.size());
  system.debug('ffffff'+bankTransSixth.size());
  system.debug('gggggg'+bankTrans7th.size());
  system.debug('hhhhhh'+bankTrans8th.size());
  system.debug('iiiiii'+bankTrans9th.size());
  system.debug('fffffff'+bankTrans10th.size());
  system.debug('jjjjjjj'+bankTrans11th.size());
  system.debug('kkkkkkk'+bankTrans12th.size());
  system.debug('llllllll'+bankTrans13th.size());
}// end of try
catch(Exception e){}
integer bankTransFirstCount;integer bankTransSecondCount;integer bankTransThirdCount;integer bankTransFourthCount;
integer bankTransFifthCount;integer bankTransSixthCount;integer bankTrans7thCount;integer bankTrans8thCount;
integer bankTrans9thCount;integer bankTrans10thCount;integer bankTrans11thCount;integer bankTrans12thCount;
integer bankTrans13thCount;

bankTrans7thCount=bankTrans7th.size();bankTrans8thCount=bankTrans8th.size();bankTrans9thCount=bankTrans9th.size();bankTrans10thCount=bankTrans10th.size();
bankTrans11thCount=bankTrans11th.size();bankTrans12thCount=bankTrans12th.size();bankTrans13thCount=bankTrans13th.size();
bankTransSixthCount=bankTransSixth.size();bankTransFifthCount=bankTransFifth.size();bankTransFourthCount=bankTransFourth.size();bankTransThirdCount=bankTransThird.size();
bankTransSecondCount=bankTransSecond.size();bankTransFirstCount=bankTransFirst.size();
//declaring variables to store the sums of IW 
decimal SumofBounceIW1stmonth=0;decimal SumofBounceIW2ndmonth=0;decimal SumofBounceIW3rdmonth=0;
decimal SumofBounceIW4thmonth=0;decimal SumofBounceIW5thmonth=0;decimal SumofBounceIW6thmonth=0;
decimal SumofBounceIW7thmonth=0;decimal SumofBounceIW8thmonth=0;decimal SumofBounceIW9thmonth=0;
decimal SumofBounceIW10thmonth=0;decimal SumofBounceIW11thmonth=0;decimal SumofBounceIW12thmonth=0;
decimal SumofBounceIW13thmonth=0;
//declaring variables to store the sums of OW 
decimal SumofBounceOW1stmonth=0;decimal SumofBounceOW2ndmonth=0;decimal SumofBounceOW3rdmonth=0;
decimal SumofBounceOW4thmonth=0;decimal SumofBounceOW5thmonth=0;decimal SumofBounceOW6thmonth=0;
decimal SumofBounceOW7thmonth=0;decimal SumofBounceOW8thmonth=0;decimal SumofBounceOW9thmonth=0;
decimal SumofBounceOW10thmonth=0;decimal SumofBounceOW11thmonth=0;decimal SumofBounceOW12thmonth=0;
decimal SumofBounceOW13thmonth=0;
//declaring variables to store the sums of CRD No
decimal SumofCRDNo1stmonth=0;decimal SumofCRDNo2ndmonth=0;decimal SumofCRDNo3rdmonth=0;decimal SumofCRDNo4thmonth=0;
decimal SumofCRDNo5thmonth=0;decimal SumofCRDNo6thmonth=0;decimal SumofCRDNo7thmonth=0;decimal SumofCRDNo8thmonth=0;
decimal SumofCRDNo9thmonth=0;decimal SumofCRDNo10thmonth=0;decimal SumofCRDNo11thmonth=0;decimal SumofCRDNo12thmonth=0;
decimal SumofCRDNo13thmonth=0;
//declaring variables to store the sums of CRD Amount
decimal SumofCRDAmount1stmonth=0;decimal SumofCRDAmount2ndmonth=0;decimal SumofCRDAmount3rdmonth=0;
decimal SumofCRDAmount4thmonth=0;decimal SumofCRDAmount5thmonth=0;decimal SumofCRDAmount6thmonth=0;
decimal SumofCRDAmount7thmonth=0;decimal SumofCRDAmount8thmonth=0;decimal SumofCRDAmount9thmonth=0;
decimal SumofCRDAmount10thmonth=0;decimal SumofCRDAmount11thmonth=0;decimal SumofCRDAmount12thmonth=0;
decimal SumofCRDAmount13thmonth=0;
//declaring variables to store the sums of DB No
decimal SumofDBNo1stmonth=0;decimal SumofDBNo2ndmonth=0;decimal SumofDBNo3rdmonth=0;
decimal SumofDBNo4thmonth=0;decimal SumofDBNo5thmonth=0;decimal SumofDBNo6thmonth=0;
decimal SumofDBNo7thmonth=0;decimal SumofDBNo8thmonth=0;decimal SumofDBNo9thmonth=0;
decimal SumofDBNo10thmonth=0;decimal SumofDBNo11thmonth=0;decimal SumofDBNo12thmonth=0;
decimal SumofDBNo13thmonth=0;
//declaring variables to store the sums of DB Amount
decimal SumofDBAmount1stmonth=0;decimal SumofDBAmount2ndmonth=0;decimal SumofDBAmount3rdmonth=0;
decimal SumofDBAmount4thmonth=0;decimal SumofDBAmount5thmonth=0;decimal SumofDBAmount6thmonth=0;
decimal SumofDBAmount7thmonth=0;decimal SumofDBAmount8thmonth=0;decimal SumofDBAmount9thmonth=0;
decimal SumofDBAmount10thmonth=0;decimal SumofDBAmount11thmonth=0;decimal SumofDBAmount12thmonth=0;
decimal SumofDBAmount13thmonth=0;
//Getting the details of 7th month
if(bankTrans7thCount>0){
for (integer iSumBounce7=0;iSumBounce7<bankTrans7th.size();iSumBounce7++){
if(bankTrans7th[iSumBounce7].Bounce_IW__c!=null)
SumofBounceIW7thmonth=SumofBounceIW7thmonth+bankTrans7th[iSumBounce7].Bounce_IW__c;
if(bankTrans7th[iSumBounce7].Bounce_OW__c!=null)
SumofBounceOW7thmonth=SumofBounceOW7thmonth+bankTrans7th[iSumBounce7].Bounce_OW__c;
if(bankTrans7th[iSumBounce7].CRD_No__c!=null)
SumofCRDNo7thmonth=SumofCRDNo7thmonth+bankTrans7th[iSumBounce7].CRD_No__c;
if(bankTrans7th[iSumBounce7].CRD_Amount__c!=null)
SumofCRDAmount7thmonth=SumofCRDAmount7thmonth+bankTrans7th[iSumBounce7].CRD_Amount__c;
if(bankTrans7th[iSumBounce7].DB_Amount__c!=null)
SumofDBAmount7thmonth=SumofDBAmount7thmonth+bankTrans7th[iSumBounce7].DB_Amount__c;
if(bankTrans7th[iSumBounce7].DB_No__c!=null)
SumofDBNo7thmonth=SumofDBNo7thmonth+bankTrans7th[iSumBounce7].DB_No__c;
}}
//Getting the details of 13th month
if(bankTrans13thCount>0){
for (integer iSumBounce13=0;iSumBounce13<bankTrans13th.size();iSumBounce13++){
if(bankTrans13th[iSumBounce13].Bounce_IW__c!=null)
SumofBounceIW13thmonth=SumofBounceIW13thmonth+bankTrans13th[iSumBounce13].Bounce_IW__c;
if(bankTrans13th[iSumBounce13].Bounce_OW__c!=null)
SumofBounceOW13thmonth=SumofBounceOW13thmonth+bankTrans13th[iSumBounce13].Bounce_OW__c;
if(bankTrans13th[iSumBounce13].CRD_No__c!=null)
SumofCRDNo13thmonth=SumofCRDNo13thmonth+bankTrans13th[iSumBounce13].CRD_No__c;
if(bankTrans13th[iSumBounce13].CRD_Amount__c!=null)
SumofCRDAmount13thmonth=SumofCRDAmount13thmonth+bankTrans13th[iSumBounce13].CRD_Amount__c;
if(bankTrans13th[iSumBounce13].DB_Amount__c!=null)
SumofDBAmount13thmonth=SumofDBAmount13thmonth+bankTrans13th[iSumBounce13].DB_Amount__c;
if(bankTrans13th[iSumBounce13].DB_No__c!=null)
SumofDBNo13thmonth=SumofDBNo13thmonth+bankTrans13th[iSumBounce13].DB_No__c;
}}
//Getting the details of 12th month
if(bankTrans12thCount>0){
for (integer iSumBounce12=0;iSumBounce12<bankTrans12th.size();iSumBounce12++){
if(bankTrans12th[iSumBounce12].Bounce_IW__c!=null)
SumofBounceIW12thmonth=SumofBounceIW12thmonth+bankTrans12th[iSumBounce12].Bounce_IW__c;
if(bankTrans12th[iSumBounce12].Bounce_OW__c!=null)
SumofBounceOW12thmonth=SumofBounceOW12thmonth+bankTrans12th[iSumBounce12].Bounce_OW__c;
if(bankTrans12th[iSumBounce12].CRD_No__c!=null)
SumofCRDNo12thmonth=SumofCRDNo12thmonth+bankTrans12th[iSumBounce12].CRD_No__c;
if(bankTrans12th[iSumBounce12].CRD_Amount__c!=null)
SumofCRDAmount12thmonth=SumofCRDAmount12thmonth+bankTrans12th[iSumBounce12].CRD_Amount__c;
if(bankTrans12th[iSumBounce12].DB_Amount__c!=null)
SumofDBAmount12thmonth=SumofDBAmount12thmonth+bankTrans12th[iSumBounce12].DB_Amount__c;
if(bankTrans12th[iSumBounce12].DB_No__c!=null)
SumofDBNo12thmonth=SumofDBNo12thmonth+bankTrans12th[iSumBounce12].DB_No__c;
}}
//Getting the details of 11th month
if(bankTrans11thCount>0){
for (integer iSumBounce11=0;iSumBounce11<bankTrans11th.size();iSumBounce11++){
if(bankTrans11th[iSumBounce11].Bounce_IW__c!=null)
SumofBounceIW11thmonth=SumofBounceIW11thmonth+bankTrans11th[iSumBounce11].Bounce_IW__c;
if(bankTrans11th[iSumBounce11].Bounce_OW__c!=null)
SumofBounceOW11thmonth=SumofBounceOW11thmonth+bankTrans11th[iSumBounce11].Bounce_OW__c;
if(bankTrans11th[iSumBounce11].CRD_No__c!=null)
SumofCRDNo11thmonth=SumofCRDNo11thmonth+bankTrans11th[iSumBounce11].CRD_No__c;
if(bankTrans11th[iSumBounce11].CRD_Amount__c!=null)
SumofCRDAmount11thmonth=SumofCRDAmount11thmonth+bankTrans11th[iSumBounce11].CRD_Amount__c;
if(bankTrans11th[iSumBounce11].DB_Amount__c!=null)
SumofDBAmount11thmonth=SumofDBAmount11thmonth+bankTrans11th[iSumBounce11].DB_Amount__c;
if(bankTrans11th[iSumBounce11].DB_No__c!=null)
SumofDBNo11thmonth=SumofDBNo11thmonth+bankTrans11th[iSumBounce11].DB_No__c;
}}
//Getting the details of 10th month
if(bankTrans10thCount>0){
for (integer iSumBounce10=0;iSumBounce10<bankTrans10th.size();iSumBounce10++){
if(bankTrans10th[iSumBounce10].Bounce_IW__c!=null)
SumofBounceIW10thmonth=SumofBounceIW10thmonth+bankTrans10th[iSumBounce10].Bounce_IW__c;
if(bankTrans10th[iSumBounce10].Bounce_OW__c!=null)
SumofBounceOW10thmonth=SumofBounceOW10thmonth+bankTrans10th[iSumBounce10].Bounce_OW__c;
if(bankTrans10th[iSumBounce10].CRD_No__c!=null)
SumofCRDNo10thmonth=SumofCRDNo10thmonth+bankTrans10th[iSumBounce10].CRD_No__c;
if(bankTrans10th[iSumBounce10].CRD_Amount__c!=null)
SumofCRDAmount10thmonth=SumofCRDAmount10thmonth+bankTrans10th[iSumBounce10].CRD_Amount__c;
if(bankTrans10th[iSumBounce10].DB_Amount__c!=null)
SumofDBAmount10thmonth=SumofDBAmount10thmonth+bankTrans10th[iSumBounce10].DB_Amount__c;
if(bankTrans10th[iSumBounce10].DB_No__c!=null)
SumofDBNo10thmonth=SumofDBNo10thmonth+bankTrans10th[iSumBounce10].DB_No__c;
}}
//Getting the details of 9th month
if(bankTrans9thCount>0){
for (integer iSumBounce9=0;iSumBounce9<bankTrans9th.size();iSumBounce9++){
if(bankTrans9th[iSumBounce9].Bounce_IW__c!=null)
SumofBounceIW9thmonth=SumofBounceIW9thmonth+bankTrans9th[iSumBounce9].Bounce_IW__c;
if(bankTrans9th[iSumBounce9].Bounce_OW__c!=null)
SumofBounceOW9thmonth=SumofBounceOW9thmonth+bankTrans9th[iSumBounce9].Bounce_OW__c;
if(bankTrans9th[iSumBounce9].CRD_No__c!=null)
SumofCRDNo9thmonth=SumofCRDNo9thmonth+bankTrans9th[iSumBounce9].CRD_No__c;
if(bankTrans9th[iSumBounce9].CRD_Amount__c!=null)
SumofCRDAmount9thmonth=SumofCRDAmount9thmonth+bankTrans9th[iSumBounce9].CRD_Amount__c;
if(bankTrans9th[iSumBounce9].DB_Amount__c!=null)
SumofDBAmount9thmonth=SumofDBAmount9thmonth+bankTrans9th[iSumBounce9].DB_Amount__c;
if(bankTrans9th[iSumBounce9].DB_No__c!=null)
SumofDBNo9thmonth=SumofDBNo9thmonth+bankTrans9th[iSumBounce9].DB_No__c;
}}
//Getting the details of 8th month
if(bankTrans8thCount>0){
for (integer iSumBounce8=0;iSumBounce8<bankTrans8th.size();iSumBounce8++){
if(bankTrans8th[iSumBounce8].Bounce_IW__c!=null)
SumofBounceIW8thmonth=SumofBounceIW8thmonth+bankTrans8th[iSumBounce8].Bounce_IW__c;
if(bankTrans8th[iSumBounce8].Bounce_OW__c!=null)
SumofBounceOW8thmonth=SumofBounceOW8thmonth+bankTrans8th[iSumBounce8].Bounce_OW__c;
if(bankTrans8th[iSumBounce8].CRD_No__c!=null)
SumofCRDNo8thmonth=SumofCRDNo8thmonth+bankTrans8th[iSumBounce8].CRD_No__c;
if(bankTrans8th[iSumBounce8].CRD_Amount__c!=null)
SumofCRDAmount8thmonth=SumofCRDAmount8thmonth+bankTrans8th[iSumBounce8].CRD_Amount__c;
if(bankTrans8th[iSumBounce8].DB_Amount__c!=null)
SumofDBAmount8thmonth=SumofDBAmount8thmonth+bankTrans8th[iSumBounce8].DB_Amount__c;
if(bankTrans8th[iSumBounce8].DB_No__c!=null)
SumofDBNo8thmonth=SumofDBNo8thmonth+bankTrans8th[iSumBounce8].DB_No__c;
}}
//Getting the details of 1st month
if(bankTransSixthCount>0){
for (integer iSumBounce6=0;iSumBounce6<bankTransSixth.size();iSumBounce6++){
if(bankTransSixth[iSumBounce6].Bounce_IW__c!=null)
SumofBounceIW1stmonth=SumofBounceIW1stmonth+bankTransSixth[iSumBounce6].Bounce_IW__c;
if(bankTransSixth[iSumBounce6].Bounce_OW__c!=null)
SumofBounceOW1stmonth=SumofBounceOW1stmonth+bankTransSixth[iSumBounce6].Bounce_OW__c;
if(bankTransSixth[iSumBounce6].CRD_No__c!=null)
SumofCRDNo1stmonth=SumofCRDNo1stmonth+bankTransSixth[iSumBounce6].CRD_No__c;
if(bankTransSixth[iSumBounce6].CRD_Amount__c!=null)
SumofCRDAmount1stmonth=SumofCRDAmount1stmonth+bankTransSixth[iSumBounce6].CRD_Amount__c;
if(bankTransSixth[iSumBounce6].DB_Amount__c!=null)
SumofDBAmount1stmonth=SumofDBAmount1stmonth+bankTransSixth[iSumBounce6].DB_Amount__c;
if(bankTransSixth[iSumBounce6].DB_No__c!=null)
SumofDBNo1stmonth=SumofDBNo1stmonth+bankTransSixth[iSumBounce6].DB_No__c;
}}//Getting the details of 2nd month
if(bankTransFifthCount>0){
for (integer iSumBounce5=0;iSumBounce5<bankTransFifth.size();iSumBounce5++){
if(bankTransFifth[iSumBounce5].Bounce_IW__c!=null)
SumofBounceIW2ndmonth=SumofBounceIW2ndmonth+bankTransFifth[iSumBounce5].Bounce_IW__c;
if(bankTransFifth[iSumBounce5].Bounce_OW__c!=null)
SumofBounceOW2ndmonth=SumofBounceOW2ndmonth+bankTransFifth[iSumBounce5].Bounce_OW__c;
if(bankTransFifth[iSumBounce5].CRD_No__c!=null)
SumofCRDNo2ndmonth=SumofCRDNo2ndmonth+bankTransFifth[iSumBounce5].CRD_No__c;
if(bankTransFifth[iSumBounce5].CRD_Amount__c!=null)
SumofCRDAmount2ndmonth=SumofCRDAmount2ndmonth+bankTransFifth[iSumBounce5].CRD_Amount__c;
if(bankTransFifth[iSumBounce5].DB_Amount__c!=null)
SumofDBAmount2ndmonth=SumofDBAmount2ndmonth+bankTransFifth[iSumBounce5].DB_Amount__c;
if(bankTransFifth[iSumBounce5].DB_No__c!=null)
SumofDBNo2ndmonth=SumofDBNo2ndmonth+bankTransFifth[iSumBounce5].DB_No__c;
}}
//Getting the details of 3rd month
if(bankTransFourthCount>0){
for (integer iSumBounce4=0;iSumBounce4<bankTransFourth.size();iSumBounce4++){
if(bankTransFourth[iSumBounce4].Bounce_IW__c!=null)
SumofBounceIW3rdmonth=SumofBounceIW3rdmonth+bankTransFourth[iSumBounce4].Bounce_IW__c;
if(bankTransFourth[iSumBounce4].Bounce_OW__c!=null)
SumofBounceOW3rdmonth=SumofBounceOW3rdmonth+bankTransFourth[iSumBounce4].Bounce_OW__c;
if(bankTransFourth[iSumBounce4].CRD_No__c!=null)
SumofCRDNo3rdmonth=SumofCRDNo3rdmonth+bankTransFourth[iSumBounce4].CRD_No__c;
if(bankTransFourth[iSumBounce4].CRD_Amount__c!=null)
SumofCRDAmount3rdmonth=SumofCRDAmount3rdmonth+bankTransFourth[iSumBounce4].CRD_Amount__c;
if(bankTransFourth[iSumBounce4].DB_Amount__c!=null)
SumofDBAmount3rdmonth=SumofDBAmount3rdmonth+bankTransFourth[iSumBounce4].DB_Amount__c;
if(bankTransFourth[iSumBounce4].DB_No__c!=null)
SumofDBNo3rdmonth=SumofDBNo3rdmonth+bankTransFourth[iSumBounce4].DB_No__c;
}}
//Getting the details of 4th month
if(bankTransThirdCount>0){
for (integer iSumBounce3=0;iSumBounce3<bankTransThird.size();iSumBounce3++){
    if(bankTransThird[iSumBounce3].Bounce_IW__c!=null)
SumofBounceIW4thmonth=SumofBounceIW4thmonth+bankTransThird[iSumBounce3].Bounce_IW__c;
if(bankTransThird[iSumBounce3].Bounce_OW__c!=null)
SumofBounceOW4thmonth=SumofBounceOW4thmonth+bankTransThird[iSumBounce3].Bounce_OW__c;
if(bankTransThird[iSumBounce3].CRD_No__c!=null)
SumofCRDNo4thmonth=SumofCRDNo4thmonth+bankTransThird[iSumBounce3].CRD_No__c;
if(bankTransThird[iSumBounce3].CRD_Amount__c!=null)
SumofCRDAmount4thmonth=SumofCRDAmount4thmonth+bankTransThird[iSumBounce3].CRD_Amount__c;
if(bankTransThird[iSumBounce3].DB_Amount__c!=null)
SumofDBAmount4thmonth=SumofDBAmount4thmonth+bankTransThird[iSumBounce3].DB_Amount__c;
if(bankTransThird[iSumBounce3].DB_No__c!=null)
SumofDBNo4thmonth=SumofDBNo4thmonth+bankTransThird[iSumBounce3].DB_No__c;
}}
//Getting the details of 5th month
if(bankTransSecondCount>0){
for (integer iSumBounce2=0;iSumBounce2<bankTransSecond.size();iSumBounce2++){
if(bankTransSecond[iSumBounce2].Bounce_IW__c!=null)
SumofBounceIW5thmonth=SumofBounceIW5thmonth+bankTransSecond[iSumBounce2].Bounce_IW__c;
if(bankTransSecond[iSumBounce2].Bounce_OW__c!=null)
SumofBounceOW5thmonth=SumofBounceOW5thmonth+bankTransSecond[iSumBounce2].Bounce_OW__c;
if(bankTransSecond[iSumBounce2].CRD_No__c!=null)
SumofCRDNo5thmonth=SumofCRDNo5thmonth+bankTransSecond[iSumBounce2].CRD_No__c;
if(bankTransSecond[iSumBounce2].CRD_Amount__c!=null)
SumofCRDAmount5thmonth=SumofCRDAmount5thmonth+bankTransSecond[iSumBounce2].CRD_Amount__c;
if(bankTransSecond[iSumBounce2].DB_Amount__c!=null)
SumofDBAmount5thmonth=SumofDBAmount5thmonth+bankTransSecond[iSumBounce2].DB_Amount__c;
if(bankTransSecond[iSumBounce2].DB_No__c!=null)
SumofDBNo5thmonth=SumofDBNo5thmonth+bankTransSecond[iSumBounce2].DB_No__c;
}}
//Getting the details of 6th month
if(bankTransFirstCount>0){
for (integer iSumBounce1=0;iSumBounce1<bankTransFirst.size();iSumBounce1++){
if(bankTransFirst[iSumBounce1].Bounce_IW__c!=null)
SumofBounceIW6thmonth=SumofBounceIW6thmonth+bankTransFirst[iSumBounce1].Bounce_IW__c;
if(bankTransFirst[iSumBounce1].Bounce_OW__c!=null)
SumofBounceOW6thmonth=SumofBounceOW6thmonth+bankTransFirst[iSumBounce1].Bounce_OW__c;
if(bankTransFirst[iSumBounce1].CRD_No__c!=null)
SumofCRDNo6thmonth=SumofCRDNo6thmonth+bankTransFirst[iSumBounce1].CRD_No__c;
if(bankTransFirst[iSumBounce1].CRD_Amount__c!=null)
SumofCRDAmount6thmonth=SumofCRDAmount6thmonth+bankTransFirst[iSumBounce1].CRD_Amount__c;
if(bankTransFirst[iSumBounce1].DB_Amount__c!=null)
SumofDBAmount6thmonth=SumofDBAmount6thmonth+bankTransFirst[iSumBounce1].DB_Amount__c;
if(bankTransFirst[iSumBounce1].DB_No__c!=null)
SumofDBNo6thmonth=SumofDBNo6thmonth+bankTransFirst[iSumBounce1].DB_No__c;
}}
if(summaryCount > 0){
bankSummary=[Select Sum_of_Bounce_IW_1st_of_month__c,Sum_of_Bounce_IW_2nd_of_month__c,Sum_of_Bounce_IW_3rd_of_month__c,Sum_of_Bounce_IW_4th_of_month__c,Sum_of_Bounce_IW_5th_of_month__c,Sum_of_Bounce_IW_6th_of_month__c,
Sum_of_Bounce_OW_1st_of_month__c,Sum_of_Bounce_OW_2nd_of_month__c,Sum_of_Bounce_OW_3rd_of_month__c, Sum_of_Bounce_OW_4th_of_month__c,Sum_of_Bounce_OW_5th_of_month__c,Sum_of_Bounce_OW_6th_of_month__c,Sum_of_CRD_Amount_1st_of_month__c,Sum_of_CRD_Amount_2nd_of_month__c,Sum_of_CRD_Amount_3rd_of_month__c,Sum_of_CRD_Amount_4th_of_month__c,Sum_of_CRD_Amount_5th_of_month__c,Sum_of_CRD_Amount_6th_of_month__c,Sum_of_CRD_No_1st_of_month__c,Sum_of_CRD_No_2nd_of_month__c,Sum_of_CRD_No_3rd_of_month__c,Sum_of_CRD_No_4th_of_month__c,
Sum_of_CRD_No_5th_of_month__c,Sum_of_CRD_No_6th_of_month__c,Sum_of_DB_Amount_1st_of_month__c,Sum_of_DB_Amount_2nd_of_month__c,Sum_of_DB_Amount_3rd_of_month__c,Sum_of_DB_Amount_4th_of_month__c,Sum_of_DB_Amount_5th_of_month__c,Sum_of_DB_Amount_6th_of_month__c,Sum_of_DB_No_1st_of_month__c,Sum_of_DB_No_2nd_of_month__c,Sum_of_DB_No_3rd_of_month__c,Sum_of_DB_No_4th_of_month__c,Sum_of_DB_No_5th_of_month__c,Sum_of_DB_No_6th_of_month__c,month1__c,month2__c,month3__c,month4__c,month5__c,month6__c,
year1__c,year2__c,year3__c,year4__c,year5__c,year6__c,year13__c,Sum_of_CRD_No_7th_of_month__c,Sum_of_CRD_No_8th_of_month__C,Sum_of_CRD_No_9th_of_month__C,Sum_of_CRD_No_10th_of_month__C,Sum_of_CRD_No_11th_of_month__c,Sum_of_CRD_No_12th_of_month__c,Sum_of_CRD_Amount_7th_of_month__c,Sum_of_CRD_Amount_8th_of_month__c,Sum_of_CRD_Amount_9th_of_month__c,Sum_of_CRD_Amount_10th_of_month__c,Sum_of_CRD_Amount_11th_of_month__c,Sum_of_CRD_Amount_12th_of_month__C,Sum_of_DB_Amount_7th_of_month__C,Sum_of_DB_Amount_8th_of_month__C,
Sum_of_DB_Amount_9th_of_month__c,Sum_of_DB_Amount_10th_of_month__C,Sum_of_DB_Amount_11th_of_month__c,Sum_of_DB_Amount_12th_of_month__c,Sum_of_DB_No_7th_of_month__C,Sum_of_DB_No_8th_of_month__C,Sum_of_DB_No_9th_of_month__c,Sum_of_DB_No_10th_of_month__c,Sum_of_DB_No_11th_of_month__c,Sum_of_DB_No_12th_of_month__C,Sum_of_Bounce_IW_7th_of_month__C,Sum_of_Bounce_IW_8th_of_month__C,Sum_of_Bounce_IW_9th_of_month__c,Sum_of_Bounce_IW_10th_of_month__c,Sum_of_Bounce_IW_11th_of_month__c,Sum_of_Bounce_IW_12th_of_month__c,
Sum_of_Bounce_OW_7th_of_month__c,Sum_of_Bounce_OW_8th_of_month__C,Sum_of_Bounce_OW_9th_of_month__C,Sum_of_Bounce_OW_10th_of_month__C,Sum_of_Bounce_OW_11th_of_month__C,Sum_of_Bounce_OW_12th_of_month__C,month7__c,month8__c,month9__c,month10__c,month11__c,month12__c,month13__c,year7__c,year8__c,year9__c,year10__c,year11__c,year12__c,Sum_of_Bounce_IW_13th_of_month__C,Sum_of_Bounce_OW_13th_of_month__c,Sum_of_CRD_No_13th_of_month__c,
Sum_of_DB_No_13th_of_month__C,Sum_of_CRD_Amount_13th_of_month__c
from Bank_Summary__c where Loan_Application__c=:LoanId];
}
else{
bankSummary.Loan_Application__c=LoanId;
}
System.debug('monthSet$$'+monthSet);
bankSummary.month1__c=monthSet[5];bankSummary.month2__c=monthSet[4];bankSummary.month3__c=monthSet[3];
bankSummary.month4__c=monthSet[2];bankSummary.month5__c=monthSet[1];bankSummary.month6__c=monthSet[0];
bankSummary.month7__c=monthSet[6];bankSummary.month8__c=monthSet[7];bankSummary.month9__c=monthSet[8];
bankSummary.month10__c=monthSet[9];bankSummary.month11__c=monthSet[10];bankSummary.month12__c=monthSet[11];
bankSummary.month13__c=monthSet[12];

bankSummary.year1__c=String.valueof(yearSet[5]);bankSummary.year2__c=String.valueof(yearSet[4]);  
bankSummary.year3__c=String.valueof(yearSet[3]);bankSummary.year4__c=String.valueof(yearSet[2]);  
bankSummary.year5__c=String.valueof(yearSet[1]);bankSummary.year6__c=String.valueof(yearSet[0]);  
bankSummary.year7__c=String.valueof(yearSet[6]); bankSummary.year8__c=String.valueof(yearSet[7]);  
bankSummary.year9__c=String.valueof(yearSet[8]);  bankSummary.year10__c=String.valueof(yearSet[9]);  
bankSummary.year11__c=String.valueof(yearSet[10]); bankSummary.year12__c=String.valueof(yearSet[11]); 
bankSummary.year13__c=String.valueof(yearSet[12]);  
//updating IW Bounce Sum       
bankSummary.Sum_of_Bounce_IW_1st_of_month__c=SumofBounceIW1stmonth;bankSummary.Sum_of_Bounce_IW_2nd_of_month__c=SumofBounceIW2ndmonth;
bankSummary.Sum_of_Bounce_IW_3rd_of_month__c=SumofBounceIW3rdmonth;bankSummary.Sum_of_Bounce_IW_4th_of_month__c=SumofBounceIW4thmonth;
bankSummary.Sum_of_Bounce_IW_5th_of_month__c=SumofBounceIW5thmonth;bankSummary.Sum_of_Bounce_IW_6th_of_month__c=SumofBounceIW6thmonth;
bankSummary.Sum_of_Bounce_IW_7th_of_month__c=SumofBounceIW7thmonth;bankSummary.Sum_of_Bounce_IW_8th_of_month__c=SumofBounceIW8thmonth;
bankSummary.Sum_of_Bounce_IW_9th_of_month__c=SumofBounceIW9thmonth;bankSummary.Sum_of_Bounce_IW_10th_of_month__c=SumofBounceIW10thmonth;
bankSummary.Sum_of_Bounce_IW_11th_of_month__c=SumofBounceIW11thmonth;bankSummary.Sum_of_Bounce_IW_12th_of_month__c=SumofBounceIW12thmonth;
bankSummary.Sum_of_Bounce_IW_13th_of_month__c=SumofBounceIW13thmonth;
//updating OW Bounce Sum
bankSummary.Sum_of_Bounce_OW_1st_of_month__c=SumofBounceOW1stmonth;bankSummary.Sum_of_Bounce_OW_2nd_of_month__c=SumofBounceOW2ndmonth;
bankSummary.Sum_of_Bounce_OW_3rd_of_month__c=SumofBounceOW3rdmonth;bankSummary.Sum_of_Bounce_OW_4th_of_month__c=SumofBounceOW4thmonth;
bankSummary.Sum_of_Bounce_OW_5th_of_month__c=SumofBounceOW5thmonth;bankSummary.Sum_of_Bounce_OW_6th_of_month__c=SumofBounceOW6thmonth;
bankSummary.Sum_of_Bounce_OW_7th_of_month__c=SumofBounceOW7thmonth;bankSummary.Sum_of_Bounce_OW_8th_of_month__c=SumofBounceOW8thmonth;
bankSummary.Sum_of_Bounce_OW_9th_of_month__c=SumofBounceOW9thmonth;bankSummary.Sum_of_Bounce_OW_10th_of_month__c=SumofBounceOW10thmonth;
bankSummary.Sum_of_Bounce_OW_11th_of_month__c=SumofBounceOW11thmonth;bankSummary.Sum_of_Bounce_OW_12th_of_month__c=SumofBounceOW12thmonth;
bankSummary.Sum_of_Bounce_OW_13th_of_month__c=SumofBounceOW13thmonth;
//updating CRD No
bankSummary.Sum_of_CRD_No_1st_of_month__c=SumofCRDNo1stmonth;bankSummary.Sum_of_CRD_No_2nd_of_month__c=SumofCRDNo2ndmonth;
bankSummary.Sum_of_CRD_No_3rd_of_month__c=SumofCRDNo3rdmonth;bankSummary.Sum_of_CRD_No_4th_of_month__c=SumofCRDNo4thmonth;
bankSummary.Sum_of_CRD_No_5th_of_month__c=SumofCRDNo5thmonth;bankSummary.Sum_of_CRD_No_6th_of_month__c=SumofCRDNo6thmonth;
bankSummary.Sum_of_CRD_No_7th_of_month__c=SumofCRDNo7thmonth;bankSummary.Sum_of_CRD_No_8th_of_month__c=SumofCRDNo8thmonth;
bankSummary.Sum_of_CRD_No_9th_of_month__c=SumofCRDNo9thmonth;bankSummary.Sum_of_CRD_No_10th_of_month__c=SumofCRDNo10thmonth;
bankSummary.Sum_of_CRD_No_11th_of_month__c=SumofCRDNo11thmonth;bankSummary.Sum_of_CRD_No_12th_of_month__c=SumofCRDNo12thmonth;
bankSummary.Sum_of_CRD_No_13th_of_month__c=SumofCRDNo13thmonth;
//updating CRD Amount
bankSummary.Sum_of_CRD_Amount_1st_of_month__c=SumofCRDAmount1stmonth;bankSummary.Sum_of_CRD_Amount_2nd_of_month__c=SumofCRDAmount2ndmonth;
bankSummary.Sum_of_CRD_Amount_3rd_of_month__c=SumofCRDAmount3rdmonth;bankSummary.Sum_of_CRD_Amount_4th_of_month__c=SumofCRDAmount4thmonth;
bankSummary.Sum_of_CRD_Amount_5th_of_month__c=SumofCRDAmount5thmonth;bankSummary.Sum_of_CRD_Amount_6th_of_month__c=SumofCRDAmount6thmonth;
bankSummary.Sum_of_CRD_Amount_7th_of_month__c=SumofCRDAmount7thmonth;bankSummary.Sum_of_CRD_Amount_8th_of_month__c=SumofCRDAmount8thmonth;
bankSummary.Sum_of_CRD_Amount_9th_of_month__c=SumofCRDAmount9thmonth;bankSummary.Sum_of_CRD_Amount_10th_of_month__c=SumofCRDAmount10thmonth;
bankSummary.Sum_of_CRD_Amount_11th_of_month__c=SumofCRDAmount11thmonth;bankSummary.Sum_of_CRD_Amount_12th_of_month__c=SumofCRDAmount12thmonth;
bankSummary.Sum_of_CRD_Amount_13th_of_month__c=SumofCRDAmount13thmonth;
//Updating DB Amount
bankSummary.Sum_of_DB_Amount_1st_of_month__c=SumofDBAmount1stmonth;bankSummary.Sum_of_DB_Amount_2nd_of_month__c=SumofDBAmount2ndmonth;
bankSummary.Sum_of_DB_Amount_3rd_of_month__c=SumofDBAmount3rdmonth;bankSummary.Sum_of_DB_Amount_4th_of_month__c=SumofDBAmount4thmonth;
bankSummary.Sum_of_DB_Amount_5th_of_month__c=SumofDBAmount5thmonth;bankSummary.Sum_of_DB_Amount_6th_of_month__c=SumofDBAmount6thmonth;
bankSummary.Sum_of_DB_Amount_7th_of_month__c=SumofDBAmount7thmonth;bankSummary.Sum_of_DB_Amount_8th_of_month__c=SumofDBAmount8thmonth;
bankSummary.Sum_of_DB_Amount_9th_of_month__c=SumofDBAmount9thmonth;bankSummary.Sum_of_DB_Amount_10th_of_month__c=SumofDBAmount10thmonth;
bankSummary.Sum_of_DB_Amount_11th_of_month__c=SumofDBAmount11thmonth;bankSummary.Sum_of_DB_Amount_12th_of_month__c=SumofDBAmount12thmonth;
bankSummary.Sum_of_DB_Amount_13th_of_month__c=SumofDBAmount13thmonth;
//Updating DB No
bankSummary.Sum_of_DB_No_1st_of_month__c=SumofDBNo1stmonth;bankSummary.Sum_of_DB_No_2nd_of_month__c=SumofDBNo2ndmonth;
bankSummary.Sum_of_DB_No_3rd_of_month__c=SumofDBNo3rdmonth;bankSummary.Sum_of_DB_No_4th_of_month__c=SumofDBNo4thmonth;
bankSummary.Sum_of_DB_No_5th_of_month__c=SumofDBNo5thmonth;bankSummary.Sum_of_DB_No_6th_of_month__c=SumofDBNo6thmonth;
bankSummary.Sum_of_DB_No_7th_of_month__c=SumofDBNo7thmonth;bankSummary.Sum_of_DB_No_8th_of_month__c=SumofDBNo8thmonth;
bankSummary.Sum_of_DB_No_9th_of_month__c=SumofDBNo9thmonth;bankSummary.Sum_of_DB_No_10th_of_month__c=SumofDBNo10thmonth;
bankSummary.Sum_of_DB_No_11th_of_month__c=SumofDBNo11thmonth;bankSummary.Sum_of_DB_No_12th_of_month__c=SumofDBNo12thmonth;
bankSummary.Sum_of_DB_No_13th_of_month__c=SumofDBNo13thmonth;
System.debug('bankSummary$$$ '+bankSummary);
if(summaryCount > 0){
ControlRecursiveCallofTrigger_Util.setAlreadyExecutedUpdateBankSummary();
update bankSummary;
}
    else{
        ControlRecursiveCallofTrigger_Util.setAlreadyExecutedUpdateBankSummary();
        insert bankSummary;
}}// end of oppty loop
system.debug('wwwwww'+bankSummary.DB_count__c);
        }

}//end of class