@RestResource(urlmapping='/RemainderRequest/*')

global class RemainderRequestImpl{

    @httpGet(urlmapping = '/RemianderId/*')
    global static String fetchRemainder(){
        RestRequest request = RestContext.Request;
        RestResponse response = RestContext.Response;
        String remainderId;
        
        Map<String,object> responseMap = new Map<String,object>();
        
        remainderId = request.requestURI.substring(request.requestURI.lastIndexOf('/'));
        System.debug('con id '+remainderId);
        List<Contact> remaniderLIst = [SELECT LastName,Email FROM Contact WHERE Id =:remainderId.split('/')[1]];
        
        if(remaniderLIst != null && remaniderLIst.size()>0){
            responseMap.put('remainder',remaniderLIst[0]);
            responseMap.put('message','Remainder found');
        }
        else{
            responseMap.put('message','Error ! remainder not found');
        }
        
        return JSON.serialize(responseMap);
    }
}