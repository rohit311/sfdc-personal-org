({
    doInit  : function(component, event, helper) {
        //fetchpicklist  
         //   helper.showhidespinner(component,event,true);
         
        //helper.fetchData(component, event);
        
        var container1 = component.find("monthly");
        var container2 = component.find("quarterly");
        
        $A.util.addClass(container2, 'slds-hide'); 
        $A.util.removeClass(container1, 'slds-hide'); 
        
        helper.loadIncomeDetails(component,event);
        
        console.log('after apex class ');
    },
    saveIncomeDetailsButton   : function(component, event, helper) {
        
        var isValid = helper.validateData(component);
        console.log('yes1'+isValid);
        if(isValid){
            var newCam = JSON.stringify(component.get("v.cam"));
            var newApplicant = JSON.stringify(component.get("v.applicant"));
            var myid = component.get("v.loanid");
            
            // var newCam = component.get("v.cam");
            //var newApplicant = component.get("v.applicant");
            //var myid=component.get("v.loanid");
            helper.showhidespinner(component,event,true);
            
            helper.saveIncomeDetailsHelper(component,event,newCam,newApplicant,myid);
            console.log('IN save income details Cntr ');
        }
        else{
            this.displayToastMessage(component,event,'Error','Please enter correct data','error');
        }
    },
    
    changeIncentiveType : function(component,event,helper){
        console.log('sdfasdaf');
        var typeOfIncentive = component.find("typeOfIncentive").get("v.value");
        // alert(typeOfIncentive);
        var container1 = component.find("monthly");
        var container2 = component.find("quarterly");
        if(typeOfIncentive=='Monthly')
        {
            
            $A.util.addClass(container2, 'slds-hide'); 
            $A.util.removeClass(container1, 'slds-hide'); 
            
        }
        if(typeOfIncentive=='Quarterly')
        {
            $A.util.addClass(container1, 'slds-hide'); 
            $A.util.removeClass(container2, 'slds-hide'); 
            
        }
        
        
        
    }
})