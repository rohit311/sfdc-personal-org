({
	checkDecimal : function (val)
	{
        
    	if(!isNaN(val)  && Math.floor(val)!= val)
        {    
             console.log('val in check decimal*** '+val);
             return true;
        }   
        else 
             console.log('false val in check decimal '+val);
              return false;
         
	},
    calcDistance : function(component,event,latold,longold,latnew,langnew){
       
                var currentLat = parseFloat(latold);
                var currentLng = parseFloat(longold);
               var leadLat;
               var leadLong;
                if(!$A.util.isEmpty(latnew) && !$A.util.isEmpty(langnew)){
                	leadLat = parseFloat(latnew);
                	leadLong = parseFloat(langnew);
                }
                if(!isNaN(leadLat) && !isNaN(leadLong)){
                    var R = 6371; // kmetres
                    var φ1 = this.toRadian(leadLat)//.toRadians();// φ => lat in radians
                    var φ2 = this.toRadian(currentLat)//.toRadians();
                    var Δφ = this.toRadian((currentLat-leadLat))//.toRadians();
                    var Δλ = this.toRadian((currentLng-leadLong))//.toRadians(); // Δλ => lng in radians
                    
                    var a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
                        Math.cos(φ1) * Math.cos(φ2) *
                        Math.sin(Δλ/2) * Math.sin(Δλ/2);
                    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
                    
                    var d = (R * c);
                    
                    return d*1000;
                  
                }
                else{
                
                }
            
           // component.set("v.distPOList", poDistMap);
          //  console.log('poDistMap'+poDistMap.length);
          //  callback.call(component);
        },
     toRadian : function(val){
        return val * Math.PI / 180;
    },
      executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('in execute apex');
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
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
})