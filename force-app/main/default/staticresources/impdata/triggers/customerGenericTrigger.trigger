trigger customerGenericTrigger on CUSTOMER_INFO__c(before update, before insert, after update, after insert) 
{
    //added code to restrict trigger execution for user having profile id maintained in Label.PO_Trigger_restrictedUserId
    string Pid = Userinfo.getProfileID();
    string Ids = Label.PO_Trigger_restrictedUserId;
    set < string > restrictedIdsSet = new set < string > ();
    if (ids != null) 
        restrictedIdsSet.addAll(Ids.split(';'));
        
    if(restrictedIdsSet.contains(Pid))
    return;

    // @info -- Flag Check to Execute Trigger Functionality
    // @Use   -- Form After trigger insertion, of Insurance Failed Sharing Handling, this flag is made false to avoid recursion
    System.debug('doRunMe:::' + GeneralUtilities.getDoRunMe());
    if (GeneralUtilities.getDoRunMe()) 
    {
        
        // *** Cities Stamping -- S
        CustInfoCitiesHandler CustInfoCitiesHandlerObj = new CustInfoCitiesHandler(Trigger.new, Trigger.oldMap, Trigger.newMap);
        if ((trigger.isinsert || trigger.isupdate) && trigger.isBefore) 
        {
            system.debug('is Before and is Insert  and update INNNNNsert');
            CustInfoCitiesHandlerObj.appendRuralCities();
        }
        // *** Cities Stamping -- E


        /*** @info - Insurance RR Logic BEFORE UPDATE or INSERT */
        if ((Trigger.isBefore && Trigger.isUpdate) || (Trigger.isBefore && Trigger.isInsert)) {
            //Round Robin Lobic
            // Filter, Criteteria, RR logic, Mapping Done in Handler        
            System.debug('Before>>' + Trigger.new);
            // BUG #12326 
            // syntax change for RR method
            InsuranceAgentRRHandler.customerInsuranceAgentAssignRR(Trigger.new,Trigger.oldMap);
            System.debug('After>>' + Trigger.new);
            
            // Start of Elite card changes bug - 13309
            if ((Trigger.isbefore && Trigger.isUpdate)) {
            //19500 S 
             
               //22066 for 19500 S
            Map<Id,Integer> custAndVouchersMap = new Map<Id,Integer>();
             List<Customer_Info__c> custAndVouchers =  [select id,(select id from Promo_Master_Pixel_Master__r) from Customer_Info__c where Id IN:Trigger.New];
                for(Customer_Info__c cust: custAndVouchers){
                    custAndVouchersMap.put(cust.id,cust.Promo_Master_Pixel_Master__r.size());
                }
                system.debug('19500 custAndVouchersMap'+custAndVouchersMap);
                //22066 for 19500 E
                for(Customer_Info__c custObj : Trigger.New) {
                    Customer_Info__c objCustOld = Trigger.oldMap.get(custObj.Id);
                    system.debug('custAndVouchersMap.get(custObj.id)'+custAndVouchersMap.get(custObj.id));
                    system.debug('custObj.Promo_Master_Pixel_Master__r'+custObj.Promo_Master_Pixel_Master__r);
                    system.debug('custObj.Promo_Master_Pixel_Master__r.size()'+custObj.Promo_Master_Pixel_Master__r.size());
                    if(objCustOld.Elite_Card_Number__c == null && custObj.Elite_Card_Number__c != null &&  objCustOld.Elite_Card_Embossing_Date__c == null && custObj.Elite_Card_Embossing_Date__c != null && !custObj.Vouchers_email_sent__c && custObj.Promo_Master_Pixel_Master__r != null && custAndVouchersMap.containsKey(custObj.id) && custAndVouchersMap.get(custObj.id)>0){//22066 for 19500
                       
                    //if(objCustOld.Elite_Card_Number__c == null && custObj.Elite_Card_Number__c != null &&  objCustOld.Elite_Card_Embossing_Date__c == null && custObj.Elite_Card_Embossing_Date__c != null && !custObj.Vouchers_email_sent__c && custObj.Promo_Master_Pixel_Master__r != null) {
                       if(Label.Elite_Card_Profiler_Needed.equalsIgnoreCase ('Y') ){ 
                        CP_EliteCard.SendVoucherEmail(custObj); 
                       }
                        else{
                            System.debug('19500');
                            String[] emailId= new String[]{};
                            //emailId.add(custObj.Email_New__c);
                            if (custObj.Email_New__c != '' && custObj.Email_New__c != null){
                                     emailId.add(custObj.Email_New__c);
                                system.debug('Email new id used');
                            }
                            else {
                                if (custObj.Customer_Email__c != '' && custObj.Customer_Email__c != null){    
                                    emailId.add(custObj.Customer_Email__c);
                                    system.debug('Customer Email id used');
                                }                      
                             }     
                            ProfilerEmailLinkHandler.sendEmailMethod('Voucher Email Revamp',custObj.id, emailId,'Elite Card Gift Vouchers');
                        }
                        System.debug('Mail sent in trigger');
                        custObj.Vouchers_email_sent__c = true;
                        custObj.Vouchers_Sent_On__c= System.now();
                    }
                }
                
            }//19500 E
            // End of Elite card changes bug - 13309
        }

        /*** @info - Insurance Sharing Logic AFTER UPDATE or INSERT */
        if ((Trigger.isAfter && Trigger.isUpdate) || (Trigger.isAfter && Trigger.isInsert)){
            Set<String> setFDCustIds = new Set<String>();
            List<String> lstOwnerId = new List<String>(); 
            List<String> lstCustId = new List<String>(); 
            List<CUSTOMER_INFO__c> lstCustInfo = new List<CUSTOMER_INFO__c>();
            
            /*asmrr__c insuraceCustomSettingRec = asmrr__c.getValues('Insurance Agent');
            // HNI Enhancement (line here moved inside below block)
            asmrr__c insuraceHNICustomSettingRec = asmrr__c.getValues('Insurance HNI Agent');
            List<Sales_Officer_Limit__c> lstInsSOLimitList = new List <Sales_Officer_Limit__c>();
            if (insuraceCustomSettingRec != null && insuraceHNICustomSettingRec!= null) {
                List<String> insuranceDesignationList = insuraceCustomSettingRec.Insurance_Agen_Hierarchy_Designations__c.split(';');
                // HNI Enhancement
                List<String> insHNIDesignationList = insuraceHNICustomSettingRec.Insurance_Agen_Hierarchy_Designations__c.split(';');
                lstInsSOLimitList = [select id, Sales_Officer_Name__c, Reporting_Manager_Name__c, Designation__c ,Sales_Officer_Name__r.Profile.UserLicense.Name ,Reporting_Manager_Name__r.Profile.UserLicense.Name from Sales_Officer_Limit__c where Active__c = True AND (Designation__c IN: insuranceDesignationList OR Designation__c IN: insHNIDesignationList)];
            } */
            
            /*fetch hierarchy of SOL*/
            List<Sales_Officer_Limit__c> lstInsSOLimitList = new List <Sales_Officer_Limit__c>();
            lstInsSOLimitList = InsuranceAgentRRHandler.fetchSOLData();
            System.debug('Insurance && HNI hierarchy Common SOL > '+lstInsSOLimitList);

            map <Id, List <Id>> removePermissionsMap = new map <Id,List<Id>>();
            List<Customer_info__share> addPermissionsList = new List < Customer_info__share>();
            List<String> lstChannel = new List<String>();
            lstChannel =System.Label.Channel_Type.split(';');
            Set<String> setChnl = new Set<String>();
            Set<String> setCustFrInteraction = new Set<String>();
            for(String strChnl:lstChannel){
                setChnl.add(strChnl);
            }
            
            for (Customer_Info__c cust: Trigger.new){               
                // BUG #12326 
                // get old customer
                Customer_Info__c oldCust;
                if(Trigger.isAfter && Trigger.isUpdate){
                    oldCust = Trigger.oldMap.get(cust.id);
                    lstCustId.add(cust.Id);
                    lstOwnerId.add(cust.OwnerId);
                }
                // BUG #12326 
                // Enhance condition to accomodate lead viewable yes-> no customers
                //system.debug(' *** OLD Condition > '+(cust.Lead_Viewable__c == 'Yes' && setChnl.contains(cust.Channel__c)));
                //system.debug(' *** NEW Condition > '+(Trigger.isAfter && Trigger.isUpdate && cust.Lead_Viewable__c == 'No' && oldCust.Lead_Viewable__c == 'Yes' && oldCust.Insurance_Agent__c != null));
                if ((cust.Lead_Viewable__c == 'Yes' && setChnl.contains(cust.Channel__c)) || (Trigger.isAfter && Trigger.isUpdate && cust.Lead_Viewable__c == 'No' && oldCust.Lead_Viewable__c == 'Yes' && oldCust.Insurance_Agent__c != null))
                {
                    //System.debug('Lead>>' + cust);                    
                    /*Added condition in below IF loop to check - When Owner Id is chnaged on after update event then sharing will execute again*/
                    /*Added condition in below IF Loop to check - 
                        -   Lead Viewable NO to YES
                        -   Previously when lead viewable was 'NO' agent was assigned
                        -   Agent is unchanged now when lead  viewable is changed from 'NO' to 'YES'
                        BUG - #13653
                    */
                    if ( (Trigger.isAfter && Trigger.isInsert ) || (Trigger.isAfter && Trigger.isUpdate && cust.Insurance_Agent__c == oldCust.Insurance_Agent__c && cust.OwnerId != oldCust.OwnerId) || (Trigger.isAfter && Trigger.isUpdate && cust.Insurance_Agent__c == oldCust.Insurance_Agent__c && oldCust.Lead_Viewable__c == 'No' && cust.Lead_Viewable__c == 'Yes')){
                        
                        System.debug('AFTERInsert::');
                        if (cust != null && cust.Insurance_Agent__c != null){
                            List<Id> hierarchyListId = new List<Id>();
                            
                            /*Fetch hierarchy of SOL record*/
                            hierarchyListId = InsuranceAgentRRHandler.fetchHierarchy(lstInsSOLimitList,cust);
                                                        
                            /*Boolean isMoreHierarchy = false;
                            Id currentUser;
                            List<Id> hierarchyListId = new List<Id>();
                            //get user id from sales office limit of agent
                            for (Sales_Officer_Limit__c officer: lstInsSOLimitList) {
                                if (officer.id == cust.Insurance_Agent__c) {
                                    currentUser = officer.Sales_Officer_Name__c;
                                    isMoreHierarchy = true;
                                    break;
                                }
                            }


                            Id currentLevelId = currentUser;
                            while (isMoreHierarchy) 
                            {
                                //System.debug('** (NEW) Current Level Id -- ' + currentLevelId);
                                hierarchyListId.add(currentLevelId);
                                //System.debug('>>>> (NEW) ** Current Level Id -- ' + currentLevelId);
                                isMoreHierarchy = false;
                                for (Sales_Officer_Limit__c officer: lstInsSOLimitList) {
                                    if (officer.Sales_Officer_Name__c == currentLevelId) {

                                        if (officer.Reporting_Manager_Name__c != null) {
                                            isMoreHierarchy = true;
                                            currentLevelId = officer.Reporting_Manager_Name__c;
                                            break;
                                        } else {
                                            isMoreHierarchy = false;
                                            break;
                                        }
                                    }
                                }
                            }*/
                            
                            /////*
                            
                            //add sharing
                            List <Customer_info__share> lstCustShareList = new List <Customer_info__share> ();
                            for (Id tmpUser: hierarchyListId) {
                                customer_info__share shareObj = new customer_info__share();
                                shareObj.ParentId = cust.id;
                                shareObj.UserOrGroupId = tmpUser;
                                //Available permissions - edit/read
                                shareObj.AccessLevel = 'edit';
                                if(cust.OwnerId != tmpUser)
                                    lstCustShareList.add(shareObj);
                                //Create list of Customer ids to insert product - Bajaj Finserv- FD
                                setFDCustIds.add(cust.id);
                            }
                            System.debug('**(NEW) add list of permissions >>>> ' + lstCustShareList);
                            addPermissionsList.addAll(lstCustShareList);
                        }
                    }

                    if (Trigger.isAfter && Trigger.isUpdate){
                        System.debug('AFTERUpdate:::');
                        //Customer_Info__c oldCust = Trigger.oldMap.get(cust.id);
                        oldCust = Trigger.oldMap.get(cust.id);
                        if (oldCust != null && cust != null && cust.Insurance_Agent__c != oldCust.Insurance_Agent__c){
                            System.debug('oldCust::' + oldCust);
                            
                            //Code added for :  SEP17 - Customer Interaction record sharing with Community users - 14461
                            setCustFrInteraction.add(cust.Id);                     
                            
                            //remove old permissions
                            if (oldCust.Insurance_Agent__c != null) {
                                List<Id> hierarchyListId = new List<Id>();  
                                /*Fetch hierarchy of SOL record*/
                                hierarchyListId = InsuranceAgentRRHandler.fetchHierarchy(lstInsSOLimitList,oldCust);
                                System.debug('** (NEW) Hierarchy Is Add New Permissions > ' + hierarchyListId);
                                /*
                                Boolean isMoreHierarchy = false;
                                Id currentUser;
                                List<Id> hierarchyListId = new List<Id> ();

                                //get user id from sales office limit of agent
                                for (Sales_Officer_Limit__c officer: lstInsSOLimitList) {
                                    if (officer.id == oldCust.Insurance_Agent__c) {
                                        currentUser = officer.Sales_Officer_Name__c;
                                        isMoreHierarchy = true;
                                        break;
                                    }
                                }


                                Id currentLevelId = currentUser;
                                while (isMoreHierarchy) {    
                                    hierarchyListId.add(currentLevelId);
                                    isMoreHierarchy = false;
                                    for (Sales_Officer_Limit__c officer: lstInsSOLimitList) {
                                        if (officer.Sales_Officer_Name__c == currentLevelId) {

                                            if (officer.Reporting_Manager_Name__c != null) {
                                                isMoreHierarchy = true;
                                                currentLevelId = officer.Reporting_Manager_Name__c;
                                                break;
                                            } else {
                                                isMoreHierarchy = false;
                                                break;
                                            }
                                        }
                                    }
                                }*/                               
                                removePermissionsMap.put(oldCust.Id, hierarchyListId);
                            }

                            //add new permissions 
                            if (cust.Insurance_Agent__c != null){
                                List<Id> hierarchyListId = new List<Id>();
                                /*Fetch hierarchy of SOL record*/
                                hierarchyListId = InsuranceAgentRRHandler.fetchHierarchy(lstInsSOLimitList,cust);
                                System.debug('** (NEW) Hierarchy Is Add New Permissions > ' + hierarchyListId);
                                /*
                                //get hierarchy
                                Boolean isMoreHierarchy = false;
                                Id currentUser;

                                //get user id from sales office limit of agent
                                for (Sales_Officer_Limit__c officer: lstInsSOLimitList) {
                                    if (officer.id == cust.Insurance_Agent__c) {
                                        currentUser = officer.Sales_Officer_Name__c;
                                        isMoreHierarchy = true;
                                        break;
                                    }
                                }


                                Id currentLevelId = currentUser;
                                while (isMoreHierarchy) {

                                    //System.debug('** (NEW) Current Level Id -- ' + currentLevelId);
                                    hierarchyListId.add(currentLevelId);
                                    //System.debug('>>>> (NEW) ** Current Level Id -- ' + currentLevelId);
                                    isMoreHierarchy = false;
                                    for (Sales_Officer_Limit__c officer: lstInsSOLimitList) {
                                        if (officer.Sales_Officer_Name__c == currentLevelId) {

                                            if (officer.Reporting_Manager_Name__c != null) {
                                                isMoreHierarchy = true;
                                                currentLevelId = officer.Reporting_Manager_Name__c;
                                                break;
                                            } else {
                                                isMoreHierarchy = false;
                                                break;
                                            }
                                        }
                                    }
                                }
                                System.debug('** (NEW) Hierarchy Is Add New Permissions > ' + hierarchyListId);
                                */

                                //add sharing

                                List <Customer_info__share> lstCustShareList = new List < Customer_info__share>();
                                for (Id tmpUser: hierarchyListId) 
                                {
                                    customer_info__share shareObj = new customer_info__share();
                                    shareObj.ParentId = cust.id;
                                    shareObj.UserOrGroupId = tmpUser;
                                    //Available permissions - edit/read
                                    shareObj.AccessLevel = 'edit';
                                    if(cust.OwnerId != tmpUser)
                                        lstCustShareList.add(shareObj);
                                    //Create list of Customer ids to insert product - Bajaj Finserv- FD
                                    setFDCustIds.add(cust.id);
                                }
                                System.debug('**(NEW) add list of permissions >>>> ' + lstCustShareList);
                                addPermissionsList.addAll(lstCustShareList);
                            }
                        }          
                        
                    }
                }
            }
            
            if(Trigger.isAfter && Trigger.isUpdate && lstCustId.size()>0){
                // Added OwnerId by Anurag for VSO Channel addition 18584 to Pipeline_Trackers__r because it was causing error
                lstCustInfo = [SELECT Id, Customer_Name__c ,Name,Owner.ProfileId, Insurance_Agent__c, Owner.Name,Email__c,Email_Id_2__c, Email_New__c,Owner.Email, Flow__c ,(Select id , OwnerId, CUSTOMER__c from Pipeline_Trackers__r) FROM CUSTOMER_INFO__c where Id In :lstCustId ];
                
                /*Code added for :  SEP17 - Customer Interaction record sharing with Community users - 14461*/ 
                List<Customer_Info__c> lstCustFrInteraction = new List<Customer_Info__c>(); 
                for(CUSTOMER_INFO__c objCustLcl : lstCustInfo){
                    if(setCustFrInteraction.contains(objCustLcl.id))
                        lstCustFrInteraction.add(objCustLcl);
                }
                InsuranceAgentRRHandler.shareInteraction(lstInsSOLimitList,lstCustFrInteraction);
            }           
                        
            // MAP LOGIC TO BULKIFY REMOVE SHARED RECORDS   
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>> REmoev Permissiosn map >> ' + removePermissionsMap);
            Set <Id> parentCustIdSet = removePermissionsMap.keySet();
            if (parentCustIdSet != null && parentCustIdSet.size() > 0) 
            {
                List <List<Id>> tmpOwnerCustIdList = removePermissionsMap.values();
                List <Id> ownerCustIdList = new List <Id> ();
                for (List<Id> tmp: tmpOwnerCustIdList)
                ownerCustIdList.addAll(tmp);
                List <Id> parentCustIdList = new List <Id> (parentCustIdSet);

                List <Customer_info__share> listShareCustRemove = [SELECT Id, ParentId, UserOrGroupId FROM Customer_Info__Share WHERE ParentId IN: parentCustIdList AND UserOrGroupId IN: ownerCustIdList];

                //System.debug('------------ Parent Id List >>> ' + parentCustIdList);
                //System.debug('------------ Owner Id List >>> ' + ownerCustIdList);
                //System.debug('-- Rought -- Tobe removed customer list > ' + listShareCustRemove);

                for (Integer i = 0; i < listShareCustRemove.size(); i++) 
                {
                    list <id> tmpOwnerList = removePermissionsMap.get(listShareCustRemove[i].ParentId);
                    Boolean validCase = false;
                    for (Id tmpId: tmpOwnerList)
                    if (listShareCustRemove[i].UserOrGroupId == tmpId) {
                        validCase = true;
                        break;
                    }
                    if (!validCase) {
                        listShareCustRemove.remove(i);
                        i--;
                    }
                }

                System.debug('Remove Permissinons LIST' + listShareCustRemove);
                if (listShareCustRemove != null) 
                {
                    try {
                        Database.delete(listShareCustRemove, false);
                    } catch (Exception e) {
                        System.debug('EXCEPTION (REMOVING PERMISSIONS)-- ' + e);
                    }
                }
            }

            //BULKIFY LOGIC TO BULKIFY INSERT TO SHARE RECORDS
            System.debug('Add Permissions LIST>' + addPermissionsList);
            Database.SaveResult[] srList;
            if (addPermissionsList != null && addPermissionsList.size() > 0) 
            {
                try {
                    srList = Database.insert(addPermissionsList, false);
                    System.debug('**(NEW) add list of permissions RESULT>>>> ' + srList);
                } catch (Exception e) {
                    System.debug('** Exception (ADDING PERMISSIONS) -- ' + e);
                }
            }

            //***Handle Sharing Failed  

            if (srList != null && srList.size() > 0) {
                Set < Id > setOfFailedSharingCustomerId = new Set < Id > ();
                for (Integer i = 0; i < srList.size(); i++) {
                    if (!srList.get(i).isSuccess()) {
                        if(addPermissionsList != null  && addPermissionsList.size() > 0)
                            setOfFailedSharingCustomerId.add((addPermissionsList.get(i)).ParentId);
                    }
                }

                System.debug('Insurance - ID List of Customers Failed Sharing > ' + setOfFailedSharingCustomerId);
                if (setOfFailedSharingCustomerId != null && setOfFailedSharingCustomerId.size() > 0) 
                {
                    List <Id> listOfFailedSharingCustomerId = new List <ID> (setOfFailedSharingCustomerId);
                    List <Customer_Info__c> listOfCustReformedToBeUpdate = [select id, Sharing_Failure__c, Channel__c, Lead_Viewable__c, Insurance_Agent__c from Customer_Info__c where Id IN: listOfFailedSharingCustomerId];
                    if (listOfCustReformedToBeUpdate != null && listOfCustReformedToBeUpdate.size() > 0) 
                    {
                        for (Customer_Info__c curCust: listOfCustReformedToBeUpdate) {
                            curCust.Sharing_Failure__c = true;
                            curCust.Channel__c = null;
                            curCust.Lead_Viewable__c = 'No';
                            curCust.Insurance_Agent__c = null;
                        }
                        try 
                        {
                            // Handle Recursion of Trigger, Disable Executing of Trigger using : General Utilits - doRunMe variable
                            GeneralUtilities.disableDoRumMe();
                            Database.SaveResult[] srListCustUpdateShrFaildHandle = Database.update(listOfCustReformedToBeUpdate, false);
                            System.debug('** Insurance Sharing Failed Customer Handle Update Result >>>> ' + srListCustUpdateShrFaildHandle);
                        } catch (Exception e) {
                            System.debug('** Exception (ADDING PERMISSIONS) -- ' + e);
                        }
                    }
                }

            }

            /* Author: Rohit Mourya
            * Enhancement: Engagement Automation
            * Modified Date: 20-3-2017
            */ 
            if(Trigger.isAfter && Trigger.isUpdate) {
                //List<String> lstCustId = new List<String>(); 
                //List<String> lstOwnerId = new List<String>();  
                List<CUSTOMER_INFO__c> lstCustFlowChange = new List<CUSTOMER_INFO__c>();
                List<CUSTOMER_INFO__c> lstCustOwnerChange = new List<CUSTOMER_INFO__c>();
                Map<String,String> mapCustIDProfId = new Map<String,String>();  
                Map<String,Boolean> mapValidProf = new Map<String,Boolean>();                   
                List<String> profiles = label.Send_Email_Profiles.split(';');
                System.debug(profiles);
                Set<String> profileSet = new Set<String>();
                for(String s:profiles){
                    profileSet.add(s);                      
                }
                
                //for(Customer_Info__c customer : Trigger.new) {
                    //lstCustId.add(customer.Id);
                    //lstOwnerId.add(customer.OwnerId);
                //}
                
                //List<CUSTOMER_INFO__c> lstCustInfo = [SELECT Id, Customer_Name__c ,Name,Owner.ProfileId, Owner.Name,Email__c,Email_Id_2__c, Email_New__c,Owner.Email, Flow__c FROM CUSTOMER_INFO__c where Id In :lstCustId ];
                
                for(Customer_Info__c objCust :lstCustInfo){
                    mapCustIDProfId.put(objCust.Id,objCust.Owner.ProfileId);
                }
                
                system.debug('mapCustIDProfId::'+mapCustIDProfId);
                if(mapCustIDProfId != null && mapCustIDProfId.size()>0 ){
                    List <Profile> profileList = [SELECT Id ,Name FROM Profile WHERE Id IN : mapCustIDProfId.values()];
                    for(Profile objProf :profileList){
                        if (profileSet.contains(objProf.Name))               
                        mapValidProf.put(objProf.Id,true);
                        else
                        mapValidProf.put(objProf.Id,false);
                    }
                    
                    system.debug('mapValidProf::'+mapValidProf);    
                    for(Customer_Info__c customer : lstCustInfo) {
                        Customer_Info__c oldCustomer = Trigger.oldMap.get(customer.Id); 
                        
                        system.debug('ProfID::'+customer.Owner.ProfileId);  
                        if(mapValidProf != null && mapValidProf.containskey(customer.Owner.ProfileId) && mapValidProf.get(customer.Owner.ProfileId) ){
                            if (customer.Flow__c == 'RM' && oldCustomer.Flow__c != 'RM' ){
                                lstCustFlowChange.add(customer);
                            }
                            else if (customer.OwnerId != oldCustomer.OwnerId){
                                lstCustOwnerChange.add(customer);
                            }
                        }
                        
                    }
                    system.debug('lstCustFlowChange::'+lstCustFlowChange);
                    if(lstCustFlowChange != null && lstCustFlowChange.size()>0)
                    RMChangeEmailHandler.processRMChangeEmail(lstCustFlowChange,lstOwnerId,'FlowChange');
                    
                    if(lstCustOwnerChange != null && lstCustOwnerChange.size()>0)
                    RMChangeEmailHandler.processRMChangeEmail(lstCustOwnerChange,lstOwnerId,'RMChange');
                }                
            } 
      
            /*Insert/update Insurance Wallet record with product - Bajaj Finserv- FD*/
            InsuranceAgentRRHandler.upsertFDWallet(setFDCustIds);
            
            // Start of SMS trigger to call center leads - 19985
            Set<Id> custId = new Set<Id>();
            for(CUSTOMER_INFO__c custObj : Trigger.New) {
                custId.add(custObj.Id);
            }
            
            List<Call_Memo__c> callMemoList = [SELECT CUSTOMER__r.Lead_Viewable__c, CUSTOMER__r.Insurance_Agent__c, CreatedBy.UserRole.Name, CreatedDate FROM Call_Memo__c WHERE CUSTOMER__c IN : custId];
            
            CallMemoTriggerHandler.createSMSRecords(callMemoList);
            // End of SMS trigger to call center leads - 19985
        }
        // *** Insurance Distribution -- END        
    }

}