public class OpportunityList2Con {

    
    public ApexPages.StandardSetController setCon{
        
        get{
            if(setCon==null)
            {
            setCon=new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name,CloseDate FROM Opportunity]));
            }
                return setCon;   
        }
        set;
        
    }
}