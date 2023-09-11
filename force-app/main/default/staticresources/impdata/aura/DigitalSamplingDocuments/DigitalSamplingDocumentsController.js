({
    doInit : function(component, event, helper) {
        console.log('in doint');
        //24316
       if(component.get("v.isMobility")){
        var arr=[];
        var action2 = component.get("c.getStatResourceData");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            var result ='';
            if (state === "SUCCESS") { 
                result = response.getReturnValue();
                for(var key in result) {
                    //if(key=="MobilitySamplingDocuments"){
                        var map =result[key];
                        var keyvalue = new Map();
                        for(var key1 in map) {
                            arr.push(key1);
                            keyvalue.set(key1,map[key1]);
                        }
                        component.set("v.docNameValueMapMob", keyvalue);
                   // }
                }
                  component.set("v.DocTypeValuesMob" , arr);
                  console.log('stat rsorce1 map>>'+component.get("v.DocTypeValuesMob"));
            }
        })
        $A.enqueueAction(action2);
    
       /* var action1 = component.get("c.getChecklistDoc");
        var tempId = component.get("v.loanID");
        component.set("v.loanIDStr",new String(tempId));
        console.log('oppId checklist>>'+component.get("v.loanIDStr"));

        action1.setParams({
            "oppId" : component.get("v.loanID")
        });
        action1.setCallback(this, function(response){
            console.log('checklist method');
            var state = response.getState();
            console.log('checklist state::'+state);
            if (state == "SUCCESS") {
                console.log('generate checklist result');
                console.log(response.getReturnValue());
                var data = JSON.parse(response.getReturnValue());
                if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.checklistdocument)){
                    //var docList =[],docmap ={},docmapwithoutdelete = {},docCountMap = {};
                    if(!$A.util.isEmpty(data.checklistdocument.standardDoc)){
                        component.set("v.standardChecklist",data.checklistdocument.standardDoc);
                        var strdoc= JSON.stringify(component.get("v.standardChecklist"));
                        console.log('document added::'+strdoc);
                    }
                }
            }
        })
        $A.enqueueAction(action1);*/
         }  //24316
        
        helper.showhidespinner(component,event,true);
        var action = component.get("c.getDGApplicants");
        var appSelectList = ["Document_Type__c","Document_Name__c"];
        var selectListNameMap = {};
        selectListNameMap["ContentVersion"] = appSelectList;
        action.setParams({ loanID : component.get("v.loanID") ,"objectFieldJSON" : JSON.stringify(selectListNameMap),"isMobility":component.get("v.isMobility")});//24316
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            var result ='';
            if (state === "SUCCESS") {
                
                var temp = response.getReturnValue();
                //alert(temp);
                var arrayOfMapKeys = [];
                var arrayOfSubmitButtonMapKeys = [];
                if(temp != null)
                {
                    result = JSON.parse(temp);
                    console.log("result --> " + result);
                    
                    component.set("v.sampledataList",result);
                    console.log(component.get("v.sampledataList"));
                    var temptemop=component.get("v.sampledataList");
                    var uniqueIdToCVMap;
                    var ShowVendorPDF = false;
                    var VendorPDFId ='';
                    if(!$A.util.isEmpty(temptemop)){
                        uniqueIdToCVMap = temptemop[0].AppDetailToCVMap;
                        var tempstring = temptemop[0].Vendor_PDF_Status;
                        var disableSubmitButton = temptemop[0].disableSubmitButton;
                        component.set("v.disableSubmitButton" , disableSubmitButton);
                        var digitalSamplingStatus = temptemop[0].digitalSamplingStatus;
                        if(digitalSamplingStatus != null){
                            component.set("v.showDGStatus" , true);
                            component.set("v.digitalSamplingStatus" , digitalSamplingStatus);
                        }
                        else{
                            component.set("v.showDGStatus" , false);
                        }
                        console.log(temptemop[0].Vendor_PDF_Status);
                        var strarray;
                        if(tempstring != undefined && tempstring != null)
                        	strarray = tempstring.split("_");
                        console.log(strarray[0] != '' && strarray[0] == 'true');
                        if(strarray[0] != '' && strarray[0] == 'true')
                        {
                           
                            ShowVendorPDF = true;
                            var temp = component.get("v.ShowVendorPDF");
                            console.log(temp);
                            component.set("v.ShowVendorPDF",ShowVendorPDF);
                             console.log('in 1st');
                            
                        }
                        if(strarray[1] != null && strarray[1] != 'null')
                        {
                            VendorPDFId = strarray[1];
                           component.set("v.VendorPDFId",VendorPDFId);
                            console.log('VendorPDFId');
                            console.log(component.get("v.VendorPDFId"));
                        }
                        
                    }
                    console.log("uniqueIdToCVMap");
                    console.log(uniqueIdToCVMap);
                    component.set("v.uploadedDataMap" , uniqueIdToCVMap);
                    for (var singlekey in uniqueIdToCVMap) 
                    {
                        arrayOfMapKeys.push(singlekey);
                    }
                    console.log(arrayOfMapKeys);
                    component.set("v.uploadedDataMapKey", arrayOfMapKeys);
                    var SubmitButtonMap;
                    if(!$A.util.isEmpty(temptemop))
                        SubmitButtonMap = temptemop[0].uniqueIdToShowSubmitMap;
                    component.set("v.submitButtonMap" , SubmitButtonMap);
                    console.log(temptemop.length);
                    var idss = component.get("v.Appids");
                    for(var i=0; i<temptemop.length; i++)
                    {	
                        var temp = temptemop[i];
                        console.log(temp);
                        idss.push(temp.appli.Id);
                    }
                    component.set("v.Appids",idss);
                    console.log(component.get("v.Appids"));
                    var maptemp ={};
                    var picklistvalue ='';
                    if(!$A.util.isEmpty(temptemop))
                    	maptemp= temptemop[0].docTypeDependValues;
                    if(!$A.util.isEmpty(temptemop))
                    	picklistvalue = temptemop[0].DoctypeLst;
                    console.log('picklistval'+picklistvalue);
                    console.log(maptemp);
                    if(!$A.util.isEmpty(maptemp))
                        component.set("v.DocNameValuesMap",maptemp)
                        
                        
                        console.log(component.get("v.DocNameValuesMap"));
                    
                }
                
            }
            helper.showhidespinner(component,event,false);
        })
        $A.enqueueAction(action);
        helper.fetchPicklistValues(component,event);
        
    },
     toggleAssVersion : function(component, event, helper)
    {
        console.log("inside toggleAssVersion");
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        console.log(click);
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        console.log(cls);
        if(cls=='hideCls'){
            console.log('here before set '+component.get("v.isMobility"));
            
                
            component.set('v.class','showCls');
                
            
            
           console.log(component.get("v.class"));
            
        }else{
            component.set('v.class', 'hideCls');
        }
        console.log('out here');
		component.set("v.DocNameValues" , []);
        /*component.set("v.DocTypeValues" , []);
        console.log(component.get("v.DocNameValues"));
        console.log(component.get("v.DocTypeValues"));
        helper.fetchPicklistValues(component,event);
        console.log(component.get("v.DocNameValues"));
        console.log(component.get("v.DocTypeValues"));*/
        
    },
    
    changeValues : function(component, event, helper) {
        var nname = event.getSource().get("v.name");
        var sampledatalist = component.get("v.sampledataList");
        var rec = sampledatalist[nname];
        var controllingField=event.getSource().get("v.value");
        //24316 start
        if(component.get("v.isMobility")){
            var keyvalue = component.get("v.docNameValueMapMob");
            var get_keys = keyvalue.keys(); 
            for(var ele of get_keys){
                if(ele == controllingField){
                    var str = keyvalue.get(ele).split(';');
                    var strarr=[];
                    for(var temp in str){
                          strarr.push(str[temp]);
                    }
                    component.set("v.DocNameValuesMob" , strarr);
                    break;
                }
            }  
            console.log('final values:'+component.get("v.DocNameValuesMob"));
        }
        //24316 stop
        
        var docmap = component.get("v.DocNameValuesMap");
        var namelist = docmap[controllingField];
        rec.DocTypeSelect = controllingField;
        rec.DocNameLst = namelist;
        component.set("v.DocNameValues" , rec.DocNameLst);
        sampledatalist[nname] = rec;
        component.set("v.sampledataList",sampledatalist);
    },
    
    handleComponentEvent: function(component, event ) {
        //alert('in handle component event');
        var docLst = event.getParam("selectedDocs");
        var appNo = event.getParam("AppNo");
        var LgRegNo = event.getParam("lgRegNo");
        console.log("appNo --> " + appNo);
        console.log("LgRegNo --> " + LgRegNo);
        var cmp = component.find("uploadDocs");
        
        //helper.showhidespinner(cmp,event,true);
        component.set("v.uploadedDocs" , docLst );
        console.log("uploaded docs main cmp --> " + docLst);
        var action = component.get("c.SubmitDocToLG");
        action.setParams({ "CVIDs" : docLst,"ApplicationNo":appNo,"LGId" :LgRegNo,"LoanId" : component.get("v.loanID")});
        action.setCallback(this , function(response){
            var state =  response.getState();
            console.log("State 1 --> " + state);
            var result ='';
            if (state == "SUCCESS") 
            {
                var storeResponse = response.getReturnValue();
                var uniqueIdToCVMap = {};
                var SubmitButtonMap  = {};
                console.log(storeResponse);
                result = JSON.parse(storeResponse);
                 console.log(result); 
                 if(!$A.util.isEmpty(result) && !$A.util.isEmpty(result.AppDetailToCVMap)){
                        uniqueIdToCVMap = result.AppDetailToCVMap;
                		component.set("v.uploadedDataMap" , uniqueIdToCVMap);
                }
                console.log('after 1');
                var msg = '';
                if(!$A.util.isEmpty(result) && !$A.util.isEmpty(result.resultString))
                    msg = result.resultString;
                console.log("Message from digital sampling document");
                console.log(msg);
                console.log('after 2');
               /* if(!$A.util.isEmpty(result) && !$A.util.isEmpty(result.uniqueIdToShowSubmitMap)){
                        SubmitButtonMap = uniqueIdToShowSubmitMap.uniqueIdToShowSubmitMap;
                    	component.set("v.submitButtonMap" , SubmitButtonMap);
                }*/
                console.log('after 3');
                var closeLoader = $A.get("e.c:LoaderClose");
				//alert('before close loader');
                closeLoader.setParams({
                    "message" : msg
                });
                console.log(closeLoader);
                closeLoader.fire();
               	//alert('after close loader event');
              
            }
            // helper.showhidespinner(cmp,event,false);
            
            
        });
        
        $A.enqueueAction(action);        
        
        
    },
    
    vendorPDFDownload: function(component, event, helper) {
        console.log('Inside vendorPDFDownload');
        window.open(component.get("v.VendorPDFId"));
    },
    
    markApplicationComplete: function(component, event, helper) {
    	console.log('from Mark Complete');
        helper.showhidespinner(component,event,true);
        var action = component.get("c.markLoanAppCompelete");
        action.setParams({loanId : component.get("v.loanID")
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('State');
            console.log(state);
            if (state == "SUCCESS"){
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                var status = storeResponse.split('_')[0];
                //var status = 'SUCCESS';
                var msg = storeResponse.split('_')[1]
                console.log(status);
                if(status == 'SUCCESS'){
                    component.set("v.disableSubmitButton",true);
                }
                helper.showhidespinner(component,event,false);
                helper.displayToastMessage(component,event,"Message",msg,"message");
                
            }
            else{
                helper.showhidespinner(component,event,false);
                helper.displayToastMessage(component,event,"Message","Internal Server Error","message");
            }
            
        })
        $A.enqueueAction(action);
    },
})