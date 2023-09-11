public class AngularWithVfPage{

public static String getContacts(){
    return JSON.serialize([SELECT Id,Name,Email FROM Contact]);
}

}