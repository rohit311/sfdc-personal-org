public class BinaryZeros {

    public static Integer getMaximumZeros(Integer num){
        String binaryData = '';
        Integer zeroCount = 0;
        Integer oneCount = 0;
        
        while(num != 0){
            
            binaryData = binaryData + Math.mod(num, 2);
            num = num /2 ;
        }
        System.debug('binary '+binaryData);        
        String[] splitedArray = binaryData.split('1');       
        if(splitedArray.size() >2){
            zeroCount = splitedArray[0].length();
            for(Integer i=1;i<splitedArray.size();i++){
                if(splitedArray[i].trim().length() > zeroCount){
                    zeroCount = splitedArray[i].trim().length();
                }           
            }
            System.debug('zeroCount '+zeroCount);
            return zeroCount;
        }
        else{
            System.debug('in else '+zeroCount);
			return null;            
        }
               
    }
    
}