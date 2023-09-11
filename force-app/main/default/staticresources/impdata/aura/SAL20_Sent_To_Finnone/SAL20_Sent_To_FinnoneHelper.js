({
	handleSendBack : function(component) 
    {      
        var utility = component.find("toastCmp");
        var sendBackAction = component.get("c.doSendBack"); 
        sendBackAction.setParams({oId :  component.get("v.oId") });
        $A.enqueueAction(sendBackAction);
        sendBackAction.setCallback(this, function(response){
			var result = response.getReturnValue();
            console.log(' result of send back : ' + result);
            if((!$A.util.isEmpty(result)))						
            {
                if(result.indexOf('FAILURE') != -1)
                {
                    utility.showToast('Error!', 'Failed to send back.' , 'error'); 
                    component.set("v.isProcessing", false);//US_1409
                }
                else if(result == 'Success') {
                    utility.showToast('Success!', 'Loan applicantion send back successfully! Please refresh to see effects' , 'success');
                    /*US_1409 S*/
                   // window.close();
                    console.log('Abhi Theme::'+component.get('v.nameTheme'));
                    //if(component.get('v.nameTheme') == 'Theme3' || component.get('v.nameTheme') == 'Theme2'){
                        if(component.get('v.isCommunityUser')==true || component.get('v.isCommunityUser')=='true')
                            window.location.href = '/Partner/006?fcf=00B90000009P3lt';
                        else
                            window.location.href = '/006?fcf=00B90000009P3lt';
                   /* }
                    else if(component.get('v.nameTheme') == 'Theme4d')
                        window.location.href = '/lightning/o/Opportunity/list?filterName=00B90000009P3lt&0.source=alohaHeader';
                        else if(component.get('v.nameTheme') == 'Theme4t')
                            this.onLoadRecordCheckForSF1(component, event);
                     else if(component.get('v.nameTheme') == 'PortalDefault')
                     {
                         
                         window.location.href =component.get('v.baseUrl') + '/' + result;
                     }*/
                    /*US_1409 E*/
                    component.set("v.isProcessing", false);//US_1409
                     //component.find("newbutton").set("v.disabled", true);
                    
                    
                }
            }
            else
            {
                utility.showToast('Error!', 'Failed to send back.' , 'error');
                 component.set("v.isProcessing", false);//US_1409
            }
            //console.log('AbhiSimpleRecord:::', component.get("v.simpleRecord"));
            component.set("v.simpleRecord.COO_Comments__c", '');
            //console.log('AbhiSimpleRecord:::'+component.get("v.simpleRecord.COO_Comments__c"));
            component.set("v.isProcessing", false);
            component.set("v.showSendBackComments", false);
        });                             
	},
    /*US_1409 S*/
     onLoadRecordCheckForSF1 : function(component, event) {
        //alert('onLoadRecordCheckForSF1');
        var action = component.get('c.getLoanApplicationListViewsPAS');			//add to pricing controller and make call to pricing controller v1
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                alert('listviews:::'+listviews.Id);
                //component.set('v.nameTheme', response.getReturnValue());
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "Opportunity"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
        //alert('enqueueAction');
    },
     /*US_1409 E*/
})