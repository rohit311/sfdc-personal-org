global class DailyLeadProcessor implements Schedulable{
  
    global void execute(SchedulableContext ctx)
    {
        List<Lead> lst=[SELECT id,LeadSource FROM LEAD WHERE LeadSource='' LIMIT 200];
        List<Lead> newlst=new List<Lead>();
        for(Lead l:lst)
        {
            l.LeadSource='Dreamforce';
            newlst.add(l);
        }
        
        update newlst;
    }
    
    
}