public class PackageXmlCntrl{


    @AuraEnabled
    public static Map<String,Object> fetchMetadata(String dataType){
        
        Map<String,Object> metaDataMap = new Map<String,Object>();
        if(dataType == 'Apex Class')
            metaDataMap.put('Apex Class',[SELECT Name FROM ApexClass]);
        else if(dataType == 'Profile')
            metaDataMap.put('Profile',[SELECT Name FROM Profile]);
        else if(dataType == 'Object'){
            List<String> SObjectList = new List<String>();

            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
               String name = objTyp.getDescribe().getName();
               // Exclude all the unwanted Sobjects e.g. History, Share etc..
            
             if(!name.toLowerCase().endsWith('history') && !name.toLowerCase().endsWith('tag')&&
                !name.toLowerCase().endsWith('share') && !name.toLowerCase().endsWith('feed')){      
                  SobjectList.add(name);
                  System.debug( 'Name : ' + name);
              }
            
            }
            
            metaDataMap.put('Object',[SELECT  QualifiedApiName FROM EntityDefinition order by QualifiedApiName]);
        }    
        
        return metaDataMap;
    }

}