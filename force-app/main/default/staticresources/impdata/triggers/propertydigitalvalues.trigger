trigger propertydigitalvalues on Property_Details__c (after update, after insert) {
     /* Customer Level Collateral Tracking added by krish start  */
   Map<String,Object> valueCollateral = new Map<String,Object>();
    List<StaticResource> staticRsrc = new  List<StaticResource>();
    staticRsrc = [SELECT body from StaticResource where name = 'SalariedCustomSettings' limit 1];
    if(staticRsrc.size() > 0){
        String jsnBody = staticRsrc[0].Body.tostring();
        Map<String,Object> allMap= (Map<String,Object>) JSON.deserializeUntyped(jsnBody);
        valueCollateral = (Map<String,Object>)allMap.get('customer_collateral');
    }
    /* Customer Level Collateral Tracking added by krish end  */
    system.debug('ContributionCalculation Flag -> ' + ControlRecursiveCallofTrigger_Util.getContributionCalculation());
    //harsit-----optimization START
    //Merged some code here from propertyId TRIGGER
    if (!ControlRecursiveCallofTrigger_Util.getContributionCalculation()) {
        ControlRecursiveCallofTrigger_Util.setContributionCalculation();
        
        List<Property_Details__c> proplist = new List<Property_Details__c>();
        Set<Id> oppsIds = new Set<Id>();
/* Customer Level Collateral Tracking added by krish start  */
        List < opportunity > opplist = new List < opportunity > ();
        List < opportunity > opplistToUpdate = new List < opportunity > ();
/* Customer Level Collateral Tracking added by krish end  */
        Opportunity opp = new Opportunity(Id = trigger.new[0].Loan_Application__c);
        for(Property_Details__c  pd : trigger.new ){
            if(pd.Loan_Application__c != null){
              oppsIds.add(pd.Loan_Application__c);
              system.debug('1********************');
            }
        }
         if(!CommonUtility.isEmpty(oppsIds)){
                proplist = [SELECT Existing_Loan_Funded_amount__c ,Product__c,Loan_application__r.Approved_Loan_Amount__c,Loan_application__r.Sum_of_Property_Funded_Amount__c,Loan_Application__c,id, name, Amount_fund_property__c, Digital_Scrip_market_price__c, Number_of_Shares__c, Contribution__c 
                  FROM Property_Details__c 
                  WHERE Loan_Application__c IN :oppsIds];
        }
        
        
        
        /* Customer Level Collateral Tracking added by krish start  */
        Set<id> oppIds = new Set<Id>();
        List<opportunity> oppToUpdate = new List<opportunity>();
        if (proplist != null && proplist.size() > 0) {
            
            for (Property_Details__c prop1: proplist) {
        Double totalPorfolio = 0;
        Double sum = 0;
                if(!oppIds.contains(prop1.Loan_Application__c)){
                    for (Property_Details__c prop2: proplist) {
                        
                        if(prop1.Loan_Application__c == prop2.Loan_Application__c){
                            if (prop2.Digital_Scrip_market_price__c != null && prop2.Number_of_Shares__c != null) {
                                totalPorfolio += prop2.Digital_Scrip_market_price__c * prop2.Number_of_Shares__c;
                            }
                            if (prop2.Amount_fund_property__c != null) {
                                sum = sum + prop2.Amount_fund_property__c;
                            }
                        }
                    }
                    system.debug('totalPorfolio '+totalPorfolio );
                    for (Property_Details__c prop2: proplist) {
                        Property_Details__c propRec = new Property_Details__c();
                        if(Trigger.oldMap != null)
                            propRec = Trigger.oldMap.get(prop2.id);
                        if(Trigger.newMap.containsKey(prop2.id) && propRec.Amount_fund_property__c != prop2.Amount_fund_property__c){
                            Set<String> colProd = new Set<String>();
                            colProd.addAll(String.valueof(valueCollateral.get('Products')).split(';'));
                            
                            decimal amount = 0;
                            if (colProd.contains(prop2.Product__c)) {
                                amount = prop2.Loan_Application__r.Approved_Loan_Amount__c;
                            
                                System.debug('amount is'+amount );
                                if(!CommonUtility.IsEmpty(prop2.Amount_fund_property__c) && !CommonUtility.IsEmpty(amount) && amount != 0){
                                        prop2.Existing_Loan_Funded_amount__c = (prop2.Amount_fund_property__c / amount )  *100;
                                        system.debug('prop.Existing_Loan_Funded_amount__c>>'+prop2.Existing_Loan_Funded_amount__c);
                                        
                                }
                            }
                        }
                        if(prop1.Loan_Application__c == prop2.Loan_Application__c){
                            if (totalPorfolio > 0 && prop2.Digital_Scrip_market_price__c != null && prop2.Number_of_Shares__c != null) {
                                prop2.Contribution__c = (prop2.Digital_Scrip_market_price__c * prop2.Number_of_Shares__c) / totalPorfolio * 100;
                            }
                        }
                        system.debug('prop.Existing_Loan_Funded_amount__c>>'+prop2.Existing_Loan_Funded_amount__c);
                                        
                    }
                    system.debug('sum is'+sum);
                    prop1.Loan_application__r.Sum_of_Property_Funded_Amount__c = sum;
                    oppIds.add(prop1.Loan_application__c);
                    oppToUpdate.add(prop1.Loan_application__r);
                }
            }
        }
        update proplist;
        update oppToUpdate;
        /* Customer Level Collateral Tracking added by krish end  */
        /*
        if (proplist != null && proplist.size() > 0) {
            for (Property_Details__c prop1: proplist) {
                if (prop1.Digital_Scrip_market_price__c != null && prop1.Number_of_Shares__c != null) {
                    totalPorfolio += prop1.Digital_Scrip_market_price__c * prop1.Number_of_Shares__c;
                }
                if (prop1.Amount_fund_property__c != null) {
                    sum = sum + prop1.Amount_fund_property__c;
                }
            }
            for (Property_Details__c prop1: proplist) {
                if (totalPorfolio > 0 && prop1.Digital_Scrip_market_price__c != null && prop1.Number_of_Shares__c != null) {
                    prop1.Contribution__c = (prop1.Digital_Scrip_market_price__c * prop1.Number_of_Shares__c) / totalPorfolio * 100;
                }
            }
            system.debug('3********************');
            update proplist;
            opp.Sum_of_Property_Funded_Amount__c = sum;
            if (opp.id != null && opp.Sum_of_Property_Funded_Amount__c!= null) {
                update opp;
            }
        }*/
    }
    //harsit-----optimization END
}