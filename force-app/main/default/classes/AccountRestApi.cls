@RestResource(urlMapping='/AccountDateApi/')
global class AccountRestApi {
	
    @httpPost
    global static void fetchAccountApi(String filterDate){
		RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
		Map<String,Object> myMap = New Map<String,Object>();
        
        try{
        	System.debug('request body '+filterDate);        
            String[] splittedDate = filterDate.split('/');
            List<Account> accountList = fetchAccounts(Date.parse(splittedDate[2]+'/'+splittedDate[1]+'/'+splittedDate[0]));
            
            
            //Creating Account data in specified format
			List<Map<String,Object>> accountMapList = new List<Map<String,Object>>();
            
            if(accountList != null && accountList.size() >0){
                for(Account accRec : accountList){
                    Map<String,Object> accMap = new Map<String,Object>();
                    accMap.put('name', accRec.Name);
                    accMap.put('source', accRec.AccountSource);
                    accMap.put('createdOn', accRec.CreatedDate);
                    accMap.put('description', accRec.Description);
                    accMap.put('billingAddr', accRec.BillingAddress);
                    accMap.put('acctOwner', accRec.Owner.Name);
                    
                    accountMapList.add(accMap);
                    
                }
                
            }
            else{
                accountMapList = new List<Map<String,Object>>();
            }
            
            myMap.put('success', true);
            
            //We can put this in a label so that it can support translation
            myMap.put('msg', 'successfully retrieved');
            
            myMap.put('data', accountMapList);    
        }
        catch(TypeException ex){
            // Block for catching invalid date exception
            myMap.put('success', false);       	
        	myMap.put('msg', 'Error: invalid input');
            myMap.put('data', null);
        }
        catch(Exception ex){
            // Block for catching any other exception
            myMap.put('success', false);      
        	myMap.put('msg', 'Internal server error');
            myMap.put('data', null);
        }
        
        res.responseBody = Blob.valueOf(JSON.serialize(myMap));
                
    }
    
    private static LIst<Account> fetchAccounts(Date filterDate){
        return [SELECT Name , AccountSource,CreatedDate,Description,BillingAddress,Owner.Name FROM Account WHERE CreatedDate > :filterDate];
        
    }
}