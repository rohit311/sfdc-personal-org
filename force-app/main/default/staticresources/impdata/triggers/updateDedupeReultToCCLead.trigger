trigger updateDedupeReultToCCLead on De_Dupe__c(after insert, after update) {
    
     //Added by mahima to restric integration user access- start--
    ID Pid=Userinfo.getProfileID();
    string Ids= Label.dedupe_App_restrictedUserId;
    //List<string> restrictedIds= new list<string>();
    set<string> restrictedIdsSet= new set<string>();
    if( ids!=null)
    {
        restrictedIdsSet.addAll(Ids.split(','));
    }
    if(!restrictedIdsSet.contains(Pid))
    {
      //Added by mahima to restric integration user access- end--  
    List < Id > applist = new List < Id > ();
    Set < Id > ApplicantsList = new Set < Id > ();
    List < CCLeadSalaried__c > tempSal = new List < CCLeadSalaried__c > ();
    List < CCLeadSalaried__c > tempSal1 = new List < CCLeadSalaried__c > ();
    Boolean isChanged = false; //harsit ---- flag to identify if the Dedupe_Lan_Matches__c/Customer_Status__c updated on dedupe records
    for (De_Dupe__c ct: Trigger.New) {
        if (ct.Loan_Application__c != null) {
            applist.add(ct.Loan_Application__c);
        }
        if (ct.Applicant__c != null) {
            ApplicantsList.add(ct.Applicant__c);
        }
        //harsit---optimization start
        //to determine if reaLLy need to update CCLeadSalaried__c
        if((ct.Dedupe_Lan_Matches__c != null || ct.Customer_Status__c != null) && ((Trigger.isInsert) ||
            (Trigger.isUpdate && (ct.Dedupe_Lan_Matches__c != Trigger.oldMap.get(ct.id).Dedupe_Lan_Matches__c || ct.Customer_Status__c != Trigger.oldMap.get(ct.id).Customer_Status__c)))){
                isChanged = true;
        }
        //harsit---optimization END
    }
    system.debug('*****applist*****' + applist);

    if(isChanged){ // harsit---optimization
        tempSal = [select Opportunity__c, cibil_score__c from CCLeadSalaried__c where Opportunity__c in: applist];
        system.debug('*****tempSal *****' + tempSal);
        if (tempSal != null && tempSal.size() > 0) {
            for (De_Dupe__c ctt: Trigger.New) {
                for (CCLeadSalaried__c sal: tempSal) {
                    if (sal.Opportunity__c == ctt.Loan_Application__c) {
                        if (ctt.Dedupe_Lan_Matches__c != null) {
                            sal.Dedupe_Lan_Matches__c = ctt.Dedupe_Lan_Matches__c;
                        }
                        if (ctt.Customer_Status__c != null) {
                            sal.Customer_Status__c = ctt.Customer_Status__c;
                    }
                }
                tempSal1.add(sal);
            }
        }
        update tempSal1;

    }


}


    if (trigger.isUpdate && trigger.isAfter) {
        boolean switchforDedupe = false;
        //if (!Test.isRunningTest())
        LaonApplicationCreation__c deDupeCustSett = LaonApplicationCreation__c.getValues('de-Dupe Switch');
        if (deDupeCustSett != null && deDupeCustSett.Integrate_Charges_API__c != null)
            switchforDedupe = deDupeCustSett.Integrate_Charges_API__c;
        //List < Applicant__c > appListUpdate = new List < Applicant__c > ();
        //Harsit----optimization start
        SET < Applicant__c > appListUpdate = new SET < Applicant__c > ();
        //Harsit----optimization end
        //Map < ID,Set < Applicant__C >> MapOfDeupeApplicants = new Map < ID,Set < Applicant__C >  > ();
    
        Map < ID,List < Applicant__C >> MapOfDeupeApplicants;
        //harsit----optimization START
        //Preparing the MapOfDeupeApplicants if needed
        /*Set < Id > ApplicantsList = new Set < Id > ();        
        List < Applicant__C > ApplicantsListNew = new List < Applicant__C > ();
        if (switchforDedupe) {
            for (De_Dupe__c dedupeNew: Trigger.New) {
                if (dedupeNew.Applicant__c != null) {
                    ApplicantsList.add(dedupeNew.Applicant__c);
                }
            }
            ApplicantsListNew = [select id, Existing_Customer__c from Applicant__C where id in: ApplicantsList];
            for (De_Dupe__c dedup: Trigger.New) {
                // Bug 13443 S - Too many SOQL query error in PO conversion
                Set < Applicant__c > ApplicantList = new Set < Applicant__c > ();
                // Bug 13443 S - Too many SOQL query error in PO conversion
                for (Applicant__C applicant: ApplicantsListNew) {
                    if (applicant.id == dedup.Applicant__c) {
                        ApplicantList.add(applicant);
                    }
                }
                MapOfDeupeApplicants.put(dedup.ID, ApplicantList);
                System.debug('MapOfDeupeApplicants******' + MapOfDeupeApplicants);

            }
        }*/
       //harsit----optimization END
        List < Applicant__c > ApplicantList;
        for (De_Dupe__c dedup: Trigger.New) {
            if (dedup.Applicant__c != null && dedup.Customer_Status__c != null && (dedup.Customer_Status__c == 'Good' || dedup.Customer_Status__c == 'Bad')) {
                if (!switchforDedupe) {
                    //appListUpdate = [select id, Existing_Customer__c, Loan_Application__r.product__c from Applicant__c where id = : dedup.Applicant__c];
                    //Harsit----optimization start
                    appListUpdate.addALL([select id, Existing_Customer__c, Loan_Application__r.product__c from Applicant__c where id = : dedup.Applicant__c]);
                    //harsit------optimization end
                }
                else{
                    //harsit--optimization START
                    //Preparing the map if it is needed and empty
                    System.debug('MapOfDeupeApplicants******' + MapOfDeupeApplicants + ':'+ CommonUtility.isEmpty(MapOfDeupeApplicants));
                    if(CommonUtility.isEmpty(MapOfDeupeApplicants)){
                        MapOfDeupeApplicants = new Map < ID,List < Applicant__C >> ();
                        List < Applicant__C > ApplicantsListNew = [select id, Existing_Customer__c from Applicant__C where id in: ApplicantsList]; // Harsit---This query is in for loop, but it will execute once.
                        for (De_Dupe__c dedupTemp: Trigger.New) {
                            ApplicantList = new List < Applicant__c > ();
                            // Bug 13443 S - Too many SOQL query error in PO conversion
                            //Set < Applicant__c > ApplicantList = new Set < Applicant__c > ();
                            // Bug 13443 S - Too many SOQL query error in PO conversion
                            for (Applicant__C applicant: ApplicantsListNew) {
                                if (applicant.id == dedupTemp.Applicant__c) {
                                    ApplicantList.add(applicant);
                                }
                            }
                            MapOfDeupeApplicants.put(dedupTemp.ID, ApplicantList);
                            System.debug('MapOfDeupeApplicants******' + MapOfDeupeApplicants);
                        }
                    }
                    //harsit --- optimization END
                    for (Applicant__c applicantDedupe: MapOfDeupeApplicants.get(dedup.ID)) {
                        appListUpdate.add(applicantDedupe);
                    }
                }
                if (appListUpdate.size() > 0) {
                    for (Applicant__c app: appListUpdate) {
                        if (dedup.Dedupe_Lan_Matches__c != null && dedup.Dedupe_Lan_Matches__c.ToUpperCase().contains('SALARIED LOAN')) {
                            app.Existing_Customer__c = 'Existing Salaried Customer';
                            break;
                        } else {
                            app.Existing_Customer__c = 'Existing Customer';
                        }
                        //app.Existing_Customer__c = 'Existing Customer';
                    }
                }
            }
        }
        if (appListUpdate != null && appListUpdate.size() > 0)
            update new List<Applicant__c>(appListUpdate);
    }
    }
}