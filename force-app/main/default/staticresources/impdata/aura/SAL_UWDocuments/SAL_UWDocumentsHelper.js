({
	openPopUp : function(component, event) {
		var resultId = event.currentTarget.name;
        var cvRec;
        var allDocs = component.get("v.allDocs");
        for(var i=0;i<allDocs.length;i++){
            if(allDocs[i].cvData.Id == resultId){
            	cvRec = allDocs[i];   
            }
        }
        console.log('cvRec.cvData.FileType'+cvRec.cvData.FileType);
        if(cvRec.cvData.FileType == 'UNKNOWN' || cvRec.cvData.FileType == 'PNG' || cvRec.cvData.FileType == 'JPEG' || cvRec.cvData.FileType == 'PDF' || cvRec.cvData.FileType == 'JPG'){
            var cmpTarget = component.find('pop');
            $A.util.addClass(cmpTarget, 'slds-show');
            $A.util.removeClass(cmpTarget, 'slds-hide');
            var backdrop = component.find('backdrop');
            $A.util.addClass(backdrop, 'slds-show');
            $A.util.removeClass(backdrop, 'slds-hide');
            
            
            if(cvRec.cvData.FileType == 'PNG' || cvRec.cvData.FileType == 'JPEG' || cvRec.cvData.FileType == 'JPG'){
                var modal = document.createElement('div');
                
                modal.setAttribute("class" , "parentDiv");
                component.find("iframeHolder").getElement().appendChild(modal);
                
                var theFrame = document.createElement('img');
                theFrame.style.height = "500px";
                theFrame.style.width = "500px";
                theFrame.setAttribute("src",component.get("v.prefixURL")+cvRec.cvData.Id);
                
                modal.appendChild(theFrame);
                
                
            }
            else if(cvRec.cvData.FileType == 'PDF' || (cvRec.cvData.FileType == 'UNKNOWN' && cvRec.cvData.Title.includes('.pdf'))){
                var modal = document.createElement('div');
                
                modal.setAttribute("class" , "parentDiv");
                component.find("iframeHolder").getElement().appendChild(modal);
                
                var theFrame = document.createElement('iframe');
                theFrame.style.height = "500px";
                theFrame.style.width = "500px";
                var fileURL = '';
                console.log('result[i].baseContent'+cvRec.baseContent);
                var url = 'data:application/pdf;base64,' + cvRec.baseContent;
                var index = i+1;
                var filename = 'preview'+index+'.pdf';
                console.log('filename is'+filename);
                fetch(url)
                .then(res => res.blob())
                .then($A.getCallback(blob => theFrame.setAttribute("src",  URL.createObjectURL(new File([blob], filename, { type: 'application/pdf' }))))); 
                
                modal.appendChild(theFrame);
            }
            else{
                this.displayToastMessage(component,event,'Error','Preview is only available for Image and PDF files','error');  
            }
        }
        else{
            this.displayToastMessage(component,event,'Error','Preview is only available for Image and PDF files','error');  
        }
        //component.find("iframeHolder").set("v.innerHTML","");
	},
    getAllAttachments : function(component){
        this.showhidespinner(component,event,true);
        var parentId = component.get("v.parentId");
        
        var self = this;
        console.log('getAllAttachments++'+parentId);
        if(parentId){     
            this.executeApex(component, "getAllDocumentsNew",{
                parentId : parentId
            },function(error, result) {
                console.log('cheking result files');
                if(!error && result){
                    component.set("v.allDocs",result);
                    
                }
                else{
                    console.log('in errror')
                }
                this.showhidespinner(component,event,false);
            });
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
    showhidespinner:function(component, event, showhide){
        console.log('in show hide');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
        console.log('after event fire');
    },
})