({
    render: function(cmp, helper) {
       console.log('render: ' + cmp.get('v.title'));
       return this.superRender()
    },
    afterRender: function(cmp, helper) {
        console.log('afterRender: ' + cmp.get('v.title')); 
        return this.superAfterRender()
    },
    rerender: function(cmp, helper) {
        console.log('rerender: ' + cmp.get('v.title')); 
        return this.superRerender()
    },
    unrender : function (cmp, helper) {
        console.log('unrender: ' + cmp.get('v.title')); 
        return this.superUnrender();
    }
})