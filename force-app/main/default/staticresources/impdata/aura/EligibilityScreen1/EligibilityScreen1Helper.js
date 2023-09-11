({
	toggleAssVersion : function(component, event) {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    fetchpicklistdata: function (component,event,oppId) {
    	var accList = ["Downsizing_Reasons__c"];
		var selectListNameMap = {};
		selectListNameMap["Account"] = accList;
       var action = component.get('c.getDedupeDetails');
        action.setParams({
            "oppID": oppId,
			"objectFieldJSON": JSON.stringify(selectListNameMap)
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
                    var picklistFields = data.picklistData;
					var accPickFlds = picklistFields["Account"];
				    console.log('downsize'+accPickFlds["Downsizing_Reasons__c"]);
                    component.set("v.downSizeList", accPickFlds["Downsizing_Reasons__c"]);                        
                }
            }else
                console.log('error');
            
        });
        $A.enqueueAction(action);
       
      
    },
    saveEligibility: function(component,event ) {
        console.log('saveEligibility');
          
        this.executeApex(component, "callEligibiltySegmentation", {"oppId": component.get("v.oppId"), "camObj" : JSON.stringify(component.get("v.camObj"))}, function(error, result){
            if(!error && result){
                var appData = JSON.parse(result);
                this.showhidespinner(component,event,false);
                if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.camObj))
                {
                     component.set("v.camObj",appData.camObj);
                     if(!$A.util.isEmpty(component.get("v.camObj").Secured_FOIR__c) ||!$A.util.isEmpty(component.get("v.camObj").Unsecured_FOIR__c)){
                        var final_foir = component.get("v.camObj").Secured_FOIR__c + component.get("v.camObj").Unsecured_FOIR__c;
                        final_foir = parseFloat(final_foir).toFixed(2);
                        component.set("v.final_foir",final_foir);
                        }
                }
                    console.log('saveEligibility maxEligiAmtMCP'+appData.maxEligiAmtMCP);
                console.log('saveEligibility maxEligiAmtMCP'+appData.maxEligiAmtMCP);
                if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.maxEligiAmtMCP))  
                    component.set("v.amountaspereligibility",appData.maxEligiAmtMCP);
                if(!$A.util.isEmpty(appData) && !$A.util.isEmpty(appData.scamOpp))  
                    component.set("v.srcamObj",appData.scamOpp);
                if(component.get('v.isHybirdFlexi')==true){
                    component.set("v.appObj", appData.applicantPrimary);//prod issue
                    this.updateCamObjHelpernew(component,event);
                }
                this.displayToastMessage(component,event,'Success','Eligibility calculated successfully','success');
                var evt = $A.get("e.c:SetParentAttributes");
                    evt.setParams({
                        "camObj" : component.get("v.camObj"),
                        "SecName":"eligibility"
                    });
                    evt.fire(); 
            }
            else if($A.util.isEmpty(result)){
                this.showhidespinner(component,event,false);
            }else{
                this.showhidespinner(component,event,false);
            }
        });
    },
   
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    updateCamObjHelper : function(component,event) {
        var Loan = component.get("v.loan");
        var app = component.get("v.appObj");
        var cam = component.get("v.camObj");
        if(component.get("v.appObj") != null && component.get('v.isHybirdFlexi')==true)
        {   
            var result = 0.0;
           // if(Loan.Loan_Amount_with_Premium__c != null && app.Pure_Flexi_Period__c != null && Loan != null && Loan.Approved_Rate__c != null )//Loan.Approved_Rate__c != null)
            if(cam != null && cam.ROI__c != null && app.Drop_Line_Flexi_Period__c != null &&  cam.Proposed_Loan_Amt__c != null)
            {
                result = Math.round((cam.Proposed_Loan_Amt__c * cam.ROI__c) / 1200);
        
            }
            app.Pure_Flexi_EMI__c =  result;
            if(cam.ROI__c != null && app.Drop_Line_Flexi_Period__c != null &&  cam.Proposed_Loan_Amt__c != null)
                cam.EMI_on_Proposed_Loan_TO__c  = this.PMT(cam.ROI__c / 1200,app.Drop_Line_Flexi_Period__c,cam.Proposed_Loan_Amt__c);
        }
        if(component.get("v.appObj") != null && component.get('v.isHybirdFlexi')==false)
        {
            app.Pure_Flexi_EMI__c =  '';
            app.Pure_Flexi_Period__c='';
            app.Drop_Line_Flexi_Period__c='';
           if(cam.ROI__c != null && cam.Tenor__c != null &&  cam.Proposed_Loan_Amt__c != null)
                cam.EMI_on_Proposed_Loan_TO__c  = this.PMT(cam.ROI__c / 1200,cam.Tenor__c,cam.Proposed_Loan_Amt__c);
        }
         component.set("v.appObj",app);
         component.set("v.camObj",cam);
        this.showhidespinner(component,event,true);
        this.executeApex(component, "updateCam", {"camObj": JSON.stringify(component.get("v.camObj")),"accObj": JSON.stringify(component.get("v.accObj")),"appObj": JSON.stringify(component.get("v.appObj"))}, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result)){
                    console.log('result'+result.Tenor__c);
                    component.set("v.camObj",result);
                    this.saveEligibility(component,event);
                }else{
                    console.log('fail to save data');
                    this.showhidespinner(component,event,false);
                }
            }
            else
            {
                this.showhidespinner(component,event,false); 
            }
            
        });
    },
    updateCamObjHelpernew : function(component,event) {//22017
        var Loan = component.get("v.loan");
        var app = component.get("v.appObj");
        var cam = component.get("v.camObj");
        if(component.get("v.appObj") != null && component.get('v.isHybirdFlexi')==true)
        {   
            var result = 0.0;
           if(cam != null && cam.ROI__c != null && app.Drop_Line_Flexi_Period__c != null &&  cam.Proposed_Loan_Amt__c != null)
            {
                result = Math.round((cam.Proposed_Loan_Amt__c * cam.ROI__c) / 1200);
    
            }
            app.Pure_Flexi_EMI__c =  result;
            if(cam.ROI__c != null && app.Drop_Line_Flexi_Period__c != null &&  cam.Proposed_Loan_Amt__c != null)
                cam.EMI_on_Proposed_Loan_TO__c  = this.PMT(cam.ROI__c / 1200,app.Drop_Line_Flexi_Period__c,cam.Proposed_Loan_Amt__c);
        }
          if(component.get("v.appObj") != null && component.get('v.isHybirdFlexi')==false)
        {
            app.Pure_Flexi_EMI__c =  '';
            app.Pure_Flexi_Period__c='';
            app.Drop_Line_Flexi_Period__c='';
            if(cam.ROI__c != null && cam.Tenor__c != null &&  cam.Proposed_Loan_Amt__c != null)
                cam.EMI_on_Proposed_Loan_TO__c  = this.PMT(cam.ROI__c / 1200,cam.Tenor__c,cam.Proposed_Loan_Amt__c);
        }
         component.set("v.appObj",app);
         component.set("v.camObj",cam);

        this.showhidespinner(component,event,true);
        this.executeApex(component, "updateCam", {"camObj": JSON.stringify(component.get("v.camObj")),"accObj": JSON.stringify(component.get("v.accObj")),"appObj": JSON.stringify(component.get("v.appObj"))}, function(error, result){
            if(!error && result){
                if(!$A.util.isEmpty(result)){
                    console.log('result'+result.Tenor__c);
                    component.set("v.camObj",result);
                    this.showhidespinner(component,event,false);
                }else{
                    console.log('fail to save data');
                    this.showhidespinner(component,event,false);
                }
            }
            else
            {
                this.showhidespinner(component,event,false); 
            }
            
        });
    },
    showhidespinner:function(component, event, showhide){
      //  alert('in showhide');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    displayToastMessage:function(component,event,title,message,type)
    {
        //alert('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    calcDropLinePeriod: function(component,event){
        
        var flexiperiodValue = 0;
        var tenorValue =0;
        var droplineId =0;
        if(!$A.util.isEmpty(component.find("PureFlexPeriod1").get("v.value")))
            flexiperiodValue = component.find("PureFlexPeriod1").get("v.value");
        tenorValue = component.find("tenor").get("v.value");
        droplineId = component.find("DropLinPeriod1").get("v.value");
        var temp = parseInt(tenorValue - flexiperiodValue);
        if(temp!=null){
            component.find("DropLinPeriod1").set("v.value",temp);
        }
    },
    PMT: function(rate,nper,pv) {
        var  result = 0.0;
        if (pv != null && rate != null && nper != null) {
            result = Math.round((pv * rate) / (1 - Math.pow(1 + rate, -nper)));
        }
        return result;
    }
})