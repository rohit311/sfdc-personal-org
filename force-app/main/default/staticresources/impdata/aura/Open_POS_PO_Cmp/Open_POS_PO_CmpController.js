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
      
        window.setTimeout(
    		$A.getCallback(function() {
                
                if(component.get("v.recordId")!=null && component.get("v.recordId")!=undefined){
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:POS_PO_Pro_Cmp",
                    componentAttributes: {
                        poId : component.get("v.recordId")
                    }
                });
                evt.fire();
                
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
            else{
                    var device = $A.get("$Browser.isAndroid");
                     var evt = $A.get("e.force:navigateToComponent");
                     evt.setParams({
                         isredirect :!device,
                        componentDef : "c:POS_PO_Pro_Cmp"                    
                    });
                    evt.fire();
            }
        		
    		}), 2000
		);
        
	

    }
})