({
	doInit : function(component, event, helper) {
        
        var fetchPicklist = component.get("c.fetchPicklistValues");
        fetchPicklist.setParams({"loanId": component.get('v.oppId')});
        fetchPicklist.setCallback(this, function( res){
        	if(res.getReturnValue()){
                var response = JSON.parse(res.getReturnValue() );
            	var optsMemCharges = JSON.parse(response.memCharges);
               	var optsCharges = [];    optsCharges.push({label:'--None--', value: null});
                	if (optsMemCharges)
                        {
                        	for(var i =0; i< optsMemCharges.length; i++)
                                {
                                 	if (optsMemCharges[i])
                                    {
                                      optsCharges.push({
                                      label : optsMemCharges[i],
                                      value : optsMemCharges[i]
                                      });
                                 	}
                         	}
                         }
                 component.set("v.optionsMembershipCharges" ,optsCharges);
            }
        });
        $A.enqueueAction(fetchPicklist);
	},
    onSave : function(component, event, helper) {
        try{
            component.set('v.isProcessing',true);
            var memCharges = component.get('v.membershipCharge');
            var optForEliteCard = component.get('v.ECselected');
            console.log('Checkbox****'+optForEliteCard);
            if(!memCharges){
               memCharges = 0; 
            }
            if(optForEliteCard){
                 var saveDataAction = component.get("c.saveData");
                saveDataAction.setParams({"membershipCharges": memCharges,
                                          "ECselected": optForEliteCard,
                                          "loanID": component.get("v.oppId")
                                         });
                saveDataAction.setCallback(this, function( res){
                    if(res.getReturnValue()){
                     var response = res.getReturnValue();
                        if(response.includes('SUCCESS')){
                        	helper.showToast(component,'Success!', response.split(':')[1] , 'success');    
                        }
                        else if(response.includes('ERROR')){
                            helper.showToast(component,'Error!', response.split(':')[1] , 'error');
                        }
                        else if(response.includes('EXCEPTION')){
                             helper.showToast(component,'Error!', 'Something went wrong! Please check with your administrator!' , 'error');
                            console.log('Exception occurred*****'+response);
                        }
                    }
                    else{
                       helper.showToast(component,'Error!', 'Something went wrong! Please check with your administrator!' , 'error'); 
                    }
                	component.set('v.isProcessing',false);
                });
                $A.enqueueAction(saveDataAction);    
            }
            else{
                helper.showToast(component,'Info!', 'Elite card offer will not be applied if checkbox is not ticked' , 'info');
                component.set('v.isProcessing',false);
            }
        }catch(err){
			console.log('Exception occurred while saving data'); 
            component.set('v.isProcessing',false);
        }
    },
    
    closeCustomToast: function(cmp, evt, helper)
    {	
        helper.closeToast(cmp);
    },
})