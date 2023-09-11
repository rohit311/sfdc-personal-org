public with sharing class FieldSetUtility {
    public FieldSetUtility() {

    }

    public static List<Schema.FieldSetMember> getFieldSetMembers(String objectName,String fieldSetName){

        DescribeSObjectResult[] describes = Schema.describeSObjects(new String[] {objectName});

        if (describes != null && describes.size() > 0) {
            // There should only be the one match for the one object type name
            Schema.FieldSet fs = describes[0].fieldSets.getMap().get(fieldSetName);

            return fs.fields;
        } else {
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccountList(Id accId){
        String query = 'SELECT ';

        List<Schema.FieldSetMember> fieldsList = new List<Schema.FieldSetMember>();

        fieldsList = getFieldSetMembers('Account','DemoFieldSet');

        if(fieldsList.size() > 0){
            for(Schema.FieldSetMember f : fieldsList) {
                query += f.getFieldPath() + ', ';
            }
            query += 'Id FROM Account WHERE ID=\''+accid+'\'';
            System.debug(query);
            return Database.query(query);    
        }
        else{
            return new Account();        
        }

                
    }
}