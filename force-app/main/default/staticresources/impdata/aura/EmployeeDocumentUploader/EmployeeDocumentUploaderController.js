({
	doInit : function(component, event, helper) {
        console.log('in init employee doc '+component.get("v.applicantObj"))
         /*DMS bug 24317s*/
         helper.getDMSDocuments(component,event);
        /*DMS bug 24317s*/
		helper.getDocList(component,event,helper);
	},
    setDocVisible : function(component, event,helper) {
        var target = component.find("Uploader");
        if(component.get("v.DocSelected") != '--None--' && !$A.util.isEmpty(component.get("v.DocSelected"))){
            $A.util.removeClass(target,'slds-hide');
            $A.util.addClass(target,'slds-show');
        }
        else{
            $A.util.addClass(target,'slds-hide');
            $A.util.removeClass(target,'slds-show');
        }
    },
    populateList : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        console.log('document upload event'+event.getParam("fileName")+'>>stst>>'+event.getParam("uploadStatus"));
        
        var isuploaded = "",filename="";
        var DocumentList = component.get("v.DocumentList");
        var DocumentSelectList =  component.get("v.DocumentSelectList"); 
        
        console.log(JSON.stringify(DocumentList));
        console.log(JSON.stringify(DocumentSelectList));
        
        
        if(!$A.util.isEmpty(event.getParam("flow")) && event.getParam("flow") == 'Mobility2'){
            helper.showhidespinner(component,event,true);
            if(!$A.util.isEmpty(event.getParam("uploadStatus")) && !$A.util.isEmpty(event.getParam("fileName"))){
                filename = event.getParam("fileName");
                console.log('filename'+filename);
                if(event.getParam("uploadStatus") == "true"){
                    if(!$A.util.isEmpty(DocumentSelectList)){
                        var i = DocumentSelectList.indexOf(filename);
                        console.log('i>>'+i);
                        if(i != -1) {
                            DocumentSelectList.splice(i, 1);   
                        }
                    }
                    if(!$A.util.isEmpty(DocumentList)){
                        DocumentList.forEach(selectedDocNames => {
                            if(selectedDocNames.docName == filename){
								selectedDocNames.isUploaded = true;
                        	}
						});
                    }
                    
                }
                else if(event.getParam("uploadStatus") == "false"){
                    if(!$A.util.isEmpty(DocumentList)){
                        DocumentList.forEach(selectedDocNames => {
                            if(selectedDocNames.docName == filename){
								selectedDocNames.isUploaded = false;
                        	}
						});
                    }
                    
                     /*DMS upload by swapnil 24317 s */
                            var dmsDoclist=component.get("v.DMSDocmap");
                            console.log('dmsDoclist '+dmsDoclist );
                            var DMSFileFound=false;
                            for(var key in dmsDoclist){
                                var dmsDocName=dmsDoclist[key];
                                if(filename.toUpperCase() == dmsDocName.toUpperCase()){
                                        filename=key;
                                }                                   
                            } 
                            /*DMS upload by swapnil 24317 e*/

                    
                    
                    if(!$A.util.isEmpty(DocumentSelectList)){
                    	DocumentSelectList.push((filename.split('\.'))[0]);
                    }
                }
                component.set("v.DocumentList",DocumentList);
                component.set("v.DocSelected",'');
                component.set("v.DocumentSelectList",DocumentSelectList);
                
            }
            helper.showhidespinner(component,event,false);
        }  
    }
})