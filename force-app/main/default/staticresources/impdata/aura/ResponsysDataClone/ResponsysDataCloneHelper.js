({
    genReport : function(component, event) {
        var products = component.get("v.products");
        var stages = ["Moved to finnone"];
        var smsType = component.find("smsType").get("v.value");
        console.log('--> '+JSON.stringify(component.get("v.selectedproducts")));
        this.executeApex(component,"fetchRespData",{"paramsMap":{"products":JSON.stringify(component.get("v.selectedproducts")),
                                                                 "StartDate":JSON.stringify(component.get("v.startDate")),
                                                                 "endDate":JSON.stringify(component.get("v.endDate")),
                                                                 "stages":JSON.stringify(stages),
                                                                 "TypeOfRep":component.get("v.TypeOfReport"),
                                                                 "smsType":smsType}},
                         function(error,result){
                             var response = JSON.parse(result);
                             component.set("v.ResponseData",response);
                             var respDat = component.get("v.ResponseData");
                             console.log('respDat'+respDat.status);
                             if(respDat.status=='SUCCESS'){
                                 var respEvent = $A.get("e.c:ResponsysDataTable");
                                 respEvent.setParams({
                                     "RespData" : respDat
                                 });
                                 respEvent.fire();
                                 component.set("v.errors", [""]);
                                 console.log(respDat.wrapList[0]);    
                             }
                             else{
                                 component.set("v.errors", ["No results for given parameters."]);
                             }
                             
                             
                         });
    },
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    init: function(component, event) {
        this.executeApex(component,"initialize",{},function(error,result){
            var response = JSON.parse(result);
            var proList = response.products.split(',');
            var products = new Array();
            console.log('proList'+proList);
            for(var i=0;i<proList.length;i++){
                console.log(proList[i]);
                products.push({value:proList[i], label:proList[i]});
            }
            component.set("v.products",products);
        });
    },
    generateCsv: function(component, event) {
        component.set("v.TypeOfReport","Detail");
        var products = component.get("v.products");
        var stages = ["Moved to finnone"];
        var self = this;
        var smsType = component.find("smsType").get("v.value");
        this.executeApex(component,"fetchRespData",{"paramsMap":{"products":JSON.stringify(component.get("v.selectedproducts")),
                                                                 "StartDate":JSON.stringify(component.get("v.startDate")),
                                                                 "endDate":JSON.stringify(component.get("v.endDate")),
                                                                 "stages":JSON.stringify(stages),
                                                                 "TypeOfRep":component.get("v.TypeOfReport"),
                                                                 "smsType":smsType,
                                                                 "LAN":component.get("v.LAN")}},
                         function(error,result){
                             var response = JSON.parse(result);
                             if(error)
                                 alert(error);
                             var csv = self.convertArrayOfObjectsToCSV(component,response.wrapList);
                             console.log('csv::::'+csv);
                             if(csv){
                                 component.set("v.errors", [""]);
                                 var today_date = new Date();
                                 today_date = new Date(today_date).toUTCString();
								 today_date = today_date.split(' ').slice(0, 4).join(' ');
                                 var time_string = (new Date()).getHours()+':'+(new Date()).getMinutes()+':'+(new Date()).getSeconds();	
                                 var hiddenElement = document.createElement('a');
                                 hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                                 hiddenElement.target = '_self'; // 
                                 hiddenElement.download = 'ResponsysData_'+today_date+'-'+time_string+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
                                 document.body.appendChild(hiddenElement); // Required for FireFox browser
                                 hiddenElement.click(); // using click() js function to download csv file
                             }
                             else{
                                 component.set("v.errors", ["No results for given parameters."]);
                             }
                         });
        //code for generating csv
        
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider, colHeaders;
        
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
        keys = ['Loan_name','smsName','prod','LAN','smsId','event','status'];
        colHeaders = ['Loan Application Name','SMS Sent Name','Product','LAN','SMS Sent Id','Event','Status'];
        csvStringResult = '';
        csvStringResult += colHeaders.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                
                
                
                if(skey=='LAN'){
                    console.log('entered LAN Check');
                    csvStringResult += '"'+ objectRecords[i][skey]+'\'"'; 
                    //csvStringResult += ('"'+'\'"'+ objectRecords[i][skey]);
                }
                else
                    csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        // return the CSV formate String 
        console.log(csvStringResult);
        return csvStringResult;        
    },
    validateFields : function(component, event, helper){
        var stDate = component.get("v.startDate");
        var enDate = component.get("v.endDate");
        var selList = component.get("v.selectedproducts");
        var errorFlag = false;
        component.set("v.TypeOfReport","Summary");
        console.log(selList);
        if(!enDate && !stDate){
            component.set("v.errors", ["Please specify start and end dates."]);
            errorFlag = true;
        }
        else if(!stDate){
            console.log('reached');
            component.set("v.errors", ["Please specify start date."]);
            errorFlag = true;
        }
            else if(!enDate){
                console.log('reached');
                component.set("v.errors", ["Please specify end date."]);
                errorFlag = true;
            }
                else if(stDate>enDate){
                    component.set("v.errors", ["Start Date cannot be after end Date."]);
                    errorFlag = true;
                }
        
                    else if(enDate && stDate){
                        component.set("v.errors", [""]);
                    }
        if(selList.length==0){
            component.set("v.errors", ["Please select at least one product."]);
            errorFlag = true;
        }
        return errorFlag;
    }
})