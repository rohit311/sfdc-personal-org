({
	fetchOppList : function(component) {
        var dasaPsfList = [];
        var postApprList = [];
        var creditList = [];
        var opsList = [];
        var finnList = [];
        var rejList = [];
		var action = component.get("c.getOppList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                console.log('list'+response.getReturnValue().length);
                console.log('getOppList '+JSON.stringify(response.getReturnValue()) );
                var oppList = response.getReturnValue();
                component.set("v.loanAppList",oppList);
                for(var i=0;i<oppList.length;i++){
                    if(oppList[i].StageName == 'DSA/PSF Login')
                        dasaPsfList.push(oppList[i]);
                    else if(oppList[i].StageName == 'Rejected')
                        rejList.push(oppList[i]);
                    else if(oppList[i].StageName == 'Branch Ops')
                        opsList.push(oppList[i]);
                    else if(oppList[i].StageName == 'Moved To Finnone')
                        finnList.push(oppList[i]);
                    else if(oppList[i].StageName == 'Underwriting')
                        creditList.push(oppList[i]);
                    else if(oppList[i].StageName == 'Post Approval Sales')
                        postApprList.push(oppList[i]);
                }
                component.set("v.dasaPsfList",dasaPsfList);
                component.set("v.rejList",rejList);
                component.set("v.opsList",opsList);
                component.set("v.finnList",finnList);
                component.set("v.creditList",creditList);
                component.set("v.postApprList",postApprList);
                console.log('dasaPsfList'+dasaPsfList.length);
            }
        });
        $A.enqueueAction(action);
	},
    toggleAccordion : function(component,event) {
        
        var targetId= event.target.getAttribute('id'); 
        console.log('TargetId : '+ targetId);
        if(targetId=="name1" || targetId=="icon1" || targetId=="section1"){
            this.showHideSection(component,"icon1","section1Content");
        }else if(targetId=="name2" || targetId=="icon2" || targetId=="section2"){
            this.showHideSection(component,"icon2","section2Content");
        }else if(targetId=="name3" || targetId=="icon3" || targetId=="section3"){
            this.showHideSection(component,"icon3","section3Content");
        }else if(targetId=="name4" || targetId=="icon4" || targetId=="section4"){
            this.showHideSection(component,"icon4","section4Content");
        }else if(targetId=="name3" || targetId=="icon5" || targetId=="section5"){
            this.showHideSection(component,"icon5","section5Content");
        }else if(targetId=="subname1" || targetId=="subicon1" || targetId=="subsection1"){
            this.showHideSubSection(component,"subicon1","subsection1Content")
        }
            else if(targetId=="subname2" || targetId=="subicon2" || targetId=="subsection2"){
                this.showHideSubSection(component,"subicon2","subsection2Content")
            }
                else if(targetId=="subname3" || targetId=="subicon3" || targetId=="subsection3"){
                    this.showHideSubSection(component,"subicon3","subsection3Content")
                }
        else if(targetId=="subname4" || targetId=="subicon4" || targetId=="subsection4"){
            this.showHideSubSection(component,"subicon4","subsection4Content")
        }
        else if(targetId=="subname5" || targetId=="subicon5" || targetId=="subsection5"){
            this.showHideSubSection(component,"subicon5","subsection5Content")
        }
        else if(targetId=="subname6" || targetId=="subicon6" || targetId=="subsection6"){
            this.showHideSubSection(component,"subicon6","subsection6Content")
        }
        else if(targetId=="subname7" || targetId=="subicon7" || targetId=="subsection7"){
            this.showHideSubSection(component,"subicon7","subsection7Content")
        }
    },
    showHideSection: function(component,iconId,sectionId){
        var i;
        var length = 8;
        
        for(i=1 ; i<length ; i++){ 
            var icon = 'icon'+i;
            var section = 'section'+i+'Content';
            console.log('icon : '+ iconId);
            if(icon == iconId)
            {
                var x = document.getElementById(icon).innerHTML;
                if(x =="[-]")
                    document.getElementById(icon).innerHTML = "[+]"; 
                else
                    document.getElementById(icon).innerHTML = "[-]";    	
            }else
            {
                document.getElementById(icon).innerHTML = "[+]";
            }
            
            if(section == sectionId)
                $A.util.toggleClass(component.find(section), 'slds-hide'); 
            else
                $A.util.addClass(component.find(section), 'slds-hide'); 
        }
    },
    showHideSubSection: function(component,iconId,sectionId){
        var i;
        for(i=1 ; i<8 ; i++){ 
            var icon = 'subicon'+i;
            var section = 'subsection'+i+'Content';
            console.log('icon : '+ icon);
            if(icon == iconId)
            {
                var x = document.getElementById(icon).innerHTML;
                if(x =="[-]")
                    document.getElementById(icon).innerHTML = "[+]"; 
                else
                    document.getElementById(icon).innerHTML = "[-]";    	
            }else
            {
                document.getElementById(icon).innerHTML = "[+]";
            }
            
            if(section == sectionId)
                $A.util.toggleClass(component.find(section), 'slds-hide'); 
            else
                $A.util.addClass(component.find(section), 'slds-hide'); 
        }
    },
    navigateToPerfiosSF1 : function(component, event, recId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
})