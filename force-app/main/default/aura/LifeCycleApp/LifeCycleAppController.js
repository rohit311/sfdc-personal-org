({
	doInit : function(component, event, helper) {
        console.log('doInit: ' + component.get('v.title'));
	},
    update : function(component, evt) {
		component.set("v.num", component.get("v.num")+1);
	},
    doneRendering: function(component, event, helper) {
		console.log('doneRendering: ' + component.get('v.title'));
    },
    valueChanged: function(component, event, helper) {
        console.log('Value Changed: ' + component.get('v.title'));
    }
})