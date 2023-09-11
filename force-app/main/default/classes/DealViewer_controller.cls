public class DealViewer_controller{

public String fname{get;set;}
public String lname{get;set;}
public ID c_id{get;set;}
public Deal__c deal{get;set;}
public List<Deal_Action__c> daList{get;set;}
public List<Deal__c> dealslist=new List<Deal__c>();
public Deal_Action__c dealaction{get;set;}
public List<Deal_Action__c> status{get;set;}
 public ApexPages.StandardSetController dealList{get; set;}  
public string deal_id{get;set{
this.deal_id=value;

}}


public List<Deal__c> getdealsList()
{
return (List<Deal__c>)dealList.getRecords();
}
public Deal__c de{get;set;}
public Contact c=[SELECT ID,Acceptance_rate__c,Deals_Accepted__c,Deals_Rejected__c,FirstName,LastName FROM Contact WHERE ID=:ApexPages.currentPage().getParameters().get('id')];
public Map<String,String> statusmap{get;set;}

public Map<String,String> amap{get;set;}
public List<Attachment> attach{get;set;}
public String deal_name{get;set;}


public Contact getC()
{

return c;
}

{
//c.Deals_Accepted__c=0;
dealslist=[SELECT ID,Deal_Name__c,Max_Acceptances__c,Valid_Through__c,Available_Deals__c,Acceptances__c,Rejections__c,Name FROM DEAL__c];

//daList=[ SELECT Status__c,(SELECT ID,Deal_Name__c,Max_Acceptances__c,Valid_Through__c,Available_Deals__c,Acceptances__c,Rejections__c FROM Deal_Action__c.Deal_c__r) FROM Deal_Action__c ];
//daList=[SELECT ID,Contact_c__c,Status__c,Deal_c__r.ID,Deal_c__r.Deal_Name__c,Deal_c__r.Max_Acceptances__c,Deal_c__r.Valid_Through__c,Deal_c__r.Available_Deals__c,Deal_c__r.Acceptances__c,Deal_c__r.Rejections__c FROM Deal_action__c];
 

//dealaction =[SELECT ID,Contact_c__c,Deal_c__c,status__c FROM Deal_Action__c WHERE Contact_c__c=:c.id];
//de=[SELECT Acceptance_Rate__c,Acceptances__c,Rejections__c FROM DEAL__C WHERE ID=:deal_id];



   statusmap=new Map<String, String>();
  // c=[SELECT ID,Acceptance_rate__c,Deals_Accepted__c,Deals_Rejected__c,FirstName,LastName FROM Contact WHERE ID=:ApexPages.currentPage().getParameters().get('id')];
        for(Deal__c d:dealslist){
            status=[SELECT Action__c FROM Deal_Action__c WHERE Deal_c__c = :d.id AND Contact_c__c = :c_id];
           if(status.size()==0)
            {
            statusmap.put(d.name,'Available');
            
            }
            else if(status[0].Action__c=='Accepted' )
            {
            statusmap.put(d.name,'Accepted');
            }
            else
            {
            statusmap.put(d.name,'Rejected');
            }

           
        }
        
      amap=new Map<String,String>();
      
          for(Deal__c d:dealslist)
          {
            attach=[ SELECT Id FROM Attachment WHERE ParentId=:d.id];
             if(attach.size()==0)
             {
                 amap.put(d.id,'https://c.ap2.visual.force.com/resource/1454055794000/default_image');
             
             }
             else
             {
             String id=(String)attach[0].id;
                amap.put(d.id,id.substring(0,15));
             
             }
              
          
          }
        
}

public DealViewer_controller()
{
       dealList=new ApexPages.StandardSetController(Database.getQueryLocator([SELECT ID,Deal_Name__c,Max_Acceptances__c,Valid_Through__c,Available_Deals__c,Acceptances__c,Rejections__c,Name FROM DEAL__c]));
        
              dealList.setPageSize(5);      

     c=[SELECT ID,Acceptance_rate__c,Deals_Accepted__c,Deals_Rejected__c,FirstName,LastName FROM Contact WHERE ID=:ApexPages.currentPage().getParameters().get('id')];
c_id=c.id;
 fname=c.Firstname;
 lname=c.LastName;

}


public PageReference done_action()
{

PageReference pr = new PageReference('/'+c.ID);

    pr.setRedirect(true);
    return pr;

//string ret= ApexPages.currentPage().getParameters().get('retURL')


}

public void Accept_Action() {

c=[SELECT ID,Acceptance_rate__c,Deals_Accepted__c,Deals_Rejected__c,FirstName,LastName FROM Contact WHERE ID=:ApexPages.currentPage().getParameters().get('id')];
Decimal y=c.Deals_Accepted__c+1;
c.Deals_Accepted__c=y;
       
    Deal_Action__c dact=new Deal_Action__c(status__c='Accepted');
    dact.Contact_c__c=ApexPages.currentPage().getParameters().get('id');
    dact.Deal_c__c=deal_id;
   update c;
   
    insert dact;
     

String x='a0B28000002zyYl';
     deal=[SELECT id,Deal_Name__c,Max_Acceptances__c,Valid_Through__c,Available_Deals__c,Acceptances__c,Rejections__c FROM DEAL__c WHERE Deal__c.id=:deal_id];
   deal.Acceptances__c=deal.Acceptances__c+1;
    upsert deal;
    statusmap.put(deal.name,'Accepted');
   dealList=new ApexPages.StandardSetController(Database.getQueryLocator([SELECT ID,Deal_Name__c,Max_Acceptances__c,Valid_Through__c,Available_Deals__c,Acceptances__c,Rejections__c,Name FROM DEAL__c]));
         

}

public void Reject_Action()
{
c=[SELECT ID,Acceptance_rate__c,Deals_Accepted__c,Deals_Rejected__c,FirstName,LastName FROM Contact WHERE ID=:ApexPages.currentPage().getParameters().get('id')];
    Decimal y=c.Deals_Rejected__c+1;
    c.Deals_Rejected__c=y;
    update c;
 
 Deal_Action__c dact=new Deal_Action__c(status__c='Rejected');
    dact.Contact_c__c=c.id;
    dact.Deal_c__c=deal_id;
    
insert dact;

 deal=[SELECT ID,Deal_Name__c,Max_Acceptances__c,Valid_Through__c,Available_Deals__c,Acceptances__c,Rejections__c FROM DEAL__c WHERE id=:deal_id ];
    deal.Rejections__c=deal.Rejections__c+1;
        upsert deal;
        
         statusmap.put(deal.name,'Rejected');
   
   


}


//Boolean to check if there are more records after the present displaying records  
     public Boolean hasNext{  
        get{  
            return dealList.getHasNext();  
        }  
        set;  
    }  
   
    //Boolean to check if there are more records before the present displaying records  
    public Boolean hasPrevious{  
        get{  
            return dealList.getHasPrevious();  
        }  
        set;  
    }
    
   
    //Page number of the current displaying records  
    public Integer pageNumber{  
        get{  
            return dealList.getPageNumber();  
        }  
        set;  
    }  
  
    //Returns the previous page of records  
    public void previous(){  
        dealList.previous();  
    }  
   
    //Returns the next page of records  
    public void next(){  
        dealList.next();  
    }
    
    //Returns the first page of records  
    public void first(){  
        dealList.first();  
    }  
   
    //Returns the last page of records  
    public void last(){  
        dealList.last();  
    }  

public void updatedealsAndContacts(ID did,ID cid)
{
List<Contact> conList=new List<Contact>();
        List<Deal__c> dealList=new List<Deal__c>();
        Contact c=[select Deals_Accepted__c,Deals_Rejected__c,Acceptance_Rate__c  from contact where id=:cid];
        Deal__c d=[select name,rejections__c,Acceptances__c,available_deals__c from deal__c where id=:deal_ID];
        for(Deal_Action__c deal : [select action__c from deal_action__c where contact_c__c=:cid and deal_c__c=:did]) {
                if(deal.action__c=='Accepted') {
                c.Deals_Accepted__c+=1;
                d.Acceptances__c+=1;
                conList.add(c);
                dealList.add(d);
                }
            if(deal.action__c=='Rejected') {
                c.Deals_Rejected__c+=1;
                d.rejections__c+=1;
                conList.add(c);
                dealList.add(d);
                }
        }
        update conList;
        update dealList;



}



}