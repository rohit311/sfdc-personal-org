({
    doInit : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        console.log('doinit polistview');
        component.set('v.onload',true);
        helper.fetchPO(component);
    },
    tabSelected : function(component, event, helper)
    {
        var tabID=component.get("v.selTabId");
        console.log('tabselected'+tabID);
        component.set('v.showFilter',false); //981 US
        if(tabID != 'search' && component.get('v.onload') != true){
            if($A.util.hasClass(component.find("filterDivTog"),"slds-show"))
                $A.util.toggleClass(component.find("filterDivTog"), "slds-hide");
            console.log('tabId in DMA Page:'+tabID);
            
            if(tabID == 'fresh'){
                component.set("v.lstPo",component.get('v.freshpoList'));
            }
            else if(tabID == 'priority'){
                //component.set("v.lstPo",component.get('v.prioritypoList')); 
                var POMap = [];
                component.set('v.countAccordian',3); //981
                POMap.push({key:'Cibil Watch',value:component.get("v.CibilPO_Priority")});
                POMap.push({key:'Pre-approved',value:component.get("v.ProgramType_Priority")});
                POMap.push({key:'Others',value:component.get("v.OthersPriority")});
                console.log('POMAp length fr priority'+POMap.length)
                component.set("v.POMap",POMap);   
            } 
                else if(tabID == 'submitted'){
                    component.set("v.lstPo",component.get('v.subpoList'));
                }
                    else if(tabID ==  'followUp'){
                        component.set("v.lstPo",component.get('v.followupPOTodayToFuture'));     
                        component.set('v.showFilter',true);
                    } 
            /*20939 s*/
                        else if(tabID ==  'disposition'){
                            var POMap = [];
                            component.set('v.countAccordian',3);//981
                            console.log('NiList'+component.get("v.notInterestedList").length);
                            POMap.push({key:'Not Interested',value:component.get("v.notInterestedList")});
                            POMap.push({key:'Not Contactable',value:component.get("v.notContactList")});
                            POMap.push({key:'Not Eligible',value:component.get("v.notEligibleList")});
                            console.log('POMAp length'+POMap.length)
                            component.set("v.POMap",POMap);    
                            console.log('after');
                        } 
            /*20939 e*/
            /*Bug 18623 start*/
                            else if(tabID ==  'ccLead'){
                                component.set("v.lstPo",component.get('v.ccLeadpoList'));    
                            }
            /*Bug 18623 end*/
                                else if(tabID ==  'all'){
                                    component.set("v.lstPo",component.get('v.allpoList'));    
                                }
            //Added by swapnil -- referral program Bug id : 19263 ==>start
                                     if(tabID ==  'mgm'){
                                        component.set("v.lstPo",component.get('v.mgmQueueList'));  
                                        $A.createComponent(
                                            "c:ReferralMGMQueue",
                                            {
                                                "lstPo" : component.get("v.lstPo"),
                                                "aura:id": "childcmp1"
                                            },
                                            function(newComponent){
                                                component.set("v.body",newComponent);
                                            }
                                        );
                                    }
            //console.log('tab id is'+tabID);
            /* if(tabID !=  'mgm')
            {
                //20939 s
                console.log('tab id is'+tabID);
                if(tabID ==  'disposition'){
                    console.log('POMAp length here'+component.get("v.POMap.length"));
                    $A.createComponent(
                        "c:SAL_POListViewAcc",
                        {
                            "POMap" : component.get("v.POMap"),
                            "aura:id": "childcmp1"
                        },
                        function(newComponent,error,errorMessage){
                            console.log('error'+errorMessage);
                            component.set("v.body",newComponent);
                        }
                    );
                }
                //20939 e*/
                                        else{
                                            /*20939 s*/
                                            console.log('tab id is'+tabID);
                if(tabID ==  'disposition'|| tabID=='priority'){
                                                console.log('POMAp length here'+component.get("v.POMap.length"));
                                                $A.createComponent(
                                                    "c:SAL_POListViewAcc",
                                                    {
                                                        "POMap" : component.get("v.POMap"),
                            "aura:id": "childcmp1",
                            "countAccordian":component.get("v.countAccordian") 
                                                    },
                                                    function(newComponent,error,errorMessage){
                                                        console.log('error'+errorMessage);
                                                        component.set("v.body",newComponent);
                                                    }
                                                );
                                            }
                                            /*20939 e*/
                                            else{
                                                $A.createComponent(
                                                    "c:SAL_POListViewTable",
                                                    {
                            "allPOsList": component.get('v.flwuppoList'),
                            "showFilter": component.get('v.showFilter'),
                                                        "lstPo" : component.get("v.lstPo"),
                                                        "aura:id": "childcmp1"
                                                    },
                                                    function(newComponent){
                                                        component.set("v.body",newComponent);
                                                    }
                                                );
                                            }
                                        }  
        }
        //Added by swapnil -- referral program Bug id : 19263 ==>end
        component.set("v.view",tabID);
        console.log('component.get("v.lstPo")'+component.get("v.lstPo"));
        /*  $A.createComponent(
                "c:SAL_POListViewTable",
                {
                    // "loggedInuser" :component.get("v.loggedInuser"),
                    // "DMAId" : component.get("v.DMAId"),
                    // "oppType":component.get('v.oppType'),
                    "lstPo" : component.get("v.lstPo"),
					"aura:id": "childcmp1"
                },
                function(newComponent){
                    component.set("v.body",newComponent);
                }
            );*/
        //}
    },
    showFilter : function(component, event, helper) {
        $("#filterDivTog").slideToggle();
    },
    filterPO : function(component, event, helper) {
        /*Bug 17815 Start*/
        var isSearchTrue = component.get('v.isValidated');
        if(isSearchTrue){
            component.set("v.isValidated",true);
            helper.filterPO(component);
        }
        /*Bug 17815 End*/
    },
    goBack : function(component, event, helper) {
        helper.goBack(component);
    },
    clearSearch : function(component, event, helper) {
        helper.clearSearch(component);
    },
    sendback : function(component,event,helper){
        // var targetCmp = component.get("v.poListInit");
        // var body = targetCmp.get("v.body");
        /* var numbers = [];
       component.set("v.poListInit",numbers);
        component.set("v.lstPo",numbers);
        component.set("v.freshpoList",numbers);
        component.set("v.prioritypoList",numbers);
        component.set("v.flwuppoList",numbers);
        component.set("v.subpoList",numbers);
        component.set("v.allpoList",numbers);
        component.set("v.filteredPOList",numbers);
		var makeblank = 'null';
        component.set("v.body",makeblank); */
        
        
        
        var targetCmp = component.find("childCmpbody");
        console.log(targetCmp);
        var body = targetCmp.get("v.body");
        targetCmp.set("v.body",''); 
        
        //  var parentBody = component.get("v.body");
        //   console.log(parentBody[0].find("childcmp"));
        //  var childcmp = parentBody[0].find("dynChildId")
        
        
        //  component.getEvent("DestroyChild").fire();
        
        var evt1 = $A.get("e.c:DestroyChild");
        
        evt1.fire();
        
        //  var cmp = component.find("childcmp");
        //  console.log(cmp);
        //  cmp.destroy();
        // console.log(cmp);
        console.log('priya');
        console.log(component.get("v.poListInit"));
        console.log(component.get("v.body"));
        
        var evt = $A.get("e.c:navigateToParent");
        evt.setParams({
            "display" : true
        });
        evt.fire();
        component.destroy();
    },
    navigateToMyPO : function(component, event, helper) {
        
        component.set("v.productOfferingId",event.getParam("productOfferingId"));
        $A.createComponent(
            
            "c:SAL_POMainScreen",{"productOfferingId":event.getParam("productOfferingId"),"view":component.get("v.view")},
            function(newComponent,status,errorMessage){
                console.log('newComponent=='+errorMessage);
                
                component.set("v.body",newComponent); 
                // $A.util.addClass(component.find("tabset"), 'disbalediv');
                document.getElementById("tabset").style.display = "none";
                
            }
        );
        
    },
    /*Bug 17815 Start*/
    /*bug 18539 start*/
    onValueChange : function(component, event, helper){
        var stringToSearchOD = component.find("off_date").get("v.value");
        if(!$A.util.isEmpty(stringToSearchOD))
        {
            var offDate = new Date(stringToSearchOD);
            if((offDate.getFullYear()).toString().length > 4){
                component.find("off_date").focus();
                component.find("off_date").set('v.validity', {valid:false, badInput :true});
            }
        }
    },
    onFocusDate : function(component, event, helper){
        var stringToSearchOD = component.find("off_date").get("v.value");
        if(!$A.util.isEmpty(stringToSearchOD))
        {
            var offDate = new Date(stringToSearchOD);
            if(offDate > Date.now() ){
                component.set("v.isValidated",false);
                component.find("off_date").focus();
            }
            else
                component.set("v.isValidated",true);
        }
    },
    /*Bug 17815 End*/
    employerKeyPressController: function (component, event, helper) {
        helper.startSearch(component, 'employer');
    },
    /*Bug 18539 Start*/
    selectEmployer: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedEmployer = component.get("v.employerList")[index];
        component.set("v.selectedEmployer", selectedEmployer);
        component.set("v.employerSearchKeyword", selectedEmployer.Name);
        component.set("v.lead.Employer__c", selectedEmployer.Id);
        helper.openCloseSearchResults(component, "employer", false);
        
        console.log('emp name' + component.get("v.employerSearchKeyword"));
        var employerSearchKeyword = component.get("v.employerSearchKeyword");
        component.set("v.ifOther", false);
        if (employerSearchKeyword.toUpperCase() == 'COMPANY NOT LISTED' || employerSearchKeyword.toUpperCase() == 'OTHER' || employerSearchKeyword.toUpperCase() == 'OTHERS') {
            //alert("other");
            component.set("v.ifOther", true);
        }
        component.set("v.companyCategory", selectedEmployer.Company_Category__c);
        // this.displayEmpData(component);
    }
    /*Bug 18539 End*/
})