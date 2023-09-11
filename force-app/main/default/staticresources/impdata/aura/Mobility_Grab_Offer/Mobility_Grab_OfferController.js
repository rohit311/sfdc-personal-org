({
    
    doInit  : function(component, event, helper) {
       // alert('in grab offer');
        helper.getUserIDfromApex(component,event);
        helper.getUserNamefromApex(component,event);
        console.log('after apex class ' + component.get("v.currentUser"));
    },
    searchWithPan : function(component, event, helper){
        var stringToSearch1 =component.get("v.PANString");
        var stringToSearch2 =component.get("v.NAMEString");
        var stringToSearch3 =component.get("v.MOBILEString");
        if(!$A.util.isEmpty(stringToSearch1))
        {
            var conMaritalStatusId = component.find("PANString");
            if(conMaritalStatusId.get("v.validity").valid)
                helper.searchWithPanHelper(component,event);
            else
            {
                conMaritalStatusId.showHelpMessageIfInvalid();
                component.set("v.items", null);
				component.set("v.defaultShow", true);//Bug 17583
            }
        }
        else if((!$A.util.isEmpty(stringToSearch3)))//added else if for bug id 
        {
            //var conMaritalStatusId = component.find("NAMEString");
            var conMaritalStatusId1 = component.find("MOBILEString");
            if(conMaritalStatusId1.get("v.validity").valid){
                helper.searchWithPanHelper(component,event);
               
            }else
            {
                if(!conMaritalStatusId1.get("v.validity").valid)
                    conMaritalStatusId1.showHelpMessageIfInvalid();
                component.set("v.items", null);
				component.set("v.defaultShow", true);//Bug 17583
            }
        }
        else if((!$A.util.isEmpty(stringToSearch2)) && (!$A.util.isEmpty(stringToSearch3)))//added else if for bug id 17585
        {
            var conMaritalStatusId = component.find("NAMEString");
            var conMaritalStatusId1 = component.find("MOBILEString");
            if(conMaritalStatusId.get("v.validity").valid && conMaritalStatusId1.get("v.validity").valid)
                helper.searchWithPanHelper(component,event);
            else
            {
                if(!conMaritalStatusId.get("v.validity").valid)
                    conMaritalStatusId.showHelpMessageIfInvalid();
                else
                	conMaritalStatusId1.showHelpMessageIfInvalid();
                
                component.set("v.items", null);
				component.set("v.defaultShow", true);//Bug 17583
            }
        }
        else
            helper.displayToastMessage(component,event,'Error','Enter Details to Search ','error');
	},
    resetFields : function(component, event, helper){
        component.set("v.items",null);
        component.set("v.MOBILEString",'');
        component.set("v.PANString",'');
        component.set("v.NAMEString",'');
		component.set("v.defaultShow", false);//Bug 17583
        helper.displayToastMessage(component,event,'Success','Reset Successfully','success');
    },
    sendback : function(component,event,helper){
        var targetCmp = component.find("polist");
        var body = targetCmp.get("v.body");
        targetCmp.set("v.body", ''); 
        console.log('view is'+component.get("v.view"));
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "display" : true,
            "view" : component.get("v.view")
        });
        evt.fire();
        component.destroy();
    },
    navigateToMyPO : function(component, event, helper) {
        console.log('inside grab offer navigate'+event.getParam("showgrabcomp")+event.getParam("productOfferingId"));
        component.set("v.showgrabcomp",event.getParam("showgrabcomp"));
        //component.set("v.productOfferingId",event.getParam("productOfferingId"));
        $A.createComponent(
            "c:SAL_POMainScreen",{"productOfferingId":event.getParam("productOfferingId"),"view":"viewoffer"},
            function(newComponent){
            var targetCmp = component.find("grabcmp");
            var body = targetCmp.get("v.body");
            targetCmp.set("v.body",newComponent); 
                //component.set("v.body",newComponent);
            }
        )
    }, 
    DestroyChildCmp: function(component, event, helper) {
        console.log('child destroy'); 
       // var numbers =[];
       // component.set("v.lstPo",numbers);
        component.destroy();
    },
     removerecord : function(component, event, helper) {
        var productid=event.getParam("productOfferingId"); 
         var graboffer = event.getParam("graboffer"); 
         var assigntotelecaller = event.getParam("assigntotelecaller"); 
         console.log('inside remove record'+productid+graboffer+assigntotelecaller);
        if(!$A.util.isEmpty(productid) && assigntotelecaller)
        {
            var productofferinglist = component.get("v.items");
            console.log('before '+productofferinglist);
            var newpolst =[];
         for(var i in productofferinglist){
           console.log(i);
           var po = productofferinglist[i];
             console.log('po.id'+po.Id+'   '+productid);
             if(!$A.util.isEmpty(po.Id) && !$A.util.isEmpty(productid) && (po.Id !== productid))
             {
                 newpolst.push(po);
             }
         }
       component.set("v.items",newpolst);
       console.log('aftre'+component.get("v.items"));
      }
        if(!$A.util.isEmpty(productid) && graboffer)
        {
            var productofferinglist = component.get("v.items");
            console.log('before '+productofferinglist);
            var newpolst =[];
         for(var i in productofferinglist){
           console.log(i);
           var po = productofferinglist[i];
             console.log('po.id'+po.Id+'   '+productid);
           if(po.Id == productid)
           {
            po.Owner.Id = component.get("v.currentUser");
            po.Owner.FirstName = component.get("v.userInfo.Name");
            newpolst.push(po);
           }
           else
           newpolst.push(po);
         }
       component.set("v.items",newpolst);
       console.log('aftre'+component.get("v.items"));
      }
     }
})