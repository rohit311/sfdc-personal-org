({
    onInit : function (cmp, evt, helper){
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.getAggregatedUsers");       
        try{
            action.setCallback(this, function(response){
                var data = response.getReturnValue();
                cmp.set("v.profiles", data);
                cmp.set("v.showSpinner", false);
            }); 
        }catch(err)
        {
            cmp.set("v.showSpinner", false);
        }
        $A.enqueueAction(action);
    },
    
	closeModal : function(cmp, evt, helper){
        cmp.destroy();
    },
    
    downloadUserList : function(cmp, evt, helper){
        cmp.set("v.showSpinner", true);
        helper.initiateDownload(cmp, evt, helper );
    },
    
    onAccept : function(cmp, evt, helper){
        var utility = cmp.find("toastCmp");
        var checkDataDownloaded = cmp.get("v.isDownloadDone");
        
        if(checkDataDownloaded && checkDataDownloaded == true){
            helper.handleAccept(cmp,evt, helper, 'Accept');
        }
        else{
            utility.showToast('Attention:', 'Please download and check the data.', 'warning');
        }
    },
    
    onReject : function(cmp, evt, helper){
        cmp.set("v.showRejectionPanel" ,  true);
    },        
    
    onRejectionCancel : function(cmp, evt, helper){        
    	cmp.set("v.rejectReason" , "");
        cmp.set("v.showRejectionPanel" , false);
	},
    
    onRejectionDone : function(cmp, evt, helper){
        var utility = cmp.find("toastCmp");
        var v = cmp.get("v.rejectReason");
        if( typeof v == 'undefined' || v == undefined || v == '' || v.trim() == '' ){
            var utility = cmp.find("toastCmp");
            utility.showToast('Attention:', 'Please enter rejection comments.', 'warning');
        }
        else{
            helper.handleAccept(cmp,evt, helper, 'Reject');    
            cmp.set("v.showRejectionPanel", false);
        }        
    },
    
    setRejectionFocus: function(cmp, evt, helper){
        if(cmp.get("v.showRejectionPanel") ==  true){
        	cmp.find("rejection-input").focus();   
            window.setTimeout(
                $A.getCallback(function() {
                    cmp.find("rejection-input").focus();
                }), 5);
        }
    }
})