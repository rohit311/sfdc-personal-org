trigger UpdateCashFlowSumary on Cash_Flow__c (after insert, after update) {
	if (!ControlRecursiveCallofTrigger_Util.hasAlreadyExecutedCashflowSummary()) {
		ControlRecursiveCallofTrigger_Util.setAlreadyExecutedCashflowSummary();
    	UpdateCashFlowSummary.UpdateSummary(trigger.new);
	}
}