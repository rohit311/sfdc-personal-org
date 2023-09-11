({
    CHUNK_SIZE: 750000, 
     fetchPickListVal: function(component) {
    },
    
    
    ReadFile: function (component,csv) {
        
        console.log('@@@ Incoming csv = ' + csv);
        var arr = []; 
        arr =  csv.split('\n');;
        console.log('@@@ arr = '+arr);
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
     
        for(var x=0;x<headers.length;x++){
            headers[x]=headers[x].replace(/\s/g,'')
            if(headers[x]==undefined || headers[x]==null || headers[x]=='')
            {
                console.log('Null header::'+headers[x]);
               
                	

            }
            console.log('header****'+headers[x])
        }
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            console.log("DAta::"+data);
            var obj = {};
            
            for(var j = 0; j < data.length; j++) {
                if(data[j]!=undefined || data[j]!=null || data[j]!='' || headers[j]!=undefined|| headers[j]!=null || headers[j]!=''){
                   /* if(data[j]=="***skip this***"){
                        continue;
                    }else{*/
                  //  if(data[j].includes("\"")&& data[j+1].includes("\"")){
                   //     console.log('include here'+data[j]+data[j+1])
                  //      data[j]=data[j]+" "+data[j+1];
                   //     data[j+1]="***skip this***";
                        obj[headers[j]] = data[j];
                     
                          console.log('@@@ obj headers = ' + obj[headers[j]]);
                    //}
                   // else{  
                  //  obj[headers[j].trim()] = data[j].trim();
                     //     console.log('@@@ obj headers = ' + obj[headers[j]]);
                    //}
                //}
                   
                }
               // console.log('@@@ obj headers = ' + obj[headers[j]]);
            }
          
            jsonObj.push(obj);
            
        }
        
        console.log('jsonOBJ' +JSON.stringify(jsonObj));
        var json = JSON.stringify(jsonObj,null, '  ').replace(/\\r/g, "");
       // var json1=JSON.stringify(json, null, '  ').replace("\\r", " ");
        console.log('@@@ json = '+ json);
        console.log(typeof(json));
        return json;
    },
     
    insertData: function (component,csvbody) {
        console.log('csv body for server call****'+csvbody);
        var fileBody = component.get("c.getInsertData");
        var utility = component.find("toastCmp");
        fileBody.setParams({
            "csvFilebody" : csvbody,
            "srcChannelName" : component.get("v.selectedSourceChannel"),
            "flow" : "Bulk_Upload"
            
        });
           fileBody.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                //alert('Request complete. Report is downloaded to your system');
                 
                var resp = response.getReturnValue();
                if(!resp.includes('EXCEPTION')){
                    console.log('Response returned*****'+resp);
               		this.downloadCsv(component,event,resp);
                    utility.showToast('Success!', 'Action Complete. Success/Failure status Report is downloaded to your system!', 'success');
                }
                else{
                   utility.showToast('Error!', 'An error occurred. '+resp.split('EXCEPTION')[1], 'error');  
                }
                
            }
               else if(status === "ERROR"){
                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    console.log('Error message****'+errors[0].message);
                    //component.set("v.errorMsg", errors[0].message);
                    //alert('error');
                    utility.showToast('Error!', 'Error occurred while calling method to upload record. Please contact your administrator', 'error'); 
                } 
            }
            component.set("v.isProcessing",false);
            var successfulRecordList = component.get("v.successfulRecords");
            this.createloan(component,event,successfulRecordList);
        }); 
        $A.enqueueAction(fileBody);
    },
    
    downloadCsv : function(component,event,resp){
        console.log('inside downloadcsv function****'+resp);
        var responseData = resp;
        //call the helper function which "return" the CSV data as a String   
        var csv = this.convertArrayOfObjectsToCSV(component,resp); 
        //console.log('Name**'+allRecords[0].Name);
         if (csv == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = component.get("v.fileName").split('.csv')[0]+' Report.csv';  // CSV file Name* you can change it.[only name not .csv] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
        },
    
    convertArrayOfObjectsToCSV : function(component,responseData){
        // declare variables
        console.log('Data in convertArrayOfObjectsToCSV****'+responseData);
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        //var recordStatusMap1 = JSON.parse(responseData).RecordStatusMap;
        var allRec = JSON.parse(responseData).AllRecordsList;
        var allRecordsList = JSON.parse(allRec);
        var allRecMap = JSON.parse(responseData).AllRecordsMap;
        var allRecordsMap = JSON.parse(allRecMap);
        var insertMap = JSON.parse(responseData).InsertStatusMap;
        var insertStatusMap = JSON.parse(insertMap);
        var successRec = JSON.parse(responseData).SuccessRecList;
        var successRecList = JSON.parse(successRec);
        component.set("v.successfulRecords",successRecList); //storing successfully inserted records
        //console.log('Key status****'+keyStatus);
        // check if "objectRecords" parameter is null, then return from function
        if (allRecordsList == null || !allRecordsList.length) {
            return null;
         }

        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        var headerNames = $A.get("$Label.c.csv_file_headers");
        //keys = ['Name','First_Name__c','Last_Name__c','Middle_Name__c'];
        keys = headerNames.split(';');
        console.log('Key values*****'+keys);
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        var status = 'Status';
 		
        for(var i=0; i < allRecordsList.length; i++){   
        //for(var mapKey in responseDataObj){
            //console.log('inside for iteration****'+JSON.parse(JSON.stringify(mapKey1)));
            //var mapKey = JSON.parse(JSON.stringify(mapKey1));
            counter = 0;
           
             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ; 
                 console.log('Key***'+skey);
 
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }   
               
               	//debugger;
                 if(skey.toUpperCase() != status.toUpperCase()){
                    console.log('Key in if*****'+skey);
                    csvStringResult += '"'+ allRecordsList[i][skey]+'"'; 
                 	//console.log('allRecords[i][skey]'+allRecordsList[i][skey]); 
                 }
                 
               
               counter++;
 
            } // inner for loop close 
            var a = allRecordsList[i]['PANNumber']+'-'+allRecordsList[i]['PolicyNumber']+'-'+allRecordsList[i]['Sfin'];
            console.log('Key***'+a);
             csvStringResult +=insertStatusMap[a];
             csvStringResult += lineDivider;
            console.log('final string****'+csvStringResult);
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;     
    },
    
     createloan : function(component,event,successfulRecordList){
         console.log('Inside createloan***'+JSON.stringify(successfulRecordList));
          var utility = component.find("toastCmp");
         var createLoan = component.get("c.createLoanFromCSV");
        createLoan.setParams({
            "successData" : JSON.stringify(successfulRecordList)            
        });
           createLoan.setCallback(this,function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var resp = response.getReturnValue();
                if(resp.includes('EXCEPTION')){
                    console.log('An error occurred: '+resp.split('EXCEPTION')[1]);
                    utility.showToast('Error!', 'An error occurred while calling batch to create loan', 'error'); 
                }
            }
               else if(status === "ERROR"){
                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    //component.set("v.errorMsg", errors[0].message);
                    console.log('Error message****'+errors[0].message);
                    //alert('error');
                    utility.showToast('Error!', 'Error occurred while calling method to create loan.', 'error'); 
                } 
            }
        }); 
        $A.enqueueAction(createLoan);
     },
   
 /* CSVtoArray: function(component,text){
    var re_valid = /^\s*(?:'[^'\\]*(?:\\[\S\s][^'\\]*)*'|"[^"\\]*(?:\\[\S\s][^"\\]*)*"|[^,'"\s\\]*(?:\s+[^,'"\s\\]+)*)\s*(?:,\s*(?:'[^'\\]*(?:\\[\S\s][^'\\]*)*'|"[^"\\]*(?:\\[\S\s][^"\\]*)*"|[^,'"\s\\]*(?:\s+[^,'"\s\\]+)*)\s*)*$/;
    var re_value = /(?!\s*$)\s*(?:'([^'\\]*(?:\\[\S\s][^'\\]*)*)'|"([^"\\]*(?:\\[\S\s][^"\\]*)*)"|([^,'"\s\\]*(?:\s+[^,'"\s\\]+)*))\s*(?:,|$)/g;
    // Return NULL if input string is not well formed CSV string.
    if (!re_valid.test(text)) return null;
    var a = [];                     // Initialize array to receive values.
    text.replace(re_value, // "Walk" the string using replace with callback.
        function(m0, m1, m2, m3) {
            // Remove backslash from \' in single quoted values.
            if      (m1 !== undefined) a.push(m1.replace(/\\'/g, "'"));
            // Remove backslash from \" in double quoted values.
            else if (m2 !== undefined) a.push(m2.replace(/\\"/g, '"'));
            else if (m3 !== undefined) a.push(m3);
            return ''; // Return empty string.
        });
    // Handle special case of empty last value.
    if (/,\s*$/.test(text)) a.push('');
    return a;
}*/
})