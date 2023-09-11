({
	showhidespinner : function(component, event, helper) {
       var showhide =  event.getParam("isShow");
       if (!$A.util.isEmpty(showhide))
       helper.showHideDiv(component,"waiting",showhide);
	}
     

})