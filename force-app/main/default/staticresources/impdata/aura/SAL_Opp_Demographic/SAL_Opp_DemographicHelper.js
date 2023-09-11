({
    areaCheck : false,
    pinChangeHelper : function(component) {
        component.set("v.areaSearchKeyword",'');
        component.set("v.areaList",null);
        self.areaCheck = false;
    },
        /*SAL 2.0 CR's s*/
    retriggerCIBIL:function(component, event) {
        this.showhidespinner(component,event,true);
        var action = component.get('c.retriggerCIBILOperation');
        action.setParams({
            "jsonOppRecord": JSON.stringify(component.get("v.oppObj")),
            "jsonConRecord": JSON.stringify(component.get("v.conObj")),
            "jsonAppRecord": JSON.stringify(component.get("v.priAppObj"))
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                this.showhidespinner(component,event,false); 
                component.set("v.cibilReinitiated",true);
                this.displayToastMessage(component,event,'Message','Retriggered CIBIL successfully.','success');
            }
            else if(state == 'ERROR')
            {   
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event,'Error','Error in CIBIL Retrigger','error');
            }
        });
        $A.enqueueAction(action);        
    },
    /*SAL 2.0 CR's e*/

    loadAllData : function(component, event, loanId) {
        var action = component.get('c.getOppDetails');
        action.setParams({
            loanApplicationId : loanId 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                var data = JSON.parse(response.getReturnValue());
                if (data !=null && data.objCon != null)
                    component.set('v.conObj',data.objCon);
                
                if (data !=null && data.accObj != null){
                    component.set('v.accObj',data.accObj);
                    if(!$A.util.isEmpty(data.accObj.Area_Locality__c)){
                        component.set("v.ValidAreaLocality",true);
                        component.set("v.areaSearchKeyword",data.accObj.Area_Locality__r.Name);
                    }
                }
                
                /*City CR s*/
                if(!$A.util.isEmpty(component.get('v.conObj.Residence_City__c'))){
                    component.set("v.validCity",true);
                    component.set("v.citySearchKeyword", component.get('v.conObj.Residence_City__c'));
                }
                /*City CR e*/
                if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.SOLPolicyList))
                {   
                    component.set("v.solPolicylist",data.SOLPolicyList);
                     var solPolicylist = component.get("v.solPolicylist");
                     for (var i = 0; i < solPolicylist.length; i++) {
                            if(!$A.util.isEmpty(solPolicylist[i].Name) && solPolicylist[i].Name == "Sales2.0 Address Change")
                            {
                                component.set("v.addresschangepolicy",solPolicylist[i]);
                                if(solPolicylist[i].copyAddressFrom__c == "AadhaarAddress")
                                   component.set("v.copyaadhaar",true);
                                if(solPolicylist[i].copyAddressFrom__c == "POAddress")
                                     component.set("v.copypo",true);
                                if(solPolicylist[i].copyAddressFrom__c == "NewAddress")
                                     component.set("v.copynewaddress",true);
                                console.log("pk solpolicy  "+solPolicylist[i].Id + solPolicylist[i].Name);
                                 break;
                            }
                           
                           
                        }
                }
                if (data !=null && data.ekycobj != null && !$A.util.isEmpty(data.ekycobj.eKYC_First_Name__c))
                {
                    component.set('v.disableAadhaar',false);
                    component.set('v.eKycObj',data.ekycobj);
                }
                
                if (data !=null && data.poobj != null) 
                {
                    component.set('v.disablePO',false);   
                    component.set('v.poObj',data.poobj);
                }
                
                /* logic of address divide*/
                /*var resiAdd = '';
                if(data !=null && data.objCon != null)
                {
                    if(!$A.util.isEmpty(data.objCon.Address_1__c)){
                        resiAdd += data.objCon.Address_1__c;
                    }
                    if(!$A.util.isEmpty(data.objCon.Address_2__c)){
                        resiAdd += data.objCon.Address_2__c;
                    }
                    if(!$A.util.isEmpty(data.objCon.Address_3__c)){
                        resiAdd += data.objCon.Address_3__c;
                    }
                }*/
                /*Bug 18914 Start*/
                component.find("resAdd").set("v.value", data.objCon.Address_1__c);
                component.find("resAdd2").set("v.value", data.objCon.Address_2__c);
                component.find("resAdd3").set("v.value", data.objCon.Address_3__c);
                component.set('v.newAddress',data.objCon.Address_1__c);
                component.set('v.newAddress2',data.objCon.Address_2__c);
                component.set('v.newAddress3',data.objCon.Address_3__c);
                /*Bug 18914 End*/
                component.set('v.newPin',data.objCon.Pin_Code__c);
                component.set('v.newCity',data.objCon.Residence_City__c);
                component.set('v.newState',data.objCon.State__c);
                
                /* end logic of address divide*/
            }
            else if(state == 'ERROR')
                console.log('Error while creating Contact Record!!');
        });
        $A.enqueueAction(action);
    },
    changePOaddress: function(component, event) {
        var productObj = component.get('v.poObj');
        var contactObj = component.get('v.conObj');
        if(productObj !=null)
        {
            component.set("v.disableText",true);
            component.set("v.disablePin",true);
            /* logic of address divide*/
            var resiAdd = '';
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_1__c'))){
                resiAdd += component.get('v.poObj.Address_Line_1__c');
            }
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_2__c'))){
                resiAdd += component.get('v.poObj.Address_Line_2__c');
            }
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_3__c'))){
                resiAdd += component.get('v.poObj.Address_Line_3__c');
            }
             if($A.util.isEmpty(resiAdd))
             {
                if(!$A.util.isEmpty(component.get('v.poObj.Lead__r.Residence_Address_Line1__c'))){
                resiAdd += component.get('v.poObj.Lead__r.Residence_Address_Line1__c');
            }
            if(!$A.util.isEmpty(component.get('v.poObj.Lead__r.Residence_Address_Line2__c'))){
                resiAdd += component.get('v.poObj.Lead__r.Residence_Address_Line2__c');
            }
            if(!$A.util.isEmpty(component.get('v.poObj.Lead__r.Residence_Address_Line3__c'))){
                resiAdd += component.get('v.poObj.Lead__r.Residence_Address_Line3__c');
            } 
             }
            //component.find("resAdd").set("v.value", resiAdd);
            /* end logic of address divide*/
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_1__c')))
                component.find("resAdd").set("v.value", component.get('v.poObj.Address_Line_1__c'));//Bug 18914
            else
                component.find("resAdd").set("v.value", component.get('v.poObj.Lead__r.Residence_Address_Line1__c'));
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_2__c')))
           		 component.find("resAdd2").set("v.value", component.get('v.poObj.Address_Line_2__c'));//Bug 18914
            else
                component.find("resAdd2").set("v.value", component.get('v.poObj.Lead__r.Residence_Address_Line2__c'));
            if(!$A.util.isEmpty(component.get('v.poObj.Address_Line_3__c')))
           		 component.find("resAdd3").set("v.value", component.get('v.poObj.Address_Line_3__c'));//Bug 18914
            else
                component.find("resAdd3").set("v.value", component.get('v.poObj.Lead__r.Residence_Address_Line3__c'));
            if(!$A.util.isEmpty(component.get('v.poObj.Pin_Code__c')))
           		 component.set('v.conObj.Pin_Code__c',component.get('v.poObj.Pin_Code__c'));
            else
                 component.set('v.conObj.Pin_Code__c',component.get('v.poObj.Lead__r.Resi_Pin_Code__c'));
            if(!$A.util.isEmpty(component.get('v.poObj.Resi_City__c'))){
				component.set('v.conObj.Residence_City__c',component.get('v.poObj.Resi_City__c'));
                /*City CR s*/
                component.set("v.citySearchKeyword", component.get('v.poObj.Resi_City__c'));
                component.set("v.validCity",true);    
                this.openCloseSearchResults(component, 'city', false);
                /*City CR e*/
            }
            else{
                component.set('v.conObj.Residence_City__c',component.get('v.poObj.Lead__r.Resi_City__c'));
            	/*City CR s*/
                component.set("v.citySearchKeyword", component.get('v.poObj.Lead__r.Resi_City__c'));
                component.set("v.validCity",true);    
                this.openCloseSearchResults(component, 'city', false);
                /*City CR e*/
            }
            if(!$A.util.isEmpty(component.get('v.poObj.Resi_City__c')))
				component.set('v.conObj.State__c',component.get('v.poObj.Resi_State__c'));  
            else
                component.set('v.conObj.State__c',component.get('v.poObj.Lead__r.Resi_State__c'));
        }
    },
    changeAadhaaraddress: function(component, event) {
        var eKycObj = component.get('v.eKycObj');
        var contactObj = component.get('v.conObj');
        if(eKycObj !=null)
        {
            component.set("v.disableText",true);
            component.set("v.disablePin",false);
            component.set('v.conObj.Pin_Code__c',component.get('v.eKycObj.eKYC_Pin_Code__c'));
            console.log('robin '+component.get('v.conObj.Pin_Code__c'));
            var permanentAddress = '';
            //Rohit added for ekyc mapping Start
            if(component.get('v.eKycObj.eKYC_Address_details__c') != null && component.get('v.eKycObj.eKYC_Address_details__c') != undefined){
                permanentAddress = component.get('v.eKycObj.eKYC_Address_details__c');
            }    
            if(component.get('v.eKycObj.Location__c') != null && component.get('v.eKycObj.Location__c') != undefined){
                permanentAddress += ' '+component.get('v.eKycObj.Location__c');
            }   
            if(component.get('v.eKycObj.House__c') != null && component.get('v.eKycObj.House__c') != undefined){
                permanentAddress += ' '+component.get('v.eKycObj.House__c');
            }
            //Rohit added for ekyc mapping Stop    
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
            }
                if(result[0])
                      component.find("resAdd").set("v.value",result[0]);
                
                if(result[1])
                     component.find("resAdd2").set("v.value",result[1]);
                else
                    component.find("resAdd2").set("v.value", component.get('v.eKycObj.eKYC_City__c'));
                
                if(result[2])
                    component.find("resAdd3").set("v.value",result[2]);
                else
                   component.find("resAdd3").set("v.value", component.get('v.eKycObj.eKYC_Pin_Code__c'));
           /* component.find("resAdd").set("v.value", permanentAddress);
            component.find("resAdd2").set("v.value", component.get('v.eKycObj.eKYC_City__c'));//Bug 18914
            component.find("resAdd3").set("v.value", component.get('v.eKycObj.eKYC_Pin_Code__c'));//Bug 18914*/
            
            component.set('v.conObj.Residence_City__c',component.get('v.eKycObj.eKYC_City__c'));
            /*City CR s*/
            component.set("v.citySearchKeyword", component.get('v.eKycObj.eKYC_City__c'));
            component.set("v.validCity",true);    
            this.openCloseSearchResults(component, 'city', false);
            /*City CR e*/
			component.set('v.conObj.State__c',component.get('v.eKycObj.eKYC_State__c'));  
            console.log('res add '+component.find('resAdd').get("v.value"));
            /* if (permanentAddress) {
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
                
                if(result[0])
                    component.set('v.conObj.Permanant_Address_Line_1__c',result[0]);
                else
                    component.set('v.conObj.Permanant_Address_Line_1__c','');
                
                if(result[1])
                    component.set('v.conObj.Permanant_Address_Line_2__c',result[1]);
                else
                    component.set('v.conObj.Permanant_Address_Line_2__c','');
                
                if(result[2])
                    component.set('v.conObj.Permanant_Address_Line_3__c',result[2]);
                else
                    component.set('v.conObj.Permanant_Address_Line_1__c','');
            }*/
        }
        console.log('disable area'+component.get("v.disablePin"));
    },
    changeNewaddress: function(component, event) {
        var contactObj = component.get('v.conObj');
        if(contactObj != null)
        {
            component.set("v.disableText",false);
            component.set("v.disablePin",false);
            if(component.get("v.isUnderwitercmp")){
                component.find("resAdd").set("v.value", component.get('v.newAddress'));//Bug 18914
                component.find("resAdd2").set("v.value", component.get('v.newAddress2'));//Bug 18914
                component.find("resAdd3").set("v.value", component.get('v.newAddress3'));//Bug 18914
                component.find("resPin").set("v.value",component.get('v.newPin'));
                component.find("resState").set("v.value",component.get('v.newState'));
                //component.find("resCity").set("v.value",component.get('v.newCity'));
                
                /*City CR s*/
                var conObj = component.get("v.conObj");
                conObj.Residence_City__c = component.get('v.newCity');
                component.set("v.conObj",conObj);
                component.set("v.citySearchKeyword", component.get('v.newCity'));
                component.set("v.validCity",true);    
                this.openCloseSearchResults(component, 'city', false);
                /*City CR e*/
            }else{
                component.set('v.conObj.Address_1__c','');
            component.set('v.conObj.Address_2__c','');//Bug 18914
            component.set('v.conObj.Address_3__c','');//Bug 18914
            component.find("resAdd").set("v.value", '');//Bug 18914
            component.find("resAdd2").set("v.value", '');//Bug 18914
            component.find("resAdd3").set("v.value", '');//Bug 18914
            component.find("resPin").set("v.value",'');
            component.find("resState").set("v.value",'');
             //23578 start
            component.find("resAdd").set("v.disabled",false);
            component.find("resAdd2").set("v.disabled",false);    
            component.find("resAdd3").set("v.disabled",false);
            //23578 stop   
            //component.find("resCity").set("v.value",'');
            /*City CR s*/
            var conObj = component.get("v.conObj");
            conObj.Residence_City__c = '';
            component.set("v.conObj",conObj);
            component.set("v.citySearchKeyword", '');
            component.set("v.validCity",false);    
            this.openCloseSearchResults(component, 'city', false);
            /*City CR e*/
            component.find("areaLoc").set("v.value",'');
            }
            /*component.set('v.conObj.Address_1__c',component.get('v.conObj.Address_1__c'));
            component.set('v.conObj.Address_2__c',component.get('v.conObj.Address_2__c'));//Bug 18914
            component.set('v.conObj.Address_3__c',component.get('v.conObj.Address_3__c'));//Bug 18914
            //component.set('v.conObj.Pin_Code__c',component.get('v.conObj.Pin_Code__c'));//Commented this line for Bug 18914
            component.find("resAdd").set("v.value", component.get('v.newAddress'));//Bug 18914
            component.find("resAdd2").set("v.value", component.get('v.newAddress2'));//Bug 18914
            component.find("resAdd3").set("v.value", component.get('v.newAddress3'));//Bug 18914
            component.find("resPin").set("v.value",component.get('v.newPin'));
            component.find("resState").set("v.value",component.get('v.newState'));
            component.find("resCity").set("v.value",component.get('v.newCity'));*/
            
            //Rohit added for setting address start
            /*var permanentAddress = ''+component.get('v.conObj.Permanant_Address_Line_1__c')+component.get('v.conObj.Permanant_Address_Line_2__c')+component.get('v.conObj.Permanant_Address_Line_3__c');
            console.log('robin con '+permanentAddress);
            component.find("resAdd").set("v.value", permanentAddress);*/
            //Rohit added for setting address stop  
        }
    },
    callPANBre : function(component, event) {
        console.log('in final offer bre'+component.get("v.account"));
        console.log(JSON.stringify(component.get("v.priAppObj")));
        this.showhidespinner(component,event,true);
        this.executeApex(component, "callPANBreOnDemographic", {
            'oppObj': JSON.stringify(component.get("v.oppObj")),
            'accObj': JSON.stringify(component.get("v.accObj")),
            'conObj': JSON.stringify(component.get("v.conObj")),
            'appObj': JSON.stringify(component.get("v.priAppObj")),
            'loanId': component.get("v.oppId")
        }, function (error, result) {
            console.log('result test: ' + result);
            if (!error && result) {
                console.log('result -->'+result);
                
                var objlst = JSON.parse(result);
                console.log('objlistr -->'+JSON.stringify(objlst));
                
                if(!$A.util.isEmpty(objlst))
                {
                    if(!$A.util.isEmpty(objlst.status))
                    {
                        if(objlst.status == 'PANBRE Done' || objlst.status == 'Success' )
                        {
                            this.showhidespinner(component,event,false);
                            //this.displayToastMessage(component,event,'Success','PAN Check has already been done','success'); 
                        }
                        else{
                            this.showhidespinner(component,event,false);
                            console.log('hv + '+objlst.status);
                            if(objlst.status.includes('CIBIL And Dedupe response are not recived yet'))
                            {
                               this.displayToastMessage(component,event,'Pending',objlst.status,'error'); 
                            }
                            else
                            {
                               this.displayToastMessage(component,event,'Error',objlst.status,'error'); 
                            }
                            if(!$A.util.isEmpty(objlst.applicantPrimary))
                            {
                                component.set("v.priAppObj" , objlst.applicantPrimary);
                            }
                        }
                    }
                    
                    
                }
                
                
                
            }
            else{
                this.showhidespinner(component,event,false);
            }
        });
        
    },
    saveContactDetails : function(component, event) {
        var createContact = component.get('v.conObj'); 
        var newAcc = component.get('v.accObj'); 
        
        var isInValidMsg = true;
         var addresschangepolicy = component.get("v.addresschangepolicy");
        if($A.util.isEmpty(component.get("v.addresschangepolicy").Id))//prod adhoc
        {
           addresschangepolicy.Name = 'Sales2.0 Address Change';
           addresschangepolicy.Policy_Name__c = 'Address Change';
           addresschangepolicy.Loan_Application__c = component.get("v.oppId");
           addresschangepolicy.Applicant_Name__c = component.get("v.priAppObj").Id;
           addresschangepolicy.copyAddressFrom__c =  component.get("v.AddressFrom");//prod adhoc
           component.set("v.addresschangepolicy",addresschangepolicy);//prod adhoc

        }
        /*var result =[];
        result = this.splitAddress(component,event,"resAdd");
        if(!$A.util.isEmpty(result))
        {
            if(result[0])
                createContact.Address_1__c = result[0];
            else
                createContact.Address_1__c ='';
            if(result[1])
                createContact.Address_2__c =result[1];
            else
                createContact.Address_2__c='';
            if(result[2])
                createContact.Address_3__c =result[2];
            else
                createContact.Address_3__c='';
        }*/
        console.log('add 1: '+createContact.Address_1__c);
        console.log('CCity : '+createContact.Residence_City__c);
        console.log('CState : '+createContact.State__c);
        newAcc.Current_Residence_Address1__c = createContact.Address_1__c;
        newAcc.Current_Residence_Address2__c = createContact.Address_2__c;
        newAcc.Current_Residence_Address3__c = createContact.Address_3__c;
        newAcc.PinCode__c = createContact.Pin_Code__c;//Bug 18914
        newAcc.Current_City__c = createContact.Residence_City__c;//Bug 18914
        newAcc.Current_State__c = createContact.State__c;//Bug 18914
        component.set("v.accObj",newAcc);
        /* var currentAddress1 = component.find("currentAddress1");
        if(currentAddress1.get("v.validity").valid)
            console.log('currentAddress1'+isInValidMsg);
        else{
            currentAddress1.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var currentAddress2 = component.find("currentAddress2");
        if(currentAddress2.get("v.validity").valid)
            console.log('currentAddress2'+isInValidMsg);
        else{
            currentAddress2.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var currentAddress3 = component.find("currentAddress3");
        if(currentAddress3.get("v.validity").valid)
            console.log('currentAddress3'+isInValidMsg);
        else{
            currentAddress3.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }
        
        var currentPincode = component.find("currentPincode");
        if(currentPincode.get("v.validity").valid)
            console.log('currentPincode'+isInValidMsg);
        else{
            currentPincode.showHelpMessageIfInvalid();
            isInValidMsg = false;
        }*/
        
        var action = component.get('c.saveContactRecord');
        action.setParams({
            "jsonContactRecord": JSON.stringify(component.get("v.conObj")),
            "jsonAccountRecord": JSON.stringify(component.get("v.accObj")),
            "loanApplicationId": component.get("v.oppId"),
            "jsonpaddresspolicy": JSON.stringify(component.get("v.addresschangepolicy"))
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                 // user story 978 start
                 if(component.get("v.stageName") == 'DSA/PSF Login' && component.get("v.isUnderwitercmp") == false)
                 {
                var updateidentifier =  $A.get("e.c:Update_identifier");
                updateidentifier.setParams({
                    "eventName": 'Demographics Details',
                    "oppId":component.get("v.oppId")
                });
                updateidentifier.fire();
                 }
                // user story 978 end
                var data = JSON.parse(response.getReturnValue());
                if(data.status == 'City Fail'){
                    this.showhidespinner(component,event,false); 
                	this.displayToastMessage(component,event,'Error','Unable to save details. City/State mapping not available for pincode.','error');
                }
                else{
                    
                    //console.log('city'+data.objCon.Residence_City__c);
                    if (data !=null && data.objCon != null) 
                        component.set('v.conObj',data.objCon);
                    
                    if (data !=null && data.accObj != null){
                        component.set('v.accObj',data.accObj);
                        
                    }
                    
                    if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.SOLPolicyList))
                    { 
                        component.set("v.solPolicylist",data.SOLPolicyList)
                        var solpolicylist = component.get("v.solPolicylist");
                        for (var i = 0; i < solpolicylist.length; i++) {
                            console.log("pk solpolicy"+solpolicylist[i]);
                            if(!$A.util.isEmpty(solpolicylist[i].Name) && solpolicylist[i].Name == 'Sales2.0 Address Change')
                            {
                                component.set("v.addresschangepolicy",solpolicylist[i]);
                                if(solpolicylist[i].copyAddressFrom__c == "AadhaarAddress")
                                    component.set("v.copyaadhaar",true);
                                if(solpolicylist[i].copyAddressFrom__c == "POAddress")
                                    component.set("v.copypo",true);
                                if(solpolicylist[i].copyAddressFrom__c == "NewAddress")
                                    component.set("v.copynewaddress",true);
                            }
                            break;
                        }
                    }  
                    console.log('area loca'+data.accObj.Area_Locality__c);
                    var varpincode = component.get("v.conObj.Pin_Code__c");
                    var vararea =  component.get("v.areaSearchKeyword");
                    console.log('inside fire'+vararea);
                    var appEvent = $A.get("e.c:setPincode");
                    if(appEvent){
                        appEvent.setParams({ "pincode" : varpincode,"arealocality" : vararea});
                        appEvent.fire();
                    } 
                    var appEventcon = $A.get("e.c:UpdateConAcc");//prod issue 23466
                    if(appEventcon){
                        appEventcon.setParams({ "accObj" : component.get('v.accObj'),"conObj" : component.get('v.conObj')});
                        appEventcon.fire();
                    } 
                    
                    this.showhidespinner(component,event,false); 
                    this.displayToastMessage(component,event,'Success','Details saved successfully.','success');
                }
            }
            //component.set('v.conObj.Permanant_Address_Line_1__c',response.getReturnValue());
            else if(state == 'ERROR')
            {
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event,'Error','Unable to Save details.','error');
            }
        });
        /*if(!component.get("v.ValidAreaLocality")){
            this.displayToastMessage(component,event,'Error','Please select valid Area/Locality','error');   
            this.showhidespinner(component,event,false);  
        }
        else */if(isInValidMsg == true)
        {
            this.showhidespinner(component,event,true); 
            $A.enqueueAction(action);
        }
    },
    reTriggerDedupeHelper:function(component, event) {
        console.log("Hrushi Id"+component.get("v.oppId"));
        var action = component.get('c.retriggerDedupeMethod');
        action.setParams({
            "oppId": component.get("v.oppId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event,'Message','Retrigger Dedupe successfully.','success');
            }
            else if(state == 'ERROR')
            {   
                this.showhidespinner(component,event,false); 
                this.displayToastMessage(component,event,'Error','Error with Retrigger','error');
            }
        });
        $A.enqueueAction(action);        
    },
    splitAddress: function (component,event,key) {
        var totalAddress = component.find(key).get("v.value");
        var result = [];
        if (totalAddress) {
            var line = [];
            var length = 0;
            totalAddress.split(" ").forEach(function(word) {
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
        }
        return result;
        
        
    },
    showhidespinner:function(component, event, showhide){
        console.log('inside showhide');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
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
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state'+state);
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                //this.showToast(component, "Error!", errors.join(", "), "error");
                callback.call(this, errors, response.getReturnValue());
            }
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
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        //var keyword = component.get("v.AreaSearchKeyword");
        
        if(key == 'area')
        {  
            console.log('outside area'+component.find("resPin").get("v.value")+component.get('v.areasearching'));
         if(!$A.util.isEmpty(component.find("resPin").get("v.value"))){
             if (keyword.length > 2 && !component.get('v.areasearching')) {
                 console.log('inside area');
                 component.set('v.areasearching', true);
                 component.set('v.oldAreaKeyword', keyword);
                 console.log('keyword -->'+component.get('v.oldAreaKeyword'));
                 this.searchHelperArea(component, key, keyword);
             }
             else if (keyword.length <= 2) {
                 console.log("keyword" + keyword+"key"+key);
                 component.set("v." + key + "List", null);
                 this.openCloseSearchResults(component, key, false);
             }
         }
            else{
                if(!self.areaCheck){
                    this.displayToastMessage(component,event,'Error','Please enter pin code','error');  
                    self.areaCheck = true;
                }
            }
                   
        }
    },
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    searchHelper: function (component, key, keyword) {
        console.log('executeApex>>' + keyword + '>>key>>' + key);
        
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord': keyword
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
            }
        });
    },
    searchHelperArea: function (component, key, keyword) {
        var pincode = component.find("resPin").get("v.value");
        console.log('executeApex>>' + keyword + '>>key>>' + key +'>>pincode'+pincode);
        
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord':keyword,
            'pincode':pincode.toString()
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                this.handleSearchResult(component, key, result);
            }
            else if(key == 'area')
        {
            component.set('v.areasearching', false);
        }
        });
    },
    handleSearchResult: function (component, key, result) {
        console.log('key :  handleSearchResult' + key);
        console.log(result);
        console.log('v.oldSearchKeyword :' + component.get('v.oldSearchKeyword') + '  -> SearchKeyword : ' + component.get("v." + key + "SearchKeyword"));
        
        console.log('inside handleserach'+component.get('v.oldSearchKeyword')+component.get("v." + key + "SearchKeyword"));
        if(key == 'Employer')
        {
            component.set('v.empsearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
        if(key == 'area')
        {
            component.set('v.areasearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldAreaKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
    },
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    //added for bug id 21851 start
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