({
	parseData : function(component, event) {
		var datars = component.get("v.dataRows");
        if(datars != null && datars != undefined){
            var parsedData = new Array();
            for(var index = 0; index < datars.length; ++index){
                var map = [];
                for(var Key in datars[index]){
                    if(!Key.includes('marketOpen') && !Key.includes('marketClose')){
                    	map.push({value:datars[index][Key],Key:Key});	
                    }
                }
                map.index = index;
                parsedData.push(map);
            }
            component.set("v.dataRows",parsedData);
            
            console.log(component.get("v.dataRows"));
        }
	},
    createcmp :function(component,Name,params,divName){
        var cmpName = "c:"+Name;
        
         console.log('in create');
            $A.createComponent(
                cmpName,params,
            function(newComponent,status,errorMessage){
                if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    var targetCmp = component.find(divName);
                    	var body = targetCmp.get("v.body");
                    	body.push(newComponent);
                    	targetCmp.set("v.body", body);
                    
                    }
                    else if (status === "INCOMPLETE") {
                       console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                    }
            }
        )
        
    }
})