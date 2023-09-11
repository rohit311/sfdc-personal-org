({
    handleError : function(component, event, helper) {
        console.log('error');
    },
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component  
        helper.closeModal(component,event);
    },
    handleSubmit : function(component, event, helper) {
        console.log('submit');      
        var contactRec = event.getParams().fields;     
        var fields = JSON.stringify(contactRec);
        console.log(fields);  
        var errorfields = '';
        var sep = '';
        for (var f in contactRec) {
            console.log('field:' + f + '=' + contactRec[f]);
            if (!contactRec[f]) {
                if (f !== 'Phone') {
                    console.log(f + ' empty and mandatory (stop)');
                    errorfields = errorfields + sep + f;
                    sep = ', ';
                    event.preventDefault();
                }             
            }
        }  
        if (errorfields !=='') component.set('v.error',errorfields+ ' must be completed');
    },
    handleSuccess : function(component, event, helper) {
        console.log('success');      
        helper.closeModal(component,event);
    }  
})