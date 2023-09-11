({
	getAllAttachments : function(component){
        var parentId = component.get("v.parentId");
       
		 var self = this;
        console.log('getAllAttachments++'+parentId);
        if(parentId){     
            this.executeApex(component, "getAllDocumentsNew",{
                parentId : parentId
            },function(error, result) {
                console.log('cheking result files');
                console.log('Result test : '+ result );
                if(!error && result){
                    for(var i in result){
                        console.log('result[i].cvData'+result[i].cvData.FileType);
                        if(result[i].cvData.FileType == 'PNG' || result[i].cvData.FileType == 'JPEG' || result[i].cvData.FileType == 'JPG'){
                            /*var titleTag = document.createElement('p');
                            titleTag.innerText = 'test image';
                            component.find("iframeHolder").getElement().appendChild(titleTag);*/
                            var theFrame = document.createElement('img');
                            theFrame.style.height = "500px";
                            theFrame.style.width = "500px";
                            theFrame.setAttribute("src",component.get("v.prefixURL")+result[i].cvData.Id);
                            component.find("iframeHolder").getElement().appendChild(theFrame);
                        }
                        else if(result[i].cvData.FileType == 'PDF'){
                            var theFrame = document.createElement('iframe');
                            theFrame.style.height = "500px";
                            theFrame.setAttribute("name","Test Image");
                            theFrame.style.width = "500px";
                            var fileURL = '';
                            var url = 'data:application/pdf;base64,' + result[i].baseContent;
                            fetch(url)
                            .then(res => res.blob())
                            .then($A.getCallback(blob => theFrame.setAttribute("src",  URL.createObjectURL(new File([blob], 'preview.pdf', { type: 'application/pdf' }))))); 
                            component.set("v.srcvalue",component.get("v.srcvalueNew"));
                            component.find("iframeHolder").getElement().appendChild(theFrame);
                        }
                            else if(result[i].cvData.FileType == 'TEXT'){
                            	console.log('txt contents'+result[i].baseContent);    
                            }
                    }
                    /*var url = 'data:application/pdf;base64,' + result[0].baseContent;
                    fetch(url)
                    .then(res => res.blob())
                    .then($A.getCallback(blob => {
                        $A.createComponent(
                        'aura:HTML',
                        {
                        tag: 'iframe',
                        HTMLAttributes: {
                            'aura:id':  'iframe',
                            id:         'iframe',
                            src:        URL.createObjectURL(new File([blob], 'preview.pdf', { type: 'application/pdf' })),
                            width:      500,
                            height:     500,
                        }
                        
                    },(iframe, status, errorMessage) => {
                        console.log('error'+status+errorMessage);
                    })
                      //  component.set("v.srcvalue",URL.createObjectURL(new File([blob], 'preview.pdf', { type: 'application/pdf' })))
                
                }));
                    console.log('final url'+component.get("v.srcvalue"));
                    /*for(var i in result){
                        console.log('result[i].cvData'+result[i].cvData.FileType);
                        if(result[i].cvData.FileType == 'PNG' || result[i].cvData.FileType == 'JPEG' || result[i].cvData.FileType == 'JPG'){
                            //urlList.push(component.get("v.prefixURL")+result[i].cvData.Id);
                        }
                        else if(result[i].cvData.FileType == 'PDF'){
                            console.log('result[i].baseContent'+result[i].baseContent);
                        	var url = 'data:application/pdf;base64,' + result[i].baseContent;
                            fetch(url)
                            .then(res => res.blob())
                            .then($A.getCallback(blob => {
                            	component.set("v.allDocs",URL.createObjectURL(new File([blob], 'preview.pdf', { type: 'application/pdf' })))
                            }));
                            console.log('final url'+component.get("v.srcvalue"));
                        }
                    }
                    
                    component.set("v.allDocs",urlList);
                    /*console.log('version data'+result[0].VersionData);
                    var preview = component.find("preview");
                    var file = new File([result], "test");
                    var myBlob = URL.createObjectURL(file);
                    console.log('file is'+myBlob);
                    component.set("v.srcvalue",myBlob);*/

                    /*if ( theFile.type.indexOf("image/") == 0 ) {    
                        var img = component.find("imagePreview").getElement();
                        img.src = URL.createObjectURL(theFile);
                    }*/
                    /*var url = 'data:application/pdf;base64,' + result;
                    fetch(url)
                    .then(res => res.blob())
                    .then($A.getCallback(blob => component.set("v.srcvalue",URL.createObjectURL(new File([blob], 'preview.pdf', { type: 'application/pdf' })))));
                */}
                else{
                    console.log('in errror')
                }
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
})