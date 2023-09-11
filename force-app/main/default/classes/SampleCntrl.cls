public class SampleCntrl {
public String curency {get;set;}
    public String amount {get;set;}
    public Boolean curencyBool {get;set;}
    
    public SampleCntrl()
    {        
        curency = 'none';
        if(curency == 'none')
        {
         curencyBool = true;
        }    
    }
    
    public void changeBool()
    {        
        if(curency != 'none')
        {
            curencyBool = false;
        }
        else
        {
            curencyBool = true; 
        } 
    }
       
}