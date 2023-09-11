({
    getDocuments : function(component, event,bothDeviDoc) {
        
        var action = component.get('c.generateChecklistDoc');
        console.log('oppId>>'+component.get('v.oppId'));
        action.setParams({
            "oppId" : component.get('v.oppId'),
            "bothDeviDocFlag":bothDeviDoc
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('generate checklist result');
                console.log(response.getReturnValue());
                var data = JSON.parse(response.getReturnValue());
                if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.checklistdocument)){
                    /*  if(!$A.util.isEmpty(data.ErrorMessage)){
                    //this.hideSpinner(component);
                    console.log('generate checklist result1');
                    console.log(response.getReturnValue());
                    alert('Error while processing!');
                    //	this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
                }
                else {*/
                    var docList =[],docmap ={},docmapwithoutdelete = {},docCountMap = {};
                    if(!$A.util.isEmpty(data.checklistdocument.standardDoc)){
                        component.set("v.standardChecklist",data.checklistdocument.standardDoc);
                        var stdChecklist = component.get("v.standardChecklist");
                        for(var i=0;i<stdChecklist.length;i++){
                            docCountMap[stdChecklist[i].docName] = stdChecklist[i].docCount;
                            docList.push(stdChecklist[i].docName);
                            docmap[stdChecklist[i].docFamObj.Id] = stdChecklist[i].docName;
							docmapwithoutdelete[stdChecklist[i].docFamObj.Id] = stdChecklist[i].docName;
                        }
                    }
                    
                    if(!$A.util.isEmpty(data.checklistdocument.deviationDoc)){
                        component.set("v.deviationChecklist",data.checklistdocument.deviationDoc);
                        /*var devChecklist = component.get("v.deviationChecklist");
                        for(var i=0;i<devChecklist.length;i++){
                            docCountMap[devChecklist[i].deviationName] = devChecklist[i].docCount;
                            docList.push(devChecklist[i].deviationName);
                            docmap[devChecklist[i].docFamObj.Id] =devChecklist[i].deviationName;
							docmapwithoutdelete[devChecklist[i].docFamObj.Id] =devChecklist[i].deviationName;
                        }*/
                    }
                    
                    /* if(!$A.util.isEmpty(data.standardDoc))
                	component.set("v.standardChecklist",data.standardDoc);
                    if(!$A.util.isEmpty(data.deviationDoc))
                        component.set("v.deviationChecklist",data.deviationDoc);*/
                    
                    if(!$A.util.isEmpty(docList)){
                        component.set("v.DocumentNameList",docList);
                        if(!$A.util.isEmpty(data.attchements)){
                            var attachments = data.attchements;
                            console.log('attachments : '+ attachments);
                            component.set("v.uploadedAttachments", attachments);
                            if(attachments.length > 0){
                                
                                
                                for(var i=0;i< attachments.length ;i++) {
                                    console.log('nameeeeee>>>'+attachments[i].Name);
                                    console.log('nameeeeee>>>'+attachments[i].Name+attachments[i].Title);
                                    var DocName = '';
                                    if(!$A.util.isEmpty(attachments[i].Name))
                                        DocName = attachments[i].Name;
                                    else if(!$A.util.isEmpty(attachments[i].Title))
                                        DocName = attachments[i].Title;
                                    if(!$A.util.isEmpty(DocName)){
                                        DocName = DocName.split("|")[0];
                                        var j = docList.indexOf(DocName);
                                        if(j != -1) {
                                            docList.splice(j, 1);
                                        }
                                        for (var key in docmap){
                                            if(docmap[key] == DocName){
                                                delete docmap[key];
                                                
                                            }
                                        }
                                    } 
                                }
                                component.set("v.DocumentNameList",docList);
                            }
                            
                        }
                        console.log('firing event'+docList.length);
                        console.log(docmap);
                        var evt = $A.get("e.c:DocNameList");
                        evt.setParams({
                            "DocNameList" : component.get("v.DocumentNameList"),
                            "DocumentNameMap" : docmap,
							"AllDocumentNameMap" :docmapwithoutdelete,
                            "docCountMap" : docCountMap
                        });
                        evt.fire(); 
                        
                        
                        
                    }
                    if(!$A.util.isEmpty(data.checklistdocument.picklistDataList) && !$A.util.isEmpty(data.checklistdocument.picklistDataList[0].picklistData)){   
                        var picklistFields = data.checklistdocument.picklistDataList[0].picklistData;
                        var checklistPickFlds = picklistFields["Checklist__c"];
                        console.log(checklistPickFlds);
                        console.log( checklistPickFlds["Sales_Status__c"]);
                        component.set("v.statusList", checklistPickFlds["Sales_Status__c"]);
                    }
                    
                    
                    console.log(data.standardDoc);
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Success','Documents and deviations generated successfully.','success');
                    //  this.hideSpinner(component);
                    //alert('Documents and deviations generated successfully.');
                    //  this.displayMessage(component, 'displaysuccessToast','displaysuccessMsg', '<b>Success!</b> Documents and deviations generated successfully.');
                    
                }
				else{
					this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Error in generating documents and deviations.','error');
				}
                
            }
            else{
                // this.hideSpinner(component);
                this.showhidespinner(component,event,true);
                this.displayToastMessage(component,event,'Error','Error in generating documents and deviations','error');
                    
                //  this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
            }
            
        });
        $A.enqueueAction(action);
    },
    savemanualDev : function(component, event) {
        console.log('here save');
        var action = component.get('c.saveManDev');
        action.setParams({
            deviationList : JSON.stringify(component.get('v.manualChecklist'))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('SON.parse(response.getReturnValue())>>');
            console.log(JSON.parse(response.getReturnValue()));
            if (state === "SUCCESS") {
                this.displayToastMessage(component,event,'Success','Manual deviations saved successfully','success')
            }
            else{
                this.displayToastMessage(component,event,'Error','Failed to save deviations','error')
            }
            this.showhidespinner(component,event,false);
        });
        $A.enqueueAction(action);
        
    },
    saveautoDev : function(component, event) {
        console.log('here save');
        var action = component.get('c.saveAutoDev');
        action.setParams({
            deviationList : JSON.stringify(component.get('v.deviationChecklist'))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('SON.parse(response.getReturnValue())>>');
            console.log(JSON.parse(response.getReturnValue()));
            if (state === "SUCCESS") {
                this.displayToastMessage(component,event,'Success','Deviations saved successfully','success')
            }
            else{
                this.displayToastMessage(component,event,'Error','Failed to save deviations','error')
            }
            this.showhidespinner(component,event,false);
        });
        $A.enqueueAction(action);
        
    },
    addDev : function(component, event) {
        var devSelected = component.get("v.devSelected");
        console.log('devselected'+devSelected);
        if($A.util.isEmpty(devSelected)){
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Please select deviation','error');
        }
        else{
            var action = component.get('c.saveDeviation');
            action.setParams({
                devSelected : devSelected,
                oppObj : JSON.stringify(component.get('v.Oppobj')) ,
                appObj : JSON.stringify(component.get('v.appObj')) 
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('SON.parse(response.getReturnValue())>>');
                console.log(JSON.parse(response.getReturnValue()));
                if (state === "SUCCESS") {
                    this.displayToastMessage(component,event,'Success','Deviation added successfully','success')
                    var data = JSON.parse(response.getReturnValue());
                    if(!$A.util.isEmpty(data.checklistdocument)){
                        if(!$A.util.isEmpty(data.checklistdocument.manualDoc)){
                            component.set("v.manualChecklist",data.checklistdocument.manualDoc);
                        }
                    }
                }
                this.showhidespinner(component,event,false);
            });
            $A.enqueueAction(action);
        }
        
    },
    getChecklistDocOnload : function(component, event) {
        var action = component.get('c.getDocOnLoad');
        console.log('oppId>>'+component.get('v.Oppobj').Id);
        action.setParams({
            Oppobj : JSON.stringify(component.get('v.Oppobj')) 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('SON.parse(response.getReturnValue())>>');
            console.log(JSON.parse(response.getReturnValue()));
            if (state === "SUCCESS") {
                var data = JSON.parse(response.getReturnValue());
                if(!$A.util.isEmpty(data.devList)){
                    component.set("v.devList",data.devList);
                }
                if(!$A.util.isEmpty(data.checklistdocument)){
                    var docList =[],docmap ={},docmapwithoutdelete = {},docCountMap = {};
                    if(!$A.util.isEmpty(data.checklistdocument.manualDoc)){
                        component.set("v.manualChecklist",data.checklistdocument.manualDoc);
                    }
                    if(!$A.util.isEmpty(data.checklistdocument.standardDoc)){
                        component.set("v.standardChecklist",data.checklistdocument.standardDoc);
                        var stdChecklist = component.get("v.standardChecklist");
                        for(var i=0;i<stdChecklist.length;i++){
                            console.log(stdChecklist[i].docName+stdChecklist[i].docCount);
                            docCountMap[stdChecklist[i].docName] = stdChecklist[i].docCount;
                            docList.push(stdChecklist[i].docName);
                            docmap[stdChecklist[i].docFamObj.Id] = stdChecklist[i].docName;
							docmapwithoutdelete[stdChecklist[i].docFamObj.Id] = stdChecklist[i].docName;
                        }
                    }
                    
                    if(!$A.util.isEmpty(data.checklistdocument.deviationDoc)){
                        component.set("v.deviationChecklist",data.checklistdocument.deviationDoc);
                        /*var devChecklist = component.get("v.deviationChecklist");
                        for(var i=0;i<devChecklist.length;i++){
                            console.log(devChecklist[i].deviationName+devChecklist[i].docCount);
                            docCountMap[devChecklist[i].deviationName] = devChecklist[i].docCount;
                            docList.push(devChecklist[i].deviationName);
                            docmap[devChecklist[i].docFamObj.Id] =devChecklist[i].deviationName; 
							docmapwithoutdelete[devChecklist[i].docFamObj.Id] = devChecklist[i].deviationName;
                        }*/
                    }
                    console.log('docmap'+docmapwithoutdelete);
                    if(!$A.util.isEmpty(data.checklistdocument.picklistDataList) && !$A.util.isEmpty(data.checklistdocument.picklistDataList[0].picklistData)){
                        
                        var picklistFields = data.checklistdocument.picklistDataList[0].picklistData;
                        var checklistPickFlds = picklistFields["Checklist__c"];
                        component.set("v.statusList", checklistPickFlds["Sales_Status__c"]);
                        console.log('Document Picklist****'+checklistPickFlds["documentList"]);
                        console.log('sales status Picklist****'+checklistPickFlds["Sales_Status__c"]);            
                    }
                    console.log('docmap'+docmapwithoutdelete);
                    if(!$A.util.isEmpty(docList)){
                        component.set("v.DocumentNameList",docList);
                        if(!$A.util.isEmpty(data.attchements)){
                            var attachments = data.attchements;
                            console.log('attachments : '+ attachments);
                            component.set("v.uploadedAttachments", attachments);
                            if(attachments.length > 0){
                                
                                
                                for(var i=0;i< attachments.length ;i++) {
                                    console.log('nameeeeeeeeeeeee>>>'+attachments[i].Title);
                                    var DocName = '';
                                    if(!$A.util.isEmpty(attachments[i].Name))
                                        DocName = attachments[i].Name;
                                    else if(!$A.util.isEmpty(attachments[i].Title))
                                        DocName = attachments[i].Title;
                                    if(!$A.util.isEmpty(DocName)){
                                        DocName = DocName.split("|")[0];
                                        var j = docList.indexOf(DocName);
                                        if(j != -1) {
                                            docList.splice(j, 1);
                                        }
                                        // if(docmap.has(DocName)){  // (!$A.util.isEmpty(docmap[DocName]))
                                        /*   if(!$A.util.isEmpty(docmap[DocName])){
                                           delete docmap[DocName];
                                        }*/
                                        /*  for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
                                          if (entry.getValue().equals(desiredValue)){
                                            keys.add(entry.getKey());
                                          }
                                        }*/
                                        for (var key in docmap){
                                            if(docmap[key] == DocName){
                                                delete docmap[key];
                                                
                                            }
                                        }
                                        
                                        
                                    } 
                                }
                                component.set("v.DocumentNameList",docList);
                                
                            }
                            
                        }
                        console.log('firing event'+docCountMap);
                        console.log(docmap);
                        var evt = $A.get("e.c:DocNameList");
                        evt.setParams({
                            "DocNameList" : component.get("v.DocumentNameList"),
                            "DocumentNameMap" : docmap,
							"AllDocumentNameMap" :docmapwithoutdelete,
                            "docCountMap" : docCountMap
                        });
                        evt.fire(); 
                        
                    }
                    
                }
                
            }
            this.showhidespinner(component,event,false);
        });
        $A.enqueueAction(action);
    },
    
    UpdateRecords : function(component, checkIds,status) {
        //this.showhidespinner(component,event,true);
        console.log('in helper'+checkIds+'>>status>>'+status);
        if(!$A.util.isEmpty(checkIds) && !$A.util.isEmpty(status)){
            var standardDoc  = component.get("v.standardChecklist");
            var deviationdoc = component.get("v.deviationChecklist");
            console.log(JSON.stringify(component.get("v.standardChecklist")));
            console.log(JSON.stringify(component.get("v.deviationChecklist")));
            for(var i=0;i< standardDoc.length;i++){     
                var j = checkIds.indexOf(standardDoc[i].docFamObj.Id);
                console.log('standardDoc >>'+j+'>>  >>'+standardDoc[i].docFamObj.Id);
                if( j != -1) {
                    
                    if(status == "true")
                        standardDoc[i].docFamObj.Sales_Status__c = 'Received';
                        else if(status == "false")
                            standardDoc[i].docFamObj.Sales_Status__c = 'Pending';
                            }
            }
            for(var i=0;i< deviationdoc.length;i++){     
                var k = checkIds.indexOf(deviationdoc[i].docFamObj.Id);
                console.log('deviationdoc >>'+k+'>>  >>'+deviationdoc[i].docFamObj.Id);
                console.log('before status'+deviationdoc[i].docFamObj.Sales_Status__c);
                if( k != -1) {
                    if(status == "true"){
                        console.log('in if');
                        deviationdoc[i].docFamObj.Sales_Status__c = 'Received';
                    }
                    else if(status == "false"){
                        
                        console.log('in else');
                        deviationdoc[i].docFamObj.Sales_Status__c = 'Pending';
                    }
                             
                }
                console.log('after status'+deviationdoc[i].docFamObj.Sales_Status__c);
            }
            
            var action = component.get('c.savedocuments');
            action.setParams({
                "oppId" : component.get('v.oppId'),
                "standardDoc" : JSON.stringify(component.get("v.standardChecklist")),
                "deviationDoc" : JSON.stringify(component.get("v.deviationChecklist"))
            });
            action.setCallback(this, function(response){
                //this.hideSpinner(component);
                var state = response.getState();
                if (state == "SUCCESS") {
                    console.log('success');
                    component.set("v.standardChecklist",standardDoc);
            component.set("v.deviationChecklist",deviationdoc);
            console.log(JSON.stringify(component.get("v.standardChecklist")));
            console.log(JSON.stringify(component.get("v.deviationChecklist")));
                   // component.set('v.documentMessage',JSON.parse(response.getReturnValue()).status);
                   // this.displayMessage(component, 'displaysuccessToast','displaysuccessMsg', '<b>Success!</b> Details saved successfully.');
                	this.showhidespinner(component,event,false);
                }
                else{
                    this.showhidespinner(component,event,false);
                }
            });
            $A.enqueueAction(action);
            
            
        }
        
    },
    callVerificationAPI : function(component, event) {
        console.log('in callVerificationAPI');
        var action = component.get('c.callBREverification');
            action.setParams({
                "oppId" : component.get('v.oppId')
                
            });
            action.setCallback(this, function(response){
                //this.hideSpinner(component);
                var state = response.getState();
                if (state == "SUCCESS") {
                    console.log('success');
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Success','Verifications generated successfully.','success');
                    //alert('verification called successfully.');
                   // component.set('v.documentMessage',JSON.parse(response.getReturnValue()).status);
                   // this.displayMessage(component, 'displaysuccessToast','displaysuccessMsg', '<b>Success!</b> Details saved successfully.');
                }
                else{
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Error in generating verifications.','errors');
                }
                    //alert('error');
                 // this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
            });
            $A.enqueueAction(action);
        
    },
    showhidespinner:function(component, event, showhide){
        console.log('here');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
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
    }
    
})