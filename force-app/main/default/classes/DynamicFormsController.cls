public inherited sharing class DynamicFormsController {
    public DynamicFormsController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<String> fetchFieldsFromFieldSet(String objectName,String fieldSetName){
        List<String> fieldApiNames = new List<String>();
        
        try {
            List<Schema.FieldSetMember> fieldSetMembersList = getFieldSetMembers(objectName,fieldSetName);    
            
            if(fieldSetMembersList != null && fieldSetMembersList.size() > 0){
                for(Schema.FieldSetMember fsMember : fieldSetMembersList){
                    fieldApiNames.add(fsMember.getFieldPath());
                }
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return fieldApiNames;
    }

    private static List<Schema.FieldSetMember> getFieldSetMembers(String objectName,String fieldSetName){
        DescribeSObjectResult[] describes = Schema.describeSObjects(new String[] {objectName});

        if (describes != null && describes.size() > 0) {
            // There should only be the one match for the one object type name
            Schema.FieldSet fs = describes[0].fieldSets.getMap().get(fieldSetName);
    
            return fs.fields;
        } else {
            return null;
        }
    }
}