trigger WeakAccountMonitoring on Weak_Account__c (before insert, before update,after insert,after update) {
  
 // public static Set<Id> samedatafound = new Set<Id>();
 List<Weak_Account__c> tempObjList = new  List<Weak_Account__c>();
 
 //Property Owner
 Map<Property_Details__c,Id> propMap = new Map<Property_Details__c,Id>();
 List<Property_Details__c> propListUpdate = new List<Property_Details__c>();
 Map<Id,String> weakIdOwnerChange = new Map<Id,String>();
 
 if(Trigger.isBefore)
 {
  
  if(Trigger.isInsert)
  {
       //update hierarchy as per LAN no.  
       //system.debug('samedatafoundm ='+samedatafound);
        Map<Id,Weak_Account__c> weakAccUpdate=new Map<Id,Weak_Account__c>();
        
        //start -- On Loan Info
              Map<String,Weak_Account__c> waMap = new Map<String,Weak_Account__c>();
        //end
        
        Set<String> LANNo = new Set<String>();
        
        //Hierarchy stamping 
            //List<String> branchIdList = new List<String>();
            String branchStr = '';
            List<String> productList = new List<String>(); 
            String prodStr = '';    
            List<Weak_Account__c> weakListHierStamp = new List<Weak_Account__c>();
        //end hierarchy stamping 
        
         for(Weak_Account__c weakNew: trigger.new)
         {            
               LANNo.add(weakNew.LAN_No__c);
               
             //start -- On Loan Info
              // if(weakNew.Bounce__c != 0)
                        waMap.put(weakNew.LAN_No__c,weakNew); 
               
             //end
                    if(weakNew.SFProductCode__c!=null && weakNew.Branch_Name__c != null)
                    { 
                        //branchIdList.add(weakNew.Branch_Name__c);
                        //branchIdList.add(weakNew.Branch_City__c);
                        
                        branchStr += (branchStr==''?'':';')+weakNew.Branch_City__c;
                        
                        productList.add(weakNew.SFProductCode__c);
                        
                        prodStr += (prodStr==''?'':';')+weakNew.SFProductCode__c;
                   }
         }
         
         System.debug('waMap='+waMap+'branchStr='+branchStr+'prodStr='+prodStr);
         
         List<Opportunity> lanList=new List<Opportunity>();
         lanList=[select Loan_Application_Number__c,Area_SM__c,Zonal_SM__c,Regional_SM__c,National_SM__c,ACM__c,CEO__c,RCM__c from Opportunity where Loan_Application_Number__c In:LANNo];
         
         Map<String,Opportunity> oppMap=new Map<String,Opportunity>();
         for(Opportunity opp:lanList)
         {
            oppMap.put(opp.Loan_Application_Number__c,opp);
         }
         
         List<Weak_Account__c> weakAccList=new List<Weak_Account__c>();
         //flag declared by leena 
         //purpose :- to decide weather the flow is of Mortgage portfolio monitoring or weak account monitoring
         // bug id:-9200 
         boolean portfolioDecisionFlag=false;
         //Mortgage portfolio monitoirng-leena-start -bug id :-9200
          for(Weak_Account__c weakNew: trigger.new)
         {
             if(weakNew.Identified_for_Portfolio_monitoring__c==true)
             {
                 portfolioDecisionFlag=true;
             }
         }
          //Mortgage portfolio monitoirng-leena-end -bug id :-9200
         system.debug('portfolioDecisionFlag====>'+portfolioDecisionFlag);
          //Mortgage portfolio monitoirng-leena-start -bug id :-9200
         if(portfolioDecisionFlag)
         {
             weakAccList=[select id,CreatedDate,Identified_for_Portfolio_monitoring__c,Last_decision_date__c ,Bounce__c,Account_Status__c,LAN_No__c,Month_of_Bounce__c from Weak_Account__c where Identified_for_Portfolio_monitoring__c=true and LAN_No__c In :LANNo];
         }
         else
         {
         weakAccList=[select id,Bounce__c,CreatedDate,Identified_for_Portfolio_monitoring__c,Last_decision_date__c ,Account_Status__c,LAN_No__c,Month_of_Bounce__c from Weak_Account__c where Account_Status__c != 'Regularised' and LAN_No__c In :LANNo];
         }
            //Mortgage portfolio monitoirng-leena-end -bug id :-9200   
                system.debug('weakAccList====>'+weakAccList);    
         Map<String,Weak_Account__c> weakAccLANMap=new Map<String,Weak_Account__c>();
         
         for(Weak_Account__c acc:weakAccList)
         {
            weakAccLANMap.put(acc.LAN_No__c,acc);
            //System.debug('acc.Status='+acc.Account_Status__c+'=acc.LAN_No__c='+acc.LAN_No__c);
         }   
           system.debug('weakAccLANMap====>'+weakAccLANMap); 
         //System.debug('lanList='+lanList.size()+'oppMap='+oppMap.size()+'weakAccList='+weakAccList.size()+'weakAccLANMap='+weakAccLANMap.size());
              
     for(Weak_Account__c weakNew: trigger.new)
     {             
      
        if(weakAccLANMap.containsKey(weakNew.LAN_No__c) == false)
        {            
         
           system.debug('inside if====>'); 
         if(oppMap.containsKey(weakNew.LAN_No__c))
         {
            
            //No Insertion of new record in weak account if LAN no is new and bounce =0
             //Mortgage portfolio monitoirng-leena-start -bug id :-9200
            if(weakNew.Bounce__c == 0 && weakNew.Identified_for_Portfolio_monitoring__c==false)
            {
                weakNew.DuplicateAccount__c=true;
                System.debug('weakNew.DuplicateAccount__c='+weakNew.DuplicateAccount__c);
            }
         else
         {
                //update 1st stage as Score Card To be Updated
                 //Mortgage portfolio monitoirng-leena-start -bug id :-9200
                if(weakNew.Identified_for_Portfolio_monitoring__c==false)
                {
                weakNew.Account_Status__c = 'Score Card To be Updated';
                }
                
                //Create map for hierarchy stamping
                weakListHierStamp.add(weakNew);
               /* Opportunity newOpp=oppMap.get(weakNew.LAN_No__c);
                System.debug('newOpp='+newOpp);
                
                if(newOpp!=null){   
                    
                   System.debug('NSM='+newOpp.National_SM__c+'RSM='+newOpp.Regional_SM__c+'RCM='+newOpp.RCM__c+'ZCM='+newOpp.CEO__c+'ZSM='+newOpp.Zonal_SM__c+'ACM='+newOpp.ACM__c+'ASM='+newOpp.Area_SM__c);
                   
                   weakNew.NSM__c=newOpp.National_SM__c;
                   weakNew.RSM__c=newOpp.Regional_SM__c;
                   weakNew.RCM__c=newOpp.RCM__c;
                   weakNew.ZCM__c=newOpp.CEO__c;
                   weakNew.ZSM__c=newOpp.Zonal_SM__c;
                   weakNew.ACM__c=newOpp.ACM__c;
                   weakNew.ASM__c=newOpp.Area_SM__c;       
                }
           */
           
            }
         }   
       }
       else if(weakAccLANMap.containsKey(weakNew.LAN_No__c) == true)
       {
            system.debug('inside else if====>'); 
             //Mortgage portfolio monitoirng-leena-start -bug id :-9200
           if(weakNew.Identified_for_Portfolio_monitoring__c==true)
           {
              // integer diff=0;
                system.debug('inside  if duplicate====>'); 
               system.debug('weakNew.Last_decision_date__c===>'+weakNew.Last_decision_date__c);
                
                   Weak_Account__c oldWA=weakAccLANMap.get(weakNew.LAN_No__c);
                     system.debug('oldWA.createdDate==>'+oldWA.createdDate);
              // diff=(weakNew.Last_decision_date__c).monthsBetween(Date.valueOf(oldWA.createdDate)) ;
               if(oldWA.createdDate>weakNew.Last_decision_date__c)
               {  
                       weakNew.DuplicateAccount__c=true;            
               }
           }
            //Mortgage portfolio monitoirng-leena-end -bug id :-9200
           else
           {
                system.debug('inside  else  duplicate====>'); 
            weakNew.DuplicateAccount__c=true;        
           }
                    
                //Month of bounce coming from datamart
                 //Mortgage portfolio monitoirng-leena-start -bug id :-9200
                if(weakNew.Identified_for_Portfolio_monitoring__c==false)
                {
                           Weak_Account__c oldWA=weakAccLANMap.get(weakNew.LAN_No__c);
                           
                           if(weakNew.Customer_ID__c!=null)
                           {
                              oldWA.Customer_ID__c = weakNew.Customer_ID__c;
                           }
                           if(weakNew.Deal_ID__c!=null)
                           {
                            oldWA.Deal_ID__c = weakNew.Deal_ID__c;
                           }                   
                           if(weakNew.Present_Property_Value__c!=null)
                           {
                            oldWA.Present_Property_Value__c = weakNew.Present_Property_Value__c;
                           }
                           if(weakNew.FOIR__c!=null)
                           {
                            oldWA.FOIR__c = weakNew.FOIR__c;
                           }
                           //if(weakNew.Bounce_in_last_12_months__c!= oldWA.Bounce_in_last_12_months__c){
                            oldWA.Bounce_in_last_12_months__c = weakNew.Bounce_in_last_12_months__c;
                           //}                   
                           /*if(weakNew.Bounce_in_last_3_months__c!= oldWA.Bounce_in_last_3_months__c){
                            oldWA.Bounce_in_last_3_months__c = weakNew.Bounce_in_last_3_months__c;
                           }*/
                           if(weakNew.Bounce_in_last_6_months__c != oldWA.Bounce_in_last_6_months__c)
                           {
                            oldWA.Bounce_in_last_6_months__c = weakNew.Bounce_in_last_6_months__c;
                           }
                            if(weakNew.Email_Id__c!=null)
                            {
                                oldWA.Email_Id__c = weakNew.Email_Id__c;
                            }
                            if(weakNew.Address_of_Applicant__c!=null)
                            {
                                oldWA.Address_of_Applicant__c = weakNew.Address_of_Applicant__c;
                            }
                            if(weakNew.Address_of_Co_Applicant__c!=null)
                            {
                                oldWA.Address_of_Co_Applicant__c = weakNew.Address_of_Co_Applicant__c;
                            }                      
                            if(weakNew.Loan_Amount__c!=null)
                            {
                                oldWA.Loan_Amount__c = weakNew.Loan_Amount__c;
                            }                    
                            if(weakNew.POS__c!=null)
                            {
                                oldWA.POS__c = weakNew.POS__c;
                            }
                            if(weakNew.ROI__c!=null)
                            {
                                oldWA.ROI__c = weakNew.ROI__c;
                            }
                            if(weakNew.EMI__c!=null){
                                oldWA.EMI__c = weakNew.EMI__c;
                            }
                            if(weakNew.Tenor__c!=null)
                            {
                                oldWA.Tenor__c = weakNew.Tenor__c;
                            }
                            if(weakNew.MOB__c!=null)
                            {
                                oldWA.MOB__c = weakNew.MOB__c;
                            }
                            if(weakNew.O_s_Overdue_Charges__c!=null)
                            {
                              oldWA.O_s_Overdue_Charges__c = weakNew.O_s_Overdue_Charges__c;    
                            }
                            if(weakNew.O_s_Bounce_Charges__c!=null)
                            {
                                oldWA.O_s_Bounce_Charges__c = weakNew.O_s_Bounce_Charges__c;
                            }
                            if(weakNew.Property_Address__c!=null)
                            {
                                oldWA.Property_Address__c = weakNew.Property_Address__c;
                            }
                            if(weakNew.PDD_Pendency__c!=null)
                            {
                                oldWA.PDD_Pendency__c = weakNew.PDD_Pendency__c; 
                            }
                            if(weakNew.Disbursement_Date__c!=null)
                            {
                                oldWA.Disbursement_Date__c = weakNew.Disbursement_Date__c;
                            }
                            if(weakNew.Branch_Name__c!=null)
                            {
                                oldWA.Branch_Name__c = weakNew.Branch_Name__c;
                            }                   
                            if(weakNew.Customer_Name__c!=null)
                            {
                                oldWA.Customer_Name__c = weakNew.Customer_Name__c;
                            }
                            if(weakNew.Co_Applicant_Name__c !=null)
                            {
                                oldWA.Co_Applicant_Name__c = weakNew.Co_Applicant_Name__c;
                            }
                            
                            //update status
                            
                            //integer boun= 1-7-15
                             //if((oldWA.Month_of_Bounce__c.equals(weakNew.Month_of_Bounce__c)) && (oldWA.Bounce__c == weakNew.Bounce__c)){
                             if(oldWA.Month_of_Bounce__c != null && oldWA.Month_of_Bounce__c.equals(weakNew.Month_of_Bounce__c))
                             {
                                
                               // System.debug('oldWA.Account_Status__c='+oldWA.Account_Status__c+'oldWA.Bounce__c='+oldWA.Bounce__c);
                                    
                                    if(weakNew.Bounce__c == 0)
                                    {
                                        oldWA.Account_Status__c='Regularised';
                                    }
                                    
                                    if(oldWA.Account_Status__c == 'CL 1 Sent')
                                    {
                                        oldWA.Account_Status__c = 'CL 1 Watch List';
                                    }
                                    
                                   
                                    if(oldWA.Account_Status__c == 'CL 2 Sent'){
                                        oldWA.Account_Status__c = 'CL 2 Watch List';
                                    }                   
                                    
                             }
                             else 
                             {
                                    //
                                    if(oldWA.Account_Status__c == 'Watchlist'){
                                        oldWA.Account_Status__c = 'Score Card To be Updated';
                                    }
                                    
                                    if(oldWA.Account_Status__c == 'CL 1 Sent' || oldWA.Account_Status__c == 'CL 1 Watch List')
                                    {
                                        oldWA.CL_2_to_be_Sent__c = true;
                                    }
                                    
                                    if(oldWA.Account_Status__c == 'CL 2 Sent' || oldWA.Account_Status__c == 'CL 2 Watch List')
                                    {
                                        oldWA.CL_3_to_be_Sent__c = true;
                                    }
                                    
                                    oldWA.Month_of_Bounce__c = weakNew.Month_of_Bounce__c;
                                    //oldWA.Bounce__c = weakNew.Bounce__c;
                              }
                                     System.debug('oldWA.Account_Status__c='+oldWA.Account_Status__c);
                             
                                    if(weakNew.Bounce__c != null)
                                    {
                                        oldWA.Bounce__c = weakNew.Bounce__c;
                                    }
                        
                               System.debug('oldWA.Bounce__c='+oldWA.Bounce__c+'=weakNew.Bounce__c='+weakNew.Bounce__c);
                      
                              weakAccUpdate.put(oldWA.id,oldWA);  
                }
          
       }
     }
     
        if(weakAccUpdate!=null && weakAccUpdate.size()>0)
        {
           //update tempObjList;  
            update weakAccUpdate.Values();
            //samedatafound = true;
        }
     //End update hierarchy as per LAN no. 
     
             //Start -- On Loan Info
             System.debug('keySet()='+waMap.keySet());
                
                Map<String,Loan_INFO__c> LoanInfoMap = new Map<String,Loan_INFO__c>();              
                
                for(Loan_INFO__c info:[select id,Loan_Number__c,Weak_Account_Status__c from Loan_INFO__c where Loan_Number__c IN :waMap.keySet()])
                {
                    LoanInfoMap.put(info.Loan_Number__c,info);
                }                   
                
                //List<Loan_INFO__c> newLoanInfoList = new List<Loan_INFO__c>();
                Map<String,Loan_INFO__c> newLoanInfoMap = new Map<String,Loan_INFO__c>();   
                
                for(String lan:waMap.keySet())
                {
                    if(!LoanInfoMap.containsKey(lan))
                    {
                        if(waMap.get(lan).Identified_for_Portfolio_monitoring__c==false)
                        {
                        Loan_INFO__c info = new Loan_INFO__c();
                        info.Name = 'WA-'+lan;
                        info.Loan_Number__c = lan;
                        info.Weak_Account_Status__c = 'Live';
                        
                        //newLoanInfoList.add(info);
                        newLoanInfoMap.put(lan,info);
                        }
                        //insert newLoanInfoList;
                    }
                    else
                    {
                        if(waMap.get(lan).Bounce__c != 0 && waMap.get(lan).Identified_for_Portfolio_monitoring__c==false)
                        {
                            Loan_INFO__c loanInfo = LoanInfoMap.get(lan);
                            loanInfo.Weak_Account_Status__c = 'Live';
                        
                            //newLoanInfoList.add(loanInfo);
                            newLoanInfoMap.put(lan,loanInfo);
                        }                       
                        
                        //update newLoanInfoList;
                    }
                }
                //System.debug('newLoanInfoMap.size()='+newLoanInfoMap.size());
                if(newLoanInfoMap!=null && newLoanInfoMap.size()>0)
                    upsert newLoanInfoMap.values();
                
                
                    //now update Weak account with id of Loan info
                    Map<String,id> loanMap = new Map<String,id>();
                    
                    //List<Loan_INFO__c> loanInfoList=[select id,Loan_Number__c,Weak_Account_Status__c from Loan_INFO__c where Loan_Number__c IN :waMap.keySet()];
                    List<Loan_INFO__c> loanInfoList=LoanInfoMap.values();
                    System.debug('loanInfoList.size()='+loanInfoList.size());               
                    
                    for(Loan_INFO__c Loaninfo:loanInfoList){
                        loanMap.put(Loaninfo.Loan_Number__c,Loaninfo.id);
                    }
                    System.debug('loanMap.size()='+loanMap.size()+'-loanMap-'+loanMap);
                    
                    //List<Weak_Account__c> weakListUpdate = new List<Weak_Account__c>();
                        for(Weak_Account__c weak : trigger.New)
                        {   
                            if(weak.Identified_for_Portfolio_monitoring__c==false)
                            {
                            System.debug('loanMap.get(weak.LAN_No__c)='+loanMap.get(weak.LAN_No__c));           
                            weak.Loan_INFO__c = loanMap.get(weak.LAN_No__c);    
                            }
                        }               
                    
                    //end update Weak account with id of Loan info
                
            //end -- On Loan Info 
            
            //start Hierarchy stamp
            
                Map<String,Sales_Officer_Limit__c> salesMap = new Map<String,Sales_Officer_Limit__c>();
                //Map<String,Sales_Officer_Limit__c> salesFinalMap = new Map<String,Sales_Officer_Limit__c>();
                
                Set<String> SalesLevel1 = new Set<String>();
                Set<String> SalesLevel2 = new Set<String>();
                Set<String> SalesLevel3 = new Set<String>();
                Set<String> SalesLevel4 = new Set<String>();
 
                 if(LaonApplicationCreation__c.getValues('Hierarchy Stamping')!=null){
                            //Start - Sales Level 1 
                            String salesHierarchyLevel1 = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Sales_Level_1__c;
                            if(salesHierarchyLevel1!=null){ 
                                system.debug('***salesHierarchyLevel1***'+salesHierarchyLevel1); 
                                String[] sales1 = salesHierarchyLevel1.split(';');
                                for(String str:sales1){
                                   SalesLevel1.add(str); 
                                }   
                            }
                            //End - Sales Level 1 
                            
                            //Start - Sales Level 2
                            String salesHierarchyLevel2 = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Sales_Level_2__c;
                            if(salesHierarchyLevel2!=null){ 
                                system.debug('***salesHierarchyLevel2***'+salesHierarchyLevel2); 
                                String[] sales2 = salesHierarchyLevel2.split(';');
                                for(String str:sales2){
                                   SalesLevel2.add(str); 
                                }   
                            }
                            //End - Sales Level 2 
                           
                           String salesHierarchyLevel3 = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Sales_Level_3__c;
                            if(salesHierarchyLevel3!=null){ 
                                system.debug('***salesHierarchyLevel3***'+salesHierarchyLevel3); 
                                String[] sales3 = salesHierarchyLevel3.split(';');
                                for(String str:sales3){
                                   SalesLevel3.add(str); 
                                }   
                            }
                            //End - Sales Level 3 

                            String salesHierarchyLevel4 = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Sales_Level_4__c;
                                if(salesHierarchyLevel4!=null){ 
                                    system.debug('***salesHierarchyLevel3***'+salesHierarchyLevel3); 
                                    String[] sales4 = salesHierarchyLevel4.split(';');
                                    for(String str:sales4){
                                       SalesLevel4.add(str); 
                                    }   
                                }
                                //End - Sales Level 4                           
                            
                         }
                        
                        System.debug('SalesLevel1='+SalesLevel1+'SalesLevel1.size()='+SalesLevel1.size());
                        System.debug('SalesLevel2='+SalesLevel2+'SalesLevel2.size()='+SalesLevel2.size());
                
                /*Map<String,String> branchMap = new Map<String,String>();
            
                for(Branch_Master__c branch:[select id,Name from Branch_Master__c where id In:branchIdList]){
                    branchMap.put(branch.id,branch.Name);
                }*/
                
                system.debug('branchStr='+branchStr);
                
                for(Sales_Officer_Limit__c sales: [select id,Sales_Officer_Name__c, Designation__c,Branch__c,Reporting_Manager_Designation__c, Reporting_Manager_Name__c,   Active__c,Product__c,Location__c from Sales_Officer_Limit__c where Sales_Officer_Name__r.Isactive=true and Active__c = true and Product__c In:productList and Location__c includes(:branchStr)]){
                            
                                salesMap.put(sales.Sales_Officer_Name__c,sales);                    
                }
                
                system.debug('salesMap.size()='+salesMap.size()+'salesMap='+salesMap);
                
                /*for(String branchName:branchMap.values()){
                    for(String solName:salesMap.keySet()){
                        if(salesMap.get(solName).Location__c.contains(branchName)){
                            salesFinalMap.put(solName,salesMap.get(solName));           
                        }
                    }
                
                }*/
    
                //system.debug('salesFinalMap.size()='+salesFinalMap.size()+'salesFinalMap='+salesFinalMap);
                //end sales
                
                
                //start credit
                    Set<String> CreditLevel1 = new Set<String>();                   
                    Set<String> CreditLevel2 = new Set<String>();
                    Set<String> CreditLevel3 = new Set<String>();
         
                         if(LaonApplicationCreation__c.getValues('Hierarchy Stamping')!=null){
                                    //Start - Credit Level 1 
                                    String CreditHierarchyLevel1 = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Level_1__c;
                                    if(CreditHierarchyLevel1!=null){ 
                                        system.debug('***CreditHierarchyLevel1***'+CreditHierarchyLevel1); 
                                        String[] Credit1 = CreditHierarchyLevel1.split(';');
                                        for(String str:Credit1){
                                           CreditLevel1.add(str); 
                                        }   
                                    }
                                    //End - Credit Level 1 
                                 }
                            System.debug('CreditLevel1='+CreditLevel1+'CreditLevel1.size()='+CreditLevel1.size()); 
                            
                            
         
                             if(LaonApplicationCreation__c.getValues('Hierarchy Stamping')!=null){
                                        //Start - Credit Level 2
                                        String CreditHierarchyLevel2 = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Level_2__c;
                                        if(CreditHierarchyLevel2!=null){ 
                                            system.debug('***CreditHierarchyLevel2***'+CreditHierarchyLevel2); 
                                            String[] Credit2 = CreditHierarchyLevel2.split(';');
                                            for(String str:Credit2){
                                               CreditLevel2.add(str); 
                                            }   
                                        }
                                        //End - Credit Level 2 
                                     }
                                System.debug('CreditLevel2='+CreditLevel2+'CreditLevel2.size()='+CreditLevel2.size());
                                
                                
                                if(LaonApplicationCreation__c.getValues('Hierarchy Stamping')!=null){
                                        //Start - Credit Level 3
                                        String CreditHierarchyLevel3 = LaonApplicationCreation__c.getValues('Hierarchy Stamping').Credit_Level_3__c;
                                        if(CreditHierarchyLevel3!=null){ 
                                            system.debug('***CreditHierarchyLevel3***'+CreditHierarchyLevel3); 
                                            String[] Credit3 = CreditHierarchyLevel3.split(';');
                                            for(String str:Credit3){
                                               CreditLevel3.add(str); 
                                            }   
                                        }
                                        //End - Credit Level 3 
                                     }
                                System.debug('CreditLevel3='+CreditLevel3+'CreditLevel3.size()='+CreditLevel3.size());  
                                 system.debug('prodStr list here is==>'+prodStr);
                                     system.debug('branchStr list here is==>'+branchStr);
                        List <Credit_Officer_Limit__c> creditList = new List <Credit_Officer_Limit__c>();
                        creditList = [select id,Credit_Officer_Name__c,Designation__c,Active_Flag__c,Products__c,City__c from Credit_Officer_Limit__c where Credit_Officer_Name__r.Isactive=true and Active_Flag__c = true and Products__c includes(:prodStr) and City__c includes(:branchStr)];
                       
                        system.debug('credit list here is==>'+creditList);
                        /*Map<String,Credit_Officer_Limit__c> colMap = new Map<String,Credit_Officer_Limit__c>();
                        
                        for(Credit_Officer_Limit__c col:creditList){
                            for(String prod:productList ){
                                system.debug('col.Products__c='+col.Products__c+'prod='+prod);
                                if(col.Products__c!=null && col.Products__c.contains(prod)){
                                    colMap.put(col.id,col);
                                }
                            }
                            
                            System.debug('colMap='+colMap.size()+'colMap='+colMap);
                            
                            for(String branchName:branchMap.values()){
                                if(col.City__c!=null && col.City__c.contains(branchName)){
                                    colMap.put(col.id,col);
                                }
                            }
                            
                            System.debug('colMap='+colMap.size()+'colMap='+colMap);                           
                        }
                        System.debug('colMap='+colMap.size()+'colMap='+colMap);
                        System.debug('-colMap.keySet()-'+colMap.keySet());*/
                        
                       // System.debug('creditList='+creditList.size());
                //end credit
                
                //Fill Loan Appication Lookup   
                List<String> lanNoList = new List<String>();            
                    for(Weak_Account__c weakTemp: weakListHierStamp){
                        lanNoList.add(weakTemp.LAN_No__c);
                    }
                    
                    //System.debug('lanNoList.size()'+lanNoList.size());
                    
                    Map<String,String> opportunityMap = new Map<String,String>();
                    for(Opportunity opp:[Select id,Loan_Application_Number__c from Opportunity where Loan_Application_Number__c In:lanNoList]){
                        opportunityMap.put(opp.Loan_Application_Number__c,opp.id);
                    }
                    
                    System.debug('opportunityMap.size()='+opportunityMap.size());
                    
                    if(opportunityMap.size()>0)
                    {
                        for(Weak_Account__c weakTemp: weakListHierStamp)
                        {
                            if(opportunityMap.containsKey(weakTemp.LAN_No__c))
                            {
                                weakTemp.Loan_Application__c = opportunityMap.get(weakTemp.LAN_No__c);
                                System.debug('opportunityMap.get(weakTemp.LAN_No__c)='+opportunityMap.get(weakTemp.LAN_No__c)+'weakTemp.LAN_No__c='+weakTemp.LAN_No__c);
                            }
                            
                        }   
                    }                   
                
                
                //end Fill Loan Appication Lookup
                
                
                for(Weak_Account__c weakTemp: weakListHierStamp)
                {
                    system.debug('inside stamping logics');
                    //start sales
                    if(salesMap.size() > 0)
                    {
                        String reportMgrDesig,reportMgrName;
                    
                        for(Sales_Officer_Limit__c sol:salesMap.values()){
                            System.debug('SalesLevel1.contains(sol.Designation__c)='+SalesLevel1.contains(sol.Designation__c)+'-weakTemp.SFProductCode__c-'+weakTemp.SFProductCode__c+'-sol.Product__c-'+sol.Product__c+'-sol.Location__c-'+sol.Location__c+'--branchMap.get(weakTemp.Branch_Name__c)-'+weakTemp.Branch_City__c);
                            
                            if(weakTemp.ASM__c == null &&(weakTemp.SFProductCode__c!=null && weakTemp.Branch_Name__c !=null) && SalesLevel1.contains(sol.Designation__c) && weakTemp.SFProductCode__c == sol.Product__c && sol.Location__c.contains(weakTemp.Branch_City__c)){
                                weakTemp.ASM__c = sol.Sales_Officer_Name__c;
                                system.debug('sol.Sales_Officer_Name__c='+sol.Sales_Officer_Name__c);
                                reportMgrDesig = sol.Reporting_Manager_Designation__c;
                                reportMgrName = sol.Reporting_Manager_Name__c;
                            }
                        }
                        
                        System.debug('reportMgrDesig='+reportMgrDesig+'reportMgrName='+reportMgrName);
                        if(weakTemp.RSM__c == null && SalesLevel2.contains(reportMgrDesig) && salesMap.containsKey(reportMgrName)){
                            System.debug('salesMap.get(reportMgrName).Location__c='+salesMap.get(reportMgrName).Location__c+'weakTemp.Branch_Name__r.Name='+weakTemp.Branch_Name__r.Name);
                            if(salesMap.get(reportMgrName).Product__c == weakTemp.SFProductCode__c && salesMap.get(reportMgrName).Location__c.contains(weakTemp.Branch_City__c)){
                                weakTemp.RSM__c = salesMap.get(reportMgrName).Sales_Officer_Name__c;
                                reportMgrDesig = salesMap.get(reportMgrName).Reporting_Manager_Designation__c;
                                reportMgrName = salesMap.get(reportMgrName).Reporting_Manager_Name__c;
                            }
                            
                        }
                        
                        System.debug('reportMgrDesig='+reportMgrDesig+'reportMgrName='+reportMgrName);
                        if(weakTemp.ZSM__c == null && SalesLevel3.contains(reportMgrDesig) && salesMap.containsKey(reportMgrName)){
                            System.debug('salesMap.get(reportMgrName).Location__c='+salesMap.get(reportMgrName).Location__c+'weakTemp.Branch_Name__r.Name='+weakTemp.Branch_Name__r.Name);
                            if(salesMap.get(reportMgrName).Product__c == weakTemp.SFProductCode__c && salesMap.get(reportMgrName).Location__c.contains(weakTemp.Branch_City__c)){
                                weakTemp.ZSM__c = salesMap.get(reportMgrName).Sales_Officer_Name__c;
                                reportMgrDesig = salesMap.get(reportMgrName).Reporting_Manager_Designation__c;
                                reportMgrName = salesMap.get(reportMgrName).Reporting_Manager_Name__c;
                            }
                            
                        }
                        
                        System.debug('reportMgrDesig='+reportMgrDesig+'reportMgrName='+reportMgrName);
                        if(weakTemp.NSM__c == null && SalesLevel4.contains(reportMgrDesig) && salesMap.containsKey(reportMgrName)){
                            System.debug('salesMap.get(reportMgrName).Location__c='+salesMap.get(reportMgrName).Location__c+'weakTemp.Branch_Name__r.Name='+weakTemp.Branch_Name__r.Name);
                            if(salesMap.get(reportMgrName).Product__c == weakTemp.SFProductCode__c && salesMap.get(reportMgrName).Location__c.contains(weakTemp.Branch_City__c)){
                                weakTemp.NSM__c = salesMap.get(reportMgrName).Sales_Officer_Name__c;
                                reportMgrDesig = salesMap.get(reportMgrName).Reporting_Manager_Designation__c;
                                reportMgrName = salesMap.get(reportMgrName).Reporting_Manager_Name__c;
                            }
                            
                        }
                    }
                    //end sales
                    
                    //start credit hierarchy
                        for(Credit_Officer_Limit__c cred : creditList)
                        {
                             system.debug('inside stamping creditList');
                            if(weakTemp.SFProductCode__c!=null && weakTemp.Branch_Name__c !=null && branchStr!='')
                            {
                                system.debug('inside stamping creditList product and branch'); 
                                /*System.debug('colMap.get(id).Designation__c='+colMap.get(id).Designation__c+'=colMap.get(id).Products__c='+colMap.get(id).Products__c+'=colMap.get(id).City__c='+colMap.get(id).City__c+'=branchMap.get(weakTemp.Branch_Name__c)='+branchMap.get(weakTemp.Branch_Name__c));
                                
                                if(CreditLevel1.contains(colMap.get(id).Designation__c) && colMap.get(id).Products__c.contains(weakTemp.SFProductCode__c) && colMap.get(id).City__c.contains(branchMap.get(weakTemp.Branch_Name__c))){
                                    weakTemp.ACM__c = colMap.get(id).Credit_Officer_Name__c;
                                    System.debug('colMap.get(id)='+colMap.get(id));
                                }*/
                                system.debug('inside stamping creditList product and branch weakTemp record is'+weakTemp); 
                                

                                 //system.debug('inside stamping creditList product and branch cred.Designation__c'+cred.Designation__c);
                                // system.debug('inside stamping creditList product and branch cred.Designation__c'+cred.City__c);
                               //system.debug('inside stamping creditList product and branch weakTemp record is cred.Products__c'+cred.Products__c); 
                               // system.debug('inside stamping creditList product and branch weakTemp record is cred.City__c'+cred.City__c);
                               // system.debug('inside condition 1'+weakTemp.ACM__c ); 
                                 //system.debug('inside condition 2'+CreditLevel1.contains(cred.Designation__c));
                                  //system.debug('inside condition 3'+cred.Products__c.contains(weakTemp.SFProductCode__c));
                                  //system.debug('inside condition 4'+cred.City__c.contains(weakTemp.Branch_City__c));
                                  system.debug('CreditLevel1===>'+CreditLevel1);
                                   system.debug('cred record===>'+cred);
                                if(weakTemp.ACM__c == null && CreditLevel1.contains(cred.Designation__c) && cred.Products__c.contains(weakTemp.SFProductCode__c) && cred.City__c.contains(weakTemp.Branch_City__c)){
                                   system.debug('inside ACM condition');
                                    weakTemp.ACM__c = cred.Credit_Officer_Name__c;
                                    //System.debug('colMap.get(id)='+colMap.get(id));
                                }
                                
                                if(weakTemp.RCM__C == null && CreditLevel2.contains(cred.Designation__c) && cred.Products__c.contains(weakTemp.SFProductCode__c) && cred.City__c.contains(weakTemp.Branch_City__c)){
                                    weakTemp.RCM__C = cred.Credit_Officer_Name__c;
                                    //System.debug('colMap.get(id)='+colMap.get(id));
                                }
                                
                                if(weakTemp.ZCM__c == null && CreditLevel3.contains(cred.Designation__c) && cred.Products__c.contains(weakTemp.SFProductCode__c) && cred.City__c.contains(weakTemp.Branch_City__c)){
                                    weakTemp.ZCM__c = cred.Credit_Officer_Name__c;
                                    //System.debug('colMap.get(id)='+colMap.get(id));
                                }
                                                            
                                
                                /*if(CreditLevel2.contains(colMap.get(id).Designation__c) && colMap.get(id).Products__c.contains(weakTemp.SFProductCode__c) && colMap.get(id).City__c.contains(branchMap.get(weakTemp.Branch_Name__c))){
                                    weakTemp.RCM__C = colMap.get(id).Credit_Officer_Name__c;
                                    System.debug('colMap.get(id)='+colMap.get(id));
                                }
                                
                                
                                if(CreditLevel3.contains(colMap.get(id).Designation__c) && colMap.get(id).Products__c.contains(weakTemp.SFProductCode__c) && colMap.get(id).City__c.contains(branchMap.get(weakTemp.Branch_Name__c))){
                                    weakTemp.ZCM__c = colMap.get(id).Credit_Officer_Name__c;
                                    System.debug('colMap.get(id)='+colMap.get(id));
                                }*/
                                
                                
                                
                            }
                            
                        }
                    //end credit                    
                }
                
            //End Hierarchy stamp
            
            
            
  }
    
  else if(Trigger.isUpdate)
  {
    
        List<Group> qId =new List<Group>();
        qId = [select id from Group where type='Queue' AND Name='PMG Group' limit 1];
           // system.debug('qId='+qId.size());
            
            //ID Pid=Userinfo.getProfileID();
            //String Pname=[select id,name from Profile where id=:Pid].name;
            
        
            Id profileId=userinfo.getProfileId();
            String Pname=[Select Id,Name from Profile where Id=:profileId].Name;
            
            //Update sales hierarchy
                String branchStr = '';
                List<String> productList = new List <String>(); 
                String reportingName = '';
                List<Weak_Account__c> changeSalesList = new List<Weak_Account__c>();
                Map<String,Sales_Officer_Limit__c> salesMap = new Map<String,Sales_Officer_Limit__c>();
             
        
        for(Weak_Account__c weakNew: trigger.new)
        {        
             //Mortgage portfolio monitoirng-leena-start -bug id :-9200
             if(weakNew.Identified_for_Portfolio_monitoring__c==false)
             {
                      //1st assignment
                      Weak_Account__c weakOld=Trigger.oldMap.get(weakNew.id);
                    
                    // Set Last Risk classification and score
                    if(weakNew.Product__c == 'SBS CS HL' || weakNew.Product__c == 'SBS CS LAP' || weakNew.Product__c == 'SBS CS SHL'){
                        System.debug('weakOld.SBS_CS_Weak_Account_risk_classification__c='+weakOld.SBS_CS_Weak_Account_risk_classification__c+'weakNew.SBS_CS_Weak_Account_risk_classification__c='+weakNew.SBS_CS_Weak_Account_risk_classification__c);
                        if(weakOld.SBS_CS_Weak_Account_risk_classification__c != weakNew.SBS_CS_Weak_Account_risk_classification__c){
                            weakNew.Previous_Risk_classification__c = weakOld.SBS_CS_Weak_Account_risk_classification__c;
                        }
                        
                        System.debug('weakOld.SBS_CS_Weak_Account_Score__c='+weakOld.SBS_CS_Weak_Account_Score__c+'weakNew.SBS_CS_Weak_Account_Score__c='+weakNew.SBS_CS_Weak_Account_Score__c);
                        if(weakOld.SBS_CS_Weak_Account_Score__c != weakNew.SBS_CS_Weak_Account_Score__c){
                            weakNew.Previous_Weak_Account_Score__c = weakOld.SBS_CS_Weak_Account_Score__c;
                        }
        
                    }
                    else{
                    System.debug('weakOld.Risk_Classification__c='+weakOld.Risk_Classification__c+'weakNew.Risk_Classification__c='+weakNew.Risk_Classification__c);
                        if(weakOld.Risk_Classification__c != weakNew.Risk_Classification__c){
                            weakNew.Previous_Risk_classification__c = weakOld.Risk_Classification__c;
                        }
                        
                    System.debug('weakOld.SME_Score_Card_Score__c='+weakOld.SME_Score_Card_Score__c+'weakNew.SME_Score_Card_Score__c='+weakNew.SME_Score_Card_Score__c);
                        if(weakOld.SME_Score_Card_Score__c != weakNew.SME_Score_Card_Score__c){
                            weakNew.Previous_Weak_Account_Score__c = weakOld.SME_Score_Card_Score__c;
                        }
        
                    }          
                    
                    String owner = weakNew.ownerId;
                        
                    System.debug('Profile---'+Pname+'-owner-'+owner);
                      
                      system.debug('weakOld.Risk_Classification__c='+weakOld.Risk_Classification__c+'=weakNew.Risk_Classification__c='+weakNew.Risk_Classification__c);
                      
                      System.debug('PMG_Status__c='+weakNew.PMG_Status__c +'Weak_Account__c='+ weakNew.Weak_Account__c +'Pname='+Pname); 
                      
                      if((weakNew.Risk_Classification__c == 'High' || weakNew.Risk_Classification__c == 'Medium' || weakNew.SBS_CS_Weak_Account_risk_classification__c == 'High' || weakNew.SBS_CS_Weak_Account_risk_classification__c == 'Medium') && weakNew.Assign_to_FPR__c == null){
                        
                            if(weakNew.ZCM__c!=null){          
                                weakNew.OwnerId=weakNew.ZCM__c;
                                System.debug('Assign ZCM');
                            }
                            else if(weakNew.RCM__c!=null){
                                weakNew.OwnerId=weakNew.RCM__c;
                                System.debug('Assign RCM');
                            }         
                              
                      }
                      
                      if((weakNew.Risk_Classification__c == 'Low' || weakNew.SBS_CS_Weak_Account_risk_classification__c == 'Low') && qId.size()>0){
                            weakNew.ownerId = qId[0].id;
                      }      
                        
                      system.debug('weakNew.OwnerId='+weakNew.OwnerId);
                      //end 1st assignment
                      
                      //start - PD update
                      if(weakNew.Weak_Account__c == true){
                         if(weakNew.PD_Status__c == 'Initiate PD' || weakNew.PD_Status__c == 'Memo submitted to ZCM'){
                                if(weakNew.ZCM__c!=null){          
                                    weakNew.OwnerId=weakNew.ZCM__c;
                                    System.debug('Assign ZCM');
                                  }
                                  else if(weakNew.RCM__c!=null){
                                    weakNew.OwnerId=weakNew.RCM__c;
                                    System.debug('Assign RCM');
                                  } 
                            }
                            
                            if(weakNew.PD_Status__c == 'Assigned to FPR'){
                                if(weakNew.Assigned_to_FPR_for_PD__c!=null){          
                                    weakNew.OwnerId=weakNew.Assigned_to_FPR_for_PD__c;
                                    System.debug('Assign Assigned_to_FPR_for_PD__c');
                                  }
                            }
                            
                            if(weakNew.PD_Status__c == 'Memo submitted to PMG'){
                                weakNew.ownerId = qId[0].id;
                                System.debug('Assign PMG');
                            }
                      }
                    //end - PD update
        
                        //Update sales hierarchy
                        if(weakOld.ASM__c != weakNew.ASM__c || weakOld.RSM__c != weakNew.RSM__c || weakOld.ZSM__c != weakNew.ZSM__c || weakOld.NSM__c != weakNew.NSM__c){
                                changeSalesList.add(weakNew);               
                                    
                                branchStr += (branchStr==''?'':';')+weakNew.Branch_City__c;
                                    
                                productList.add(weakNew.SFProductCode__c);          
                                
                        }
                }
          }
          if(productList!=null && productList.size()>0 && branchStr!=null && branchStr!='')
          {
              for(Sales_Officer_Limit__c sales: [select id,Sales_Officer_Name__c, Designation__c,Branch__c,Reporting_Manager_Designation__c, Reporting_Manager_Name__c,   Active__c,Product__c,Location__c from Sales_Officer_Limit__c where Sales_Officer_Name__r.Isactive=true and Active__c = true and Product__c In:productList and Location__c includes(:branchStr)])
              {
                                    
                            salesMap.put(sales.Sales_Officer_Name__c+''+sales.Designation__c,sales);   
                                                                
                }
          }

            if(changeSalesList!=null && changeSalesList.size()>0)
            {
                for(Weak_Account__c weak: changeSalesList)
                {         
                   Weak_Account__c weakOld=Trigger.oldMap.get(weak.id);
                    
                    if(weak.ASM__c != weakOld.ASM__c){
                        if(salesMap.containsKey(weak.ASM__c+'Area Sales Manager') && salesMap.get(weak.ASM__c+'Area Sales Manager')!=null && salesMap.get(weak.ASM__c+'Area Sales Manager').Reporting_Manager_Designation__c!=null){
                            reportingName = salesMap.get(weak.ASM__c+'Area Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.ASM__c+'Area Sales Manager').Reporting_Manager_Designation__c;    
                        }
                        else{
                            weak.RSM__c = null;
                            weak.ZSM__c = null;
                            weak.NSM__c = null;
                        }
                        System.debug('reportingName='+reportingName);
                        
                        if(reportingName!=null && salesMap.containsKey(reportingName) && salesMap.get(reportingName).Designation__c == 'Regional Sales Manager' && salesMap.get(reportingName).Location__c.contains(weak.Branch_City__c) && salesMap.get(reportingName).Product__c.contains(weak.SFProductCode__c)){
                            weak.RSM__c = salesMap.get(reportingName).Sales_Officer_Name__c;
                            if(salesMap.get(weak.RSM__c+'Regional Sales Manager').Reporting_Manager_Designation__c != null){
                                reportingName = salesMap.get(weak.RSM__c+'Regional Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.RSM__c+'Regional Sales Manager').Reporting_Manager_Designation__c;
                            }
                            else{
                                
                                weak.ZSM__c = null;
                                weak.NSM__c = null;
                            }                            
                        }else{
                                weak.RSM__c = null;
                                weak.ZSM__c = null;
                                weak.NSM__c = null;
                            }
                        
                        if(reportingName!=null && salesMap.containsKey(reportingName) && salesMap.get(reportingName).Designation__c == 'Zonal Sales Manager' && salesMap.get(reportingName).Location__c.contains(weak.Branch_City__c) && salesMap.get(reportingName).Product__c.contains(weak.SFProductCode__c)){
                            weak.ZSM__c = salesMap.get(reportingName).Sales_Officer_Name__c;
                            if(salesMap.get(weak.ZSM__c+'Zonal Sales Manager').Reporting_Manager_Designation__c != null){
                                reportingName = salesMap.get(weak.ZSM__c+'Zonal Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.ZSM__c+'Zonal Sales Manager').Reporting_Manager_Designation__c;
                            }
                            else{                               
                                weak.NSM__c = null;
                            }                            
                        }else{                              
                                weak.ZSM__c = null;
                                weak.NSM__c = null;
                            }
                        
                        if(reportingName!=null && salesMap.containsKey(reportingName) && salesMap.get(reportingName).Designation__c == 'National Sales Manager' && salesMap.get(reportingName).Location__c.contains(weak.Branch_City__c) && salesMap.get(reportingName).Product__c.contains(weak.SFProductCode__c)){
                            weak.NSM__c = salesMap.get(reportingName).Sales_Officer_Name__c;
                            if(salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Designation__c != null){
                                reportingName = salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Designation__c;
                            }
                            
                        }else{  
                               weak.NSM__c = null;
                        }
                    }
                    
                    if(weak.RSM__c != weakOld.RSM__c){
                        if(salesMap.containsKey(weak.RSM__c+'Regional Sales Manager') && salesMap.get(weak.RSM__c+'Regional Sales Manager')!=null && salesMap.get(weak.RSM__c+'Regional Sales Manager').Reporting_Manager_Designation__c!=null){
                            reportingName = salesMap.get(weak.RSM__c+'Regional Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.RSM__c+'Regional Sales Manager').Reporting_Manager_Designation__c;    
                        }
                        else{
                            weak.ZSM__c = null;
                            weak.NSM__c = null;
                        }
                        System.debug('reportingName='+reportingName);
                        
                        if(reportingName!=null && salesMap.containsKey(reportingName) && salesMap.get(reportingName).Designation__c == 'Zonal Sales Manager' && salesMap.get(reportingName).Location__c.contains(weak.Branch_City__c) && salesMap.get(reportingName).Product__c.contains(weak.SFProductCode__c)){
                            weak.ZSM__c = salesMap.get(reportingName).Sales_Officer_Name__c;
                            if(salesMap.get(weak.ZSM__c+'Zonal Sales Manager').Reporting_Manager_Designation__c != null){
                                reportingName = salesMap.get(weak.ZSM__c+'Zonal Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.ZSM__c+'Zonal Sales Manager').Reporting_Manager_Designation__c;
                            }
                            else{                               
                                weak.NSM__c = null;
                            }
                            
                        }else{
                            weak.ZSM__c = null;
                            weak.NSM__c = null;
                        }
                        
                        if(reportingName!=null && salesMap.containsKey(reportingName) && salesMap.get(reportingName).Designation__c == 'National Sales Manager' && salesMap.get(reportingName).Location__c.contains(weak.Branch_City__c) && salesMap.get(reportingName).Product__c.contains(weak.SFProductCode__c)){
                            weak.NSM__c = salesMap.get(reportingName).Sales_Officer_Name__c;
                            if(salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Designation__c != null){
                                reportingName = salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Designation__c;
                            }
                            
                        }
                    }
                    
                    if(weak.ZSM__c != weakOld.ZSM__c){
                        if(salesMap.containsKey(weak.RSM__c+'Zonal Sales Manager') && salesMap.get(weak.RSM__c+'Zonal Sales Manager')!=null && salesMap.get(weak.RSM__c+'Zonal Sales Manager').Reporting_Manager_Designation__c!=null){
                            reportingName = salesMap.get(weak.RSM__c+'Zonal Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.RSM__c+'Zonal Sales Manager').Reporting_Manager_Designation__c;  
                        }
                        else{
                            weak.NSM__c = null; 
                        }
                        System.debug('reportingName='+reportingName);
                        
                        if(reportingName!=null && salesMap.containsKey(reportingName) && salesMap.get(reportingName).Designation__c == 'National Sales Manager' && salesMap.get(reportingName).Location__c.contains(weak.Branch_City__c) && salesMap.get(reportingName).Product__c.contains(weak.SFProductCode__c)){
                            weak.NSM__c = salesMap.get(reportingName).Sales_Officer_Name__c;
                            if(salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Designation__c != null){
                                reportingName = salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Name__c+''+salesMap.get(weak.NSM__c+'National Sales Manager').Reporting_Manager_Designation__c;
                            }
                            
                        }
                    }
                    
                 }
                }
      }      
      
    }
    
    if(Trigger.isAfter)
    {
        
        if(Trigger.isInsert) 
        {
            List<Weak_Account__c> weList=[Select DuplicateAccount__c,Account_Status__c,CreatedDate,Identified_for_Portfolio_monitoring__c,Last_decision_date__c from Weak_Account__c where DuplicateAccount__c=true];
            
            if(weList.size()>0)
            {
                //System.debug('weList='+weList[0].Account_Status__c);
                delete weList;
            }
            
            //Clone Property details
                Map<String,Weak_Account__c> weakList = new Map<String,Weak_Account__c>();
                
                
                for(Weak_Account__c weakNew: trigger.New)
                {
                     //Mortgage portfolio monitoirng-leena-start -bug id :-9200
                    if(weakNew.DuplicateAccount__c == false && weakNew.Identified_for_Portfolio_monitoring__c==false)
                    {
                        weakList.put(weakNew.LAN_No__c,weakNew);
                    }
                }
              //  System.debug('weakList.size()='+weakList.size()+'weakList='+weakList);
                
                Map<String,String> oppIdMap = new Map<String,String>();
                if(weakList!=null && weakList.size()>0)
                {
                    for(Opportunity opp:[Select id,Loan_Application_Number__c from Opportunity where Loan_Application_Number__c In:weakList.keySet()])
                    {
                        oppIdMap.put(opp.id,opp.Loan_Application_Number__c);
                    } 
                } 
               // System.debug('oppIdMap.size()='+oppIdMap.size());
                if(oppIdMap!=null && oppIdMap.size()>0)
                {
                    Set<String> oppIdList = oppIdMap.keySet();
                    
                    String soql = WeakAccountScoreCard.getCreatableFieldsSOQL('Property_Details__c','Loan_Application__c In:oppIdList');            
                    System.debug('soql='+soql);
                    
                    List<Property_Details__c> propList = new List<Property_Details__c>();
                    propList = Database.query(soql);
                        
                    //System.debug('propList.size()='+propList.size());
                    
                    List<Property_Details__c> cloneProperty = new List<Property_Details__c>();
                                    
                    for(Property_Details__c property:propList){
                        if(oppIdMap.get(property.Loan_Application__c)!=null){
                            Property_Details__c newProp = property.clone(false, true);
                            newProp.Loan_Application__c = null; 
                            newProp.Weak_Account__c = weakList.get(oppIdMap.get(property.Loan_Application__c)).id;
                            
                            newProp.OwnerId = weakList.get(oppIdMap.get(property.Loan_Application__c)).OwnerId;
                            //System.debug('OwnerId='+weakList.get(oppIdMap.get(property.Loan_Application__c)).OwnerId);
                            
                            cloneProperty.add(newProp);
                        }
                        
                    }
                    
                    //system.debug('cloneProperty.size()='+cloneProperty.size());
                    if(cloneProperty.size()>0){
                        insert cloneProperty;
                    }   
                }
                
            //end Property
            
           
            
        }  
       
        if(Trigger.isUpdate)
        {
          
          //OwnerSharing
                List<Group> qId =new List<Group>();
                List<Weak_Account__Share> jobShrs  = new List<Weak_Account__Share>();
                Weak_Account__Share weakAcctShareObj;   
                List<Id> ownerList = new List<Id>();
        
                qId = [select id from Group where type='Queue' AND Name='PMG Group' limit 1];
                //system.debug('qId='+qId.size());
            //end OwnerSharing
            
            //if WA status is regularised update same in Loan Info
                Map<Id,String> loanInfoIdMap = new Map<Id,String>();
                    
                    for(Weak_Account__c weakNew: trigger.new)
                    {
                              Weak_Account__c weakOld=Trigger.oldMap.get(weakNew.id);
                                
                                //Property owner change
                                System.debug('weakNew.ownerId='+weakNew.ownerId+'=weakOld.ownerId='+weakOld.ownerId);
                            if(weakNew.ownerId != weakOld.ownerId){
                              weakIdOwnerChange.put(weakNew.id,weakNew.ownerId);
                            }
                                
                                //end Property
                                
                                if(weakNew.Account_Status__c != weakOld.Account_Status__c){             
                                    System.debug('weakNew.Loan_Info__c='+weakNew.Loan_Info__c+'weakNew.Account_Status__c='+weakNew.Account_Status__c);
                                    loanInfoIdMap.put(weakNew.Loan_Info__c,weakNew.Account_Status__c);
                                }
                                
                                 //OwnerSharing
                                  ownerList.clear();
                                  //System.debug('ownerList='+ownerList.size()+'weakNew.DuplicateAccount__c='+weakNew.DuplicateAccount__c);
                                  
                                  if(weakNew.ACM__c!=null && weakNew.OwnerId != weakNew.ACM__c)
                                      ownerList.add(weakNew.ACM__c);
                                    if(weakNew.RCM__c!=null && weakNew.OwnerId != weakNew.RCM__c)   
                                      ownerList.add(weakNew.RCM__c);
                                    if(weakNew.ZCM__c!=null && weakNew.OwnerId != weakNew.ZCM__c)   
                                      ownerList.add(weakNew.ZCM__c);
                                    /*if(weakNew.NCM__c!=null && weakNew.OwnerId != weakNew.NCM__c)   
                                         ownerList.add(weakNew.NCM__c);*/
                                      
                                    if(weakNew.ASM__c!=null && weakNew.OwnerId != weakNew.ASM__c)
                                       ownerList.add(weakNew.ASM__c);
                                    if(weakNew.RSM__c!=null && weakNew.OwnerId != weakNew.RSM__c)   
                                          ownerList.add(weakNew.RSM__c);
                                    if(weakNew.ZSM__c!=null && weakNew.OwnerId != weakNew.ZSM__c)   
                                          ownerList.add(weakNew.ZSM__c);
                                    if(weakNew.NSM__c!=null && weakNew.OwnerId != weakNew.NSM__c)   
                                      ownerList.add(weakNew.NSM__c); 
                                    if(weakNew.Assign_to_FPR__c!=null && weakNew.OwnerId != weakNew.Assign_to_FPR__c)   
                                      ownerList.add(weakNew.Assign_to_FPR__c);                          
                                    if(weakNew.Assigned_to_FPR_for_PD__c!=null && weakNew.OwnerId != weakNew.Assigned_to_FPR_for_PD__c)   
                                      ownerList.add(weakNew.Assigned_to_FPR_for_PD__c);
                                      
                      
                                       // System.debug('weakNew.OwnerId='+weakNew.OwnerId+'-qId[0].id-'+qId[0].id);
                                        // List<GroupMember> userList = new List<GroupMember>();
                                  
                                  
                                  if(qId.size()>0){
                                    Id idQ = qId[0].id;
                                  
                                    System.debug('idQ='+idQ+'=weakNew.OwnerId='+weakNew.OwnerId);
                                    if(idQ != weakNew.OwnerId){
                                      ownerList.add(idQ);
                                    }                            
                                     
                                  }
          
                                 // System.debug('ownerList='+ownerList.size()+'ownerList='+ownerList);    
                                  
                                  for(Id owner: ownerList){
                                      weakAcctShareObj = new Weak_Account__Share();
                                          weakAcctShareObj.ParentID = weakNew.Id;
                                          
                                          system.debug('owner --> ' + owner);
                                          weakAcctShareObj.UserOrGroupId = owner;
                                          weakAcctShareObj.AccessLevel= 'Edit';
                                          weakAcctShareObj.RowCause = 'Manual';
                                          jobShrs.add(weakAcctShareObj);
                                  }
                              
                              //end OwnerSharing
                    
                }
                    
                   // System.debug('jobShrs.size()='+jobShrs.size()+'=jobShrs='+jobShrs);
                if(jobShrs!=null && jobShrs.size()>0)
                {
                    //insert jobShrs;
                    Database.SaveResult[] lsr = Database.insert(jobShrs,false);
                    System.debug('lsr='+lsr);
                    Integer i=0;
                  for(Database.SaveResult sr : lsr){
                      if(!sr.isSuccess()){
                          Database.Error err = sr.getErrors()[0];
                          if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                                         &&  err.getMessage().contains('AccessLevel'))){
                              trigger.newMap.get(jobShrs[i].ParentID).
                                addError(
                                 'Unable to grant sharing access due to following exception: '
                                 + jobShrs[i]+'...'+err.getMessage());
                          }
                      }
                      i++;
                  }
              
                }
                
                //Property owner change
                    //System.debug('weakIdOwnerChange.size()='+weakIdOwnerChange.size());
                  if(weakIdOwnerChange!=null && weakIdOwnerChange.size() > 0)
                  {
                      Set<Id> ownerListProp = new Set<Id>();
                      ownerListProp = weakIdOwnerChange.keySet();
                      
                    String soql = WeakAccountScoreCard.getCreatableFieldsSOQL('Property_Details__c','Weak_Account__c In:ownerListProp');            
                    System.debug('soql='+soql);
                    
                    List<Property_Details__c> propList = new List<Property_Details__c>();
                    propList = Database.query(soql);
                      
                    //System.debug('propList.size()='+propList.size());
                    
                    for(Property_Details__c p : propList){
                      propMap.put(p,p.Weak_Account__c);
                    }
                  }
                  
                 // System.debug('propMap.size()='+propMap.size());
                 if(propMap!=null && propMap.size()>0)
                 {
                  for(Property_Details__c p: propMap.keySet())
                  {
                    if(weakIdOwnerChange.containsKey(p.Weak_Account__c)){
                      p.ownerId = weakIdOwnerChange.get(p.Weak_Account__c);
                      propListUpdate.add(p);
                    }
                  }
                 }
                  
                  
                                      
                  //  System.debug('propListUpdate.size()='+propListUpdate.size());  
                  if(propListUpdate!=null && propListUpdate.size()>0)
                  {
                     /* QueueSobject mappingObject = new QueueSobject(QueueId = qId[0].id, SobjectType = 'Property_Details__c');
                                //System.runAs(new User(Id = UserInfo.getUserId())){
                                    insert mappingObject;*/
                                //}
                    
                    update propListUpdate;
                  }
                  
                  //Property end
                  
                
                 //   System.debug('loanInfoIdMap.size()='+loanInfoIdMap.size()+'loanInfoIdMap='+loanInfoIdMap);
                    
                    if(loanInfoIdMap!=null && loanInfoIdMap.size()>0)
                    {
                        List<Loan_INFO__c> loanInfoList1 = new List<Loan_INFO__c>();
                        loanInfoList1=[select id,Loan_Number__c,Weak_Account_Status__c from Loan_INFO__c where id IN :loanInfoIdMap.keySet()];
                        
                       // system.debug('loanInfoList1.size()='+loanInfoList1.size());                     
                        
                            for(Loan_INFO__c info:loanInfoList1){
                                if(loanInfoIdMap.get(info.id) != 'Regularised'){
                                    info.Weak_Account_Status__c = 'Live';
                                }                                   
                                else{
                                    info.Weak_Account_Status__c = loanInfoIdMap.get(info.id);
                                }   
                                    
                            }
                        
                        
                        //System.debug('loanInfoList1.size()='+loanInfoList1.size());
                        if(loanInfoList1.size()>0)
                         update loanInfoList1;
                    }
                            
                //end  -- if WA status is regularised update same in Loan Info
        }     
        
        
    }
   
 }