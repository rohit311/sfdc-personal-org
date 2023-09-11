public class day4_assign1_controller{
public Map<Invoice__c,List<Line_Item__c>> linemap=new Map<Invoice__c,List<Line_Item__c>>();
public date d{get;set;}
public Map<Invoice__c,List<Line_Item__c>> getLinemap()
{
return linemap;
}


public day4_assign1_controller()
{
  }

public Map<Invoice__c,List<Line_Item__c>>  getAllRecord()
{
 List<Invoice__c>ilst=[Select id,Name,Ownerid,Status__c From Invoice__c where cDate__c=:d];
 List<Line_Item__c> lnlst=[Select id,Invoice__c,Quantity__c,Unit_Price__c,Merchandise__c From LIne_item__c];
 
 for(Invoice__c inv:ilst)
 {
 List<Line_Item__c> temp=new List<Line_Item__c>();
 linemap.put(inv,temp);
    for(LIne_item__c l:lnlst)
    {
         if(inv.id==l.Invoice__c)
         {
             temp.add(l);
         }
    } 
 
 }
 
 return linemap;
}
  
  public PageReference calc()
  {
   linemap=getAllRecord();
   return null;
  }   
}