({
	MAX_FILE_SIZE: 5 242 880, /* 1024*1024*5  1 000 000 * 3/4 to account for base64 */
	preview : function(component,event) {
    	var fileInput = component.find("file-upload-input").getElement();
        var file = fileInput.files[0];
        var img = component.find("imagePreview").getElement();
        var reader = new FileReader();
        var binaryString;
        var self = this;
        var latitude;
        var longitude;
        var uploadType = component.get("v.uploadType");
    	
    	if(file != undefined){
            if(file.name != undefined){
                var fileName=file.name;
                if (file.size > this.MAX_FILE_SIZE) {
		            self.showToast(component,'Error!\n','File size cannot exceed ' + this.MAX_FILE_SIZE/(1024*1024) + ' Mb.\n' +
		    	          'Selected file size: ' + file.size/(1024*1024) + ' Mb.','error');
		            this.reset(component);
		    	    return;
		        }
                if(component.get("v.filePrefix")!=undefined){
	                var idvar=String(component.get("v.filePrefix"));
	                var dnow = '-'+$A.localizationService.formatDate(new Date(), "DD/MM/YYYY hh:mm:ss a");
	                fileName =idvar+'_'+file.name+dnow+'.jpg';
	                var img = component.find("imagePreview").getElement(); 
	                img.src = URL.createObjectURL(file);
                }
                component.find("file-name").set("v.value", fileName);
                component.set("v.fileName", fileName);
                component.set("v.allowUpload", "true");
            }
            else{
                component.find("file-name").set("v.value", "");
            }
			if(uploadType === 'feed'){
                reader.onload = function(readerEvent) {
                        binaryString = readerEvent.target.result;
                        var pic = new Image();
                    	pic.src = 'data:image/jpeg;base64,'+ btoa(binaryString);        
                        pic.onload = function(){
                            EXIF.getData(this, function () {
                                longitude = EXIF.getTag(this, 'GPSLongitude');
                                latitude = EXIF.getTag(this, 'GPSLatitude');   
                        if(typeof longitude != 'undefined' && longitude != null && longitude != '' && typeof latitude != 'undefined' && latitude != null && latitude != ''){
                            img.src = URL.createObjectURL(file);
                            window.setTimeout(
                                        $A.getCallback(function() {
                                            if (component.isValid()) {
                                                component.find("Declattitude").set("v.value", latitude);
                                                component.find("Declongitude").set("v.value", longitude);
                                                component.find("latitude").set("v.value", 'Latitude: '+(latitude[0].numerator + latitude[1].numerator /(60 * latitude[1].denominator) + latitude[2].numerator / (3600 * latitude[2].denominator)));
                                    			component.find("longitude").set("v.value", 'Longitude: '+(longitude[0].numerator + longitude[1].numerator /(60 * longitude[1].denominator) + longitude[2].numerator / (3600 * longitude[2].denominator)));
                                 				component.set("v.latitude", (latitude[0].numerator + latitude[1].numerator /(60 * latitude[1].denominator) + latitude[2].numerator / (3600 * latitude[2].denominator)) );
                                    			component.set("v.longitude", (longitude[0].numerator + longitude[1].numerator /(60 * longitude[1].denominator) + longitude[2].numerator / (3600 * longitude[2].denominator)) );
                                 				if(component.get("v.latitude") == null || component.get("v.longitude") == null)
                                                 {
                                                   var declat = latitude[0] + (latitude[1]/60) + (latitude[2]/(60*60));
                                                   var declong = longitude[0] + (longitude[1]/60) + (longitude[2]/(60*60));
                                                   component.find("latitude").set("v.value", 'Latitude: '+declat);
                                    			   component.find("longitude").set("v.value", 'Longitude: '+declong); 
                                    			   component.set("v.latitude",declat);       
                                                   component.set("v.longitude",declong);  
                                                 }
                                            }
                                        }), 10
                                    );
                                }
                                else{
                                    window.setTimeout(
                                        $A.getCallback(function() {
                                            if (component.isValid()) {
                                                self.showToast(component,'Error!', 'Selected image does not have any Lattitude/Langitute associated', 'error' );
                                                self.reset(component);
                                            }
                                        }), 10
                                    );
                                }
                                });
                        };
                    };
                    reader.readAsBinaryString(file);
                }
    	}
    },
    
    save : function(component) {
    	$A.util.removeClass(component.find("spinner"),"slds-hide");
    	var fileInput = component.find("file-upload-input").getElement();
    	var file = fileInput.files[0];
   
        if (file.size > this.MAX_FILE_SIZE) {
            self.showToast(component,'Error!\n','File size cannot exceed ' + this.MAX_FILE_SIZE/(1024*1024) + ' Mb.\n' +
		    	          'Selected file size: ' + file.size/(1024*1024) + ' Mb.','error');
    	    return;
        }
    
        var fr = new FileReader();
        var self = this;
       	var fileContents;
   		fr.onload = function(readerEvent) {
            var img = document.createElement("img");
            img.src = component.find("imagePreview").getElement().src;
            var MAX_WIDTH = 800;
            var MAX_HEIGHT = 600;
            var width = img.width;
            var height = img.height;
            
            if (width > height) {
                if (width > MAX_WIDTH) {
                    height *= MAX_WIDTH / width;
                    width = MAX_WIDTH;
                }
            } else {
                if (height > MAX_HEIGHT) {
                    width *= MAX_HEIGHT / height;
                    height = MAX_HEIGHT;
                }
            }
            var canvas = document.createElement('canvas');
            canvas.width = width;
            canvas.height = height;
            var ctx = canvas.getContext("2d");
            ctx.drawImage(img, 0, 0, width, height);
            fileContents = canvas.toDataURL('image/jpeg');
    	var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
		
                window.setTimeout(
                    $A.getCallback(function() {
                        if (component.isValid()) {
                            self.upload(component, file, fileContents);
                           }
                    }), 10
                );
        };
        fr.readAsDataURL(file);
    },
    
    upload: function(component, file, fileContents) {
    	$A.util.removeClass(component.find("spinner"),"slds-hide");
    	var action = component.get("c.saveAsFile");
    	action.setParams({
            parentId: component.get("v.parentId"),
            fileName: component.get("v.fileName"),
            base64Data: encodeURIComponent(fileContents), 
        });
        action.setCallback(this, function(a) {
        	var state = a.getState();
            if (component.isValid() && state === "SUCCESS") {
	        	$A.util.addClass(component.find("spinner"),"slds-hide");
	        	var getEvent = component.getEvent("GridRefresh");
			        getEvent.fire()
	            var attachId = a.getReturnValue();
	            component.set("v.isUploaded", "true");
	            component.set("v.allowUpload", "false");
	            this.showToast(component,'Success!','File uploaded successfully.','success');
            }
            else{
            	$A.util.addClass(component.find("spinner"),"slds-hide");
            	component.set("v.allowUpload", "true");
            	this.showToast(component,'Error!',component.get("v.fileName")+' upload failed, please try again.','error');
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        }
        else{
            var customToast = component.find('customToast');
            $A.util.removeClass(customToast, 'slds-hide');
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme,"slds-theme--error");
            $A.util.removeClass(toastTheme,"slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme,"slds-theme--error");
            }
            else if(type == 'success'){
                $A.util.addClass(toastTheme,"slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
        }
    },
    
    reset : function(component){
        component.find("file-upload-input").getElement().value = "";
        component.find("file-name").set("v.value", 'No file chosen');
        component.set("v.allowUpload", "false");
        component.find("imagePreview").getElement().src = "";
        if(component.get("v.uploadType") == "feed"){
        	component.find("lat-log").set("v.value",'');
            component.find("latitude").set("v.value",'');
            component.find("longitude").set("v.value",'');
	    	$A.util.addClass(component.find("lat-log-div"), 'slds-hide');
        }
        $A.util.addClass(component.find("previewBlock"), 'slds-hide');
    },
    
    
    markRed : function(component){
    },
    
    doUpload : function(component, file, fileContents){
    	var fileInput = component.find("file-upload-input").getElement();
    	var file = fileInput.files[0];
    	var self = this;
        if (file.size > this.MAX_FILE_SIZE) {
            self.showToast(component,'Error!\n','File size cannot exceed ' + this.MAX_FILE_SIZE/(1024*1024) + ' Mb.\n' +
		    	          'Selected file size: ' + file.size/(1024*1024) + ' Mb.','error');
    	    return;
        }
        var fr = new FileReader();
        var self = this;
   		fr.onload = function(readerEvent) {
            var img = document.createElement("img");
            img.src = component.find("imagePreview").getElement().src;
            var MAX_WIDTH = 800;
            var MAX_HEIGHT = 600;
            var width = img.width;
            var height = img.height;
            if (width > height) {
                if (width > MAX_WIDTH) {
                    height *= MAX_WIDTH / width;
                    width = MAX_WIDTH;
                }
            } else {
                if (height > MAX_HEIGHT) {
                    width *= MAX_HEIGHT / height;
                    height = MAX_HEIGHT;
                }
            }
            var canvas = document.createElement('canvas');
            canvas.width = width;
            canvas.height = height;
            var ctx = canvas.getContext("2d");
            ctx.drawImage(img, 0, 0, width, height);
            fileContents = canvas.toDataURL('image/jpeg');
	    	var base64Mark = 'base64,';
        	var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
 
        fileContents = fileContents.substring(dataStart);
        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    self.save2Controller(component, file, fileContents);
                   }
            }), 10
        );
        }
        fr.readAsDataURL(file);
    },
    
    save2Controller : function(component, file, fileContents) {
    	var apexControllerMethod = component.get("c.saveFilewithGeo"); 
		var parentId = component.get("v.parentId");        
        var contentType = file.type;
        var fileName = component.get("v.fileName");
        apexControllerMethod.setParams({
            parentId: parentId,
            fileName: fileName,
            contentType: contentType,
            base64Data: encodeURIComponent(fileContents),
            fileId : '',
			uploadType : component.get("v.uploadType"),
			longitude : component.get("v.longitude"),
			latitude : component.get("v.latitude")
        });
        apexControllerMethod.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                isSuccess = response.getReturnValue();
                if(isSuccess == true){
                	this.reset(component);
                	if(component.get("v.uploadType") == "feed"){
	                    var enableSubmitButtonEvent = $A.get("e.c:EnableSubmitButtonEvent");
	                    enableSubmitButtonEvent.fire();  
                	}
                }else{
                	this.showToast(component,'Error!',' File upload Failed.','error');
                }
            } 
            else{
                this.showToast(component,'Error!', 'Premise Picture '+component.get("v.fileName")+' upload failed, please try again.'+JSON.stringify(response),'error');
            }
        });
        $A.enqueueAction(apexControllerMethod);
    },
        setParentId : function(component,event){
        var verificationId = event.getParam("verificationId");
        component.set("v.parentId", verificationId);
        var selectFileErrorFlag = event.getParam("selectFileErrorFlag");
        component.set("v.selectFileErrorFlag", selectFileErrorFlag);
        this.save(component);
    },
    setOfferData: function(component, event){
        component.set("v.isconvert", event.getParam('checkconvert'));
    },
})