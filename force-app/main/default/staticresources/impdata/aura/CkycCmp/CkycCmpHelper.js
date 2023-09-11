({
    fetchData : function(component, event) {
        try {
            event.preventDefault();
             event.stopPropagation();
        } catch (e) {
            console.log('event issue ' + e);
        }
        var params = new Object();
        console.log(component.get("v.ckycFlow").flowtype);
        params["flowtype"] = "detail";//component.get("v.ckycFlow").flowtype; // Bug Id : 24716
        params["object"] = component.get("v.ckycFlow").object;//component.get("v.ckycFlow").object+'_CkycConfig'; // Bug Id : 24716
        params["resource"] = component.get("v.ckycFlow").resource; // Bug Id : 24716
        params["**RecordIdentifier**"] = component.get("v.Product");//11371 passed product to first API
        params["**ApplicationFormNo**"] = "";//component.get("v.poiNumber");
        params["**InputIdNo**"] = component.get("v.poiNumber");
         params["**InputIdType**"] = component.get("v.poi");
        params["api"] = "search";
        console.log('component.get("v.recordId") --> ' , component.get("v.recordId"));
        params["**RequestId**"] = component.get("v.recordId");
        params["mobNo"] = component.get("v.mobNo");
        params["smsName"] = "CKYC Alert";
        params["receiver"] = "Customer";
        params["**TransactionId**"] = "12345";
        params["**BranchCode**"]="";
        //params["**RequestId**"] = "12345";// US : 13265 S
        var fourdigitsrandom = Math.floor(1000 + Math.random() * 10000);
        if(!$A.util.isEmpty(fourdigitsrandom)) {
            params["**RequestId**"] = fourdigitsrandom+'';
        }// US : 13265 E
        
        var self = this;
        var searchData = null; var searchRes = null;// US : 13265
        this.executeApex(component,"callCkycApi",{"paramsMap":params},function(error,result){
            //self.showhidespinner(component,event,false); // Bug Id : 24716
            //component.set("v.Spinner", true); // Bug Id : 24716
            var response = JSON.parse(result);
            try {
                if(!error && response.status == "SUCCESS"){
                    searchData = response.respMap;// US : 13265
                    component.set("v.isSearchDone",true);
                    console.log('search response');
                    console.log(response.respMap["TransactionStatus"] );
                    if(response.respMap && response.respMap["TransactionStatus"] != "CKYCRejected" && response.respMap["RequestStatus"] != "RejectedByTW"){
                        component.set("v.isfirstRespfetched",true);
                        var ckycPhoto = response.respMap["CKYCPhoto"];
                        component.set("v.ckycPhoto",ckycPhoto);
                        response.respMap["CKYCPhoto"] = "<!DOCTYPE html><html><body><img src=data:image/jpeg;base64,"+ckycPhoto+ ' width="150" height="150"/>' +'</body></html>';
                        console.log(response.respMap["CKYCPhoto"]);
                        // US : 13265 S
                        console.log('****CKYCPhotoBytes--> '+searchData["CKYCPhotoBytes"]);
                        if(searchData["CKYCPhotoBytes"]){
                            //console.log('****ckycPhoto--> '+searchData["CKYCPhoto"])
                            delete searchData["CKYCPhotoBytes"];
                        }
                        if(searchData["CKYCPhoto"]){
                            //console.log('****ckycPhoto--> '+searchData["CKYCPhoto"])
                            delete searchData["CKYCPhoto"];
                        }
                        // US : 13265 E
                        component.set("v.searchResp",response.respMap);
                        console.log('search response');
                        console.log(component.get("v.searchResp"));
                        component.set("v.ckycsmsLst",response.ckycsmsLst);
                        // Bug Id : 24716 added common spinner
                        self.showhidespinner(component,event,false);
                        //component.set("v.Spinner", false);// Bug Id : 24716
                        searchRes = 'CKYC details fetched';// US : 13265
                        self.displayToastMessage(component,event,"Success","Search Completed !",'success');
                    }
                    else{
					     component.set("v.isCkycAttempted",true);//added for US 21328
                         component.set("v.isfirstRespfetched",false);
                        component.set("v.dataSource","CKYC Search");//US11371
                       if(response.respMap["TransactionStatus"] == 'CKYCRejected' && response.respMap["TransactionRejectionDescription"] != 'No record found'){
                            // Bug Id : 24716 added common spinner
                            self.showhidespinner(component,event,false);
                            //component.set("v.Spinner", false);// Bug Id : 24716
	                        self.displayToastMessage(component,event,'Error',response.respMap["TransactionRejectionDescription"],'error');
                        }
                        //Added by Rohan
                        else if((response.respMap["RequestStatus"] == "CKYCRejected" || response.respMap["TransactionStatus"] == 'CKYCRejected') && response.respMap["TransactionRejectionDescription"] == 'No record found'){
                            
                             // Bug Id : 24716 added common spinner
                            self.showhidespinner(component,event,false);
                            //component.set("v.Spinner", false);// Bug Id : 24716
                            self.displayToastMessage(component,event,'Success','No Record found in CKYC.Kindly proceed!','success');                            
						}
                        //Ended by Rohan
                        else if(response.respMap["RequestStatus"] == "RejectedByTW"){
                            component.set("v.dataSource","CKYC Search");//US11371
                            // Bug Id : 24716 added common spinner
                            self.showhidespinner(component,event,false);
                            //component.set("v.Spinner", false);// Bug Id : 24716
                            self.displayToastMessage(component,event,'Error',response.respMap["RequestRejectionDescription"],'error');                            
                        }
                        searchRes = 'CKYC details not found';// US : 13265
                    }
                }
                else{
				 component.set("v.isCkycAttempted",true);//added for US 21328
                    component.set("v.dataSource","CKYC Search");//US11371
                    component.set("v.isfirstRespfetched",false);
                    // Bug Id : 24716 added common spinner
                    self.showhidespinner(component,event,false);
                   // component.set("v.Spinner", false);// Bug Id : 24716
                    searchRes = 'CKYC details not found';// US : 13265
                    self.displayToastMessage(component,event,'Error','Internal Server Error , Please try again later','error');
                }
                // US : 13265 Start
                console.log("searchData --> ", searchData);
                var ckycEvent = $A.get("e.c:CkycSearchInfo");
				ckycEvent.setParams({"SearchInfo":searchData, "dSource":searchRes});
				ckycEvent.fire();
                // US : 13265 End
            }catch(err) {
                // Bug Id : 24716 added common spinner
                self.showhidespinner(component,event,false);
               // component.set("v.Spinner", false);// Bug Id : 24716
                self.displayToastMessage(component,event,'Error','Internal server error :'+err.message,'error');   
            }
        });
        
        
    },
    fetchCkyc: function(component, event) {
        try {
            event.preventDefault();
             event.stopPropagation();
        } catch (e) {
            console.log('event issue ' + e);
        }
        console.log('in helper');
        // Bug Id : 24716 added common spinner
          this.showhidespinner(component,event,true);
         /*if(component.get("v.ckycFlow").flowtype != 'Salaried'){
            	component.set("v.Spinner",true);
            }
            else{
                this.showhidespinner(component,event,true); // Bug Id : 24716
            }*/
            //this.showhidespinner(component,event,true); // Bug Id : 24716
          //  component.set("v.Spinner",true); // Bug Id : 24716
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var params = new Object();
        var dob = component.get("v.dateOfBirth");
        var formatted_date = dob.split('-');
        console.log('in helper2 '+months[parseInt(formatted_date[1]-1)]);
        /*params["flowtype"] ="Salaried";// component.get("v.ckycFlow").flowtype;
        params["object"] = component.get("v.ckycFlow").object;//component.get("v.ckycFlow").object+'_CkycConfig';//component.get("v.ckycFlow").object;*/
        params["flowtype"] = "detail";//component.get("v.ckycFlow").flowtype; // Bug Id : 24716
        params["object"] = component.get("v.ckycFlow").object;//component.get("v.ckycFlow").object+'_CkycConfig'; // Bug Id : 24716
        params["resource"] = component.get("v.ckycFlow").resource; // Bug Id : 24716
        params["poiType"] = component.get("v.poiType");
        params["poiNum"] = component.get("v.poiNumber");
        params["api"] = "download";
        params["RecId"] = "";
        params["**RequestId**"] = component.get("v.searchResp")["CKYCRequestId"];
        params["**TransactionId**"] = component.get("v.searchResp")["TransactionId"];
        params["**CKYCNumber**"] = component.get("v.searchResp")["CKYCID"];
        var mon = parseInt(formatted_date[1]-1);
        console.log('mon --> ' + mon);
        console.log('months --> ' + months[mon]);
        debugger;
         //Rohit added for dob issue start
        var mon = parseInt(formatted_date[1]-1)+1;
        
         var monStr = mon+'';
        if(mon<10){
            monStr = '0'+mon;           
        }
         //Rohit added for dob issue stop
        params["**DOB**"] = formatted_date[2]+'-'+monStr+'-'+formatted_date[0];
        //params["**DOB**"] = months[d.getMonth()];
        params["mobNo"] = component.get("v.mobNo");
        console.log('in helper2 '+params["**DOB**"]);
        var smsMap = new Map();
        smsMap["param1"] = 'test1';
        params["smsParams"] = JSON.stringify(smsMap);
        
        var self = this;
        
        this.executeApex(component,"callCkycApi",{"paramsMap":params},function(error,result){
            var response = JSON.parse(result);
            try {
                console.log('download response');
                console.log(response);
                // Bug Id : 24716 added common spinner
                this.showhidespinner(component,event,false);
               // component.set("v.Spinner",false);// Bug Id : 24716
                if(!error && response.status == "SUCCESS"){                 
                    debugger;
                    console.log(response.fieldsMap);
                    component.set("v.downResp",response.respMap);
                    var downResp = component.get('v.downResp');
                    console.log(downResp["TransactionStatus"]);
                    if(downResp && downResp["TransactionStatus"] && downResp["TransactionStatus"] != "CKYCRejected" && downResp["RequestStatus"] != "RejectedByTW"){
                        //downResp["CKYCPhoto"] = component.get("v.searchResp").CKYCPhoto;
                        downResp["CKYCPhoto"] = component.get("v.ckycPhoto");
                        downResp["mobNo"] = component.get("v.mobNo");
                        downResp["object"] = component.get("v.ckycFlow").object;// Bug Id : 24716
                        component.set("v.downResp",downResp);
                        var res = 'Copy data from CKYC';// US : 13265
                        var ckycEvent = $A.get("e.c:shareCkycInfo");
                        ckycEvent.setParams({"infObj":component.get("v.downResp"),"ckycsmsLst":component.get("v.ckycsmsLst"),"dSource":res});// US : 13265
                        ckycEvent.fire();
                        debugger;
                        self.displayToastMessage(component,event,'Success','Ckyc data fetched successfully !','success');
                    }
                    else{
                        self.displayToastMessage(component,event,'Error',downResp["TransactionRejectionDescription"],'error');
                        var res = 'CKYC Download Failure';// US : 13265
                        var ckycEvent1 = $A.get("e.c:CkycSearchInfo");// US : 13265
				        ckycEvent1.setParams({"dSource":res,"downInfo":downResp});// US : 13265
				        ckycEvent1.fire();// US : 13265
                    }
                }
                else{
                    console.log('error --> ', error);console.log('response --> ', response);// US : 13265
                    self.displayToastMessage(component,event,'Error',response,'error');//downResp["TransactionRejectionDescription"]// US : 13265
                    var res = 'CKYC Download Failure';// US : 13265
                    var ckycEvent1 = $A.get("e.c:CkycSearchInfo");// US : 13265
			        ckycEvent1.setParams({"dSource":res,"downInfo":response});// US : 13265
			        ckycEvent1.fire();// US : 13265
                    //self.displayToastMessage(component,event,'Error',downResp["TransactionRejectionDescription"],'error');
                }
            }catch(err) {
                self.displayToastMessage(component,event,'Error','Internal server error :'+err.message,'error');   
                var res = 'CKYC Download Failure';// US : 13265
                var ckycEvent1 = $A.get("e.c:CkycSearchInfo");// US : 13265
		        ckycEvent1.setParams({"dSource":res,"downInfo":'Internal server error :'+err.message});// US : 13265
		        ckycEvent1.fire();// US : 13265
            }
            
        });
        
    },
    setResponseData: function(component, fieldsMap) {
        var popResp = new Object();
        var downResp = component.get("v.downResp");
        for(var key in downResp){            
            for(var obj in fieldsMap){
                popResp[obj] = new Object(); 
                for(var field in fieldsMap[obj]["ResponseIdentifier"]){
                    console.log('fields');
                    if(field == key){                        
                        popResp[obj][fieldsMap[obj]["ResponseIdentifier"][field]] = downResp[key];
                    }                    
                }
            }
        }
        
        console.log(popResp);
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        debugger;
        console.log('displayToastMessage -->');
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent) {
            console.log('needhi standard toast -->');
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        } else {
            console.log('needhi custom mobility toast which causes issue -->');
            var showhideevent =  $A.get("e.c:ShowCustomToast");
            if (showhideevent != undefined) {
                showhideevent.setParams({
                    "title": title,
                    "message":message,
                    "type":type
                });
                showhideevent.fire();
            }
        }
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
        console.log('in showhidespinner');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    
    // Bug Id : 24716 Start
     validatepanField: function(component,event) {
         var panValid = true;
         if((component.get("v.poiType") == 'PAN')){
            component.set("v.poiNumber", (component.get("v.poiNumber") || "").toUpperCase()); 
            var pattern = /[A-Za-z]{5}\d{4}[A-Za-z]{1}/ ;
            var panValue = component.get("v.poiNumber");
            panValid = !!(panValue == '' || pattern.test(panValue.trim()));
             if(panValid == false){
             	this.displayToastMessage(component,event,"Error","Please Enter Valid PAN","error");   

             }
         } 
        return panValid;
    }
    // Bug Id : 24716 End

})