public class conVsGood
{
    Contact c;
    
   public Contact getContactMethod1()
   {
     if(c==null)
     {
          c=[SELECT Name,id FROM CONTACT LIMIT 1];
          
     }
     return c;
    
   }
   
   public Contact getContactMethod2()
   {
       
   return getContactMethod1();
   }

}