({
	approveData : function(component, event, helper) {
        //RSL fix
        if (component.get("v.loan").Product__c!='RSL'){
          var loanVarient=component.get('v.loanVarient');
        var locationCategory=component.get('v.locationCategory');
        if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '12.5' && loanVarient != null && loanVarient != 'null' && loanVarient.includes('REGULAR') && locationCategory !=null && locationCategory=='1-8'){
                                helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
        }
        else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '12.5' && loanVarient != null && loanVarient != 'null' && loanVarient.includes('REGULAR') && locationCategory !=null && locationCategory !='1-8'){
               helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
        }
         else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '13.5' && loanVarient != null && loanVarient != 'null' && (loanVarient.includes('FLEXI') || loanVarient.includes('HYBRID')) && locationCategory !=null && locationCategory=='1-8'){
                                        helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
         }
         else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '13' && loanVarient != null && loanVarient != 'null' && (loanVarient.includes('FLEXI') || loanVarient.includes('HYBRID')) && locationCategory !=null && locationCategory !='1-8'){
                                        helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
       		 
         }  //1652 stop
        else
		helper.saveData(component, event);
        // alert('oppdata'+JSON.stringify(component.get("v.loan")));
        }
        else
		helper.saveData(component, event);
	},
    calculateDroplinePeriod: function(component,event,helper){
        console.log('in calculate');
        if(component.get('v.isHybirdFlexi')==true){
            helper.calcDropLinePeriod(component,event);
        }
    },
    Cancel : function(component, event, helper) {
        component.set("v.selectApproval",false);
        component.find("sendMail").set("v.disabled",false);
    },
    
  checkRate : function(component, event, helper) {
      //RSL fix
      if (component.get("v.loan").Product__c!='RSL'){
            
        var approvedRate = component.get("v.approvedRate");
        var proposedRate = component.get("v.proposedRate");
        var approvedPF = component.get("v.approvedPF");
        var proposedPF = component.get("v.proposedPF");
        var maxLimitROI = parseFloat(component.get("v.maxLimitROI"));//sprint 5C 22624
                  // 8/27  
        var onChangeRoiDif = Math.abs (component.find('ROI').get("v.value") - component.get("v.approvedRate"));
        console.log ('check 3 onChangeROID='+onChangeRoiDif);
		var onChangePfDif =  Math.abs (component.find('PF').get("v.value") - component.get ("v.approvedPF"));
        console.log ('check 4 onChangePFD='+onChangePfDif);
		
		if (onChangeRoiDif > 1.75 || onChangePfDif > 1.5)
		{
			component.set("v.showApprove",true);
            component.set ("v.selectApproval",false);
        } 
          else {
		// 8/27
		component.set("v.showApprove",false);
        console.log('Rate si '+proposedRate+'  '+approvedRate);
        component.set("v.selectApproval",false);//added later 1652
        console.log('approvedRate++'+approvedRate);
            console.log('proposedRate++'+proposedRate);
        if((proposedRate <= approvedRate) && (proposedPF <= approvedPF)){
            component.set("v.showApprove",false);
        }
              else {component.set("v.showApprove",true);
                    component.set ("v.selectApproval",false);}
           
        } 
      }
      
    },
    sendApprMail : function(component, event, helper) {
          //1652 start
          console.log('in if');
                var loanVarient=component.get('v.loanVarient');
        var locationCategory=component.get('v.locationCategory');
        if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '12.5' && loanVarient != null && loanVarient != 'null' && loanVarient.includes('REGULAR') && locationCategory !=null && locationCategory=='1-8'){
                                helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
        }
        else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '12.5' && loanVarient != null && loanVarient != 'null' && loanVarient.includes('REGULAR') && locationCategory !=null && locationCategory !='1-8'){
               helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
        }
         else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '13.5' && loanVarient != null && loanVarient != 'null' && (loanVarient.includes('FLEXI') || loanVarient.includes('HYBRID'))  && locationCategory !=null && locationCategory=='1-8'){
                                        helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
         }
         else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '13' && loanVarient != null && loanVarient != 'null' && (loanVarient.includes('FLEXI') || loanVarient.includes('HYBRID'))  && locationCategory !=null && locationCategory !='1-8'){
                                        helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
       		 
         }  //1652 stop
        else
        helper.sendApprMailHelper(component, event);
    },
    sendEmailToHeirarchy : function(component, event, helper) {
        //1652 start
        var loanVarient=component.get('v.loanVarient');
        var locationCategory=component.get('v.locationCategory');
        console.log ('loan variant='+loanVarient);
        console.log ('locationCategory='+locationCategory);
        console.log ('ROI='+component.find('ROI').get("v.value"));
        
        if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '12.5' && loanVarient != null && loanVarient != 'null' && loanVarient.includes('REGULAR') && locationCategory !=null && locationCategory=='1-8'){
                                helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
        }
        else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '12.5' && loanVarient != null && loanVarient != 'null' && loanVarient.includes('REGULAR') && locationCategory !=null && locationCategory !='1-8'){
               helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
        }
         else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '13.5' && loanVarient != null && loanVarient != 'null' && (loanVarient.includes('FLEXI') || loanVarient.includes('HYBRID'))  && locationCategory !=null && locationCategory=='1-8'){
                                        helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
         }
         else if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && component.find('ROI').get("v.value") < '13' && loanVarient != null && loanVarient != 'null' &&(loanVarient.includes('FLEXI') || loanVarient.includes('HYBRID'))  && locationCategory !=null && locationCategory !='1-8'){
                                        helper.displayToastMessage(component,event,'Error','ROI/PF cannot be approved','error');
       		 
         }
        else {
        //1652 stop
          // user story 978 s
             var updateidentifier =  $A.get("e.c:Update_identifier");
             updateidentifier.setParams({
            "eventName": 'Pricing Loan Details',
            "oppId":component.get("v.loan").Id
              });
           updateidentifier.fire();
         // user story 978 e
        if(!$A.util.isEmpty(component.find('ROI').get("v.value")) && !$A.util.isEmpty(component.find('PF').get("v.value"))  )
        {
        component.find("sendMail").set("v.disabled",true);
        helper.sendEmailToHeirarchy(component, event);
        }
        else
            helper.displayToastMessage(component,event,'Error','Value not present in ROI and PF','error');
        }
       
    },
     doInit : function(component, event, helper) {
        console.log('log1'+component.get("v.disableApproveButton"));
        if(component.get("v.disableApproveButton")){
            console.log('alright now show approve button but disable it, and hide hierarchy button');
                component.set("v.showApprove",true);
               component.find("approve").set("v.disabled", true);   
        }
         // 8/27
        console.log ('check 1');
		var onLoadRoiDif = Math.abs (component.find('ROI').get("v.value") - component.get("v.approvedRate"));
		console.log ('check 2');
        var onLoadPfDif =  Math.abs (component.find('PF').get("v.value") - component.get ("v.approvedPF"));
		
		if (onLoadRoiDif > 1.75 || onLoadPfDif > 1.5)
		{
			component.set("v.showApprove",true);
		}
         // 8/27
    },
    checkHierarchyCondtions : function(component, event, helper) { //1652
        
        // RSL fix
        if (component.get("v.loan.Product__c") !='RSL'){
                console.log('log2'+component.get("v.disableApproveButton"));

         if(component.get("v.disableApproveButton")){
            console.log('alright n');
                component.set("v.showApprove",true);
               component.find("approve").set("v.disabled", true);   
        }
        else
        helper.sendEmailToHeirarchy(component,event);
        }
    }
})