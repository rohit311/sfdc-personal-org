public class LighteningUtilities{

    @AuraEnabled
    public static Map<String, Map<String, List<String>>> getPicklistValues(String objectFieldJSON){
        Map<String, Map<String, List<String>>> picklistValueMap = new Map<String, Map<String, List<String>>>();
        Map<String, Object> picklistNameMap = (Map<String, Object>)JSON.deserializeUntyped(objectFieldJSON);
        System.debug('picklistNameMap : '+objectFieldJSON);
        if(picklistNameMap.size() > 0){
            for(String objectKey : picklistNameMap.keySet()){
                List<Object> picklistNameSet = (List<Object>)picklistNameMap.get(objectKey);
                if(picklistNameSet != null && picklistNameSet.size() > 0){
                    for(Object fieldname : picklistNameSet){
                        List<String> picklistValueList = SFDCMobilePOUtility.getPicklistValues(objectKey, (String)fieldname);
                        System.debug('fieldname : '+ picklistValueList);
                        if(picklistValueMap.containsKey(objectKey)){
                            System.debug('got Key');
                            ((Map<String, List<String>>)picklistValueMap.get(objectKey)).put((String)fieldname , picklistValueList);
                        }else{
                            System.debug('No Key Found');
                            Map<String, List<String>> picklistFieldMap = new Map<String, List<String>>();
                            picklistFieldMap.put((String)fieldname, picklistValueList);
                            picklistValueMap.put(objectKey, picklistFieldMap);
                        }
                        System.debug('picklistValueMap : '+picklistValueMap);
                    }
                }
            }
        }
        return picklistValueMap;
    }  
    
    @AuraEnabled
    public static List<SObject> getAllDocuments(String parentId){
        system.debug('parentId++'+parentId);
        List<SObject> allDocList = new List<SObject>();
        List<Attachment> attachmentList = getAllAttachments(parentId);
        if(!CommonUtility.isEmpty(attachmentList)){
            allDocList.addAll((List<SObject>) attachmentList);
        }
        
        List<ContentVersion> cvLst = getAllContentDocs(parentId);
        if(!CommonUtility.isEmpty(cvLst)){
            allDocList.addAll((List<SObject>) cvLst);
        }
        allDocList.sort();
        List<SObject> sortedDocList = new List<SObject>();
        for(Integer i = allDocList.size()-1; i>=0;i--)
        {
            sortedDocList.add(allDocList.get(i));
        }
        return sortedDocList;
    }
    
    @AuraEnabled
    public static void removeAttachment(Id docId){
        if(!CommonUtility.isEmpty(docId)){
            System.debug('docId : '+ docId);
            List<Attachment> attList = [SELECT ID FROM Attachment WHERE ID =: docId LIMIT 1]; 
            if(!CommonUtility.isEmpty(attList))    delete attList;
            
            List<ContentDocument> conDocList = [SELECT ID FROM ContentDocument WHERE ID =: docId LIMIT 1]; 
            if(!CommonUtility.isEmpty(conDocList))    delete conDocList;
        }
    }    
    
    @AuraEnabled
    public static List<ContentVersion> getAllContentDocs(String parentId){
        List<ContentVersion> cvLst = new List<ContentVersion>();
        if(!CommonUtility.isEmpty(parentId)){
            List<Id> cdLst = new List<Id>();
            for(ContentDocumentLink cdLnk : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :parentId])
                cdLst.add(cdLnk.ContentDocumentId);
            cvLst = [SELECT /*SAL 2.0 CR's*/OwnerId,id,ContentDocumentId, Title, CreatedDate FROM ContentVersion WHERE ContentDocumentId IN :(cdLst) LIMIT 25];
        }
        system.debug('cvLst-->'+cvLst);
        return cvLst;   
    }
    
    @AuraEnabled
    public static List<Attachment> getAllAttachments(String parentId){
        List<Attachment> attachmentList;
        if(!CommonUtility.isEmpty(parentId)){
            attachmentList = [SELECT Id, Name, ParentId, ContentType, CreatedDate FROM Attachment WHERE ParentId =: parentId ORDER BY CreatedDate DESC];
        }
        return attachmentList;  
    }
     /*Sal Mobility 17138 s*/
    @AuraEnabled
    public static Boolean removeAttachmentMob(Id docId,String fileName,Id parentId){
        if(!CommonUtility.isEmpty(docId)){
            System.debug('docId : '+ docId +parentId+fileName);
            List<Attachment> attList = [SELECT ID FROM Attachment WHERE parentId =: parentId AND name LIKE :('%' + fileName + '%')]; 
            if(!CommonUtility.isEmpty(attList))    delete attList;
            List<ContentDocumentLink> conDocList = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
            ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
            FROM ContentDocumentLink 
            WHERE LinkedEntityId =: parentId AND ContentDocument.Title LIKE :('%' + fileName + '%')];
            if(!CommonUtility.isEmpty(conDocList))    delete conDocList;
            fileName = fileName.substring(0, fileName.indexOf('|'));
            List<Attachment> attList1 = [SELECT ID FROM Attachment WHERE parentId =: parentId AND name LIKE :('%' + fileName + '%')]; 
            List<ContentDocumentLink> conDocList1 = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
            ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
            FROM ContentDocumentLink 
            WHERE LinkedEntityId =: parentId AND ContentDocument.Title LIKE :('%' + fileName + '%')];
            if(attList1.size() > 0 || conDocList1.size() > 0)
                return false;
            else
                return true;
        }
        return false;
    }    
    /*Sal Mobility 17138 e*/
  }