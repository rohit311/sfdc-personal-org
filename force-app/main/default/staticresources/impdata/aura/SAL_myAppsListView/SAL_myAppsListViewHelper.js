({
	setData: function(component){
        //alert('check');
        var pageSize = component.get("v.pageSize");
        if(component.get("v.oppList"))
        component.set("v.totalRecords", component.get("v.oppList").length);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        var totRec = component.get("v.oppList").length;
        var rem = totRec % pageSize;
        if(rem > 0){
            component.set("v.totalPages",Math.floor((totRec/pageSize))+1);
        }
        else{
            component.set("v.totalPages",(totRec/pageSize));
        }
        var oppList = [] = component.get("v.oppList");
      
        var PaginationList = [];
         //Added for Bug 23064 Start
        var validExotelProd=component.get("v.validExotelProd");
         var newOppList = [];//Added for bug 23064
        
        for(var i=0; i< pageSize; i++){
            if(oppList.length > i){
                //console.log('validExotelProd'+validExotelProd+oppList[i].Product__c);
              for(var j=0 ; j < validExotelProd.length ; j++){
                  console.log('validExotelProd'+validExotelProd+oppList[i].Product__c);  
                  if((validExotelProd[j].toUpperCase() === (oppList[i].Product__c).toUpperCase()) && (oppList[i].StageName == 'DSA/PSF Login' ||oppList[i].StageName == 'Underwriting')){
                      /*Change added by swapnil for exotel 23064*/
                      var appList = oppList[i].Loan_Application__r ;
                      for(var k=0; k < appList.length; k++){
                          if(appList[k].Applicant_Type__c && (appList[k].Applicant_Type__c).toUpperCase() == ('Primary').toUpperCase()){
                              newOppList.push({'opp':oppList[i],'showCall':true,'ApplicantId':appList[k].Id});                            
                          }
                      }
                      /*Change added by swapnil for exotel 23064*/
                     
                  }else{
                       newOppList.push({'opp':oppList[i],'showCall':false});
                  }
                }
               
                /*Change added by swapnil 23064 e*/
                
                PaginationList.push(oppList[i]);    
        }
         }  
        component.set('v.newOppList', newOppList);//Added for bug 23064
        console.log('PaginationList'+PaginationList.length);
        component.set('v.PaginationList', PaginationList);
        
    },
    getValidExotelProd: function(component, event){
        
        this.executeApex(component,'getvalidExotelProduct', {
        }, function (error, result) {
            
         
            if (!error && result) {
               
                var data=JSON.parse(result);
                component.set("v.validExotelProd",data);
                 this.setData(component);
                
            } 
           
        }); 
    },
    //Added for Bug 23064 Stop

    next : function(component, event){
        var sObjectList = component.get("v.oppList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
          //Added for Bug 23064 Start
        var validExotelProd=component.get("v.validExotelProd");
         var newOppList = [];//Added for bug 23064
        
        for(var i=0; i< pageSize; i++){
            if(sObjectList.length > i){
                //console.log('validExotelProd'+validExotelProd+oppList[i].Product__c);
              for(var j=0 ; j < validExotelProd.length ; j++){
                  console.log('validExotelProd'+validExotelProd+sObjectList[i].Product__c);  
                  if((validExotelProd[j].toUpperCase() === (sObjectList[i].Product__c).toUpperCase()) && (sObjectList[i].StageName == 'DSA/PSF Login' ||sObjectList[i].StageName == 'Underwriting')){
                      
                      newOppList.push({'opp':sObjectList[i],'showCall':true});
                  }else{
                       newOppList.push({'opp':sObjectList[i],'showCall':false});
                  }
                }
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        // component.set("v.sortAsc",false);
         component.set('v.newOppList', newOppList);//Added for bug 23064
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")+1);
    },
    
    previous : function(component, event){
        var sObjectList = component.get("v.oppList");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
          //Added for Bug 23064 Start
        var validExotelProd=component.get("v.validExotelProd");
         var newOppList = [];//Added for bug 23064
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                
                  //console.log('validExotelProd'+validExotelProd+oppList[i].Product__c);
              for(var j=0 ; j < validExotelProd.length ; j++){
                  console.log('validExotelProd'+validExotelProd+sObjectList[i].Product__c);  
                  if((validExotelProd[j].toUpperCase() === (sObjectList[i].Product__c).toUpperCase()) && (sObjectList[i].StageName == 'DSA/PSF Login' ||sObjectList[i].StageName == 'Underwriting')){
                      
                      newOppList.push({'opp':sObjectList[i],'showCall':true});
                  }else{
                       newOppList.push({'opp':sObjectList[i],'showCall':false});
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
           component.set('v.newOppList', newOppList);//Added for bug 23064
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")-1);
    },/*Sprint 6 23064*/
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
				//this.showToast(component, "Error!", errors.join(", "), "error");
				callback.call(this, errors, response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}, showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
      
	}

/*Sprint 6 23064*/    
    
})