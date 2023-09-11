({
	fetchOppData : function(component, event) {
		
        var oppId = component.get("v.oppId");
     //  alert('Opp id is '+ component.get("v.oppId"));
        if(oppId != null && oppId != ''){
           
            this.executeApex(component,"fetchdata",{"oppId":oppId},function(error, result){
              
                if(!error && result){
                    
                  var data = JSON.parse(result);
                  console.log('data @@'+JSON.stringify(data));
                  component.set('v.verificationObj',data.verListData);
                  component.set("v.WeakAcc",data.weakAcc); 
                  component.set("v.appObj",data.appObj); 
                  console.log('Lat Long '+JSON.stringify(data.appObj.Verifications__r));
                  component.set("v.camObj",data.camObj); 
                  component.set("v.verTypeList",data.verTypeList);
                  component.set("v.CoappList",data.coAppList); 
                  console.log('coAppList'+data.coAppList);
                  console.log('Verification list '+component.get("v.verTypeList"));
                  console.log('verification data '+JSON.stringify(component.get('v.verificationObj')));
                  var  list=component.get('v.verificationObj');
                 
                 // console.log('Verification object data'+JSON.stringify(component.get('v.verificationObj')));
                   
                    if(list.length>0 && list!=null){                     
                        for(var i=0;i<list.length;i++){
                            console.log('verification type '+list[i].Verification_Type__c);
                         if(list[i].Verification_Type__c == 'Office verification' || list[i].Verification_Type__c == 'Residence verification'){
                             console.log('sm inside if '+list[i].Verification_Type__c+' Image_Latitude_Longitude_Details__c '+list[i].Image_Latitude_Longitude_Details__c);
                          
                             if(list[i].Verification_Type__c == 'Office verification' && !$A.util.isEmpty(list[i].Image_Latitude_Longitude_Details__c) && list[i].Geo_Tagging__c == true){
                                    component.set('v.OfficelGeoLocation',list[i].Image_Latitude_Longitude_Details__c);
                                 console.log('@@swapnil OfficelGeoLocation '+ component.get('v.OfficelGeoLocation'));
                                    component.set('v.isOfficeGeoavailable',true);
                                
                            }else if(list[i].Verification_Type__c == 'Office verification'){
                                 component.set('v.isOfficeGeoavailable',false);
                            }
                            if(list[i].Verification_Type__c == 'Residence verification' &&  !$A.util.isEmpty(list[i].Image_Latitude_Longitude_Details__c) && list[i].Geo_Tagging__c == true){
                                    component.set('v.recidentialGeoLocation',list[i].Image_Latitude_Longitude_Details__c); 
                                	component.set('v.isResiGeoavailable',true);
                                 console.log('@@swapnil recidentialGeoLocation '+ component.get('v.recidentialGeoLocation'));
                                 
                            }else if(list[i].Verification_Type__c == 'Residence verification'){
                                component.set('v.isResiGeoavailable',false);
                            }
                         		
                        }
                       }  
                    }                 
                }  else{
                   // alert('here '+errors[0].message);
                }  
                       var getResult =$A.get("e.c:getAuditResult");
            			console.log('getResult'+getResult);
              			getResult.fire();
               
            });
            
          }
         
	},
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            console.log('in execute apex');
             console.log('in response '+JSON.stringify(response));
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
              
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})