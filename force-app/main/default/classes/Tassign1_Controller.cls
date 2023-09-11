public class Tassign1_Controller {

     public List<Account> acclist{get;set;}
    public Map<ID,Boolean> mapid{get;set;}
    
    public Tassign1_Controller(){
        
        mapid=new Map<ID,Boolean>();
        acclist=new List<Account>();
        acclist=[SELECT ID,name,Phone,AccountNumber FROM Account];
        
         for(Account a:acclist)
        {
            mapid.put(a.id,false);
        }
    }
    
    
    public PageReference myfunc(){
        List<String> toSaveList=new List<String>();
        
        for(String aid:mapid.keySet())
        {
            if(mapid.get(aid))
            {
                toSaveList.add(aid);
                
            }          
        }
        
        Account[] newList;//=new List<Account>();
        newList=[SELECT Id,name,Phone,AccountNumber FROM Account WHERE Id IN :toSaveList];
        System.debug(newList);
        if(newList.size()>0)
        update newList;
      
        return null;
    }
}