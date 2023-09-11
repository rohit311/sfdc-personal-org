({
    MAX_FILE_SIZE: 4500000, /* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE: 4250000, /* Use a multiple of 4 */
    preview : function(component,event) {
      
        //alert(component.get("v.uploadImageFilesOnly"));
     	/*Bug 17138 s*/
        if(component.get("v.flow") == 'Mobility2'){
            this.showhidespinner(component,event,true);
        }
        /*Bug 17138 e*/
        var fileInput = component.find("file-upload-input").getElement();
        var file = fileInput.files[0];
        var img = component.find("imagePreview").getElement();
       // document.getElementById(component.get("v.poId")+"_"+component.get("v.instance"));
        var reader = new FileReader();
        var binaryString;
        var self = this;
        var latitude;
        var longitude;
        var uploadType = component.get("v.uploadType");
        //alert('preview'+file.name);
        component.set("v.disablepage",true);
        if(file != undefined){
           // console.log('File Size : '+ file.size);
            
            if(file.name != undefined){
                var fileName = file.name;
                component.find("file-name").set("v.value", fileName);
            }
            else{
                component.find("file-name").set("v.value", "");
            }
            
         
     	   //alert(file.type.indexOf("image/"));       
            // only display if it is an image
            if (file.type.indexOf("image/") == 0 ) {
               //alert('Within image loop'+uploadType);
               
                if(uploadType === 'feed'){
                    
                    // YK fire event when file is discarded
                    if(component.get("v.displayUpload") == false)
						this.triggerPostImageSelectDeselectEvent(component, true);
                    
                    reader.onload = function(readerEvent) {
                        binaryString = readerEvent.target.result;
                        var pic = new Image();
                    	pic.src = 'data:image/jpeg;base64,'+ btoa(binaryString);        
                        pic.onload = function(){
                           // alert("IN onload");       
                            EXIF.getData(this, function () {
                                longitude = EXIF.getTag(this, 'GPSLongitude');
                                latitude = EXIF.getTag(this, 'GPSLatitude');        
                                if(typeof longitude != 'undefined' && longitude != null && longitude != '' && typeof latitude != 'undefined' && latitude != null && latitude != ''){
                                   //alert("In If..."+img.getAttribute("Id"));
                                   // alert(img);
                                    
                                    //var img = '<img width="100%" src="https://maps.googleapis.com/maps/api/staticmap?markers=color:red%7Clabel:A%7C' + latitudeDecimal + ',' + longitudeDecimal + '&center=' + latitudeDecimal + ',' + longitudeDecimal + '&zoom=18&size=720x720&sensor=false"/>'; $('.geoloc').val(latitudeDecimal+','+longitudeDecimal); 
                                    img.src = URL.createObjectURL(file);
                                   //alert(img.offsetHeight;);
                                    component.set("v.imageUpload", "true");
                                    window.setTimeout(
                                        $A.getCallback(function() {
                                             //alert(component.isValid());
                                            if (component.isValid()) {
           									//alert("Lat : "+ latitude + "longitude : "+ longitude + ' DoDecimal : '+ this.doDecimal(component.find("longitude").get("v.value")) + ' long : '+ this.doDecimal(component.find("latitude").get("v.value")));
                                                component.find("Declattitude").set("v.value", latitude);
                                                component.find("Declongitude").set("v.value", longitude);
                                                // Bug 13338 S
                                                component.find("latitude").set("v.value", 'Latitude: '+(latitude[0].numerator + latitude[1].numerator /(60 * latitude[1].denominator) + latitude[2].numerator / (3600 * latitude[2].denominator)));
                                    			component.find("longitude").set("v.value", 'Longitude: '+(longitude[0].numerator + longitude[1].numerator /(60 * longitude[1].denominator) + longitude[2].numerator / (3600 * longitude[2].denominator)));
                                 				// Bug 13338 E
                                 				 // Bug ID : 13884 Start	
                                 				if(component.get("v.latitude") == null || component.get("v.longitude") == null)
                                                 {
                                                   var declat = latitude[0] + (latitude[1]/60) + (latitude[2]/(60*60));
                                                   var declong = longitude[0] + (longitude[1]/60) + (longitude[2]/(60*60));
                                                   component.find("latitude").set("v.value", 'Latitude: '+declat);
                                    			   component.find("longitude").set("v.value", 'Longitude: '+declong);        
                                                 }
                                                // Bug ID : 13884 End

                                            }
                                        }), 100
                                    );
                                }
                                else{
                                    //alert("In else...");
                                    window.setTimeout(
                                        $A.getCallback(function() {
                                            if (component.isValid()) {
                                                if(component.get("v.salMobilityDocument") == 'Mobility')
                                                	component.set("v.documentToast",'Error,Selected image does not have any Latitude/Longitude associated');
                                               else
                                                   self.showToast(component,'Error!', 'Selected image does not have any Latitude/Longitude associated', 'error' );
                                                /*Bug 17138 s*/
                                                if(component.get("v.flow") == 'Mobility2'){
                                                    console.log('hide');
                                                    this.displayToastMessage(component,event,'Error','Selected image does not have any Lattitude/Langitute associated.','error');
                                                    this.showhidespinner(component,event,false);
                                                }
                                                /*Bug 17138 e*/
                                                self.reset(component);
                                            }
                                        }), 500
                                    );
                                    component.set("v.imageUpload", "false");
                                }
                            });
                        };
                    };
                    reader.readAsBinaryString(file);
                }
                else{
                    component.set("v.disablepage",true);
                   img.src = URL.createObjectURL(file);
                   component.set("v.imageUpload", "true");
                   //$A.util.removeClass(component.find("imagePreview"), 'slds-hide');
                }
            } else {
                //$A.util.removeClass(component.find("imagePreview"), 'slds-hide');
                component.set("v.imageUpload", "false");
               // component.set("v.uploadImageFilesOnly","true");
                //YK check to upload image files only
               //alert(component.get("v.uploadImageFilesOnly"));
            //   alert(file.type.indexOf("image/"));
             //   alert(component.get("v.uploadImageFilesOnly"));
            //    alert(component.get("v.salMobilityDocument");
                if(component.get("v.uploadImageFilesOnly") == true || component.get("v.uploadImageFilesOnly") == "true" )
                {
                    this.reset(component);
                      window.setTimeout(
               			 $A.getCallback(function() {
                    		debugger;
                   			if(component.get("v.salMobilityDocument") == 'Mobility')
                    			component.set("v.documentToast",'Error,Kindly select an image file only.');
                    		else if(component.get("v.flow") != 'Mobility2')
                        		self.showToast(component,'Error!', 'Kindly select an image file only.', 'error' );
                             /*Bug 17138 s added above if for else*/
                             if(component.get("v.flow") == 'Mobility2'){
                                 console.log('hide');
                                 this.displayToastMessage(component,event,'Error','Kindly select an image file only.','error');
                                 this.showhidespinner(component,event,false);
                             }
                             /*Bug 17138 e*/
             			}), 2500
             		);
                }
            }
            component.set("v.disablepage",false);
        }
        else{
            this.reset(component);
            component.set("v.disablepage",false);
        }
        /*Bug 17138 s*/
        if(component.get("v.flow") == 'Mobility2'){
            console.log('hide');
            this.showhidespinner(component,event,false);
        }
        /*Bug 17138 e*/
       //alert('end uploading'); 
	},
    reset : function(component){
        component.find("file-upload-input").getElement().value = "";
        component.find("file-name").set("v.value", 'No file chosen');
        component.set("v.imageUpload", "false");
        component.find("latitude").set("v.value", '');
        component.find("longitude").set("v.value", '');
		component.find("Declattitude").set("v.value", '');
		component.find("Declongitude").set("v.value", '');
        component.find("imagePreview").getElement().src = "";
        $A.util.addClass(component.find("previewBlock"), 'slds-hide');
        // YK fire event when file is discarded
        if(component.get("v.displayUpload") == false)
			this.triggerPostImageSelectDeselectEvent(component, false);
    },
    disableForm: function(component){
       		
          window.setTimeout(
                $A.getCallback(function() {
                    
                    if(component.get("v.showUploadButton") === true || component.get("v.showUploadButton") === 'true'){
                    	 	component.find("saveButtonId").set("v.disabled", true);
                    	}
						 //PSL changes : Nikhil Bugfix #11766                					 
           				component.find("cancelButtonId").set("v.disabled", true);
           				component.find("file-upload-input").getElement().disabled = true;
       					
             	}), 2000
             );
        
        
        
        
        
        

    },
    save : function(component) {
      //  alert('Inside save method123');
        component.set("v.disablepage",true);
        var fileInput = component.find("file-upload-input").getElement();
        //17138 added if
        if(component.get("v.flow") != 'Mobility2')
        	component.set("v.spinnerFlag","true");
        else
            this.showhidespinner(component,event,true);
        if(fileInput){
            //var file = fileInput.files[0];
            var file = document.getElementById("file-upload_"+component.get("v.instance")).files[0];
            var self = this;
            var selectFileErroFlag = component.get("v.selectFileErrorFlag");
            if ($A.util.isEmpty(component.get('v.fileName'))) {
                component.set("v.documentToast",'Error,Please Select Document Type.');
                component.set("v.disablepage",false);
                /*Bug 17138 s*/
                if(component.get("v.flow") == 'Mobility2'){
                    this.displayToastMessage(component,event,'Error','Please Select Document Type.','error');
					this.showhidespinner(component,event,false);
                }
                /*Bug 17138 e*/
                return;
            }
            /*Bug 17138 s*/
            if(component.get("v.flow") == 'Mobility2' && !component.get("v.forPricingDashboard")){
                
                var fileMob = document.getElementById("file-upload_11").files[0];
                console.log('file is'+fileMob);
                if (fileMob == null){
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','File #1 is mandatory.','error');
                    return;
                }
            }
            console.log('file is '+file);
            console.log('file error flag '+ selectFileErroFlag)
          //  alert('file is '+file);
          //  alert('file error flag '+ selectFileErroFlag);
            /*Bug 17138 e*/    
            if (file == null && (selectFileErroFlag==="true"||selectFileErroFlag === true )) {
				component.set("v.spinnerFlag","false");
                if(component.get("v.salMobilityDocument") == 'Mobility')
                	component.set("v.documentToast",'Error,Select a file.');
                else if(component.get("v.flow") != 'Mobility2')
                    self.showToast(component,'Error!', 'Select a file first.', 'error' );
                /*Bug 17138 s and added above else for if*/
                if(component.get("v.flow") == 'Mobility2'){
                    console.log('hide');
                    this.displayToastMessage(component,event,'Error','Please select a file first.','error');
					this.showhidespinner(component,event,false);
                }
                /*Bug 17138 e*/
                component.set("v.documentToast",'');
                component.set("v.disablepage",false);
                return;
            }
            else if(file == null && !selectFileErroFlag) {
                component.set("v.disablepage",false);
				component.set("v.spinnerFlag","false");
                return;
            }
            else{                               
                var fr = new FileReader();
                var fileContents; //This variable will contain the file as base64 string
                var reader = new FileReader();
             var fileContents; 	
            reader.onloadend = (function(readerEvent){
                
                return function(readerEvent){
	                    if (component.get("v.imageUpload") === "true") {
                        var img = document.createElement("img");
                        img.src = component.find("imagePreview").getElement().src;
                        
                        //Let's compress the image file
                        var MAX_WIDTH = 1800; //800
                        var MAX_HEIGHT = 1200;
                        var width = img.width;
                        var height = img.height;
                        //alert('width++'+width + ' '+height);
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
                       // alert('width+2+'+width + ' '+height);
                        var canvas = document.createElement('canvas');
                        canvas.width = width;
                        canvas.height = height;
                        
                        var ctx = canvas.getContext("2d");
                        ctx.drawImage(img, 0, 1, width, height);
                        
                        fileContents = canvas.toDataURL('image/jpeg');
                    // Bug 15772 S - Hemant Keni
					}else if(component.get("v.uploadType") === 'feed'){
                        //alert('feed doc type');
						component.set("v.spinnerFlag","false");
                        if(component.get("v.salMobilityDocument") == 'Mobility')  
                        	component.set("v.documentToast",'Error,Selected image does not have any Latitude/Longitude associated with it.');
                        else if(component.get("v.flow") != 'Mobility2')
                            self.showToast(component,'Error!', 'Selected image does not have any Latitude/Longitude associated with it', 'error' );
                       	/*Bug 17138 s and added above else for if*/
                        if(component.get("v.flow") == 'Mobility2'){
                            //alert('check image');
                            this.displayToastMessage(component,event,'Error','Selected image does not have any Lattitude/Langitute associated with it..','error');
                            this.showhidespinner(component,event,false);
                        }
                        /*Bug 17138 e*/
                        component.set("v.disablepage",false);
                        return;
                    // Bug 15772 E - Hemant Keni
                    } else {
                        //Checking file size only for PDF as we will compress images anyway
                        if (file.size > self.MAX_FILE_SIZE) {
							component.set("v.spinnerFlag","false");
                            if(component.get("v.salMobilityDocument") == 'Mobility')  
                            	component.set("v.documentToast",'Error,File size cannot exceed ' + + self.MAX_FILE_SIZE + ' bytes.\n' +
                                           'Selected file size: ' + file.size, 'error' );
                            else if(component.get("v.flow") != 'Mobility2')
                                self.showToast(component,'Error!', 'File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' +
                                           'Selected file size: ' + file.size, 'error' );
                          	component.set("v.disablepage",false);
                            /*Bug 17138 s and added above if for else*/
                            if(component.get("v.flow") == 'Mobility2'){
                                this.displayToastMessage(component,event,'Error','File size cannot exceed ' + + self.MAX_FILE_SIZE + ' bytes.\n' +
                                           'Selected file size: ' + file.size,'error');
                                this.showhidespinner(component,event,false);
                            }
                            /*Bug 17138 e*/
                            return;
                        }
                        debugger;
                        fileContents = readerEvent.target.result;
                    }
                    var base64Mark = 'base64,';
                    var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                    fileContents = fileContents.substring(dataStart);
    
                    window.setTimeout(
                        $A.getCallback(function() {
                            if (component.isValid()) {
                                self.fireUpload(component, file, fileContents);
                               }
                        }), 10
                    );
                    

                 
                }
                    
            })(file);
                
            reader.readAsDataURL( file );
            }
        }
      
	},
	fireUpload : function(component, file, fileContents){
		//Nikhil : Changed logic from Attachments to Files
		var uploadType, latitude, longitude;
		//alert('inside firupload file is'+ file);
		uploadType = component.get("v.uploadType");
		
		if(!this.isEmpty(component.find("Declongitude").get("v.value")))
			longitude =  this.doDecimal(component.find("Declongitude").get("v.value"));
		if(!this.isEmpty(component.find("Declattitude").get("v.value")))
			latitude = this.doDecimal(component.find("Declattitude").get("v.value"));
        
		//Bug 15237 fix start
        if(isNaN(longitude) || isNaN(latitude))
        {
            var decLat = component.find("Declattitude").get("v.value");
            var decLong = component.find("Declongitude").get("v.value");
            if(decLat && decLong){
                latitude = decLat[0] + (decLat[1]/60) + (decLat[2]/(60*60));
                longitude = decLong[0] + (decLong[1]/60) + (decLong[2]/(60*60));
            }
        }
        //Bug 15237 fix end
        
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '', uploadType, longitude, latitude);        
    },
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId, uploadType, longitude, latitude) {
        var apexControllerMethod = component.get("c.saveTheChunk"); 
		var parentId = component.get("v.parentId");  
        var isDeleteInsert = component.get("v.isDeleteInsert"); //17556
       // console.log(parentId);
        var contentType = file.type;
        var chunk = fileContents.substring(fromPos, toPos);
        var fileNameArray = file.name.split(".");
        var fileName = component.get("v.fileName")+'.'+fileNameArray[fileNameArray.length-1];
	//	alert('file name is'+ fileName);
     
        //alert(base64Data);
        apexControllerMethod.setParams({
            parentId: parentId,
            fileName: fileName,
            contentType: contentType,
            base64Data: encodeURIComponent(chunk),
            fileId : attachId,
			uploadType : uploadType,
			longitude : longitude,
			latitude : latitude,
            isDeleteInsert : isDeleteInsert // bug 17556
        });

        apexControllerMethod.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                 component.set("v.spinnerFlag","false");
                attachId = response.getReturnValue();
                fromPos = toPos;
            	toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);
            
            	if (fromPos < toPos) {
              //      alert('inside and before upload chunks');
            		this.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
            	}
                else{
                    /*17138 commenting code called event below
                    var documentSaveEvent = $A.get("e.c:DocumentUploadEvent");
                    documentSaveEvent.fire();
                    e*/
                    //Bug 15855 S - Hemant Keni
                    var instance = component.get('v.instance');
                    if(component.get("v.salMobilityDocument") == 'Mobility')
                    	component.set("v.documentToast",'Success,'+component.get("v.fileName")+' uploaded successfully.');
                    else if((instance && (instance === 11 || instance === 12 || instance === 13) || instance === 14) && component.get("v.flow") != 'Mobility2'){ //17138 added and condition
                    	this.showToast(component,'Success!',component.get("v.fileName")+' uploaded successfully.','success');
                    }else{
                        //console.log('Image for instance '+ instance+ ' File name '+ component.get("v.fileName")+ ' uploaded successfully.');
                    }
                    /*Bug 17138 s*/
                    console.log('filename is'+fileName);
                    if(component.get("v.flow") == 'Mobility2'){
                        //console.log('hide');
                        this.displayToastMessage(component,event,'Success','File(s) uploaded successfully.','success');
                        this.showhidespinner(component,event,false);
                    }
                    //Bug 15855 E - Hemant Keni
                    //this.showToast(component,'Success!',component.get("v.fileName")+' uploaded successfully.','success');
                    //this.showToast(component,'Success!',component.get("v.fileName")+' uploaded successfully.','success');                    
                    //component.set("v.documentToast",'Success,'+component.get("v.fileName")+' uploaded successfully.');
                    this.reset(component);
                    //YK Enable 'Submit' button...
                    var displayUpload = component.get("v.displayUpload");
                    
                    if(displayUpload == false)
                    {
                        var enableSubmitButtonEvent = $A.get("e.c:EnableSubmitButtonEvent");
                        enableSubmitButtonEvent.fire();     
                    }
                    //YK refresh page
                    /*17138 s*/
                    var documentSaveEvent = $A.get("e.c:DocumentUploadEvent");
                    documentSaveEvent.setParams({
                            "fileName" : component.get("v.fileName"),
                        	 "uploadStatus" : "true",
                             "flow": component.get("v.flow")
                        });
                    //documentSaveEvent.fire();
                    //alert('before event');
                    window.setTimeout(
                        function() {
                            documentSaveEvent.fire();
                        }, 2000
                    );
                	/*17138 e*/
                    var refreshPage = component.get("v.refreshPage");
                    if(refreshPage == true)
                    {
                        var reloadImage = $A.get("e.c:reloadImage");
                        reloadImage.fire();     
                    }
                    
                    
                    try{
                        if(component.get("v.isFromCPV")){
                            this.calculateDistance(component); //Bug 17531 - Rural Geo Fencing
                        }   
                    }catch(e){
                        console.log('Exception : '+e);
                    }
                        
                }
            } else {
                 component.set("v.spinnerFlag","false");
               // console.log("Error: " + JSON.stringify(response));
            }
            component.set("v.disablepage",false);
        });
            
        //alert ('calling server');
        $A.enqueueAction(apexControllerMethod); 
        
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
    doDecimal : function(number) {
               
        return number[0].numerator + number[1].numerator /
                   (60 * number[1].denominator) + number[2].numerator / (3600 * number[2].denominator);
	},
	//Nikhil : Changed logic from Attachments to Files
    /*
     * @author	: Nikhil S
     * @date	: 04/20/2017 
     * @desc	: This method return true if the given value is empty or undefined
     * 
     */
    isEmpty: function(value){
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    
    setVerificationId : function(component,event){
        var fileInput = component.find("file-upload-input").getElement();
        
        //Bug 15855 S - Hemant Keni
        var instance = component.get('v.instance');
        if(instance && (instance === 11 || instance === 12 || instance === 13)){
            var verificationId = event.getParam("verificationId");
            //console.log('Instance : ' +  instance);
            //console.log('verificationId : '+ verificationId);
            //debugger;
            //console.log('Working Instance : '+ component.get('v.instance'));
            //console.log("ParentId : "+component.get("v.parentId"));
           // console.log(verificationId);
            if(verificationId)
            	component.set("v.parentId", verificationId);
           // console.log(component.get("v.parentId"));
            var selectFileErrorFlag = event.getParam("selectFileErrorFlag");
            //console.log('selectFileErrorFlag : '+ selectFileErrorFlag);
            component.set("v.selectFileErrorFlag", selectFileErrorFlag);
            //console.log('Inside setParentId of DocumentUploader Helper');
        //    alert('File Instance'+ instance);
            this.save(component);
        }
        //Bug 15855 E
    },
    
    triggerPostImageSelectDeselectEvent: function(component, imageSelectedFlag){
    //    console.log('imageSelectedFlag ----->> '+imageSelectedFlag);
        var fileBrowseEvent = $A.get("e.c:FileBrowseEvent");
//        console.log('fileBrowseEvent ----->> '+fileBrowseEvent);
        if(fileBrowseEvent){
            fileBrowseEvent.setParams({ 
                "isImageSelected": imageSelectedFlag
            });
            fileBrowseEvent.fire();
        }
    },
    
    calculateDistance: function(component, parentId) { //Bug 17531 - Rural Geo Fencing
        /*
         * Method Name: calculateDistance
         * Functionality: To calculate distance between image lat-long on verfication record and branch lat-long if it records qualifies
         * 					and to display Toast Message if any error occurrs 
         * @param: String parentId (Image document's parent record id)
         * @return: NA
         * From requirement number: Bug 17531 - Rural Geo Fencing
        */
        
        try {
            var apexControllerMethod = component.get("c.getDistanceFromBranch");
            var parentId = component.get("v.parentId");
            apexControllerMethod.setParams({
                parentId: parentId
            });
            apexControllerMethod.setCallback(this, function(response) { //Call to Apex Controller SFDCMobilePOController.getDistanceFromBranch
              //  console.log('response : state : '+response.getState()+' | value : '+response.getReturnValue() );
                var state = response.getState();
                if (state === "SUCCESS") { //component.isValid() 
                    //Response: 'Not Applicable' or 'HTTP Response' or 'Google API Response' or 'Distance in km'
                    if (response && response.getReturnValue() != 'Not Applicable') {
                        var responseMsg = response.getReturnValue();
                        if (responseMsg != null && responseMsg != 'undefined') {
                            if (responseMsg.includes('HTTP Response')) { //HTTP error : Display Toast message 
                                this.showToast(component, 'Something went wrong while calculating distance.', '\n\n The request may succeed if you try again.' + '\n Please re-upload image.', 'error');
                                return;
                            } else if (responseMsg.includes('Google API Response')) { //Google API error : : Display Toast message 
                                responseMsg = responseMsg.replace('Google API Response :', '');
                                this.showToast(component, 'Something went wrong while calculating distance.', '\n ' + responseMsg + '\n Please re-upload image.', 'error');
                                return;
                            }
                        }
                    }
                } else {
                    console.log('Error :' + response);
                }
            });
            $A.enqueueAction(apexControllerMethod);
        } catch (e) {
            console.log('Exception : ' + e);
        }
    },
    /*Bug 17138 s*/
    setChecklistId : function(component,event){
        this.showhidespinner(component,event,true);
        var fileInput = component.find("file-upload-input").getElement();
        var instance = component.get('v.instance');
        if(instance){
            var checklistId = event.getParam("checklistId");
            component.set("v.parentId", checklistId);
            
            console.log('ParentId set');
            var selectFileErrorFlag = event.getParam("selectFileErrorFlag");
            component.set("v.selectFileErrorFlag", selectFileErrorFlag);
            this.save(component);
        }
        else{
            this.showhidespinner(component,event,false);
        }
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
    /*Bug 17138 e*/
})