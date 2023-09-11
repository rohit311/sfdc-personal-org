({
    fetchOTP : function(component,event) {
        var params = new Object();
        params["lead"] = JSON.stringify([component.get("v.leadObj")]);
        if(component.get("v.selectedProd") == 'Combo(CPP+FFR)'){
            params["product"] = "CPP &#038; FFR";
        }
        else{
            params["product"] = component.get("v.selectedProd");             
        }
        var self =this;
        
        this.executeApex(component,"sendOTPtoCustomer",{"paramsMap":params},function(error,result){
            component.set("v.Spinner",false);
            var response = JSON.parse(result);
            console.log('status '+response);
            if(!error && response.status == "SUCCESS"){ 
                component.set("v.leadObj",response.leadRec);
                console.log('--> '+component.get("v.leadObj").One_Time_Password__c);
                component.find("CibilBtnId").set("v.disabled",false);
                self.displayToastMessage(component,event,'Success','OTP generated Successfully','success');
            }else{
                
                self.displayToastMessage(component,event,'Error','Internal server error : '+response.message,'error');                
            }
            
            
            
        });
    },
    triggerCibil : function(component,event) {
        var params = new Object();
        params["lead"] = JSON.stringify([component.get("v.leadObj")]);
        
        var self =this;
        component.set("v.Spinner",true);
        this.executeApex(component,"genCibil",{"paramsMap":params},function(error,result){
            component.set("v.Spinner",false);
            var response = JSON.parse(result);
            console.log('status '+response);
            if(!error && response.status == "SUCCESS"){ 
                component.set("v.leadObj",response.leadRec);
                //console.log('--> '+component.get("v.leadObj").One_Time_Password__c);
                //component.find("CibilBtnId").set("v.disabled",false);
                self.displayToastMessage(component,event,'Info','Cibil Initiated , please wait for some time','info');
                component.set("v.Spinner",true);
                // CR not given start
                var shareCibilInfo = component.getEvent("shareCibilInfo");
                
                if(shareCibilInfo){
                     shareCibilInfo.fire();                   
                }
                // CR not given stop
                
                var intervalId = window.setInterval(
                    $A.getCallback(function() { 
                        
                        self.pollcibilRecords(component,event,self);
                    }), 10000
                ); 
                component.set("v.intervalId",intervalId);
            }else{
                
                self.displayToastMessage(component,event,'Error','Internal server error :'+response.message,'error');                
            }
            
            
            
        });
        
        
    },
    pollcibilRecords : function(component,event,self){
        
        
        self.displayToastMessage(component,event,'Info','Checking Cibil , please wait for some time','info');
        console.log('in poller');
        var pollCnt = component.get("v.pollCnt");
        pollCnt = pollCnt +1;
        component.set("v.pollCnt",pollCnt);
        if(pollCnt == 6){
            component.set("v.Spinner",false);
            window.clearInterval(component.get("v.intervalId"));
            self.displayToastMessage(component,event,'Info','Unable to generate Cibil , please Re-initiate Cibil.','info');
            component.find("CibilBtnId").set("v.disabled",false);
            component.set("v.Spinner",false);
            component.set("v.isCibildone",true); //added for testing as cibil not working on partial
            //document.getElementById("otpLink").className = "";
        }
        else{
            self.executeApex(component,"fetchCibilRecs",{"leadId":component.get("v.leadObj").Id},function(error,result){
                var response = JSON.parse(result);
                
                if(!error && response.status == "SUCCESS"){ 
                    console.log(response);
                    if(response.isCibilDone == true){
                        document.getElementById("otpLink").className = "disabled";
                        self.displayToastMessage(component,event,'Success','Cibil Completed successfully !','success');
                        window.clearInterval(component.get("v.intervalId"));
                        component.find("paymentButtonId").set("v.disabled",false);
                        component.set("v.Spinner",false);
                        component.set("v.leadObj",response.leadRec);
                        var leadObj = component.get("v.leadObj");
                        if(leadObj.CIBIL_Score__c && leadObj.CIBIL_Score__c != 'Err%' && leadObj.CIBIL_Score__c != 'ERRR%' && leadObj.CIBIL_Score__c != '00000' && leadObj.CIBIL_Score__c != '000-1'){
                            component.set("v.isCibildone",true);
                            component.set("v.isdataChanged",false);//CR 24406
                            
                        }
                        else{
                            self.displayToastMessage(component,event,'Info','Invalid cibil score , Please contact Bajaj Finserv.','info');
                            
                        }
                        
                    }
                    
                }else{
                    self.displayToastMessage(component,event,'Error','Internal server error :'+response.message,'error'); 
                    component.set("v.Spinner",false);
                    window.clearInterval(component.get("v.intervalId"));
                }
                
            });
            
        }
    },
    insertRecs : function(component,event) {
        
        component.set("v.Spinner",true);
        var params = new Object();
        var self = this;      
        
        if(component.get("v.selectedProd") == 'CPP' || component.get("v.selectedProd") == 'Combo(CPP+FFR)'){
            this.populateWallet(component,event);
            this.populateSerToSales(component,event);  
            params["insuWallet"] = JSON.stringify([component.get("v.insWalletObj")]);  
            params["SerToSalesObj"] = JSON.stringify([component.get("v.SerToSalesObj")]);  
        }
        
        if(component.get("v.selectedProd") == 'FFR' || component.get("v.selectedProd") == 'Combo(CPP+FFR)'){
            var lead = component.get("v.leadObj");
            lead.FFR_opted__c = true;
            lead.Insurance_Premium_Amount__c = component.get("v.FFRAmt");  
            component.set("v.leadObj",lead);  
        }
        
        
        this.populateDedupe(component,event);
        
        params["deDupeObj"] = JSON.stringify([component.get("v.deDupeObj")]); 
        params["lead"] = JSON.stringify([component.get("v.leadObj")]);        
        if(component.get("v.selectedProd") == 'Combo(CPP+FFR)'){
            params["product"] = "CPP &#038; FFR";
        }
        else{
            params["product"] = component.get("v.selectedProd");             
        }		
        params["totalAmt"] = component.get("v.totalAmt");
        this.setRequest(component,event);
        params["payRequest"] = component.get("v.payRequest");
        params["premium"] = component.get("v.premium");
        
        this.executeApex(component,"insertRecords",{"paramsMap":params},function(error,result){
            component.set("v.Spinner",false);
            var response = JSON.parse(result);
            if(!error && response.status == "SUCCESS"){              
                component.set("v.leadObj",response.leadRec);
                component.set("v.insWalletObj",response.insRec);
                component.set("v.showThankyou",true);             
                self.displayToastMessage(component,event,'Success','Communication sent to customer successfully !','success');   
                var products = component.get("v.products");
                if(products){
                    console.log(component.get("v.selectedProd"));
                    for(var i=0;i<products.length;i++){
                        if(products[i].product != component.get("v.selectedProd")){
                            products[i].status = true;
                        }                      
                    }    
                    component.set("v.products",products);
                }
                // CR 24406 start
                var sharepayInfo = component.getEvent("sharePaymentInfo");
                
                if(sharepayInfo){
                     sharepayInfo.fire();                   
                }
                // CR 24406 stop
            }
            else{               
                self.displayToastMessage(component,event,'Error','Internal server error :'+response.message,'error');
            }
            
            
        }); 
        
    },
    populateWallet : function(component,event) {
        var insWalletObj = component.get("v.insWalletObj");
        var leadObj = component.get("v.leadObj");
        insWalletObj = new Object();       
        
        insWalletObj.Status__c = 'New To Bajaj'; 
        if(leadObj.Customer_ID1__c){
            insWalletObj.CUSTOMER__c = leadObj.Customer_ID1__c;      
            insWalletObj.Status__c = 'Existing-Bajaj';          
        }
        insWalletObj.Insurance_Category__c = 'General';
        insWalletObj.Insurance_Sub_category__c = 'General';     
        insWalletObj.Amount_of_the_Instrument__c = parseInt(component.get("v.premium"));                
        insWalletObj.Payment_Frequency__c = 'Single(0)';
        insWalletObj.Sum_Assured__c = parseInt(component.get("v.SumAssured")); 
        insWalletObj.Payment_for_Multiple_Form__c = 'No';   
        if(component.get("v.selectedProd") == 'CPP' || component.get("v.selectedProd") == 'Combo(CPP+FFR)'){
            insWalletObj.Product__c = 'CPP- Wallet Protect';     
        }
        insWalletObj.Payment_mode__c = 'Online Payment';
        insWalletObj.Premium_Amount__c = parseInt(component.get("v.premium")); 
        insWalletObj.Policy_Tenor_GI__c = 3;
        insWalletObj.Source__c = "SAL Standalone Product";
        
        component.set("v.insWalletObj",insWalletObj);    
    },
    populateSerToSales : function(component,event) {
        var SerToSalesObj = component.get("v.SerToSalesObj");
        var leadObj = component.get("v.leadObj");
        SerToSalesObj = new Object();
        if(leadObj && leadObj.Gender__c){
            if(leadObj.Gender__c == 'Male')
                SerToSalesObj.Gender__c = 'Male';
            else
                SerToSalesObj.Gender__c = 'Female';
        }
        //new fields start
        SerToSalesObj.Family_Relation__c = 'Self';
        SerToSalesObj.Preferred_Communication_Address__c = 'Permanent';
        if(leadObj.Per_Pin_Code__c){
            SerToSalesObj.Pincode__c = leadObj.Per_Pin_Code__c+'';
        }
        else{
            SerToSalesObj.Pincode__c = '';
        }
        
        SerToSalesObj.Office_Telephone__c = '';
        //new fields stop 
        console.log('date of birth '+leadObj.DOB__c);
        if(leadObj.DOB__c)
        SerToSalesObj.Date_of_Birth__c =leadObj.DOB__c;
        
        SerToSalesObj.PAN__c = leadObj.PAN__c;
        SerToSalesObj.Mobile__c = leadObj.Customer_Mobile__c;
        SerToSalesObj.First_Name__c = leadObj.FirstName;
        SerToSalesObj.Last_Name__c = leadObj.LastName;
        component.set("v.SerToSalesObj",SerToSalesObj);
    },
    populateDedupe : function(component,event) {
        var deDupeObj = component.get("v.deDupeObj"); 
        var leadObj = component.get("v.leadObj"); 
        deDupeObj = new Object(); 
        
        deDupeObj.Lead__c = leadObj.Id; 
        deDupeObj.Source_Or_Target__c = 'Source';
        deDupeObj.First_Name__c = leadObj.FirstName;
        deDupeObj.Last_Name__c =  leadObj.LastName;
        deDupeObj.PAN__c = leadObj.PAN__c;
        deDupeObj.Address1_Residence__c = leadObj.Permanent_Line_1_New__c;
        deDupeObj.Address2_Residence__c = leadObj.Address_Line_2_New__c;
        deDupeObj.Address3_Residence__c = leadObj.Permanent_Address_3__c;
        deDupeObj.Area_Residence__c = leadObj.Permanent_Address_3__c;
        deDupeObj.City_Residence__c = leadObj.Per_City__c;
        deDupeObj.Address1_Office__c = leadObj.Permanent_Line_1_New__c;
        deDupeObj.Address2_Office__c = leadObj.Address_Line_2_New__c; 
        deDupeObj.Address3_Office__c = leadObj.Permanent_Address_3__c;
        deDupeObj.City_Office__c = leadObj.Per_City__c;
        deDupeObj.Datafix_Updated__c = "New records";
        deDupeObj.Mobile_Office__c = leadObj.Customer_Mobile__c;
        deDupeObj.Application_Status__c = "Complete";
        deDupeObj.Email_Residence__c = leadObj.Email;
        deDupeObj.Random_Dedupe__c = 1;
        
        component.set("v.deDupeObj",deDupeObj);
    },
    executeApex: function(component, method, params,callback){
        
        console.log('params'+JSON.stringify(params));
        console.log('method name is '+method)
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('response is'+response);
            var state = response.getState();
            console.log('state is '+state);
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()123'+response.getReturnValue());
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
    setRequest : function(component,event){
        var payRequest = component.get("v.payRequest");
        var payRecord = component.get("v.payRecord");
        if(payRequest && payRecord){
            payRecord = payRecord.replace("**Id**",1+'');
            if(component.get("v.selectedProd") == 'CPP' || component.get("v.selectedProd") == 'FFR'){
                payRecord = payRecord.replace("**MERCID**",component.get("v.merMap")[component.get("v.selectedProd")]);
                payRecord = payRecord.replace("**AMOUNT**",parseFloat(component.get("v.totalAmt")).toFixed(2));                
            }
            else{
                payRecord = payRecord.replace("**MERCID**",component.get("v.merMap")["FFR"]);
                payRecord = payRecord.replace("**AMOUNT**",component.get("v.FFRAmt"));     
            }
            payRecord = payRecord.replace("**CUSTOMERID**",component.get("v.leadObj").Id+'');
            payRecord = payRecord.replace("**ADDITIONALINFO1**",component.get("v.leadObj").Customer_Mobile__c+'');
            payRecord = payRecord.replace("**ADDITIONALINFO2**",component.get("v.leadObj").Customer_Email_Id__c+'');
            payRecord = payRecord.replace("**ADDITIONALINFO3**","BAJFS12345");
            payRequest = payRequest.replace("**Rec1**",payRecord);
            if(component.get("v.selectedProd") == 'Combo(CPP+FFR)'){
                var payRecord2 =component.get("v.payRecord");
                payRecord2 = payRecord2.replace("**Id**",2+'');
                payRecord2 = payRecord2.replace("**MERCID**",component.get("v.merMap")["CPP"]);
                payRecord2 = payRecord2.replace("**CUSTOMERID**",component.get("v.leadObj").Id);
                payRecord2 = payRecord2.replace("**ADDITIONALINFO1**",component.get("v.leadObj").Customer_Mobile__c);
                payRecord2 = payRecord2.replace("**ADDITIONALINFO2**",component.get("v.leadObj").Customer_Email_Id__c);
                payRecord2 = payRecord2.replace("**ADDITIONALINFO3**",component.get("v.leadObj").Id);
                console.log('payRecord '+payRecord);
                payRecord2 = payRecord2.replace("**AMOUNT**",component.find("PremId").get("v.value")+'');
                payRequest = payRequest.replace("**Rec2**",payRecord2);
            }
            else{
                payRequest = payRequest.replace("**Rec2**",'');
            }
            payRequest = payRequest.replace("**Rec3**",'');
        }
        console.log('request --> '+payRequest);
        component.set("v.payRequest",payRequest);
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
})