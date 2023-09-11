({
    saveObligations : function(component, event) {
        
        this.setupLsts(component, event);
        var self = this;
        this.executeApex(component,"changeOblig",{"obligtoUpdate":JSON.stringify(component.get("v.updateLst")),"obligtodelete":JSON.stringify(component.get("v.deleteLst"))},function (error, result) {
            self.showhidespinner(component,event,false);
            if (!error && result && (!result.includes('exception'))) {
                var data = JSON.parse(result);
                var obligLst = new Array();
                component.set("v.deleteLst",[]);
                component.set("v.updateLst",[]);
                console.log('data');
                console.log(data);
                self.fetchExtDetl(component,event);
                obligLst = component.get("v.obligLst");
                if(obligLst && obligLst.length >0){
                    /*for(var i=0;i<data.length;i++){
                        
                        
                        obligLst.push({"exObj":data[i],"deleteRecord":false,"startDate":data[i].Start_On__c});
                        
                    }*/
                    component.set("v.obligLst",obligLst);
                   //Added for Bug-26686 total Obligation calculation - Raghu start 
                    var totalObligation = 0;
                    for(var i=0; i<obligLst.length; i++){
                        
                        if(obligLst[i].exObj.Status__c == 'Live' && obligLst[i].exObj.Obligation__c == 'Yes'){
                            
                            if(obligLst[i].exObj.EMI__c != null && obligLst[i].exObj.EMI__c > 0){
                                if(obligLst[i].exObj.Loan_Type__c == 'Credit Card'){
                                	totalObligation = totalObligation+(obligLst[i].exObj.EMI__c * 5) / 100;
                                }
                                else{
                                    totalObligation = totalObligation+obligLst[i].exObj.EMI__c; 
                                }
                                
                            }
                            else if(obligLst[i].exObj.Derived_EMI__c != null && obligLst[i].exObj.Derived_EMI__c > 0){
                                if(obligLst[i].exObj.Loan_Type__c == 'Credit Card'){
                                    totalObligation = totalObligation+(obligLst[i].exObj.Derived_EMI__c * 5) / 100;
                                }
                                else{
                                    totalObligation = totalObligation+obligLst[i].exObj.Derived_EMI__c;
                                }
                            }
                        }
                    }
                    
                    component.set("v.totalObligations",Math.round(totalObligation));  
                //Added for Bug-26686 total Obligation calculation - Raghu end     
                }
                else{
                    console.log('here');
                    component.set("v.obligLst",[]);
                }
                
                self.displayToastMessage(component,event,'Success','Obligations updated successfully','success');
                console.log('obligLst');
                console.log( component.get("v.obligLst"));
                self.calcTotalObl(component, event); 
                self.callPANBre(component);
            }else{
                
                self.displayToastMessage(component,event,'Error','Internal Server error, Please try again later!','error');
            }
            
        });
        
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
    
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    
    setupLsts:function(component, event) {
        var updateLst = component.get("v.updateLst");
        var deleteLst = component.get("v.deleteLst");
        
        if(component.get("v.obligLst")){
            for(var i=0;i<component.get("v.obligLst").length;i++){
                
                if(component.get("v.obligLst")[i].deleteRecord && (component.get("v.obligLst")[i].deleteRecord == true) ){                 
                    if(component.get("v.obligLst")[i].exObj.Id){	
                        deleteLst.push(component.get("v.obligLst")[i].exObj);
                    }
                    
                }
                else{
                    var exObj = component.get("v.obligLst")[i].exObj;
                    exObj.Customer_Declared_EMI__c = exObj.EMI__c;
					exObj.Final_EMI__c = exObj.EMI__c;
                    var one_day=1000*60*60*24;
                    if(exObj.Start_On__c  && exObj.Status__c == 'Live'){
                        var todaysDate =  new Date();
                        
                        
                        var dateDiff = todaysDate.getTime() - (new Date(exObj.Start_On__c).getTime());
                        console.log(dateDiff/(one_day*30));
                      
                        //exObj.MOB__c = Math.floor(dateDiff/(one_day*30)); 
                        exObj.MOB__c = this.monthDiff(new Date(exObj.Start_On__c),todaysDate)+1;
                        console.log('mob dateDiff '+Math.floor(dateDiff/(one_day*30)));
                        console.log('function '+(this.monthDiff(new Date(exObj.Start_On__c),todaysDate)+1));
                        component.get("v.obligLst")[i].exObj = exObj;
                        
                    }else if(exObj.Start_On__c  && component.get("v.obligLst")[i].startDate){
                        var prevStartDate = component.get("v.obligLst")[i].startDate;
                        var diff = (new Date(prevStartDate).getTime()) - (new Date(exObj.Start_On__c).getTime());
                        
                        
                        console.log(prevStartDate);
                        console.log(exObj.Start_On__c);
                        if(parseInt(diff/(one_day*30)) >-1){
                            exObj.MOB__c = exObj.MOB__c +parseInt(diff/(one_day*30));
                        }
                        else{
                            exObj.MOB__c = -1;
                        }
                        
                        
                        console.log('mob '+diff/(one_day*30));
                    }
                   
                    // new Date()
                    updateLst.push(component.get("v.obligLst")[i].exObj);
                    
                }
            }
            component.set("v.updateLst",updateLst);
            component.set("v.deleteLst",deleteLst);
            console.log('updateLst'); 
            console.log(component.get("v.updateLst"));
        }
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
    
    validateDetails : function(component,event){
        //alert('here');
        var requiredFields =["Applicant__c","Start_On__c","POS__c","Status__c"];
        var cnt = 0;
        var obligLst = component.get("v.obligLst");
        var todaysDate = new Date ();
        var recDate ;
        var patt = new RegExp("^[0-9]+$");
        console.log (todaysDate);
        
        console.log ('date check start'); 
        
        for(var i=0;i<obligLst.length;i++){
            console.log(obligLst[i]);
            
            recDate = new Date ( obligLst[i].exObj[requiredFields[1]] ) ;
            
            if(obligLst[i].deleteRecord == false){
                for(var j=0;j<requiredFields.length;j++){
                    
                    
                    if( (!obligLst[i].exObj[requiredFields[j]] && obligLst[i].exObj[requiredFields[j]]!=0) 
                       || obligLst[i].exObj[requiredFields[j]] == '-- None --')
                        
                    {
                        // obligLst[i].exObj[requiredFields[j]]!=0 condition added to counter the condition of 0 being treated as falsy value
                        cnt = 1;
                        console.log(requiredFields[j]);
                        break;                   
                        
                    }                    
                    else if   (j==2 && recDate.getFullYear() > todaysDate.getFullYear()
                               || (recDate.getFullYear() == todaysDate.getFullYear() && recDate.getMonth() > todaysDate.getMonth() )
                               || (recDate.getFullYear() == todaysDate.getFullYear() && recDate.getMonth() == todaysDate.getMonth() && recDate.getDate() > todaysDate.getDate())
                              )
                    {
                        cnt = 3;
                        console.log(requiredFields[j]);
                        break;
                    }
                    else if((obligLst[i].exObj["POS__c"] && !patt.test(obligLst[i].exObj["POS__c"])) || (obligLst[i].exObj["Loan_Amount__c"] && !patt.test(obligLst[i].exObj["Loan_Amount__c"]))){
                        cnt = 2;
                         break;
                    }
                    
                    
                }
                
            }
            
        }          
        
        
        
        console.log('cnt '+cnt);
        return cnt
        
    },
    monthDiff : function(d1,d2){
         var months;
        months = (d2.getFullYear() - d1.getFullYear()) * 12;
        months -= d1.getMonth() + 1;
        months += d2.getMonth();
        return months <= 0 ? 0 : months;
        
    },
      calcTotalObl : function(component, event) {
   //     var obligationRecId = event.getParam("obligationRecordId");
   //     console.log('obligationRecId ---helper---->> '+obligationRecId);
        console.log('loanAppID ----helper--->> '+component.get("v.oppId"));
		 this.showhidespinner(component,event,true);
        var action = component.get("c.updateCamScam");
        action.setParams({
            "oppId": component.get("v.oppId")
        });
        var self = this;
        action.setCallback(this, function(response){
             self.showhidespinner(component,event,false);
        	var state = response.getState();
        	if (component.isValid() && state === "SUCCESS") {
                console.log('inside success updateCamScam...');
                var camObj = response.getReturnValue();
                //console.log('Total_Mthly_Oblig__c ---->> '+camObj.Total_Mthly_Oblig__c);
                console.log('camObj'+camObj);
                component.set("v.camObj", camObj);
        	}
    	});
        $A.enqueueAction(action);
    },
    
    callPANBre : function(component) {
       // this.showhidespinner(component,event,true);
        this.executeApex(component, "retriggerPANBRE",{"loanid":component.get("v.oppId")                                                
                                                 },
                         function(error, result){
                             
                             // var result = response.getReturnValue();
                             console.log('result -->'+result);
                             
                            
                             
                         }                                                                          
                        ); 
},
 // Added for Ext prod issue Rohit start
    fetchExtDetl : function(component,event){
        var action = component.get("c.fetchExtDet"); 
        console.log('in fetchExtDetl');
        action.setParams({ "oppId" : component.get("v.oppId") });
        
        action.setCallback(this, function(response) {
        	var state = response.getState();
            if (state === "SUCCESS") {
                
            	console.log('in ext details',response.getReturnValue());
                
                var responseData = response.getReturnValue();
                if(responseData){
                     var obligLst = new Array();
                    var exObj;
                    for(var i=0;i<responseData.length;i++){
                        exObj = new Object();
                        exObj = responseData[i];
                        if (exObj.EMI__c){
                            var num =parseFloat(exObj.EMI__c);
                            exObj.EMI__c = num.toFixed(2).toString();
                            console.log ('check decimal point='+exObj.EMI__c);
                        }
                        obligLst.push({"exObj":exObj,"deleteRecord":false,"startDate":exObj.Start_On__c});
                        
                    }
                    component.set("v.obligLst",obligLst);
                    console.log('obligLst-----'+obligLst);
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);

    },
    // Added for Ext prod issue Rohit stop   
    
})