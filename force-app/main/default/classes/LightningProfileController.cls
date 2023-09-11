public with sharing class LightningProfileController {
    public LightningProfileController() {

    }

    @AuraEnabled
    public static List<String> fetchProfiles(){
        Set<String> profileNames = new Set<String>();

        try {
            for(Profile profileRecord : [SELECT Id, Name from Profile ORDER BY Name]){
                profileNames.add(profileRecord.Name);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return new List<String>(profileNames);
    }
}