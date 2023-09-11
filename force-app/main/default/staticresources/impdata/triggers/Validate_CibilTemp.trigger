trigger Validate_CibilTemp on Cibil_Temp__c(before insert, before update)
{
  Set<Id> appid = new Set<Id>();
    for(Cibil_Temp__c ctmp : Trigger.new){
        appid.add(ctmp.Applicant__c);
    }
    System.debug('appid --> ' + appid);
    Map
        <Id,Applicant__c> mapofapplst = new Map
            <Id,Applicant__c>([Select id,Cibil_Temp__c,Contact_Name__r.Date_of_Birth__c,Contact_Name__r.Pin_Code__c,Contact_Name__r.AppCity__c,Contact_Name__r.State__c,Contact_Name__r.LastName,Contact_Name__r.FirstName,Contact_Customer_Type__c,Contact_Name__r.VoterID_Number__c,Contact_Name__r.PassPort_Number__c,Contact_Name__r.PAN_Number__c,Contact_Name__r.Address_1__c,Contact_Name__r.Address_2__c,Contact_Name__r.Address_3__c From Applicant__c where id IN :appid]);
    String invalidData=' ' ; //to add missing fields
     //code to handle bulkification
    for(Cibil_Temp__c ctmpvalidate : Trigger.new)
    {
        Applicant__c app;
        app = mapofapplst.get(ctmpvalidate.Applicant__c);
        //System.debug('ctmpvalidate.Applicant__c --> ' + ctmpvalidate.Applicant__c);
          //System.debug('app con --> ' + app.Contact_Name__r);
         if(app != null && app.Contact_Customer_Type__c == 'Individual' )//cibil is only allowed for Individual customer
        {
             if(app.Contact_Name__r.PAN_Number__c!=null || app.Contact_Name__r.VoterID_Number__c!=null || app.Contact_Name__r.PassPort_Number__c!=null){
             }
             else{
             if(app.Contact_Name__r.PAN_Number__c==null ){
            invalidData= invalidData +'PAN Number,';

            }
           else if(app.Contact_Name__r.VoterID_Number__c==null  ){
             invalidData = invalidData + 'Voter Id,'; 
             
             }
            else if(app.Contact_Name__r.PassPort_Number__c==null ){
            invalidData = invalidData + 'Passport Number,';
            
            }
           }
            if(app.Contact_Name__r.Address_1__c==null ){
            invalidData= invalidData +'Resi/Reg Address Line1,';
            }
            if(app.Contact_Name__r.Address_2__c==null ){
            invalidData= invalidData +'Resi/Reg Address Line2,';
            }
            if(app.Contact_Name__r.Address_3__c==null ){
            invalidData= invalidData +'Resi/Reg Address Line3,';
            }
            if(app.Contact_Name__r.FirstName==null ){
            invalidData= invalidData +'First Name,';
            }
            if(app.Contact_Name__r.LastName==null ){
            invalidData= invalidData +'Last Name,';
            }
            System.debug('state --> ' + app.Contact_Name__r.State__c);
            if(app.Contact_Name__r.State__c==null ){
            invalidData= invalidData +'State,';
            }
            if(app.Contact_Name__r.AppCity__c==null ){
            invalidData= invalidData +'Resi/Regi-Office City,';
            }
            if(app.Contact_Name__r.Date_of_Birth__c==null ){
            invalidData= invalidData +'Date of Birth,';
            }
            if(app.Contact_Name__r.Pin_Code__c==null ){
            invalidData= invalidData +'Office Pin Code,';
            }
           
         }//outer if ends
        
        if(invalidData!=' ')
        ctmpvalidate.adderror(invalidData + ' is mandatory in Applicant\'s contact!!!!!!!! ');
        
    }//for ends
}