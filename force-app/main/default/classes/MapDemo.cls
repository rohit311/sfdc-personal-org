public class MapDemo {

    
    public Map<String,String> dir{
        get{
            
            return new Map<String,String>{
                'Kieslowski' => 'Poland',
                'del Toro' => 'Mexico',
                'Gondry' => 'France'                 
            };
        }
        set;
        
        
    }
}