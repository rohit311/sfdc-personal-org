@RestResource(urlmapping='/RemainderService/*')
global class RemainderServiceImpl {
    
    @httpGet
    global static String createRemainders(){
        RestRequest request = RestContext.Request;
        RestResponse response = RestContext.Response;
        String remainderDateString;
        try{
        
            remainderDateString = request.requestURI.substring(request.requestURI.lastIndexOf('/'));
            //DateTime remainderDate = DAteTime.valueof(remainderDateString);
            String remainderid = '';
            //RemainederHelper.insertRemainder(remainderDate);
             Contact con = new Contact(LastName = 'HelpShift',Description = remainderDateString);
            upsert con;

            return con.id;
        }catch(Exception ex){
                       return 'Internal Server Error';
        }   
        
    }
    
}