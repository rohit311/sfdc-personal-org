/** 

* File Name: UpdateDeDupeStatus

* Description: This trigger is used to update

* UpdateDeDupeStatus on loan

* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 

* @author : Wipro

* Modification Log 

* =============================================================== 

* Ver   Date        Author      Modification 

* --- ---- ------ ------------- ---------------------------------

* 1.0   19-Feb-10  Raji Created 
*/
trigger UpdateDeDupeStatus on De_Dupe__c(after update) {
  /*20939 s */
  Map<String,List<Map<String,String>>> oldValueNewValueMap=new Map<String,List<Map<String,String>>>();       
/*20939 e */
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
      List < Opportunity > opp = new List < Opportunity > ();
      //List < Id > oppId = new List < Id > ();
      List < De_Dupe__c > dedupes = new List < De_Dupe__c > ();
      //Id LoanId;
      integer count = 0, flag = 0;
      //harsit-----optimzation START
      //to store the opp IDs, using SET instead of LIST
      SET < Id > oppId = new SET < Id > ();
      for (De_Dupe__c app: trigger.new) {
       //if de dupe error raised      
       /*flag = 0;
       for (integer n = 0; n < OppId.size(); n++) {
        if (OppId[n] == app.Loan_Application__c)
         flag = 1;
       }
       if (flag == 0 && app.Loan_Application__c != null)
        OppId.add(app.Loan_Application__c);*/
         if(app.Loan_Application__c != null)
            oppId.add(app.Loan_Application__c);
      }
      //harsit-----Optimization END
      //getting oppty recs
      //
      boolean switchforDedupe = false;
      LaonApplicationCreation__c deDupeCustSett = LaonApplicationCreation__c.getValues('de-Dupe Switch');
      if(deDupeCustSett != null && deDupeCustSett.Integrate_Charges_API__c != null)
          switchforDedupe = deDupeCustSett.Integrate_Charges_API__c;
       if (!switchforDedupe) {
       opp = [Select Id, De_Dupe_Status__c, FlagChecklist__c,/*20939 s */Account.Offer_Inhanced__c,Account.Flow__c,(select id,name,Old_Loan_Application__c,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policys__r)/*20939 e */ from Opportunity
        where Id in : OppId
       ];
       dedupes = [Select Id, De_Dupe_result__c, Loan_Application__c from
        De_Dupe__c where Loan_Application__c in : OppId
       ];
      } else {
       opp = [Select Id, De_Dupe_Status__c, FlagChecklist__c,/*20939 s */Account.Offer_Inhanced__c,Account.Flow__c,(select id,name,Old_Loan_Application__c,Policy_Name__c,Remarks__c,Disposition_Status__c,Checklist_Policy_Status__c from SOL_Policys__r),/*20939 e*/(select id, De_Dupe_result__c, Loan_Application__c from De_Dupes__r) from Opportunity
        where Id in : OppId
       ];
       // harsit---optimzation start
       /*for (Opportunity oppnew: opp) {
        for (De_Dupe__c dedupe: oppnew.De_Dupes__r) {
         dedupes.add(dedupe);
        }
       }*/
       // harsit---optimzation END
      }
/*20939 s */      
Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();  
      for (integer i = 0; i < opp.size(); i++) {
          oppMap.put(opp[i].Id,opp[i]); /*20939 e */

       count = 0;
      //harsit----optimzation START
       if(!switchforDedupe){
            for (integer k = 0; k < dedupes.size(); k++) {
                if (opp[i].Id == dedupes[k].Loan_Application__c && dedupes[k].De_Dupe_result__c == 'Bad')
                count = count + 1;
            }
        }else{
            if(!CommonUtility.isEmpty(opp[i].De_Dupes__r)){
                for(integer k = 0; k < opp[i].De_Dupes__r.size();k++){
                    if(opp[i].De_Dupes__r[k].De_Dupe_result__c == 'Bad')
                        count = count + 1;
                }
            }
       }
       //harsit----optimzation END
       if (count > 0) {
        opp[i].De_Dupe_Status__c = true;
       } else {
        opp[i].De_Dupe_Status__c = false;
       }
       decimal flag1 = 0;
       if (Opp[i].FlagChecklist__c >= 0 || Opp[i].FlagChecklist__c < 0) {
        flag1 = Opp[i].FlagChecklist__c + 1;
       } else {
        flag1 = 1;
       }
       Opp[i].FlagChecklist__C = flag1;
      }
      // Bug 13443 S - Too many SOQL query error in PO conversion
      /*  Retrigger BRE 20939 s*/
      Map<String,Object> allMap = new Map<String,Object>();
      allMap = GeneralUtilities.fetchRetriggerRescMap();
      Map<String,SOL_Policy__c> solPolicyToUpdateMap = new map<String,SOL_Policy__c>();
      for (De_Dupe__c app: trigger.new) {
          Opportunity Loan = new Opportunity();
          if(oppMap != null && oppMap.containsKey(app.Loan_Application__c) && oppMap.get(app.Loan_Application__c) != null)
              Loan = oppMap.get(app.Loan_Application__c);
          system.debug('Loan is'+Loan+Loan.Account.Flow__c);
          if(Loan != null && Loan.Account.Flow__c == 'Mobility V2'){
            Map<String,Object> appFields = new Map<String,Object>();
            
            if(!commonutility.isEmpty(allMap)){
                appFields = (Map<String,Object>)allMap.get('De_Dupe__c');
                System.debug('Hi'+appFields );
                if(!commonutility.isEmpty(appFields)){
                    solPolicyToUpdateMap = GeneralUtilities.reTriggerBREGen(Trigger.oldmap.get(app.Id),app,Loan,appFields,solPolicyToUpdateMap);
                    
                }
            }
          }
      }
      if(solPolicyToUpdateMap != null && solPolicyToUpdateMap.size() > 0){
          update solPolicyToUpdateMap.values();    
      }
    /* Retrigger BRE 20939 e*/
     if(!ControlRecursiveCallofTrigger_Util.hasDedupeToPOUpdate()){
        update opp;
        ControlRecursiveCallofTrigger_Util.setDedupeToPOUpdate();
      }
      // Bug 13443 S - Too many SOQL query error in PO conversion
    }
 } //end of trigger