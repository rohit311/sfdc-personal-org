public without sharing class EmployeeLoanAutomationCtrl {
	public static transient SavePoint savepointvar;
	public static Decimal netDisbursementAmount;

	//Added by Aniket Start
	public static Product_Offerings__c productOffer {
		get;
		set;
	}
	public static String poId {
		get;
		set;
	}

	public string EmployeeId {
		get;
		set;

	}
	public string MobileNo {
		get;
		set;

	}
	public EmployeeLoanAutomationCtrl() {}

	public PageReference authenticateURLReference(){
		try{
			Map<String, String> headerMap = (Map<String, String>) ApexPages.currentPage().getHeaders();

			for(string key: headerMap.keySet()){
				System.debug(key+' : '+headerMap.get(key));
			}

			String refererURL =  headerMap.get('Referer');
			if(refererURL!=null && refererURL.endsWithIgnoreCase('EmployeeLoginPage')){
				return null;    
			}else{

				PageReference refererPageRef = new PageReference(Label.BflsiteuserURL+'/EmployeeLoginPage');
				System.debug('refererPageRef : '+refererPageRef);
				refererPageRef.setRedirect(true);    
				return refererPageRef;
			}   
		}catch(Exception e){
			System.debug('Exception in authenticateURLReference : '+e);
			return null; 
		}   
	}

	public class MobileNumberWrapper {
		public String encryptedMob;
		public String mobileToShow;
	}

	@AuraEnabled
	public static String GetEmployeeMobileNo(String EmployeeID) {
		MobileNumberWrapper mss=new MobileNumberWrapper();
		System.debug('employeid' + EmployeeId);
		List < Performance_reports__c > EmpDetailList = new list < Performance_reports__c > ();
		EmpDetailList = [Select Mobile__c from Performance_reports__c where EmployeeId__c =: EmployeeId AND Offer_status__c = 'LIVE' order by createdDate desc];
		if (EmpDetailList != null && EmpDetailList.size() > 0) {
			System.debug('employeid' + EmpDetailList[0].id);
			String MobileNo = EmpDetailList[0].Mobile__c;
			mss.mobileToShow='XXXXXXX'+MobileNo.substring(MobileNo.length()-3,MobileNo.length());
			mss.encryptedMob=CommonUtility.EncryptURLParam(EmpDetailList[0].Mobile__c);
			System.debug('After encr'+mss);
			return JSON.serialize(mss);

			//System.debug('MobileNo '+MobileNo);
		}
		return 'NO DATA';
	}
	@AuraEnabled
	public static String encryptEmpId(String EmployeeID) {

		String encrID= CommonUtility.encryptURLParam(EmployeeID);
		System.debug('encrypted employeid' + encrID);
		return encrID;
	}
	@AuraEnabled
	public static String decryptEmpId(String EmployeeID) {

		String decrID= CommonUtility.decryptURLParam(EmployeeID);
		System.debug('decryptURLParam employeid' + decrID);

		return decrID;
	}


	public static String GenerateOTP() {
		double y = Math.random(); //between 0 and 1
		y = 9999 * y;
		integer index = math.round(y); //something between 0 and 9999
		String indexStr = String.valueof(index);
		System.debug('indexStr==' + indexStr);
		if (indexStr.length() == 3) {
			indexStr = indexStr + '0';
		}
		if (indexStr.length() == 2) {
			indexStr = indexStr + '00';
		}
		if (indexStr.length() == 1) {
			indexStr = indexStr + '000';
		}
		return indexStr;
	}

	@AuraEnabled 
	public static String sendOTP(String mobNumber, String EmployeeID) {
		String tempMob=CommonUtility.decryptURLParam(mobNumber);
		List<Performance_reports__c> PerformanceReport = [Select ID,login_attempts__c, Mobile__c, EmployeeId__c, One_Time_Password__c from Performance_reports__c where EmployeeId__c =: EmployeeId AND Mobile__c =: tempMob AND Offer_status__c = 'LIVE' order by createdDate desc LIMIT 1];
		if(!CommonUtility.isEmpty(PerformanceReport) && PerformanceReport[0].login_attempts__c > 3 )
		{
			return 'too many attempts';
		}
		/*if(CommonUtility.isEmpty(PerformanceReport) ){
PerformanceReport = [Select ID, Mobile__c, EmployeeId__c, One_Time_Password__c from Performance_reports__c where EmployeeId__c =: EmployeeId AND Mobile__c =: mobNumber AND Offer_converted__c = true order by createdDate desc LIMIT 1];
}*/
		String VerCode = GenerateOTP();
		Map<String,Object> maps=CommonUtility.getMapFromStaticResource('EmployeeLoanStaticResource','EmployeeLoan');
		String smsText =  String.valueOf(maps.get('DefaultOTPMessage'));
		smsText=smsText.replace('XXXXXX',VerCode);
		if (tempMob != '') {
			if (!Test.isRunningTest()) {

				sendsms.message(tempMob, smsText);
			}
		}
		if(!CommonUtility.isEmpty(PerformanceReport) ){
			PerformanceReport[0].One_Time_Password__c = VerCode;
			if(PerformanceReport[0].login_attempts__c == null)   PerformanceReport[0].login_attempts__c=0;
			PerformanceReport[0].login_attempts__c=PerformanceReport[0].login_attempts__c+1;
			update PerformanceReport;
		}
		return 'OTP Sent';
	}
	@AuraEnabled
	public static String validateOTP(String EmployeeID, String OTP) {
		Performance_reports__c PerformanceReport = [Select ID,login_attempts__c, Mobile__c, EmployeeId__c, One_Time_Password__c from Performance_reports__c where EmployeeId__c =: EmployeeId AND Offer_status__c = 'LIVE' order by createdDate desc LIMIT 1];
		/*if(CommonUtility.isEmpty(PerformanceReport) ){
PerformanceReport = [Select ID, Mobile__c, EmployeeId__c, One_Time_Password__c from Performance_reports__c where EmployeeId__c =: EmployeeId AND Offer_converted__c = true order by createdDate desc LIMIT 1];
}*/
		if (PerformanceReport != null && PerformanceReport.One_Time_Password__c == OTP && PerformanceReport.login_attempts__c!=null && PerformanceReport.login_attempts__c<=3)
		{
			PerformanceReport.login_attempts__c=0; //reset to successful login
			update PerformanceReport;
			return 'Login Successfull';
		}
		else if(PerformanceReport.login_attempts__c!=null && PerformanceReport.login_attempts__c>3)
		{
			return 'Account locked'; 
		}
		else
			return 'Login failed';

	}

	@AuraEnabled
	public static String getOppList(String empId) {
		Set<Id> oppId = new Set<Id>();
		list<Performance_reports__c> prtList =[select Loan_Application_Number__c from Performance_reports__c where EmployeeId__c =: empId];
		for(Performance_reports__c pp:prtList){

			if(!CommonUtility.isEmpty(pp.Loan_Application_Number__c)){
				oppId.add(pp.Loan_Application_Number__c);
				system.debug('here '+pp);
			}
		}

		list <Applicant__c> AppList = [select Loan_Application__r.Id,Loan_Application__c,Loan_Application__r.Loan_Application_Number__c,Loan_Application__r.Name,Application_Form_Timestamp__c,IP_Address_Timestamp__c,KYC_Verifications__c,Loan_Application__r.stageName  from Applicant__c where Loan_Application__c IN: oppId] ;         

		System.debug('List opp id is '+oppId);

		return JSON.serialize(AppList);
	}
	@AuraEnabled
	public static String getEmployeeOffer(String EmployeeId, String objectFieldJSON) {
		EmpLoanWrapper EmpWrap = new EmpLoanWrapper(); 
		list<Performance_reports__c> prlistAll = [SELECT Id,login_attempts__c, EmployeeId__c, Name, Approved_Amt__c, Approved_Tenor__c, Loan_Type__c,Rate__c, Offer_status__c, Offer_converted__c, Bank_Acct_Number__c, Disbursement_Payment_Mode__c, Employee_Name__c, Bank_Name__c, Current_Address1__c, Current_Address2__c, Current_Address3__c, City__c, Pin_code__c, State__c,Loan_Application_Number__c,Loan_Application_Number__r.StageName ,Availed_Tenor__c FROM Performance_reports__c where EmployeeId__c =: EmployeeId order by createdDate desc];
		system.debug('Employee PO List '+prlistAll);
		EmpWrap.picklistData = LighteningUtilities.getPicklistValues(objectFieldJSON);
		List<String> feesAndCharges = (CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','ProcessingFee','')).split(';');
		// List<String> rate = (CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','Rate','')).split(';');
		// List<String> welcomemessage1 = (CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','WelcomeMessage1','')).split(';');
		// List<String> welcomemessage2 = (CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','WelcomeMessage2','')).split(';');

		if(prlistAll!=null && prlistAll.size()>0){
			EmpWrap.isLAOpen=false;
			EmpWrap.isNonDisbursed=false;
			for(Performance_reports__c prObj :prlistAll){
				if(prObj.Loan_Application_Number__c!=null && prObj.Loan_Application_Number__r.StageName!=null){
					EmpWrap.isLAOpen=true;
				}
				if(prObj.Loan_Application_Number__c!=null && prObj.Loan_Application_Number__r.StageName !='Branch Ops' && prObj.Loan_Application_Number__r.StageName !='Moved To Finnone'){
					EmpWrap.isNonDisbursed=true;
					System.debug('Non disbursed found');
				}
				if(prObj.Loan_Application_Number__c!=null && prObj.Loan_Application_Number__r.StageName =='DSA/PSF Login')
				{
					EmpWrap.stageOfLoan='DSA/PSF Login';
				}

			}

			EmpWrap.perList=prlistAll[0];
			if(prlistAll[0]!=null && prlistAll[0].Offer_converted__c==true){
				System.debug('Loan Application number is '+prlistAll[0].Id);
				Applicant__c appRec=[select id,Employee_Modified__c from Applicant__c where Loan_Application__c=:prlistAll[0].Loan_Application_Number__c limit 1];
				if(appRec!=null && appRec.Employee_Modified__c!=null)
					EmpWrap.primaryApplicant=appRec;
			}       
			EmpWrap.perList=prlistAll[0];
			// prlistAll[0].login_attempts__c=0; //successful attempt, so set zero
			//prlistAll[0].login_attempts__c= prlistAll[0].login_attempts__c+1;
			// update prlistAll[0];
		}
		EmpWrap.processingFee=feesAndCharges[0];
		//EmpWrap.rate=rate[0];
		// EmpWrap.welcomemessage1 =welcomemessage1[0];
		// EmpWrap.welcomemessage2=welcomemessage2[0].replace('#***#',String.valueOf(EmpWrap.perList.Approved_Amt__c));
		return JSON.serialize(EmpWrap);
	}

	public PageReference loadEmpHome() {

		PageReference pr = new PageReference('/apex/EmployeeLoansLanding_VF');
		pr.getParameters().put('recordID', 'EmployeeId');
		pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
		return pr;
	}


	@AuraEnabled
	public static String getEmandateState(String oppId){
		System.debug('OppId '+OppId);
		RePayment_mode_detail__c repayObj=[select id,UMRN__c,Loan_Application__c,Loan_Application__r.Account.Mobile__c from RePayment_mode_detail__c where Loan_Application__c =: OppId order by lastModifiedDate desc limit 1];
		System.debug('Emandate value is '+repayObj);
		if(repayObj!=null)
			return JSON.serialize(repayObj);
		return 'failed';
	}
	@AuraEnabled
	public static String ConvertOffer(String OfferObj, String RejectReasons, String SchemeId, String EMI, String InitEmi, String SubEmi, String InitTenor, String SubTenor, String Fees, String availedAmount) {
		system.debug('in convertOffer '+OfferObj);
		savepointvar = Database.setSavepoint();     Performance_Reports__c offer ;     try {
			offer = (Performance_Reports__c)Json.deserialize(OfferObj,Performance_reports__c.class);
			//Scheme_Master__c schemeObj = (Scheme_Master__c)Json.deserialize(SchemeObj,Scheme_Master__c.class);


			offer.Availed_amount__c = Decimal.valueOf(availedAmount);
			if(offer.loan_type__c != null && offer.loan_type__c.tolowercase() == 'hybrid loan' && !Commonutility.isEmpty(Integer.valueOf(InitTenor)))
			{
				//offer.Availed_Tenor__c=String.valueOf(InitTenor).trim();
				offer.Availed_Tenor__c=String.valueOf(Decimal.valueOf(InitTenor));
				offer.Approved_Tenor__c=String.valueOf(Decimal.valueOf(InitTenor)+ Decimal.valueOf(SubTenor));
			}
			else{
				offer.Availed_Tenor__c = String.valueOf(SubTenor).trim();
			}
			update Offer;
		} catch (Exception ex) {
			system.debug('in Exception'+ex.getLineNumber() +ex.getMessage()); 
			return 'An Internal Error Occured.Unable to save PO Details';
		}
		system.debug('Offer Is:::::::::' + offer);

		Map < String, Object > params = new Map < String, Object > ();
		params.put('OfferId', Offer.Id);
		params.put('Sendtoname', 'Sales');
		params.put('flow', 'salaried');
		if (!CommonUtility.isEmpty(RejectReasons))
			params.put('RejectReasons', RejectReasons);
		if(!commonUtility.isEmpty(SchemeId))
			params.put('SchemeObjId',schemeId);
		params.put('EMI',EMI);
		params.put('InitEmi',InitEmi);
		params.put('SubEmi',SubEmi);
		params.put('InitTenor',InitTenor);
		params.put('SubTenor',SubTenor);
		params.put('Fees',Fees);

		system.debug('Scheme Id is:::'+SchemeId);
		return sendtoSalesConvert(JSON.serialize(params));

	}

	public static String sendtoSalesConvert(String RequestMap) {
		savepointvar = Database.setSavepoint();
		if (!CommonUtility.isEmpty(RequestMap)) {
			Map < String, Object > jsMap = (Map < String, Object > ) Json.deserializeUntyped(RequestMap);
			String OfferId = jsMap.containsKey('OfferId') ? (String) jsMap.get('OfferId') : '';
			String Sendtoname = jsMap.containsKey('Sendtoname') ? (String) jsMap.get('Sendtoname') : '';
			String flow = jsMap.containsKey('flow') ? (String) jsMap.get('flow') : '';
			String RejectReasons = jsMap.containsKey('RejectReasons') ? (String) jsMap.get('RejectReasons') : '';
			String SchemeId = jsMap.containsKey('SchemeObjId') ? (String) jsMap.get('SchemeObjId') : '';
			String EMI = jsMap.containsKey('EMI') ? String.valueOf(jsMap.get('EMI')) : '0';
			String InitEMI = jsMap.containsKey('InitEmi') ? String.valueOf(jsMap.get('InitEmi')) : '0';
			String SubEMI = jsMap.containsKey('SubEmi') ? String.valueOf(jsMap.get('SubEmi')) : '0';
			String InitTenor = jsMap.containsKey('InitTenor') ? String.valueOf(jsMap.get('InitTenor')) : '0';
			String SubTenor = jsMap.containsKey('SubTenor') ? String.valueOf(jsMap.get('SubTenor')) : '0';
			String Fees = jsMap.containsKey('Fees') ? String.valueOf(jsMap.get('Fees')) : '0';
			try {
				Opportunity oppObj;
				List < Performance_reports__c > OfferObj = [Select id, Disbursement_Payment_Mode__c, Address_Proof__c,Approved_Amt__c,Approved_Tenor__c,Availed_Amount__c,Availed_Tenor__c,Bank_Acct_Number__c,Bank_Name__c,Branch__c,City__c,CurrencyIsoCode,Current_Address1__c,Current_Address2__c,Current_Address3__c,
				                                            Current_City__c,Current_Pin_Code__c,Customer__r.name,Current_State__c,Customer__c,Date_Of_Joining__c,Decision_date__c,DOB__c,EMI_Amount__c,EmployeeId__c,
				                                            Employee_Address1__c,Employee_Address2__c,Employee_Address3__c,Employee_Band__c,Employee_Email__c,Employee_Name__c,Father_Spouse_First_Name__c,
				                                            Father_Spouse_Last_Name__c,Father_Spouse_Middle_Name__c,Father_Spouse_Salutation__c,Father_Spouse__c,Fees__c,/*Flexi_Term_Loan_Duration_EMI__c,
Flexi_Term_Loan_Tenor__c,*/Identity_Document_Expiry_Date__c,Identity_Document_No__c,Id_Proof__c,KYC_Applicable__c,Loan_Application_Number__c,Loan_Type__c,
MICR_Code__c,Mobile__c,Mother_First_Name__c,Mother_Last_Name__c,Mother_Middle_Name__c,Offer_converted__c,Offer_status__c,Office_City__c,Office_Email__c,
Office_Pin_Code__c,Office_State__c,PAN__c,Pin_code__c,Program_Name__c,/*Pure_Flexi_Duration_EMI__c,Pure_Flexi_Tenor__c,*/Rate__c,Risk_Segmentation__c,Salary__c,
/*SchemeName__c,SourcingChannel__c,SourcingChannel__r.Reporting_Manager__c,*/State__c,IFSC_Code__c,Marital_Status__c,Gender__c From Performance_Reports__c where id =: OfferId AND Offer_Status__c = 'LIVE' AND Offer_converted__c = false];
				List < Sourcing_Channel__c > sc = [Select id,Branch__c,Reporting_Manager__c From Sourcing_Channel__c where Name = 'Online Employee Loan'];
				system.debug('OfferObj[0].Office_city__c='+OfferObj[0].Office_city__c);
				List < Branch_Master__c > branch = [Select Branch_City__c from Branch_Master__c where id =: OfferObj[0].Office_city__c Limit 1];
				system.debug('Branch='+branch);
				String[] Name = OfferObj[0].Employee_Name__c.split(' ');
				String Fname, Lname, Mname;
				Lname='';
				if (!CommonUtility.isEmpty(Name) && Name.size() == 3) {
					Fname = Name[0];
					Mname = Name[1];
					Lname = Name[2];
				} else if (!CommonUtility.isEmpty(Name) && Name.size() == 2) {
					Fname = Name[0];
					Lname = Name[1];
				}else if(!CommonUtility.isEmpty(Name) && Name.size() == 1) {
					Lname = Name[0];
				}else{
					Fname = Name[0];
					Mname = Name[1];
					Lname= Name[2];
					for(Integer i=3;i<Name.size();i++)
						Lname =Lname+' '+Name[i];
				}
				savepointvar = database.setsavePoint();
				Account accountObj = new Account();

				accountObj.name = OfferObj[0].Employee_Name__c;
				accountObj.Last_Name__c = Lname;
				accountObj.First_Name__c = Fname;
				accountObj.Sourcing_Channel__c = sc[0].id;
				accountObj.Product__c = 'SPL';
				accountObj.Date_of_Birth__c = OfferObj[0].DOB__c;
				//accountObj.Marital_Status__c = OfferObj[0].Marital_Status__c;
				//accountObj.gender__c = OfferObj[0].gender__c;
				accountObj.Middle_Name__c = Mname;
				//accountObj.Employer__c = OfferObj[0].Employer__c;
				accountObj.Accountant_email_id__c = OfferObj[0].Office_Email__c;
				accountObj.Office_State__c = OfferObj[0].Office_State__c;

				accountObj.PANNumber__c = OfferObj[0].PAN__c;
				accountObj.Current_Email_Id__c = OfferObj[0].Employee_Email__c;
				accountObj.Joining_date_curr_Employer__c  = OfferObj[0].Date_Of_Joining__c; 
				accountObj.Permanent_Residence_Address1__c = OfferObj[0].Employee_Address1__c;
				accountObj.Permanent_Residence_Address2__c = OfferObj[0].Employee_Address2__c;
				accountObj.Permanent_Residence_Address3__c = OfferObj[0].Employee_Address3__c;
				accountObj.Permanent_City__c = OfferObj[0].City__c;
				accountObj.Permanent_PinCode__c = OfferObj[0].Pin_Code__c;
				accountObj.PinCode__c = OfferObj[0].Pin_Code__c; //added later for MobilityV2  23821
				accountObj.DesignationOTP__c = OfferObj[0].Employee_Band__c;
				accountObj.Accountant_email_id__c = OfferObj[0].Office_Email__c;
				if (OfferObj[0].Mobile__c != null) {
					string phNo = OfferObj[0].Mobile__c;
					phNo = phNo.remove(' ');
					phNo = phNo.remove('(');
					phNo = phNo.remove(')');
					phNo = phNo.remove('-');
					accountObj.Mobile__c = Decimal.valueOf(phNo);
				}

				accountObj.Email_Id__c = OfferObj[0].Employee_Email__c;
				//accountObj.Marital_Status__c = OfferObj[0].Marital_Status__c;
				//accountObj.Email_Id__c = OfferObj[0].Office_Email__c;
				accountObj.Office_City__c = branch[0].branch_city__c;
				accountObj.Flow__c = 'Mobility V2';
				accountObj.Gross_Salary_Turn_Over__c = OfferObj[0].Salary__c;
				accountObj.Group_Type__c = 'salaried';
				accountObj.Gender__c = OfferObj[0].Gender__c;
				insert accountObj;

				List < Contact > newContacts = new List < Contact > ();

				Contact contactObj = new Contact();
				contactObj.AccountId = accountObj.id;
				contactObj.ApplicantType__c = 'Primary';
				//contactObj.Employer_Name__c = OfferObj[0].Employer_Name__c;
				//contactObj.Employer__c = OfferObj[0].Employer__c;


				contactObj.Address_1__c = OfferObj[0].Current_Address1__c;
				contactObj.Address_2__c = OfferObj[0].Current_Address2__c;
				contactObj.Address_3__c = OfferObj[0].Current_Address3__c;
				contactObj.AppCity__c = OfferObj[0].Current_City__c;
				contactObj.Residence_City__c = OfferObj[0].Current_City__c;

				if (OfferObj[0].Pin_Code__c != null)
					contactObj.Pin_Code__c = OfferObj[0].Current_Pin_Code__c;
				contactObj.State__c = OfferObj[0].Current_State__c;


				contactObj.Office_City__c = branch[0].branch_city__c;

				contactObj.LastName = Lname;
				contactObj.firstname = Fname;
				contactObj.Joining_date_curr_Employer__c = OfferObj[0].Date_of_Joining__c;
				//contactObj.Marital_Status__c = OfferObj[0].Marital_Status__c;
				//contactObj.gender__c = OfferObj[0].gender__c;
				/*
if (contactObj.gender__c == 'Male') {
contactObj.Sex__c = 'M';
} else if (contactObj.gender__c == 'Female') {
contactObj.Sex__c = 'F';
} else {}
				 */


				contactObj.PAN_Number__c = OfferObj[0].PAN__c;
				contactObj.Email__c = OfferObj[0].Employee_Email__c;
				contactObj.Email = OfferObj[0].Employee_Email__c;

				contactObj.Year_of_Incorporation__c = OfferObj[0].Date_of_Joining__c;
				contactObj.Date_of_Birth__c = OfferObj[0].DOB__c;
				contactObj.Permanant_Address_Line_1__c = OfferObj[0].Employee_Address1__c;
				contactObj.Permanant_Address_Line_2__c = OfferObj[0].Employee_Address2__c;
				contactObj.Permanant_Address_Line_3__c = OfferObj[0].Employee_Address3__c;
				contactObj.Permanant_City__c = OfferObj[0].City__c;
				contactObj.Permanent_State__c = OfferObj[0].State__c;
				//contactObj.Permanent_Mobile__c = OfferObj[0].Phone_Number__c;
				contactObj.Permanent_Pin_Code__c = OfferObj[0].Pin_Code__c;
				contactObj.Marital_Status__c = OfferObj[0].Marital_Status__c;
				contactObj.Office_Email_Id__c = OfferObj[0].Office_Email__c;

				if (OfferObj[0].Mobile__c != null) {
					string phNo = OfferObj[0].Mobile__c;
					phNo = phNo.remove(' ');
					phNo = phNo.remove('(');
					phNo = phNo.remove(')');
					phNo = phNo.remove('-');
					contactObj.Mobile__c = Decimal.valueOf(phNo);
				}



				contactObj.Office_City__c = branch[0].branch_city__c;
				contactObj.Office_Pin_Code__c = String.valueOf(OfferObj[0].Office_Pin_Code__c);
				contactObj.Office_State__c = OfferObj[0].Office_State__c;

				contactObj.Customer_Type__c = 'Individual';

				contactObj.CIF_Id__c = OfferObj[0].Customer__r.name;
				contactObj.Father_Spouse__c = OfferObj[0].Father_Spouse__c;
				contactObj.Father_Spouse_Salutation__c = OfferObj[0].Father_Spouse_Salutation__c;
				contactObj.Father_Spouse_First_Name__c = OfferObj[0].Father_Spouse_First_Name__c;
				contactObj.Father_Spouse_Middle_Name__c = OfferObj[0].Father_Spouse_Middle_Name__c;
				contactObj.Father_Spouse_Last_Name__c = OfferObj[0].Father_Spouse_Last_Name__c;
				contactObj.Mother_First_Name__c = OfferObj[0].Mother_First_Name__c;
				contactObj.Mother_Middle_Name__c = OfferObj[0].Mother_Middle_Name__c;
				contactObj.Mother_Last_Name__c = OfferObj[0].Mother_Last_Name__c;


				//newContacts.add(contactObj);


				//if (newContacts != null && newContacts.size() > 0) {

				insert contactObj;//newContacts;

				//}



				oppObj = new Opportunity();
				oppObj.EMI_CAM__c = 0;
				system.debug('Fees Is::::'+Fees);
				oppObj.Processing_Fees__c = Decimal.valueOf(Fees); /* pick from static resource */


				if (OfferObj[0].Loan_type__c != null && (OfferObj[0].Loan_type__c.toLowerCase() == 'term loan' || OfferObj[0].Loan_type__c.toLowerCase() == 'flexi term loan'))
					oppObj.EMI_CAM__c = Decimal.valueOf(EMI);
				if (OfferObj[0].Loan_type__c != null && OfferObj[0].Loan_type__c.toLowerCase() == 'hybrid loan')
					oppObj.EMI_CAM__c = Decimal.valueOf(SubEmi);

				if (!CommonUtility.isEmpty(OfferObj[0].Approved_Amt__c))
					oppObj.amount = OfferObj[0].Approved_Amt__c;
				else
					oppObj.amount = OfferObj[0].Availed_amount__c;

				oppObj.Approved_Loan_Amount__c = OfferObj[0].Availed_Amount__c;
				oppObj.AccountId = accountObj.Id;
				oppObj.Product__c = 'SPL';

				oppObj.Branch_Name__c = branch[0].id;
				//oppObj.Loan_Amount__c = OfferObj[0].Approved_Amt__c;
				oppObj.Loan_Amount__c = OfferObj[0].Availed_Amount__c;
				/*logic for scheme master to be inserted here*/
				/*List<Scheme_Master__c> SchemeList = [Select id,flexi_flag__c,IsHybridFlexi__c,employee__c From Scheme_Master__c where employee__c = true && Active__c = true];

for(scheme_master__c schemes  : SchemeList){
if(offerObj[0].Loan_Type__c = 'Flexi Term Loan' && schemes.flexi_flag__c == true && schemes.IsHybridFlexi__c == false)
oppObj.Scheme_Master__c = schemes.id;
else if(offerObj[0].Loan_Type__c = 'Hybrid Loan' && schemes.flexi_flag__c == true && schemes.IsHybridFlexi__c == true)
oppObj.Scheme_Master__c = schemes.id;
else if(offerObj[0].Loan_Type__c = 'Term Loan' && schemes.flexi_flag__c == false && schemes.IsHybridFlexi__c == false)
oppObj.Scheme_Master__c = schemes.id;
}*/
				/* logic for scheme master to be inserted here*/
				oppObj.Scheme_Master__c = SchemeId;
				/*if(offerObj[0].loan_type__c != null && offerObj[0].loan_type__c.toLowerCase() == 'term loan')
oppObj.Tenor__c = Decimal.valueOf(OfferObj[0].Availed_Tenor__c);
else
oppObj.Tenor__c = Decimal.valueOf(OfferObj[0].Approved_Tenor__c);

if(offerObj[0].loan_type__c != null && offerObj[0].loan_type__c.toLowerCase() == 'term loan')
oppObj.Approved_Tenor__c = Decimal.valueOf(OfferObj[0].Availed_Tenor__c);
else{
oppObj.Approved_Tenor__c=Decimal.valueOf(OfferObj[0].Approved_Tenor__c);
}
				 */
				oppObj.Sourcing_Channel__c = sc[0].id;

				oppObj.Loan_Application_Flow__c = flow;

				oppObj.name = accountObj.name;
				//oppObj.recordTypeId = recordTypeId;
				oppObj.Existing_Customer__c = 'Existing Customer';
				oppObj.Approved_Rate__c = OfferObj[0].Rate__c;

				/*if(OfferObj[0].Flexi_Term_Loan_Duration_EMI__c != null){
oppObj.EMI_for_Tenor_2__c = OfferObj[0].Flexi_Term_Loan_Duration_EMI__c;
}*/


				oppObj.Approved_Loan_Amount__c = OfferObj[0].Approved_Amt__c;
				//oppObj.Product_Offereing_id__c = OfferObj[0].Offer_ID__c;

				oppObj.Link_Offer_Id__c = OfferObj[0].id;
				oppObj.Customer_Type__c = 'Individual';
				oppObj.Application_Source__c = 'Online Employee Loans';
				oppObj.Approved_Rate__c = OfferObj[0].Rate__c;


				oppObj.Repayment_Bank_Name__c = OfferObj[0].Bank_Name__c;
				oppObj.StageName = 'DSA/PSF Login';
				oppObj.CUSTOMER__c = OfferObj[0].Customer__c;
				oppObj.approver__c = 'CPA Login Partner';
				oppObj.Relationship_Manager__c = sc[0].Reporting_Manager__c;

				//oppObj.Approved_Amt__c = OfferObj[0].Approved_Amt__c;
				oppObj.Approved_Loan_Amount__c = OfferObj[0].Availed_Amount__c;
				oppObj.Loan_Amount__c = OfferObj[0].Availed_Amount__c;
				oppObj.Repayment_Mode__c = 'ECS';
				oppObj.Mode_of_Disbursal__c = OfferObj[0].Disbursement_Payment_Mode__c;
				oppObj.Favouring__c = OfferObj[0].Employee_Name__c;

				//if (OfferObj[0].Bank_Account_Type__c != null)
				oppObj.A_C_Type__c = 'Savings A/c';


				oppObj.Account_Holder_Name__c = OfferObj[0].Employee_Name__c;
				oppObj.Repayment_Account_Holder_Name__c = OfferObj[0].Employee_Name__c;


				if(offerObj[0].loan_type__c != null && (offerObj[0].loan_type__c.toLowerCase() == 'term loan' ||offerObj[0].loan_type__c.toLowerCase() ==  'flexi term loan')) {
					if(OfferObj[0].Availed_Tenor__c != null){
						oppObj.Approved_Tenor__c = Decimal.valueOf(OfferObj[0].Availed_Tenor__c);
						oppObj.Tenor__c = Decimal.valueOf(OfferObj[0].Availed_Tenor__c);
					}
				}
				else{
					//System.debug('rohit '+OfferObj[0].Approved_Tenor__c);
					oppObj.Approved_Tenor__c = Decimal.valueOf(OfferObj[0].Approved_Tenor__c);
					oppObj.Tenor__c = Decimal.valueOf(OfferObj[0].Approved_Tenor__c);
				}


				Decimal feesNum = Decimal.valueOf(Fees);

				oppObj.Processing_Fees__c = Decimal.valueOf(Fees); /*pick value from static resource*/
				oppObj.Amount_Rs__c = (feesNum/100) * OfferObj[0].Availed_Amount__c; /*formula will be Processing_fees__c * loan Amount*/
				oppObj.A_C_NO__c = OfferObj[0].Bank_Acct_Number__c;
				oppObj.Bank_Name__c = OfferObj[0].Bank_Name__c;
				if(!commonUtility.isEmpty(OfferObj[0].MICR_Code__c))
					oppObj.MICR_Number__c = Decimal.ValueOf(OfferObj[0].MICR_Code__c);
				oppObj.Repayment_Mode__c = 'ECS';
				/* logic for first due date to be stamped here */
				Date dueDate;
				if (System.today() != null && system.today().day() <= 15) {
					dueDate = Date.newInstance(system.today().Year(), System.today().month() + 1, 2);
				} else {
					dueDate = Date.newInstance(system.today().Year(), System.today().month() + 2, 2);
				}
				system.debug('dueDate is::::::' + dueDate);
				oppObj.First_Due_Date__c = dueDate;
				/* logic for first due date to be stamped above*/
				oppObj.Bank_A_c_No_of_Customer__c = OfferObj[0].Bank_Acct_Number__c;
				oppObj.Repayment_Bank_Name__c = OfferObj[0].Bank_name__c;
				oppObj.CUSTOMER__c = OfferObj[0].Customer__c;
				oppObj.Approved_Rate__c = OfferObj[0].Rate__c;
				oppObj.Business_IRR__c = OfferObj[0].Rate__c;
				oppObj.OwnerId = RoundRobinEmpLoanOwner('Salaried Telecalling Team',oppObj.id);
				oppObj.CloseDate = date.today() + 90;
				oppObj.IFSC_Code__c = offerObj[0].IFSC_Code__c;
				oppObj.Loan_Type__c = offerObj[0].Loan_Type__c; 
				oppObj.Type_Of_Loan__c='Parallel 1';
				oppObj.Employee_Type__c='Salaried';
				insert oppObj;

				OfferObj[0].Offer_converted__c=true;
				OfferObj[0].Loan_Application_Number__c=oppObj.id;
				update OfferObj[0];

				Applicant__c applicant = new Applicant__c();
				applicant.Drop_Line_Flexi_Period__c = 0;
				applicant.Pure_Flexi_Period__c = 0;
				applicant.Pure_Flexi_EMI__c = 0;
				applicant.Contact_Name__c = contactObj.Id;
				applicant.Loan_Application__c = oppObj.Id;
				applicant.Applicant_Type__c = 'Primary';
				applicant.Risk_Segmentation__c = OfferObj[0].Risk_Segmentation__c;
				applicant.Existing_Customer__c = 'Individual';
				applicant.Proof_of_Identity__c = OfferObj[0].Id_Proof__c;
				applicant.Identity_Document_No__c = OfferObj[0].Identity_Document_No__c;
				applicant.Identity_Document_Expiry_Date__c = OfferObj[0].Identity_Document_Expiry_Date__c;
				applicant.Kyc_verifications__c = OfferObj[0].KYC_Applicable__c;
				applicant.Proof_of_Address_Submitted_for_Permanent__c = OfferObj[0].Address_Proof__c;
				if (OfferObj[0].Loan_type__c != null && OfferObj[0].Loan_type__c.toLowerCase() == 'hybrid loan')
					applicant.Drop_Line_Flexi_Period__c = Decimal.valueOf(SubTenor);
				if (OfferObj[0].Loan_type__c != null && OfferObj[0].Loan_type__c.toLowerCase() == 'hybrid loan')
					applicant.Pure_Flexi_Period__c = Decimal.valueOf(initTenor);
				if (OfferObj[0].Loan_type__c != null && OfferObj[0].Loan_type__c.toLowerCase() == 'hybrid loan')
					applicant.Pure_Flexi_EMI__c = Decimal.valueOf(InitEmi);
				if(OfferObj[0].Loan_type__c != null && OfferObj[0].Loan_type__c.toLowerCase() == 'flexi term loan')
					applicant.Pure_Flexi_Period__c = Decimal.valueOf(OfferObj[0].Approved_Tenor__c);
				if(OfferObj[0].Loan_type__c != null && OfferObj[0].Loan_type__c.toLowerCase() == 'flexi term loan')
					applicant.Pure_Flexi_EMI__c = Decimal.valueOf(EMI);
				if (!CommonUtility.isEmpty(RejectReasons)){
					applicant.Customer_Decline_Reasons__c = RejectReasons;
					applicant.Decline_Reasons__c= RejectReasons;
				}
				System.debug('contactObj.CIF_Id__c101===='+contactObj.CIF_Id__c); 
				if(contactObj.CIF_Id__c!=null){
					applicant.Dedupe_Linking_Done__c='SAVE';
					applicant.Dedupe_Done__c=true;
				}
				else
					applicant.Dedupe_Linking_Done__c='RESET';
				applicant.Note_code__c='GIFTFLAG';
				applicant.Note_details__c='Y';
				applicant.Payment_type__c='funded';
				applicant.Financial_Health_Check_Guide__c=true;
				applicant.EMI_Card__c='2999';//present on prod
				insert applicant;

				CAM__c camObj = new CAM__c();
				camObj.Loan_Application__c = oppObj.Id;
				camObj.Applicant__c = applicant.Id;
				camObj.ROI__c = OfferObj[0].Rate__c;
				camObj.Average_incentive_for_Q1__c = OfferObj[0].Salary__c;
				camObj.Average_incentive_for_Q2__c = OfferObj[0].Salary__c;
				camObj.Average_incentive_for_Q3__c = OfferObj[0].Salary__c;
				camObj.Net_Salary_for_Month1__c = OfferObj[0].Salary__c;
				camObj.Net_Salary_for_Month2__c = OfferObj[0].Salary__c;
				camObj.Net_Salary_for_Month3__c = OfferObj[0].Salary__c;
				camObj.Proposed_Loan_Amt__c = OfferObj[0].Availed_Amount__c;
				camObj.Average_Monthly_Net_Income1__c = OfferObj[0].Salary__c;
				camObj.sal_max_loan__c = OfferObj[0].Approved_Amt__c;
				if(OfferObj[0].loan_Type__c != null && OfferObj[0].loan_type__c.toLowerCase() == 'hybrid loan')
					camObj.Tenor__c = Decimal.valueOf(SubTenor) + Decimal.valueOf(initTenor);
				else if(OfferObj[0].loan_Type__c != null && OfferObj[0].loan_type__c.toLowerCase() == 'flexi term loan')
					camObj.Tenor__c = applicant.Pure_Flexi_Period__c;
				else if(OfferObj[0].loan_Type__c != null && OfferObj[0].loan_type__c.toLowerCase() == 'term loan')
					camObj.Tenor__c = oppObj.Tenor__c;
				//camObj.EMI__c = stamp applicable EMI here 
				camObj.EMI_on_Proposed_Loan_TO__c = oppObj.EMI_CAM__c;
				camObj.EMI__c = oppObj.EMI_CAM__c;


				insert camObj;

				Bank_Account__c bankObj =  new  Bank_Account__c();
				bankObj.Account_Type__c = 'Savings A/c';
				bankObj.Bank_Account_Number__c = Decimal.valueOf(OfferObj[0].Bank_Acct_Number__c);
				bankObj.Bank_Acct_Number__c = OfferObj[0].Bank_Acct_Number__c;
				bankObj.Bank_Name__c =OfferObj[0].Bank_Name__c;
				bankObj.Applicant__c = applicant.Id;
				bankObj.Loan_Application__c = oppObj.Id;
				bankObj.IFSC_Code__c = OfferObj[0].IFSC_Code__c;
				bankObj.Applicant_Name__c=OfferObj[0].Employee_Name__c;
				insert bankObj;

				list<Opportunity> oppList=new list<Opportunity>();
				oppList.add(oppObj);
				if(commonUtility.isEmpty(RejectReasons))
					GeneralCommunicationHandler.sendSMS(oppList,'Employee Loan Accept-Cust');
				else 
					GeneralCommunicationHandler.sendSMS(oppList,'Employee Loan Decline-Cust');

				return oppObj.id;

			} catch (Exception ex) {
				Database.rollback(savePointVar);
				system.debug('Exception Occured:::: ' + ex.getMessage() + ' ' + ex.getLineNumber());
				return 'Error';
			}
		} else {
			system.debug('Empty request');
			return 'Error';
		}
	}

	public class EmpLoanWrapper {
		public Performance_reports__c perList;
		public boolean isLAOpen=false;
		public boolean isNonDisbursed=false;
		public String rate='';
		public Map < String, Map < String, List < String >>> picklistData;
		public Opportunity opp;
		public CAM__c cam;
		public Contact con;
		public Applicant__c primaryApplicant;
		public RePayment_mode_detail__c repay;
		public Current_Disbursal_Details__c disb;
		public Bank_Account__c bankAcc;
		public Decimal emiTemp,tenorTemp;
		public String showKYCError;
		public String sentToWhere;
		public String showRiskSegmentationError;
		public String processingFee;
		public String welcomemessage1;
		public String welcomemessage2;
		public Decimal netDisbursementAmount;
		public String FinnoneErrorMsg;
		public List<String> DocumentList = new List<String>();
		public Decimal pf_in_Rupee;
		public Date LastDate;
		public String stageOfLoan;
	}

	//added by Aniket for bug 23263(CR) Start
	public static Decimal getDisburs(String oppId)
	{ 
		if(!CommonUtility.isEmpty(oppId))
		{
			Contact con;
			Current_Disbursal_Details__c cdd;
			String processingFee;
			Decimal total=0;
			processingFee=CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','ProcessingFee','');
			Opportunity oppObj = [select id,Tenor__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.is_Pure_Flexi__c,Account.Mobile__c,StageName,Loan_Application_Number__c,Name,Bank_Name__c,A_C_Type__c,IFSC_Code__c,Favouring__c,Bank_A_c_No_of_Customer__c, Product__c, Loan_Type__c, Approved_Loan_Amount__c, Loan_Amount_with_Premium__c, Approved_Rate__c, EMI_CAM__c, Approved_Tenor__c, Amount_Rs__c from Opportunity where id =: oppId];
			Applicant__c primaryApplicant=[select id,Emp_tele_identifier__c,Contact_Name__r.id,IP_Address_Timestamp__c,Application_Form_Timestamp__c,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c,Decline_Reasons__c,Customer_Decline_Reasons__c,Employee_Modified__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];
			List<Contact> conList = [SELECT Stamp_Duty__c from Contact where id=: primaryApplicant.Contact_Name__r.id LIMIT 1];
			if(!CommonUtility.isEmpty(conList) && oppId != null)
			{
				if(!CommonUtility.isEmpty(conList)){ 
					con = conList.get(0);
				}  
				List<Current_Disbursal_Details__c> disbList=[select id,UMRN__c,Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,FinnOne_Disbursement_Date__c,Repay_Disb_Diff__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c ,IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c from Current_Disbursal_Details__c where Loan_Application__c=: oppId];
				List<RePayment_mode_detail__c> repayList=[SELECT Id, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c,UMRN__c,Loan_Application__r.Account.Mobile__c FROM RePayment_mode_detail__c where Loan_Application__c =: oppId];

				AggregateResult[] groupedResults=[select SUM(Change_Amount__c)total from Fees_and_Charge__c  where Loan_Application__c =: oppId and Deducted_from_Disbursement__c='Yes'];
				if(!CommonUtility.isEmpty(groupedResults) && groupedResults[0].get('total')!=null){
					total = (decimal)groupedResults[0].get('total');}
				System.debug('here is'+oppObj.Loan_Amount_with_Premium__c+' '+con.Stamp_Duty__c+' '+Decimal.valueOf(processingFee)+' '+total);
				Decimal pf_in_rs=(Decimal.valueOf(processingFee)/100)*oppObj.Loan_Amount_with_Premium__c;
				if(CommonUtility.isEmpty(con.Stamp_Duty__c)){con.Stamp_Duty__c=0;}
				netDisbursementAmount = oppObj.Loan_Amount_with_Premium__c-(total); //removed stampduty
				if(netDisbursementAmount != null)
				{
					System.debug(netDisbursementAmount);
					return netDisbursementAmount.setScale(0); //24469 
				}
			}
		}

		return 0;

	}
	//added by Aniket for bug 23263(CR) Stop 

	@AuraEnabled 
	public static String getDisbursmentData(String oppId) {
		System.debug('OPP id '+oppId);
		EmpLoanWrapper dss = new EmpLoanWrapper();
		Opportunity oppObj = [select id,Tenor__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.is_Pure_Flexi__c,Account.Mobile__c,StageName,Loan_Application_Number__c,Name,Bank_Name__c,A_C_Type__c,IFSC_Code__c,Favouring__c,Bank_A_c_No_of_Customer__c, Product__c, Loan_Type__c, Approved_Loan_Amount__c, Loan_Amount_with_Premium__c, Approved_Rate__c, EMI_CAM__c, Approved_Tenor__c, Amount_Rs__c ,First_Due_Date__c,(Select id,Insurance_Product__c,Insurance_Name__c from Insurance__r) from Opportunity where id =: oppId];
		system.debug(oppObj);
		dss.opp = oppObj;
		Applicant__c primaryApplicant=[select id,Emp_tele_identifier__c,Contact_Name__r.id,IP_Address_Timestamp__c,Application_Form_Timestamp__c,KYC_Verifications__c,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c,Decline_Reasons__c,Customer_Decline_Reasons__c,Employee_Modified__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];
		if(!CommonUtility.isEmpty(primaryApplicant)) 
		{

			if(!CommonUtility.isEmpty(oppObj)){
				Date currentDate = oppObj.First_Due_Date__c;
				if(oppObj.Loan_Type__c == 'Hybrid Loan'){

					Date LastDate = currentDate.addMonths((Integer.valueOf(primaryApplicant.Pure_Flexi_Period__c + primaryApplicant.Drop_Line_Flexi_Period__c)));
					dss.LastDate = LastDate;
				}
				else if(oppObj.Loan_Type__c == 'Flexi Term Loan'){
					Date LastDate = currentDate.addMonths((Integer.ValueOf(primaryApplicant.Pure_Flexi_Period__c)));
					dss.LastDate = LastDate;
				}else{
					Date LastDate = currentDate.addMonths((Integer.valueOf(oppObj.Tenor__c)));
					dss.LastDate = LastDate;
				}
			}
			// System.debug('EMI = '+oppObj.EMI_CAM__c+ ' ;'+primaryApplicant.Pure_Flexi_EMI__c );
			dss.primaryApplicant=primaryApplicant;
			//  dss.emiTemp = oppObj.EMI_CAM__c + primaryApplicant.Pure_Flexi_EMI__c ; 
			// dss.tenorTemp= oppObj.Approved_Tenor__c;// + primaryApplicant.Pure_Flexi_Period__c + primaryApplicant.Drop_Line_Flexi_Period__c;
			Map<String,Object> ApplicableFields =getApplicableEMI_Tenor(primaryApplicant,oppObj);
			dss.emiTemp=(decimal)ApplicableFields.get('Applicable EMI');
			dss.tenorTemp=(Decimal)ApplicableFields.get('Applicable Tenor');
		}
		List<RePayment_mode_detail__c> repayList=[SELECT Id, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c,UMRN__c,Loan_Application__r.Account.Mobile__c FROM RePayment_mode_detail__c where Loan_Application__c =: oppId];
		if(!CommonUtility.isEmpty(repayList))
		{
			dss.repay=repayList[0];
		}
		List<Current_Disbursal_Details__c> disbList=[select id,UMRN__c,Disbursement_To__c, IMPS_Flag__c, Bank_Branch__c, name, Tranche_Detail__c, Loan_Application__c, Internal_Closure__c, Disbursement_Amount__c, Disbursal_Mode__c, Disbursement_Date__c,FinnOne_Disbursement_Date__c,Repay_Disb_Diff__c,Successful_IMPS_Count__c,Failure_IMPS_Count__c ,IFSC_Code__c, Favouring__c,isTopUp__c,Tranche_Detail__r.Tranche_Number__c, Bank_Name__c, Bank_Account__c, Payable_at__c, Credit_Days__c, IMPS_Result__c from Current_Disbursal_Details__c where Loan_Application__c=: oppId];
		if (!commonUtility.isEmpty(disbList)) { 
			dss.disb= disbList[0];
		}       
		List<Bank_Account__c> bankAccList=[select Salary_Credit_Date1__c,Salary_Credit_Date2__c,Salary_Credit_Date3__c,Perfios_inwardChqBounces__c,Perfios_inwardECSBounces__c,Perfios_Bank_Name__c from Bank_Account__c where Loan_Application__c =: oppId];
		if (!CommonUtility.isEmpty(bankAccList))
		{
			dss.bankAcc=bankAccList[0];
		}
		dss.processingFee=CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','ProcessingFee','');
		List<Contact> conList = [SELECT Stamp_Duty__c from Contact where id=: primaryApplicant.Contact_Name__r.id LIMIT 1];
		if(!CommonUtility.isEmpty(conList)){ 
			dss.con = conList.get(0);
		}
		Decimal total=0;
		AggregateResult[] groupedResults=[select SUM(Change_Amount__c)total from Fees_and_Charge__c  where Loan_Application__c =: oppId and Deducted_from_Disbursement__c='Yes'];
		if(!CommonUtility.isEmpty(groupedResults) && groupedResults[0].get('total')!=null){
			total = (decimal)groupedResults[0].get('total');}
		System.debug('here is'+dss.opp.Loan_Amount_with_Premium__c+' '+dss.con.Stamp_Duty__c+' '+Decimal.valueOf(dss.processingFee)+' '+total);
		Decimal pf_in_rs=(Decimal.valueOf(dss.processingFee)/100)*dss.opp.Loan_Amount_with_Premium__c;
		dss.pf_in_Rupee=pf_in_rs;
		if(CommonUtility.isEmpty(dss.con.Stamp_Duty__c)){dss.con.Stamp_Duty__c=0;}
		dss.netDisbursementAmount = dss.opp.Loan_Amount_with_Premium__c-(total);
		// netDisbursementAMT=dss.netDisbursementAmount;


		return JSON.serialize(dss);
	}
	/*
//@AuraEnabled
//Added Static method by Aniket for bug 23263 
//have to add later Decimal netDisbursementAmount as parameter
public static String disdata(String oppId)
{
EmpLoanWrapper dss = new EmpLoanWrapper();
Decimal total=0;
AggregateResult[] groupedResults=[select SUM(Change_Amount__c)total from Fees_and_Charge__c  where Loan_Application__c =: oppId and Deducted_from_Disbursement__c='Yes'];
if(!CommonUtility.isEmpty(groupedResults) && groupedResults[0].get('total')!=null){
total = (decimal)groupedResults[0].get('total');}
System.debug('here is'+dss.opp.Loan_Amount_with_Premium__c+' '+dss.con.Stamp_Duty__c+' '+Decimal.valueOf(dss.processingFee)+' '+total);
Decimal pf_in_rs=(Decimal.valueOf(dss.processingFee)/100)*dss.opp.Loan_Amount_with_Premium__c;
if(CommonUtility.isEmpty(dss.con.Stamp_Duty__c)){dss.con.Stamp_Duty__c=0;}
dss.netDisbursementAmount = dss.opp.Loan_Amount_with_Premium__c-(dss.con.Stamp_Duty__c+pf_in_rs+total);

return JSON.serialize(dss);
}
	 */

	@AuraEnabled 
	public static String getLACardData(String oppId) {
		EmpLoanWrapper dss = new EmpLoanWrapper();
		Opportunity oppObj = [select id,Account.Mobile__c,StageName,Loan_Application_Number__c,Name,Bank_Name__c,A_C_Type__c,IFSC_Code__c,Favouring__c,Bank_A_c_No_of_Customer__c, Product__c, Loan_Type__c, Approved_Loan_Amount__c, Loan_Amount_with_Premium__c, Approved_Rate__c, EMI_CAM__c, Approved_Tenor__c, Amount_Rs__c from Opportunity where id =: oppId];
		dss.opp = oppObj;
		return JSON.serialize(dss);
	}
	@AuraEnabled
	public static String sendE_aggrementMail(String oppId){
		try{
			Opportunity op = [select id,Loan_Type__c,Tenor__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.is_Pure_Flexi__c,First_Due_Date__c,Tenor_Step_1__c,Approved_Tenor__c,EMI_CAM__c,EMI_For_Tenor_2__c,EMI_for_Tenor_1__c,Tenor_Step_2__c,MICR_Number__c,CUSTOMER__c,CUSTOMER__r.Name,PAN_Number__c,(select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
					Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
					Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charges__r) from Opportunity where id = : oppId];
			Applicant__c primaryApplicant=[select id,Financial_Health_Check_Guide__c,Contact_Name__r.id,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];  
			//Decimal emiTemp = op.EMI_CAM__c + primaryApplicant.Pure_Flexi_EMI__c ; 
			Map<String,Object> ApplicableFields =getApplicableEMI_Tenor(primaryApplicant,op);
			Decimal emiTemp=(decimal)ApplicableFields.get('Applicable EMI');
			List<Contact> conList = [SELECT Stamp_Duty__c from Contact where id=: primaryApplicant.Contact_Name__r.id LIMIT 1];

			String BPI;
			List<Fees_and_Charge__c> bpi_fee= [select Change_Amount__c,Finnone_ChargeCode__c from Fees_and_Charge__c  where Loan_Application__c =: oppId and Deducted_from_Disbursement__c='Yes' and Finnone_ChargeCode__c=500284];
			if(!CommonUtility.isEmpty(bpi_fee))
			{
				BPI=String.valueOf(bpi_fee[0].Change_Amount__c);
			}

			List<RePayment_mode_detail__c> repayList=[SELECT Id, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c,UMRN__c,Loan_Application__r.Account.Mobile__c FROM RePayment_mode_detail__c where Loan_Application__c =: oppId];

			if(!CommonUtility.isEmpty(repayList))
			{   
				Date currentDate = op.First_Due_Date__c;
				Date LastDate;
				if(op.Loan_Type__c == 'Hybrid Loan'){
					LastDate = currentDate.addMonths(Integer.valueOf(primaryApplicant.Pure_Flexi_Period__c + primaryApplicant.Drop_Line_Flexi_Period__c));
				}
				else if(op.Loan_Type__c == 'Flexi Term Loan'){
					LastDate = currentDate.addMonths(Integer.valueOf(primaryApplicant.Pure_Flexi_Period__c));
				}else{
					LastDate = currentDate.addMonths(Integer.valueOf(op.Tenor__c));
				}
				SALMobilityPricingCntrl_V2.sendEaggrementMail(oppId,BPI,conList[0].Stamp_Duty__c+'',String.valueOf(op.First_Due_Date__c),'',String.valueOf(LastDate),emiTemp+'');
			}
		}catch(Exception e){System.debug('Exception at line '+e.getLineNumber()+e.getMessage());}
		return 'Pass';
	}


	@AuraEnabled
	public static String sendToFinnoneOrBranchOps(String oppId) {
		EmpLoanWrapper dss = new EmpLoanWrapper();
		Boolean condition1=false,condition2=false,condition3=false,condition4=false; 
		Boolean sendToFinnone=false; 
		Opportunity op = [select id,Tenor__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.is_Pure_Flexi__c,First_Due_Date__c,Tenor_Step_1__c,Approved_Tenor__c,EMI_CAM__c,EMI_For_Tenor_2__c,EMI_for_Tenor_1__c,Tenor_Step_2__c,MICR_Number__c,CUSTOMER__c,CUSTOMER__r.Name,PAN_Number__c , /*DMS 24317 s*/Product__c /*DMS 24317 s*/ from Opportunity where id = : oppId];
		calculateFoir(oppId);
		Applicant__c primaryApplicant=[select id,Risk_Segmentation__c,IP_Address_Timestamp__c,Application_Form_Timestamp__c,KYC_Verifications__c,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];  
		
		 //DMS 24317 s
        Map<String,Object> DMSDocs=new Map<String,Object>();
        if(!CommonUtility.isEmpty(op.product__c))
            DMSDocs= CommonUtility.getDMSDocuments(op.product__c);
        //DMS 24317 e
		
		if(!commonUtility.isEmpty(primaryApplicant) && (!CommonUtility.isEmpty(primaryApplicant.Application_Form_Timestamp__c)) && (!CommonUtility.isEmpty(primaryApplicant.IP_Address_Timestamp__c)) && (primaryApplicant.IP_Address_Timestamp__c.indexOf('Accepted') >=0 ) && (primaryApplicant.Application_Form_Timestamp__c.indexOf('Accepted') >=0 )){
			List<RePayment_mode_detail__c> repayList=[SELECT Id, A_C_type__c,ECS_Barcode_No__c,Open_ECS_Facility__c, Open_ECS_Ex_Customer_Id__c, Open_Valid_till__c, Open_ECS_Max_Limit__c, ECS_Start_Date__c, ECS_End_Date__c, ECS_Amount__c, name, Loan_Application__c, A_C_NO__c, MICR_Code__c, PDC_START_DATE__c, IFSC_Code__c, Account_Holder_Name__c,Bank_Name__c, No_of_Cheques__c, Cheque_Serial_Number__c, Repayment_Mode__c, To_Cheque_Serial_Number__c, Cheque_Amount__c, Tranche_Detail__c, Bank_Branch__c, PDC_By_Name__c ,Loan_Application__r.CUSTOMER__c  ,Mandate_Process_Stage__c,UMRN__c,Loan_Application__r.Account.Mobile__c FROM RePayment_mode_detail__c where Loan_Application__c =: oppId];
			Map<String,Object> ApplicableFields =getApplicableEMI_Tenor(primaryApplicant,op);
			System.debug('ApplicableFieldsPooja===' +ApplicableFields);
			Decimal emiTemp=(decimal)ApplicableFields.get('Applicable EMI');
			Decimal  tenorTemp=(Decimal)ApplicableFields.get('Applicable Tenor');
			// Decimal emiTemp = op.EMI_CAM__c + primaryApplicant.Pure_Flexi_EMI__c ; 
			// Decimal tenorTemp= op.Approved_Tenor__c;// + primaryApplicant.Pure_Flexi_Period__c + primaryApplicant.Drop_Line_Flexi_Period__c;
			Date addedDate=Date.today().addMonths(Integer.valueOf(tenorTemp));

			if(repayList[0].Open_ECS_Facility__c=='Existing' && op.CUSTOMER__c!=null && repayList[0].ECS_End_Date__c>=addedDate &&  repayList[0].Open_ECS_Max_Limit__c >= emiTemp && op.MICR_Number__c!=null && repayList[0].MICR_Code__c!=null &&  op.MICR_Number__c ==repayList[0].MICR_Code__c )
			{
				condition1=true;
			}
			if((!CommonUtility.isEmpty(primaryApplicant.KYC_Verifications__c) && primaryApplicant.KYC_Verifications__c==true))
			{
				condition3=true; 
			}
			if(!CommonUtility.isEmpty(repayList))
			{
				if(repayList[0].UMRN__c!=null) 
					condition2=true; 
			}
			if(!CommonUtility.isEmpty(primaryApplicant.IP_Address_Timestamp__c) && primaryApplicant.IP_Address_Timestamp__c.contains('Accepted') && !CommonUtility.isEmpty(primaryApplicant.Application_Form_Timestamp__c) && primaryApplicant.Application_Form_Timestamp__c.contains('Accepted'))
			{
				condition4=true;
			}

			if((condition1 || condition2) &&  condition3 && condition4)
			{

				dss.FinnoneErrorMsg= sendToFinnoneDirect(oppId);
				System.debug('got message'+dss.FinnoneErrorMsg);
				dss.sentToWhere='Finnone';
				return JSON.serialize(dss);
			}
			List<String> DocName = (CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','EmployeeLoanDocuments','')).split(';');
			String kycname=DocName[0];
			String pdc1name=DocName[1];
			String pdc2name=DocName[2];
			String pdc3name=DocName[3];
			
			 //Added by swapnil for DMS 24317 s
			String dmsKycname= kycname;
            String DMSPdc1name=pdc1name;  
            String DMSPdc2name=pdc2name;
            String DMSPdc3name=pdc3name;
			if(!commonUtility.isEmpty(DMSDocs.get(kycname)))			
             dmsKycname=(String)DMSDocs.get(kycname); 
		    if(!commonUtility.isEmpty(DMSDocs.get(pdc1name)))			
             DMSPdc1name=(String)DMSDocs.get(pdc1name);
		    if(!commonUtility.isEmpty(DMSDocs.get(pdc2name)))			
             DMSPdc2name=(String)DMSDocs.get(pdc2name); 
		    if(!commonUtility.isEmpty(DMSDocs.get(pdc3name)))			
             DMSPdc3name=(String)DMSDocs.get(pdc3name); 
		   //Added by swapnil for DMS 24317 e
			
			if((!CommonUtility.isEmpty(primaryApplicant.KYC_Verifications__c) && primaryApplicant.KYC_Verifications__c==false))
			{
				dss.showKYCError='true';
			}
			if(!CommonUtility.isEmpty(primaryApplicant.Risk_Segmentation__c) && primaryApplicant.Risk_Segmentation__c=='HR')
			{
				dss.showRiskSegmentationError='true';
			}

			if(dss.showKYCError!='true' && dss.showRiskSegmentationError!='true') //no error msg set, so send to branchops
			{
				sendToBranchOps(oppId);
				dss.sentToWhere='Branch Ops';
				return JSON.serialize(dss);
			}
			if(dss.showKYCError=='true' && dss.showRiskSegmentationError!='true') //KYC error msg set, 
			{
				dss.documentList.add('KYC');
				kycname = '%' + kycname + '%';
				dmsKycname  = '%' + dmsKycname + '%'; //DMS 24317
				if([SELECT id,ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId =: oppId AND ( ContentDocument.title like  : kycname OR   ContentDocument.title like : dmsKycname ) ].size() >0)//Added by swapnil for DMS 24317
				{
					//KYC document is present, so allow to branchops 
					dss.showKYCError='false';
					dss.showRiskSegmentationError='false';
					sendToBranchOps(oppId);
					dss.sentToWhere='Branch Ops';
					//dss.documentList.remove('KYC');
					return JSON.serialize(dss);
				}
			}
			if(dss.showKYCError!='true' && dss.showRiskSegmentationError=='true') //in high risk, so 3 documents are mandatory
			{
				kycname = '%' + kycname + '%';
				pdc1name = '%' + pdc1name + '%';
				pdc2name = '%' + pdc2name + '%';
				pdc3name = '%' + pdc3name + '%';
				
				 //Added by swapnil for DMS 24317 s
				 dmsKycname= '%' + dmsKycname + '%';
				 DMSPdc1name='%' + DMSPdc1name + '%';
				 DMSPdc2name='%' + DMSPdc2name + '%';
				 DMSPdc3name='%' + DMSPdc3name + '%';
                //Added by swapnil for DMS 24317 e
				dss.documentList.add('Post-Dated Cheque 1');
				dss.documentList.add('Post-Dated Cheque 2');
				dss.documentList.add('Post-Dated Cheque 3');    
				 if([SELECT id,ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId =: primaryApplicant.id AND (ContentDocument.title like :pdc1name OR ContentDocument.title like :pdc2name OR ContentDocument.title like:pdc3name OR ContentDocument.title like: DMSPdc1name  OR ContentDocument.title like: DMSPdc2name OR ContentDocument.title like: DMSPdc3name )].size()>2) //added by swapnil for DMS 24317
				{
					//KYC document is present, so allow to branchops
					dss.showKYCError='false';
					dss.showRiskSegmentationError='false';
					sendToBranchOps(oppId);
					dss.sentToWhere='Branch Ops';
					//dss.documentList.remove('Post-Dated Cheque 1');
					//dss.documentList.remove('Post-Dated Cheque 2');
					//dss.documentList.remove('Post-Dated Cheque 3');
					return JSON.serialize(dss);
				}
			}
			if(dss.showKYCError=='true' && dss.showRiskSegmentationError=='true') //in high risk, so 3 documents are mandatory
			{
				kycname = '%' + kycname + '%';
				pdc1name = '%' + pdc1name + '%';
				pdc2name = '%' + pdc2name + '%';
				pdc3name = '%' + pdc3name + '%';
				dss.documentList.add('KYC');
				dss.documentList.add('Post-Dated Cheque 1');
				dss.documentList.add('Post-Dated Cheque 2');
				dss.documentList.add('Post-Dated Cheque 3');
				
				 //Added by swapnil for DMS 24317 s
				 dmsKycname= '%' + dmsKycname + '%';
				 DMSPdc1name='%' + DMSPdc1name + '%';
				 DMSPdc2name='%' + DMSPdc2name + '%';
				 DMSPdc3name='%' + DMSPdc3name + '%';
                //Added by swapnil for DMS 24317 e
				
				if([SELECT id,ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId =:oppId AND (ContentDocument.title like :kycname OR ContentDocument.title like :pdc1name OR ContentDocument.title like :pdc2name OR ContentDocument.title like:pdc3name  OR ContentDocument.title like: DMSPdc1name  OR ContentDocument.title like: DMSPdc2name OR ContentDocument.title like: DMSPdc3name )].size()>3)
				{
					//KYC document is present, so allow to branchops
					dss.showKYCError='false';
					dss.showRiskSegmentationError='false';
					sendToBranchOps(oppId);
					dss.sentToWhere='Branch Ops';
					//dss.documentList.remove('KYC');
					//dss.documentList.remove('Post-Dated Cheque 1');
					//dss.documentList.remove('Post-Dated Cheque 2');
					//dss.documentList.remove('Post-Dated Cheque 3');
					return JSON.serialize(dss);
				}
			}
			return JSON.serialize(dss);
		}else{
			return 'Acceptance Pending';
		}
	}
	@AuraEnabled
	public static String getOpportunityData(String oppId, String objectFieldJSON) {
		return SALMobilityCntrl_V2.getOpportunityData(oppId, objectFieldJSON);
	}
	@AuraEnabled
	public static string updateEmplyeeDetails(String loanObjString, String contObjString, String actionOn) {
		Opportunity loanobj = (Opportunity) JSON.deserialize(loanObjString, Opportunity.class);
		System.debug('Loan details' +loanObjString+'  '+ loanobj.id);
		getFeesList(loanobj.id);//added later, temporory
		savepointvar = database.setsavePoint();
		Applicant__c app=[select id,name,Employee_Modified__c,ModifiedStatus__c from applicant__c where Loan_Application__c =: loanobj.id AND applicant_type__c = 'Primary'];
		system.debug('Applicant is:::::'+app);
		Boolean modifiedFlag = app.Employee_Modified__c;
		try {
			if (actionOn.equalsIgnoreCase('Bank Details')) {
				loanobj.StageName = 'DSA/PSF Login';
				loanobj.Bank_Name__c = loanobj.Repayment_Bank_Name__c;
				loanobj.A_C_No__c = loanobj.Bank_A_c_No_of_Customer__c;
				loanobj.Favouring__c = loanobj.Repayment_Account_Holder_Name__c;
				app.Employee_Modified__c=true;
				if(app.ModifiedStatus__c==null)app.ModifiedStatus__c='';
				app.ModifiedStatus__c=app.ModifiedStatus__c+'B;';
				update loanobj;

				Bank_Account__c bankObj=[select id,Bank_Account_Number__c,Bank_Acct_Number__c,Bank_Name__c,Applicant_Name__c from Bank_Account__c where Loan_Application__c =: loanobj.id];
				bankObj.Bank_Account_Number__c=decimal.valueOf(loanobj.Bank_A_c_No_of_Customer__c);
				bankObj.Bank_Acct_Number__c=loanobj.Bank_A_c_No_of_Customer__c;
				bankObj.Bank_Name__c=loanobj.Repayment_Bank_Name__c;
				bankObj.Applicant_Name__c=loanobj.Repayment_Account_Holder_Name__c;
				bankObj.Bank_Name_List__c = loanObj.Repayment_Bank_Name__c;
				update bankObj;
				System.debug('in confirmLA');


			} else if (actionOn.equalsIgnoreCase('Demographic Details')) {
				app.Employee_Modified__c=true;
				Contact contObj = (Contact) JSON.deserialize(contObjString, Contact.class);
				System.debug('in confirmLA');
				update contObj;
			} else if (actionOn.equalsIgnoreCase('Confirm EmployeeLA')) {
				app.Employee_Modified__c=false;
				app.ModifiedStatus__c=null; 
				app.Customer_Decline_Reasons__c = '';
				app.Decline_Reasons__c='';
				loanobj.StageName='Post Approval Sales';
				loanobj.Approval_Stages__c='Approved';

				System.debug('in confirmLA');
				update loanobj;
				update app;
			}
			// if(modifiedFlag!=true){
			update app;
			// }
			return 'details updated';
		} catch (Exception e) {
			Database.rollback(savePointVar);
			System.debug('Exception occured in updateEmplyeeDetails ' + e.getMessage() + ' On line no ' + e.getLineNumber());
			return e.getMessage();
		}    
	}
	public static String RoundRobinEmpLoanOwner(String QueueName,String oppId) {
		String OwnerId;
		System.debug('QueueName==='+QueueName+ 'oppId==='+oppId);
		try{
			boolean selected = false;
			List<User> userDet;
			List<Credit_Officer_Limit__c> COusers;
			System.debug('QueueName==='+QueueName);
			if(QueueName != 'sales'){
				system.debug('here 0');
				List < Group > queue = [Select Id from Group where type = 'Queue'
						and Name =: QueueName
						LIMIT 1
						];
				system.debug('queue is'+queue);
				List < GroupMember > memberList = [Select UserOrGroupId From GroupMember where GroupId IN: queue];
				system.debug('memberList is'+memberList);

				List < String > userList = new List < String > ();
				for (GroupMember u: memberList) {
					system.debug('User or group Id is'+u.UserOrGroupId);
					if (!commonUtility.isEmpty(u.UserOrGroupId) && (String.valueOf(u.UserOrGroupId)).substring(0, 3) == '005'){
						userList.add((String) u.userOrGroupId);
						system.debug('here 6');
					}
				}
				userDet = [Select id, isSelected__c from User where id IN: userList AND IsActive = true];
				system.debug('userList is'+userDet);                

				if (!commonUtility.isEmpty(userDet)) {
					for (User u: userDet) {
						if (u.isSelected__c == false) {
							OwnerId = u.Id;
							u.isSelected__c = true;
							selected = true;
							break;
							system.debug('here 1');
						}
					}

					if (!selected) {
						for (User u: userDet) {
							u.isSelected__c = false;
						}
						OwnerId = userDet[0].id;
						userDet[0].isSelected__c = true;
					}

					update userDet;
				}
			}
			else{
				Opportunity op = [select id,BranchName__c,stageName,Approver__c,Sales_Submit_to_Branch_Ops_Date__c,ownerId from Opportunity where id = : oppId];
				system.debug('op====='+op);
				COusers = [SELECT id, name, City__c, Number_of_Deviations__c, Credit_Officer_Name__r.Isactive,Credit_Officer_Name__r.isSelected__c, 
				           Credit_Officer_Name__r.id, Credit_Officer_Name__r.name, Credit_Officer_Name__c, Designation__c, Loan_Amount__c, User_Type__c, Flow__c
				           FROM Credit_Officer_Limit__c WHERE product__C = 'SPL' AND Credit_Officer_Name__r.Isactive = true AND 
				           Active_Flag__c = true AND User_Type__c = 'OPs User' and City__c INCLUDES( :op.BranchName__c) ];  
				system.debug('COUserList'+COusers);
				if (!commonUtility.isEmpty(COusers)) {
					for (Credit_Officer_Limit__c u: COusers) {
						if (u.Credit_Officer_Name__r.isSelected__c == false) {
							OwnerId = u.Id;
							u.Credit_Officer_Name__r.isSelected__c = true;
							selected = true;
							break;
						}
					}

					if (!selected) {
						for (Credit_Officer_Limit__c u: COusers) {
							u.Credit_Officer_Name__r.isSelected__c = false;
						}
						OwnerId = COusers[0].id;
						COusers[0].Credit_Officer_Name__r.isSelected__c = true;
					}
					update COusers; 
				}
			}
		}catch(Exception e){System.debug('Exception on line '+e.getLineNumber()+e.getMessage());}
		if (Test.isRunningTest()) {
			return String.valueOf(UserInfo.getUserId());
		}
		system.debug('OwnerID is'+OwnerId);
		return OwnerId;
	}
	public static Map < String, Schema.SobjectType > getSobjectTypeMap() {
		Map < String, String > keys = new Map < String, String > ();
		Map < String, Schema.SobjectType > describe = Schema.getGlobalDescribe();
		for (String s: describe.keyset())
			keys.put(describe.get(s).getDescribe().getKeyPrefix(), s);
		return describe;
	}
	@AuraEnabled
	public static String initiateOpenEcsForEmployeeLoanMethod(String opp){
		return InitiateECSController.initiateOpenEcsForEmployeeLoan(opp);

	}
	@AuraEnabled
	public static String sendToFinnoneDirect(String oppId){
		String msg=SAL_PricingCtrlV2.sendToFinnOne(oppId);
		System.debug('FINNONE VALIDATION MESSAGE ADDED'+msg);
		return msg;
	}
	@AuraEnabled
	public static String sendToBranchOps(String oppId){

		try{
			System.debug('talking from sentobranchops');
			Opportunity op = [select id,BranchName__c,stageName,Approver__c,Sales_Submit_to_Branch_Ops_Date__c,ownerId from Opportunity where id = : oppId];

			String officerId= RoundRobinEmpLoanOwner('sales',op.Id);
			System.debug('officerId=='+officerId);
			if (!CommonUtility.isEmpty(officerId)) {
				Credit_Officer_Limit__c col=[select id,Credit_Officer_Name__r.id, Designation__c from Credit_Officer_Limit__c where id =:officerId];
				if (!CommonUtility.isEmpty(col)) {
					op.Approver__c = col.Designation__c;
					op.ownerId = col.Credit_Officer_Name__r.id;
					op.stageName = 'Branch Ops';
					op.Loan_Type__c='Personal Loan';
					op.Sales_Submit_to_Branch_Ops_Date__c = System.now();

				}
			}
			upsert op;
		}catch(Exception e){System.debug('Exception e '+e.getMessage()+e.getLineNumber());}                                         
		return 'pass'; 
	}

	@AuraEnabled
	public static void callCharges(String oppId){
		system.debug('in EMP loan Id is'+oppId);
		List<Fees_and_Charge__c> Fees = [select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
		                                 Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
		                                 Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charge__c where Loan_Application__c = : oppId
		                                 ];
		if(commonUtility.isEmpty(Fees))
		{
			//SALMobilityPricingCntrl_V2.CallChargesAPI(oppId);//commented for 24536
		}
	}



	@AuraEnabled
	public static String getFeesList(String oppId){
		//Added by Aniket Start
		Opportunity loan = new Opportunity();
		AllFeesWrapper dss=new AllFeesWrapper();
		dss.FeesWrapperList = new List<FeesWrapper>();
		dss.FeesToShowOnDisb = new List<FeesWrapper>();

		if(!CommonUtility.isEmpty(oppId)){
			List<Opportunity> oppList = [SELECT id,StageName,/* 20934 s*/Application_Source__c,/*20934 e*/Loan_Amount_with_Premium__c,Loan_Application_Number__c ,Due_Day__c ,Scheme_Master__r.Scheme_Code__c, Approved_Rate__c ,Approved_Tenor__c,Processing_Fees__c ,
			                             (select id, name, Finnone_ChargeId__c, Charge_Desc__c, Tranche_Detail__r.name, Deposition_Date__c, Deposit_Slip_Number__c, Loan_Application__r.name, Change_Amount__c, Charge_Type__c, Deducted_from_Disbursement__c,
			                            		 Service_Charge__c, Status__c, Tranche_Detail__c, Instrument_Date__c, Instrument_No__c, Bank_Branch__c, Instrument_type__c,
			                            		 Amount_after_Service_Change__c, Tranche_Detail__r.Tranche_Number__c from Fees_and_Charges__r)
			                            		 from Opportunity where id = : oppId];
			if(!CommonUtility.isEmpty(oppList)){
				loan = oppList.get(0);
			}
			BRECallout br = new BRECallout();
			List<Fees_and_Charge__c> Fees = new  List<Fees_and_Charge__c> ();
			if(!CommonUtility.isEmpty(loan.Fees_and_Charges__r)){
				Fees = oppList[0].Fees_and_Charges__r;
			}
			Map < String, String > chargesAPIResponse = new MAP < String, String > ();
			Map < String, String > ChargesAPIMap = new Map < String, String > ();
			ChargesAPIMap.put('DealID', (Loan.Loan_Application_Number__c != null) ? String.valueof(Loan.Loan_Application_Number__c) : '0');
			ChargesAPIMap.put('LoanAmount', (Loan.Loan_Amount_with_Premium__c != null) ? String.valueof(Loan.Loan_Amount_with_Premium__c) : '0');
			if(loan.Application_Source__c != null && loan.Application_Source__c.toLowerCase() == 'online employee loan')
				ChargesAPIMap.put('DueDay', (Loan.First_Due_Date__c != null) ? String.valueof(Loan.First_Due_Date__c.day()) : '0');
			else   
				ChargesAPIMap.put('DueDay', (Loan.Due_Day__c != null) ? String.valueof(Loan.Due_Day__c.day()) : '0');
			ChargesAPIMap.put('Scheme', (Loan.Scheme_Master__r.Scheme_Code__c != null) ? String.valueof(Loan.Scheme_Master__r.Scheme_Code__c) : '0');
			ChargesAPIMap.put('RateOfInterest', (Loan.Approved_Rate__c != null) ? String.valueof(Loan.Approved_Rate__c) : '0');
			ChargesAPIMap.put('Tenure', (Loan.Approved_Tenor__c != null) ? String.valueof(Loan.Approved_Tenor__c) : '0');
			system.debug('chargesAPIRequestmap======>' + ChargesAPIMap);

			String res = CommonUtility.getStaticResourceData('SalariedCustomSettings','ChargesAPIIntegration','');
			//System.debug('pk response'+res+fees.size());
			System.debug('Stage name is '+loan.StageName);
			dss.showOnVas='false';

			if(res != null && res.toUpperCase() == 'FALSE' && Fees.size() == 0 && loan.StageName !='DSA/PSF Login') 
			{
				ChargesAPIMap.put('DealID', (Loan != null) ? String.valueof(Loan.id) : '0');
				chargesAPIResponse = CommonUtility.MockChargesAPI(ChargesAPIMap);  
				dss.showOnVas='true';
			}
			else if(res != null && res.toUpperCase() == 'TRUE' && Fees.size() == 0 && loan.StageName !='DSA/PSF Login')
			{
				chargesAPIResponse = br.callCharegesAPIService(ChargesAPIMap); 
				dss.showOnVas='true';

			}
			//Changes for CR
			List<Fees_and_Charge__c> updateFees = new  List<Fees_and_Charge__c> ();
			List<Fees_and_Charge__c> feesToShow = new  List<Fees_and_Charge__c> ();
			system.debug('Fees List is '+Fees);
			if(!commonUtility.isEmpty(Fees)){
				List<String> ChargesShowOnUI = (CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','MandatoryCharges_SkipFromUI','')).split(';'); 
				System.debug('ChargesShowOnUI'+ChargesShowOnUI);           
				for(Fees_and_charge__c feeObj : Fees){
					System.debug('before compare'+feeObj.Finnone_ChargeId__c);           
					if(!ChargesShowOnUI.contains(String.valueOf(feeObj.Finnone_ChargeId__c)))
					{
						System.debug('if equal'+feeObj.Finnone_ChargeId__c); 
						if(feeObj.Change_Amount__c>0){
							feeObj.Deducted_from_Disbursement__c = 'Yes';
							feeObj.Status__c = 'To be collected';
							feeObj.Instrument_type__c = 'Deduct from Disb';
						}
						updateFees.add(feeObj);               
					} 
					else
					{
						feesToShow.add(feeObj);
					}
				}
				update updateFees;
			} 


			if(!commonUtility.isEmpty(feesToShow)){
				for(Fees_and_charge__c FeesObj : feesToShow){
					FeesWrapper wrapperobj = new FeesWrapper();
					wrapperobj.FeesObj = FeesObj;
					if(FeesObj.Deducted_from_Disbursement__c == 'Yes' || commonUtility.isEmpty(FeesObj.Deducted_from_Disbursement__c)){
						wrapperobj.checked = true;

					}
					else{
						wrapperobj.checked = false;
					}
					if(feesObj.Charge_Desc__c !=null)
					{
						if(feesObj.Change_Amount__c != null && feesObj.Deducted_from_Disbursement__c != 'Yes' && feesObj.Charge_Desc__c.contains('EMI CARD') )
						{
							wrapperobj.checked = false;
						}
					}
					wrapperObj.Key = FeesObj.Id +'';
					dss.FeesWrapperList.add(wrapperObj);
					dss.showOnVas='true';
					System.debug('show on VAS '+dss.FeesWrapperList);
				}
			}
			if(!commonUtility.isEmpty(Fees)){
				for(Fees_and_charge__c FeesObj : Fees){
					FeesWrapper wrapperobj = new FeesWrapper();
					wrapperobj.FeesObj = FeesObj;
					if(FeesObj.Deducted_from_Disbursement__c == 'Yes' || commonUtility.isEmpty(FeesObj.Deducted_from_Disbursement__c)){
						wrapperobj.checked = true;

					}
					else{
						wrapperobj.checked = false;
					}
					if(feesObj.Charge_Desc__c !=null)
					{
						if(feesObj.Change_Amount__c != null && feesObj.Charge_Desc__c.contains('EMI CARD')  && FeesObj.Deducted_from_Disbursement__c != 'Yes')
						{
							wrapperobj.checked = false;
						}
					}
					wrapperObj.Key = FeesObj.Id +'';
					dss.FeesToShowOnDisb.add(wrapperObj);
				}
			}
		}
		return Json.serialize(dss);
	}//Added by Aniket Stop

	@AuraEnabled
	public static String calculateEMI(String loan_type,String loan_tenor, String loan_amount,String loan_tenor_initial,String rate) {
		system.debug('hereeeee');
		Double loan_EMI_intial_result = 0.0; 
		Double loan_EMI_result = 0.0;
		Double rate_db = 0.0;
		Integer loan_tenor_int = 0;
		if(String.isNotBlank(rate))
			rate_db=Double.valueOf(rate);
		System.debug('1111  '+loan_tenor);
		if(String.isNotBlank(loan_tenor))    
			loan_tenor_int=Integer.valueOf(loan_tenor);
		list<Double> emiList=new list<Double>();
		try{// String loan_type,Integer loan_tenor, decimal loan_amount,double loan_EMI, double loan_EMI_intial, Integer loan_tenor_initial,double rate

			Decimal loan_amount_db=Decimal.valueOf(String.ValueOf(loan_amount));
			System.debug('All the values '+loan_type+' '+loan_tenor_int+' '+loan_amount_db+' '+loan_tenor_initial);
			//I+' '+loan_EMI_intial+' '+loan_tenor_initial+' '+rate 
			if (loan_type != null && loan_type.endsWithIgnoreCase('Hybrid Loan')) {
				System.debug('in method '+loan_type);
				Double result = 0.0;
				if(loan_amount != null && Integer.valueOf(loan_tenor_initial) !=null && loan_tenor_initial != null && rate != null)
				{
					result = Math.round((loan_amount_db * rate_db) / 1200);
					System.debug('result-->'+result);
				}
				loan_EMI_intial_result =  result;
				emiList.add(loan_EMI_intial_result);
				if (loan_amount != null && rate  != null)
					loan_EMI_result = PMT(Double.valueOf(rate_db / 1200), loan_tenor_int,loan_amount_db);
				System.debug(' Initail EMI  '+ loan_EMI_intial_result+' Subsequent EMI '+loan_EMI_result);
				// String aa=String.valueOf(loan_EMI_result)+' '+String.valueOf(loan_EMI_intial_result);
				emiList.add(loan_EMI_result);
				System.debug('Print emi list  hybrid '+emiList);
				return Json.serialize(emiList);
			}
			else{

				if (loan_amount != null && loan_tenor != null && rate!= null)
					loan_EMI_result = (PMT(double.valueOf(rate_db/ 1200), loan_tenor_int ,loan_amount_db));//decimal.valueOf(loan_amount)
				System.debug(' Final  EMI  '+loan_EMI_result);
				emiList.add(loan_EMI_result);
				System.debug('Print emi list hybrid '+emiList);
				return Json.serialize(emiList);
			}

		}catch(Exception e){
			System.debug('  Error '+e.getMessage()+'  '+e.getLineNumber());
		}
		return 'failed';//+'  '+loan_EMI_intial;

	}
	@AuraEnabled
	public static  double PMT(double rate, integer nper, decimal pv) {
		system.debug('******rate********' + rate + '**nper*' + nper + '*pv**' + pv);
		Double result = 0.0;
		if (pv != null && rate != null && nper != null) {
			result = Math.round((pv * rate) / (1 - Math.pow(1 + rate, -nper)));
			system.debug('****result**' + result);
		}
		return result;
	}

	@AuraEnabled
	public static String saveFeesList(String FeesList){
		system.debug('FeesListFeesList is::::: '+FeesList);
		List<FeesWrapper> AllFeesList = new List<FeesWrapper>();
		List<Fees_and_charge__c> feesobj = new List<Fees_and_charge__c>();
		String oppId;
		system.debug('feesobj is::::: ');
		try{
			if(!CommonUtility.isEmpty(FeesList)){
				AllFeesList =  (List<FeesWrapper>)Json.deserialize(FeesList, List<FeesWrapper>.class);
				system.debug('FeesList is::::: '+AllFeesList);
			}
			if(!commonUtility.isEmpty(AllFeesList)){
				for(FeesWrapper wrapperObj : AllFeesList){
					system.debug('wrapperObj::::: '+wrapperObj);
					if(wrapperObj.checked){

						wrapperObj.FeesObj.Deducted_from_Disbursement__c = 'Yes';
						wrapperObj.FeesObj.Status__c = 'To be collected';
						wrapperObj.FeesObj.Instrument_type__c = 'Deduct from Disb';

					}else{
						wrapperObj.FeesObj.Deducted_from_Disbursement__c = 'No';  
						wrapperObj.FeesObj.Status__c = '';
						wrapperObj.FeesObj.Instrument_type__c = '';
					}

					feesobj.add(wrapperObj.FeesObj);
					oppId=wrapperObj.FeesObj.Loan_Application__c;
					System.debug('opp id is '+wrapperObj.FeesObj.Loan_Application__c);
				}
				update feesobj;
				System.debug('primaryApplicantprimaryApplicant');
				//changes to reset Emandate and customer accepatance start
				Applicant__c primaryApplicant=[select id,Emp_tele_identifier__c,Contact_Name__r.id,IP_Address_Timestamp__c,Application_Form_Timestamp__c,KYC_Verifications__c,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c,Decline_Reasons__c,Customer_Decline_Reasons__c,Employee_Modified__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];

				primaryApplicant.IP_Address_Timestamp__c='';
				primaryApplicant.Application_Form_Timestamp__c='';
				update primaryApplicant; 


				Opportunity op = [select (SELECT Id,Name,Loan_Application__r.Account.Mobile__c FROM RePayment_mode_details__r),(SELECT Id,Name FROM Current_Disbursal_Details_s__r),id,Mode_of_Disbursal__c,Tenor__c,Repayment_Bank_Name__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.is_Pure_Flexi__c,A_C_NO__c,Account.Mobile__c,Account_Holder_Name__c,IFSC_Code__c,First_Due_Date__c,Tenor_Step_1__c,Approved_Tenor__c,EMI_CAM__c,EMI_For_Tenor_2__c,EMI_for_Tenor_1__c,Tenor_Step_2__c,MICR_Number__c,CUSTOMER__c,CUSTOMER__r.Name,PAN_Number__c,Loan_Type__c from Opportunity where id = : oppId];

				List<Current_Disbursal_Details__c> dsList1 = op.Current_Disbursal_Details_s__r;
				if(!CommonUtility.isEmpty(dsList1))
					delete dsList1;
				List<RePayment_mode_detail__c> repayList = op.RePayment_mode_details__r;
				if(!CommonUtility.isEmpty(repayList))
					delete repayList;
				//changes to reset Emandate and customer accepatance stop


				return 'Success';
			}
			return 'No charges to save';
		}
		catch(Exception ex){
			return 'An error Occured while saving';
		}
	}

	@AuraEnabled
	public static String fetchScheme(){
		list <Scheme_Master__c> schemeMaster =new list< Scheme_Master__c>();
		try{
			schemeMaster =[select id,name,employee__c,is_Pure_Flexi__c,flexi_flag__c,IsHybridFlexi__c from Scheme_Master__c where employee__c=true];

		}catch(Exception e){
			System.debug('Exception in fetchScheme '+e.getMessage()+' Line '+e.getLineNumber());
		}
		System.debug('schemeMaster '+schemeMaster+' size '+schemeMaster.size());
		if(schemeMaster!=null && schemeMaster.size()>0){
			return Json.serialize(schemeMaster);
		}else 
			return 'failed';
	}

	public class FeesWrapper{
		@TestVisible
		Fees_And_Charge__c FeesObj;
		@TestVisible
		Boolean checked;
		@TestVisible
		String Key;
	}

	public class AllFeesWrapper{
		@TestVisible
		List<FeesWrapper> FeesWrapperList;
		@TestVisible
		List<FeesWrapper> FeesToShowOnDisb;
		@TestVisible
		String showOnVas;

	}

	public class documentWrapper{
		@TestVisible
		String docName;
		@TestVisible
		Boolean isUploaded;
	}

	@AuraEnabled
	 public static String getDocumentList(String appId){//appId added by swapnil for DMS 24317
		system.debug('inside getDocumentList');
		List <DocumentWrapper> docList = new List<documentWrapper>();  
		List<String> DocName = (CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','EmployeeLoanDocuments','')).split(';');

		system.debug('DocName::::::'+DocName);
		for(String docStr : DocName){
			DocumentWrapper docWrap = new documentWrapper();
			docWrap.docName = docStr;
			docWrap.isUploaded = false;
			docList.add(docWrap);
		}

		List<ContentVersion> docs = (List<ContentVersion>)Json.deserialize(SALMobilityPricingCntrl_V2.getUploadVerification(appId), List<ContentVersion>.class);  //DMS appIadd added by swapnil 24317
		system.debug('docs:::::'+docs);
		//Added by swapnil for DMS 24317 s 
        Applicant__c app=[select id,name,Loan_Application__r.Product__c from Applicant__c where id = : appId];
        Map<String,Object> DMSDocs=new Map<String,Object>();
        DMSDocs= CommonUtility.getDMSDocuments(app.Loan_Application__r.Product__c); //Prod added by swapnil for DMS 24317;        //Added by swapnil for DMS 24317 e
		for(ContentVersion conVer: docs){
			for(DocumentWrapper wrapperObj : docList){
				system.debug('title is:::::'+conver.Title.split('\\.')[0]);
				if(wrapperObj.docName == (conver.Title.split('\\.'))[0] || DMSDocs.get(wrapperObj.docName) == (conver.Title.split('\\.'))[0] ){
					wrapperObj.isuploaded = true;
				}
			}
		}

		return Json.serialize(docList);  
	}

	public static Map<String,Object> getApplicableEMI_Tenor(Applicant__c appObj,Opportunity oppObj){
		System.debug('oppObj.Scheme_Master__r.IsHybridFlexi__c==='+oppObj.Scheme_Master__r.IsHybridFlexi__c);
		Map<String,Object> ApplicableFields = new Map<String,Object>();
		if(oppObj.Scheme_Master__r.IsHybridFlexi__c){
			ApplicableFields.put('Applicable EMI', (appObj.Pure_Flexi_EMI__c + oppObj.EMI_CAM__c));
			ApplicableFields.put('Applicable Tenor', (appObj.Pure_Flexi_Period__c + appObj.Drop_Line_Flexi_Period__c));
		}
		else if(oppObj.Scheme_Master__r.is_Pure_Flexi__c){
			ApplicableFields.put('Applicable EMI', (appObj.Pure_Flexi_EMI__c));
			ApplicableFields.put('Applicable Tenor', (appObj.Pure_Flexi_Period__c));
		}
		else{
			ApplicableFields.put('Applicable EMI', (oppObj.EMI_CAM__c));
			ApplicableFields.put('Applicable Tenor', (oppObj.Tenor__c));
		}
		return ApplicableFields;
	}

	@AuraEnabled
	public static string uploadForModify(String oppId){
		system.debug('here i am');
		EmpLoanWrapper dss = new EmpLoanWrapper();
		Applicant__c primaryApplicant=[select id,Emp_tele_identifier__c,ModifiedStatus__c,Risk_Segmentation__c,IP_Address_Timestamp__c,Application_Form_Timestamp__c,KYC_Verifications__c,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c ,/*DMS 24317s s*/Loan_Application__r.Product__c/*DMS 24317s e*/  from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];
		System.debug('primaryApplicant=='+primaryApplicant);
		List<String> DocName = (CommonUtility.getStaticResourceData('EmployeeLoanStaticResource','EmployeeLoanDocuments','')).split(';');
		System.debug('DocName=='+DocName);
		
		String kycname=DocName[0];
		String pdc1name=DocName[1];
		String pdc2name=DocName[2];
		String pdc3name=DocName[3];
		
		 //Added by swapnil for DMS 24317 s
			String dmsKycname= kycname;
            String DMSPdc1name=pdc1name;  
            String DMSPdc2name=pdc2name;
            String DMSPdc3name=pdc3name;
        
        Map<String,Object> DMSDocs=new Map<String,Object>();
        DMSDocs= CommonUtility.getDMSDocuments(primaryApplicant.Loan_Application__r.Product__c); //Prod added by swapnil for DMS 24317;        //Added by swapnil for DMS 24317 e
        
			if(!commonUtility.isEmpty(DMSDocs.get(kycname)))			
             dmsKycname=(String)DMSDocs.get(kycname); 
		    if(!commonUtility.isEmpty(DMSDocs.get(pdc1name)))			
             DMSPdc1name=(String)DMSDocs.get(pdc1name);
		    if(!commonUtility.isEmpty(DMSDocs.get(pdc2name)))			
             DMSPdc2name=(String)DMSDocs.get(pdc2name); 
		    if(!commonUtility.isEmpty(DMSDocs.get(pdc3name)))			
             DMSPdc3name=(String)DMSDocs.get(pdc3name); 
		   //Added by swapnil for DMS 24317 e
		   
		List<String> Modified_Sections = new List<String>();
		system.debug('modified status is '+primaryApplicant.ModifiedStatus__c);
		if(!CommonUtility.isEmpty(primaryApplicant.ModifiedStatus__c)){
			Modified_Sections = primaryApplicant.ModifiedStatus__c.split(';');
			system.debug('list is '+Modified_Sections);
		}
		if((!CommonUtility.isEmpty(Modified_Sections) && Modified_Sections.contains('C')))
		{
			dss.showKYCError='true';
		}
		if((!CommonUtility.isEmpty(Modified_Sections) && Modified_Sections.contains('B')))
		{
			dss.showRiskSegmentationError='true';
		}

		if(dss.showKYCError!='true' && dss.showRiskSegmentationError!='true') //no error msg set, so send to branchops
		{
			dss.sentToWhere='Exit';
			primaryApplicant.ModifiedStatus__c = 'T';
			primaryApplicant.Emp_tele_identifier__c = true;
			update primaryApplicant;
			dss.primaryApplicant = primaryApplicant;
			return JSON.serialize(dss);
		}
		if(dss.showKYCError=='true' && dss.showRiskSegmentationError!='true') //no error msg set, so send to branchops
		{
			kycname = '%' + kycname + '%';
			dmsKycname = '%' + dmsKycname + '%'; //added by swapnil for DMS 24317
			 if([SELECT id,ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId =: primaryApplicant.id AND (ContentDocument.title like  : kycname  OR ContentDocument.title like: dmsKycname ) ].size() >0)//added by swapnil for DMS 24317
			{
				//KYC document is present, so allow to branchops 
				dss.showKYCError='false';
				dss.showRiskSegmentationError='false';
				dss.sentToWhere='Exit';
				primaryApplicant.ModifiedStatus__c = 'T';
				primaryApplicant.Emp_tele_identifier__c = true;
				update primaryApplicant;
				dss.primaryApplicant = primaryApplicant;
				return JSON.serialize(dss);
			}
		}
		if(dss.showKYCError!='true' && dss.showRiskSegmentationError=='true') //in high risk, so 3 documents are mandatory
		{
			system.debug('Here i am');
			kycname = '%' + kycname + '%';
			pdc1name = '%' + pdc1name + '%';
			pdc2name = '%' + pdc2name + '%';
			pdc3name = '%' + pdc3name + '%';
           //added by swapnil for DMS 24317 s
			 dmsKycname= '%' + dmsKycname + '%';
			 DMSPdc1name='%' + DMSPdc1name + '%';
			 DMSPdc2name='%' + DMSPdc2name + '%';
			 DMSPdc3name='%' + DMSPdc3name + '%';
           //added by swapnil for DMS 24317 s
			if([SELECT id,ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId =: primaryApplicant.id AND (ContentDocument.title like :pdc1name OR ContentDocument.title like :pdc2name OR ContentDocument.title like: pdc3name OR ContentDocument.title like: DMSPdc1name OR ContentDocument.title like: DMSPdc2name OR ContentDocument.title like : DMSPdc3name)].size()>2) //added by swapnil for DMS 24317
			{
				//KYC document is present, so allow to branchops
				dss.showKYCError='false';
				dss.showRiskSegmentationError='false';
				dss.sentToWhere='Exit';
				primaryApplicant.ModifiedStatus__c = 'T';
				primaryApplicant.Emp_tele_identifier__c = true;
				update primaryApplicant;
				dss.primaryApplicant = primaryApplicant;
				return JSON.serialize(dss);
			}
		}
		if(dss.showKYCError=='true' && dss.showRiskSegmentationError=='true') //in high risk, so 3 documents are mandatory
		{
			kycname = '%' + kycname + '%';
			pdc1name = '%' + pdc1name + '%';
			pdc2name = '%' + pdc2name + '%';
			pdc3name = '%' + pdc3name + '%';
			 //added by swapnil for DMS 24317 s
			 dmsKycname= '%' + dmsKycname + '%';
			 DMSPdc1name='%' + DMSPdc1name + '%';
			 DMSPdc2name='%' + DMSPdc2name + '%';
			 DMSPdc3name='%' + DMSPdc3name + '%';
           //added by swapnil for DMS 24317 s
		   
			if([SELECT id,ContentDocument.title FROM ContentDocumentLink WHERE LinkedEntityId =:oppId AND (ContentDocument.title like :pdc1name OR ContentDocument.title like :pdc2name OR ContentDocument.title like: pdc3name OR ContentDocument.title like: DMSPdc1name OR ContentDocument.title like: DMSPdc2name OR ContentDocument.title like : DMSPdc3name)].size()>3)
			{
				//KYC document is present, so allow to branchops
				dss.showKYCError='false';
				dss.showRiskSegmentationError='false';
				dss.sentToWhere='Exit';
				primaryApplicant.ModifiedStatus__c = 'T';
				primaryApplicant.Emp_tele_identifier__c = true;
				update primaryApplicant;
				dss.primaryApplicant = primaryApplicant;
				return JSON.serialize(dss);
			}
		}

		return JSON.serialize(dss);
	}

	// Start of changes - 22181
	// Added by Anurag for 23390 S
	public class InsuranceWrapper{
		public List<DPLinsurance__c> listInsurance;
		public boolean oppHasInsurance;
		// public Integer size;
	}
	@AuraEnabled
	public static String getInsuranceList(String loanId){
		try{
			InsuranceWrapper insuranceWrpObj = new InsuranceWrapper();
			List<DPLinsurance__c> insuranceLst = [SELECT Id FROM DPLinsurance__c WHERE Opportunity__c =: loanId];
			insuranceWrpObj.oppHasInsurance = false;
			insuranceWrpObj.listInsurance = insuranceLst;
			// insuranceWrpObj.size = insuranceLst.size();
			if(insuranceWrpObj.listInsurance != null && insuranceWrpObj.listInsurance.size() > 0)
				insuranceWrpObj.oppHasInsurance = true;
			return JSON.serialize(insuranceWrpObj);
		}
		catch(Exception e){
			System.debug('Exception in method getInsuranceList: '+e+' Line number: '+e.getLineNumber());
			return null;
		}
	}
	// Added by Anurag for 23390 E
	@AuraEnabled
	public static String validateInsuranceDetails(String loanId) {
		return ValidateDPLSTF.validateInsuranceDetails(loanId);
	}

	@AuraEnabled
	public static String validateSendFinnone(String loanId) {
		return ValidateDPLSTF.validateSendFinnone(loanId);
	}

	@AuraEnabled
	public static String fdQuesValidate(String loanId) {
		return PricingDisbmntDetails_Ctrl.fdQuesValidate(loanId);
	}

	@Future(callout=true)
	public static void calculateFoir(String loanId){
		SalesEligibilityDetailsCtrl se = new SalesEligibilityDetailsCtrl(loanId);
		se.CalculateSegmentation();
	}
	// End of changes - 22181
	public static Decimal getNetAmount(String oppId)
	{ 
		Decimal nb_amount;
		if(!CommonUtility.isEmpty(oppId))
		{ 
			Decimal total=0;
			Opportunity oppObj = [select id,Tenor__c,Scheme_Master__r.IsHybridFlexi__c,Scheme_Master__r.is_Pure_Flexi__c,Account.Mobile__c,StageName,Loan_Application_Number__c,Name,Bank_Name__c,A_C_Type__c,IFSC_Code__c,Favouring__c,Bank_A_c_No_of_Customer__c, Product__c, Loan_Type__c, Approved_Loan_Amount__c, Loan_Amount_with_Premium__c, Approved_Rate__c, EMI_CAM__c, Approved_Tenor__c, Amount_Rs__c from Opportunity where id =: oppId];
			Applicant__c primaryApplicant=[select id,Emp_tele_identifier__c,Contact_Name__r.id,IP_Address_Timestamp__c,Application_Form_Timestamp__c,Pure_Flexi_Period__c,Drop_Line_Flexi_Period__c,Pure_Flexi_EMI__c,Decline_Reasons__c,Customer_Decline_Reasons__c,Employee_Modified__c from Applicant__c where Loan_Application__c =: oppId AND Applicant_Type__c ='Primary' ];

			AggregateResult[] groupedResults=[select SUM(Change_Amount__c)total from Fees_and_Charge__c  where Loan_Application__c =: oppId and Deducted_from_Disbursement__c='Yes'];
			if(!CommonUtility.isEmpty(groupedResults) && groupedResults[0].get('total')!=null){
				total = (decimal)groupedResults[0].get('total');}
			nb_amount = oppObj.Loan_Amount_with_Premium__c-(total); //removed stampduty
			if(nb_amount != null)
			{
				System.debug(nb_amount);
				return nb_amount;
			}
		}
		return 0;  
	}
	/*DMS bug 24317    s*/
    @AuraEnabled
    public static Map<String,Object>  getDMSDocuments(String product){
        Map<String,Object> DMSDocs=new Map<String,Object>();
        DMSDocs= CommonUtility.getDMSDocuments(product);
        return DMSDocs;
    }
	/*DMS bug 24317    e*/
}