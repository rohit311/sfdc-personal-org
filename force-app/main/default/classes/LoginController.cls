public class LoginController{
    
    public class ResponseData{

        @AuraEnabled
        public String Status;
        @AuraEnabled
        public String msg;
        @AuraEnabled
        public Contact contact;

    }

    
    @AuraEnabled
    public static String validateUser(Map<String,String> params){
        ResponseData respData = new ResponseData();
        
        System.debug('params '+params);
        
        if(UtilityClass.isNotEmpty(params.get('UserName')) && UtilityClass.isNotEmpty(params.get('pwd')) ){
        
            List<Contact> conList = [SELECT Id,Email,FirstName FROM Contact WHERE Email = :params.get('UserName') AND password__c = :params.get('pwd')];
            if(UtilityClass.isNotEmpty(conList)){
                
                respData.Status = 'Success';
                respData.msg = 'Logged in successfully !';  
                respData.contact = conList[0];                
            }
            else{
                respData.Status = 'Failure';
                respData.msg = 'User not found , Please register.';                 
            }
        }
        
        return JSON.serialize(respData);
    
    
    }
    
    @AuraEnabled
    public static String createNewUser(String conStr){
        ResponseData respData = new ResponseData();
        
        List<Contact> conList = (List<Contact>)JSON.deserialize(conStr,List<Contact>.class);
        
        if(UtilityClass.isNotEmpty(conList)){
        
            if(!checkDupl(conList[0])){
                if(UtilityClass.upsertData(conList)){
                
                    respData.Status = 'Success';
                    respData.msg = 'User Created Successfully !';  
                    respData.contact = conList[0];
                
                }
                else{
                    respData.Status = 'Failure';
                    respData.msg = 'Internal server error !';
                }
            }
            else{
                respData.Status = 'Duplicate';
                respData.msg = 'User already present !';
            
            }
        
        }
        
        return JSON.serialize(respData);
    }
    
    public static Boolean checkDupl(Contact con){
        List<Contact> conList = [SELECT Id,Email,FirstName FROM Contact WHERE Email = :con.Email];
        
        if(UtilityClass.isNotEmpty(conList)){
        
            return true;
        }
        
        return false;
    
    }

}