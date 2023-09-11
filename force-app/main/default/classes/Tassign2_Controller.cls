public class Tassign2_Controller {

    public List<Expense__c> explist{get;set;}
    public Map<String,Boolean> mapid{get;set;}
    public List<Expense__c> newlist{get;set;}     
    public String mid{get;set;}
    
    {mapid=new Map<String,Boolean>();}
    
    public Tassign2_Controller(){
        
       
        explist=new List<Expense__c>();
        explist=[SELECT ID,Amount__c,Client__c,Name FROM Expense__c];
        
         for(Expense__c a:explist)
        {
            mapid.put(a.Id,false);
        }
    }
    
    
    
    public void uMap()
        {
            Boolean flag=mapid.get(mid);
            mapid.put(mid,!flag);
        }
    
    public PageReference myfunc(){
        List<String> toSaveList=new List<String>();
         newlist=new List<Expense__c>();
        for(String aid:mapid.keySet())
        {
            if(mapid.get(aid))
            {
                toSaveList.add(aid);
                //newList.add(aid);
            }          
        }
        
       
       newList=[SELECT Id,Amount__c,Client__c,Name FROM Expense__c WHERE Id IN :toSaveList];
        System.debug(newList);
        List<Expense__c> toUpdate=new List<Expense__c>();
        Integer i=0;
        for(String aid:mapid.keySet())
        {
            if(aid!=explist.get(i).id && mapid.get(aid))
            {
                explist.remove(i);
               
            }       
            i++;
        }
       System.debug(explist.size());
        if(explist.size()>0)
        update explist;
       // update toSaveList;
        System.debug(explist);
       
        return null;
    }
}