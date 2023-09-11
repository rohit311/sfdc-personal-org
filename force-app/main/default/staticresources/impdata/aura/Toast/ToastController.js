({
    onShowToast : function(cmp, evt, helper) {
        var params = evt.getParam('arguments');
        if (params) {
            helper.showToast(cmp,params.title, params.message , params.type);            
        }
        else
        {
            helper.showToast(cmp,'Error!', 'ERR-Toast::Toast not found.Something went wrong.', 'error');
        }
    },
    
    closeCustomToast : function(cmp, evt, helper){
        helper.closeToast( cmp );
    }
})