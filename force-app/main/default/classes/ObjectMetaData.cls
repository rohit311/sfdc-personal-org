public class ObjectMetaData {

    public static void describeObject(String objName)
    {
        Map<String,Schema.SObjectType> gd=Schema.getGlobalDescribe();
        
        Schema.SObjectType objType=gd.get(objName);
        
        System.debug('Account '+objType);
        
        Schema.DescribeSObjectResult dsr=objType.getDescribe();
        
        System.debug('DSR ' + dsr);
        
        System.debug('CRUD  '+dsr.isCreateable());
        
        //Map<String,Schema.SObjectField> fieldMap= Schema.SObjectType.Account.Fields.getMap();
        
        Map<String,Schema.SObjectField> fieldMap= dsr.Fields.getMap();

        
        System.debug('Field map '+fieldMap);
        
        System.debug('Name field ' + fieldMap.get('Name').getDescribe().isUpdateable());
    }
}