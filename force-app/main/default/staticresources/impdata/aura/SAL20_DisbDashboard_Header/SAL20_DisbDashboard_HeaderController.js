({
	onInit : function(component, event, helper) {
         
		var recId = component.get("v.oId");
        var fetchOpp = component.get("c.fetchOpportunity");
        fetchOpp.setParams({rID : recId});
        fetchOpp.setCallback(this, function(response){
            component.set('v.record' ,response.getReturnValue());
            helper.calcGroupType(component, event, helper);
        });
        
        $A.enqueueAction(fetchOpp);
	}, 
    
    goToHome : function(component, event, helper){
        var appEvent = $A.get("e.c:SAl20_DisbDashboard_Navigator");
        appEvent.setParams({
            "SAL20_Dashboard_Component" : "Home"});
        appEvent.fire();        
    },
    goToDSS : function(component, event, helper){
        //22552
        var flow = component.get("v.record.Account.Flow__c");
        console.log('flow--->'+flow);
        console.log('event', event.target);
        var elements = document.getElementsByClassName("slds-is-active slds-tabs_default__item");
        for (var i=0; i<elements.length; i++) {
            console.log(elements[i].classList);
            elements[i].classList.remove('slds-is-active');
        }
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        $A.util.addClass(ctarget, 'slds-is-active');
        console.log(ctarget, id_str);
        
        var navURL, vfPage, groupType;
        var tabNames;
        var GTRes = component.get("v.GTResponse");
        console.log('GTRes::::'+GTRes);
        var GTResObj;
        if(GTRes != 'failed')
            GTResObj = JSON.parse(GTRes);
        else
            navURL='';
        /*if(GTResObj){
            groupType = GTResObj.GT;
            vfPage = GTResObj.Page;
        }*/
        //console.log(groupType+' '+vfPage);
        
        var loanId = component.get("v.record.Id");
        if(id_str && GTResObj){
            if(!flow || flow!='Mobility V2'){
                groupType = GTResObj.GT;
                vfPage = GTResObj.Page;
                if(id_str == 'demographic_tab'){
                    navURL = '/apex/'+vfPage+'?id='+loanId+'&grouptype='+groupType+'&hideForDash='+'true';
                }else if(id_str == 'financial_tab'){
                    navURL = '/apex/COEligibilityDetailsPage?id='+loanId+'&grouptype='+groupType+'&hideForDash='+'true';
                }else if(id_str == 'pricing_tab'){
                    navURL = '/apex/PricingDetailsPage?id='+loanId+'&grouptype='+groupType+'&hideForDash='+'true';
                }
            }
            else if((flow && flow =='Mobility V2')){
                if(id_str == 'pricing_V2'){
                    navURL = '/apex/SAL_Pricing_V2'+'?recordID='+loanId;
                }else if(id_str == 'sales_V2'){
                    navURL = '/apex/SAL_Sales_Page?recordID='+loanId;
                }else if(id_str == 'credit_tab'){
                    navURL = '/apex/SAL_UnderwritingPage?recordID='+loanId;
                }
            }
        }
        
        /*if(product){
            if(product == 'SAL' || product == 'SPL'){
                groupType = 'salaried';
            }else if(product == 'PRO' || product == 'DOCTORS'){
                groupType = 'professional';
            }else if(product == 'PSBL'){
                groupType = 'selfemployed';
            }
        }*/
        
        if(id_str){
            if(id_str == 'opportunity_tab'){
                window.open('/'+loanId);
            }
        }       
        //window.open(navURL);
        console.log('navURL : ',navURL);
        
        try{
        var appEvent = $A.get("e.c:SAl20_DisbDashboard_Navigator");
        appEvent.setParams({
            "SAL20_Dashboard_Component" : "DSS",
            "navigationURL" : navURL
        });
        appEvent.fire();    
        }catch(er){
            console.log(er);
        }
    }
    
})