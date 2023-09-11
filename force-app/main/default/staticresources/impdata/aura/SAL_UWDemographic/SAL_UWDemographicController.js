({
	doInit: function(component, event, helper) {
        var loanId = component.get('v.oppId');
        console.log('loanId++'+loanId);
    },
    callPANBre :function(component, event, helper) {
        console.log('pan bre fired');
        helper.callPANBreHelper(component,event);
    },
})