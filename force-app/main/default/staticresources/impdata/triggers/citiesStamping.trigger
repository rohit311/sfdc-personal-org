trigger citiesStamping on CUSTOMER_INFO__c(before insert, before update) {

  //added code to restrict trigger execution for user having profile id maintained in Label.PO_Trigger_restrictedUserId
    string Pid = Userinfo.getProfileID();
    string Ids = Label.PO_Trigger_restrictedUserId;
    set < string > restrictedIdsSet = new set < string > ();
    if (ids != null) 
        restrictedIdsSet.addAll(Ids.split(';'));
        
    if(restrictedIdsSet.contains(Pid))
    return;

    CustInfoCitiesHandler CustInfoCitiesHandlerObj = new CustInfoCitiesHandler(Trigger.new, Trigger.oldMap, Trigger.newMap);
    //New added
    if ((trigger.isinsert || trigger.isupdate) && trigger.isBefore) {
        system.debug('is Before and is Insert  and update INNNNNsert');
           CustInfoCitiesHandlerObj.appendRuralCities();
    }
    /*
    for (CUSTOMER_INFO__c custInfo: trigger.new) {
        if (trigger.isinsert && trigger.isBefore) {
           system.debug('is Before and is Insert INNNNNsert');
           CustInfoCitiesHandlerObj.appendRuralCities();
        }
        if (trigger.isupdate && trigger.isBefore) {
           system.debug('is Before and is Insert INNNNN');
           CustInfoCitiesHandlerObj.appendRuralCities();
        }
    }*/
}