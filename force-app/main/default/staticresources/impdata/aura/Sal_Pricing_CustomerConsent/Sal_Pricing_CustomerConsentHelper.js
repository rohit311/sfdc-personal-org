({
    sendEaggrementHelper:function(component,event){
       
        this.showhidespinner(component,event,true);
        var bpival,stampdutyval;
         debugger;
        if(!$A.util.isEmpty(component.get('v.BPI')))
            bpival = component.get('v.BPI').toString();
        else
            bpival=component.get('v.BPI'); 
        if(!$A.util.isEmpty(component.get('v.StampDuty')))
            stampdutyval = component.get('v.StampDuty').toString();
        else
            stampdutyval=component.get('v.StampDuty');
        
        var disbList = component.get("v.disbusmentList");
        console.log('hee '+component.get('v.EMI')+' '+stampdutyval);
        var emiVal = '';
        if(!$A.util.isEmpty(component.get('v.EMI')))
            emiVal = component.get('v.EMI').toString();
        this.executeApex(component, 'sendMailEAggrement', {
            "oppId":component.get('v.loanid'),
            "bpi":bpival,
            "stampDuty":stampdutyval,
            "firstEMI":component.get('v.EMI1stDate'),
            "disbursmentObj":JSON.stringify(disbList[0]), //sends String
            "lastEMI":component.get('v.EMILastDate'),
            "EMI":emiVal
        },   
                         function (error, result) {
                             
                             if (!error && result) {
                                  // user story 978 s
                                 var updateidentifier =  $A.get("e.c:Update_identifier");
                                 updateidentifier.setParams({
                                "eventName": 'Pricing Customer Consent',
                                "oppId":component.get("v.loan").Id
                                  });
                               updateidentifier.fire();
                             // user story 978 e
                                 this.displayToastMessage(component,event,'Success','Email sent to Customer successfully','success');
                             }
                             else{
                                 this.displayToastMessage(component,event,'Error','Failed to send mail to Customer','error');
                             }
                             
                             this.showhidespinner(component,event,false);   
                         }); 
    },
    //priyanka added for Upfront and touch free charges -start
    fetchCharges: function(component,event) {
        console.log('inside fetch charges');
        
        this.executeApex(component, 'getCharges', {"oppId":component.get('v.loanid')},   
                         function (error, result) {
                             if (!error && result) 
                             {
                                 for(var key in result){
                                     console.log('key: '+key);                   
                                     if(key=='Upfront charge'){
                                         component.set('v.upfrontCharge',result[key]); 
                                     }
                                     if(key=='Touch free fees'){
                                         component.set('v.touchFreeCharge',result[key]);
                                     }
                                     console.log('pk charges');
                                     if(key=='BPI fees'){
                                         component.set('v.BPICharge',result[key]);
                                         console.log('pk charges');
                                         console.log(result[key]);
                                         component.set("v.BPI",result[key].Change_Amount__c);
                                     }
                                     if(key=='NetDisbAmt'){
                                         component.set("v.netdisbamt",result[key]);
                                           //25097 start
                                         /*if(component.get('v.netdisbamt') < 500000){
                                             	component.set("v.isMITC",true);
                                         }*/
                                          //25097 stop
                                         console.log('NetDisbAmt pk'+result[key]);
                                         
                                     }
                                     //25097 start
                                      console.log('Loan Amt with pre helper'+component.get("v.loan.Loan_Amount_with_Premium__c"));
                                     if(component.get("v.loan.Loan_Amount_with_Premium__c")<= 500000)
                                         	component.set("v.isMITC",true);
                                     //25097 stop
                                     /*22624 s*/
                                     if(key=='totalDisbAmount'){
                                         component.set("v.totalDisbAmount",result[key]);
                                         console.log('sss222'+result[key]);
                                         
                                     }
                                     /*22624 e*/
                                 }
                                 
                             }
                             else{
                                 component.set('v.touchFreeCharge','');
                                 component.set('v.upfrontCharge','');
                                 component.set('v.BPICharge','');
                             }
                             
                             
                         });
        
    },
    //priyanka added for Upfront and touch free charges -end
    saveCustomerConsentMethod1: function(component,event) {
        var first= component.find('emi1st').get("v.value"); 
        var last= component.find('emiLastId').get("v.value") ;
        var isvaliddate= this.dateUpdate(component,event);
        
        if(isvaliddate)
        {
            this.executeApex(component, 'saveCustomerConsent', {
                "oppId":component.get('v.loanid'),
                "bpi":component.get('v.BPI'),
                "stampDuty":component.get('v.StampDuty'),
                "firstEMI":component.get('v.EMI1stDate'),
                "disbursmentObj":JSON.stringify(component.get("v.disbusment")), //sends String
                "lastEMI":component.get('v.EMILastDate'),
                "EMI":component.get('v.EMI'),
                "upfrontCharge":component.get('v.upfrontCharge.Change_Amount__c'),
                "touchFreeFees":component.get('v.touchFreeCharge.Change_Amount__c')
            },   
                             function (error, result) {
                                 console.log('result==='+result);
                                 if (!error && result) {
                                     // alert('success saving customer Consent');
                                     //   var data = JSON.parse(result);
                                     //component.set("v.cam", data.camObj); 
                                     //  component.set("v.applicant",data.currApp);
                                     this.displayToastMessage(component,event,'Success','Customer Consent Details saved successfully','success');
                                     
                                     this.showhidespinner(component,event,false);
                                 }
                                 else{
                                     // this.displayToastMessage(component,event,'Success','Customer Consent Details saved successfully','success');
                                     this.showhidespinner(component,event,false);
                                 }
                                 
                                 
                             });
            
        }
        else{
            this.displayToastMessage(component,event,'Error','Please Enter valid dates','error');
            this.showhidespinner(component,event,false);
        }
    },
    executeApex: function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    dateUpdate : function(component, event) {
        console.log('inside dateupdate');
        var isvaliddate = true;
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        var firstemidate = component.get("v.EMI1stDate");
        var approvedtenor  = component.get("v.loan").Approved_Tenor__c-1;
        var first_dd,first_mm,first_yyyy;
        var last_dd,last_mm,last_yyyy;
        var dd_lastemi;
        var isvalidmonth = false;
        if(!$A.util.isEmpty(firstemidate)){
            var emisplit = firstemidate.split("-");
            first_mm = parseInt(emisplit[1]);
            first_yyyy = parseInt(emisplit[0]);
            first_dd =  parseInt(emisplit[2]);
            var lastemidate = new Date(first_yyyy, first_mm, first_dd);
            if(!isNaN(approvedtenor))
                lastemidate.setMonth(lastemidate.getMonth()+approvedtenor);
            last_mm = lastemidate.getMonth(); 
            last_yyyy = lastemidate.getFullYear();
            if(last_mm == 0){
                last_mm = last_mm+12;
                last_yyyy = last_yyyy-1;
            }
            last_dd = lastemidate.getDate(); 
            if(last_mm < 10){
                last_mm = '0' + last_mm;
            } 
            if(last_dd < 10){
                last_dd = '0' + last_dd;
            }
            var lastFormattedDate = last_yyyy+'-'+last_mm+'-'+last_dd;
            component.set("v.EMILastDate",lastFormattedDate);
        }
        console.log('inside less'+first_mm+mm);
        if(dd <= 15)
        {
            if(parseInt(first_mm) - parseInt(mm) > 1 )
                isvalidmonth = true;
            console.log('inside less'+first_mm+mm);
        }
        else if(parseInt(first_mm) - parseInt(mm) > 2 )
        {
            isvalidmonth = true;
            console.log('inside greater'+first_mm+mm);
        }
        
        var EMILastDate = component.get("v.EMILastDate");
        if(!$A.util.isEmpty(EMILastDate)){
            EMILastDate = firstemidate.split("-");
            dd_lastemi =  parseInt(EMILastDate[2]);
        } 
        console.log('inside dateupdate0'+isvaliddate);
        if((component.get("v.EMI1stDate") != '' && component.get("v.EMI1stDate") <= todayFormattedDate) || (parseInt(first_dd) != 2 && parseInt(first_dd) != 5  && !isvalidmonth)){
            component.set("v.dateValidationError1" , true);
            isvaliddate = false;
            console.log('inside dateupdate1'+isvaliddate);
            component.set("v.datevalidationmsg1","Start Date must be 2nd and 5th of Future Date");
        }else{
            component.set("v.dateValidationError1" , false);
            component.set("v.datevalidationmsg1","");
        }
        if((component.get("v.EMILastDate") != '' && component.get("v.EMILastDate") <= todayFormattedDate)|| (parseInt(dd_lastemi) != 2 &&  parseInt(dd_lastemi) != 5)){
            component.set("v.dateValidationError2" , true);
            isvaliddate = false;
            console.log('inside dateupdate2'+isvaliddate);
            component.set("v.datevalidationmsg2","End Date must be 2nd and 5th of Future Date");
        }else{
            component.set("v.dateValidationError2" , false);
            component.set("v.datevalidationmsg2", "");
        }
        if(isvaliddate && component.get("v.EMI1stDate") != '' && component.get("v.EMILastDate") != '' && component.get("v.EMI1stDate") > component.get("v.EMILastDate")){
            component.set("v.dateValidationError1" , true);
            component.set("v.dateValidationError2" , true);
            isvaliddate = false;
            console.log('inside dateupdate'+isvaliddate);
            component.set("v.datevalidationmsg1","Start date must be less than End date");
            component.set("v.datevalidationmsg2","End date must be greater than Start date");
        }
        if(isvaliddate){
            component.set("v.dateValidationError1" , false);
            component.set("v.dateValidationError2" , false);
            component.set("v.datevalidationmsg1","");
            component.set("v.datevalidationmsg2","");
        }
        
        return isvaliddate;
    },
    showhidespinner:function(component, event, showhide){
        
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
        
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    }
})