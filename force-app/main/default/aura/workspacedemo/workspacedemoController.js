({
    openTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '#/sObject/0012800000FJRtXAAX/view',
            focus: true
        });
    },
})