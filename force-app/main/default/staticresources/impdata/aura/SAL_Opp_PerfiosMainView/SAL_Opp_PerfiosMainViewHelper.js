({
    createBankAccountData: function(component, event) {
        var RowItemList = component.get("v.bankAccountList");
        RowItemList.push({
            'sobjectType': 'Bank_Account__c'
        });
        component.set("v.bankAccountList", RowItemList);
    },
    saveHVTDetails: function(component){
        var uniqueMon = new Map();
        var monMap = component.get("v.perfiosTrans");
        //alert('monMap'+monMap.length);	
        for(var i = 0;i< monMap.length;i++){
            uniqueMon[monMap[i].month] = monMap[i].date;
            
        }
        var salList = [];
        
        for(var key in uniqueMon){
            //alert($('input[name='+key+']:checked').length);
            if (!$('input[name='+key+']:checked').length) {
                this.displayToastMessage(component,event,'Error','One transaction for each month should be selected','error');
                //alert('One best match for each applicant should be selected');
                return false; 
            }
            salList.push($('input[name='+key+']:checked').val());
            
        }    
        var bankAccObj;
        var bankAcc = component.get("v.bankAccountList");
        if(!$A.util.isEmpty(bankAcc)){
            bankAccObj = bankAcc[0];
        }
        
        var cam = component.get("v.camObj");
        if(!$A.util.isEmpty(salList[0])){
            var listData = salList[0].split(',');
            cam.Average_incentive_for_Q1__c = listData[0];
            bankAccObj.Salary_Credit_Date1__c = listData[1];
            console.log('narrationpk1'+listData[2]);
            bankAccObj.narration1__c = listData[2];
            
        }
        	
        if(!$A.util.isEmpty(salList[1])){
            var listData = salList[1].split(',');
            cam.Average_incentive_for_Q2__c = listData[0];
            console.log('dateis'+listData[1]);
            bankAccObj.Salary_Credit_Date2__c = listData[1];
            console.log('narrationpk2'+listData[2]);
             bankAccObj.narration2__c = listData[2];
        }
        	
        else if(!$A.util.isEmpty(salList[0])){
            var listData = salList[0].split(',')
            cam.Average_incentive_for_Q2__c = listData[0];
            bankAccObj.Salary_Credit_Date2__c = listData[1];
             bankAccObj.narration2__c = listData[2];
        }
            
        if(!$A.util.isEmpty(salList[2])){
            var listData = salList[2].split(',')
            cam.Average_incentive_for_Q3__c = listData[0];
            console.log('dateis'+listData[1]);
            bankAccObj.Salary_Credit_Date3__c = listData[1];
             console.log('narrationpk3'+listData[2]);
            bankAccObj.narration3__c = listData[2];
        }
        	
        else if(!$A.util.isEmpty(salList[0])){
            var listData = salList[0].split(',')
            cam.Average_incentive_for_Q3__c = listData[0];
            bankAccObj.Salary_Credit_Date3__c = listData[1];
            bankAccObj.narration3__c = listData[2];
        }
        component.set("v.bankAccount",bankAccObj);    
        component.set("v.camObj",cam);
        component.set("v.isOpen", false);
    },
    fetchHVT : function(component,event){
        if(!$A.util.isEmpty(component.get("v.account.Type_of_Salary__c")))
        {
            
            if(component.get("v.account.Type_of_Salary__c") == 'Perfios')
            {
                component.set("v.isToDisabled", true); 
                component.set("v.isOpen", true);
            }
            
        }
        else{
            this.displayToastMessage(component,event,'Error','Please select option','error');
        }
        if(!$A.util.isEmpty(component.get("v.account.Type_of_Salary__c")))
        {
            if(component.get("v.account.Type_of_Salary__c") == 'Perfios'){
                this.showhidespinner(component,event,true); 
                this.executeApex(component, "fetchHVTDetails",{
                    "loanId": component.get("v.loan.Id"),
                } , function(error, result){
                    if(!error && result){
                        var mapResult = result;
                        var finalList = [];
                        var month1List = [];
                        var month2List = [];
                        var month3List = [];
                        var months = [];
                        mapResult.reverse();
                        var count = 1;
                        console.log('check months');
                        var lastMon = new Date().getMonth();
                        console.log('lastMon'+lastMon);
                        for(var i in mapResult){
                            if(count < 4){
                                var month = new Date(mapResult[i].date).getMonth();
                                console.log('month'+month);
                                if(!months.includes(month)){
                                    console.log('in no');
                                    var inc = 0;
                                    for(var j in mapResult){
                                        if(inc < 5){
                                            var monthCmp = new Date(mapResult[j].date).getMonth();
                                            console.log('monthCmp'+monthCmp);
                                            if(monthCmp == month){
                                                if(count == 1)
                                                    month1List.push(mapResult[j]);
                                                else if(count ==2)
                                                    month2List.push(mapResult[j]);
                                                else if(count ==3)
                                                    month3List.push(mapResult[j]);    
                                                finalList.push(mapResult[j]);
                                                inc++;
                                            } 
                                        }
                                        
                                    }
                                    months.push(month);
                                    count++;
                                }
                            }
                            
                        }
                        if(finalList.length > 0){
                            console.log('month1Listt'+month1List.length+month2List.length+month3List.length);
                            component.set('v.perfiosTrans',finalList);
                            component.set('v.month1List',month1List);
                            component.set('v.month2List',month2List);
                            component.set('v.month3List',month3List);
                        }
                        else{
                            this.displayToastMessage(component,event,'Error','Perfios response has not been received yet','error');
                            component.set("v.isOpen", false);
                            component.set("v.isToDisabled", false); 
                            component.set("v.account.Type_of_Salary__c",'Manual');
                        }
                        this.showhidespinner(component,event,false); 
                    }  
                    else{
                        this.displayToastMessage(component,event,'Error','Perfios response has not been received yet','error');
                        component.set("v.isOpen", false);
                        this.showhidespinner(component,event,false);
                        component.set("v.isToDisabled", false); 
                        component.set("v.account.Type_of_Salary__c",'Manual');
                    }
                    
                });
            }
            else{
                this.displayToastMessage(component,event,'Error','Please select salary type perfios.','error');
            }
        }
        else{
            this.displayToastMessage(component,event,'Error','Please select salary type.','error');
        }
    },
    validateRequired: function(component, event) {
        var invalidCount = 0;
        var isValid = true;
        var bankCmp = component.find("bankListCmp");
        
        if ($A.util.isArray(bankCmp)) {
            bankCmp.forEach(cmp => {
                isValid = cmp.validatebank();
                //alert('isValid'+isValid);
                if(!isValid){
                	invalidCount++;
            	}
            })
        } else {
           isValid = bankCmp.validatebank();
           if(!isValid){
               invalidCount++;
            }
        }
        
        
        /*var isValid = true;
        var allContactRows = component.get("v.bankAccountList");
        for (var indexVar = 0; indexVar < allContactRows.length; indexVar++) {
            if ($A.util.isEmpty(allContactRows[indexVar].applicantObj)) {
                isValid = false;
                alert('First Name Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }*/
        
        return invalidCount;
    },
                
     saveSalaryDetails: function(component) {
         
         var cam = component.get("v.camObj");
         //alert(component.get("v.applicantObj").Id);
         //alert(!cam.Loan_Application__c);
     /*Prod issue-24773 S*/    if(!cam.Loan_Application__c)
        	 cam.Loan_Application__c = component.get("v.loan").Id;
         if(!cam.Applicant__c)
             cam.Applicant__c = component.get("v.applicantObj").Id;
       /*Prod issue-24773 E*/   
         console.log('isValid '+JSON.stringify(cam));
         var isValid = this.validateSourceData(component);
         console.log('isValid '+isValid);
         if(isValid){
         this.showhidespinner(component,event,true); 
          
         console.log('here in save cam');
         this.executeApex(component, "saveCamDetails", {"params":{"solPolicySrc":"Sales2.0",
           "appObj": JSON.stringify([component.get("v.applicantObj")]),//24668
           "finAppl":JSON.stringify([component.get("v.finAppl")]),//24668                                                       
           "empAccount":JSON.stringify([component.get("v.account")]),
           "empContact":JSON.stringify([component.get("v.contact")]),
           "empOpp":JSON.stringify([component.get("v.loan")]),
           "TypeForMCP":"Sal",
           "bankObj":JSON.stringify(component.get("v.bankAccount")),
           "JSONCamObj" :JSON.stringify(cam)}}, function(error, result){
         		 if(!error && result){
                     console.log(result);
                     var appData = JSON.parse(result);
                     console.log('pkmcp'+appData.status);
                     console.log('in save cam')
                     if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.camObj)){
                         component.set("v.camObj",appData.camObj);
                         
                         var camObj = appData.camObj;
                         console.log('camobj'+camObj.Id);
                         var amount1 = 0,amount2 = 0,amount3 = 0,averageSal = 0;
                         if(!$A.util.isEmpty(camObj.Average_incentive_for_Q1__c))
                             amount1 = camObj.Average_incentive_for_Q1__c;
                         if(!$A.util.isEmpty(camObj.Average_incentive_for_Q2__c))
                             amount2 = camObj.Average_incentive_for_Q2__c;
                         if(!$A.util.isEmpty(camObj.Average_incentive_for_Q3__c))
                             amount3 = camObj.Average_incentive_for_Q3__c;
                         averageSal = amount1 + amount2 + amount3;
                         if(averageSal != 0)
                             averageSal = parseFloat(averageSal/3).toFixed(2); 
                         component.set("v.averageSal",averageSal);
                     }
                     console.log('appData is::'+appData);
                     if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.accObj))
                     component.set("v.account",appData.accObj);
                     if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.opp))
                     component.set("v.loan",appData.opp);
                     console.log('opp is::'+appData.opp);
                     var oppStage = appData.opp.StageName;
                     console.log('oppStage::'+oppStage);
                     if(oppStage != null)
                     {
                         if(oppStage == 'DSA/PSF Login')
                         {
                             component.set("v.stageCompletion","20%") ;
                         }
                         else if(oppStage == 'MCP Reject')
                         {
                             location.reload();
                             console.log('in mcp reject Console');
                             component.set("v.stageCompletion","0%") ;
                             /*component.set("v.MCPRejectON",false) ;
                             
                             var cmpEvent =  $A.get("e.c:MCPRejectEvent");
                             cmpEvent.setParams({
                                 "flag": false
                             });
                             cmpEvent.fire();
                             console.log('after fire event');*/
                             
                         }
                     }
                    // alert(JSON.stringify(appData.camObj));
                     if(appData.status == 'Success'){
                     	this.showhidespinner(component,event,false);
                    	this.displayToastMessage(component,event,'Success','Details Saved Successfully','success');
                     }else{
                      this.showhidespinner(component,event,false);
                    	this.displayToastMessage(component,event,'Error',appData.status,'error');
                        
                     }
                     }
               else{
                   	this.showhidespinner(component,event,false);
                     this.displayToastMessage(component,event,'Error','Error while saving the data','error');
               }
             
         });
         }
         else{
             this.displayToastMessage(component,event,'Error','Please fill the required details','error');
         }
         
     },
                
     validateSourceData :function (component) {
         var list = ["HVTpick","InwardECSBounce","inwardChqBounces"];
         console.log('list'+list.length);
         //alert(component.get("v.account.Type_of_Salary__c"))
         if(!$A.util.isEmpty(component.get("v.bankAccount")) && component.get("v.account.Type_of_Salary__c") == 'Manual'){
             //alert('in');
             list.push("SalaryDate1");
             list.push("SalaryDate2");
             list.push("SalaryDate3");
         }
         if(component.get("v.account.Type_of_Salary__c") == 'Manual'){
             list.push("NetSalary1");
             list.push("NetSalary3");
             list.push("NetSalary2");
         }
        // alert('list'+list.length);
        var isvalid =true;
        for (var i = 0; i < list.length; i++) {
            console.log('list[i]>>' + list[i]+component.find(list[i]));
           // console.log(a);
           var bankCmp = component.find(list[i]);
           if ($A.util.isArray(bankCmp)) {
            bankCmp.forEach(cmp => {
                if (!cmp.get("v.validity").valid)
                {
                
                	isvalid = false;
                	cmp.showHelpMessageIfInvalid();
            	}
            })
        } else {
           if (!bankCmp.get("v.validity").valid)
                {
                
                	isvalid = false;
                	bankCmp.showHelpMessageIfInvalid();
            	}
        }
            /*if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
               
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }*/
        }
        
        return isvalid;
    },           
     executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state '+state );
            if(state === "SUCCESS"){
                //console.log('response.getReturnValue()'+response.getReturnValue());
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
    },
})