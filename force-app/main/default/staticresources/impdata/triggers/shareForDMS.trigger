trigger shareForDMS on ContentVersion (after insert) {
    System.debug('In after insert ContentVersion');
     Map<String,Object> allMap= (Map<String,Object>) CommonUtility.getMapFromStaticResource('SalariedCustomSettings','DMSUploadDetails');
     list<String> users=  String.valueOf(allMap.get('DMSUsers')).split(';');
     List<User> lstUser=new List<User>();
    if(!CommonUtility.isEmpty(users))
      lstUser =[select id,name from user where id in :users];//0050k000001RUL5 pratiksha user id removed
    set<ID> userAccess=new set<ID>();
    System.debug('User list '+lstUser);
    List<ContentDocumentLink> lstCDLUpdate=new list<ContentDocumentLink>();
    for(ContentVersion objCDL: trigger.new){
        for(User objUsr: lstUser){ 
             System.debug('User to add '+objUsr.Id+' objCDL.createdBy.Id '+objCDL.OwnerId+'  ==> '+objCDL.OwnerId);
            if(objUsr.Id != objCDL.OwnerId && objCDL.Consent_For_Upload__c=='Y'){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId= objCDL.ContentDocumentId ;                       
                cdl.LinkedEntityId = objUsr.Id; 
                cdl.ShareType = 'C' ;
                cdl.Visibility = 'AllUsers' ;
                lstCDLUpdate.add(cdl);
            }
        }   
    }
    if(lstCDLUpdate.size()>0)
        insert lstCDLUpdate;
      System.debug('inserted doc link  '+lstCDLUpdate);  
    
}