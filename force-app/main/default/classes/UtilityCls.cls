public class UtilityCls{

    
    public static Boolean isNotEmpty(Object obj){
        
        if(obj instanceOf String){
            return (obj != null && obj != '');
        }
        else if(obj instanceOf List<Object>){
            return (obj != null && ((List<Object>)obj).size()>0);
        }
    
        return false;
    }
    
    public static Boolean upsertData(List<sObject> obj){
    
        try{
            upsert obj;
            return true;
        
        }catch(Exception ex){
            return false;
        }
    
    }
    
}