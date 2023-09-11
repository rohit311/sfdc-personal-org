trigger UserTrigger on User(before insert,before update,after update)
{
    System.debug('in create user');
    UserTriggerHandler userTriggerHandlerObj = new UserTriggerHandler(trigger.new,trigger.oldMap,trigger.newMap); 
    
    if((trigger.isBefore && trigger.isInsert) || (trigger.isBefore && trigger.isUpdate))
    {
        userTriggerHandlerObj.appendRuralServingCities();
        // userTriggerHandlerObj.appendBranchCity();
    }
    
    if((trigger.isBefore && trigger.isUpdate))
    {
        userTriggerHandlerObj.incrementLicenceCountOfUser();
        
        // START
        //BBHAL - 06/22/2016 - Clears the federation ID field if user is deactivated
        for (User u : trigger.new)
        {
            try
            {
                if(!u.IsActive)
                    u.FederationIdentifier = '';
            }
            catch(Exception e)
            {
                System.debug('Exception '+ e);
            }
        }
        //END
    }
    
    // Added for bug 6260
    if((trigger.isAfter && trigger.isUpdate))
    {
        Set<id> newUserSet = new Set<id>();
    
    for(User u : Trigger.New)
          newUserSet.add(u.id);
        
        UserTriggerHandler.deactivateSalesOfficerCreditOfficerRecord(newUserSet);
    }
    
    // Added for 18812
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            List<Id> userIdList = new List<Id>();
            for(User userObj : Trigger.New) {
                userIdList.add(userObj.Id);
            }   
            userTriggerHandlerObj.calculateSharing(Trigger.New, userIdList);
        }
        if(trigger.isUpdate) {
            List<Id> userIdList = new List<Id>();
            List<User> userList = new List<User>();
            for(User userObj : Trigger.New) {
                if(trigger.oldMap.get(userObj.Id).Branch_City__c != userObj.Branch_City__c) {
                    userIdList.add(userObj.Id);
                    userList.add(userObj);
                }
            }
            userTriggerHandlerObj.calculateSharing(userList, userIdList);
        }
    }
}