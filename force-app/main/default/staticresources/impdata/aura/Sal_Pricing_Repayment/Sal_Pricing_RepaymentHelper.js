({
    editRecord : function(component, event) {
        try{
        var recAppId = event.currentTarget.value;
        console.log('id is'+recAppId);
		//US5431s
        //Bug 20391 : Bug 22065 : Added for point 10 : Added isDisbDashboard flag
                this.executeApex(component, "fetchIFSCData", {
                "ifscmicrCode": event.target.id,
                "fieldAPI": 'IFSC_Code__c'
        },function (error, result) {           
            console.log('result'+result);
                    if(result == 'Fail'){                        
                        this.displayToastMessage(component,event,'Error','Record not found!','error');
                    }
                    else if(result.includes("Error")){
                        
                        this.displayToastMessage(component,event,'Error','Error occured!','error');
                    }
                        else{ 
                            console.log('else');
                            var ifscList = JSON.parse(result);                            
                            var micrList= [];
                            console.log('ifscObj0='+ifscList[0]);   
                            for(var i=0;i<ifscList.length;i++){
                                micrList.push(ifscList[i].MICR__c);
                                component.set("v.micrActive", true);
                            }
                            console.log('result='+result);
                                                     
                            console.log('micrList='+micrList);
                        }
            
            $A.createComponent(//changed for 22017
            "c:repayModalContentNew",{"header":"Edit Record",
                                      "repayId":recAppId,
                                      "loanId":component.get("v.loanId"),
                                      "loan":component.get("v.loan"),
                                      "primaryAppId":component.get("v.primaryAppId"),//22017
                                      "disbList":component.get("v.disbList"),
                                      "isDisbDashboard": component.get("v.isDisbDashboard"), 
                                      "bankObj":component.get("v.bankAccount"),
                                      "micrList":micrList,////us5431 passed micrlist
                                      "micrActive":component.get("v.micrActive")},//us5431 passed micrActive
            
            function(newComponent){
                component.set("v.body",newComponent);
            }
        );
            
        });
        }catch(e){console.error('editRecord Error '+e);}
        //US5431e
        
    },
    addRecord : function(component, event) {
       
        var recAppId = event.currentTarget.value;
      
        console.log('id is'+recAppId);
        /* added by swapnil bug id: start*/
             var Ex_customer_id='';
        var repayList=component.get("v.repayList");
        if(repayList && repayList.length>0){ //Bug:22974 added null check for repaylist
            if(repayList[0].Open_ECS_Ex_Customer_Id__c!=null)
                Ex_customer_id=repayList[0].Open_ECS_Ex_Customer_Id__c;
        }
        console.log(" --> ",component.get("v.loan"));
        //Bug 20391 : Bug 22065 : Added for point 10 : Added isDisbDashboard flag
        $A.createComponent(//changed for 22017
                    "c:repayModalContentNew",{"header":"Add Record",
                                           "loanId":component.get("v.loanId"),
                                           "bankObj":component.get("v.bankAccount"),//24315
                                           "loan":component.get("v.loan"),
                                           "disbList":component.get("v.disbList"),
                                           "primaryAppId":component.get("v.primaryAppId"),
                                           "bankObj":component.get("v.bankAccount"),
										  "isDisbDashboard": component.get("v.isDisbDashboard") },
            function(newComponent,status,errorMessage){
                console.log('in create'+status+errorMessage);
                component.set("v.body",newComponent);
            }
        )
         /* added by swapnil bug id: end*/
        console.log('after');
    },
       
    callECS : function(component, event) {
        $A.createComponent(//changed for 22017
            "c:SAL_Pricing_initiateOpenECS",{"isOpen": true,"bankAccount":component.get("v.bankAccount"),
                                   "oppId":component.get("v.loanId")},
            function(newComponent){
                     component.set("v.body",newComponent);

            }
           
        );
    },
    deleteRecord : function(component, event){
        var recAppId = event.currentTarget.value;
       //24315s
                console.log('outer +'+component.get("v.bankAccount"));
        var bankAccountObj=component.get("v.bankAccount");
        if(bankAccountObj != null)
        bankAccountObj.Perfios_account_same_as_Salary_account__c = false;
        //24315e
        var bnkAc= JSON.stringify(bankAccountObj);
        console.log('inter +'+bnkAc);
        this.executeApex(component, "deleteRepaymentObject", {
            "repayId": recAppId,
            "loanId": component.get("v.loanId"),
            "bankAccount": bnkAc //24315 passed bankAccount
        }, function (error, result) {
           	component.set("v.rerenderEmandate", false);
            if (!error && result) {
                if(result == 'Fail'){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Error while processing!','error');
                }
                else if (result == 'Empty'){
                    component.set("v.repayList",null);
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Succces','Record deleted successfully!','success');
                }
                else{
                    component.set("v.repayList",JSON.parse(result));
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Succces','Record deleted successfully!','success');
                }
                component.set("v.rerenderEmandate", true);
                
            }
        });
    },
    handleUpdateRepay : function(component, event){
        this.showhidespinner(component,event,true);
        component.set("v.rerenderEmandate", false);
        this.executeApex(component, "fetchRepayList", {
           "loan" : JSON.stringify(component.get("v.loan")),
            "repay" : event.getParam("repay")
        }, function (error, result) {
           
            if (!error && result) {
                if(result == 'Fail'){
                    this.showhidespinner(component,event,false);
                }
                else{
                  	var data = JSON.parse(result);
                    console.log('opp'+data.opp);
                    component.set("v.repayList",data.repayList);
                    component.set("v.loan",data.opp);
                    component.set("v.rerenderEmandate", true);
                    this.showhidespinner(component,event,false);
                }
                
            }
        });
        
    },
    executeApex : function(component, method, params,callback){
      
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
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
})