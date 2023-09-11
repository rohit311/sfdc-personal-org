({
    doInit : function(component, event, helper){
        console.log('Demog change '+ component.get('v.DemogAction'));
       var fullAdd ='';
        if(!$A.util.isEmpty(component.get('v.LoanObj.CUSTOMER__r.Residence_demog__c'))){
            console.log('Enterrred');
            fullAdd=component.get('v.LoanObj.CUSTOMER__r.Residence_demog__c');
        var str= fullAdd.split(' ');
        var address1='';
        var address2='';
        var address3='';
        var add='';
        var i=0;
       
       
        while(i<str.length){   
            console.log('str[i].length '+str[i]+'  '+str[i].length );
            if(((add.length)+(str[i].length))<=35 ){
                address1=address1+" "+str[i]; 
                add=address1;
                
                
            }else if( ((add.length)+(str[i].length))>35  && ((add.length)+(str[i].length))<=70 ){
                address2=address2+" "+str[i];
                add=address1+" "+address2;
               
            }else{
                address3=address3+" "+str[i];
                add=address1+" "+address2+" "+address3;
                
            }  
            i++;
        }
        
        console.log(' Adress will hold 1 '+address1+' 2 '+ address2+' 3 '+address3);
        component.set("v.Address1",address1);
        component.set("v.Address2",address2);
        component.set("v.Address3",address3);
      }  
        console.log('Loan Application '+component.get('v.LoanObj').CUSTOMER__c);
         var LastModifiedDate=component.get('v.LoanObj.CUSTOMER__r.Last_Modified_Date_Demog__c');
        console.log('Last modified date '+LastModifiedDate);
         component.set('v.LastModifiedDate',LastModifiedDate);
    },
    DestroyChildCmp: function(component, event, helper) {
        // component.set("v.body",'');
        component.destroy();
    },
})