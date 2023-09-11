public class ProfileController {

    
    @AuraEnabled
    public static List<Profile> fetchProfiles(){
        
        return [select Name,UserType from Profile];
    }
    
    @AuraEnabled
    public static List<ObjectPermissions> fetchPermissions(String profileName){
      System.debug('profileName '+profileName);  
      return  [SELECT Id, SObjectType, PermissionsRead, PermissionsCreate FROM ObjectPermissions WHERE parentid in (select id from permissionset where PermissionSet.Profile.Name = :profileName)];
    }
}