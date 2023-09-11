({
    doInit : function(component, event, helper){
        var oppId = component.get("v.oppId");
        component.set("v.loanId",oppId);
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
       
        helper.fetchpicklistdata(component,oppId);
    },
    saveDedupe : function(component, event, helper){
        console.log('onApplicantListChange');
        helper.saveDedupe(component, event);     
    },
    toggleAssVersion : function(component, event, helper) {
    	helper.toggleAssVersion(component, event);     
    },
   /* OpenCustomerEyePage : function(component, event, helper){
        console.log(event.target.getAttribute('id'));
         var url ='/apex/CustomerEyeVF?id='+event.target.getAttribute('id');
         window.open(url,'_blank');
    },*/
    redirectToOppPage : function (component, event, helper) {
        var LANnumber = event.target.getAttribute('id');
        console.log('pk'+LANnumber);
         if (!$A.util.isEmpty(LANnumber))
         {
            
            var LANnumber_split = LANnumber.split('~');
             if(LANnumber_split.length >= 2)
             {
             component.set("v.LANnumber",LANnumber_split[0]);
             console.log('pk2'+LANnumber_split[0]);
             }
             component.set("v.isViewOppPageOpen", true); 
         }
       
    },
    closeModel1 : function (component, event, helper) {
    	component.set("v.isViewOppPageOpen", false);
    },
    OpenCustomerEyePage : function (component, event, helper) {

        var custid = event.target.getAttribute('id')
        var customerlist = component.get("v.customerList");
         console.log('pks2');
        console.log(customerlist);
        for(var i=0;i<customerlist.length;i++){
             if(customerlist[i].Name  == custid){
                 component.set("v.custId",customerlist[i].Id);
                 break;
             }
        }
		component.set("v.isViewCustomerEyeModal", true);
   },
    closeModel : function (component, event, helper) {
    	component.set("v.isViewCustomerEyeModal", false);
    },
	 DestroyChildCmp: function(component, event, helper) {
        component.set("v.body",'');
        component.destroy();
    }
})