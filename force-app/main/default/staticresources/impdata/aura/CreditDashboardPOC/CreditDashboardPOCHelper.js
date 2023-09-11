({
  getoppDetails : function(component, event) {
        console.log('in callVerificationAPI');
        var selectListNameMap = {};
        var oppSelectList = ["Reject_Reason_1__c","Reject_Reason__c","Hold_Reason__c"];
        selectListNameMap["Opportunity"] = oppSelectList;
        var action = component.get('c.getOppDetails');
        
        action.setParams({
            "loanApplicationId" : component.get('v.oppId'),
            "objectFieldJSON": JSON.stringify(selectListNameMap)
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('success');
                if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
                    component.set("v.existingDisList",data.existingDisList);
                    if (!$A.util.isEmpty(data.opp)){
                        //console.log(data.opp.CAMs__r.records);
                        console.log('WANT'+JSON.stringify(data.opp));
                       	console.log('Yes');
                        
                        component.set('v.loan',data.opp);/*
                        var product = $A.get("$Label.c.Top_Up_Dup_Unsecured_Products");
                        var productCodes = product.split(";");
                        if (!$A.util.isEmpty(component.get("v.loan.Product__c"))){
                             var loanProduct = component.get("v.loan.Product__c");
                            for(var i=0;i<productCodes.length;i++){
                                if(productCodes[i] == loanProduct){
                                    component.set("v.displayreferral",true);
                                }
                            }
                        }
                        component.set("v.loanProduct",component.get('v.loan.Product__c'));*/
                    } 
                    var picklistFields = data.picklistData;
                    var oppPickFlds = picklistFields["Opportunity"];
                    component.set("v.rejectOption1", oppPickFlds["Reject_Reason_1__c"]);
                    console.log('pk'+oppPickFlds["Hold_Reason__c"]);
                    component.set("v.HoldOption", oppPickFlds["Hold_Reason__c"]);
                    if (!$A.util.isEmpty(data) && !$A.util.isEmpty(data.options))
                    {
                        component.set("v.rejectOption",data.options);
                    }
                    
                   //24668 added if -else if
                    if (!$A.util.isEmpty(data.contentId) && component.get("v.appType") == 'Primary')
                        component.set("v.contentId", data.contentId);  
                    else if(!$A.util.isEmpty(data.contentIdforApp) && component.get("v.appType") == 'Financial Co-Applicant')
                         component.set("v.contentId", data.contentIdforApp);
                    else
                        component.set("v.contentId", null);
                    
                   // alert('product>>'+);
                    if (data !=null && data.ekycobj != null)
                    {
                        component.set('v.eKycObj',data.ekycobj);
                        this.eKycSplitAddress(component, event);
                    }
                    if (data !=null && data.srcamObj != null)
                    {
                        component.set('v.srcamObj',data.srcamObj);
                    }
                    //24668 added condition for co-applicant
                    if (component.get("v.appType") == 'Primary' && !$A.util.isEmpty(data.applicantPrimary))
                        component.set("v.applicantObj", data.applicantPrimary);
                    if(!$A.util.isEmpty(data.finAppl) && component.get("v.appType") == 'Financial Co-Applicant')
                        component.set("v.applicantObj", data.finAppl);
                    
                    if(!$A.util.isEmpty(data.dedupeList) && !$A.util.isEmpty(data.applicantPrimary)) 
                    {
                        
                        var dedupeLst = data.dedupeList;
                        component.set("v.dedupeObj",dedupeLst[0]);
                        var dedupePrimaryLst = [];
                        for(var i=0;i<dedupeLst.length;i++){
                            
                             if(component.get("v.appType") == 'Primary' && dedupeLst[i].Applicant__c == data.applicantPrimary.Id){
                                 if(dedupeLst[i].Source_Or_Target__c == 'Source' && !$A.util.isEmpty(dedupeLst[i].Negative_Area__c)){
                                      component.set("v.negativeAreaVal",dedupeLst[i].Negative_Area__c);
                                 }
                                 if(dedupeLst[i].Source_Or_Target__c == 'Source' && !$A.util.isEmpty(dedupeLst[i].Area_Status__c)){
                                      component.set("v.negativeAreastatus",dedupeLst[i].Area_Status__c);
                                 }
                                 dedupePrimaryLst.push(dedupeLst[i]);
                              }
                            else if(component.get("v.appType") == 'Financial Co-Applicant' && dedupeLst[i].Applicant__c == data.finAppl.Id){
                                if(dedupeLst[i].Source_Or_Target__c == 'Source' && !$A.util.isEmpty(dedupeLst[i].Negative_Area__c)){
                                      component.set("v.negativeAreaVal",dedupeLst[i].Negative_Area__c);
                                 }
                                 if(dedupeLst[i].Source_Or_Target__c == 'Source' && !$A.util.isEmpty(dedupeLst[i].Area_Status__c)){
                                      component.set("v.negativeAreastatus",dedupeLst[i].Area_Status__c);
                                 }
                                dedupePrimaryLst.push(dedupeLst[i]);
                                
                            }
                        }
                        component.set("v.dedupeList", dedupePrimaryLst); 
                    }
                  
                   if (!$A.util.isEmpty(data.customerList))
                   {
                    
                     component.set("v.customerList",data.customerList);                         
                   }
                    if(!$A.util.isEmpty(data.RuralRules)){ //11806 s
                    	component.set("v.rules",data.RuralRules);
                    } //11806 e
                     if(!$A.util.isEmpty(data.pdObj)) 
                    {
                        component.set("v.pdObj", data.pdObj);   
                        if(!$A.util.isEmpty(data.pdObj.PD_Conducted__c) && data.pdObj.PD_Conducted__c)
                            component.set("v.pddone",'Yes');
                        else
                            component.set("v.pddone",'No');
                      //  console.log('pk status'+data.pdObj.PD_Conducted__c);
                     if(component.get("v.pdObj.Tele_PD_Applicability__c") == 'NO')
               			 component.set("v.telepdstatusdashboard",'Waived');
                	 else if(component.get("v.pdObj.Tele_PD_Applicability__c") == 'YES' && !$A.util.isEmpty(data.pdObj.PD_Conducted__c) && data.pdObj.PD_Conducted__c)
               		 {
                	 component.set("v.telepdstatusdashboard",'Positive');
                    // component.set("v.cibilDashboardData.cibil_dashboard",'Positive');
               		 }
                	else
                    	 component.set("v.telepdstatusdashboard",'Pending'); 
                    }
                    if(!$A.util.isEmpty(data.allpdquestions)) 
                    {
                        console.log('pk');
                        console.log('pd questions'+data.allpdquestions);
                        var count = 1;
                        for(var i=0;i<data.allpdquestions.length;i++){
                            data.allpdquestions[i].index = count;
                            count++;
                            //console.log('tele pd'+data.allpdquestions[i].showQues+'---'+allpdquestions[i].selectedvalue);
                            if(data.allpdquestions[i].title == 'Family Members (spouse, parents, son, unmarried daughter) is/are existing BFL salaried customers')
                             
                            {
                                console.log('in ser'+data.allpdquestions[i].answer);
                                if(data.allpdquestions[i].selectedvalue == 'N'){
                                    console.log('in ser');
                                    for(var j=0;j<data.allpdquestions.length;j++){
                                        if(data.allpdquestions[j].title == 'Total family exposure'){
                                          	data.allpdquestions[j].showQues = false;
                                        	data.allpdquestions[j].selectedvalue = '';  
                                            count--;
                                        }
                                    		
                                    }
                                }
                                    
                            }
                        }
                        for(var j=0;j<data.allpdquestions.length;j++){
                            console.log('tele pd'+data.allpdquestions[j].title+'---'+data.allpdquestions[j].selectedvalue);
                        }
                        component.set("v.quesdetailslist", data.allpdquestions);   
                    }
                    if(component.get("v.appType") == 'Primary' && !$A.util.isEmpty(data.secondarycibilList)) 
                    {
                        component.set("v.secondaryCibilRecs", data.secondarycibilList);   
                    } 
                    else if(component.get("v.appType") == 'Financial Co-Applicant' && !$A.util.isEmpty(data.finAppl) && !$A.util.isEmpty(data.finAppl.CIBIL_secondary_match__r)){
                        component.set("v.secondaryCibilRecs", data.finAppl.CIBIL_secondary_match__r.records);
                    }else{
                         component.set("v.secondaryCibilRecs", null); 
                    }                   
                    
                    if(!$A.util.isEmpty(data.sanctionList)) 
                    {
                        component.set("v.sanctionList", data.sanctionList); 
                        for(var i=0;i< data.sanctionList.length;i++){
                           if(!$A.util.isEmpty(data.sanctionList[i].Status__c) && (data.sanctionList[i].Status__c == 'Pending' || data.sanctionList[i].Status__c =='Re-opened')) {
                                component.set("v.SanctionFinalOutput",'Not done');
                                                               break;

                            }
                            else if(data.sanctionList[i].Status__c !== 'Pending' || data.sanctionList[i].Status__c !== 'Re-opened'){
                                component.set("v.SanctionFinalOutput",'Done');
                            }
                            	
                        }
                       
                    }
                     if(component.get("v.appType") == 'Primary' && !$A.util.isEmpty(data.cibilExt1)) 
                    {
                        component.set("v.cibilExt1", data.cibilExt1);   
                    }//24668 start
                    else if(component.get("v.appType") == 'Financial Co-Applicant' && !$A.util.isEmpty(data.finAppl) && !$A.util.isEmpty(data.finAppl.Cibil_Extension1s__r)){
                        component.set("v.cibilExt1",data.finAppl.Cibil_Extension1s__r.records[0]);
                    }
                    else{
                        component.set("v.cibilExt1", null);    
                    }
                    console.log('cibilExt ');
                    //console.log(data.finAppl.Cibil_Extension1s__r);
                    //24668 stop
                    //console.log('____'+JSON.stringify(data.cibilTempobj));
                   if(component.get("v.appType") == 'Primary' && !$A.util.isEmpty(data.cibilTempobj))
                    {
                        component.set("v.cibilTemp", data.cibilTempobj);   
                    }//24668 start
                    else if(component.get("v.appType") == 'Financial Co-Applicant' && !$A.util.isEmpty(data.finAppl) && !$A.util.isEmpty(data.finAppl.Cibil_Temps__r)){
                        component.set("v.cibilTemp", data.finAppl.Cibil_Temps__r.records[0]);
                    }
                    else{
                        component.set("v.cibilTemp", null);
                    }
                    //24668 stop
                   
                   
                     if(component.get("v.appType") == 'Primary' && !$A.util.isEmpty(data.cibilobj))
                    {
                        component.set("v.cibil", data.cibilobj);   
                    }//24668 start
                    else if(component.get("v.appType") == 'Financial Co-Applicant' && !$A.util.isEmpty(data.finAppl) && !$A.util.isEmpty(data.finAppl.CIBILs__r)){
                        component.set("v.cibil", data.finAppl.CIBILs__r.records[0]);
                    }
                    else{
                        component.set("v.cibil", null);    
                    }
                    //24668 stop
                    
                    if (!$A.util.isEmpty(data.isCommunityUsr)){
                        component.set('v.iscommunityUser', data.isCommunityUsr);
                    }
                    if (!$A.util.isEmpty(data.theme))
                        component.set('v.theme', data.theme);
                    var verifyList  = [];
                    var verComplete = true;
                    var bankveridone = false;
                    var officeveri = false;
                    var resiveri = false;
                    var bankveri = false;
                    var perVeri = false;
                    var bankveri = false;
                    
                    if (!$A.util.isEmpty(data.veriList)){
                        for(var i=0;i<data.veriList.length;i++){
                             var test = component.get("v.appType");
                            debugger;
                            if(component.get("v.appType") == 'Primary' && data.veriList[i].Applicant__c == data.applicantPrimary.Id){
                                if(!$A.util.isEmpty(data.veriList[i].Verification_Type__c) && data.veriList[i].Verification_Type__c.toUpperCase() == 'BANK STATEMENTS'){
                                	component.set("v.bankVerifyDone", "Yes");
                                    alert(component.get("v.bankVerifyDone"));
                                    bankveridone = true;
                                }
                            if(!$A.util.isEmpty(data.veriList[i].Verification_Type__c) && data.veriList[i].Verification_Type__c.toUpperCase() == 'OFFICE VERIFICATION'){
                                if($A.util.isEmpty(data.veriList[i].Credit_Status__c) || data.veriList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                                component.set("v.officeverification",data.veriList[i]);
                            	verifyList.push(data.veriList[i]);
                                officeveri = true;
                            }if(!$A.util.isEmpty(data.veriList[i].Verification_Type__c) && data.veriList[i].Verification_Type__c.toUpperCase() == 'PERMANENT ADDRESS VERIFICATION'){
                                if($A.util.isEmpty(data.veriList[i].Credit_Status__c) || data.veriList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                                component.set("v.resPerverification",data.veriList[i]); 
                                verifyList.push(data.veriList[i]);
                                console.log('here veri2');
                                perVeri = true;
                            } if(!$A.util.isEmpty(data.veriList[i].Verification_Type__c) && data.veriList[i].Verification_Type__c.toUpperCase() == 'RESIDENCE VERIFICATION'){
                                if($A.util.isEmpty(data.veriList[i].Credit_Status__c) || data.veriList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                                component.set("v.resCurverification",data.veriList[i]);
                                verifyList.push(data.veriList[i]);
                                resiveri = true;
                            }if(!$A.util.isEmpty(data.veriList[i].Verification_Type__c) && data.veriList[i].Verification_Type__c.toUpperCase() == 'BANK STATEMENTS'){
                                if($A.util.isEmpty(data.veriList[i].Credit_Status__c) || data.veriList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                                component.set("v.bankverification",data.veriList[i]);
                                verifyList.push(data.veriList[i]);
                                bankveri = true;
                            }
                        	}
                            
                            if(component.get("v.appType") == 'Financial Co-Applicant' && data.veriList[i].Applicant__c == data.finAppl.Id){
                                if(!$A.util.isEmpty(data.veriList[i].Verification_Type__c) && data.veriList[i].Verification_Type__c.toUpperCase() == 'BANK STATEMENTS'){
                                component.set("v.bankVerifyDone", "Yes");
                                bankveridone = true;
                                }
                            if(!$A.util.isEmpty(data.veriList[i].Verification_Type__c) && data.veriList[i].Verification_Type__c.toUpperCase() == 'OFFICE VERIFICATION'){
                                if($A.util.isEmpty(data.veriList[i].Credit_Status__c) || data.veriList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                                component.set("v.officeverification",data.veriList[i]);
                            	verifyList.push(data.veriList[i]);
                                officeveri = true;                                
                            }if(!$A.util.isEmpty(data.veriList[i].Verification_Type__c) && data.veriList[i].Verification_Type__c.toUpperCase() == 'BANK STATEMENTS'){
                                if($A.util.isEmpty(data.veriList[i].Credit_Status__c) || data.veriList[i].Credit_Status__c == 'Insufficient')
                                    verComplete = false;
                                component.set("v.bankverification",data.veriList[i]);
                                verifyList.push(data.veriList[i]);
                                bankveri = true;
                            }
                        	}
                            //added for coApplicant Dashboard nandha e 24668
                        }
                    } 
                    console.log('pk negative'+component.get("v.negativeAreastatus") + verComplete);
                   if(!$A.util.isEmpty(component.get("v.negativeAreastatus")) && component.get("v.negativeAreastatus") == 'Negative' && verComplete)
                   {

                       verComplete = false;
                   }
                        
                    component.set("v.verComplete",verComplete);
                    if (!$A.util.isEmpty(verifyList))
                        component.set("v.verifyList", verifyList);
                    if (component.get("v.appType") == 'Primary' && !$A.util.isEmpty(data.objCon))
                        component.set("v.conObj", data.objCon);  // change for co applicant 24668
                    if(component.get("v.appType") == 'Financial Co-Applicant' && !$A.util.isEmpty(data.objConFin))
                        component.set("v.conObj",data.objConFin);
                    if (component.get("v.appType") == 'Primary' && !$A.util.isEmpty(data.bankObj)){//24668 added appType check
                        component.set("v.bankObj", data.bankObj);                                              
                    }else if(component.get("v.appType") == 'Primary'){
                         component.set("v.bankObj", new Object());
                    }  
                    
                      /*new change for IM swapnil 27077 s*/
                    if(!$A.util.isEmpty(data.objCon)){
                        component.set("v.DemogChange",data.objCon.Existing_cust_demog_change__c); 
                        component.set("v.DemogAction",data.objCon.Demog_change_action__c); 
                    }
                    /*new change for IM swapnil 27077 e*/
                    
                    //24668 start
                     if (component.get("v.appType") == 'Financial Co-Applicant' && !$A.util.isEmpty(data.bankObjFinn)){//24668 added appType check
                        component.set("v.bankObj", data.bankObjFinn);                                              
                    }  
                    else if(component.get("v.appType") == 'Financial Co-Applicant'){
                         component.set("v.bankObj", new Object());
                    }
                    //24668 stop
                       
                    if (!$A.util.isEmpty(data.accObj)) {
                        component.set("v.account", data.accObj);
                        if (!$A.util.isEmpty(data.accObj.Date_of_Birth__c) && component.get("v.appType") == 'Primary') {//24668 added appType
                            var age = this.fetchage(data.accObj.Date_of_Birth__c);
                            component.set("v.age",age);
                        }
                    }
                    
                     if(!$A.util.isEmpty(data.finAppl) && !$A.util.isEmpty(data.finAppl.Contact_Name__r.Date_of_Birth__c) && component.get("v.appType") == 'Financial Co-Applicant'){//24668 start
                            
                            var coAppAge = this.fetchage(data.finAppl.Contact_Name__r.Date_of_Birth__c);
                            component.set("v.age",coAppAge);                           
                        }
                        //24668 stop
                    
                    if (!$A.util.isEmpty(data.camObj)){
                        var netsalary = 0 ;
                        if(component.get("v.appType") == "Primary"){//24668 added if
                        if(!$A.util.isEmpty(data.camObj.Average_incentive_for_Q1__c))
                            netsalary = data.camObj.Average_incentive_for_Q1__c;
                        if(!$A.util.isEmpty(data.camObj.Average_incentive_for_Q2__c))
                            netsalary = netsalary + data.camObj.Average_incentive_for_Q2__c;
                        if(!$A.util.isEmpty(data.camObj.Average_incentive_for_Q3__c))
                            netsalary = netsalary + data.camObj.Average_incentive_for_Q3__c;   
                        if(netsalary != 0)
                            netsalary = netsalary/3;
                        }//24668 start
                        else if(component.get("v.appType") == "Financial Co-Applicant"){
                            var cnt = 0;
                            if(!$A.util.isEmpty(data.camObj.Receips4_Doc__c)){
                                cnt = cnt+1;
                            	netsalary = data.camObj.Receips4_Doc__c;
                            }
                            if(!$A.util.isEmpty(data.camObj.Receips5_Doc__c)){
                                cnt = cnt+1;
                            	netsalary = netsalary + data.camObj.Receips5_Doc__c;
                            }
                            if(!$A.util.isEmpty(data.camObj.Receips6_Doc__c)){
                                cnt = cnt+1;
                            	netsalary = netsalary + data.camObj.Receips6_Doc__c; 
                            }
                        if(netsalary != 0 && cnt != 0)
                            netsalary = netsalary/cnt;
                            
                        }//24668 stop
                        
                        component.set("v.netsalary",netsalary);
                        component.set("v.camObj", data.camObj);
                        if(!$A.util.isEmpty(component.get("v.camObj").Secured_FOIR__c) ||!$A.util.isEmpty(component.get("v.camObj").Unsecured_FOIR__c)){
                        var final_foir = component.get("v.camObj").Secured_FOIR__c + component.get("v.camObj").Unsecured_FOIR__c;
                        final_foir = parseFloat(final_foir).toFixed(2);
                        component.set("v.final_foir",final_foir);
                        }
                    }
                     console.log('inside inner cam');
                        //console.log(data.opp.CAMs__r.records);
                        if(data.opp && data.opp.CAMs__r && data.opp.CAMs__r.records && data.opp.CAMs__r.records.length >0){
                            component.set("v.camObj",data.opp.CAMs__r.records[0]);
                            console.log('inside inner cam');
                            
                        }
                    if(!$A.util.isEmpty(data.poobj)){
                        component.set("v.poObj",data.poobj)
                        var address = ''
                        if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_1__c")))
                            address = address + ' ' + component.get("v.poObj.Address_Line_1__c");
                        if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_2__c")))
                            address = address + ' ' + component.get("v.poObj.Address_Line_2__c");
                        if(!$A.util.isEmpty(component.get("v.poObj.Address_Line_3__c")))
                            address = address + ' ' + component.get("v.poObj.Address_Line_3__c");
                        component.set("v.poAddress",address);
                    }
                    if(!$A.util.isEmpty(component.get("v.account"))){
                        var address1 = ''
                        if(!$A.util.isEmpty(component.get("v.account.Current_Residence_Address1__c")))
                            address1 = address1 + ' ' + component.get("v.account.Current_Residence_Address1__c");
                        if(!$A.util.isEmpty(component.get("v.account.Current_Residence_Address2__c")))
                            address1 = address1 +  ' ' + component.get("v.account.Current_Residence_Address2__c");
                        if(!$A.util.isEmpty(component.get("v.account.Current_Residence_Address3__c")))
                            address1 = address1 + ' ' + component.get("v.account.Current_Residence_Address3__c");
                        //component.set("v.inputAddress",address1);
                    }
                    //COmmented below code for US 524
                    /*Bug 20939 RCU s
                    console.log('data.isCriticalChange '+data.isCriticalChange);
					if(!$A.util.isEmpty(data.isCriticalChange)){
						
						component.set("v.isCriticalChange",data.isCriticalChange);
						console.log('data.isCriticalChange return  '+component.get("v.isCriticalChange"));
					}
					if(!$A.util.isEmpty(data.DemogChange)){
						console.log('data.DemogChange '+data.DemogChange);
						component.set("v.DemogChange",data.DemogChange);
						console.log('data.DemogChange return  '+component.get("v.DemogChange"));
					}
					if(!$A.util.isEmpty(data.DemogAction)){
						console.log('data.DemogAction '+data.DemogAction);
						component.set("v.DemogAction",data.DemogAction);
						console.log('data.DemogAction return  '+component.get("v.DemogAction"));
					}
                    
					Bug 20939 RCU e*/
                    if (!$A.util.isEmpty(data.SOLPolicyList)){
                        component.set("v.solpolicyList", data.SOLPolicyList);
                        console.log('data.SOLPolicyList>>',data.SOLPolicyList);
                        var policyList = component.get("v.solpolicyList");
                        //24668 start
                        var agePol = false;
                        var salPol = false;
                        var expPol = false;
                        var cibilPol = false;
                        //24668 stop
                        
                        for(var i=0;i<policyList.length;i++){
                            if(!$A.util.isEmpty(policyList[i].Policy_Name__c)){
                                if(policyList[i].Policy_Name__c.includes("DOB MCP") && !$A.util.isEmpty("v.applicantObj") && component.get("v.applicantObj.Id") == policyList[i].Applicant_Name__c){
                                    console.log('in age mcp');
                                    component.set("v.agesolpolicy",policyList[i]);
                                    agePol = true;//24668
                                }
                                
                                if(policyList[i].Policy_Name__c.includes("Experience MCP") && !$A.util.isEmpty("v.applicantObj") && component.get("v.applicantObj.Id") == policyList[i].Applicant_Name__c){
                                    component.set("v.expsolpolicy",policyList[i]);
                                    expPol = true;//24668
                                	console.log('in exp mcp');
                                }
                                console.log('exppppppppppppppppppppppp>>'+component.get("v.expsolpolicy") && !$A.util.isEmpty("v.applicantObj") && component.get("v.applicantObj.Id") == policyList[i].Applicant_Name__c);
                                if(policyList[i].Policy_Name__c.includes("Sal MCP")){
                                    component.set("v.salsolpolicy",policyList[i]);
                                	console.log('in sal mcp');
                                    salPol = true;//24668
                                }
                                if(policyList[i].Policy_Name__c.includes("Primary Pan Check") && !$A.util.isEmpty("v.applicantObj") && component.get("v.applicantObj.Id") == policyList[i].Applicant_Name__c){   
                                    if(!$A.util.isEmpty(policyList[i].Old_Address_Value__c)){
                                        var oldVal =  JSON.parse(policyList[i].Old_Address_Value__c);
                                        console.log('oldVal>>>>'+oldVal);
                                        component.set("v.panDashboardData",oldVal);
                                        console.log(JSON.stringify(component.get("v.panDashboardData")));
                                    } 
                                    
                                }
                                if(policyList[i].Policy_Name__c.includes("CIBIL Check") && !$A.util.isEmpty("v.applicantObj") && component.get("v.applicantObj").Id == policyList[i].Applicant_Name__c){    //includes("Primary Pan Check")){
                                    if(!$A.util.isEmpty(policyList[i].Old_Address_Value__c)){
                                        var addVal = JSON.parse(policyList[i].Old_Address_Value__c);
                                       
                                        console.log('addVal>>>> pk cibil',addVal);
                                        component.set("v.cibilDashboardData",addVal);
                                        debugger;
                                        console.log('sec cibil recs',component.get("v.secondaryCibilRecs"));
                                        if(addVal.codified_output_list)
                                        	component.set("v.cibilDashboardData.codified_output_list",addVal.codified_output_list.toString());
                                        
                                        cibilPol = true;//24668
                                        //alert(component.get("v.cibilDashboardData.cibil_dashboard"));
                                    } 
                                    else{
                                        console.log('in cibil else');
                                        component.set("v.cibilDashboardData",new Object());
                                	}
                                    
                                }
                                
                                
                            	if(policyList[i].Policy_Name__c.includes("Dedupe Check") && !$A.util.isEmpty("v.applicantObj") && component.get("v.applicantObj.Id") == policyList[i].Applicant_Name__c){    
                                    if(!$A.util.isEmpty(policyList[i].Old_Address_Value__c)){
                                        var addVal1 =  JSON.parse(policyList[i].Old_Address_Value__c);
                                        console.log('addVal>>>>'+addVal1);
                                        component.set("v.dedupeDashboardData",addVal1);
                                    } 
                                    
                                }
                                if(policyList[i].Policy_Name__c.includes("Employment Check") && !$A.util.isEmpty("v.applicantObj") && component.get("v.applicantObj.Id") == policyList[i].Applicant_Name__c){    
                                    if(!$A.util.isEmpty(policyList[i].Old_Address_Value__c)){
                                        var addVal2 =  JSON.parse(policyList[i].Old_Address_Value__c);
                                        console.log('addVal>>>>'+addVal2);
                                        component.set("v.empCheckDashboardData",addVal2);
                                    } 
                                    
                                }else if(policyList[i].Policy_Name__c.includes("Employment Check")){//24668 start
                                    
                                    component.set("v.empCheckDashboardData",new Object());
                                }
                                //24668 stop
                                
                                
                                if(policyList[i].Policy_Name__c.includes("Banking Check") && !$A.util.isEmpty("v.applicantObj") && component.get("v.applicantObj.Id") == policyList[i].Applicant_Name__c){    
                                    if(!$A.util.isEmpty(policyList[i].Old_Address_Value__c)){
                                        var addVal2 =  JSON.parse(policyList[i].Old_Address_Value__c);
                                        console.log('addValbanking pk>>>>'+addVal2);
                                        console.log(addVal2);
                                        component.set("v.bankCheckDashboardData",addVal2);
                                    } 
                                    
                                }
                            }
                            
                        }
                        
                        //24668 start
                        if(!agePol){
                            component.set("v.agesolpolicy",new Object());
                        }
                        if(!salPol){
                            component.set("v.salsolpolicy",new Object());
                        }
                        if(!expPol){
                            component.set("v.expsolpolicy",new Object());
                        }
                        if(!cibilPol){
                            console.log('in cibil pol');
                            component.set("v.cibilDashboardData",new Object());
                        }
                        //24668 stop
                    }
                    component.set("v.panDetailsList",data.panCheckList);
                    
                    for (var i=0; i<data.panCheckList.length;i++){
                        console.log('here '+data.panCheckList[i].tatRec);
                        if(data.panCheckList[i] != null && data.panCheckList[i] != undefined && data.panCheckList[i].panType == 'Dual'){
                            component.set("v.tatObj",data.panCheckList[i].tatRec);
                            console.log(component.get("v.tatObj")); 
                            component.set("v.displayPANSave",true);
                        }
                    }
                    console.log(component.get("v.tatObj"));
                    
                } //24316
                 if (!$A.util.isEmpty(data.showDGFlag)){
                        component.set('v.showDGComp', data.showDGFlag);
                }
               //24316
            }
            else
                console.log('error');
            // this.displayMessage(component, 'displayErrorToast', 'displayErrorMsg', '<b>Error!</b>,Error while processing!');
            this.showhidespinner(component,event,false);
        });
        $A.enqueueAction(action);
        
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    fetchpicklistdata: function (component,event,oppId) {
    	var accList = ["Downsizing_Reasons__c"];
		var discrepancySelectList = ["OTPDiscrepancyCategory__c","OTPDiscrepancyDocuments__c","Status__c"];
		var selectListNameMap = {};
        selectListNameMap["Discrepancy__c"] = discrepancySelectList;
        selectListNameMap["Account"] = accList;
        var action = component.get('c.getDedupeDetails');
        action.setParams({
            "oppID": oppId,
			"objectFieldJSON": JSON.stringify(selectListNameMap)
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == "SUCCESS") {
                if(!$A.util.isEmpty(response.getReturnValue())){
                    var data = JSON.parse(response.getReturnValue());
                    var picklistFields = data.picklistData;
                    var discrepancyPickFlds = picklistFields["Discrepancy__c"];
                    component.set("v.Status__c",discrepancyPickFlds["Status__c"]); 
					var accPickFlds = picklistFields["Account"];
				    console.log('downsize'+accPickFlds["Downsizing_Reasons__c"]);
                    component.set("v.downSizeList", accPickFlds["Downsizing_Reasons__c"]);                        
                }
            }else
                console.log('error');
            
        });
        $A.enqueueAction(action);
       
      
    },
    executeApex: function(component, method, params,callback){
        console.log('params'+JSON.stringify(params));
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response.getReturnValue()'+response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    toggleAssVersion : function(component, event) {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
            
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    saveTatRec : function(component, event) {
        console.log('in helper');
        this.executeApex(component,"updateTatRec",{"tatRec":JSON.stringify(component.get("v.tatObj"))},function (error, result) {
            if(!error && result != null && result != undefined){
                console.log('result '+result);   
            }
            
        });
    },
    fetchage: function(birth){
        var today = new Date();
        var nowyear = today.getFullYear();
        var nowmonth = today.getMonth();
        var nowday = today.getDate();
        var birth = new Date(birth);
        var birthyear = birth.getFullYear();
        var birthmonth = birth.getMonth();
        var birthday = birth.getDate();
        
        var age = nowyear - birthyear;
        var age_month = nowmonth - birthmonth;
        var age_day = nowday - birthday;
        
        if(age_month < 0 || (age_month == 0 && age_day <0)) {
            age = parseInt(age) -1;
        }
        return age;
    },
     eKycSplitAddress: function(component, event) {
        var eKycObj = component.get('v.eKycObj');
        if(eKycObj !=null)
        {
            var permanentAddress = component.get('v.eKycObj.eKYC_Address_details__c');
            if (permanentAddress) {
                var result = [], line = [];
                var length = 0;
                permanentAddress.split(" ").forEach(function(word) {
                    if ((length + word.length) >= 35) {
                        result.push(line.join(" "));
                        line = []; length = 0;
                    }
                    length += word.length + 1;
                    console.log('word'+word);
                    line.push(word);
                    console.log('line'+line);
                });
                if (line.length > 0) {
                    result.push(line.join(" "));
                    console.log('final result'+result);
                }
                var address = '';
                if(result[0])
                    address = address + result[0];
                if(result[1])
                    address = address + result[1];
                
                if(result[2])
                     address = address + result[2];
                component.set("v.eKycAddress",address);
            }
        }
    }
})