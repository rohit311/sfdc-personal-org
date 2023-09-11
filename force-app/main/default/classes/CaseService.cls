public with sharing class CaseService {

    
    public static void closeCases(Set<Id> caseIds,String closeReason){
        if(caseIds == null || caseIds.size() == 0){
            throw new CaseServiceException();
        }
        else{
            List<Case> caseList = [SELECT Reason,Status FROM Case WHERE Id IN :caseIds];
            List<Case> casesToUpdate = new List<Case>();
            for(Case caseObj : caseList){
                caseObj.Status = 'Closed';
                caseObj.Reason = closeReason;                
            	casesToUpdate.add(caseObj);
            }
            
            SavePoint sp = Database.setSavePoint();
            
            try{
                if(casesToUpdate.size() > 0){
                    update casesToUpdate;
                }
            }catch(Exception e){
                Database.rollback(sp);
                
                throw e;
            }
        }
        
        
    }
    
    public class CaseServiceException extends Exception{}
}