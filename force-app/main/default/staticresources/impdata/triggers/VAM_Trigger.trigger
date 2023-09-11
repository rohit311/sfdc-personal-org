/******************************************************************
* Description   : This trigger is used to ensure that there will be 
*          no collision for "Default" agency feature. 
* Purpose     :  To validate "Default" agency checkbox.       
* Author    :   Persistent Systems Limited
*******************************************************************/
trigger VAM_Trigger on Verification_Agency_Master__c (before insert, before update) 
{
    //List<Verification_Agency_Master__c > temp = new List<Verification_Agency_Master__c > ();
    for(Verification_Agency_Master__c objVAM : trigger.new)
    {
    
       Boolean flag = false;
       
       if(trigger.isInsert== true){
           flag = true;
       }
       else if(objVAM.id != NULL ){
           if(trigger.oldMap.get(objVAM.id) != NULL && trigger.oldMap.get(objVAM.id).isDefault__c != true){
           flag = true;}
       }
       
      //check if it is going to "true" from "false"
      if(objVam.isDefault__c == true && flag == true)
      {
         String[] products  = objVam.Product__c.split(';');
         String[] locations   = objVam.Location__c.split(';');
         String[] types    = objVam.Verification_Types__c.split(';');
         Integer lastIndex   = 0;
         
         String query = 'SELECT id, isDefault__c from Verification_Agency_Master__c where isDefault__c = true and ';
         System.debug('Query 1 :' + query);
         
         //******** adding product to Query *******
         query += 'Product__c includes (';
         for(String strProduct : products)
         {
           query += '\'' + strProduct + '\',';
         }
         //removing last comma character in query
         lastIndex = query.lastIndexOf(',');
         query = query.subString(0, lastIndex);
         System.debug('Query 2 :' + query);
         
           /****** adding locations to Query *******
         // Stopped using,as location picklist is Single, not multi
         query += ') and Location__c includes (';
         for(String strLocation : locations)
         {
           query += '\'' + strLocation + '\',';
         }
         //removing last comma character in query
         lastIndex = query.lastIndexOf(',');
         query = query.subString(0, lastIndex);
         ******************************************/
         
         //******* adding locations to Query *******
         query += ') and Verification_Types__c includes (';
         for(String strType : types)
         {
           query += '\'' + strType + '\',';
         }
         //removing last comma character in query
         lastIndex = query.lastIndexOf(',');
         query = query.subString(0, lastIndex);
         
         //**** Completing the query ***
         query += ')';
         
         //temp while location get multipicklist 
         query += ' and Location__c =\''+ objVam.Location__c + '\'';
         
         System.debug('Query : ' + query );
         
         List<Verification_Agency_Master__c>  fetchedVAM = Database.query(query);
         //if we get rows more than 0, ie even if a single record is present,  
         //we need to stop processing
         if(fetchedVAM != NULL && fetchedVAM.size() > 0)
         {
           objVAM.addError('You can not make default to this agency, as there is another agency marked '
                   +'as Default for same Location-Product-Verification_Types. ');
         }
         
      } 
    }
}