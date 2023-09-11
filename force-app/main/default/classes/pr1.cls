public class pr1 {

    
    public static void info1()
    {
        ID id1=Userinfo.getProfileId();
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
		String MyProfileName = PROFILE[0].Name;
        System.Debug(MyProfileName);
    }
}