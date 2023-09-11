({
    navigateToSearch : function(component, event, helper) {
        if(component.get("v.profileName") != 'DSA Login Partner')
        {
            component.set("v.homeFlag",false);
            $A.createComponent(
                "c:Mobility_Grab_Offer",{},
                function(newComponent,status,errorMessage){
                    //  alert(component.get("v.body"));
                    //  alert(newComponent);
                    component.set("v.body",newComponent);
                    if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                        }
                }
            )
        }
        
        
    },
    navigateToMyPO : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:SAL_POListView",{},
            function(newComponent,status,errorMessage){
                component.set("v.body",newComponent);
                if (status === "SUCCESS") {
                    console.log('SUCCESS');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        )
        
    },
    goToBOT : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:SAL_BOT",{},
            function(newComponent,status,errorMessage){
                component.set("v.body",newComponent);
                if (status === "SUCCESS") {
                    console.log('SUCCESS');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        )
        
    },
    myApps : function(component, event, helper) {
        
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:SAL_MyAppplications",{"theme" : component.get("v.theme"),"iscommunityUser" : component.get("v.iscommunityUser")},
            function(newComponent,status,errorMessage){
                component.set("v.body",newComponent);
                if (status === "SUCCESS") {
                    console.log('SUCCESS');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        )
        
    },
    newLoanApplicationForm : function(component, event, helper) {
        component.set("v.homeFlag",false);
        /*var action = component.get('c.CheckUserId');
action.setParams({
"created_date1" : ''
});

action.setCallback(this,function(response){	
var state = response.getState();
console.log('state-->'+state);
if(state == 'SUCCESS')
{
var evt = $A.get("e.force:navigateToComponent");
if(evt){
console.log('evt'+evt);
evt.setParams({
componentDef: "c:SAL_SalesCmp",
componentAttributes :{"newloanFlag": true}
});

evt.fire();
}
else{*/
    $A.createComponent(
        "c:SAL_SalesCmp",{"newloanFlag": false},
        function(newComponent,status,errorMessage){
            component.set("v.body",newComponent);
            if (status === "SUCCESS") {
                console.log('SUCCESS');
            }
            else if (status === "INCOMPLETE") {
                console.log("No response from server or client is offline.")
            }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
        }
    )
    /*}

}
else{
alert('this functionality is not availabel for this user');
}
});

$A.enqueueAction(action);    */
},
     //Added for Bug 23064 Start
    SOLDashboard : function(component, event, helper) {
        
        $A.createComponent(
            "c:SOLDashboard",{},
            function(newComponent){
                component.set("v.body",newComponent);
                
            }
        ) 
        
    },
    //Added for bug 23064 Stop 
    // Added for Bug 23577 Start
    navigatetoClonePage :function(component, event, helper) {
       component.set("v.homeFlag",false);
      $A.createComponent(
          "c:CloneLAPage",{},
                    function(newComponent,status,errorMessage){
                        component.set("v.body",newComponent);
                        if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    }
                    else if (status === "INCOMPLETE") {
                       console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                    }
                    }
                )  
     },
    
    //Added for Bug 23577 Stop
    //Commented for Bug 23577 Start
     /*   newLoanApplicationForm : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
                    "c:SAL_SalesCmp",{"newloanFlag": true},
                    function(newComponent,status,errorMessage){
                        component.set("v.body",newComponent);
                        if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    }
                    else if (status === "INCOMPLETE") {
                       console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                    }
                    }
                )
                
    },*/
     //Commented for Bug 23577 Stop
    doInit : function(component, event, helper){
        //added for bug id 19263 start
        helper.showhidespinner(component,event,true);
        var a = component.get('c.getDiaryColor');
        $A.enqueueAction(a);
        //added for bug id 19263 stop
        var action = component.get("c.getTheme");
        console.log('inside doinit');
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('...inside success...');
                var responseStr = response.getReturnValue();
                var data = responseStr.split(';');
                console.log(data);
                component.set("v.theme", data[0]);
                component.set("v.profileName", data[1]);
                component.set("v.iscommunityUser", data[2]);
                //1649
                helper.showPsfCheck(component,event);
                if(component.get("v.profileName") == 'DSA Login Partner')
                {
                    var cmpTarget = cmp.find('seachTile');
                    $A.util.addClass(cmpTarget, 'slds-theme_info');
                    var cmpTarget1 = cmp.find('seachTile');
                    $A.util.removeClass(cmpTarget1, 'slds-theme--alt-inverse');
                    
                }
            }
        });
        $A.enqueueAction(action);        
    },
    //Added by Hrishikesh to getDiaryColor on main page ==>Bug id 19263 start-->
    getDiaryColor : function(component, event, helper){
        helper.getDiaryColorCode(component,event); 
    }, //end
    setDisplay : function(component, event, helper){
        component.set("v.homeFlag", event.getParam("display"));
        var a = component.get('c.getDiaryColor');//added for bug id 19263
        $A.enqueueAction(a);
        
        console.log('firing event'+event.getParam("view"));
        if(event.getParam("view") == 'fresh' ||event.getParam("view") == 'mgm' || event.getParam("view") == 'priority' || event.getParam("view") == 'submitted' || event.getParam("view") == 'followUp' || event.getParam("view") == 'disposition' || event.getParam("view") == 'ccLead' || event.getParam("view") == 'all'){
            $A.createComponent(
                "c:SAL_POListView",{"view":event.getParam("view")},
                function(newComponent,status,errorMessage){
                    component.set("v.body",newComponent);
                    if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    }
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                        }
                }
            )
        }
        else if(event.getParam("view") == 'viewoffer'){
            if(component.get("v.profileName") != 'DSA Login Partner')
            {
                component.set("v.homeFlag",false);
                $A.createComponent(
                    "c:Mobility_Grab_Offer",{},
                    function(newComponent,status,errorMessage){
                        //  alert(component.get("v.body"));
                        //  alert(newComponent);
                        component.set("v.body",newComponent);
                        if (status === "SUCCESS") {
                            console.log('SUCCESS');
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                        }
                            else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                            }
                    }
                )
            }
        }
    },
    navigateToReferral: function(component, event, helper){
        if(component.get("v.profileName") != 'DSA Login Partner')
        {
            component.set("v.homeFlag",false);
            $A.createComponent(
                "c:Referral_Mobility",{},
                function(newComponent){
                    component.set("v.body",newComponent);
                }
            )
        }
    },
    //Added by swapnil for navigate to Referral Program main page ==>Bug id 19263 end-->
    /* Bug 22624 Start - Hrushikesh Sprint 5C */
    
    goToServiceBOT : function(component, event, helper) {
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:SAL_Service_BOT",{},
            function(newComponent,status,errorMessage){
                component.set("v.body",newComponent);
                if (status === "SUCCESS") {
                    console.log('SUCCESS');
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        )
        
    },
    /* Bug 22624 Stop - Hrushikesh Sprint 5C */
    navigateToHelpline : function(component, event, helper) {
        window.open("https://onlinedm.bajajfinserv.in/_layouts/B2B_2010_LoginControls/B2B_CustomLogin.aspx?ReturnUrl=%2f_layouts%2fAuthenticate.aspx%3fSource%3d%252FPages%252FSalesRequest%252Easpx%253FMID%253D115&Source=%2FPages%2FSalesRequest%2Easpx%3FMID%3D115",'_blank');
    },
    //CR 24286 start 23062
    CreateCrossSellCmp : function(component, event, helper){
         component.set("v.homeFlag",false);
         $A.createComponent(
             "c:StandAloneMainCmp",{"isFromHomePg":true},
                function(newComponent){
                    component.set("v.body",newComponent);
                }
            )
        
    }, 
//CR 24286 stop 23062

   // US 1649 PSF Tile  
    toPsfData : function(component, event, helper) {
        //alert('Hi');
        console.log ('inside home page controller');
        component.set("v.homeFlag",false);
        $A.createComponent(
            "c:psfLoanData",{},
            function(newComponent,status,errorMessage){
                component.set("v.body",newComponent);
               // alert('Hi'+status);
                    if (status === "SUCCESS") {
                        console.log('SUCCESS');
                    								}
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                    									}
                        else if (status === "ERROR") {
                            console.log("Error: " + errorMessage);
                        								}
            }
        )
        
    },
})