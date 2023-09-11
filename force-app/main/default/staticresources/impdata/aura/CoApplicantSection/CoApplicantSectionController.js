({
    doInit : function(component, event, helper){
        
      // if(!component.get("v.isCredit")) commented for testing
        helper.showhidespinner(component,event,true);
        helper.getAppList(component,event,false);
            
    },
    updateList: function (component, event, helper) {
        console.log('inside parent');
        if(!component.get("v.isOpen")){
            component.set("v.isOpen",true);
        }
        helper.getAppList(component,event,true);
    },
    PANCheck :function(component, event, helper){
        
        helper.showhidespinner(component,event,true);
        var recAppId = event.currentTarget.value;
        helper.PANCheck(component,event,recAppId);
            
    },
    addNewRecord : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        component.set("v.currAppId",'');
        var conList = component.get("v.conList");
        var coAppList = component.get("v.coAppList");
        console.log('accObj'+component.get("v.accObj"));
        $A.createComponent(
            "c:Add_CoApplicant",
            {
                "oppId" : component.get("v.recordId"),
                "appId" : component.get("v.currAppId"),
                "primApp" : component.get("v.primApp"),
                "accObj" : component.get("v.accObj"),
                "oppObj" : component.get("v.oppObj"),
                "cityList" : component.get("v.cityList"),
				"currentDate":component.get("v.currentDate"),//23578
                "ckycFlow":component.get("v.ckycFlow"), //23578
            },
            function(newComponent){
                component.set("v.body",newComponent);
            }
        );
        //helper.showhidespinner(component,event,false);
	},
    editRecord : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        var recAppId = event.currentTarget.value;
    	helper.editRec(component,event,recAppId);
	},
    reiniCibil : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        var recAppId = event.currentTarget.value;
        helper.reiniCibil(component,event,recAppId);
    },
    deleteRecord : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        var recId = event.currentTarget.value;
        helper.delRec(component,event,recId);
    },
        //29248 start
      redirectToViewCibilReport : function (component, event, helper) {
         var appId = event.target.getAttribute('id');
         var cibilid = event.target.getAttribute('name');
          component.set("v.cibilId",cibilid );
          component.set("v.appId",appId );
          //alert(appId+'  '+cibilid);
        /*24997 added if else*/
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isViewReportModalOpen", true);
        else
            window.open('/apex/OTPOneViewCIBILpage?id=' + cibilid+'&appId='+appId,'_blank', 'toolbar=0,location=0,menubar=0');
    },
    closeModel : function (component, event, helper) {
    	component.set("v.isViewReportModalOpen", false);
        component.set("v.showcibilpopup",false );//10647

    },
	redirectToOneViewCibilReport : function (component, event, helper) {
        var cibilid = event.target.getAttribute('name');
        component.set("v.cibilId",cibilid );
        helper.FetchCibilDetails(component, event);
        component.set("v.isOneViewReportModalOpen", true);
    },
    closeOneViewModel : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpen", false);
    }, 
    redirectToOneViewCibilReportold : function (component, event, helper) {
          var cibilid = event.target.getAttribute('name');
          component.set("v.cibilId",cibilid );
        /*24997 added if else*/
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isOneViewReportModalOpenold", true);
        else
            window.open('/apex/DetailedCibilReportPage?id=' + cibilid,'_blank', 'toolbar=0,location=0,menubar=0');
            
    },
    closeOneViewModelold : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpenold", false);
    }, 
     openOneViewCIBIL : function(component, event, helper) {
         var appId = event.target.getAttribute('id');
         var cibilid = event.target.getAttribute('name');
         var cibiltempid = event.target.getAttribute('rel');
        // alert(cibiltempid);
            $A.createComponent(
                "c:OTPOneViewCIBILPageLightning",{"appId":appId,"cibid":cibilid,"cibilTempId":cibiltempid,"leadId":""},
                function(newComponent){
                    console.log('sd');
                    component.set("v.body",newComponent);
                    
                }
            ) 
        },
    //29248 end

    
})