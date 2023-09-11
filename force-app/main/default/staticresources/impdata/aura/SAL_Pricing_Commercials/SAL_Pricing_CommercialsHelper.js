({
    
    calcDropLinePeriod: function(component,event){
        var Id= event.target.getAttribute('id');
        console.log("TargetId: "+Id);
    },
    
    savePricingData : function(component, event)
    {
        console.log('savePricingData');
        var action = component.get('c.saveCommercialdetails');
        action.setParams({
            "jsonappobj": JSON.stringify([component.get("v.applicantPrimary")]),
            "jsonoppobj": JSON.stringify([component.get("v.Loan")])
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('hi'+response.getReturnValue());
                if(response.getReturnValue())
                {
                    var data = JSON.parse(response.getReturnValue());
                    console.log(data);
                    component.set("v.Loan",data.opp);
                    component.set("v.applicantPrimary",data.applicantPrimary);
                    component.set("v.showspinnerflag",false);
                    this.displayMessage(component, 'SuccessLoanMsg', 'successmsg', 'Success! Saved Successfully');
                } 
                component.set("v.showspinnerflag",false);
            }else if(state == 'ERROR')
            {
                component.set("v.showspinnerflag",false);
                this.displayMessage(component, 'ErrorLoanMsg', 'errormsg', 'Error! Failed to save Data.');
            }   
        });
        component.set("v.showspinnerflag",true);
        $A.enqueueAction(action);
    },
    
    /*calcDropLinePeriod() function start*/
    calcDropLinePeriod: function(component,event){
        //console.log('in drop line calculation');
        var flexiperiodValue;
        var tenorValue;
        var droplineId;
        flexiperiodValue = component.find("PureFlexPeriod1").get("v.value");
        tenorValue = component.find("tenorLoan").get("v.value");
        droplineId = component.find("DropLinPeriod1").get("v.value");
        var temp = parseInt(tenorValue - flexiperiodValue);
        if(temp!=null){
            component.find("DropLinPeriod1").set("v.value",temp);
        }
    },
    /*calcDropLinePeriod() function End*/
    
    successLoanMsg: function (component) {
        document.getElementById('successmsg').innerHTML = "";
        document.getElementById('SuccessLoanMsg').style.display = "none";
    },
    errorLoanMsg: function (component) {
        document.getElementById('errormsg').innerHTML = "";
        document.getElementById('ErrorLoanMsg').style.display = "none";
    },
    
    displayMessage: function (component, loanid, messageid, message) {
        
        document.getElementById(messageid).innerHTML = message;
        document.getElementById(loanid).style.display = "block";
        setTimeout(function () {
            document.getElementById(messageid).innerHTML = "";
            document.getElementById(loanid).style.display = "none";
        }, 3000);
    },
    
})