trigger DPLInsuranceTrigger on DPLinsurance__c (before insert, after insert, 
    before update, after update, 
    before delete, after delete) {
    static Set<id> LoanIdsSet = new Set<id>(); // 24313
    static List<Opportunity> oppLstSt;// 24313
    if(ControlRecursiveCallofTrigger_Util.getDPLInsuranceTriggerFlag()) {
        if(Trigger.isBefore) {
            if(Trigger.isInsert || Trigger.isUpdate) {
                DPLInsuranceTriggerHandler HandlerObj = new DPLInsuranceTriggerHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap,false);
                HandlerObj.upadteCPAApplicant();
                HandlerObj.updateShortCode();
            }   
        }
        
        if(Trigger.isAfter) {
		//Added for Bug 24313 start
            if(Trigger.isInsert ){
                
                set<Id> setLoan = new set<id>();
                for(DPLinsurance__c ins:trigger.new){
                    
                    if(ins.Opportunity__c != null)
                        setLoan.add(ins.Opportunity__c);
                }
                GeneralUtilities.ResendConsentMailValidation('DPLinsurance__c',setLoan);
            }
            //Added for Bug 24313 stop
            if(Trigger.isInsert || Trigger.isUpdate) {
                DPLInsuranceTriggerHandler HandlerObj = new DPLInsuranceTriggerHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap,false);
                HandlerObj.calculatePremium();
                //HandlerObj.handleCommunication();
                HandlerObj.validatePolicyMembers();
                ControlRecursiveCallofTrigger_Util.setDPLInsuranceTriggerFlag();
            }
			}
			}
              //Added getDelInsuTrigFlag for Bug 24313 start
    if(ControlRecursiveCallofTrigger_Util.getDelInsuTrigFlag()) {
        if(Trigger.isDelete) {
            //Added for Bug 24313 start
            if(Trigger.isAfter){
                
                set<Id> setLoan = new set<id>();
                for(DPLinsurance__c ins:trigger.old){
                    
                    if(ins.Opportunity__c != null)
                        setLoan.add(ins.Opportunity__c);
                }
                GeneralUtilities.ResendConsentMailValidation('DPLinsurance__c',setLoan);
                ControlRecursiveCallofTrigger_Util.setDelInsuTrigFlag();//Added for Bug 24313
            }
            //Added for Bug 24313 stop    
            DPLInsuranceTriggerHandler HandlerObj = new DPLInsuranceTriggerHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap,true);
            HandlerObj.calculatePremium();
            HandlerObj.preventDelete();
            
        }
    }
	//Added for Bug 24313 start 
    if(Trigger.isAfter && trigger.isUpdate){
    DPLInsuranceTriggerHandler HandlerObj = new DPLInsuranceTriggerHandler(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap,false);
        HandlerObj.updInsMobility();
    }
    //Added for Bug 24313 stop
    
}