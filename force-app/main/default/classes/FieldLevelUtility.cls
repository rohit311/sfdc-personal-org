public class FieldLevelUtility{

  public Blob csvFileBody{get;set;}
  public String objectName{get;set;}
  public String csvDataString{get;set;}
  public List<String> fieldApiNames = new List<String>();
  
  public FieldLevelUtility(){
  
  }
  
  public void readCsvData(){
  
     if(csvFileBody != null){
         csvDataString = csvFileBody.toString();
         //populateFieldNames();
         updateFieldAccess();      
     }
  }
  
  public List<ProfileAccessWrapper> populateFieldNames(){
       fieldApiNames.clear();
       List<String> profileNames = new List<String>();
       List<ProfileAccessWrapper> profileWrapperList = new List<ProfileAccessWrapper>();
       Map<String,String> profileNameToAccess = new Map<String,String>();
       //profileNames.add('Account Reviewer');
       //profileNames.add('Standard');
       if(csvDataString != null){
           String[] dataLines = csvDataString.split('\n');
           if(dataLines != null && dataLines.size()>1){
               String[] header = dataLines[0].split(',');
               
               for(Integer k = 4;k<header.size();k++){
                   profileNames.add(header[k]);
               }
               String fieldName = ''; 
               for (Integer i = 1;i<dataLines.size();i++){
                   String[] csvRecordData = dataLines[i].split(',');
                   System.debug('csv row '+dataLines[i]+' ');
                   objectName = csvRecordData[0];
                   fieldName = csvRecordData[2];
                   profileNameToAccess = new Map<String,String>();
                   for(Integer j = 4;j<csvRecordData.size();j++){
                       profileNameToAccess.put(profileNames[j-4],csvRecordData[j]);
                   }
                   profileWrapperList.add(new ProfileAccessWrapper(fieldName,profileNameToAccess));
               } 
               System.debug('rohit '+profileNameToAccess); 
           }
       }
       return profileWrapperList;
  }
  
  
  public String updateFieldAccess(){
     List<ProfileAccessWrapper> profileWrapperList = populateFieldNames();
     MetadataService.MetadataPort service = new MetadataService.MetadataPort();
     service.SessionHeader = new MetadataService.SessionHeader_element();
     service.SessionHeader.sessionId = UserInfo.getSessionId();
     
     if(profileWrapperList != null && profileWrapperList.size()>0){
         MetadataService.Profile[] metaProfileList = new List<MetadataService.Profile>();
         System.debug('rohit ' + profileWrapperList);
         for(ProfileAccessWrapper prof : profileWrapperList){
             
          for(String profileName : prof.profileNameToAccess.keySet()){
               MetadataService.Profile mObj= new MetadataService.Profile();
               mObj.fullName = profileName;
               mObj.custom = false;
               
               MetadataService.ProfileFieldLevelSecurity fieldSec = new MetadataService.ProfileFieldLevelSecurity();
               fieldSec.field=objectName+'.'+prof.fieldName;
               String accessCode = prof.profileNameToAccess.get(profileName);
               System.debug('access code '+fieldSec.field);
               if(accessCode != null && accessCode.trim() == 'R'){  
                   fieldSec.editable=false;
                   fieldSec.readable=true; 
               }
               else if(accessCode.trim() == 'RE'){
                   System.debug('in re');
                   fieldSec.editable=true;
                   fieldSec.readable=true;
               }
               else if(accessCode.trim() == 'NA'){
               
                   fieldSec.editable=false;
                   fieldSec.readable=false;
               }
               
               
               mObj.fieldPermissions  = new MetadataService.ProfileFieldLevelSecurity[] {fieldSec} ;
                List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { mobj});
               metaProfileList.add(mObj);
               System.debug('here '+results);
          }
         }  
         
         if(metaProfileList.size()>0){
            // List<MetadataService.SaveResult> results = service.updateMetadata(metaProfileList);
             //System.debug('rohit '+results);
         }
          
     }
     
     
     return ''; 
  }
  
  public class ProfileAccessWrapper{
    public String fieldName{get;set;}
    public Map<String,String> profileNameToAccess{get;set;}
    
    public ProfileAccessWrapper(String fieldName,Map<String,String> profileNameToAccess){
        this.fieldName = fieldName;
        this.profileNameToAccess = profileNameToAccess;
    }
     
  }
  
}