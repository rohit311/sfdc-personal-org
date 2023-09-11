public class ParkLocator{

   public static String[] country(String con){
       ParkService.ParksImplPort parkSer = new ParkService.ParksImplPort();
       
      return parkSer.byCountry(con);
   }

}