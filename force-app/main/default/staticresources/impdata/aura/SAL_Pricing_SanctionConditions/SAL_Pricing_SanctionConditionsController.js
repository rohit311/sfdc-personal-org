({
   doInit  : function(component, event, helper) {
       /* var RowItemList = component.get("v.discrepancyList");
       // alert(RowItemList.length);
       if(RowItemList.length == 0){
           //  component.set(component.find('saveSanc').get('v.class'), 'slds-hide');           
       }
       // helper.getSanctionDetailsMethod(component,event);*/
        
    },
    addNewRow: function(component, event, helper) {
        helper.createDummyRow(component, event);
    },
    
    SaveSanctionDetails: function(component, event, helper) {
        
        var validData = true;
        var validCount = 0;
        var recordView = component.find("bankListCmp")
        if ($A.util.isArray(recordView)) 
        {
            recordView.forEach(cmp => {
                validData = cmp.validate();
                if(!validData)
                validCount++;
            });
        }
        else 
		{
                validData = recordView.validate();
                if(!validData)
                validCount++;
        }
        if(validCount == 0)
		{
			var RowItemList = component.get("v.discrepancyList");
			if(RowItemList.length == 0)
            {
                helper.displayToastMessage(component,event,'Error','No Records to save. ','error');            
            }   
            else
			{
                helper.showhidespinner(component,event,true);
                helper.SaveSanctionDetails(component);
            }
		}
        else
		{
        	helper.displayToastMessage(component,event,'Error','Please fill all required data','error');
            helper.showhidespinner(component,event,false);
		}
	},
})