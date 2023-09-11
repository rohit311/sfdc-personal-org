({
     doInit: function (component, event, helper) {
     },
    /*23064 start
    doInit: function (component, event, helper) {

        var validExotelProd;
        component.set("v.displayExotel",false);
        helper.executeApex(component,'getvalidExotelProduct', {
            
        }, function (error, result) {
            if (!error && result) {
                
                var data=JSON.parse(result);
                component.set("v.validExotelProd",data);
                validExotelProd=component.get("v.validExotelProd");
                for(var i=0 ; i < validExotelProd.length ; i++){
                    if(component.get("v.item.Products__c") != null && validExotelProd[i].toUpperCase() === component.get("v.item.Products__c").toUpperCase()){
                        component.set("v.displayExotel",true);
                    }
                }
                
            }else{
                alert('no data');
            }
         }); 
    },23064 end*/
	 closeModel : function (component, event, helper) {
            var modalname = component.find("graboffermodal");
			component.set("v.poID",'');//Bug 17672
         	var otpCmp = component.find("childCmp");
        	 otpCmp.MakeOtpBlank();
           $A.util.removeClass(modalname, "slds-show");
			$A.util.addClass(modalname, "slds-hide");
    },
    grabOffer: function (component, event,helper) {
        var submit_status = event.getParam("submitStatus");
        var modalname = component.find("graboffermodal");


		
         console.log('inside submit_status'+submit_status + component.get("v.poID"));
         if(!$A.util.isEmpty(submit_status) && submit_status == true){
             helper.showhidespinner(component,event,true);
           $A.util.removeClass(modalname, "slds-show");
		   $A.util.addClass(modalname, "slds-hide");
          
             helper.changeOwnerOfPOFunction(component,event);
         }else{
            
         }
    },

    generatenewOTP :function(component,event,helper) 
    {
        
        var productofferid = event.getSource().get('v.value');
        component.set("v.poID",productofferid);
        var phonenumber = event.getSource().get('v.name');
        component.set("v.phonenumber",phonenumber);
        
       /* var testvar = document.getElementById("dummyId");
       // alert('testvar:'+testvar);
        //testvar.focus();
        
       //if("{!$User.UIThemeDisplayed}" != "Theme4d"){//{!$User.UITheme}
           // alert('hi');
        var element = document.getElementById('testDiv');
		var position = element.getBoundingClientRect();
		var x = position.left;
		var y = position.top;
       console.log('x y co >>'+x+' '+y);
        
        var d = document.getElementById("dummyDiv");
        d.style.position = "absolute";
        d.style.left = x+'px';
        d.style.top = y-250+'px';
        
        console.log('x y co >>'+d.style.left+' '+d.style.top);*///bug id 17845*/
        
        /*Bug 17930(CR) Start*/
        var branchName = component.get("v.userBranchCity");
        var sbsbrnch = component.get("v.sbsBranch");
        var isvalidated = true;
        //Bug 17681 Start
         if($A.util.isEmpty(phonenumber))
        {
          helper.displayToastMessage(component,event,'Error','Please enter mobile number.','error');
          isvalidated = false;
        }
        console.log('branchName : '+branchName);
        console.log('SBS Branch : '+sbsbrnch);
        /*Bug 18450 start*/
        var branchlst = '';
        if(!$A.util.isEmpty(branchName))
        	branchlst = branchName.split(';');
        var sameBrnch = false;
        for(var i in branchlst){
            if(branchlst[i] == sbsbrnch){
                sameBrnch = true;
                break;
            }
         }
        if(!sameBrnch){
            helper.displayToastMessage(component,event,'Error','You cannot grab this offer.','error');
            isvalidated = false;
        }
        /*BUg 18450 End*/
        //Bug 17681 End
        if(isvalidated){
            helper.generateOTPhelper(component,event,phonenumber);
        }
        /*Bug 17930(CR) End*/
        
    },
    clickViewOffer : function(component,event,helper){
        helper.clickViewOffer(component,event);
    },
    
    assign2telecaller : function(component,event,helper){
         helper.assign2telecaller(component,event);
    },/*added by swapnil 23064 s
    makeacall : function(component,event,helper){
       helper.showhidespinner(component,event,true);
       helper.displayToastMessage(component,event,'Success','Calling....','success'); 
        var LeadId = component.get("v.item.Lead__r.Id")+'';
       
        var fromNumber;
       
        if(component.get("v.userInfo.Mobile_number__c"))
            fromNumber=component.get("v.userInfo.Mobile_number__c");
        else if(component.get("v.userInfo.Phone"))
            fromNumber=component.get("v.userInfo.Phone");
        else if(component.get("v.userInfo.MobilePhone"))
            fromNumber=component.get("v.userInfo.MobilePhone");
        // callToCustomerCallback
         helper.executeApex(component,'callToCustomer', {
             "frommobile" : 'none', //fromNumber,
             "tomobile" : component.get("v.item.Lead__r.Customer_Mobile__c")+'',
             "objName":"Lead",
             "Id" : LeadId,
             "Product":component.get("v.item.Products__c").toUpperCase()
         }, function (error, result) {
             if (!error && result) {
                 console.log('Callback done '+JSON.stringify(result));
                 if(result !== 'Success'){
                     helper.displayToastMessage(component,event,'Error',result,'error');
                 }
                helper.showhidespinner(component,event,false);
             }else{
                 console.log('error '+leadId);
                  helper.displayToastMessage(component,event,'Error',result,'error');
    }
         }); 
    },
 added by swapnil 23064 e*/
})