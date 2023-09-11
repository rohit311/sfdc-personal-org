({
    updateDetails:function(component, event) {
        var item=component.get("v.listchange");
        var oppId = component.get("v.oppId");
        
        this.executeApex(component, 'updateSolPolicies', {
            "itemlist": item,"oppId":oppId
            
        }, function(error, result){
            if(!error && result){
                var temp1=result.toString();
                if(temp1=='')
                {
                    this.displayToastMessage(component,event,'Success ', 'Disposition Status Saved','success');
                    
                }
                else
                {
                    this.displayToastMessage(component,event,'SOL Policies not found -> ', temp1,'info');
                }
                //this.fetchAccountDetails(component,event);
          //        var modalname = component.find("dashboardModel");
      // $A.util.removeClass(modalname, "slds-show");
      //  $A.util.addClass(modalname, "slds-hide");
                
                
                
            } 
        });
        
    },
    populateDispositionDataInternal: function(component, event) {
                            this.showhidespinner(component,event,true);
        var self = this;//24668
        console.log('inside populateDispositionDataInternal');
        this.executeApex(component, 'getDispositionforSOL', {
            "controllingField": "Checklist__c",
            "dependentField": "	Disposition_Status__c",
            "fldDisposition": 'Dedupe'      
        }, function(error, result){
            console.log('populateDispositionDataInternal'+result);
            if(!error && result){
                
                //console.log('populateDispositionDataInternal2'+(typeof result));
                //24668 start
                if(component.get("v.appType") == 'Financial Co-Applicant'){
                  var tilesForApp = ["PAN Check","DOB MCP","Sal MCP","Employment","Dedupe","CIBIL","Company Listing check"];  
                  var coAppRes = new Array();
                    for(var i =0;i<result.length;i++){
                        if(result[i]["key"] && tilesForApp.includes(result[i]["key"])){
                            coAppRes.push(result[i]);
                        }
                        console.log('keys '+result[i]["key"]);
                        
                    }  
                    result = coAppRes;
                
                    console.log(typeof result);
                }
               
                //24668 stop
                component.set("v.SOLDependentList", result); //contains full List
                console.log('sol data '+component.get("v.SOLDependentList"))  
        
            } 
        });
    },
    fetchAccountDetails: function(component,event){    
        console.log('inside my helper data');
        this.showhidespinner(component,event,true);
        var oppId = component.get("v.oppId");
        
        var accSelectList = ["Type_Of_Industry__c"]; 
        var checklist=["Checklist__c","Disposition_Status__c"];
        
        var selectListNameMap = {};
        selectListNameMap["Account"] = accSelectList;
        selectListNameMap["SOL_Policy__c"]= checklist;
        var iconMap = [];
        
        
        
        console.log('inside  data2');
        
        this.executeApex(component, "getDashboardDetails", {"oppID":oppId, "objectFieldJSON" : JSON.stringify(selectListNameMap),"appId":component.get("v.curAppId")}, function(error, result){
            if(!error && result){
                var data = JSON.parse(result);
               //logic for Freezed Banking row
            /*   if(data.poobj!=null)
               {
               document.getElementById('Banking').disabled=true;     
               } */
               //end of Freezed Banking row logic - Hrushikesh
                
                var picklistFields = data.picklistData;
                var veriList=data.veriList;					//this is array of verification objects(bank,office,etc only)
                
                var accPickFlds = picklistFields["Account"];
                var solPickFlds = picklistFields["SOL_Policy__c"];
                //alert(solPickFlds["Checklist__c"]); 
                console.log('hi'+solPickFlds["Disposition_Status__c"]);    
                component.set("v.checklist", solPickFlds["Checklist__c"]); //contains full List
                component.set("v.dispositionList", solPickFlds["Disposition_Status__c"]); //contains full List
                
                
                //alert(data.currentTheme);
                if(data.currentTheme != 'Theme4t') //if not on mobile
                {
                    $A.util.addClass(document.getElementById('deviceBasedDiv'), 'slds-align_absolute-center');       
                }
                else
                {
                    //alert('I m on mobile');
                }
                
                //logic for Employment check && banking check
                var dedupeRemark='',employmentcheckremark='',bankingcheckremark='',veripermanentremark='',vericurrentremark='',veriofficeremark='',veribankingremark='';
                var employmentcheckFlag=false;
                var bankingcheckFlag=false;
                var codifiedDedupecheckFlag=false;
                var veripermanentflag=false;
                var vericurrentflag=false;
                var veribankingpass=false;
                var veriofficepass=false;
                var SOLPolicyList1=data.SOLPolicyList;
                var disValMap = new Map();
                for( var i in SOLPolicyList1)
                {
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Employment Check Pass"))
                    {       
                        employmentcheckFlag=true; 
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Employment Check")){
                        if(!$A.util.isEmpty(SOLPolicyList1[i].Remarks__c))
                        	employmentcheckremark=SOLPolicyList1[i].Remarks__c;
                        disValMap['Employment'] = SOLPolicyList1[i].Disposition_Status__c;
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Banking Check Pass"))
                    {
                            bankingcheckFlag=true;

                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Banking Check")){
                        if(!$A.util.isEmpty(SOLPolicyList1[i].Remarks__c))
                        	bankingcheckremark = SOLPolicyList1[i].Remarks__c;
                        disValMap['Banking Check'] = SOLPolicyList1[i].Disposition_Status__c;
                    }
                    if(SOLPolicyList1[i].Policy_Name__c=="Dedupe Check Pass")
                    {
                        codifiedDedupecheckFlag=true;
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Dedupe Check"))
                    {
                        if(!$A.util.isEmpty(SOLPolicyList1[i].Remarks__c))
                        	dedupeRemark=SOLPolicyList1[i].Remarks__c;
                        disValMap['Dedupe'] = SOLPolicyList1[i].Disposition_Status__c;
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Veri- Permanent Pass"))
                    {
                        //if(SOLPolicyList[i].Checklist_Policy_Status__c === 'Pass')
                        //{
                        veripermanentflag=true;
                        //}
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Veri- Permanent")){
                        veripermanentremark = SOLPolicyList1[i].Remarks__c;
                        disValMap['Veri- Permanent'] = SOLPolicyList1[i].Disposition_Status__c;
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Veri- Current Pass"))
                    {
                        //if(SOLPolicyList[i].Checklist_Policy_Status__c === 'Pass')
                        //{
                        vericurrentflag=true;
                        //}
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Veri- Current")){
                        if(!$A.util.isEmpty(SOLPolicyList1[i].Remarks__c))
                        	vericurrentremark = SOLPolicyList1[i].Remarks__c;
                        disValMap['Veri- Current'] = SOLPolicyList1[i].Disposition_Status__c;
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Veri- Office Pass"))
                    {
                        //if(SOLPolicyList[i].Checklist_Policy_Status__c === 'Pass')
                        //{
                        veriofficepass=true;
                        //}
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Veri- Office")){
                        if(!$A.util.isEmpty(SOLPolicyList1[i].Remarks__c))
                        	veriofficeremark = SOLPolicyList1[i].Remarks__c;
                        disValMap['Veri- Office'] = SOLPolicyList1[i].Disposition_Status__c;
                    }	
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Veri- Banking Pass"))
                    {
                        //if(SOLPolicyList[i].Checklist_Policy_Status__c === 'Pass')
                        //{
                        veribankingpass=true;
                        //}
                    }
                    if(SOLPolicyList1[i].Policy_Name__c.includes("Veri- Banking")){
                        if(!$A.util.isEmpty(SOLPolicyList1[i].Remarks__c))
                        	veribankingremark = SOLPolicyList1[i].Remarks__c;
                        disValMap['Veri- Banking'] = SOLPolicyList1[i].Disposition_Status__c;
                    }
                }
                //console.log('document.getElementById'+document.getElementById('E KYC'));
                //document.getElementById('Employment').setAttribute("iconName", "action:close");
                if(employmentcheckFlag===true)
                {          
                    iconMap.push({
                        name: 'Employment',
                        value: 'action:approval',
                        remarks: employmentcheckremark
                    });
                    //$A.util.addClass(document.getElementById('Employment'), 'green-color');       
                }
                if(employmentcheckFlag===false)
                {          
                    iconMap.push({
                        name: 'Employment',
                        value: 'action:close',
                        remarks: employmentcheckremark
                    });
                    //$A.util.addClass(document.getElementById('Employment'), 'orange-color');
                    $A.util.removeClass(document.getElementById('EmploymentdropdownDiv'), 'slds-hide');
                    
                }
                //document.getElementById("Employmentremark").innerHTML = employmentcheckremark;
                if(bankingcheckFlag==true)
                {
                    iconMap.push({
                        name: 'Banking Check',
                        value: 'action:approval',
                        remarks: bankingcheckremark
                    });
                    if(document.getElementById('Banking CheckdropdownDiv'))      
                    $A.util.addClass(document.getElementById('Banking CheckdropdownDiv'), 'slds-hide');//24668       
                }
                if(bankingcheckFlag==false)
                {
                    //$A.util.addClass(document.getElementById('Banking Check'), 'orange-color');   
                    iconMap.push({
                        name: 'Banking Check',
                        value: 'action:close',
                        remarks: bankingcheckremark
                    });    
                     if(document.getElementById('Banking CheckdropdownDiv'))
                    $A.util.removeClass(document.getElementById('Banking CheckdropdownDiv'), 'slds-hide');
                    
                    
                }
                //document.getElementById("Banking Checkremark").innerHTML = bankingcheckremark;
                if(codifiedDedupecheckFlag==true)
                {      
                    iconMap.push({
                        name: 'Dedupe',
                        value: 'action:approval',
                        remarks: dedupeRemark
                    });
                    //$A.util.addClass(document.getElementById('Dedupe'), 'green-color');  
                    $A.util.addClass(document.getElementById('DedupedropdownDiv'), 'slds-hide');//24668      
                }
                if(codifiedDedupecheckFlag===false)
                {
                    iconMap.push({
                        name: 'Dedupe',
                        value: 'action:close',
                        remarks: dedupeRemark
                    });
                    //$A.util.addClass(document.getElementById('Dedupe'), 'orange-color');  
                    $A.util.removeClass(document.getElementById('DedupedropdownDiv'), 'slds-hide');
                    
                    
                    //$A.util.removeClass(document.getElementById('Deduperemark'), 'slds-hide');   
                    
                }
                //document.getElementById("Deduperemark").innerText = dedupeRemark;
                if(veripermanentflag===true)
                {         
                    iconMap.push({
                        name: 'Veri- Permanent',
                        value: 'action:approval',
                        remarks: veripermanentremark
                    });
                    //$A.util.addClass(document.getElementById('Veri- Permanent'), 'green-color');   
                     $A.util.addClass(document.getElementById('Veri- PermanentdropdownDiv'), 'slds-hide');//24668        
                }
                if(veripermanentflag===false)
                {       
                    iconMap.push({
                        name: 'Veri- Permanent',
                        value: 'action:close',
                        remarks: veripermanentremark
                    });
                    //$A.util.addClass(document.getElementById('Veri- Permanent'), 'orange-color');
                    $A.util.removeClass(document.getElementById('Veri- PermanentdropdownDiv'), 'slds-hide');
                    
                }
                //document.getElementById("Veri- Permanentremark").innerHTML = veripermanentremark;
                if(vericurrentflag===true)
                {          
                    iconMap.push({
                        name: 'Veri- Current',
                        value: 'action:approval',
                        remarks: vericurrentremark
                    });
                    //$A.util.addClass(document.getElementById('Veri- Current'), 'green-color');   
                    $A.util.addClass(document.getElementById('Veri- CurrentdropdownDiv'), 'slds-hide');//24668     
                }
                if(vericurrentflag===false)
                {     
                    iconMap.push({
                        name: 'Veri- Current',
                        value: 'action:close',
                        remarks: vericurrentremark
                    });
                    //$A.util.addClass(document.getElementById('Veri- Current'), 'orange-color');
                    $A.util.removeClass(document.getElementById('Veri- CurrentdropdownDiv'), 'slds-hide');
                    
                }
                if(veribankingpass===true)
                {       
                    iconMap.push({
                        name: 'Veri- Banking',
                        value: 'action:approval',
                        remarks: veribankingremark
                    });
                    //$A.util.addClass(document.getElementById('Veri- Banking'), 'green-color'); 
                    $A.util.addClass(document.getElementById('Veri- BankingdropdownDiv'), 'slds-hide');//24668      
                }
                if(veribankingpass===false)
                {        
                    iconMap.push({
                        name: 'Veri- Banking',
                        value: 'action:close',
                        remarks: veribankingremark
                    });
                    //$A.util.addClass(document.getElementById('Veri- Banking'), 'orange-color');
                    $A.util.removeClass(document.getElementById('Veri- BankingdropdownDiv'), 'slds-hide');
                    
                }
                //document.getElementById("Veri- Bankingremark").innerHTML = veribankingremark;
                //document.getElementById("Veri- Currentremark").innerHTML = vericurrentremark;
                if(veriofficepass===true)
                {     
                    iconMap.push({
                        name: 'Veri- Office',
                        value: 'action:approval',
                        remarks: veriofficeremark
                    });
                    //$A.util.addClass(document.getElementById('Veri- Office'), 'green-color');  
                    $A.util.addClass(document.getElementById('Veri- OfficedropdownDiv'), 'slds-hide'); //24668      
                }
                if(veriofficepass===false)
                {          
                    iconMap.push({
                        name: 'Veri- Office',
                        value: 'action:close',
                        remarks: veriofficeremark
                    });
                    //$A.util.addClass(document.getElementById('Veri- Office'), 'orange-color');
                    $A.util.removeClass(document.getElementById('Veri- OfficedropdownDiv'), 'slds-hide');
                    
                }
                //document.getElementById("Veri- Officeremark").innerHTML = veriofficeremark;
                //end of Employment logic && banking check logic
                
                //logic for PAN check
                var pancheckFlag=false;
                var pancheckremark='';
                var SOLPolicyList=data.SOLPolicyList;
                for( var i in SOLPolicyList)
                {
                    if((SOLPolicyList[i].Policy_Name__c).toUpperCase() === ('Primary Pan Check Pass').toUpperCase())
                    {
                        pancheckFlag=true;
                    }
                  	if((SOLPolicyList[i].Policy_Name__c).toUpperCase().includes(('Primary Pan Check').toUpperCase()))
                    {
                        console.log('disposition pan'+SOLPolicyList[i].Disposition_Status__c);
                        
                        if(!$A.util.isEmpty(SOLPolicyList[i].Remarks__c))
                        	pancheckremark=SOLPolicyList[i].Remarks__c;
                        disValMap['PAN Check'] = SOLPolicyList[i].Disposition_Status__c;
                    }
                }
                if(pancheckFlag===true)
                {
                    iconMap.push({
                        name: 'PAN Check',
                        value: 'action:approval',
                        remarks: pancheckremark
                    });
                    //$A.util.addClass(document.getElementById('PAN Check'), 'green-color');
                }
                if(pancheckFlag===false)
                {
                    iconMap.push({
                        name: 'PAN Check',
                        value: 'action:close',
                        remarks: pancheckremark
                    });
                    //$A.util.addClass(document.getElementById('PAN Check'), 'orange-color');
                    $A.util.addClass(document.getElementById('PAN CheckdropdownDiv'), 'slds-hide');//24668
                    //component.find("PAN Checkdropdownval").set("v.value",SOLPolicyList[i].Disposition_Status__c);
                    
                    //$A.util.removeClass(document.getElementById('PAN Checkremark'), 'slds-hide');    
                }
                
                //document.getElementById("PAN Checkremark").innerHTML = pancheckremark;
                    //end of PAN check logic
                
                
                //logic for MCP SOLPolicy section
                var SOLPolicyList=data.SOLPolicyList;
                var pname;
                var expremark='',salremark='',dobremark ='';
                var expFlag=false,salFlag=false,dobFlag=false;
                for(var i in SOLPolicyList)
                {
                    pname=SOLPolicyList[i].Policy_Name__c;
                    if(pname.includes('Experience MCP Pass'))  //this is correct
                    {
                        expFlag=true;
                    }
                    if(pname.includes('Experience MCP')){
                        if(!$A.util.isEmpty(SOLPolicyList[i].Remarks__c))
                        	expremark = SOLPolicyList[i].Remarks__c;
                        disValMap['Experience MCP'] = SOLPolicyList[i].Disposition_Status__c;
                    }
                    if(pname.includes('Sal MCP Pass')) 
                    {
                        salFlag=true;
                    }
                    if(pname.includes('Sal MCP')) {
                        if(!$A.util.isEmpty(SOLPolicyList[i].Remarks__c))
							salremark = SOLPolicyList[i].Remarks__c;
                        disValMap['Sal MCP'] = SOLPolicyList[i].Disposition_Status__c;
                    }
                    if(pname.includes('DOB MCP Pass'))
                    {
                        dobFlag=true;
                    }
                    if(pname.includes('DOB MCP')){
                        if(!$A.util.isEmpty(SOLPolicyList[i].Remarks__c))
                        	dobremark = SOLPolicyList[i].Remarks__c;
                        console.log('dobmcp dis' +SOLPolicyList[i].Disposition_Status__c);
                        disValMap['DOB MCP'] = SOLPolicyList[i].Disposition_Status__c;
                    }
                }
                
                if(expFlag===true)
                {
                    iconMap.push({
                        name: 'Experience MCP',
                        value: 'action:approval',
                        remarks: expremark
                    });
                    //$A.util.addClass(document.getElementById('Experience MCP'), 'green-color');
                    //
                    $A.util.addClass(document.getElementById('Experience MCPdropdownDiv'), 'slds-hide');//24668
                }
                if(expFlag===false)
                {
                    iconMap.push({
                        name: 'Experience MCP',
                        value: 'action:close',
                        remarks: expremark
                    });
                    //$A.util.addClass(document.getElementById('Experience MCP'), 'orange-color');                    
                    $A.util.removeClass(document.getElementById('Experience MCPdropdownDiv'), 'slds-hide');
                    
                    
                }
                //document.getElementById("Experience MCPremark").innerHTML = expremark;
                 if(document.getElementById("Experience MCPremark")) //24668 added null check
                document.getElementById("Experience MCPremark").innerHTML = expremark;
                
                if(salFlag===true)
                {
                    iconMap.push({
                        name: 'Sal MCP',
                        value: 'action:approval',
                        remarks: salremark
                    });
                    //$A.util.addClass(document.getElementById('Sal MCP'), 'green-color');
                    $A.util.addClass(document.getElementById('Sal MCPdropdownDiv'), 'slds-hide');//24668
                }
                if(salFlag===false)
                {
                    iconMap.push({
                        name: 'Sal MCP',
                        value: 'action:close',
                        remarks: salremark
                    });
                    //$A.util.addClass(document.getElementById('Sal MCP'), 'orange-color');       
                    $A.util.removeClass(document.getElementById('Sal MCPdropdownDiv'), 'slds-hide');
                    
                    
                }
                //document.getElementById("Sal MCPremark").innerHTML = salremark;
                if(document.getElementById("Sal MCPremark")) //24668 added null check
                document.getElementById("Sal MCPremark").innerHTML = salremark; 
                if(dobFlag===true)
                {
                    iconMap.push({
                        name: 'DOB MCP',
                        value: 'action:approval',
                        remarks: dobremark
                    });
                    //$A.util.addClass(document.getElementById('DOB MCP'), 'green-color');
                }
                if(dobFlag===false)
                {
                    iconMap.push({
                        name: 'DOB MCP',
                        value: 'action:close',
                        remarks: dobremark
                    });
                    //$A.util.addClass(document.getElementById('DOB MCP'), 'orange-color');       
                    $A.util.removeClass(document.getElementById('DOB MCPdropdownDiv'), 'slds-hide');
                    
                    
                }
                //document.getElementById("DOB MCPremark").innerHTML = dobremark;
                if(expFlag===true && dobFlag===true && salFlag===true)
                {  
                    $A.util.addClass(component.find('mcpchecklabel'), 'green-color');       
                }
                if(expFlag!=true || dobFlag!=true || salFlag!=true)
                {
                    $A.util.addClass(component.find('mcpchecklabel'), 'orange-color');       
                }
                //end of Logic MCP SOLPolicy section
                
    
                //logic for EKYC section
                //added condition for bug id 21851 start
                if(component.get("v.hideAadhaarSection") == false){
                var ekycFlag=false;
                var primaryApplicant=data.applicantPrimary;
                if(primaryApplicant!=null)
                {
                    if(primaryApplicant.eKYC_Processing__c===true)
                    {
                        ekycFlag=true;
                    }
                }
                var ekycObject=data.ekycobj;
                if(ekycObject!=null)
                {
                    if(ekycObject.bio_Ekyc__c===true)
                    {
                        ekycFlag=true;
                        
                    }
                }
                
                if(ekycFlag===true)
                {
                    iconMap.push({
                        name: 'E KYC',
                        value: 'action:approval'
                    });
                    //$A.util.addClass(document.getElementById('E KYC'), 'green-color');
                    
                }
                if(ekycFlag===false)
                {
                    iconMap.push({
                        name: 'E KYC',
                        value: 'action:close'
                    });
                    //$A.util.addClass(document.getElementById('E KYC'), 'orange-color');
                    $A.util.removeClass(document.getElementById('E KYCdropdownDiv'), 'slds-hide');
                    document.getElementById("E KYCremark").innerText = "OTP  Confirmation Pending";
                    $A.util.removeClass(document.getElementById('E KYCremark'), 'slds-hide');
   
                }
            }//added for bug id 21851 end
                 
                //end of Ekyc Logic
                
              //Start- logic for Codified Cibil
             /*   if(primaryApplicant.Codified_CIBIL__c==='Positive')
                {
                    $A.util.addClass(document.getElementById('CIBIL'), 'green-color');	                    
                }
                if(primaryApplicant.Codified_CIBIL__c!='Positive')
                {
                    $A.util.addClass(document.getElementById('CIBIL'), 'orange-color');	
                    $A.util.removeClass(document.getElementById('CIBILdropdown'), 'slds-hide');
                    
                } */
                
                 //logic for CIBIL check
                var cibilcheckFlag=false;
                var SOLPolicyList=data.SOLPolicyList;
                var cibilcheckremark = '';
                for( var i in SOLPolicyList)
                {
                    if(SOLPolicyList[i].Policy_Name__c === 'CIBIL Check Pass')
                    {
                        cibilcheckFlag=true;
                    }
                    if(SOLPolicyList[i].Policy_Name__c.includes('CIBIL Check')){
                        if(!$A.util.isEmpty(SOLPolicyList[i].Remarks__c))
                        	cibilcheckremark = SOLPolicyList[i].Remarks__c;
                        disValMap['CIBIL'] = SOLPolicyList[i].Disposition_Status__c;
                    }
                }
                if(cibilcheckFlag===true)
                {
                    iconMap.push({
                        name: 'CIBIL',
                        value: 'action:approval',
                        remarks: cibilcheckremark
                    });
                    //$A.util.addClass(document.getElementById('CIBIL'), 'green-color');
                }
                if(cibilcheckFlag===false)
                {
                    iconMap.push({
                        name: 'CIBIL',
                        value: 'action:close',
                        remarks: cibilcheckremark
                    });
                    //$A.util.addClass(document.getElementById('CIBIL'), 'orange-color');
                    $A.util.removeClass(document.getElementById('CIBILdropdownDiv'), 'slds-hide');
                    
                }
                //document.getElementById("CIBILremark").innerText = cibilcheckremark;
                //end ofCIBIL  logic
                    
                
                
                //End logic of Codified Cibil
                
                var disVal = component.find("disVal");
                if($A.util.isArray(disVal)){
                    disVal.forEach(cmp => {
                        var nameDis = cmp.get("v.name");
                        console.log('nameDis'+nameDis+'val'+disValMap[nameDis]);
                        if(!$A.util.isEmpty(disValMap) && !$A.util.isEmpty(disValMap[nameDis]))
                        cmp.set("v.value",nameDis+';'+disValMap[nameDis]);
                    })
                }
                
                /*  below code is to check status through Verification object. hence, it is commented
          *  
          *   //logic for Verification Details section
                var i; 
                for( i in veriList)
                {
                    //for Office - 
                    if(veriList[i].Status__c ==='Positive' && veriList[i].Verification_Type__c.includes('Office'))
                    {
                         $A.util.addClass(document.getElementById('Veri -Office'), 'green-color');	
                    }
                    else
                    {
                         $A.util.addClass(document.getElementById('Veri -Office'), 'orange-color');	
                  $A.util.removeClass(document.getElementById('Veri -Officedropdown'), 'slds-hide');
                    }
                }
                    
                   for( i in veriList)
                {  
                    //for Bank
                    if(veriList[i].Status__c ==='Positive' && veriList[i].Verification_Type__c.includes('Bank'))
                    {
                          $A.util.addClass(document.getElementById('Veri- Banking'), 'green-color');	
                        
                    }
                    else
                    {
                         $A.util.addClass(document.getElementById('Veri- Banking'), 'orange-color');	
                  $A.util.removeClass(document.getElementById('Veri- Bankingdropdown'), 'slds-hide');
                    }
                }
                   
                   for( i in veriList)
                {  
                    //for permanent address
                    if(veriList[i].Status__c ==='Positive' && veriList[i].Verification_Type__c.includes('PERMANENT'))
                    {
                  $A.util.addClass(document.getElementById('Veri- Permanent'), 'green-color');	
                    }
                    else
                    {
                         $A.util.addClass(document.getElementById('Veri- Permanent'), 'orange-color');	
                  $A.util.removeClass(document.getElementById('Veri- Permanentdropdown'), 'slds-hide');
                    }
                }
                 
                for( i in veriList)
                {  

                    //for Current address
                    if(veriList[i].Status__c ==='Positive' && veriList[i].Verification_Type__c.includes('Residence'))
                    {
                    $A.util.addClass(document.getElementById('Veri- current'), 'green-color');	       
                    } 
                    else
                    {
                         $A.util.addClass(document.getElementById('Veri- current'), 'orange-color');	
                  $A.util.removeClass(document.getElementById('Veri- currentdropdown'), 'slds-hide');
                    }
                    
                }
   */
                
                
                //Company Category Logic
                component.set("v.Type_Of_Industry__c", accPickFlds["Type_Of_Industry__c"]); //contains full List
                component.set("v.accObj", data.accObj );
                console.log('data.accObj'+data.accObj);
                if(component.get("v.appType") == 'Primary'){//24668 added if for primary applicant
                var checkCompany=component.get("v.accObj.Type_Of_Industry__c"); // contains specific Type based on Oppid
                console.log('type of industry'+checkCompany);
               
                if(checkCompany === "Others" || typeof(checkCompany) == 'undefined' || checkCompany == null || checkCompany == 'Company not listed'){
                    iconMap.push({
                        name: 'Company Listing check',
                        value: 'action:close'
                    });
                    $A.util.removeClass(document.getElementById('Company Listing checkdropdown'), 'slds-hide');
                }
                
                else
                {
                    iconMap.push({
                        name: 'Company Listing check',
                        value: 'action:approval'
                    });
                   
                }
                }//24668 start
                else if(component.get("v.appType") == 'Financial Co-Applicant'){
                    var finAppComp = component.get("v.finAppl.Contact_Name__r.Employer__r.Company_Category__c");
                    console.log('employer '+finAppComp);
                    if(finAppComp === "Others" || typeof(finAppComp) == 'undefined' || finAppComp == null || finAppComp == 'Company not listed'){
                        iconMap.push({
                            name: 'Company Listing check',
                            value: 'action:close'
                        });
                        $A.util.removeClass(document.getElementById('Company Listing checkdropdown'), 'slds-hide');
                    }
                    
                    else
                    {
                        iconMap.push({
                            name: 'Company Listing check',
                            value: 'action:approval'
                        });
                       
                    }
                }//24668 stop
                console.log('LIST OF DEDUPE1'+data.dedupeList);
                if(!$A.util.isEmpty(data.dedupeList) && !$A.util.isEmpty(data.dedupeList[0]))
                {
                     console.log('LIST OF DEDUPE1'+data.dedupeList[0].Area_Status__c);
                    if(data.dedupeList[0].Area_Status__c== "Positive")
                    {
                        iconMap.push({
                            name: 'Negative Area',
                            value: 'action:approval'
                        });
                        //$A.util.addClass(document.getElementById('Negative Area'), 'green-color');
                        
                    }
                   else
                   {
                       iconMap.push({
                           name: 'Negative Area',
                           value: 'action:close'
                       });
                       //$A.util.addClass(document.getElementById('Negative Area'), 'orange-color');
                       $A.util.removeClass(document.getElementById('Negative AreadropdownDiv'), 'slds-hide');
                   }
                }
                else{
                    iconMap.push({
                           name: 'Negative Area',
                           value: 'action:close'
                       });
                       //$A.util.addClass(document.getElementById('Negative Area'), 'orange-color');
                       $A.util.removeClass(document.getElementById('Negative AreadropdownDiv'), 'slds-hide');
                }

                
                
            }
            else
            {
            }
            component.set("v.mapOfIcons",iconMap);
            
            this.showhidespinner(component,event,false);
        });
        
        

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
    displayToastMessage:function(component,event,title,message,type)
    {
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
       showhidespinner:function(component, event, showhide){
        console.log('in showhidespinner');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },//added for bug id 21851 start
    getHideAadhaarSectionHelper:function(component)
    {

        var action = component.get("c.getHideAadhaarSection");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log('hide aadhaaar>>>'+response.getReturnValue());
               		component.set('v.hideAadhaarSection',response.getReturnValue());    
            }         
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action); 
    }//added for bug id 21851 stop
})