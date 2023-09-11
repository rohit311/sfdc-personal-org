({
    getPsfTableData : function (component , event)   {
        console.log ('control flow check from save to fetch');
        
    var action = component.get ("c.fetchPsfTableData");
	action.setCallback (this ,function(response) {
		
        console.log ('inside component callback');
        console.log ('response value='+response.getReturnValue());
		var tableData = [];
        var opTableValues = [];
		var state = response.getState();
        
		if (state == 'SUCCESS' && response.getReturnValue() != null)
			{
				
				var res = JSON.parse(response.getReturnValue());
                console.log ('res='+JSON.stringify(res));
                console.log ('res length ='+res.length);
                
				for (var i=0 ; i<res.length ; i++){
                    console.log ('inside for loop');
                    console.log ('res[i]='+res[i]);
					var tab =new Object();
					tab.psfName = res[i].psfName ;
                    tab.psfId = res[i].psfId ;
                    console.log ('tab.psfId='+tab.psfId);
                    console.log ('tab.psfName='+tab.psfName);
					tab.countOfOpps = res[i].countOfOpps ;
                    console.log ('tab.countOfOpps='+tab.countOfOpps);
                    console.log ('tab='+tab);
                    
                    console.log ('res[i].psfOpps='+JSON.stringify (res[i].psfOpps));
                    opTableValues.push (res[i].psfOpps);
                    tableData.push(tab) ;
                    
                    
					}
          
                console.log (tableData);
				component.set ("v.tableData" , tableData) ;
                console.log ('opTable values='+ JSON.stringify(opTableValues));
                console.log ('opTableValues length='+opTableValues.length);
                component.set ("v.opTableValues" , opTableValues) ;

			}
        else
        {
           component.set ("v.tableData" , []) ; 
        }
        	
		
		});
	
	$A.enqueueAction(action);
		
    } ,
   
    
    
    saveOpportunities : function(component, event) {
        
        console.log ('save method:helper');
        var self = this;
        console.log('accounts ');
        console.log(component.get("v.acsToUpdate"));
        debugger;
        
		
        self.showhidespinner(component,event,true);   
        this.executeApex(component,
                         "updateOpps",
                         {"oppsToUpdate":JSON.stringify(component.get("v.opDisplayValues")),
                          "acsToUpdate":JSON.stringify(component.get("v.acsToUpdate"))},
                         function (error, result) {
                    
            console.log ('inside execute Apex callback');
            console.log ('execute apex return values=');
            console.log ('error='+error);
            console.log ('result='+result);
                             
            self.showhidespinner(component,event,false);
			
            if (!error && result && (!result.includes('exception') ) ) {
			
                var data = JSON.parse(result);
                var oppsLst = new Array();
                component.set("v.opDisplayValues",data);
                oppsLst = component.get ("v.opTableValues");
                console.log('data');
                console.log(data);
                if(data && data.length >0){
				
			
                    for(var i=0;i<oppsLst.length;i++){
                
                        
                        if ( oppsLst[i][0] !=undefined && oppsLst[i][0].Id === data[0].Id)
							oppsLst[i] = data ;
                       
													 }
													 
                    component.set("v.opTableValues",oppsLst);
                    component.set("v.acsToUpdate",[]);
                    
											}
                else{
                    console.log('here');
                    component.set("v.opDisplayValues",[]);
                    component.set("v.acsToUpdate",[]);
                }
                
                self.getPsfTableData(component,event);
                self.displayToastMessage(component,event,'Success','Opportunities updated successfully','success');
                component.set ("v.flag",false);
                
                
            }else{
                
            
                self.displayToastMessage(component,event,'Error','Internal Server error, Please try again later!','error');
                
            }
            
        });
        
    },
    
    executeApex: function(component, method, params,callback){
        
        console.log ('executeApex:helper');
        console.log('params'+JSON.stringify(params));
        console.log('method name is '+method)
        var action = component.get("c."+method); 
        

        action.setParams(params);
		
        action.setCallback(this, function(response) {
            
			console.log ('after database operations');
            console.log ('response='+response);
            var state = response.getState();
            console.log('state is '+state);
            
			if(state === "SUCCESS"){
                console.log ('after db ops state SUCCESS');
                console.log('response.getReturnValue()123'+response.getReturnValue());
                callback.call(this,null, response.getReturnValue());
            }
            
			else if(state === "ERROR") 
			{
                console.log ('after db ops state ERROR');
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message)
					{
                        errors.push(item.message);
                    }
                }
                callback.call(this,errors, response.getReturnValue());
            }
        });
        
		
		$A.enqueueAction(action);
    },
    
        showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
        } ,

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