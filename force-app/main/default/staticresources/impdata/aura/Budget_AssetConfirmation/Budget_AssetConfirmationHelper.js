({
    handleAccept : function(cmp, evt , helper, sAcceptOrReject){
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.saveAssetAnswer");
        var utility = cmp.find("toastCmp");
        try{
            var sIp = cmp.get('v.ipAddr');
            var sReason = cmp.get("v.rejectReason");
            if(typeof sIp != 'undefined' && sIp != '' )
            {
                action.setParams({
                    acceptOrReject: sAcceptOrReject,
                    ip: sIp,
                    rejectReason : sReason
                });
                action.setCallback(this, function(response){
                    cmp.set("v.rejectReason" , ""); 
                    var res = response.getReturnValue();
                    if(res == 'SUCCESS'){
                        utility.showToast('Success!', 'Saved successfully.!' , 'success');
                        cmp.set("v.showSpinner", false);
                    }
                    else{
                        utility.showToast('Error!', 'Something went wrong. Please check your data once, or contact your administrator.' , 'error');
                        cmp.set("v.showSpinner", false);
                    }
                });
            }
                
        }catch(errorWhileAccept){
            console.log(errorWhileAccept);
            cmp.set("v.showSpinner", false);            
        }
        $A.enqueueAction(action);
    },
    initiateDownload : function(cmp, evt, helper)
    {
        var action = cmp.get("c.getUserReport");
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            var businessUnit ;
            var utility = cmp.find("toastCmp");
            
            if(typeof data == 'undefined' || data == '' || data == undefined)
            {
                utility.showToast('Error!', 'Please check user has proper BU or it has active users to download the data.' , 'error');
                cmp.set("v.showSpinner", false);
            }
            else
            {
                try
                {
                    businessUnit = data[0].Business_Unit__c;
                    var csvData = helper.convertArrayOfObjectsToCSV(cmp, data);
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvData);
                    hiddenElement.target = '_self'; // 
                    var currentdate = new Date(); 
                    var fileName = currentdate.getDate() + '-' + currentdate.getMonth() + '-' +currentdate.getFullYear() + '_' +currentdate.getHours() + ':' + currentdate.getMinutes() + ':' +currentdate.getSeconds() ;				
                    fileName  = 'Users___' + businessUnit + '___' + fileName;
                    hiddenElement.download = fileName + '.csv';  // CSV file Name* you can change it.[only name not .csv] 
                    document.body.appendChild(hiddenElement); // Required for FireFox browser
                    hiddenElement.click(); // using click() js function to download csv file*/
                    cmp.set("v.showSpinner", false);
                    utility.showToast('Success!', 'Downloaded successfully.!' , 'success');
                    cmp.set("v.isDownloadDone", true);
                    
                }catch(err){
                    console.log('ERR: '  +err);
                    utility.showToast('Error!', 'Something went wrong. Please contact your administrator!' , 'error');
                    //utility.showToast('Success!', 'Saved successfully.!' , 'success');
                }
            }
        });
        $A.enqueueAction(action);
    },   
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        keys = ['User name','Email Id', 'User Id' ,'Profile Name', 'Business Unit' ,'Employee ID',  'Last Login Date', 'Created Date' ];
        var apiKeys = ['Username','Email','Id','Profile Name', 'Business_Unit__c' ,'Employee_ID__c', 'LastLoginDate', 'CreatedDate' ];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in apiKeys) 
            {
                var skey = apiKeys[sTempkey] ;  
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                //console.log(sTempkey);
                //console.log(skey);
                //console.log(objectRecords[i]['Profile']['Name']);
                
                if(skey.indexOf('Profile') != -1 )
                {
                    csvStringResult += '"'+ objectRecords[i]['Profile']['Name'] +'"'; 
                    
                }
                else{
                    csvStringResult += '"'+ objectRecords[i][skey]+'"';     
                }
                
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        return csvStringResult;        
    }
})