({
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.lstPo");
        console.log('sortAsc'+sortAsc);
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            if($A.util.isEmpty(a[field])){
                return 1;
            }
            else if($A.util.isEmpty(b[field])){
                return -1;
            }
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.lstPo", records);
        
        var PaginationList = [];
        var pageSize = component.get("v.pageSize");
        for(var i=0; i< pageSize; i++){
            if(records.length> i)
                PaginationList.push(records[i]);    
        }
        console.log('PaginationList'+PaginationList.length);
        component.set('v.PaginationList', PaginationList);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        component.set("v.sortAscDist", true);
        console.log('component'+component.get("v.sortAsc"));
        
    },
    setData: function(component){
        //alert('check');
        this.showhidespinner1(component,event,true);
        console.log('length >>>>'+component.get("v.lstPo").length);
        var pageSize = component.get("v.pageSize");
        component.set("v.totalRecords", component.get("v.lstPo").length);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        var totRec = component.get("v.lstPo").length;
        var rem = totRec % pageSize;
        if(rem > 0){
            component.set("v.totalPages",Math.floor((totRec/pageSize))+1);
        }
        else{
            component.set("v.totalPages",(totRec/pageSize));
        }
        var poList = [] = component.get("v.lstPo");
        
        var PaginationList = [];
        var validExotelProd=component.get("v.validExotelProd");//Added for Bug 23064
        var newPoList = [];//Added for Bug 23064
        //alert(validExotelProd);
        for(var i=0; i< pageSize; i++){
            if(poList.length > i){
			//Added for bug 23064
              for(var j=0 ; j < validExotelProd.length ; j++){
                    if(validExotelProd[j].toUpperCase() === (poList[i].Products__c).toUpperCase()){
                       newPoList.push({'po':poList[i],'showCall':true});
                       //poList[i].Converted_To_Salaried__c=true;
                    }
                }
                PaginationList.push(poList[i]);    
        }
         }  
        component.set("v.newPoList",newPoList);//Added for Bug 23064
        component.set("v.lstPo",poList);//Added for bug 23064
        console.log('PaginationList'+PaginationList.length);
        component.set('v.PaginationList', PaginationList);
        this.showhidespinner1(component,event,false);
    },
//Added for bug 23064 start
    getValidExotelProd: function(component, event){
        debugger;
        this.executeApex(component,'getvalidExotelProduct', {
        }, function (error, result) {
            
         console.log('PR_Result'+result);
            if (!error && result) {
               
                var data=JSON.parse(result);
                component.set("v.validExotelProd",data);
                 this.setData(component);
                
            } 
        
        }); 
    },
//Added for Bug 23064 end
    next : function(component, event){
        var sObjectList = component.get("v.lstPo");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
           var validExotelProd=component.get("v.validExotelProd");//Added for Bug 23064
        var newPoList = [];//Added for Bug 23064
        for(var i= end ; i<end+pageSize; i++){
            if(sObjectList.length > i){
                //Added for bug 23064
              for(var j=0 ; j < validExotelProd.length ; j++){
                    if(validExotelProd[j].toUpperCase() === (sObjectList[i].Products__c).toUpperCase()){
                       newPoList.push({'po':sObjectList[i],'showCall':true});
                       //poList[i].Converted_To_Salaried__c=true;
                    }
                }
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        // component.set("v.sortAsc",false);
         component.set("v.newPoList",newPoList);//Added for Bug 23064
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")+1);
    },
    
    previous : function(component, event){
        var sObjectList = component.get("v.lstPo");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        var validExotelProd=component.get("v.validExotelProd");//Added for Bug 23064
        var newPoList = [];//Added for Bug 23064
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                                //Added for bug 23064
              for(var j=0 ; j < validExotelProd.length ; j++){
                    if(validExotelProd[j].toUpperCase() === (sObjectList[i].Products__c).toUpperCase()){
                       newPoList.push({'po':sObjectList[i],'showCall':true});
                       //poList[i].Converted_To_Salaried__c=true;
                    }
                }
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        // component.set("v.sortAsc",false);
         component.set("v.newPoList",newPoList);//Added for Bug 23064

        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")-1);
    },
    getGeolocation :function(component,event,callback){
        var latitude;
        var longitude;
        
        console.log("Inside GeoLocation");
        //alert('inside geo11');
        if (navigator.geolocation) {
            //alert('inside geo111');
            if(navigator.geolocation.getCurrentPosition == undefined) {
                //alert('in fail');
                component.set("v.isGPSEnabled", false);
                console.log('position null');
            }
            
            //alert('inside geo111');
            // to call on success of gps location.
            function successF(position) {
                console.log('before calculating co-ordinates'+this);
                latitude=position.coords.latitude;
                longitude=position.coords.longitude; 
                
                if(position.coords.latitude == undefined || position.coords.latitude == null) {
                    component.set("v.isGPSEnabled", false);
                    setTimeout(function() {
                        component.set("v.body",[]);
                    },5000);
                }
                component.set("v.latitude",latitude);
                component.set("v.longitude",longitude);
                component.set("v.isGPSEnabled", true);
                callback.call(component,event);
            }
            /*function failureF(err){
                component.set("v.isGPSEnabled", false);
                console.log('User denied geolocation');
                console.warn(`ERROR(${err.code}): ${err.message}`);
                callback.call(component);
            }*/
            function failureF(err){
                component.set("v.isGPSEnabled", false);
                console.log('User denied geolocation');
                //console.warn('ERROR(${err.code}): ${err.message}');
                callback.call(component);
            }
            //geolocation options
            var options = {
                timeout : 5000,
                enableHighAccuracy: true,
                maximumAge: 0
            };

            navigator.geolocation.getCurrentPosition(successF, failureF,options);
            
                        
        } else {
            //alert('inside geo11');
            component.set("v.isGPSEnabled", false);
        }
    },
    calcDistance : function(component,event,callback){
        var poDistMap = [];
        var POList = component.get("v.lstPo");
        if(POList != null){
            for(var poX = 0;poX<POList.length;poX++){
                var currentLat = parseFloat(component.get("v.latitude"));
                var currentLng = parseFloat(component.get("v.longitude"));
                var leadLat,leadLong; 
                if(!$A.util.isEmpty(POList[poX].Lead__c)){
                	leadLat = POList[poX].Lead__r.CheckINLocation__Latitude__s;
                	leadLong = POList[poX].Lead__r.CheckINLocation__Longitude__s;
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
                    poDistMap.push({
                        name: POList[poX],
                        value: d
                    });
                	
                }
                else{
                    poDistMap.push({
                        name: POList[poX],
                        value: ''
                    });
                }
            }
            component.set("v.distPOList", poDistMap);
            console.log('poDistMap'+poDistMap.length);
            callback.call(component);
        }
        
        
    },
    sortByDist : function(component){
        if(component.get("v.isGPSEnabled")){
            var sortAsc = component.get("v.sortAscDist");
            console.log('in sort by distance');
            var poDistMap = component.get("v.distPOList");
            
            var sortedMap = poDistMap.sort(function(a, b) {
                var t1 = a.value == b.value,
                t2 = a.value > b.value;
                if($A.util.isEmpty(a.value)){
                    return 1;
                }
                else if($A.util.isEmpty(b.value)){
                    return -1;
                }
                return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
            });
            
            if(sortAsc){
                sortAsc = false;
            }
            else{
                sortAsc = true;
            }
            var finalPOList = [];
            for(var i=0;i<sortedMap.length;i++){
                console.log('sortedMap'+sortedMap.length);
                if(!$A.util.isEmpty(sortedMap[i])){
                	finalPOList.push(sortedMap[i].name);
                }
            }
            component.set("v.sortAscDist", sortAsc);
            component.set("v.sortField", '');
            component.set("v.sortAsc", true);
            component.set("v.lstPo", finalPOList);
            var PaginationList = [];
            var pageSize = component.get("v.pageSize");
            for(var i=0; i< pageSize; i++){
                if(finalPOList.length> i)
                    PaginationList.push(finalPOList[i]);    
            }
			console.log('PaginationList'+PaginationList.length);            
            component.set('v.PaginationList', PaginationList);
            component.set("v.startPage",0);
            component.set("v.currentPage",1);
            component.set("v.endPage",pageSize); 
        }
        else{
            console.log('Please enable GPS');
        }
        this.showhidespinner(component,'waitingDiv',false);
    },
    toRadian : function(val){
        return val * Math.PI / 180;
    },
    
    showhidespinner : function(component, loaderDiv,showhide) {
        console.log('show'+showhide+loaderDiv);
        if(showhide){
            console.log('inif');
            document.getElementById(loaderDiv).style.display = "block";
        }
        else{
            console.log('inelse');
            document.getElementById(loaderDiv).style.display = "none";
        }
        console.log('after div'); 
	},
    showCustomToast : function(component, toastid, messageid, message,title,type) {
        //component.find("v."+messageid).set("v.value",message);
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
            toastEvent.fire(); 
        } else {
        //alert('test'+toastid+document.getElementById(toastid));
		document.getElementById(messageid).innerHTML = message;
		document.getElementById(toastid).style.display = "block";
		document.getElementById(toastid).style.width = "50%";
       }
    },
    closeCustomToast : function(component){
        document.getElementById('errormsg').innerHTML = "";
        document.getElementById('successmsg1').innerHTML = "";
		document.getElementById('errorToast').style.display = "none";
		document.getElementById('successToast').style.display = "none";
        
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
    },
    showhidespinner1:function(component, event, showhide){
        console.log('show hide of table');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
    /*Sprint 6 23064*/
    executeApex: function (component, method, params, callback) {
		var action = component.get("c." + method);
		action.setParams(params);
		console.log('calling method' + method);
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log('response.getReturnValue()' + JSON.stringify(response.getReturnValue()));
				callback.call(this, null, response.getReturnValue());
			} else if (state === "ERROR") {
				console.log('error');
				console.log(response.getError());

				var errors = ["Some error occured. Please try again. "];
				var array = response.getError();
				for (var i = 0; i < array.length; i++) {
					var item = array[i];
					if (item && item.message) {
						errors.push(item.message);
					}
				}
				console.log('calling method failed ' + method);
				this.showToast(component, "Error!", errors.join(", "), "error");
				callback.call(this, errors, response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}

/*Sprint 6 23064*/    
    


})