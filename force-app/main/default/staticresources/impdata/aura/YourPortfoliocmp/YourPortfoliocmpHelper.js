({
    /* CSV changes S */
    csvToJSON : function(component,fileData){
        //console.log('@@@ Incoming fileData = ' + fileData);        
        var dataArray = [];         
        dataArray =  fileData.split('\n');;
        
        //console.log('@@@ dataArray = ' + dataArray);
        
        dataArray.pop();
        var jsonObj = [];
        var headers =  dataArray[0].split(',');
        
        var test1 = [];
        var dataArray1 = fileData.split('\n');       
        
        var invNames = [];
        var test = [];
        if(dataArray1.length != 0 )
        {
            for(var i = 1;i< dataArray1.length;i++)
            {
                if( dataArray1[i].trim() != '' &&  dataArray1[i] != null    )
                {
                    var names = dataArray1[i].split(',');   
                    if(names[0] || names[1])
                    {
                        invNames.push({
                            'invType' : names[0].trim(),
                            'invName' : names[1].trim(),
                            'quantity' : names[2].trim(),
                            'isin' : names[3].trim()	
                        });
                    }
                    //console.log("ISIN " + names[3]);
                }
            }
        }
        //console.log('INV names ****** ' + JSON.stringify(invNames));
        //console.log('ISIN ****' + invNames[1].isin);
        component.set("v.invNames" , invNames);
        /*headers*/
        for(var a = 0;a < headers.length; a++)
        {
            //  console.log('####### ' + headers[a]);
            if(headers[a].includes("type"))
            {
                headers[a] = "invType";
            }else if(headers[a].includes("name"))
            {
                headers[a] = "invName";
            }else if (headers[a].includes("Quantity") || headers[a].includes("number"))
            {
                headers[a] = "quantity";
            }
            
        }
        headers[headers.length] = "countID";
        //console.log("Headers #### " + headers);   
        for(var i = 1; i < dataArray.length; i++)
        {
            var data = dataArray[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length ; j++) 
            {                
                obj[headers[j].trim()] = data[j].trim();
                //console.log('@@@ obj headers = ' + obj[headers[j].trim()]);
            }
            obj[headers[data.length].trim() ]= 0;
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        //console.log('@@@ json = '+ json);
        return jsonObj;
    },
    
    processFileData : function(component, fileContents)
    {        
        var action = component.get("c.addPortfolio");  
        var id1=component.get("v.recordId");  
        //console.log("loan id " + id1);
        action.setParams({
            //"inputFromFile":fileContents,
            "AccId":id1
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var name = a.getReturnValue();
                //  component.set("v.secLst",name);
                //console.log("Property Detials ******* " + JSON.stringify(name));           
            }
            else
            {
                alert("Error while fetching data");
            }
        });       
        $A.enqueueAction(action);   
    },
    
    checkInvName : function(component ){        
        var action = component.get("c.getScripName");  
        var id1=component.get("v.recordId");  
        var invNames = component.get("v.invNames");
        //console.log("loan id " + invNames);
        action.setParams({
            "invNames":JSON.stringify(invNames),
            "input":"id1"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var name = a.getReturnValue();
                //console.log("Scrip Names ******* " + JSON.stringify(name));
                component.set("v.secLst" , name);
            }
            else
            {
                alert("Error while fetching data");                
            }
        });       
        $A.enqueueAction(action);                 
    }    
    /* CSV changes E */
})