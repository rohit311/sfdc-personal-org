({
    
    
    MAX_FILE_SIZE: 6291456,
    MAX_FILE_SIZE_PDF:2000000,
    CHUNK_SIZE: 750000,
    save : function(component,event,fileInput) {
        // var fileInput = document.getElementById(component.get("v.imgId"));
        var allValid = true;
        if(fileInput){
            var file = fileInput.files[0];
            var self = this;
            if (file == null) {
                this.showtoast(component,event,'Error',"Please select the File!",'error');
                component.set("v.spinnerFlag","false");
                return;
            }else
                if (file.size > self.MAX_FILE_SIZE) {
                    this.showtoast(component,event,'Error',"File size cannot exceed 6 MB!",'error');
                    console.log('File size cannot exceed '+  self.MAX_FILE_SIZE);
                    component.set("v.spinnerFlag","false");
                    self.reset(component,event);
                    return;
                }
                else{   
                    console.log("fileName is ###"+component.get("v.fileName"));
                    var fileName = component.get("v.fileName");
                    var docType = fileName.substring(0,fileName.indexOf("_"));
                    var checklatLonRequired = component.get("v.latLongList");
                    for (var doc in checklatLonRequired){ 
                        console.log('doctype'+docType +'doc'+doc + 'checklatLonRequired[doc]'+checklatLonRequired[doc]);
                        if(doc == docType && checklatLonRequired[doc]==true){
                            component.set("v.isLatLongRequired",true);
                        }
                    }
                    var fr = new FileReader();
                    var fileContents; //This variable will contain the file as base64 string
                    var reader = new FileReader();
                    var fileContents;
                    var val = null;
                    
                    reader.onloadend = (function(readerEvent){
                        return function(readerEvent){
                            if(file.type.indexOf("/pdf") == 11){
                                if(component.get("v.isLatLongRequired")  == true){
                                    self.showtoast(component,event,'Error',"Please Select Image file for this document type",'error');
                                    component.set("v.isLatLongRequired",false);
                                    component.set("v.spinnerFlag","false");
                                    self.reset(component,event);
                                    return;
                                }
                                else  if (file.size > self.MAX_FILE_SIZE_PDF) {
                                    this.showtoast(component,event,'Error',"PDF File size cannot exceed 2 MB!",'error');
                                    console.log('File size cannot exceed '+  self.MAX_FILE_SIZE_PDF);
                                    component.set("v.spinnerFlag","false");
                                    self.reset(component,event);
                                    return;
                                }else{
                                    fileContents = readerEvent.target.result;
                                    var base64Mark = 'base64,';
                                    var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                                    fileContents = fileContents.substring(dataStart);
                                    window.setTimeout(
                                        $A.getCallback(function() {
                                            if (component.isValid() && allValid === true) {
                                                try{
                                                    debugger;
                                                    console.log('file contents are'+fileContents);
                                                    self.fireUpload(component,event, file, fileContents);
                                                }catch(e){
                                                    this.showtoast(component,event,'Error',e,'error');
                                                    component.set("v.spinnerFlag","false");
                                                    self.reset(component,event);
                                                    return;
                                                    console.log('exception is -->'+e);
                                                }
                                                
                                            }
                                        }), 10
                                    );
                                }
                            }
                            else if(file.type.indexOf("image/")== 0){
                                var bs = readerEvent.target.result;
                                console.log('bs'+bs);
                                var pic = new Image();
                                pic.src = 'data:image/jpeg;base64,'+ btoa(bs); 
                                pic.onload = function(){
                                 //   alert('EXIF'+EXIF);
                                    EXIF.getData(this, function (){
                                    //    alert('inside exif');
                                      // alert('lat'+EXIF.getTag(this, 'GPSLatitude'));
                                      //  alert('long'+EXIF.getTag(this, 'GPSLongitude'));
                                        var longitude = EXIF.getTag(this, 'GPSLongitude');
                                        var latitude = EXIF.getTag(this, 'GPSLatitude');
                                     //   alert('latlongrequired'+component.get("v.isLatLongRequired"));
                                        if((longitude != null && latitude != null && typeof latitude != 'undefined' && typeof longitude !='undefined') || component.get("v.isLatLongRequired")  == false)  {
                                            if(longitude != null && latitude != null && typeof latitude != 'undefined' && typeof longitude !='undefined'){
                                                console.log('image contains lat long'+(latitude[0].numerator + latitude[1].numerator /(60 * latitude[1].denominator) + latitude[2].numerator / (3600 * latitude[2].denominator)));
                                                component.set("v.latitude", (latitude[0].numerator + latitude[1].numerator /(60 * latitude[1].denominator) + latitude[2].numerator / (3600 * latitude[2].denominator)));
                                                component.set("v.longitude", (longitude[0].numerator + longitude[1].numerator /(60 * longitude[1].denominator) + longitude[2].numerator / (3600 * longitude[2].denominator)));
                                                console.log("latitute"+component.get("v.latitude"));
                                                console.log("longitude"+component.get("v.longitude"));
                                                if(component.get("v.latitude") == null || component.get("v.longitude") == null || isNaN(component.get("v.latitude")) || isNaN(component.get("v.longitude")))
                                                {
                                                    var declat = latitude[0] + (latitude[1]/60) + (latitude[2]/(60*60));
                                                    var declong = longitude[0] + (longitude[1]/60) + (longitude[2]/(60*60));
                                                    console.log('declat'+declat +'declong'+declong);
                                                    component.set("v.latitude",declat);
                                                    component.set("v.longitude",declong);
                                                    
                                                }
                                                
                                            }
                                       //     alert('before compress');
                                            console.log('image upload flag'+ component.get("v.imageUpload"));
                                            if (file.type.includes('image/')) {
                                           //     alert('inside compress logic');
                                                var img = document.createElement("img");
                                                console.log("file is --->"+ file.type);
                                                debugger;
                                                img =  pic;
                                                console.log('Image we are getting is'+img);
                                                //  }
                                                var MAX_WIDTH = 600;
                                                var   MAX_HEIGHT = 800;
                                                
                                                var width = img.width;
                                                var height = img.height;
                                            //    alert('heightbefore'+height + 'widthbefore' + width);
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
                                                ctx.drawImage(img, 0, 1, width, height);
                                            //    alert('heightafter'+height + 'widthafter' + width);
                                                fileContents = canvas.toDataURL('image/jpeg');                  
                                            }else {
                                                
                                                
                                                fileContents = readerEvent.target.result;
                                            }
                                            var base64Mark = 'base64,';
                                            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                                            fileContents = fileContents.substring(dataStart);
                                            
                                            window.setTimeout(
                                                $A.getCallback(function() {
                                                    if (component.isValid() && allValid === true) {
                                                        try{
                                                            debugger;
                                                            console.log('file contents are'+fileContents);
                                                            self.fireUpload(component,event,file,fileContents);
                                                        }catch(e){
                                                            this.showtoast(component,event,'Error',e,'error');
                                                            component.set("v.spinnerFlag","false");
                                                            self.reset(component,event);
                                                            console.log('exception is -->'+e);
                                                        }
                                                        
                                                    }
                                                }), 10
                                            );
                                            
                                        } else {
                                            if(component.get("v.isLatLongRequired") == true){
                                                // self.reset(component);
                                                // component.set("v.imageUpload",false);
                                                self.showtoast(component,event,'Error',"Selected image does not have lat/long assosciated with it!",'error');
                                                component.set("v.spinnerFlag","false");
                                                component.set("v.isLatLongRequired",false);
                                                self.reset(component,event);
                                                console.log('making it false');
                                                return;
                                            }
                                            
                                        }
                                    });
                                };
                                
                            }
                                else{
                                    component.set("v.spinnerFlag","false");
                                    self.showtoast(component,event,'Error',"Please select allowed file type",'error');
                                    self.reset(component,event);
                                    return;
                                }
                        }
                        
                    })(file);
                    console.log('file before'+fileContents+ file.type);
                    console.log(file);
                    if(file.type != null && file.type.includes('image/')) {
                        reader.readAsBinaryString(file);
                    }
                    else{
                   //     alert('file type pdf');
                        reader.readAsDataURL(file); 
                    }
                    
                    console.log('reader content IS'+ reader.result);
                }
        }
        
    },
    
    fireUpload : function(component,event, file, fileContents){
        var uploadType, latitude, longitude;
        latitude = component.get("v.latitude");
        longitude = component.get("v.longitude");
        uploadType = component.get("v.uploadType");
        uploadType = 'attachment';
        var fromPos = 0;
        console.log('file content length'+fileContents.length);
        console.log('chunk size'+this.CHUNK_SIZE);
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        console.log('to pos is'+toPos);
        this.uploadChunk(component,event, file, fileContents, fromPos, toPos, '', uploadType, longitude, latitude);        
    },
    uploadChunk : function(component,event, file, fileContents, fromPos, toPos, attachId, uploadType, longitude, latitude) {
        var apexControllerMethod = component.get("c.saveTheChunk"); 
        var parentId = component.get("v.parentId");  
        var isDeleteInsert = component.get("v.isDeleteInsert"); //17556
        var contentType;
        contentType = file.type;
        console.log('fileContents.length'+fileContents.length);
        var chunk = fileContents.substring(fromPos, toPos);
        var fileName = component.get("v.fileName");
        console.log('file name is'+ fileName);
        console.log('latitude'+latitude + 'longitude' + longitude);
        
        if (latitude) { 
            latitude = latitude.toString();
        }
        if (longitude) { 
            longitude = longitude.toString();
        }
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
                attachId = response.getReturnValue();
                fromPos = toPos;
                console.log('fileContents length'+fileContents.length + 'fromPos'+fromPos+'this.CHUNK_SIZE'+this.CHUNK_SIZE);
                toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
                console.log('fromPos --> ' + fromPos + ' toPos --> ' + toPos);
                if (fromPos < toPos) {
                 //   alert('inside and before upload chunks');
                    this.uploadChunk(component,event,file,fileContents, fromPos, toPos, attachId);  
                }
                else{
                    component.set("v.spinnerFlag","false");
                    this.setDocumentConfiguration(component);
                    this.showtoast(component,event,'Success',"File uploaded successfully !",'success');
                	this.reset(component,event);
                }
            } 
            else if (state === "INCOMPLETE") {
                this.showtoast(component,event,'Error', response.getReturnValue(),'error');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.reset(component,event);
                        this.showtoast(component,event,'Error', errors[0].message,'error');
                    }
                } else {
                    this.reset(component,event);
                    this.showtoast(component,event,'Error','Some error occured while processing','error');
                }
            }
            
                else {
                    component.set("v.spinnerFlag","false");
                    this.reset(component,event);
                    this.showtoast(component,event,'Error',"some error occurred",'error');
                }
            
        });
        
        $A.enqueueAction(apexControllerMethod); 
        
    },
    
    setDocumentConfiguration : function(component,event,helper) {
        var action = component.get("c.getFlowWiseMap");
        var parentId = component.get("v.parentId");
        var flow = component.get("v.Flow");
        action.setParams(
            {
                "strFlow":flow,
                "strLinkedID":parentId
                
            }
        );
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var documentConfig = response.getReturnValue();
                var getAllObject = JSON.parse(documentConfig);
                var varDocumentMappings = getAllObject.mapOfDocumentTypes;
                var varDocumentStatus = getAllObject.uploadStatus;
                var allDocList = getAllObject.mapOfDocList;
                var varMapOfLatLongCheck = getAllObject.mapOfLatLongCheck;
                var DocWrapperList = [];
                var DocStatusList = [];
                var docList = [];
                var latLongList = component.get("v.latLongList");
                for (var Doc in varDocumentMappings){ 
                    var valueObj = {};
                    valueObj.options = varDocumentMappings[Doc];
                    valueObj.selectedFileName = "None";
                    DocWrapperList.push({value:valueObj,key:Doc});
                }
                component.set("v.DocWrapperList",DocWrapperList);
                console.log('doc wrapper list'+JSON.stringify(DocWrapperList));
                console.log('document status list'+JSON.stringify(varDocumentStatus));
                for(var Doc in varDocumentStatus){
                    DocStatusList.push({value :varDocumentStatus[Doc],key:Doc});
                }
                component.set("v.DocStatusList",DocStatusList);
                for (var Doc in allDocList){ 
                    docList.push({value:allDocList[Doc],key:Doc}); 
                }
                component.set("v.uploadedAttachments",docList);
                console.log('all document List'+JSON.stringify(component.get("v.uploadedAttachments")));
                for (var Doc in varMapOfLatLongCheck){ 
                    latLongList[Doc] = varMapOfLatLongCheck[Doc];
                }
                console.log('latLongList'+JSON.stringify(latLongList));
                component.set("v.latLongList",latLongList);
                component.set("v.spinnerFlag","false");
                return;
            }
             else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.showtoast(component,event,'Error', errors[0].message,'error');
                        }
                    } 
                }
            
            
        });
        $A.enqueueAction(action);
    },
    
    deleteAttachment : function(component, attachId) {
        var action = component.get("c.removeAttachment");
        action.setParams({
            "attachId" : attachId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                this.setDocumentConfiguration(component);
                this.showtoast(component,event,'Success',"File deleted successfully !",'success');
            }
             else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.showtoast(component,event,'Error', errors[0].message,'error');
                        }
                    } 
                }
            
        });
        $A.enqueueAction(action);
    },
    showtoast:function(component,event, title, message, type){
        var self = this;
        console.log('self',self);
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){ //Standard toast message : if supports standard toast message
            console.log('Inside standard toast');
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "3000"
            });    
            toastEvent.fire();
        }else{//Custom toast message : if doesn not support standard toast message
            console.log('inside displayToastMessage'+message+type);
            var showhideevent =  $A.get("e.c:ShowCustomToast");
            console.log('showhideevent--> '+showhideevent);
            showhideevent.setParams({
                "title": title,
                "message":message,
                "type":type
            });
            showhideevent.fire();     
        }
    },
     reset : function(component,event){
         event.target.value = '';
       /*  var selecetdFileIds = component.find("fileAuraId");
         alert('selecetdFileIds'+selecetdFileIds);
         for (var fileId in selecetdFileIds){ 
             alert(fileId.getElement().value);
            // fileId.getElement().value = '';
           
         }
         for (var doc in Documents){ 
             doc.set("v.value",'');
         }
         //alert('id value'+component.find("fileAuraId"));
         // component.find("fileAuraId").getElement().value = "";
         //component.find("fileAuraId").set("v.value",'');
         //component.find("Documents").set("v.value",'');
         //return;
         //*/
    },
    getGeolocation :function(component,helper)
    {
       // alert('test in inside'+navigator.geolocation);
        var latitude;
        var longitude;
        if (navigator.geolocation) 
        { 
          //  alert('test first block');
            if(navigator.geolocation.getCurrentPosition == undefined)
            {
//                alert('position null');
            }
            
            navigator.geolocation.getCurrentPosition(function(position) {
                //alert('Inside navigator.geolocation');
                console.log('before calculating co-ordinates');
                latitude=position.coords.latitude;
                longitude=position.coords.longitude; 
                
                /*   if(position.coords.latitude == undefined || position.coords.latitude == null)
                {
                    this.displayNotification(component,"Warning","Please check GPS connection.");  
                    setTimeout(function() {
                        component.set("v.body",[]);
                    },5000);
                }
				*/
                   component.set("v.latitude",latitude);
                   component.set("v.longitude",longitude);
                  // alert('latitude in helper method:'+component.get("v.latitude"));
                return;
                   //isError = false;
               }); 
          
           }
        else{
        //    alert('else loc');
              return;
        }
        component.set("v.spinnerFlag","true");
   }
})