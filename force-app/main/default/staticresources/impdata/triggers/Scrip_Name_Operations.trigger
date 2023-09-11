trigger Scrip_Name_Operations on Scrip_Name__c (before update) //US:27456 Removed after update
{
	System.debug('>>>> In Scrip_Name_Operations -- Doing post loan creation activities');
    
    Map<String, Scrip_Name__c> scrips = new Map<String, Scrip_Name__c>(); // map to store all the scrips and its loan application number which we got from single_screen
    map<String,Applicant__c> loanApplicantMap = new map<String,Applicant__c>();  
    map<String,String> loanScripMap = new map<String,String>();
    if(trigger.isBefore && trigger.isUpdate){ //US:27456 Added if to ensure code runs only in before update context
    	for(Scrip_Name__c scrip : trigger.new)
        {
            if( scrip.status__c == 'Processed' && String.isNotBlank(scrip.Loan_Application_Number__c))//scrip.flow__c == 'Single_Screen' && commented
            {
                scrips.put(scrip.Loan_Application_Number__c, scrip);
                loanScripMap.put(scrip.Id,scrip.Loan_Application_Number__c);
            }
        }
    
    if( scrips != NULL && scrips.size() > 0 )
    {       
        System.debug('Processing with following scrip_name records : ' + scrips.keyset() );
        
        
        List<Applicant__c> apps = [SELECT Id, Contact_Name__c, Loan_Application__c, Loan_Application__r.Loan_Application_Number__c, 
                                   Loan_Application__r.Account.Id,Applicant_Type__c from Applicant__c WHERE Loan_Application__c in 
                                   (select id from Opportunity where Loan_Application_Number__c in : scrips.keySet() )];
    
        //To store all the contact Id w.r.to Loan Application, which we'll use to fetch scrip data from scrips map 
		Map<Id, String> cIds = new Map<Id, String>();
        
        for(Applicant__c app : apps)
        {
            if( String.isNotBlank(app.Contact_Name__c))
            {
                cIds.put(app.Contact_Name__c,  app.Loan_Application__r.Loan_Application_Number__c);
            }
            if(String.isNotBlank(app.Applicant_Type__c) && app.Applicant_Type__c.equalsIgnoreCase('Primary'))
            	loanApplicantMap.put(app.Loan_Application__r.Loan_Application_Number__c,app);
        }
        system.debug('Loan Applicant map****'+loanApplicantMap);
       	Map<Id, Contact> cMap = new Map<Id, Contact>([SELECT 
                                                      		Id, Gender__c, Marital_Status__c, Residence_City__c, 
                                                      		State__c, Occupation_Ckyc__c, Qualification__c 
                                                      FROM 
                                                      		Contact 
                                                      WHERE 
                                                      		Id in: cIds.keySet() ]);
        
        List<Contact> consToUpdate = new List<Contact>();        
        
     	for(Contact cons : cMap.values() )
        {
            if( cIds.containsKey(cons.Id) && scrips.containsKey(cIds.get(cons.Id)) ){
                Scrip_Name__c sc = scrips.get( cIds.get( cons.Id ) );                
                cons.Gender__c  = sc.Gender__c;
                cons.Marital_Status__c = sc.Marital_Status__c;
                cons.Residence_City__c = sc.City__c;
                cons.State__c = sc.State__c;
                cons.Occupation_CKYC__c  = sc.Occupation__c;
                cons.Qualification__c = sc.Profession__c;
                
                //--Modifying only if the trigger is running in before trigger method. 
                if(trigger.isBefore)
                {
                    sc.Status__c = 'Processed with Post Loan Creation Activities';    
                }
                
                consToUpdate.add(cons);
            }
            else
            {
                continue;
            }
        }
               
        //--- Getting all the loan applications from 
        List<Scrip_Name__c> scripsOfBulkUpload = new List<Scrip_Name__c>();
        List<String> scripsOfSingleScreen = new List<String>();
        List<String> scripLoanIds = new List<String>();
        List<String> screenScripLoanIds = new List<String>();
        List<StakeHolder__c> stakeholderToUpdate = new List<StakeHolder__c>();
        for(Scrip_Name__c sc : scrips.values())
        {
            if(sc.Flow__c == 'Bulk_Upload')
            {
                if( String.isNotBlank(sc.Loan_Application_Number__c) )
                	scripLoanIds.add(sc.Loan_Application_Number__c);
                scripsOfBulkUpload.add(sc);
            }
            if(sc.Flow__c == 'Single_Screen')
            {
                system.debug('Inside single screen if***'+sc.Loan_Application_Number__c);
                if( String.isNotBlank(sc.Loan_Application_Number__c) )
                	scripsOfSingleScreen.add(sc.Id);
            }
        }
        
        system.debug('Scrip Id***'+scripsOfSingleScreen);
        if(scripsOfSingleScreen != NULL && scripsOfSingleScreen.size() > 0 )
        {
            List<Stakeholder__c> holders = [SELECT Id,Name,Applicant__c,Account__c,Applicant_type__c,
                                            Loan_Application__c,Used_For__c,Scrip_Name__c,Scrip_Name__r.Loan_Application_Number__c,
                                            Insurance_Company_Name__c,Policy_Number__c,Policy_Type__c,Policy_Commencement_Date__c,
                                            Remarks__c
                                            FROM Stakeholder__c WHERE Scrip_Name__c IN :scripsOfSingleScreen];
            
            for(Stakeholder__c s: holders)
            {
                Stakeholder__c st = new Stakeholder__c();
                st.Used_For__c = 'LAIP';
                st.Insurance_Company_Name__c = s.Insurance_Company_Name__c;
                st.Policy_Number__c = s.Policy_Number__c;
                st.Policy_Type__c = s.Policy_Type__c;
                st.Policy_Commencement_Date__c = s.Policy_Commencement_Date__c;
                st.Remarks__c = s.Remarks__c;
                system.debug('Inside for***'+loanScripMap.get(s.Scrip_Name__c));
                
                if(string.isNotBlank(loanScripMap.get(s.Scrip_Name__c)))
                {
                    
                    system.debug('Account***'+loanApplicantMap.get(loanScripMap.get(s.Scrip_Name__c)).Loan_Application__r.Account.Id);                    
                    
                    st.Account__c = loanApplicantMap.get(loanScripMap.get(s.Scrip_Name__c)).Loan_Application__r.Account.Id;
                	st.Applicant__c = loanApplicantMap.get(loanScripMap.get(s.Scrip_Name__c)).Id;
                	st.Applicant_type__c = loanApplicantMap.get(loanScripMap.get(s.Scrip_Name__c)).Applicant_Type__c;
                	st.Loan_Application__c = loanApplicantMap.get(loanScripMap.get(s.Scrip_Name__c)).Loan_Application__c;
                }
                stakeholderToUpdate.add(st);
            }
        }
        
        if(scripsOfBulkUpload != NULL && scripsOfBulkUpload.size() > 0 )
        {
            //Added Property_Status__c in query for Bug: 27460
            List<Property_Details__c> props = [SELECT Id,Property_Status__c,Investment_start_date__c,  PI_Number__c, Loan_Application__c, Loan_Application__r.Sour_Channel_Name__c, Loan_Application__r.AccountId, Loan_Application__r.Loan_Application_Number__c FROM Property_Details__c WHERE Loan_Application__c in (SELECT Id FROM Opportunity WHERE Loan_Application_Number__c in :scripLoanIds )];
            Set<String> uniquePolicyNumbers = new Set<String>(); //Check if policy number is already created. 

            for(Property_Details__c prop :  props)
            {
                if(prop != NULL && prop.Pi_Number__c != NULL && uniquePolicyNumbers.contains(prop.Pi_Number__c)  )
                {
                    continue;
                }                    
                else if(prop != NULL && prop.Pi_Number__c != NULL)
                {
                    uniquePolicyNumbers.add(prop.Pi_Number__c); 
                }

                Stakeholder__c sh = new Stakeholder__c();                
                sh.Policy_Number__c = prop.Pi_Number__c;
                sh.Loan_Application__c = prop.Loan_Application__c;
                sh.Policy_Type__c=prop.Property_Status__c; // Bug:27460
                if(prop.Investment_start_date__c != NULL)
                {
                    Integer d = prop.Investment_start_date__c.day();
                    Integer mo = prop.Investment_start_date__c.month();
                    Integer yr = prop.Investment_start_date__c.year();
                    Date dt = Date.newInstance(yr, mo, d);
					sh.Policy_Commencement_Date__c = dt;
                }                                
				sh.Used_For__c = 'LAIP';     
                sh.Account__c = prop.Loan_Application__r.AccountId;
                sh.Insurance_Company_Name__c = prop.Loan_Application__r.Sour_Channel_Name__c;
                sh.Scrip_Name__c  = scrips.get(prop.Loan_Application__r.Loan_Application_Number__c).Id;
                sh.Applicant__c = loanApplicantMap.get(prop.Loan_Application__r.Loan_Application_Number__c).Id;
                sh.Applicant_type__c = loanApplicantMap.get(prop.Loan_Application__r.Loan_Application_Number__c).Applicant_Type__c;
                stakeholderToUpdate.add(sh);
            }
        }
        
        
        if(consToUpdate != NULL && consToUpdate.size() > 0) 
        {
            System.savePoint sp =  Database.setSavepoint();
            try
            {
                update consToUpdate;
                
                System.debug('stakeholderToUpdate :: ' + stakeholderToUpdate);
                if(stakeholderToUpdate != NULL && stakeholderToUpdate.size() > 0 )
                {
                    upsert stakeholderToUpdate;
                }                
            }
            catch(Exception e)
            {
                Database.rollback(sp);
                System.debug('Something went wrong : ' + e);
            }
        }
    }    
  }//US:27456 End of if
}