({
    doInit : function(component, event, helper){
      /* CR 22307 s */
            var stage = component.get("v.stageName");
            if(stage == 'Underwriting' || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
             component.set("v.displayReadOnly",false);
            } 
            else{
            component.set("v.displayReadOnly",true);
            }
            /* CR 22307 e */
			// Bug 23064 start
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            { 
                component.set("v.displayReadOnly",true);
                
            } 
            // Bug 23064 stop
    },
    DestroyChildCmp: function(component, event, helper) {
       // component.set("v.body",'');
        component.destroy();
    },
    toggleAssVersion : function(component, event, helper) {
    	helper.toggleAssVersion(component, event);     
    },
    checkChange : function(component, event, helper) {
        var allpdquestions = component.get("v.quesdetailslist");
        var count = 1;
        for(var i=0;i<allpdquestions.length;i++){
            console.log('tele pd'+allpdquestions[i].showQues+'---');
            allpdquestions[i].index = count;
            count++;
            if(allpdquestions[i].title == 'Family Members (spouse, parents, son, unmarried daughter) is/are existing BFL salaried customers')
                
            {
                console.log('in ser'+allpdquestions[i].answer);
                if(allpdquestions[i].selectedvalue == 'N'){
                    console.log('in ser');
                    for(var j=0;j<allpdquestions.length;j++){
                        if(allpdquestions[j].title == 'Total family exposure'){
                            allpdquestions[j].showQues = false;
                        	allpdquestions[j].selectedvalue = '';
                            count--;
                        }
                    }
                }
                else{
                    for(var j=0;j<allpdquestions.length;j++){
                        if(allpdquestions[j].title == 'Total family exposure')
                            allpdquestions[j].showQues = true;
                    }
                }
                
            }
        }
        component.set("v.quesdetailslist", allpdquestions);   
    },
      onCrossButton : function(component,event,helper)
    {
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-show");
        $A.util.addClass(modalname, "slds-hide");
    },
    showmodal : function(component,event,helper)
    {
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-hide");
        $A.util.addClass(modalname, "slds-show");
    },
    savepdrecord  : function(component, event, helper) {
         var quesdetailslist  = component.get("v.quesdetailslist");
         for(var i=0;i<quesdetailslist.length;i++)
        {
            console.log(quesdetailslist[i]);
            if(quesdetailslist[i].showQues && quesdetailslist[i].mandatory =="TRUE" && $A.util.isEmpty(quesdetailslist[i].selectedvalue))
            {
                component.set("v.validallquestions",false)
                break;
            }
            else
             component.set("v.validallquestions",true)   
        }
        var ispdapplicable='';
        if(!$A.util.isEmpty(component.get("v.pdObj")))
            ispdapplicable = component.get("v.pdObj").Tele_PD_Applicability__c;
        
        if($A.util.isEmpty(ispdapplicable) || ispdapplicable != 'YES')
             component.set("v.validallquestions",true);
    	if((component.get("v.validallquestions")  || !component.get("v.validallquestions")) && !$A.util.isEmpty(component.get("v.pddone")) &&  component.get("v.pddone") != 'Yes')
        {
        helper.savepdrecordhelper(component, event);   
        }
        else if(component.get("v.validallquestions") && !$A.util.isEmpty(component.get("v.pddone")) &&  (component.get("v.pddone") == 'Yes' || component.get("v.pddone") == 'No'))
        {
        helper.savepdrecordhelper(component, event);   
        }
        else
         helper.displayToastMessage(component,event,'Error','Please answer all required questions','error'); 
    },
    
    saverecords : function(component, event, helper) {
    
       var cmplist = component.find("answer");
       var quesdetailslist  = component.get("v.quesdetailslist");
       var pdobj ={};
       var isvalid = true;
       pdobj = component.get("v.pdObj");
        for(var i=0;i<cmplist.length;i++)
        {
            
            if(!$A.util.isEmpty(cmplist[i]) && !cmplist[i].get("v.validity").valid && quesdetailslist[i].showQues)
            {
                isvalid = false;
                cmplist[i].showHelpMessageIfInvalid();
            }
            if(quesdetailslist[i].showQues){
                var questionanswer = quesdetailslist[i].title+"-"+cmplist[i].get("v.value");
                var fields = 'Question'+(i+1)+'__c';
                pdobj[fields] = questionanswer;
                console.log("pk"+questionanswer+'fields'+fields);
            }
            else{
                var fields = 'Question'+(i+1)+'__c';
                pdobj[fields] = '';
            }
            
        }
        component.set("v.pdObj",pdobj);
        if(isvalid)
        {
          component.set("v.validallquestions",true);
           helper.savepdrecordhelper(component, event); 
        }
        else
        {
           helper.displayToastMessage(component,event,'Error','Please fill all required fields','error');
        }
    },
})