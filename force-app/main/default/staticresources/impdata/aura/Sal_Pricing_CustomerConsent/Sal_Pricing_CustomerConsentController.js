({
    doInit: function(component, event, helper) {
        console.log('Loan Amt with pre'+component.get("v.loan.Loan_Amount_with_Premium__c"));
        var disObj= component.get('v.disbusmentList');
        component.set('v.disbusment',disObj[0]);
        var validExotelProd;
        component.set("v.displayExotel",false);
        helper.executeApex(component,'getvalidExotelProducts', {
            
        }, function (error, result) {
            
            console.log('result'+result);
            if (!error && result) {
                
                var data=JSON.parse(result);
              //alert(component.get("v.loan.Products__c"));
                component.set("v.validExotelProd",data);
                validExotelProd=component.get("v.validExotelProd");
                console.log('prodsvalid'+validExotelProd+component.get("v.loan.Product__c"));
                if(validExotelProd.includes(component.get("v.loan.Product__c")))
                    component.set("v.displayExotel",true);
                else
                    component.set("v.displayExotel",false);
                
                
            	helper.fetchCharges(component, event);
            }else{
                alert('no data');
            }
           
         }); 
        
    },
    makeacall : function(component,event,helper){
       helper.showhidespinner(component,event,true);
       helper.displayToastMessage(component,event,'Success','Calling....','success'); 
    // var appId = event.target.getAttribute('id');
        var ctarget = event.currentTarget;
    	var appId = ctarget.dataset.value;
        console.log(appId + ' ---- '+appId);
     // var oppID=component.get("v.OppID");
      //  alert(oppID);
        var fromNumber;
   
         helper.executeApex(component,'callToCustomer', {
             "frommobile" :  "none",
             "tomobile":component.get("v.account.Mobile__c")+'',
             "Id" : appId,
             "objName":"Applicant__c",
             "Product":component.get("v.appObj.Product__c").toUpperCase()
         }, function (error, result) {
             if (!error && result) {
                 console.log('Callback done '+JSON.stringify(result));
                 if(result !== 'Success'){
                     helper.displayToastMessage(component,event,'Error',result,'error');
                 }
                helper.showhidespinner(component,event,false);
                
             }else{
                 
                 helper.displayToastMessage(component,event,'Error',result,'error');
             }
              helper.showhidespinner(component,event,false);
         }); 
    },
    //22017 start
   
    updatelastemi : function(component, event, helper) {
       
        var today = new Date();  
        var ddnew = today.getDate();
        var dd = 2;
        var mm = today.getMonth() + 1; //January is 0!
        console.log('pk date 1'+mm);
        //console.log('today.getMonth()'+today.getMonth());
        /*if(ddnew <= 15)
            today.setMonth(today.getMonth()+2);
        else
            today.setMonth(today.getMonth()+3);*/
        if(ddnew <= 15)
            mm = mm + 1;
        else
            mm = mm + 2;
        //console.log('today.getMonth()'+today.getMonth());
        var yyyy = today.getFullYear();
        //mm = today.getMonth(); 
         
        console.log('pk date 2'+mm);
        yyyy = today.getFullYear();
        if(mm == 0){
            mm = first_mm+12;
            yyyy = first_yyyy-1;
        }
        if(dd < 10){
            dd = '0' + dd;
        } 
        if(mm < 10){
            mm = '0' + mm;
        }
        console.log('pk date 3'+mm);
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        console.log('ak::'+todayFormattedDate);
        component.set("v.EMI1stDate",todayFormattedDate);
        var approvedtenor  =0;
        if(!$A.util.isEmpty(component.get("v.loan")))
            approvedtenor  = component.get("v.loan").Approved_Tenor__c-1;
        console.log('pk approved tenor'+approvedtenor);
        var first_dd,first_mm,first_yyyy;
        if(!$A.util.isEmpty(approvedtenor) && !isNaN(approvedtenor)){
            var lastemidate = new Date(yyyy,mm,dd);
            lastemidate.setMonth(lastemidate.getMonth()+approvedtenor);
            first_mm = lastemidate.getMonth(); 
            first_yyyy = lastemidate.getFullYear();
            if(first_mm == 0){
                first_mm = first_mm+12;
                first_yyyy = first_yyyy-1;
            }
            first_dd = lastemidate.getDate(); 
            if(first_mm < 10){
                first_mm = '0' + first_mm;
            } 
            if(first_dd < 10){
                first_dd = '0' + first_dd;
            }
            todayFormattedDate = first_yyyy+'-'+first_mm+'-'+first_dd;
            component.set("v.EMILastDate",todayFormattedDate);
        }
        else
            component.set("v.EMILastDate",todayFormattedDate);
    },//22017 end
    
    saveCustomerCons: function(component, event, helper) {
        helper.showhidespinner(component,event,true); 
        //22624 s
        console.log('component.get("v.totalDisbAmount")'+component.get("v.totalDisbAmount")+'--'+component.find('disAmountId').get("v.value"));
        if(component.get("v.totalDisbAmount")!= component.find('disAmountId').get("v.value"))
        {
            helper.showhidespinner(component,event,false);
            helper.displayToastMessage(component,event,'Error','Enter Valid Disbursment Amount','error');   
        }        
        //22624 e
        //below if condition is for BUG 19961
        else if(!$A.util.isEmpty(component.find('disAmountId').get("v.value")) && !$A.util.isEmpty(component.find('emi1st').get("v.value")) && !$A.util.isEmpty(component.find('emiLastId').get("v.value")) && !$A.util.isEmpty(component.find('emiId').get("v.value"))  )
        {
            helper.saveCustomerConsentMethod1(component,event);
        }
            else
            {
                helper.showhidespinner(component,event,false);
                helper.displayToastMessage(component,event,'Error','Please enter mandatory fields','error');
            }
    },
    send_E_Aggrement:function(component, event, helper) {
        debugger;
        var first= component.find('emi1st').get("v.value"); 
        var last= component.find('emiLastId').get("v.value") ;
        var isvaliddate= helper.dateUpdate(component,event);//22017
        var repayList = component.get("v.repayList");//22017
        console.log('pk repay'+JSON.stringify(repayList));
        var list = []; 
        var isvalid = true;
        var isvalidEcs = true;
            //SAL 2.0 CR's removed emiId
            list = ["disAmountId","emi1st","emiLastId"];
        for (var i = 0; i < list.length; i++) {
            console.log('list[i]>>' + list[i]);
            console.log(component.find(list[i]));
            if (component.find(list[i]) && $A.util.isEmpty(component.find(list[i]).get("v.value")))
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        console.log('pk repay2');
        if(!isvalid)
        {
            helper.showhidespinner(component,event,false);       
            helper.displayToastMessage(component,event,'Error','Please fill all mandatory details','error');  
        }
        console.log('pk repay3');
        if(!isvaliddate){
            helper.showhidespinner(component,event,false);  
            helper.displayToastMessage(component,event,'Error','Please Enter valid dates','error');
        }
    
        if(isvaliddate && component.get("v.EMILastDate") != '' && !$A.util.isEmpty(repayList)){ 
            for(var i=0;i<repayList.length;i++)
            {
                if(new Date(repayList[i].ECS_End_Date__c) < new Date(component.get("v.EMILastDate")) || repayList[i].Open_ECS_Max_Limit__c < component.get("v.EMI"))
                {
                    isvalidEcs =false;
                  helper.displayToastMessage(component,event,'Error','Existing ECS Details is exhausted. Please collect fresh mandate/e-mandate.','error');
                }
            }
            helper.showhidespinner(component,event,false);  
        }
        
         
        
        if(isvaliddate && isvalid && isvalidEcs){
            console.log('herer');
            helper.showhidespinner(component,event,true); 
            helper.sendEaggrementHelper(component,event);
        }
        
        
        
    },
    dateUpdate : function(component, event, helper) {
        return helper.dateUpdate(component,event);
    },
    /*SAL 2.0 CR's s*/
    redirectToReport : function (component, event, helper) {
        console.log('in set modal');
        component.set("v.headerVal",'Application Form');
    	component.set("v.isViewReportModalOpen", true);
    },
    redirectAggToReport : function (component, event, helper) {
        console.log('in set modal');
        component.set("v.headerVal",'Agreement');
    	component.set("v.isViewReportModalOpen", true);
    },
    /*SAL 2.0 CR's e*/

})