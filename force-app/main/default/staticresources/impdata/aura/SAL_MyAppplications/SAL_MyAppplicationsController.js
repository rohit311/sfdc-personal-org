({
	doInit : function(component, event, helper) {
        debugger;
		//helper.showhidespinner(component,event,true);
		console.log('theme is'+component.get("v.theme"));
        helper.fetchOppList(component);
	},
    toggletab : function(component, event, helper) {
        console.log('hi'+event.target.id);
        helper.toggleAccordion(component,event);
    },
    sendback : function(component,event,helper){
        
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "display" : true
        });
        evt.fire();
        component.destroy();
    },
    navigateToLA : function(component, event, helper) {
        var stage = event.getParam("stage");
        if(stage == 'DSA/PSF Login'){
            $A.createComponent(
                
                "c:SAL_SalesCmp",{"recordId":event.getParam("oppId")},
                function(newComponent,status,errorMessage){
                    component.set("v.body",newComponent); 
                }
            );
            document.getElementById("appView").style.display = "none";
        }
        else if(stage == 'Post Approval Sales'){
            $A.createComponent(
                
                "c:SAL_PricingCmp",{"recordId":event.getParam("oppId")},
                function(newComponent,status,errorMessage){
                    component.set("v.body",newComponent); 
                }
            );
            document.getElementById("appView").style.display = "none";
        }
            else{
                var recordid = event.getParam("oppId");
                var theme = component.get("v.theme");
                console.log('theme is '+theme+component.get('v.iscommunityUser'));
                if(theme =='Theme3' || theme =='Theme2'){
                    if(component.get('v.iscommunityUser') == false){
                        window.open('/Partner/' + recordid,"_self");
                    	console.log('here test');
                    }
                    else
                        window.open('/' + recordid,"_self");
                }else if(theme == 'Theme4d')
                    window.open('/lightning/r/Opportunity/' + recordid + '/view',"_self");
                    else if(theme == 'Theme4t')
                        helper.navigateToPerfiosSF1(component, event, recordid);
                //window.open('http://bflhts.my.salesforce.com/'+recordid);
            }
    }
})