public class day3_a3_controller
{
    public Integer q{get;set;}
    public Integer p{get;set;}
    public Integer res{get;set;}
    
    
    public PageReference calculate()
    {
       this.res=(this.q)*(this.p);
       return null;
    }
     
     
     

}