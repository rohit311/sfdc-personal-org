({
	doInit : function(component, event, helper) {
        console.log('Inside Controlers Doinit');
        console.log('Flow11 : '+ component.get('v.flow') + ' ParentId : '+ component.get('v.parentId'));
        
        //setTimeout(function(){ 
        	helper.getAllVerifications(component);
        //}, 1000);
		
	},
    deleteVer : function(component, event, helper){
        var verificationId = event.getSource().get("v.value");
        console.log('verificationId to delete'+ verificationId);
        if(verificationId)
        	helper.deleteVerification(component, verificationId);
    },
    closeCustomToast : function(component, event, helper){
        helper.closeToast(component);
    },
    /*17138 s*/
    saveVeri : function(component, event, helper){
        helper.showhidespinner(component,event,true); 
        helper.saveVeriRecords(component);
    },
    toggleAssVersion : function(component, event, helper)
    {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        console.log('click'+click);
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class",'showCls');
           
            
        }else{
            component.set("v.class",'hideCls');
        }        
    }
    /*17138 e*/
})