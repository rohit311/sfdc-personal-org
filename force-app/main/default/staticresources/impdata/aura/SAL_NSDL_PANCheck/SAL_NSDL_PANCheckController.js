({
     doEmploymentCheck: function(component, event, helper){
        if(!$A.util.isEmpty(component.find('officialEmailId').get("v.value")))
        {
            helper.doEmpCheck(component);
        }

        else{
            helper.displayToastMessage(component,event,'Error','Please Enter Office Email ID','error');
        }
    },
    opencibilpopup: function (component, event, helper) {//10647
        
        if(!$A.util.isEmpty(component.get("v.secondaryCibilRecs")))
        { component.set("v.showcibilpopup",true );
        }
    },  //10647
    pinChange : function(component, event, helper){
        helper.pinChangeHelper(component);
    },
    PanCheck : function(component, event, helper) {
        console.log("in pan check controller");
        if(!$A.util.isEmpty(component.get("v.account")) && !$A.util.isEmpty(component.get("v.account.PANNumber__c")))
        {   
            if(component.find("PANString").get("v.validity").valid)
             {
            var pannumber = component.get("v.account.PANNumber__c").toUpperCase();
            component.set("v.account.PANNumber__c",pannumber);
            helper.showhidespinner(component,event,true);
            helper.PanCheck(component,event);
            }
         else{
             component.find("PANString").showHelpMessageIfInvalid();
             helper.displayToastMessage(component,event,'Error','Please Enter valid PAN','error');
         }
        }     
        else
        {
            helper.displayToastMessage(component,event,'Error','Please Enter PAN','error');
            // component.set("v.items", null);
        }
    },
        
    initiateKYCForm : function(component, event, helper){ 
        component.set("v.kyc", event.getParam("kyc"));
        if (!$A.util.isEmpty(component.get("v.kyc")) && !$A.util.isEmpty(component.get("v.kyc.eKYC_First_Name__c")))
           component.set('v.disableAadhaar',false);
        else 
             component.set('v.disableAadhaar',true);
   
    },
    setpincode : function(component, event, helper){ 
        var pincode = event.getParam("pincode");
        var arealocality = event.getParam("arealocality");
      //component.set('v.account.PinCode__c',pincode);
      console.log('inside handler'+arealocality);
        component.set('v.areaSearchKeyword',arealocality);
   
    },
    
    removerecord : function(component, event, helper) {
        var productid=event.getParam("productOfferingId"); 
        var graboffer = event.getParam("graboffer"); 
        var assigntotelecaller = event.getParam("assigntotelecaller"); 
        console.log('inside remove record'+productid+graboffer+assigntotelecaller);
        if(!$A.util.isEmpty(productid) && assigntotelecaller)
        {
            var productofferinglist = component.get("v.items");
            console.log('before '+productofferinglist);
            var newpolst =[];
            for(var i in productofferinglist){
                console.log(i);
                var po = productofferinglist[i];
                console.log('po.id'+po.Id+'   '+productid);
                if(po.Id !== productid)
                {
                    newpolst.push(po);
                }
            }
            component.set("v.items",newpolst);
            console.log('aftre'+component.get("v.items"));
        }
        if(!$A.util.isEmpty(productid) && graboffer)
        {
            var productofferinglist = component.get("v.items");
            console.log('before '+productofferinglist);
            var newpolst =[];
            for(var i in productofferinglist){
                console.log(i);
                var po = productofferinglist[i];
                console.log('po.id'+po.Id+'   '+productid);
                if(po.Id == productid)
                {
                    po.Owner.Id = component.get("v.currentUser");
                    po.Owner.FirstName = component.get("v.userInfo.Name");
                    newpolst.push(po);
                }
                else
                    newpolst.push(po);
            }
            component.set("v.items",newpolst);
            console.log('aftre'+component.get("v.items"));
        }
        
        
    },
    
    continue : function(component, event, helper) {
        component.set("v.callfrom",false);
    	//component.set("v.conCreate",true);
        //component.set("v.officeflag",true);
    
     var callsaveloan =  $A.get("e.c:newloansave");
		callsaveloan.setParams({
			"callfrom": 'nsdlpancheck'
		});
		callsaveloan.fire();
        
	},
        savenew : function(component, event, helper) {
            component.set("v.callfrom",false);
           // component.set("v.conCreate",true);
            //component.set("v.officeflag",true);
            var callsaveloan =  $A.get("e.c:newloansave");
            callsaveloan.setParams({
                "callfrom": 'nsdlpancheck'
            });
            callsaveloan.fire();
        },
        
    searchOffer : function(component, event, helper) {
    	//helper.showhidespinner(component,event,true);
    	var stringToSearch1 =component.get("v.account.PANNumber__c");
        var stringToSearch2 =component.get("v.account.First_Name__c");
        var stringToSearch3 =component.get("v.account.Mobile__c");
    	console.log('stringToSearch1 pk'+stringToSearch1 +stringToSearch2 +stringToSearch3);
        if(!$A.util.isEmpty(stringToSearch1) && !$A.util.isEmpty(stringToSearch2) && !$A.util.isEmpty(stringToSearch3))
        {
            var PanID = component.find("PANString");
            var MobileID = component.find("Mobile");
            var NameID = component.find("FirstName");
             if(PanID.get("v.validity").valid && MobileID.get("v.validity").valid && NameID.get("v.validity").valid)
                helper.searchPOOfferHelper(component,event);
            else
            {
               // helper.showhidespinner(component,event,false);
                PanID.showHelpMessageIfInvalid();
                MobileID.showHelpMessageIfInvalid();
                NameID.showHelpMessageIfInvalid();
                component.set("v.items", null);
            }
        }
        else if(!$A.util.isEmpty(stringToSearch1))
        {
            var conMaritalStatusId = component.find("PANString");
            if(conMaritalStatusId.get("v.validity").valid)
                helper.searchPOOfferHelper(component,event);
            else
            {
               // helper.showhidespinner(component,event,false);
                conMaritalStatusId.showHelpMessageIfInvalid();
                component.set("v.items", null);
            }
        }
       else if(!$A.util.isEmpty(stringToSearch3))
        {
            var conMaritalStatusId = component.find("Mobile");
            if(conMaritalStatusId.get("v.validity").valid)
                helper.searchPOOfferHelper(component,event);
            else
            {
                conMaritalStatusId.showHelpMessageIfInvalid();
                component.set("v.items", null);
            }
        }
        else if((!$A.util.isEmpty(stringToSearch2))&&(!$A.util.isEmpty(stringToSearch3)))
        {
            var conMaritalStatusId = component.find("Mobile");
            if(conMaritalStatusId.get("v.validity").valid)
                helper.searchPOOfferHelper(component,event);
            else
            {
               // helper.showhidespinner(component,event,false);
                conMaritalStatusId.showHelpMessageIfInvalid();
                component.set("v.items", null);
            }
        }
        
        else{
           // helper.showhidespinner(component,event,true);
            helper.displayToastMessage(component,event,'Error','Enter Details to Search ','error');
        }
           
        
    },
        checkOfficeEmailId  : function(component, event, helper) {
            if($A.util.isEmpty(component.find('officialEmailId').get("v.value")))
            {
                    return false;
            }
            return true;
        },
    validateData  : function(component, event, helper) {
        //added for bug id 18459 start
        var isvalid = true;
            var today = new Date();
            var month = today.getUTCMonth() + 1;
            var day = today.getUTCDate();
            var year = today.getUTCFullYear();
            
            if(day<9&&day>1)
                day='0'+day;
            if(month<9 && month>1)
                month='0'+month;
            var newdate = year + "-" + month + "-" + day;
         
         if(!$A.util.isEmpty(component.get("v.account.Date_of_Birth__c")))
        {
			var inputField = component.find('DOB');
            var value = inputField.get('v.value');
            if(value > newdate) {
              $A.util.addClass(component.find("DOB"),"slds-has-error");
              $A.util.removeClass(component.find("dobdiv"),"slds-hide");
              $A.util.addClass(component.find("dobdiv"),"slds-show");
			   isvalid = false;
               console.log('inside ifisvalid>>'+isvalid);
           }
            else
            {
            $A.util.removeClass(component.find("dobdiv"),"slds-show");
			$A.util.addClass(component.find("dobdiv"), "slds-hide");
            $A.util.removeClass(component.find("DOB"),"slds-has-error");
            }
        }
        else{
            console.log('test dob in');
            component.find("DOB").showHelpMessageIfInvalid(); 
            isvalid = false;
        }
            
        //added for bug id 18459 end
        var list = ["PANString","FirstName","LastName", "MiddleName","pincode","areaLoc","resAdd","resAdd2","resAdd3"];
        console.log("test check"+component.get("v.OppID"));
        if($A.util.isEmpty(component.get("v.OppID"))){
        	list.push('Mobile');    
        }
        /*22017 s*/
        if(component.get("v.callfrom")){
            list.push('netSal');    
        }
        /*22017 e*/
        for (var i = 0; i < list.length; i++) {
            console.log('list[i]>>' + list[i]);
            console.log(component.find(list[i]));
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                isvalid = false;
                 console.log('list[i]>>component' + list[i]);
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        
       
         
         if(component.get("v.callfrom") && $A.util.isEmpty(component.get("v.EmployerSearchKeyword")))
        {
            isvalid = false;
            component.find("employer").set("v.errors", [{
                message: "Please Enter Value"
            }
                                                         ]);
        }
        /* if($A.util.isEmpty(component.get("v.areaSearchKeyword")))
        {
            isvalid = false;
            component.find("areaName").set("v.errors", [{
                message: "Please Enter Value"
            }
                                                         ]);
        }*/
        if(component.get("v.isOther"))
        {
           if (component.find("othercompany") && !component.find("othercompany").get("v.validity").valid)
           {
            isvalid = false;
            component.find("othercompany").showHelpMessageIfInvalid();
           }
       }
        console.log('isvalid -->'+isvalid);
        return isvalid;
        
    },
        
    validateCompany: function (component, event, helper) {
        var isvalid = true;
         if(component.get("v.callfrom") && $A.util.isEmpty(component.get("v.EmployerSearchKeyword")))
        {
            isvalid = false;
            component.find("employer").set("v.errors", [{
                message: "Please Enter Value"
            }
                                                         ]);
        }
        return isvalid;
    },
    /*City CR s*/
    cityKeyPressController: function (component, event, helper) {
    	component.set("v.validCity",false);  
        var finalCity = [];
        var cityList = component.get("v.cityList");
        var keyword = component.get("v.citySearchKeyword");
        if (keyword.length > 2){
            try{
            for(var i in cityList){
                if( cityList[i].city && cityList[i].city.toUpperCase().startsWith(keyword.toUpperCase()))
                    finalCity.push(cityList[i]);
            }
            }catch(e){console.log('exce');
                     console.log(e);
                     } 
            helper.openCloseSearchResults(component, 'city', true); 
        }
        else if (keyword.length <= 2) {
        	helper.openCloseSearchResults(component, 'city', false);    
        }
        console.log('citylist'+finalCity.length);
        component.set("v.finalCity",finalCity);
    },
    selectCity: function (component, event, helper) {
    	component.set("v.validCity",true);
        var index = event.currentTarget.dataset.record;
        var selectedCity = component.get("v.finalCity")[index];
        var keyword = selectedCity.city;
        console.log('keyword>>' + keyword);
        component.set("v.selectedCity", selectedCity);
        component.set("v.citySearchKeyword", keyword);
        var account = component.get("v.account");
        account.Current_State__c = selectedCity.state;
        account.Current_City__c = selectedCity.city;
        component.set("v.account",account);
        helper.openCloseSearchResults(component, 'city', false);    
    },
    /*City CR e*/
    empKeyPressController: function (component, event, helper) {
        component.set("v.ValidCompanyName",false);
        console.log('insourcekey');
        helper.startSearch(component, 'Employer');
    },
    selectEmployer: function (component, event, helper) {
        component.set("v.ValidCompanyName",true);
        var index = event.currentTarget.dataset.record;
        var selectedEmployer = component.get("v.EmployerList")[index];
        console.log('selected employer='+JSON.stringify(selectedEmployer));
        var keyword = selectedEmployer.Name;
        console.log('keyword>>' + keyword);
        component.set("v.selectedEmployer", selectedEmployer);
        component.set("v.EmployerSearchKeyword", keyword);
        if(keyword != undefined && (keyword.toLowerCase() == 'others' || keyword.toLowerCase() == 'other' || keyword.toLowerCase() == 'company not listed' || keyword.toLowerCase() == 'govt. department not listed' || keyword.toLowerCase() == 'school not listed'  )){                
              component.set("v.isOther",true);
        }
        else{
              component.set("v.isOther",false);
         }
        /* CR 22307 s */
        var stage = component.get("v.stageName");
        if(component.get("v.isUnderwriter") == true){
            if(stage == 'Underwriting' || component.get("v.loan.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
                component.set("v.epfoShow",false);
            } 
        }
        if(component.get("v.stageName") == 'DSA/PSF Login' && component.get("v.isUnderwriter") == false) {
           
            component.set("v.epfoShow",false);
        }
        /* CR 22307 e */
        component.set("v.account.Employer__c", selectedEmployer.Id);
        component.set("v.contObj.Employer__c", selectedEmployer.Id);
        component.set("v.contObj.Employer__r.KID__c", selectedEmployer.KID__c);
        console.log('employer is pkkid'+selectedEmployer.KID__c);
        console.log('employer is'+component.get("v.account.Employer__c"));
        component.set("v.account.Type_Of_Industry__c", selectedEmployer.Company_Category__c);
        helper.openCloseSearchResults(component, "Employer", false);
        component.find("employer").set("v.errors", [{
            message: ""
        }
                                                   ]);
    },
    areaKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        component.set("v.ValidAreaLocality",false);
        helper.startSearch(component, 'area');
    },
     selectArea: function (component, event, helper) {
                 component.set("v.ValidAreaLocality",true);
        var index = event.currentTarget.dataset.record;
        var selectedArea = component.get("v.areaList")[index];
        console.log(selectedArea);
        var keyword = selectedArea.Name;
        
        console.log('keyword>>' + selectedArea);
        component.set("v.selectedArea", selectedArea);
        component.set("v.areaSearchKeyword", keyword);
         var account = component.get("v.account");
        account.Area_Locality__c=selectedArea.Id;
        console.log('insdide selectpk'+component.get("v.account.Area_Locality__c"));
        //account.Current_Residence_Address1__c = selectedArea.Name;
         component.set("v.account",account);
		//component.set("v.account.Area_Locality__r.Name", selectedArea.Name);
        //console.log('Area loc master'+component.get("v.account").Area_Locality__r.Name) ;
        helper.openCloseSearchResults(component, "area", false);
        component.find("areaName").set("v.errors", [{
            message: ""
        }
                                                     ]);
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
    //Rohit added for address Start
     handleChange : function (component, event, helper) {
        var changeValue = event.getParam("value");
        console.log(changeValue);
    },
    doInit: function(component, event, helper){
        debugger;
        // Bug 23064 start
       
        if(stage == 'Underwriting' && component.get("v.salesprofilecheck") == true)
            {
            component.set("v.displayReadOnly",true);
             
            } 
        // Bug 23064 stop
        
		/* CR 22307 s */
        var stage = component.get("v.stageName");
        if(component.get("v.isUnderwriter") == true){
            if(stage == 'Underwriting' || component.get("v.loan.Consider_for_Re_Appraisal__c") == true || stage == 'Re-Appraise- Loan amount' || stage == 'Re-Appraise- IRR' || stage == 'Re-Appraise- Reject Case' || stage == 'Re-Appraise- Tenor')
            {
                component.set("v.displayReadOnly",false);
            } 
            else{
                component.set("v.displayReadOnly",true);
                component.set("v.epfoShow",true);
            }
            
        }
        if(component.get("v.stageName") != 'DSA/PSF Login' && component.get("v.isUnderwriter") == false) {
            component.set("v.displayReadOnly",true);
            component.set("v.epfoShow",true);
        }
        /* CR 22307 e */
        helper.fetchDataForDetails(component, event);
        //added for bug id 21851 start
        helper.getHideAadhaarSectionHelper(component);
        //added for 21851 end
        var met =  component.get('c.disableFields');
        console.log('here '+component.get("v.OppID")+' - '+component.get("v.isUnderwriter"));
         $A.enqueueAction(met);
        	if(component.get("v.fromcloneflag")== false) { //Added this if condition for Bug 23577
            //Rohit start
                
            if(component.get("v.isUnderwriter") == false && component.find("FirstName").get("v.value") != null && component.find("FirstName").get("v.value") != undefined)
                component.find("FirstName").set("v.disabled",true);
        	
        	if(component.get("v.isUnderwriter") == false && component.find("MiddleName").get("v.value") != null && component.find("MiddleName").get("v.value") != undefined)
                component.find("MiddleName").set("v.disabled",true);
            
            if(component.get("v.isUnderwriter") == false && component.find("LastName").get("v.value") != null && component.find("LastName").get("v.value") != undefined)
                component.find("LastName").set("v.disabled",true);
     
        	if(component.get("v.isUnderwriter") == false && component.find("DOB").get("v.value") != null && component.find("DOB").get("v.value") != undefined)
                component.find("DOB").set("v.disabled",true);

        	if(component.get("v.isUnderwriter") == false && component.find("Mobile")!=undefined && component.find("Mobile").get("v.value") != null && component.find("Mobile").get("v.value") != undefined)//21328
                component.find("Mobile").set("v.disabled",true);
			
        //hrushikesh added below 3 lines
        if( component.find("PANString").get("v.value") != null && component.find("PANString").get("v.value") != undefined){
                component.find("PANString").set("v.disabled",true);
            }
        //hrushikesh stop above 3 lines
      
            }
//Rohit stop
        var validExotelProd;
        component.set("v.displayExotel",false);
        helper.executeApex(component,'getvalidExotelProduct', {
            
        }, function (error, result) {
            
            console.log('result'+result);
            if (!error && result) {
                
                var data=JSON.parse(result);
              //alert(component.get("v.loan.Products__c"));
                component.set("v.validExotelProd",data);
                validExotelProd=component.get("v.validExotelProd");
                console.log('prodsvalid'+validExotelProd);
                for(var i=0 ; i < validExotelProd.length ; i++){
                    debugger;
                    if(!$A.util.isEmpty(component.get("v.loan.StageName"))){
                        if(validExotelProd[i].toUpperCase() === component.get("v.loan.Product__c").toUpperCase() && component.get("v.loan.StageName") && ( component.get("v.loan.StageName").trim() == 'DSA/PSF Login' || component.get("v.loan.StageName").trim() == 'Underwriting') || component.get("v.loan.StageName").trim() == 'Re-Appraise- Loan amount'){//Bug 24090 added undefined check for stage
                            if(component.get("v.loan.StageName").trim() == 'Underwriting' && component.get("v.isUnderwriter") == false){
                                component.set("v.displayExotel",false);
                            }else
                                component.set("v.displayExotel",true);
                        }
                    }
                }
            
            }else{
                alert('no data');
            }
         }); 
           
        	
    },
    copyDetails : function(component, event, helper){
        try{
        var getWhichBtn = event.getSource().get("v.label");
        var firstName = '';
        var lastName = '';
        var middleName = '';
        if(getWhichBtn != null && getWhichBtn == 'Copy PAN Details'){
			 component.set("v.isEditCkyc",false);//23578
            component.find("CkycEditBtn").set("v.disabled",true);//23578
            var acc = component.get("v.account");
            if(acc != null && acc != undefined){
                firstName = component.get("v.panFname");
                lastName = component.get("v.panLname");
                middleName= component.get("v.panMname"); 
				 //Bug 23578 start
                component.set("v.dataSource","Copy Pan Data");
                 component.find("FirstName").set("v.disabled", true); 
               component.find("MiddleName").set("v.disabled", true); 
               component.find("LastName").set("v.disabled", true);  
               component.find("pincode").set("v.disabled", false);
               component.find("PANString").set("v.disabled", false);     
               component.find("DOB").set("v.disabled", false);	
               component.find("areaLoc").set("v.disabled",false); 
                 //Bug 23578 stop	
            }    
            //component.find("DOB").set("v.value",null);
        }
        else if(getWhichBtn == 'Copy EKYC Details'){
		component.set("v.isEditCkyc",false);//23578
            component.find("CkycEditBtn").set("v.disabled",true);//23578
            var kyc = component.get("v.kyc");
            if(kyc != null && kyc != undefined){
                firstName = kyc.eKYC_First_Name__c;
                lastName = kyc.eKYC_Last_Name__c;
                component.find("DOB").set("v.value",kyc.eKYC_Date_of_Birth__c);
            }    
        }
        else if(getWhichBtn == 'Copy PO Details'){
			 component.set("v.isEditCkyc",false);//23578
            component.find("CkycEditBtn").set("v.disabled",true);//23578
            component.set("v.dataSource","Copy PO Data");//US11371 bug identified during uat movement
             var po = component.get("v.po");
            if(po != null && po != undefined){
                firstName = po.Lead__r.FirstName;
                lastName = po.Lead__r.LastName; 
                //added for bug id 18661 start
                if(po.Lead__r.middle_name__c != null || po.Lead__r.Middle_Name__c != undefined || po.Lead__r.Middle_Name__c !='' ){
               		 middleName = po.Lead__r.Middle_Name__c;
                    console.log('middlename='+middleName);
                }
                if(po.Lead__r.Middle_Name__c == null || po.Lead__r.Middle_Name__c =='' ){
                    console.log('in else middlename='+middleName);
               		 component.find("MiddleName").set("v.disabled",false);
            	}
                //added for bug id 18661 end
            }    
        }//Bug 23578 Ckyc rohit start
         else if(getWhichBtn == 'Copy CKYC Details'){
           component.find("CkycEditBtn").set("v.disabled",false);//23578  
           var accnt = component.get("v.Ckycaccount");
           console.log(accnt.Last_Name__c);
           if(accnt){
               firstName = accnt.First_Name__c;
               lastName = accnt.Last_Name__c;
               middleName= accnt.Middle_Name__c; 
                                                                        
           }
           var acc = Object.assign({}, component.get("v.Ckycaccount"));//deep cloning of objects to retain contact
           component.set("v.account",acc);//Bug 23578
           helper.changeCKYCfields(component,false);
           component.set("v.dataSource","Copy CKYC Data");//Bug 23578
         }
         else if(getWhichBtn == 'Edit CKYC Details' && component.find("CkycEditBtn") ){
           var accont = component.get("v.account");
           console.log(component.find("CkycEditBtn").get("v.checked"));
           if(component.find("CkycEditBtn").get("v.checked") === true){ 
            if(accont){
                firstName = accont.First_Name__c;
                lastName = accont.Last_Name__c;
                middleName= accont.Middle_Name__c; 
                                                                        
            } 
               
               
            helper.changeCKYCfields(component,true);
            component.set("v.dataSource","Edit CKYC Data");//Bug 23578
          }
          else{
            component.set("v.dataSource","Copy CKYC Data");  
           var acct = Object.assign({}, component.get("v.account"));//deep cloning of objects to retain contact
            firstName = acct.First_Name__c;
                lastName = acct.Last_Name__c;
                middleName= acct.Middle_Name__c; 
           component.set("v.account",acct);//Bug 23578
           helper.changeCKYCfields(component,false);
          }   
             
         }
        //Bug 23578 Ckyc rohit stop
        component.find("FirstName").set("v.value",firstName);
        component.find("MiddleName").set("v.value",middleName);
        component.find("LastName").set("v.value",lastName);
        }catch(e){console.error('searchdata Error '+e);}//US11371
    },
    disableFields : function(component, event, helper){
        console.log('here ');
         var account = component.get("v.account");
         var LAN = component.get("v.loan.Loan_Application_Number__c"); //Added for Bug 23577
        if(account != null && account != undefined){
            if(account.PANNumber__c != null && account.PANNumber__c != undefined && !$A.util.isEmpty(LAN)){ //Added LAN condition for Bug 23577
            	component.find("PANString").set("v.disabled",true);    
            }
            
           if(account.Date_of_Birth__c != null && account.Date_of_Birth__c != undefined && !$A.util.isEmpty(LAN)){ //Added LAN condition for Bug 23577
               console.log('here2');
                component.find("DOB").set("v.disabled",true);
            }
            
            if(component.get("v.isUnderwriter") == false && account.Mobile__c != null && account.Mobile__c != undefined && !$A.util.isEmpty(LAN)){ //Added LAN condition for Bug 23577
             /* var cmplist = component.find("Mobile");
                for(var i=0;i< cmplist.length;i++){
                    if(cmplist[i])
                    cmplist[i].set("v.disabled",true);
                }*/
                  
             component.set("v.isMobileNumberReadOnly",true);
                //Added conditions for Bug 23577 Start
                                                                if(component.get("v.fromcloneflag") && !$A.util.isEmpty(LAN)){ 
                                                                    if(component.get("v.isUnderwriter") == false && component.find("FirstName").get("v.value") != null && component.find("FirstName").get("v.value") != undefined)
                                                                        component.find("FirstName").set("v.disabled",true);
                                                                    
                                                                    if(component.get("v.isUnderwriter") == false && component.find("MiddleName").get("v.value") != null && component.find("MiddleName").get("v.value") != undefined)
                                                                        component.find("MiddleName").set("v.disabled",true);
                                                                    
                                                                    if(component.get("v.isUnderwriter") == false && component.find("LastName").get("v.value") != null && component.find("LastName").get("v.value") != undefined)
                                                                        component.find("LastName").set("v.disabled",true);
             
        }
                                                                //Added conditions for Bug 23577 Stop
        }
        }
    },
/*23064 s*/
    makeacall : function(component,event,helper){
       helper.showhidespinner(component,event,true);
       helper.displayToastMessage(component,event,'Success','Calling....','success'); 
    // var appId = event.target.getAttribute('id');
        var ctarget = event.currentTarget;
    	var appId = ctarget.dataset.value;
        console.log(appId + ' ---- '+appId);
     // var oppID=component.get("v.OppID");
      //  alert(oppID);
        var fromNumber;
   
         helper.executeApex(component,'callToCustomer', {
             "frommobile" :  "none",
             "tomobile":component.get("v.account.Mobile__c")+'',
             "Id" : appId,
             "objName":"Applicant__c",
             "Product":component.get("v.applicantObj.Product__c").toUpperCase()
         }, function (error, result) {
             if (!error && result) {
                 console.log('Callback done '+JSON.stringify(result));
                 if(result !== 'Success'){
                     helper.displayToastMessage(component,event,'Error',result,'error');
                 }
                helper.showhidespinner(component,event,false);
                
             }else{
                 
                 helper.displayToastMessage(component,event,'Error',result,'error');
             }
              helper.showhidespinner(component,event,false);
         }); 
    },
 /*added by swapnil 23064 e*/   
        /*23064 e*/
    //Rohit added for address Stop 
    redirectToViewCibilReport : function (component, event, helper) {
        console.log(component.get("v.cibil.Id"));
        console.log(component.get("v.primaryApplicant.Id"));
        /*24997 added if else*/
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isViewReportModalOpen", true);
        else if(component.get("v.isCommunityUsr"))
              window.open('/Partner/apex/OTPOneViewCIBILpage?id=' + component.get("v.cibil.Id")+'&appId='+component.get("v.applicantObj.Id"),'_blank', 'toolbar=0,location=0,menubar=0');
        else
            window.open('/apex/OTPOneViewCIBILpage?id=' + component.get("v.cibil.Id")+'&appId='+component.get("v.applicantObj.Id"),'_blank', 'toolbar=0,location=0,menubar=0');
    },
    closeModel : function (component, event, helper) {
    	component.set("v.isViewReportModalOpen", false);
        component.set("v.showcibilpopup",false );//10647

    },
	redirectToOneViewCibilReport : function (component, event, helper) {
        component.set("v.isOneViewReportModalOpen", true);
    },
    closeOneViewModel : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpen", false);
    }, 
    redirectToOneViewCibilReportold : function (component, event, helper) {
        /*24997 added if else*/
        if(component.get("v.theme") == 'Theme4t')
            component.set("v.isOneViewReportModalOpenold", true);
        else if(component.get("v.isCommunityUsr"))
             window.open('/Partner/apex/DetailedCibilReportPage?id=' + component.get("v.cibil.Id"),'_blank', 'toolbar=0,location=0,menubar=0');  
         else
            window.open('/apex/DetailedCibilReportPage?id=' + component.get("v.cibil.Id"),'_blank', 'toolbar=0,location=0,menubar=0');
            
    },
    closeOneViewModelold : function (component, event, helper) {
    	component.set("v.isOneViewReportModalOpenold", false);
    }, 
        
    doEPFOCheck: function(component, event, helper){
        helper.doEPFO(component,event);
    },  
        openOneViewCIBIL : function(component, event, helper) {
            console.log('sd');
            $A.createComponent(
                "c:OTPOneViewCIBILPageLightning",{"appId":component.get("v.applicantObj.Id"),"cibid":component.get("v.cibil.Id"),"cibilTempId":component.get("v.cibil.Cibil_Temp__c"),"leadId":""},
                function(newComponent){
                    console.log('sd');
                    component.set("v.body",newComponent);
                    
                }
            ) 
        },
		  //23578 start
      setCKYCfields : function(component, event, helper){
       	helper.changeCKYCfields(component,false,event);
      },
      PanCheckFrmLandPg :function(component, event, helper){
      	var params = event.getParam("arguments"); 
          if(params){
              component.set("v.panSrc", params.from);
              console.log('pan source '+component.get("v.panSrc"));
              $A.enqueueAction(component.get('c.PanCheck'));
          }
      },
     //23578 stop  
            setConAcc:function(component, event, helper){// sal 2.0 adhoc
                
                var priConObj =  event.getParam("priConObj");
                var account =  event.getParam("account");
                if(!$A.util.isEmpty(priConObj)) 
                    component.set("v.priConObj",priConObj);
                if(!$A.util.isEmpty(account)) 
                    component.set("v.account",account);
            }
              
              
                  

        
})