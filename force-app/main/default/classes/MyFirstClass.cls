public class MyFirstClass{
public String[] arr=new String[]{'January','February','March','April','May','June','July','August','September','October','November','December'};
public string str='';


public string getStr()
{
str='';
   for(string a:arr)
        str=str+' >'+a;

  return str;
}
}