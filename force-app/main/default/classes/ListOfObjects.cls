public class ListOfObjects {

    public static void List_obj()
    {
		List<String> SObjectList=new List<String>();
        
        for(Schema.SObjectType objType:Schema.getGlobalDescribe().Values()){
            String name=objType.getDescribe().getKeyPrefix();
            
            SObjectList.add(name);
            System.debug(name);
        }
        //System.debug(SObjectList);
       
    }
    
}