({
    doinit : function(component, event, helper) {
        var OppId =component.get('v.OppId');
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-hide");
        $A.util.addClass(modalname, "slds-show");
        helper.showhidespinner(component,event,true);
        helper.executeApex(component, "getPDRecord", {
            'OppId': OppId
        }, function (error, result) {
            console.log('Returned data is '+result);
            if(!error && result!=null){
                var data=JSON.parse(result);
                component.set('v.pdObj',data);
                console.log('Pd object is '+ JSON.stringify(component.get('v.pdObj')));
                var pdObj = component.get('v.pdObj');
                console.log('pdObj object is '+ pdObj);
                helper.executeApex(component, "getallquestions",{'pdObjStr' : JSON.stringify([component.get('v.pdObj')])},
                                   function (error, resultone) {
                                       console.log('Returned data in is@@@  '+JSON.stringify(resultone));
                                       if(!error && result!=null){
                                           var data1=resultone;
                                           component.set('v.quesdetailslist',data1);
                                          // alert(component.get('v.quesdetailslist').length);
                                           console.log('answers '+JSON.stringify(component.get('v.quesdetailslist')));
                                           helper.showhidespinner(component,event,false);
                                       }  
                                   });
            }  
        });
    },
    onCrossButton : function(component,event,helper)
    {
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-show");
        $A.util.addClass(modalname, "slds-hide");
    },
    saverecords : function(component, event, helper) {
        
        var cmplist = component.find("answer");
        var quesdetailslist  = component.get("v.quesdetailslist");
        var pdobj ={};
        var isvalid = true;
        pdobj = component.get("v.pdObj");
        console.log('v.pdObj '+component.get("v.pdObj"));
        for(var i=0;i<cmplist.length;i++)
        {
            
            if(!$A.util.isEmpty(cmplist[i]) && !cmplist[i].get("v.validity").valid && quesdetailslist[i].showQues)
            {
                isvalid = false;
                cmplist[i].showHelpMessageIfInvalid();
                
            }
            if(quesdetailslist[i].showQues){
                var questionanswer;
             
                if(cmplist[i].get("v.value") === 'undefined' || $A.util.isEmpty(cmplist[i].get("v.value"))){
                     questionanswer= quesdetailslist[i].title+"-"+' ';
                  
                }    
                else
                     questionanswer= quesdetailslist[i].title+"-"+cmplist[i].get("v.value");
                  
                var fields = 'Question'+(i+1)+'__c';
                console.log('fields name is '+fields+' questionanswer '+questionanswer);
                console.log('fields pdobj '+pdobj);
                pdobj[fields] = questionanswer;
                console.log("pk"+questionanswer+'fields'+fields);
            }
            else{
                var fields = 'Question'+(i+1)+'__c';
                pdobj[fields] = ' ';
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
})