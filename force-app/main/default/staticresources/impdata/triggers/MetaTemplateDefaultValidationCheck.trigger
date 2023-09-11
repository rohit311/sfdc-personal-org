trigger MetaTemplateDefaultValidationCheck on Template__c (before delete, before insert, before update) {
	if(Trigger.isDelete){
		for (Template__c template : Trigger.old) {
			if(template.IsDefault__c)
				template.addError('Cannot delete a default template');
		}
	}else{
		for (Template__c template : Trigger.new) {
			if(template.IsDefault__c){
				List<Template__c> templateLst = [SELECT Name,Product__r.Name FROM Template__c WHERE Product__c = :template.Product__c AND IsDefault__c = true AND Id != :template.Id LIMIT 1];
				if(!CommonUtility.isEmpty(templateLst)){
					Template__c defaultTemplate = templateLst[0];
					template.addError('There is already a default Template '+defaultTemplate.Name+' set for the Product '+defaultTemplate.Product__r.Name);				
				}
				if(('Disabled').equalsIgnoreCase(template.Status__c)){
					template.addError('Cannot disable a default template');
				}
		  	}
		}
	}
}