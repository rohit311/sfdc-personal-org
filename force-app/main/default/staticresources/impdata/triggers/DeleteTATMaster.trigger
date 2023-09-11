//trigger added for 22042
trigger DeleteTATMaster on CIBIL_secondary_match__c (after update) 
{
Boolean ischanged = false;  
List<TAT_Master__c> TATmstristtodelete = new List<TAT_Master__c>();  
    for(CIBIL_secondary_match__c newrec : Trigger.new){
        for(CIBIL_secondary_match__c oldrec : Trigger.old){
            if(newrec.id == oldrec.id){
CIBIL_secondary_match__c NewSecCibil = newrec; 
CIBIL_secondary_match__c OldSecCibil = oldrec; 
CIBIL_secondary_match__c SecCibilObject = new CIBIL_secondary_match__c(); 

// This takes all available fields from the required object.
 Schema.SObjectType objType = CIBIL_secondary_match__c.getSObjectType(); 
 Map<String, Schema.SObjectField> M = Schema.SObjectType.CIBIL_secondary_match__c.fields.getMap();
 for (String str : M.keyset()) 
 { try 
 { 
 System.debug('Field name: '+str +'. New value: ' + NewSecCibil.get(str) +'. Old value: '+OldSecCibil.get(str)); 
 if(NewSecCibil.get(str) != OldSecCibil.get(str))
 { system.debug('******The value has changed!!!! ');
 ischanged = true;
  }
 } catch (Exception e) 
 { System.debug('Error: ' + e); } 
 }
      
    
 if(ischanged == true){

List<TAT_Master__c> TATmstrist =[Select id,PAN_Source__c from TAT_Master__c where PAN_Number__c =: oldrec.PAN_Number__c];

For(TAT_Master__c tatm : TATmstrist ){
    if(tatm.PAN_Source__c=='Secondary Cibil'){
        TATmstristtodelete.add(tatm);
    }
    }
    }
 
       }//outer if ends
    }//trigger.old for ends
    }//trigger.new for ends
    if(TATmstristtodelete!=null&& TATmstristtodelete.size()>0)
     delete TATmstristtodelete;
 }