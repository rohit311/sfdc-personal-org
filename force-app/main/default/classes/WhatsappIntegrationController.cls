public class WhatsappIntegrationController {

    
    @AuraEnabled
    public static Boolean sendMessageToWhatsApp(String caseId){
        Case caseRecord = [SELECT ContactMobile FROM Case WHERE Id =:caseId];
        
        if(caseRecord != null) {
            String recipientNumber = '91'+caseRecord.ContactMobile;
            
            Http httpRec = new Http();
            HttpRequest httpReq = new HttpRequest();
            String whatsAppPhoneId = '109063111941688';
            String endPoint = 'https://graph.facebook.com/v14.0/'+whatsAppPhoneId+'/messages';
            
            httpReq.setEndpoint(endPoint);
            //httpReq.setHeader('Content-type', 'application/json');
            httpReq.setMethod('POST');
            
            String messageBody = '{"messaging_product": "whatsapp","recipient_type": "individual","to": "'+recipientNumber+'", "type":"template","template": {"name": "sf_welcome_message","language":{"code":"en"}}}';
            
            httpReq.setBody(messageBody);
            
            String apiToken = 'EAAQLManPO14BAPGUMmlGXQ7rzgpkzqVSuQbTg3riTZAyHNMLb418g7yxqcOO0hStfe3u27lwzPBDwehIZB4JurGQofhQhAfFmewUUeAsqbz46ohcJFTYR7WsroUeZC0Jy8KFxlzRohoRJWbzpnVhkcyOX64SXiEGhfIIXYJIvZChTktNFXvnGRRrpYsmODzPRybhoW3qPZBn8URIp9RZAlFGZBlPTDldEcZD';
            
            
            httpReq.setHeader('Authorization','Bearer '+apiToken);
            
            httpResponse response = httpRec.send(httpReq);
            System.debug('request '+JSON.serializePretty(httpReq.getBody()));
            System.debug('response : '+response.getBody());
            
            if(response.getStatusCode() == 200){
                return true;
            }
            
        }
        
        return false;
    }
}