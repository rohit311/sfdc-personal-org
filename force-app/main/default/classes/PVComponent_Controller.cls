public class PVComponent_Controller {

   public ID hisID {get;set;}
   
   public List<History_Tracking__History> historyTrackingList{get;set;}
   public String priorValue{get;set;}
   public String newValue{get;set;}
    public DateTime LastModified {get;set;}
    public Integer index{get;set;}
   /*public List<History_Tracking__History> gethistoryTrackingList()
   {   
        
        historyTrackingList = [SELECT OldValue, NewValue,Field From History_Tracking__History];
       
        
     if(historyTrackingList!=null && historyTrackingList.size()>0)
     {
           for(History_Tracking__History history:historyTrackingList)
           {
                 if(history.Field == 'Grade__c')
                 {
                    priorValue = String.valueOf(history.OldValue);
                    newValue = String.valueOf(history.NewValue);
                    break;
                 }
           }
         }
         System.debug('prior values '+priorValue);
          System.debug('prior values '+newValue);
      return historyTrackingList;
   }*/
   
   public PVComponent_Controller(){
   
       historyTrackingList = [SELECT OldValue, NewValue,Field,CreatedDate From History_Tracking__History];
       Integer cnt=0;
        
     if(historyTrackingList!=null && historyTrackingList.size()>0)
     {
         LastModified= historyTrackingList.get(0).CreatedDate;
           for(History_Tracking__History history:historyTrackingList)
           {
               cnt=cnt+1;
                 if(history.Field == 'Grade__c' && LastModified<history.CreatedDate)
                 {
                    
                    LastModified=history.CreatedDate;
                    index=cnt;
                 }
           }
         
                    priorValue = String.valueOf(historyTrackingList.get(index).OldValue);
                    newValue = String.valueOf(historyTrackingList.get(index).NewValue);
         }
         System.debug('prior values '+priorValue);
          System.debug('prior values '+newValue);
   }
}