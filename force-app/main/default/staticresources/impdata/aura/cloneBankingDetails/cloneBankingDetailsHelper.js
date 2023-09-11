({
	searchrecords : function(component,event) {
		
       var bankaccnumbr=component.get("v.bankAccNo");	
       if($A.util.isEmpty(bankaccnumbr) && component.get("v.isSALMobilityV2")){
            this.displayToastMessage(component,event,'Error','Please enter bank account number','error')
       }
       else{
           var fetch = component.get("c.fetchRec");
           fetch.setParams({"bankaccno":bankaccnumbr});
           fetch.setCallback(this,function(response){	
               var state = response.getState();
               console.log('state   - ' + state );
               if(state == "SUCCESS"){
                   var custs = [];
                   var returnVal = response.getReturnValue();
                   //console.log('returnVal   - ' + JSON.stringify(returnVal) );
                   for(var key in returnVal ){
                       custs.push(returnVal[key]);
                       //alert('key'+key);
                   }
                   component.set("v.disbursement",custs[0]);
                   //component.set("v.repayment",custs[1]);
                   component.set("v.TotalDis",component.get("v.disbursement").length);
                   var size=component.get("v.TotalDis");
                   if(size<0 || size==0){
                       component.set("v.norecord",true);    
                   }
                   //component.set("v.TotalRepay",component.get("v.repayment").length);
                   //alert('disbursement'+component.get("v.TotalRepay"));
               }
           });
           
           $A.enqueueAction(fetch);
       }
        
	},
    cloneRecord: function(component) {
    	var selectedvalue=component.get("v.selectedRecord");
        //console.log('selectedvalue'+selectedvalue);
        
        var oppId = component.get("v.oppId");
        
        var newRec = component.get("c.clone");
       	newRec.setParams({"selectedvalue":selectedvalue , "LoanId" : oppId });
       	newRec.setCallback(this,function(response){	
            var state = response.getState();
            console.log('state   - ' + state );
            if(state == "SUCCESS"){
                
                var returnVal = response.getReturnValue();
                //console.log('returnVal   - ' +JSON.stringify(returnVal) );
               if(!component.get("v.isSALMobilityV2"))
                window.location.reload();
                
                if(component.get("v.isSALMobilityV2")){
                      component.set("v.isOpen", false);
                 var showhideevent = $A.get("e.c:SetCloneBankRecord");
                   showhideevent.setParams({
                    "loanid": component.get("v.oppId")
                 });
                showhideevent.fire();
                 }
            }
        });
       if(!$A.util.isEmpty(selectedvalue)) 
         $A.enqueueAction(newRec);
        else
         this.displayToastMessage(component,event,'Error','Please select record','error')   
        
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
})