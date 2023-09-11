({
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
                    for(var i=0;i<result.length;i++){
                        if(result[i].cvData.FileType == 'PNG' || result[i].cvData.FileType == 'JPEG' || result[i].cvData.FileType == 'JPG'){
                            var modal = document.createElement('div');
                            
                            modal.setAttribute("class" , "parentDiv");
                            component.find("iframeHolder").getElement().appendChild(modal);
                            var titleTag = document.createElement('p');
                            titleTag.innerText = result[i].cvData.Title;
                            titleTag.style.width = "500px";
                            modal.appendChild(titleTag);
                            var theFrame = document.createElement('img');
                            theFrame.style.height = "500px";
                            theFrame.style.width = "500px";
                            theFrame.setAttribute("src",component.get("v.prefixURL")+result[i].cvData.Id);
                            
                            modal.appendChild(theFrame);
                            
                            
                        }
                        else if(result[i].cvData.FileType == 'PDF'){
                            var modal = document.createElement('div');
                            
                            modal.setAttribute("class" , "parentDiv");
                            component.find("iframeHolder").getElement().appendChild(modal);
                            var titleTag = document.createElement('p');
                            titleTag.innerText = result[i].cvData.Title;
                            titleTag.style.width = "500px";
                            modal.appendChild(titleTag);
                            var theFrame = document.createElement('iframe');
                            theFrame.style.height = "500px";
                            theFrame.style.width = "500px";
                            var fileURL = '';
                            console.log('result[i].baseContent'+result[i].baseContent);
                            var url = 'data:application/pdf;base64,' + result[i].baseContent;
                            var index = i+1;
                            var filename = 'preview'+index+'.pdf';
                            console.log('filename is'+filename);
                            fetch(url)
                            .then(res => res.blob())
                            .then($A.getCallback(blob => theFrame.setAttribute("src",  URL.createObjectURL(new File([blob], filename, { type: 'application/pdf' }))))); 
                            
                            modal.appendChild(theFrame);
                        }
                        
                    }
                    
                }
                else{
                    console.log('in errror')
                }
                this.showhidespinner(component,event,false);
            });
        }
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