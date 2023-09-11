({
    fetchDashboardDetails: function(component,event){    
        console.log('inside my helper data');
        
        var offerId = component.get("v.offerId");
        var leadId = component.get("v.leadId");
        console.log('here is value '+component.get("v.offerId"));
        var iconMap = [];
        var solMap = [];
        console.log('offer is '+JSON.stringify(offerId));
        
        console.log('inside  data2');
				
        		
                
                if(offerId != null){
                    this.showhidespinner(component,event,true);
                //alert(data.currentTheme);
                /*if(data.currentTheme != 'Theme4t') //if not on mobile
                {
                    $A.util.addClass(document.getElementById('deviceBasedDiv'), 'slds-align_absolute-center');       
                }
                else
                {
                    //alert('I m on mobile');
                }*/
                
                //logic for Employment check && banking check
                //var dedupeRemark='',employmentcheckremark='',bankingcheckremark='',veripermanentremark='',vericurrentremark='',veriofficeremark='',veribankingremark='';
                var employmentcheckFlag=false;
                var bankingcheckFlag=false;
                var codifiedDedupecheckFlag=false;
				var cibilflag = false;
                //var offerObj = 
                var disValMap = new Map();
                    
                    this.executeApex(component, "fetchPOdetails", {
            			"offerId" : offerId,
                        "leadId"  : leadId
        			}, function (error, result) {
            			if(!error && result){
                            console.log(result);
                            var details = new Map();
                            details = JSON.parse(result);
                            var offerObj = details['offerObj'];
                            var leadObj = details['leadObj'];
                            var dedupeList = details['dedupeList'];
                            solMap = details['solMap'];
                            if(solMap != null){
                                solMap = solMap['SALPL_Output'];
                            }
                            console.log('solMap is '+solMap);
                            component.set('v.offerObj',offerObj);
                            component.set('v.leadObj',leadObj);
                            
                            //dedupeList = leadObj.De_Dupes__r;
                            console.log('dedupeList '+JSON.stringify(dedupeList));
                            console.log('dedupeList '+' '+dedupeList.length);
                            component.set('v.DeDupeList',dedupeList);
					/* employment check begins */
                    if(offerObj.EPFO_Result__c != null && offerObj.EPFO_Result__c != 91 )//&&)
                    {       
                       component.set('v.EPFOcheck',true);
                    }
                           
                    if(leadObj.Domain_Check_Result__c != null && leadObj.Domain_Check_Result__c.toUpperCase() == 'OK' )//&&)
                    {       
                       component.set('v.Domaincheck',true);
                    }
                     if(offerObj.KYC_verification_Done__c != null && offerObj.KYC_verification_Done__c.toUpperCase() == 'YES' )//&&)
                    {       
                       component.set('v.Emailcheck',true);
                    }
					/* employment check ends*/
                    /*if(offerObj.EPFO_Result__c )//&&) // add condition for cibil
                    {    
                        component.set('v.Cibilcheck',true); 
                        cibilflag = true;
                    }*/
                    if(!offerObj.Bank_Details_Change__c)
                    {
                            bankingcheckFlag=true;

                    }
                            //console.log('sol pol '+solMap['employment_check'] + ' ' + solMap['CIBIL_check']);
                            if(solMap != null && solMap['employment_check'] == 'SUCCESSFUL'){
                                employmentcheckFlag=true;
                            }
                            if(solMap != null && solMap['CIBIL_check'] == 'SUCCESSFUL'){
                                cibilflag = true;
                                component.set('v.Cibilcheck',true);
                            }
                    	dedupeList.forEach(obj => {
                            console.log('dedupe is::: '+JSON.stringify(obj));
                            console.log('source or target:::'+obj.Source_Or_Target__c);
                            console.log('status:::'+obj.Customer_Status__c);
                        if(obj.Source_Or_Target__c == 'Source' && obj.Customer_Status__c != null && obj.Customer_Status__c.toLowerCase() == 'good'){
                        	component.set('v.DeDupeFlag',true);
                    	}
					});       
                    
 
                //console.log('document.getElementById'+document.getElementById('E KYC'));
                //document.getElementById('Employment').setAttribute("iconName", "action:close");
                if(employmentcheckFlag===true)
                {          
                    iconMap.push({
                        name: 'Employment Section',
                        value: 'action:approval'
                    });
                    //$A.util.addClass(document.getElementById('Employment'), 'green-color');       
                }
                if(employmentcheckFlag===false)
                {          
                    iconMap.push({
                        name: 'Employment Section',
                        value: 'action:close'
                    });
                    //$A.util.addClass(document.getElementById('Employment'), 'orange-color');
                    //$A.util.removeClass(document.getElementById('EmploymentSectionVals'), 'slds-hide');
                    
                }
                //document.getElementById("Employmentremark").innerHTML = employmentcheckremark;
                if(bankingcheckFlag==true)
                {
                    iconMap.push({
                        name: 'Banking Section',
                        value: 'action:approval'
                    });
                    //$A.util.addClass(document.getElementById('Banking Check'), 'green-color');       
                }
                if(bankingcheckFlag==false)
                {
                    //$A.util.addClass(document.getElementById('Banking Check'), 'orange-color');   
                    iconMap.push({
                        name: 'Banking Section',
                        value: 'action:close'
                    });    
                    //$A.util.removeClass(document.getElementById('BankDetailsSection'), 'slds-hide');
                    
                    
                }
				if(cibilflag==true)
                {
                    iconMap.push({
                        name: 'CIBIL Norms',
                        value: 'action:approval'
                    });
                    //$A.util.addClass(document.getElementById('Banking Check'), 'green-color');       
                }
                if(cibilflag==false)
                {
                    //$A.util.addClass(document.getElementById('Banking Check'), 'orange-color');   
                    iconMap.push({
                        name: 'CIBIL Norms',
                        value: 'action:close'
                    });    
                    //$A.util.removeClass(document.getElementById('CibilSection'), 'slds-hide');
                    
                    
                }
                            if(component.get('v.DeDupeFlag') == true){
                                iconMap.push({
                        		name: 'De Dupe',
                        		value: 'action:approval'
                    			});
                            }
                            else{
                                iconMap.push({
                        		name: 'De Dupe',
                        		value: 'action:close'
                    			});
                            }
							console.log('IconMap is '+JSON.stringify(iconMap));
							component.set("v.mapOfIcons",iconMap);
                        }else{
							console.log('An error eccored '+error);
						}

                        this.showhidespinner(component,event,false);
                    });
            }
            else
            {
			console.log('Empty PO');
            }
		},
        executeApex : function(component, method, params,callback){
        
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
})