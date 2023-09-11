public class MyTimeController {

    public Datetime myDateTime { 
        get {
            if (myDateTime == null) {
                myDateTime =  (Datetime.now()+0.229166533);
                            }
            return myDateTime;
        } 
        set;
    }
    
/*    
1 day/24h = 0.0416666666 (value of 1 hour)
0.041666666(value of 1 hour) x 4 (how many hours difference my timezone to GMT) = 0.166666664
 
then I used (NOW () - 0.166666664) and that gave me current time
*/
    
      public Time myTime { 
        get {
            if (myTime == null) {
                myTime =  DateTime.now().time();
            }
            return myTime;
        } 
        set;
}


}