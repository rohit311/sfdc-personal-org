({
	 showHideDiv: function (component, divId, show) {
		$A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
		$A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");

	}
})