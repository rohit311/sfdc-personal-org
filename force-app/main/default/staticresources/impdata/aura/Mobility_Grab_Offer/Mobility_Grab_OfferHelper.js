({
    searchWithPanHelper : function(component,event) {
        if(!$A.util.isEmpty(component.get("v.PANString"))||(!$A.util.isEmpty(component.get("v.NAMEString"))&&!$A.util.isEmpty(component.get("v.MOBILEString"))) || !$A.util.isEmpty(component.get("v.MOBILEString"))){
          this.showhidespinner(component,event,true);
            
            /*var searchstring = new Object();
            searchstring["PANString"] = component.get("v.PANString");
            searchstring["NAMEString"] = component.get("v.NAMEString");
            searchstring["MOBILEString"] = component.get("v.MOBILEString");
               /* "PANString" :component.get("v.PANString"),
                "NAMEString" :component.get("v.NAMEString"),
                "MOBILEString" :component.get("v.MOBILEString")
                
            */
            var searchstring = '';
            if(!$A.util.isEmpty(component.get("v.PANString")))
                searchstring += component.get("v.PANString")+';';
            else
                searchstring += ';';
            if(!$A.util.isEmpty(component.get("v.NAMEString")))
            	searchstring += component.get("v.NAMEString")+';';
            else
                searchstring += ';';
            if(!$A.util.isEmpty(component.get("v.MOBILEString")))
            {  
                 var mobile = component.get("v.MOBILEString");
                 var  mobile1 = mobile.substring(0,5);
                 var mobile2 = mobile.substring(5);
                 console.log("pk mobile"+mobile1+'  '+mobile2);
            	//searchstring += component.find("Mobile").get("v.value")+';';
            	searchstring += mobile1+';'+mobile2+';';
            }
            else
                searchstring += ';';
            
			console.log(searchstring);
            //console.log('pk1');
            //console.log(JSON.stringify(searchstring));
			this.executeApex(component, "getLoanItems", {
               'searchString' : searchstring.toString()
            }, function (error, result) {
                console.log('result>>>>'+result);
                if (!error && result) {
                    console.log('result  of get: '+result);
                    var data=result; //22018
					    /*Added by swapnil RSL Mobility bug 22018 s*/ //replaced entire IF 22018
                        var userProd = component.get("v.userInfo.Product__c").split(';');
                        if( !$A.util.isEmpty(data.poList) && data.poList.length > 0 && data.poList !=null && !$A.util.isEmpty(userProd) && userProd != null ){
                            component.set("v.items", data.poList);
                           console.log('SBS Branch inside Mobility grab Helper : ');
                            
                            
                            if(!$A.util.isEmpty(component.get("v.userInfo.Product__c")))
                                
                                console.log('User prod '+userProd);
                            
                            var LAList= component.get("v.items");
                            console.log('@@swapnil '+JSON.stringify(LAList));
                            console.log('LAList.length'+LAList.length);
                            for(var i=data.poList.length-1;i>=0;i--){
                                if(!userProd.includes(data.poList[i].Products__c)){
                                    LAList.pop();
                                }
                            } 
                            
                            component.set("v.items",LAList);
                            /*Added by swapnil RSL Mobility bug 22018 e*/
                            component.set("v.defaultShow", false);//Bug 17583
                        } //replaced entire IF 22018
                    else{
                        var data = JSON.parse(result);
                        //console.log('resutl'+result[0].Opportunity__c);
                        if(data.poList.length > 0){
                            component.set("v.items", data.poList);
                            console.log('SBS Branch inside Mobility grab Helper :'); //'+data.poList[0].Lead__r.SBS_Branch__r.Name);
                            component.set("v.defaultShow", false);//Bug 17583
                        }
                    		
                        else{
                            console.log('in set else');
                            component.set("v.defaultShow", true);
                            component.set("v.items", null);
                        }
                             
                        if(data.isTeleCaller){
                            component.set("v.isTeleCaller", true);
                        }
                        else{
                            component.set("v.isTeleCaller", false);
                        }
                        if(data.isFieldAgent){
                            component.set("v.isFieldAgent", true);
                        }
                        else{
                            component.set("v.isFieldAgent", false);
                        }
						
					}
						console.log('pk6');
					this.showhidespinner(component,event,false);
                }
                else{
                    component.set("v.items", null);
					component.set("v.defaultShow", true);//Bug 17583
				}
            });
        }else
        {
            this.showhidespinner(component,event,false);
            component.set("v.items", null);
			component.set("v.defaultShow", true);//Bug 17583
        }
    }, 
    
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
       console.log('calling method>>'+method+'>>params>>'+params);
        console.log(params);
         action.setCallback(this, function (response) {
            console.log('in callback');
            var state = response.getState();
            console.log('in callback'+state);
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        console.log('pk in execute');
        $A.enqueueAction(action);
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    getUserIDfromApex : function(component,event) {
        this.executeApex(component, 'getUserIDfromApex', {},
                         function (error, result) {
                             if (!error && result) {
                                 console.log('result  : '+result);
                                 component.set("v.currentUser", result);
                             }
                         });   
    },       
    getUserNamefromApex : function(component,event) {
        this.executeApex(component, 'fetchUser', {},
                         function (error, result) {
                             if (!error && result) {
                                 console.log('result  : '+result);
                                 component.set("v.userInfo", result); 
                             }
                         });
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
    }  
})