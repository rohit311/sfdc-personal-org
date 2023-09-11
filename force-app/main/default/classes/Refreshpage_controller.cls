public class Refreshpage_controller {
public Integer i{get;set;}
{
i=0;
}
public PageReference incr()
{
i=i+1;
return null;
}

}