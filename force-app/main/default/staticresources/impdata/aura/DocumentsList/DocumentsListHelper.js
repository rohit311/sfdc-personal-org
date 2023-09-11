({
    
    getAllAttachments : function(component){
        var parentId = component.get("v.parentId");
        
        var self = this;//23578
        console.log('getAllAttachments++'+parentId);
        if(parentId){     
            this.executeApex(component, "getAllDocuments",{
                parentId : parentId
            },function(error, result) {
                console.log('Result : '+ result);
                if(!error && result){
                    var attachments = result;
                    console.log('attachments : '+ JSON.stringify(attachments));
                    /*17138 s*/
                    var newAttachments = [];/*20934*/
                    if(component.get("v.flow") == 'Mobility2'){
                        for(var i=0;i<attachments.length;i++){
                            /*added for DMS by swapnil 24317 s*/
                            var dmsDocs=  component.get("v.DMSDocmap");
                            var deviationFound=false;
                            for(var key in dmsDocs){
                                var dmsDoc=dmsDocs[key];
                                var dmsDocNameLAN =dmsDocs[key]+'-'+component.get("v.Oppobj.Loan_Application_Number__c"); //DMS new
                                if((attachments[i].Title.toUpperCase() === dmsDoc.toUpperCase() || attachments[i].Title.toUpperCase() == dmsDocNameLAN.toUpperCase()) && key.indexOf('_dev') != -1 ) //DMS new
                                    deviationFound=true;
                            }
                            /*added for DMS by swapnil 24317 e*/
                            if((!$A.util.isEmpty(attachments[i].Title) && (attachments[i].Title.includes('_dev')) || (attachments[i].Title.includes('CKYC'))) || deviationFound){ //DSM added by swapnil 24317 , rohit added ckyc condition
                                attachments[i].hideDelete = true;
                            }
                            /*SAL 2.0 CR's s*/ /*20934*/
                            if(attachments[i].OwnerId != $A.get("$SObjectType.CurrentUser.Id") && component.get("v.isEmployeeLoans") != true)
                            {
                                attachments[i].hideDelete = true;
                                
                            }
                            /*SAL 2.0 CR's e*/
                            //bug 20934 s
                            if (component.get("v.isEmployeeLoans") == true && (!$A.util.isEmpty(attachments[i].Title) && !attachments[i].Title.includes('.jfif'))) {
                                console.log('adding ' + attachments[i].Title + attachments[i].Name);
                                newAttachments.push(attachments[i]);
                                //console.log(newAttachments);
                            } //bug 20934 e
                        }
                    }
                    /*17138 e*/
                    component.set("v.uploadedAttachments", attachments);
                    if (component.get("v.isEmployeeLoans")) { /*20934 */
                        component.set("v.uploadedAttachments", newAttachments);
                    }
                    if(attachments.length > 0){
                        $A.util.removeClass(component.find("uploadedDocs"),"slds-hide");
                    }
                    else{
                        $A.util.addClass(component.find("uploadedDocs"),"slds-hide");
                    } 
                }
                /*Bug 17138 s*/
                if(component.get("v.flow") == 'Mobility2' ){
                    this.showhidespinner(component,event,false);
                    self.getapplAttachments(component);//23578
                }
                /*Bug 17138 e*/
            });
        }
        /*Bug 17138 s*/
        if(component.get("v.flow") == 'Mobility2' ){
            this.showhidespinner(component,event,false);
        }
        /*Bug 17138 e*/
    },    
    deleteAttachment : function(component, docId) {
        
        
        this.executeApex(component, "removeAttachment", {
            "docId" : docId
        }, function(error, result){
            if(!error){
                component.set("v.documentToast",'Success, Document Successfully Deleted');
                this.getAllAttachments(component);
            }
        });
    },
    
    executeApex: function(component, method, params, callback){
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
                if(component.get("v.flow") != 'Mobility2' ){
                    this.showToast(component, "Error!", errors.join(", "), "error");
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    /*Bug 17138 s*/
    deleteAttachmentMob : function(component, docId,fileName) {
        //23578 start
        var parentId = component.get("v.parentId");
        
        if(fileName.includes("CKYC Ph")){
            console.log('file name '+fileName);
            parentId = component.get("v.applId");
        }
        //23578 stop
        this.executeApex(component, "removeAttachmentMob", {
            "docId" : docId,"fileName" : fileName,"parentId" : parentId
        }, function(error, result){
            if(!error){
                console.log('delete flow >>'+result);
                if(!$A.util.isEmpty(fileName)){
                    var myStr = fileName;
                    
                    console.log('mystr'+myStr);
                    //myStr = myStr.split(".")[0];
                    //DMS new
                    if(myStr.includes('.')){
                        myStr = myStr.substring(0, myStr.lastIndexOf('.'));
                    }
                    var dmsDocs=  component.get("v.DMSDocmap");
                    for(var key in dmsDocs){
                        console.log('key is'+key);
                        var dmsLAN = dmsDocs[key]+'-'+component.get("v.Oppobj.Loan_Application_Number__c");
                        if(dmsDocs[key] == myStr || dmsLAN == myStr)
                            myStr = key;
                    }
                    console.log('mystr'+myStr);
                    //DMS new e
                    this.displayToastMessage(component,event,'Success','Document(s) deleted successfully.','success');
                    if(result){
                        var docDeleteEvent = $A.get("e.c:DocumentUploadEvent");
                        docDeleteEvent.setParams({
                            "fileName" : myStr,
                            "uploadStatus" : "false",
                            "flow": component.get("v.flow")
                        });
                        docDeleteEvent.fire();
                    }
                    else{
                        this.getAllAttachments(component);
                        this.showhidespinner(component,event,false);
                    }
                }
                else{
                    this.displayToastMessage(component,event,'Error','Error in deleting document.','error');
                    this.showhidespinner(component,event,false);
                }
            }
            else{
                this.displayToastMessage(component,event,'Error','Error in deleting document.','error');
                this.showhidespinner(component,event,false);
            }
        });
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
    },
    /*Bug 17138 e*/
    //23578 start
    getapplAttachments : function(component){
        debugger;
        var applId = component.get("v.applId");
        console.log('getapplAttachments++'+applId);
        if(applId){     
            this.executeApex(component, "getAllDocuments",{
                parentId : applId
            },function(error, result) {
                console.log('Result : '+ result);
                if(!error && result){
                    var attachments = result;
                    console.log('attachments : '+attachments.length+ attachments);
                    /*17138 s*/
                    var newAttachments=[];
                    if(component.get("v.flow") == 'Mobility2'){
                        for(var i=0;i<attachments.length;i++){
                            console.log('mkmapp  '+ attachments[i].Title + ':::::'+ attachments[i].Name);
                            
                            /*added for DMS by swapnil 24317 s*/
                            var dmsDocs=  component.get("v.DMSDocmap");
                            var deviationFound=false;
                            for(var key in dmsDocs){
                                var dmsDoc=dmsDocs[key];
                                var dmsDocNameLAN =dmsDocs[key]+'-'+component.get("v.Oppobj.Loan_Application_Number__c"); //DMS new
                                if((attachments[i].Title.toUpperCase() === dmsDoc.toUpperCase()  || attachments[i].Title.toUpperCase() == dmsDocNameLAN.toUpperCase()) && key.indexOf('_dev') != -1 ) //DMS new
                                    deviationFound=true;
                            }
                            /*added for DMS by swapnil 24317 e*/
                            
                            if((!$A.util.isEmpty(attachments[i].Title) && attachments[i].Title.includes('_dev')) ||  deviationFound){ //DSM added by swapnil 24317
                                attachments[i].hideDelete = true;
                            }
                            console.log('checking owner'+attachments[i].OwnerId+'--'+$A.get("$SObjectType.CurrentUser.Id"));
                            if(attachments[i].OwnerId != $A.get("$SObjectType.CurrentUser.Id"))
                                attachments[i].hideDelete = true;
                            
                        }
                    }
                    /*17138 e*/
                    console.log('before'+component.get("v.uploadedAttachments").length);
                    //23578 start
                    
                    var applAttachments =  component.get("v.uploadedAttachments");
                    console.log(component.get("v.uploadedAttachments").length);
                    
                    var ckycphoto = false;
                    for(var i=0;i<applAttachments.length;i++){
                        //console.log('here '+ (applAttachments[i].Title)+'--- '+applAttachments[i].Name);
                        //if((applAttachments[i].Name && applAttachments[i].Name == 'CKYC Photo') || (applAttachments[i].Title && applAttachments[i].Title.includes("PHOTOG"))){
                        if(applAttachments[i] && applAttachments[i].Title && applAttachments[i].Title == 'CKYC Photo'){  
                            ckycphoto = true;
                        }                       
                    }
                    if(ckycphoto === false){
                        if(attachments && attachments.length >0){
                            for(var j=0;j<attachments.length;j++){
                                if(attachments[j].Title && attachments[j].Title == 'CKYC Photo'){
                                    applAttachments.push(attachments[j]);
                                }
                                
                            }
                        }    
                    }
                    //23578 stop
                    console.log(applAttachments);
                    component.set("v.uploadedAttachments", applAttachments); 
                    console.log('uploaded @@' );
                    console.log(component.get("v.uploadedAttachments"));
                    
                    if(applAttachments.length > 0){
                        $A.util.removeClass(component.find("uploadedDocs"),"slds-hide");
                        $A.util.addClass(component.find("uploadedDocs"),"slds-show");
                    }
                    else{
                        $A.util.addClass(component.find("uploadedDocs"),"slds-hide");
                        $A.util.removeClass(component.find("uploadedDocs"),"slds-show");
                    } 
                }
                /*Bug 17138 s*/
                if(component.get("v.flow") == 'Mobility2' ){
                    this.showhidespinner(component,event,false);
                }
                /*Bug 17138 e*/
            });
        }
        /*Bug 17138 s*/
        if(component.get("v.flow") == 'Mobility2' ){
            this.showhidespinner(component,event,false);
        }
        /*Bug 17138 e*/
    },  
    //23578 stop
})