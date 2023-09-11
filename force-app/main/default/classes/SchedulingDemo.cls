global class SchedulingDemo implements Schedulable{

    public static Integer x=0;
    global void execute(SchedulableContext sc){
        Account acc=[SELECT Phone,Name,NumberOfEmployees FROM Account WHERE id='0012800000jB2JU'];
        
        if(x==0)
        {
        acc.NumberOfEmployees=12;
            x=1;
        }
        else
        {
            acc.NumberOfEmployees=24;
            x=0;
        }
        update acc;
    }
}