public class GenericTableCtrl {
    
    public class GenericWrapper{
        @AuraEnabled
        public List<String> objList = new List<String>();
        @AuraEnabled
        public List<SObject> recordsList = new List<SObject>();
        @AuraEnabled
        public List<String> fieldAPIList = new List<String>();
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String Error;
    }
    
    
    @AuraEnabled
    public static String  initialize(){
        GenericTableCtrl genTb = new GenericTableCtrl();
        GenericTableCtrl.GenericWrapper wrp = new GenericTableCtrl.GenericWrapper();
        wrp.objList = genTb.fetchAllObjects();
        
        String response = JSON.serialize(wrp);
        return response;
        
    }
    
    @AuraEnabled 
    public static String fetchFieldNames(String objName){
        
        GenericTableCtrl.GenericWrapper wrp = new GenericTableCtrl.GenericWrapper();
        try{
            
            Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get(objName);
            List<String> fieldNamesList = new List<String>();
            
            if(ObjectSchema != null){
                
                Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
                
                for(String fieldName: fieldMap.keySet()){
                    fieldNamesList.add(fieldName);
                }
                
                wrp.fieldAPIList = fieldNamesList;
                wrp.status = 'Success';
                wrp.Error = '';
            }
            else{
                wrp.status = 'Falied';
            }
        }
        catch(Exception e){
            wrp.Error = 'Error occured : '+e.getMessage();
        }
        return JSON.serialize(wrp);
    }
    
    @AuraEnabled
    public static String queryData(String query){
        GenericTableCtrl.GenericWrapper wrp = new GenericTableCtrl.GenericWrapper();
        
        try{
            List<sObject> sobjList = Database.query(query);
            wrp.recordsList = sobjList;
            wrp.status = 'Success';
        }catch(Exception ex){
            wrp.status = 'Failed';
            wrp.Error = 'Error occurred '+ex.getMessage();
        }
        return JSON.serialize(wrp);
    }
    
    public List<String> fetchAllObjects(){
        List<String> objList = new List<String>();
        for(Schema.SObjectType obj : Schema.getGlobalDescribe().Values()){
            objList.add(obj.getDescribe().getName());
        }
        
        return objList;
    }
    
}