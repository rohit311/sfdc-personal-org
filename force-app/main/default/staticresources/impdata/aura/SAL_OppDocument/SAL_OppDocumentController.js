({
    doInit : function(component, event, helper) {
        console.log('inside document pk '+JSON.stringify(component.get("v.Oppobj")));
        /* CR 22307 s */
        var stage = component.get("v.stageName");
        if(component.get("v.isUnderwitercmp") == true){
            if(stage == 'Hold')
                component.set("v.isHold",true);
            if(stage == 'Underwriting' || component.get("v.Oppobj.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
                component.set("v.displayReadOnly",false);
            } 
            else{ 
                component.set("v.displayReadOnly",true);
                
            }
            // 11806 s
            if(component.get("v.Oppobj.Product__c") == 'RSL'){
                
                helper.getRules(component,event,helper);
				//call helper method to run rules.
            }
            //11806 e
            
        }
        // Bug 23064 start
            if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            { 
                component.set("v.displayReadOnly",true);
                
            } 
            // Bug 23064 stop
        /*22624 added if else s*/
        if(component.get("v.stageName") == 'Post Approval Sales' && component.get("v.isPricingcmp") == true){
            component.set("v.displayReadOnly",false);    
        }
        /*22624 e*/
        else if(component.get("v.stageName") != 'DSA/PSF Login' && component.get("v.isUnderwitercmp") == false) {
            component.set("v.displayReadOnly",true);
         
        } 
        console.log('nishit '+($A.get("$SObjectType.CurrentUser.Id") + ' and'+component.get("v.Oppobj.OwnerId")));
        if($A.get("$SObjectType.CurrentUser.Id")!=component.get("v.Oppobj.OwnerId")) //25051
            component.set("v.arDisabled",true); //25051
        if(component.get("v.displayReadOnly") == true){// ||($A.get("$SObjectType.CurrentUser.Id")!=component.get("v.Oppobj.OwnerId"))){ //||($A.get("$SObjectType.CurrentUser.Id")!=component.get("v.Oppobj.OwnerId")) Bug 25051
           component.set("v.isdiablebutton",true); 
            if(component.get("v.stageName") == 'Approved') 
                component.set("v.isdisablePricingbutton",false);
            else
                component.set("v.isdisablePricingbutton",true);
        }  /* CR 22307 e */ 
        //helper.getChecklistDocOnload(component, event);
       helper.checkAllSolPolicies(component,event);
    },
    /*hideDocumentCPV :  function(component,event,helper){
       // var event =  $A.get("e.c:PassCountOfVerificationListToParent");
		var count = event.getParam("count");
     console.log('Hi count is = '+count);
      if(count==0)
        {
        $A.util.addClass(component.find('VerificationImageUpload'), 'slds-hide');       
        }
        else
                    $A.util.removeClass(component.find('VerificationImageUpload'), 'slds-hide');       

            
        
    },*/
    /*Doc Uploader s*/
    handleStdUpload: function (cmp, event, helper) {
        // Get the list of uploaded files
        console.log('in after event');
        helper.handleStdUploadHelper(cmp,event);
        //alert("Files uploaded : " + uploadedFiles[0].documentId);
    },
    /*Doc Uploader e*/
    /* 20939 s */
    checkSOlPolicyRec : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        helper.checkAllSolPolicies(component,event);
       
	 }, 
    /* 20939 e */
    callPANBre : function(component,event,helper){
        helper.callPANBre(component,event);    
    },
    sendToCreditOfficer : function(component, event, helper) {
        helper.applicantRecord(component, event);
    }, 
    submitPricing : function(component, event, helper) {
       component.set("v.isHoldEnabled",false);
       component.set("v.isTextBoxEnabledreject",false);
       component.set("v.isTextBoxEnabledRecommend",false);
	   component.set("v.isSendBackEnabled",false);
       component.set("v.isTextBoxEnabled",false);
       helper.submitForPricing(component, event);
    }, 
    submitRecommend : function(component, event, helper) {
        component.set("v.isHoldEnabled",false);
     	component.set("v.isTextBoxEnabledRecommend",true);
		component.set("v.isSendBackEnabled",false);
        component.set("v.isTextBoxEnabled",false);
        component.set("v.isTextBoxEnabledreject",false);
           if(!$A.util.isEmpty(component.find("rejectbutton")))
        component.find("rejectbutton").set("v.disabled",false);
    }, 
     submitHold : function(component, event, helper) {
        component.set("v.isHoldEnabled",true);
        console.log('pk hold'+component.get("v.Oppobj").Hold_Reason__c);
        var multislect = component.find("mymultiselect");
        multislect.setRejectReason(component.get("v.Oppobj").Hold_Reason__c);

     	component.set("v.isTextBoxEnabledRecommend",false);
		component.set("v.isSendBackEnabled",false);
        component.set("v.isTextBoxEnabled",false);
        component.set("v.isTextBoxEnabledreject",false);
        component.find("holdBtn").set("v.disabled",false);
           if(!$A.util.isEmpty(component.find("rejectbutton")))
        component.find("rejectbutton").set("v.disabled",false);
    }, 
    holdCancel : function(component, event, helper){ 
        component.set("v.isHoldEnabled",false);

    }, 
    holddone :function(component, event, helper){ 
      helper.holddoneHelper(component,event);
    },
     submitunHold :function(component, event, helper){ 
      helper.submitunHoldhelper(component,event);
    },
	submitSendBack : function(component, event, helper) {
        component.set("v.isHoldEnabled",false);
		component.set("v.isSendBackEnabled",true);
     	component.set("v.isTextBoxEnabledRecommend",false);
        component.set("v.isTextBoxEnabled",false);
        component.set("v.isTextBoxEnabledreject",false);
        console.log(component.find("rejectbutton"));
        if(!$A.util.isEmpty(component.find("rejectbutton")))
        	component.find("rejectbutton").set("v.disabled",false);
		var multislect = component.find("mymultiselectSendback");//User story 985
        multislect.setRejectReason(component.get("v.Accobj").Send_Back_Reason__c);//User story 985
    }, 
	SendbackCancel : function(component, event, helper){ 
        component.set("v.isSendBackEnabled",false);
    }, 
   sendBackdone :function(component, event, helper){ 
        //User story 985 s
        var isvalid = true;
        var multislect = component.find("mymultiselectSendback");
        var mySelectedvalues = multislect.bindData();
        component.set("v.SelvalSendback",mySelectedvalues);
        if($A.util.isEmpty(mySelectedvalues))
        {
            isvalid =false;
            $A.util.addClass(component.find("multiselectsendback"), "slds-show");
        }
        if(isvalid){
        debugger;
        helper.sendbacktosales(component,event);
        }
        else
        {   
            debugger;
          helper.displayToastMessage(component,event,'Error','Please select send back reason ','error');
        }
        //User story 985 e
    },
    operationSelectCreditOfficer : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        var loanAppId = component.get('v.oppId'); 
        var isPerfiosMsg = true;
        var action = component.get('c.getSelectCreditOfficer');
        action.setParams({
            loanApplicationId : loanAppId 
        });
        
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            console.log(response.getReturnValue());
            //helper.closeParentToastHelper('parentInfoToastCredit','parentInfoMsgCredit');
            console.log('result ssm>>>'+result);
            if(result == 'showCreditSection' || result == 'PAN CHECK NOT DONE')
            {           
                // Bug Id : 21804
                
                helper.creditAutoAllocation(component);
                
            }
            else if(result == 'Sales not available'){
            	helper.showhidespinner(component,event,false);
            	helper.displayToastMessage(component,event,'Error','Sales officer not available','error');    
            }
            else if(result == 'PLTB Success' || result == 'Success')
            {            
              //  alert('inside pltb');
                         // user story 978 s
                        var updateidentifier =  $A.get("e.c:Update_identifier");
                        updateidentifier.setParams({
                            "eventName": 'Submit To Credit',
                            "oppId":component.get("v.oppId")
                        });
                        updateidentifier.fire();
                        // user story 978 e

                helper.showhidespinner(component,event,false);// Bug Id : 21804
                //console.log('in pltb Success');
                component.find("sendToCreditButton").set("v.disabled",true);
                //helper.showParentToastHelper('parentInfoToastCredit','parentInfoMsgCredit','CheckList rules failed , case will now be assigned to PO owner ',false);
                helper.displayToastMessage(component,event,'Info','CheckList rules failed , case will now be assigned to ASM','info');
                if(component.get('v.nameTheme') =='Theme3' || component.get('v.nameTheme') =='Theme2'){
                    if(component.get('v.iscommunityUser'))
                        window.location.href = '/Partner/006/o';
                    else
                        window.location.href = '/006/o';
                }else if(component.get('v.nameTheme') == 'Theme4d')
                    window.location.href = '/lightning/o/Opportunity/list?filterName=Recent';
                    else if(component.get('v.nameTheme') == 'Theme4t')
                        helper.onLoadRecordCheckForSF1(component, event);
            }
                else if(result.includes('incompleteData')){
                    var incompleteFields = result.split('-');
                    helper.showhidespinner(component,event,false);// Bug Id : 21804
                    helper.displayToastMessage(component,event,'Error','Please enter all mandatory fields in previous tabs'+incompleteFields[1],'error');
                }
                  /* else if(result == 'PAN CHECK NOT DONE'){
                    helper.showhidespinner(component,event,false);// Bug Id : 21804
                    helper.displayToastMessage(component,event,'Error','Please initiate PAN check','error');
                }*/
                 else if(result == 'EPFO NOT DONE'){
                    helper.showhidespinner(component,event,false);// Bug Id : 21804
                    helper.displayToastMessage(component,event,'Error','Please complete EPFO check','error');
                }
                    else if(result == 'CreditFailure'){
                        helper.showhidespinner(component,event,false);// Bug Id : 21804
                        //helper.showParentToastHelper('parentErrorToastCredit','parentErrorMsgCredit','Failed to submit to credit due to document policy ',false);     
                        helper.displayToastMessage(component,event,'Error','Failed to submit to credit due to document policy ','error');
                    }
            			/* Bug 22624 Start - Hrushikesh Sprint 5C */
                        else if(result=='hit_generate_checklist')            
                        {
                            helper.showhidespinner(component,event,false);// Bug Id : 22624
                            helper.displayToastMessage(component,event,'Error','Please hit generate checklist button','error');  
                        }            
            			/* Bug 22624 stop - Hrushikesh Sprint 5C */
                        else{
                            helper.showhidespinner(component,event,false);// Bug Id : 21804
                            //helper.showParentToastHelper('parentErrorToastCredit','parentErrorMsgCredit','Internal Server Error , Please try again later ! ',false); 
                            helper.displayToastMessage(component,event,'Error','Internal Server Error , Please try again later ! ','error');
                            //console.log('Internal Server Error');    
                        }
            
        });
        console.log('Contact Record Saved Successfully!!'+isPerfiosMsg);
        if(isPerfiosMsg == true)
        {
            console.log('Contact Record Saved Successfully!!');
            var sendToCreditVar = component.find("sendToCreditId").get("v.checked");
            if (sendToCreditVar != null && sendToCreditVar == true)
            {
                //helper.showParentToastHelper('parentInfoToastCredit','parentInfoMsgCredit','Please wait... ',true);
                //helper.displayToastMessage(component,event,'Message','Please wait...','message');
                $A.enqueueAction(action);
                helper.loadData(component, event);
                component.set('v.isBoxEnabled',true);
            }
            else
            {
                helper.showhidespinner(component,event,false);
                component.set('v.showCredit',false);
                helper.displayToastMessage(component,event,'Info','Please check confirmation checkbox','info');
                        
                //alert('Please check confirmation checkbox');
            }
        } 
        else
            console.log(' Perfios flag '+isPerfiosMsg);
    },
    sendtoSales : function(component, event, helper){
        helper.salesSumbit(component, event);
    },
    setCountList : function(component, event, helper) {
        console.log('inside onchange');
        var docName = component.get("v.DocSelected");
        var docCountMap = component.get("v.docCountMap");
        var count = docCountMap[docName];
        var index = 1;
        var countList = [];
        while (index <= count) {
            countList.push(index);
            index++;
        }
		component.set("v.DocSelectedName",docName);//Added for DMS 24317
        component.set("v.countDocList",countList);
    },
    PopulateNameList : function(component, event, helper) {
        
        component.set("v.DocNameList",event.getParam("DocNameList"));
        console.log('DocNameList>>> '+JSON.stringify(component.get("v.DocNameList")));
        console.log('DocumentNameMap >>>' + JSON.stringify(event.getParam("DocumentNameMap")));
        // console.log( Object.keys(event.getParam("DocumentNameMap")));  
        var NameMap = {},doclist =[],originalmap ={},testmap ={},docCountMap = {};
        var originalmapbackup = new Map();
        var docmap =  event.getParam("DocumentNameMap");
        var docCountMap =  event.getParam("docCountMap");
        component.set("v.docCountMap",docCountMap);
        console.log('docCountMap'+docmap.length);
        var AllDocumentNameMap =  event.getParam("AllDocumentNameMap"); 
        
        if(!$A.util.isEmpty(AllDocumentNameMap)){
            testmap  = event.getParam("AllDocumentNameMap");
            component.set("v.DocOriginalNameMapbackup",testmap);
        }
        if(!$A.util.isEmpty(docmap)){
            
            originalmap = event.getParam("DocumentNameMap");
            component.set("v.DocOriginalNameMap", originalmap);
            for (var key in originalmap){
                console.log('original map');
                originalmapbackup[key] = originalmap[key];
                NameMap[originalmap[key]] = key;
            } 
            component.set("v.DocOriginalNameMapbackup",originalmapbackup);
            // var DocListMap = [];
            // for (var key in docmap ){
            //  NameMap[docmap[key]] = key ;
            /*DocListMap.push({
                        name: docmap[key],
                        value: key
                    });*/
            // } 
            console.log('NameMap '+JSON.stringify(NameMap));
            var myMap = {};
            for(var key in NameMap){
                console.log('key is'+NameMap[key]);
                doclist.push(key);
                myMap[key] = NameMap[key];
            }
        }
        // component.set("v.priya",DocListMap);
        console.log('on load backup map');
        component.set("v.DocNameMap",NameMap);
        
        component.set("v.DocNameMapbackup",myMap); 
        
        component.set("v.DocNameList",doclist);
        console.log('doclist>>'+component.get("v.DocNameList"));
        console.log(JSON.stringify(component.get("v.DocNameMap")));
        console.log(JSON.stringify(component.get("v.DocNameMapbackup")));
        console.log(JSON.stringify(component.get("v.DocOriginalNameMap")));
        if(!$A.util.isEmpty(AllDocumentNameMap)){
            console.log('AllDocumentNameMap');
            testmap  = event.getParam("AllDocumentNameMap");
            console.log('AllDocumentNameMap'+testmap);
            component.set("v.DocOriginalNameMapbackup",testmap);
        }
        console.log(JSON.stringify(component.get("v.DocOriginalNameMapbackup")));
        var documentSaveEvent = $A.get("e.c:DocumentUploadEvent");
		 //23578 start
        var containsPhoto = false;
        for(var key in component.get("v.DocOriginalNameMapbackup")){
            if(component.get("v.DocOriginalNameMapbackup")[key].includes("PHOTOG")){
                containsPhoto = true;
                break;
                
            }
            
        }
        documentSaveEvent.setParams({"containsPhoto":containsPhoto});
        //23578 stop
        documentSaveEvent.fire();
    },
    save : function(component, event, helper) {
        console.log('in checklist insert event');
        helper.showhidespinner(component,event,true);
        var docType = component.find("selectedDoc").get("v.value");
        if(docType){
            var checklistInsertEvent = $A.get("e.c:checklistInsertEvent");
            checklistInsertEvent.setParams({ 
                "checklistId": component.get("v.primaryApp.Id"), //DMS Added by swapnil 24317
                "selectFileErrorFlag": false
            });
            checklistInsertEvent.fire();
        }else{
            helper.displayToastMessage(component,event,'Error','Please select document.','error');
            helper.showhidespinner(component,event,false);
            // helper.showToast(component, 'Error!', ' Please select document type.' , 'error');
            //helper.showParentToastHelper('parentErrorToast', 'parentErrorMsg', 'Error! Please select document type.');
        }
        /*var docType = component.find("selectedDoc");
        if(docType){
            var selectedDoc = docType.get('v.value');
            console.log('selectedDoc : '+ selectedDoc);
            if(selectedDoc != ''){
                var docCMP = component.find("file-uploader-1");
                console.log('docCMP : '+ docCMP);
                if(docCMP){
                    docCMP.uploadDoc();
                }
            }else{
                alert('Please select document type.');
                // helper.showToast(component, 'Error!', ' Please select document type.' , 'error');
                //helper.showParentToastHelper('parentErrorToast', 'parentErrorMsg', 'Error! Please select document type.');
            }
        }*/
    },
    reset : function(component, event, helper){
        var docCMP = component.find("file-uploader-1");
        console.log('docCMP : '+ docCMP);
        if(docCMP){
            docCMP.resetDoc();
        }        
    },
    populateList : function(component, event, helper){
        helper.showhidespinner(component,event,true);
        //console.log('document upload event'+event.getParam("fileName")+'>>stst>>'+event.getParam("uploadStatus"));
        
        var isuploaded = "",filename="";
        var DocNameList = component.get("v.DocNameList");
        var DocNameMap =  component.get("v.DocNameMap"); 
        var DocOriginalNameMap =  component.get("v.DocOriginalNameMap");
        var DocNameMapbackup =  component.get("v.DocNameMapbackup"); 
        var DocOriginalNameMapbackup =  component.get("v.DocOriginalNameMapbackup");
        var checkId =[];
        console.log('before>>'+DocNameList);
        console.log(JSON.stringify(DocNameMap));
        console.log(JSON.stringify(DocNameMapbackup));
        console.log(JSON.stringify(DocOriginalNameMap));
        console.log(JSON.stringify(DocOriginalNameMapbackup));
        
        if((!$A.util.isEmpty(event) && !$A.util.isEmpty(event.getParam("flow")) && event.getParam("flow") == 'Mobility2') || component.get("v.standardUploader")){
            helper.showhidespinner(component,event,true);
            if((!$A.util.isEmpty(event) && !$A.util.isEmpty(event.getParam("uploadStatus")) && !$A.util.isEmpty(event.getParam("fileName"))) || component.get("v.standardUploader")){
                /*Doc Uploader*/
                if(component.get("v.standardUploader"))
                    filename = component.get("v.DocSelectedName");
                else
                    filename = event.getParam("fileName");
                if(filename.includes('|')){//23578
                    filename = filename.substring(0, filename.indexOf('|'));
                }
                console.log('filename'+filename);
                if((!$A.util.isEmpty(event) && event.getParam("uploadStatus") == "true") || component.get("v.standardUploader")){
                    if(!$A.util.isEmpty(DocNameList)){
                        var i = DocNameList.indexOf(filename);
                        console.log('i>>'+i);
                        if(i != -1) {
                            DocNameList.splice(i, 1);
                            for (var key in DocOriginalNameMap ){
                                if(DocOriginalNameMap[key] == filename){
                                    delete DocOriginalNameMap[key];
                                    checkId.push(key);
                                }
                            }
                            delete DocNameMap[filename];
                            console.log('splice');
                            console.log(DocNameMap);
                            
                        }
                    }
                }
                else if((!$A.util.isEmpty(event) && event.getParam("uploadStatus") == "false") || component.get("v.standardUploader")){
                    //console.log('filename'+filename+DocNameMapbackup[filename]);
					//23578 start
                    var containsPhoto = false;
                    for(var i=0;i<DocNameList.length;i++){
                        if(DocNameList[i].toUpperCase() == "PHOTOGRAPH"){
                            containsPhoto = true;
                            break;
                        }
                        
                    }
                    if(filename.includes('CKYC Pho') && !containsPhoto){
						DocNameList.push('PHOTOGRAPH');                        
                    } else{
                        if(!filename.includes('CKYC')){
						/*DMS upload by swapnil 24317 s */
                            var dmsDoclist=component.get("v.DMSDocmap");
                            console.log('dmsDoclist '+dmsDoclist );
                            var DMSFileFound=false;
                            for(var key in dmsDoclist){
                                var dmsDocName=dmsDoclist[key];
                                if(filename.toUpperCase() == dmsDocName.toUpperCase()){
                                        filename=key;
                                }                                   
                            } 
                            /*DMS upload by swapnil 24317 e*/
							DocNameList.push(filename);
						}
						}
					
                    
                    if(!$A.util.isEmpty(DocNameMapbackup) && !$A.util.isEmpty(DocNameMapbackup[filename])){  
                        DocNameMap[filename] = DocNameMapbackup[filename];
                    }
                    for (var key in DocOriginalNameMapbackup){
                        if(DocOriginalNameMapbackup[key] == filename){
                            DocOriginalNameMap[key] = filename;
                            checkId.push(key);
                        }//23578 start 
                        else if (filename.includes('CKYC Ph') && DocOriginalNameMapbackup[key].toUpperCase() == 'PHOTOGRAPH'){
                            checkId.push(key);
                        } 
						 //DMS code modification need to done here 24317 start
                        else{
                               console.log('in j== -1');
                                var dmsDoclist=component.get("v.DMSDocmap");
                                console.log('dmsDoclist '+dmsDoclist );
                                for(var key in dmsDoclist){
                                    var dmsDocName=dmsDoclist[key];
                                    console.log('before key found is DocName  dmsDocName '+dmsDocName.toUpperCase());
                                    if(filename.toUpperCase() == dmsDocName.toUpperCase()){
                                        console.log('key found is '+key);
                                         checkId.push(key);
                                    }                                   
                                } 
                          }
                          //DMS 24317 end//23578 stop
                        
                    }
                }
                component.set("v.countDocList",[]);
                component.set("v.DocSelected",'');
                component.set("v.DocNameList",DocNameList);
                component.set("v.DocOriginalNameMap",DocOriginalNameMap);
                component.set("v.DocNameMap",DocNameMap);
                
                
                /* var evt = $A.get("e.c:DocNameList");
                evt.setParams({
                    "DocNameList" : DocNameList
                });
                evt.fire();*/ 
                console.log('robin checkid '+checkId);
                var cmp = component.find("checklistCmp");
                /*Doc Uploader s*/
                if(component.get("v.standardUploader"))
                    cmp.updateChkRec(checkId,'true');
                else
                    cmp.updateChkRec(checkId,event.getParam("uploadStatus"));
                /*Doc Uploader e*/
            }
            helper.showhidespinner(component,event,false);
        }  
    },
    
    closeParentToast : function(component, event, helper){
        var eventId= event.getSource().getLocalId();
        console.log('robin '+eventId);
        if(eventId == "SuccessButtonFinal"){
            helper.closeParentToastHelper('parentSuccessToastCredit','parentsuccessMsgCredit');    
        }  
        else if(eventId == "errorButtonFinal"){
            helper.closeParentToastHelper('parentErrorToastCredit','parentErrorMsgCredit');
        }
            else if(eventId == "infoButtonFinal"){
                helper.closeParentToastHelper('parentInfoToastCredit','parentInfoMsgCredit');    
            }
    },

     //underwiter screen changes start
     showapprove : function(component, event, helper){
        console.log('inside showapprove');
        if(component.get("v.isconfirmed")){
       component.set("v.isTextBoxEnabled",true);
       component.find("rejectbutton").set("v.disabled",true);
        component.set("v.isTextBoxEnabledRecommend",false);
		component.set("v.isSendBackEnabled",false);
        component.set("v.isTextBoxEnabledreject",false);
       helper.updateCamObjHelper(component,event);
         }
         else
           helper.displayToastMessage(component,event,'Error','Please check confirmation checkbox','message');	
        },        
     approveCancel : function(component, event, helper){ 
        component.set("v.isTextBoxEnabled",false); 
        component.find("rejectbutton").set("v.disabled",false);
    },
    
     showreject : function(component, event, helper){
       
        console.log('inside showapprove');
       component.set("v.isTextBoxEnabledreject",true);
         component.set("v.isTextBoxEnabledRecommend",false);
		 component.set("v.isSendBackEnabled",false);
        component.set("v.isTextBoxEnabled",false);
       component.find("approvebutton").set("v.disabled",true);
        var reasonval;
        var loan = component.get("v.Oppobj");
        var reasonval = loan.Reject_Reason__c;
        var multislect = component.find("mymultiselect");
        multislect.setRejectReason(reasonval);
        }, 
     rejectCancel : function(component, event, helper){ 
        component.set("v.isTextBoxEnabledreject",false);
        component.find("approvebutton").set("v.disabled",false);
    },
     recommendCancel : function(component, event, helper){ 
        component.set("v.isTextBoxEnabledRecommend",false);
    }, 
    recommendDone :function(component, event, helper){ 
      helper.recommend(component,event);
    },
    approvedone :function(component, event, helper){ 
      //11806 s
        var valid = true;
        if(component.get("v.Oppobj.Product__c") == 'RSL')
        	valid = helper.checkrules(component,event,helper);
        if(valid)
        	helper.approvedonehelper(component,event,helper);
        else{
            helper.displayToastMessage(component,event,'Error','Remarks is mandatory if action is override','error');	
        }
        //11806 e
    },
    rejectdone : function(component,event,helper)
    {      
        var isvalid = true;
        
             var multislect = component.find("mymultiselect");
             var mySelectedvalues = multislect.bindData();
             component.set("v.mySelectedvalues",mySelectedvalues);
             if($A.util.isEmpty(mySelectedvalues))
             {
              isvalid =false;
             $A.util.addClass(component.find("multiselectdiv"), "slds-show");
             }
     if(isvalid)
     {
         helper.rejectdonehelper(component,event);
     }
     else
     {    
         helper.displayToastMessage(component,event,'Error','Please select reject reason ','error');
     }
        
    },
    DestroyChildCmp: function(component, event, helper) {
        component.set("v.body",'');
        component.destroy();
    },
    //underwiter screen changes end 
    /*Retrigger 20939 s*/
    retriggerBRE: function(component, event, helper) {
        helper.retriggerBRE(component, event, helper);
    },
    /*Retrigger 20939 e*/
    /*20939 RCU s*/
    checkIM :function(component, event, helper){ 
        helper.checkIMHelper(component,event);
        
    },
    /*20939 RCU e*/
})