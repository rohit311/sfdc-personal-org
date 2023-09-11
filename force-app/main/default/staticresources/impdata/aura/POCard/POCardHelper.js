({
     gotoURL : function (component) {
        var isCommunityUser = '{!$Site.CurrentSiteUrl}' === '' ? false : true;   
        var urlEvent = $A.get("e.force:navigateToURL");
        var leadCibilId = component.get("v.leadCibilId");
        var v_url;
        v_url = "/apex/DetailedCibilReportPage?id="+ leadCibilId; 
        component.set("v.navigateURL",false);
                urlEvent.setParams({
                  "url": v_url
                });
                urlEvent.fire();
        },
    setOfferData: function(component, event){
        component.set("v.loanNumber", event.getParam('loanNumber'));
        component.set("v.cibilScore", event.getParam('cibilScore'));
    },
    invalidPO: function(component,message){
        this.showToast(component, "Error!", "This is not a valid PO: "+message, "error");
	},
    showToast: function(component, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
        	toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(component.find("customToast"), "slds-hide");
            $A.util.removeClass(toastTheme, "slds-theme--error");
        	$A.util.removeClass(toastTheme, "slds-theme--success");
            if(type == 'error'){
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if(type == 'success'){
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title+' ');
        }
    },
    
    closeToast: function(component){
        var toastTheme = component.find("toastTheme");
        $A.util.addClass(component.find("customToast"), "slds-hide");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
    },
})