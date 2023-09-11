({
	toggleAssVersion : function(component, event, helper)
    {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        console.log('click'+click);
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    saveSanctionDiscDetails : function(component, event, helper){
        helper.saveSanctionDiscDetailsHelper(component,event);
        
    }
})