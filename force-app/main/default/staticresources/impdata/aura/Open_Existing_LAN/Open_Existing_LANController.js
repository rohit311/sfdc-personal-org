({
	doInit : function(component, event, helper) {
		
        if (document.getElementById('POS_PRO_POMainDIV') != null && document.getElementById('POS_PRO_POMainDIV') != undefined)
        {    
            document.getElementById('POS_PRO_POMainDIV').innerHTML = '';
        }
        if (document.getElementById('POS_LA_MainDIV') != null && document.getElementById('POS_LA_MainDIV') != undefined)
        {    
            document.getElementById('POS_LA_MainDIV').innerHTML = '';
        }
        if (document.getElementById('POS_CPV_MainDIV') != null && document.getElementById('POS_CPV_MainDIV') != undefined)
        {    
            document.getElementById('POS_CPV_MainDIV').innerHTML = '';
        }
        if (document.getElementById('POS_LADocument_MainDIV') != null && document.getElementById('POS_LADocument_MainDIV') != undefined)
        {    
            document.getElementById('POS_LADocument_MainDIV').innerHTML = '';
        }
        
        
        
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:POS_LA_Pro_Cmp",
            componentAttributes: {
                "LoanId" : component.get("v.recordId"),
                "aura:id" : "POS_LA_Pro_Cmp"
            }
        });
        evt.fire();
        
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();

    }
})