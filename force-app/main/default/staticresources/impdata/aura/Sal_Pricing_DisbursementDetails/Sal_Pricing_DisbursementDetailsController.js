({
    editRecord : function(component, event, helper) {
        helper.editRecord(component, event);
    },
    addNewRecord : function(component, event, helper) {
        helper.addRecord(component, event);
    },
    addNewRecord1 : function(component, event, helper) {
        helper.addRecord1(component, event);
    },
    handleUpdateDisbursement : function(component, event, helper){
        helper.handleUpdateDisbursement(component, event);
    },
    deleteRecord : function(component, event, helper){
        helper.deleteRecord(component, event);
    },
   fetchDisbursementafterclone:function(component,event)
    {
        
    },
     validateImps : function(component, event, helper){
        helper.fetchData(component, event);
    },
    cloneBankDetails :function(component, event, helper){
           /* CR 22307 s */
       if(!$A.util.isEmpty(component.get("v.page")) && component.get("v.page") == "pricing" && component.get("v.stageName") == 'Post Approval Sales'){
       	helper.cloneBankDetails(component, event);
       }
    },
    setdisbursallist:function(component, event, helper){
        console.log('inside handle event');
       helper.setdisbursallisthelper(component, event);
    },
   //Bug:20391 changes Start (Handle visiblity of IMPS response and IMPS check button)
    doInit : function(component, event, helper) {
        console.log('in parent::'+component.get("v.loan"));
        /*var impsLabel = $A.get("$Label.c.IMPS_Product");
        console.log('User profile***'+component.get("v.userProfile"));
        if(impsLabel && !$A.util.isEmpty(component.get('v.loan'))){
            console.log('Inside if****');
            var labelValue = [];
            labelValue = impsLabel.split('-');
            console.log('Label value****'+labelValue);
            if(!$A.util.isEmpty(labelValue) && !$A.util.isEmpty(labelValue[0]) && !$A.util.isEmpty(labelValue[1])){
            	if((labelValue[0].toUpperCase().split(';').includes((component.get('v.loan.Product__c')).toUpperCase())) &&
                   (labelValue[1].toUpperCase().split(';').includes((component.get('v.userProfile')).toUpperCase()))) {
                	console.log('Inside if***');
                    component.set('v.showIMPSResponse',true);
            	}    
            }
            
        }
        component.set('v.showIMPSResponse',true);
        console.log('Flag value****'+component.get('v.showIMPSResponse'));*/
        
        //Bug 21287---S
        var action = component.get("c.getdataOnDisbLoad");
        action.setParams({"loanId": component.get("v.loanId")});
           action.setCallback(this,function(response){
            var state = response.getState();
              if (state === "SUCCESS") {
           		var bankIFSC = [];
                var response = JSON.parse(response.getReturnValue() );
                  console.log('Response--->'+JSON.stringify(response));
                component.set('v.userProfile', response.ProfileName);
                component.set("v.disbList",JSON.parse(response.DisbData)); // SAL 2.0 issues
                var banks = JSON.parse(response.IMPSbanks);
                var loanDetails = JSON.parse(response.LoanData);
                for ( var key in banks ) {
                    bankIFSC.push({value:banks[key], key:key});
                }
                  console.log('bankIFSC::'+bankIFSC);
            component.set("v.impsBankMap", bankIFSC);
            var impsLabel = $A.get("$Label.c.IMPS_Product");
            if(impsLabel && !$A.util.isEmpty(loanDetails)){
                var labelValue = [];
                labelValue = impsLabel.split('-');
                if(!$A.util.isEmpty(labelValue) && !$A.util.isEmpty(labelValue[0]) && !$A.util.isEmpty(labelValue[1])){
                    if((labelValue[0].toUpperCase().split(';').includes(loanDetails[0].Product__c.toUpperCase())) &&
                       (labelValue[1].toUpperCase().split(';').includes((component.get('v.userProfile')).toUpperCase()))) {
                        component.set('v.showIMPSResponse',true);
                    }    
                }
                
            }
            console.log('Flag value****'+component.get('v.showIMPSResponse'));
            helper.BtnRender(component,event); //25677
               }
		});
   		$A.enqueueAction(action);
        //Bug 21287 ---E   
           
   },
    
    recheckImps : function(component, event, helper){
        helper.recheckIMPS(component, event);
    },
    //Bug:20391 Changes End
    
    //Bug-22785(Related to 20391) start
    saveIMPS : function(component, event, helper){
        helper.saveIMPS(component, event);
    },
    //Bug-22785(Related to 20391) end
})