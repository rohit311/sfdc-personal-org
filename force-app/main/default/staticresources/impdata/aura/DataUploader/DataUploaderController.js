({ 
    doInit: function(component, event, helper) {
        var srcLabelValues=$A.get("$Label.c.csv_Upload_Sourcing_Channel");
        var srcChannel = [];
         if(srcLabelValues){
             srcChannel = srcLabelValues.split(';');
         }
         var sChannelList = [];    sChannelList.push({label:'--None--', value: null});
         if (srcChannel)
         {
            for(var i =0; i< srcChannel.length; i++)
            	{
                	if (srcChannel[i])
                    {
						sChannelList.push({
                        	label : srcChannel[i],
                            value : srcChannel[i]
                        });
                     }
                 }
          }
         component.set("v.sourceChannelList",sChannelList);
         console.log('Sourcing channels****'+component.get("v.sourceChannelList"));
    },
    
    /*onPicklistChange: function(component, event, helper) {
        alert(event.getSource().get("v.value"));
    },*/
    
    /*doSave: function(component, event, helper) {
        alert('Inside dosave'+component.get(v.selectedSourceChannel));
        if (component.find("file").get("v.files").length = null)
        {        
            alert('Please Select a Valid File');
        } 
        else {
            //this.onInsert();
        }
    },*/
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    onInsert : function(component, event, helper) { 
        //alert('Inside dosave'+component.get('v.selectedSourceChannel'));
        var utility = component.find("toastCmp");
        if(component.get("v.selectedSourceChannel")){
            if(component.get("v.fileName")!="No File Selected.." && component.get("v.fileName").substring(component.get("v.fileName").length-4) == ".csv"){
                component.set("v.isProcessing",true);
                var MAX_FILE_SIZE=300000;
                var fileName = component.find("file").get("v.value") ;
                var fileInput = component.find("file").get("v.files");
                var file = fileInput[0];
                //alert('File::'+file);        
                var reader = new FileReader();
                reader.readAsText(file);
                
                reader.onload = function(evt) {
                    console.log("EVT FN");
                    var Data=evt.target.result;
                    
                    console.log("Reader Result:"+evt.target.result);
                    console.log("Data:"+Data);
                    var fileContent=helper.ReadFile(component,Data);
                    //console.log('myData =' +fileContent.replace(" \r","" )) ;
                    console.log('File content***'+fileContent);
                    window.setTimeout($A.getCallback(function(){
                        helper.insertData(component,fileContent);
                    }), 10);
                }
                reader.onerror = function (evt) {
                    console.log("error reading file");
                    //alert("error reading file");
                    utility.showToast('Error!', 'Error Reading csv file!', 'error'); 
                    component.set("v.isProcessing",false);
                }
            }
            else{
                //alert('Please upload a Valid File');
                utility.showToast('Error!', 'Please upload a Valid File!', 'error');
                component.set("v.isProcessing",false);
            }
        }
        else{
            //alert('Please select sourcing channel ');
            utility.showToast('Error!', 'Please select sourcing channel!', 'error');
        }
    }, 
    
})