({
    doInit: function(component, event, helper) {
        //console.log('appNew'+component.get("v.accObj").Id);
        //console.log('appNew'+component.get("v.oppObj").Id);
        //added for bug id 21851 start
        helper.getHideAadhaarSectionHelper(component);
		 //23578 start
        if(!component.get("v.appId")){
            var con = new Object();
            con.attributes = {"type":"Contact"};
            var app = new Object();
            app.attributes = {"type":"Applicant__c"};
            component.set("v.conNew",con);
            component.set("v.appNew",app);
        }else{
            //component.find("skipckyc").set("v.disabled",true);
            //document.getElementById("otherSection").style.display = 'block';
        }
        
        
        //23578 stop
        //added for 21851 end
        helper.getAppData(component,event);
    },
PANCheck :function(component, event, helper){
   
        
        helper.showhidespinner(component,event,true);
    //alert(component.get("v.conNew.Id"));
        //var recAppId = event.currentTarget.value;
        helper.PANCheckhelper(component,event);
        
    },
    onPicklistChange: function(component, event, helper) {
        var createContact = component.get('v.conNew');
        if($A.util.isEmpty(createContact) || $A.util.isEmpty(createContact.Residence_Type__c) || createContact.Residence_Type__c == 'Owned by Self/Spouse' 
           || createContact.Residence_Type__c == 'Owned by Parent/Sibling')
            component.set('v.isRented',false);
        else      
            component.set('v.isRented',true);
    },
    toggletab : function(component, event, helper) {
        console.log('hi'+event.target.id);
        helper.toggleAccordion(component,event);
    },
    empKeyPressController: function (component, event, helper) {
        component.set("v.empFlag",false);
        helper.startSearch(component, 'Employer');
    },
    goBack: function (component, event, helper){
		component.destroy();
        var appEvent = $A.get("e.c:updateCoappList");
        if(appEvent){
            appEvent.fire();
        }        
    },
    saveCoApp: function (component, event, helper){
        helper.showhidespinner(component,event,true);
        helper.saveCoApp(component, event, false);
    },
    saveCoAppPar: function (component, event, helper){
        helper.showhidespinner(component,event,true);
        helper.saveCoApp(component, event, true);
    },
    updateMar: function(component, event, helper){
        var relation = component.find("relation").get("v.value");
        var conObj = component.get("v.conNew");
        if(relation == 'Spouse'){
            conObj.Marital_Status__c = 'Married';
        }
        else{
            conObj.Marital_Status__c = '';
        }
        component.set("v.conNew",conObj);
    },
    copyResiAdd : function (component, event, helper){
    	var isCopy = component.find("copyAdd").get("v.checked");
        if(isCopy){
            var conNew= component.get("v.conNew");
            var perAdd = '';
            if(!$A.util.isEmpty(conNew.Address_1__c))
            	conNew.Permanant_Address_Line_1__c = conNew.Address_1__c;
            if(!$A.util.isEmpty(conNew.Address_2__c))
            	conNew.Permanant_Address_Line_2__c = conNew.Address_2__c;
            if(!$A.util.isEmpty(conNew.Address_3__c))
            	conNew.Permanant_Address_Line_3__c = conNew.Address_3__c;
            //component.find("perResAdd").set("v.value",perAdd);
            component.set("v.conNew.Permanent_Pin_Code__c",component.get("v.conNew.Pin_Code__c"));
            /*City CR s*/
            if(!$A.util.isEmpty(component.get("v.accObj.Current_City__c"))){
                conNew.Permanent_State__c = component.get("v.conNew.State__c");
                conNew.Permanant_City__c = component.get("v.conNew.Residence_City__c");
                component.set("v.percitySearchKeyword", conNew.Residence_City__c);
                component.set("v.validpercity",true); 
            }
            /*City CR e*/
        }
        else{
            
            component.find("perResAdd").set("v.value",'');
            component.set("v.conNew.Permanent_Pin_Code__c",0);
            /*City CR s*/
            var conNew= component.get("v.conNew");
            conNew.Permanent_State__c = '';
            conNew.Permanant_City__c = '';
            component.set("v.percitySearchKeyword", '');
            component.set("v.validpercity",false); 
            /*City CR e*/
        }
        component.set("v.conNew",conNew);
	},
    copyPrimAdd : function (component, event, helper){
        var isCopy = component.find("copyPriAdd").get("v.checked");
        var conNew = component.get("v.conNew");
        if(isCopy){
            var resiAdd = ''
            var priApp = component.get("v.primApp");
            console.log('test'+priApp);
            if(!$A.util.isEmpty(priApp.Contact_Name__c) && !$A.util.isEmpty(priApp.Contact_Name__r.Address_1__c)){
                conNew.Address_1__c = priApp.Contact_Name__r.Address_1__c;
            }
            if(!$A.util.isEmpty(priApp.Contact_Name__c) && !$A.util.isEmpty(priApp.Contact_Name__r.Address_2__c)){
                conNew.Address_2__c = priApp.Contact_Name__r.Address_2__c;
            }
            if(!$A.util.isEmpty(priApp.Contact_Name__c) && !$A.util.isEmpty(priApp.Contact_Name__r.Address_3__c)){
                conNew.Address_3__c = priApp.Contact_Name__r.Address_3__c;
            }
            //component.find("resAdd").set("v.value", resiAdd);
            
            component.set("v.conNew.Pin_Code__c",priApp.Contact_Name__r.Pin_Code__c);
            /*City CR s*/
            if(!$A.util.isEmpty(priApp.Contact_Name__r.Residence_City__c)){
                console.log('priApp.Residence_City__c'+priApp.Contact_Name__r.State__c);
                conNew.Residence_City__c = priApp.Contact_Name__r.Residence_City__c;
                conNew.State__c = priApp.Contact_Name__r.State__c;
                component.set("v.resicitySearchKeyword", priApp.Contact_Name__r.Residence_City__c);
                component.set("v.validresicity",true); 
            }
            /*City CR e*/
        }
        else{
            conNew.Address_1__c = '';
            conNew.Address_2__c = '';
            conNew.Address_3__c = '';
            //component.find("resAdd").set("v.value",'');
            component.set("v.conNew.Pin_Code__c",0);
            /*City CR s*/
            conNew.Residence_City__c ='';
            conNew.State__c = '';
            component.set("v.resicitySearchKeyword", '');
            component.set("v.validresicity",false); 
            /*City CR e*/
        }
        component.set("v.conNew",conNew);
    },
    selectEmployer: function (component, event, helper) {
        var index = event.currentTarget.dataset.record;
        var selectedEmployer = component.get("v.EmployerList")[index];
        console.log(selectedEmployer);
        var keyword = selectedEmployer.Name;
        console.log('keyword>>' + keyword);
        component.set("v.selectedEmployer", selectedEmployer);
        component.set("v.EmployerSearchKeyword", keyword);
        if(keyword != undefined && (keyword.toLowerCase() == 'others' || keyword.toLowerCase() == 'other' || keyword.toLowerCase() == 'company not listed')){                
              component.set("v.isOther",true);
        }
        else{
              component.set("v.isOther",false);
         }
        component.set("v.conNew.Employer__c", selectedEmployer.Id);
        component.set("v.conNew.Company_Category__c", selectedEmployer.Company_Category__c);
        helper.openCloseSearchResults(component, "Employer", false);
        component.find("employer").set("v.errors", [{
            message: ""
        }
                                                   ]);
    },
    initiateKYCForm: function (component, event) {
        component.set("v.kyc", event.getParam("kyc"));
    },
    destroyAddCo: function(component, event){
        component.destroy();
        var appEvent = $A.get("e.c:updateCoappList");
        if(appEvent){
            console.log('inside add child');
            appEvent.fire();
        }
    },
    /*City CR s*/
    cityKeyPressController: function (component, event, helper) {
        var cityType = event.getSource().getLocalId();
        console.log('city type is'+cityType);
    	component.set("v.valid"+cityType,false);  
        var finalCity = [];
        var cityList = component.get("v.cityList");
        var keyword = component.get("v."+cityType+"SearchKeyword");
        if (keyword.length > 2){
            for(var i in cityList){
                if(cityList[i].city.toUpperCase().startsWith(keyword.toUpperCase()))
                    finalCity.push(cityList[i]);
            }  
            helper.openCloseSearchResults(component, cityType, true); 
        }
        else if (keyword.length <= 2) {
        	helper.openCloseSearchResults(component, cityType, false);    
        }
        console.log('citylist'+finalCity.length);
        component.set("v.final"+cityType,finalCity);
    },
    selectCity: function (component, event, helper) {
        var cityType = event.target.id;
        console.log('city type is'+cityType);
    	component.set("v.valid"+cityType,true);
        var index = event.currentTarget.dataset.record;
        var selectedCity = component.get("v.final"+cityType)[index];
        var keyword = selectedCity.city;
        console.log('keyword>>' + keyword);
        component.set("v."+cityType+"SearchKeyword", keyword);
        var conNew = component.get("v.conNew");
        if(cityType == 'resicity'){
        	conNew.Residence_City__c = selectedCity.city;
            conNew.State__c = selectedCity.state;
        }
        else if(cityType == 'ofccity'){
            conNew.Office_City__c = selectedCity.city;
            conNew.Office_State__c = selectedCity.state;
        }
        else if(cityType == 'percity'){
         	conNew.Permanent_State__c = selectedCity.state;
            conNew.Permanant_City__c = selectedCity.city;   
        }
        
        component.set("v.conNew",conNew);
        helper.openCloseSearchResults(component, cityType, false);    
    },
    /*City CR e*/
	
	 //23578 start
    copyDetails : function(component, event, helper){
          var firstName = '';
          var lastName = '';
         var getWhichBtn = event.getSource().get("v.label");
         console.log(getWhichBtn);
        if(getWhichBtn != null && getWhichBtn == 'Copy PAN Details'){
            component.set("v.isEditCkyc",false);
            component.find("CkycEditBtnCo").set("v.disabled",true);
            var contact = Object.assign({}, component.get("v.conNew"));//deep cloning of objects to retain contact
            contact.FirstName = component.get("v.panFname");
            contact.LastName = component.get("v.panLname");
            component.set("v.dataSource","Copy Pan Data");            
            component.set("v.conNew",contact);
                    
        }
        else if(getWhichBtn == 'Copy CKYC Details'){
            component.find("CkycEditBtnCo").set("v.disabled",false);//23578
             console.log(component.get("v.Ckyccontact.LastName"));
            console.log(component.get("v.conNew.LastName"));
             var contact = Object.assign({}, component.get("v.Ckyccontact"));//deep cloning of objects to retain Ckycaccount
             component.set("v.conNew",contact);
             component.set("v.appNew",component.get("v.Ckycapplicant"));
             component.set("v.dataSource","Copy CKYC Data");
             helper.changeCKYCfields(component,false);
        }
        else if(getWhichBtn == 'Edit CKYC Details'){
             //component.set("v.conNew",component.get("v.Ckyccontact"));
             //component.set("v.appNew",component.get("v.Ckycapplicant"));
            if(component.find("CkycEditBtnCo") && component.find("CkycEditBtnCo").get("v.checked") === true){
                component.set("v.dataSource","Edit CKYC Data");
             	helper.changeCKYCfields(component,true);               
            }
            else{
                component.set("v.dataSource","Copy CKYC Data");
                var contact = Object.assign({}, component.get("v.conNew"));//deep cloning of objects to retain contact
                component.set("v.conNew",contact);
                component.set("v.appNew", Object.assign({}, component.get("v.appNew")));
                helper.changeCKYCfields(component,false);
            }
            
        }
        
         
    },
    setCkyc : function(component, event, helper){
        component.find("coAppType").set("v.disabled",false);
        helper.setCkycFields(component, event);
    },
    skipckyc : function(component, event, helper){
        document.getElementById("otherSection").style.display = 'block';
        helper.showHideSubSection(component,"subicon5","subsection5Content");
        helper.showHideSubSection(component,"subicon2","subsection2Content");
        component.find("skipckyc").set("v.disabled",true);
    },
    //23578 stop
    // 24668 start
    doEPFOCheck : function(component,event,helper){
        helper.doEPFO(component,event);
    },
   
    submitOTP : function(component, event, helper) {
         if (component.find("otpvalue") && $A.util.isEmpty(component.find("otpvalue").get("v.value")))
            {
                component.find("otpvalue").showHelpMessageIfInvalid();
                helper.displayToastMessage(component,event,'Error','Please enter correct OTP','error');
            }
        else{
             helper.showhidespinner(component,event,true);
		     helper.officeemailverify(component, event);
        }
       
	},
    doEmploymentCheck: function(component, event, helper){
        if(!$A.util.isEmpty(component.find('offEmail').get("v.value")))
        {
            helper.doEmpCheck(component);
        }

        else{
            helper.displayToastMessage(component,event,'Error','Please Enter Office Email ID','error');
        }
    },
    // 24668 stop
})