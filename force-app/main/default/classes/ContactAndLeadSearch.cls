public class ContactAndLeadSearch {

    public static List<List<sObject>> searchContactsAndLeads(String n)
    {
        List<List<sObject>> sobj=[FIND :n in NAME FIELDS RETURNING Contact,Lead];
        return sobj;
    }
    
    
}