public class TrailLoop {
   
 
    
    //Here is a combined problem of a query that needs a filter
    //and a loop that continually calls out to the database
    public static void AllGoodThings(Account a) {
    List<Task> taskLst = new List<Task>();
        List<Task> allMyTasks = [Select Id, status, whatId From Task WHERE whatId = :a.Id];
        for (Task t : allMyTasks) {
                t.status = 'Completed';
                taskLst.add(t);
            
        }
        
        update taskLst;
    }
    
   
    
}