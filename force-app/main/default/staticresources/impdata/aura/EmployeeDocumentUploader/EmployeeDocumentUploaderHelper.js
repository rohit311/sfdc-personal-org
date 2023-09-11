({
		getDocList : function(component,event) {
            this.showhidespinner(component,event,true);
			var appId = component.get("v.applicantObj.Id"); //DMS change 24317 added  applicantObj.Id
        console.log('Id is:::'+appId);
        if(appId != null){
            this.executeApex(component, "getDocumentList", {
               "appId" : appId //DMS change 24317 added  applicantObj.Id
            }, function (error, result) {
                
                if (!error && result) { 
                    console.log('Documents list'+result);
                    var objlst = JSON.parse(result);
                    var selectedList=[];
                    console.log('docList'+objlst);
                    if(!$A.util.isEmpty(objlst)){
                        component.set("v.DocumentList",objlst);
                        objlst.forEach(selectedDocNames => {
                            if(selectedDocNames.isUploaded == false){
                            	selectedList.push(selectedDocNames.docName);
                        	}
						});
                        component.set("v.DocumentSelectList",selectedList);
                    }
                    this.showhidespinner(component,event,false);
                            this.showhidespinner(component,event,false);    
                }
                else{
                    console.log('error is '+error);
                                this.showhidespinner(component,event,false);
                }
            });
        }
		},
    getOppData : function(component, event){
      var oppId = component.get("v.oppId");
        if(oppId != null){
            this.executeApex(component, "getDisbursmentData", {
                "oppId" : oppId
            }, function (error, result) {
                
                if (!error && result) {
                    console.log('result '+result);
                    var objlst = JSON.parse(result);
                    if(objlst.opp.StageName == 'Branch Ops' || objlst.opp.StageName == 'Moved To Finnone'){
                        console.log('inside read only condition');
                    	component.set("v.displayReadOnly",true);
                    }
                    else{
                        component.set("v.displayReadOnly",false);
                    }
                }
                else{
                    console.log('error id:::'+error); 
                }
            });
        }
        else{
            console.log('No loan Id');
        }
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
        console.log('inside parent show hide '+showhide);
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },/*DMS 24317 s*/
    getDMSDocuments : function(component, event){
        var product=component.get("v.applicantObj.Loan_Application__r.Product__c");
        console.log('DMS Prod '+product);
         this.executeApex(component, "getDMSDocuments", {
             "product":product
        }, function (error, result) {
            if (!error && result) {
               component.set("v.DMSDocmap",result);
               console.log('DMS result '+JSON.stringify(result));
                  console.log('DMS resultsss '+component.get("v.DMSDocmap"));
                
            }
            else{
                console.log('DMS invalid file name');
            }
        });
    }
})