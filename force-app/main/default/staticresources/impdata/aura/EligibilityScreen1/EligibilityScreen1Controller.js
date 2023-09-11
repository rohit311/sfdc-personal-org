({
	doInit : function(component, event, helper) {
		//helper.fetchpicklistdata(component,event,'');
		/* CR 22307 s */
            var stage = component.get("v.stageName");
            if(stage == 'Underwriting' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
             component.set("v.displayReadOnly",false);
            } 
            else{
            component.set("v.displayReadOnly",true);
            }
            /* CR 22307 e */
        // Bug 23064 start
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            { 
                component.set("v.displayReadOnly",true);
                
            } 
            // Bug 23064 stop
        var accObj = component.get("v.accObj");
        console.log('accobj reason'+accObj.Downsizing_Reasons__c);
        var multislect = component.find("mymultiselect");
        multislect.setRejectReason(accObj.Downsizing_Reasons__c);
	},
    toggleAssVersion : function(component, event, helper) {
    	helper.toggleAssVersion(component, event);     
    },
    updateCamObj : function(component, event, helper) {
       /*var list = ["tenor","Finalloanamount","FinalROI"];
        var isvalid =true;
        for (var i = 0; i < list.length; i++) {
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }*/
        var isvalid =true;
        var accObj = component.get("v.accObj");
        var multislect = component.find("mymultiselect");
        var mySelectedvalues ='';
        //if(component.get("v.isFromTile"))
               mySelectedvalues = multislect.bindData();
      //  else if(component.get("v.mySelectedvalues"))
        	//mySelectedvalues = component.get("v.mySelectedvalues");
        console.log('updateCamObjHelper'+mySelectedvalues);
        accObj.Downsizing_Reasons__c = mySelectedvalues;
        component.set("v.accObj",accObj);
         if (component.find("tenor") && !component.find("tenor").get("v.validity").valid)
            {
                isvalid = false;
                component.find("tenor").showHelpMessageIfInvalid();
            }
         /*if($A.util.isEmpty(mySelectedvalues)){
              isvalid = false;
         }*///CR implemented
         /*US_24979 S*/
         if(!$A.util.isEmpty(mySelectedvalues)|| !component.get("v.isFromTile"))
        {
           component.set("v.downSizeFlag",true); 
        }
        /*US_24979 E*/
        if(isvalid /*US_24979 S*/&& component.get('v.downSizeFlag')/*US_24979 E*/)
                helper.updateCamObjHelper(component,event);
       else
           helper.displayToastMessage(component,event,'Error','Please fill all required data ','error');
		
	},
    DestroyChildCmp: function(component, event, helper) {
        component.set("v.body",'');
        component.destroy();
    },
    calculateDroplinePeriod: function(component,event,helper){
        console.log('in calculate');
        if(component.get('v.isHybirdFlexi')==true && component.find("PureFlexPeriod1").get("v.validity").valid){
            helper.calcDropLinePeriod(component,event);
    }
        else  if(component.get('v.isHybirdFlexi')==true)
             helper.displayToastMessage(component,event,'Error','Please fill Correct data.','error');
            
    },
})