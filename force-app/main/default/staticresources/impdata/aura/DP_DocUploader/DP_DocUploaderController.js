({
	doInit : function(component, event, helper) 
    {
        component.set("v.showSpinner", true);
     // console.log('###' +  component.find("document").get("v.value"));
        helper.refresh( component, event, helper );  
	}, 
    
    
    onDelete : function(component, event, helper)
    {        
        component.set("v.showSpinner", true);
        var utility = component.find("toastCmp");
        
        var cdId = event.getSource().get("v.name");
        console.log('Id to be deleted : '  + cdId);
        var delFile = component.get("c.deleteFile"); 
        delFile.setParams({
            contentDocumentId : cdId
        });
        delFile.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS')
            {
                var retval = response.getReturnValue();
                if(retval=='SUCCESS'){
                    //alert('Deleted Successfully. ');
                    utility.showToast('Success!', 'Document deleted successfully.' , 'success');
                    helper.refresh( component, event, helper );  
                    helper.showConfetti();                   
                }
                else{
                    utility.showToast('Error!', retval , 'error');
                }
            }
            else
            {
                utility.showToast('Error!', 'Issue in server processing.Pls connect with your System administrator!' , 'error');
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(delFile);
    },
    
    onTypeChange : function(component, event, helper)
    {
        console.log('--> Event : ' + event.getSource().get("v.value"));
        console.log('--> Event Src: ' + event.getSource().get("v.name") );
        
        var evtVal = event.getSource().get("v.value");
        var evtIdxName = event.getSource().get("v.name");
        if( evtVal === ''  || evtVal === undefined )	return;
        
        if( evtIdxName === '' || evtIdxName === undefined )	return;
        
        var evtIdx = evtIdxName.split('-')[0];
        var appId = evtIdxName.split('-')[1];
        var typeList = component.get("v.typeList");
        
        /***** storing count of existing files start **************/
        var docNameMap = new Map();
        var appList = component.get("v.appList"); 
        //var typeNameList = ['Application Form', 'Mandate Form', 'Kyc Document', 'Other Document' ];
        for(var v in appList) 
        {
            if(appList[v].ContentDocumentLinks === undefined)	continue;
            
            var cdlist = appList[v].ContentDocumentLinks;
            for(var w in cdlist)
            {
                if(cdlist[w].ContentDocument === undefined)	continue;
                
                let fName = cdlist[w].ContentDocument.Title;
                
                    if( fName.indexOf( appId + '_DP_' + evtVal ) != -1)
                    {                                    
                        if( docNameMap.has(evtVal) === true)
                        {
                            var count = docNameMap.get( evtVal );
                            count = count + 1; 
                            docNameMap.set(evtVal, count);
                        }
                        else
                        { 
                            docNameMap.set(evtVal , 1);
                        }                                
                    }
            }
        }
        console.log('Printing map prepared for name :' + docNameMap);
        
        
        if( docNameMap.get(evtVal )  >= 1){
            typeList[evtIdx].count = docNameMap.get(evtVal);
        }
        else{
            typeList[evtIdx].count = '';
        }
        
        component.set("v.typeList", typeList);
        /**** END : storing count of existing files ****/
    }
})