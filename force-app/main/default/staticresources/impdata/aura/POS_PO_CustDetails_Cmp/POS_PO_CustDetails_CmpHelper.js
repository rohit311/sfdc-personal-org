({
 sendSms: function(component) {
  if (component.get("v.smsCount") < 5) {
   var tempsmsCount = component.get("v.smsCount");
   var mobileNumber = component.get("v.lead.MobilePhone");
   component.set("v.spinnerFlag", "true");
   this.executeApex(component, "callSendSms", {
    "MobileNumber": mobileNumber
   }, function(error, result) {
    component.set("v.spinnerFlag", "false");
    if (!error && result) {
     tempsmsCount++;
     component.set("v.smsCount", tempsmsCount);
     component.set("v.smsSentList", smsObjList);
     var smsObjList = [];
     smsObjList.push(result[0]);
     component.set("v.smsSentList", smsObjList);
     this.showToast(component, 'Success!', 'Consent SMS send Successfully', 'success');

    } else {
     this.showToast(component, 'Error!', 'Error While sending Consent SMS', 'error');

    }
   });

  } else {
   this.showToast(component, 'info!', 'Cannot Send More than 5 SMS', 'info');

  }


 },

 createSmsSentObjs: function(component) {
  this.executeApex(component, "createSmsSentObj", {
    "poId": component.get("v.po").Id,
    "SmsObjList": JSON.stringify(component.get("v.smsSentList"))
   },
   function(error, result) {
    if (!error && result) {}
   });
 },

 getResidentialCity: function(component) {
  this.executeApex(component, "getResidenceCity", {}, function(error, result) {
   if (!error && result) {
    component.set("v.residenceCities", result || []);
   }
  });
 },
 getDegreeType: function(component) {
     
  this.executeApex(component, "getDegreeOptions", {}, function(error, result) {
   if (!error && result) {
       
    component.set('v.degreeValues', result);
    this.setSelectOptions(component, result, "Degree", "degreeProspect");

   }
  });
 },
 getDoctorDegreeDependent: function(component) {
  this.executeApex(component, "getDoctorDependentDegreeOptions", {}, function(error, result) {
   if (!error && result) {

    // bugId 21687 S -- As setSelectOptions called below is making binding varialbe v.po.Degree__c of degreeProspect id as blank string ("")
    // so fetcing the value before call and resetting it for degreeProspect id
    var doctorDegree;
    if (component.get("v.po.Degree__c") != undefined)
     doctorDegree = component.get("v.po.Degree__c");
    // bugId 21687 E

    component.set('v.degreeValues', result);
    this.setSelectOptions(component, result, "Degree", "degreeProspect");

    // bugId 21687 S
    if (component.get("v.po.Degree__c") != undefined && component.find("degreeProspect") != undefined)
     component.find("degreeProspect").set("v.value", doctorDegree);
    // bugId 21687 E
   }
  });
 },
    //Bug 24237 S
    getUserData : function(component) {
       // debugger;
       var listOfBranch =  $A.get("$Label.c.POS_SourcingBranch").split(',');
       component.set("v.listOfBranch",listOfBranch); 
        this.executeApex(component, "getCurrentUserData", {}, function(error, result){
            if(!error && result){     
                component.set('v.currentUserEmpId', result.Employee_ID__c);
                
            }
        });
    },
    //Bug 24237 E
 getSalutation: function(component) {
  var SalutaionList = ['Mr.', 'Mrs.', 'Ms.'];
  this.setSalutationOptions(component, SalutaionList, "Salutation");
  component.set("v.lead.Salutation", "-- None --");


 },

 getResidentialTypeData: function(component) {
  this.executeApex(component, "getResidentialType", {}, function(error, result) {
   if (!error && result) {
    this.setSelectOptions(component, result, "Residential Type", "residentialType");
    component.set("v.lead.Residential_type__c", "Owned by Self/Spouse");
   }
  });
 },
 getPracticeTypeData: function(component) {
  var segmentValue = component.find("profession").get("v.value") || component.get("v.lead.Profession_Type__c");
  var result = this.getPracticeTypeMap(component, segmentValue);
  if (result) {
   this.setSelectOptions(component, result, "Practice Type", "practiceType");
   component.set("v.po.Practice_Type__c", "SEP");
  }
  /*this.executeApex(component, "getPracticeType", {}, function(error, result){
      if(!error && result){
          this.setSelectOptions(component, result, "Practice Type", "practiceType");
      }
  });*/
 },
 getSpecializationData: function(component) {
  var segmentValue = component.find("profession").get("v.value") || component.get("v.lead.Profession_Type__c");
  var result = this.getspecializationMap(component, segmentValue);
  //if (result)
   //this.setSelectOptions(component, result, "Specialization", "specialization");
  if (segmentValue == 'Engineers') {// Mobile Automation 23-07-2019
      if(result)// Mobile Automation 23-07-2019
          this.setSelectOptions(component, result, "Stream", "specialization");// Mobile Automation 23-07-2019
  } else {// Mobile Automation 23-07-2019
      if(result)
         this.setSelectOptions(component, result, "Specialization", "specialization");
  }// Mobile Automation 23-07-2019
  /*  this.executeApex(component, "getSpecialization", {}, function(error, result){
      if(!error && result){
          this.setSelectOptions(component, result, "Specialization", "specialization");
      }
  });*/
 },
 getspecializationMap: function(component, key) {

  //POS YK s added var to resolve error
  var specializationMap = [];
  //POS YK e added var to resolve error

  //Fixed by Rajendra 20520-18158 //gopika 23971
  specializationMap['Doctor']=['Allergist', 'Anaesthesist', 'Anatomy and Physiology', 'Andrologist', 'Audiologist', 'Ayurveda', 'Biochemistry', 'Cardiac Surgeon', 'Cardiologist', 'Cardiothorasic Surgeon', 'Community Medicine and PSM', 'Cosmetic Surgeon', 'Dentist', 'Dermatologist', 'Diabetologist', 'Emergency Medicine', 'Endocrinologist', 'Endodontist', 'ENT', 'Epidemeologist', 'Family Medicine', 'Forensic Medicine and Toxicology', 'Gastroenterologist', 'General Medicine', 'General Physician', 'General Surgeon', 'Geriatrician', 'Gynaecologist and Obstetrician', 'Haematolgist', 'Histopathology', 'Homeopath', 'Hospital Management', 'Immunologist', 'Implantologist', 'Leprhologist', 'Microbiology', 'Neonatologist', 'Nephrologist', 'Neurologist', 'Neurosurgeons', 'Nuclear Medicine', 'Oncologist', 'Operative Dentistry', 'Opthalmologist', 'Oral and Maxilofacial', 'Oral Medicine and Radiology', 'Orthodontists', 'Orthopaedic', 'Palliative Medicine', 'Pathologist', 'Pediatrician', 'Pedodontics and Preventive Dentistry', 'Periodontics', 'Periodontology and Oral Implantology', 'Pharmacologist', 'Podiatrist', 'Prosthodontics', 'Psychiatrist', 'Psychologist', 'Pulmonologist', 'Radiologist', 'Rheumatologist', 'Tropical', 'Urosurgeon', 'Vascular and Endovascular Surgeon', 'Venerologist','Veterinary']; 
  specializationMap['Engineers'] = ['Chemical Engg', 'Electronics Instrumentation', 'mechanical engg', 'Computer Science', 'Textile Chemistry', 'Electronics And Comm', 'Civil Engg', 'electrical engg', 'automobile engg', 'Computer Engg', 'IT', 'Production Engg', 'Not Available'];
  specializationMap['all'] = ['Chemical Engg', 'Electronics Instrumentation', 'mechanical engg', 'Computer science', 'Textile Chemistry', 'Electronics And Comm', 'Civil Engg', 'electrical engg', 'automobile engg', 'Computer Engg', 'IT', 'Production Engg', 'CA', 'CS', 'CWA', 'Allergist', 'Anaesthesist', 'Anatomy and physiology', 'Andrologist', 'Audiologist', 'Ayurveda and Homeopath', 'Cardiologist', 'Cosmetic', 'Surgeon', 'Dentist', 'Dentistry', 'Dermatologist', 'Diabetologist', 'Diagnostic', 'Endocrinologist', 'Endodontist', 'ENT', 'EPIDEMEOLOGIST', 'Gastroenterologist', 'General', 'Physician', 'General', 'Surgeon', 'Geriatrician', 'Gynaecologist & Obstetrician', 'HAEMOTOLOGISTS', 'Histopathology', 'Immunologist', 'Implantologist', 'Neonatologist', 'Nephrologist', 'Neurologist', 'Oncologist', 'Opthalmologist', 'Oral & Maxilofacial Surgeon', 'Orthodontists', 'Pathologist', 'Pediatrician', 'Periodontics', 'Pharmacologist', 'Physiotherapist', 'Podiatrist', 'Psychologist', 'Pulmonologist', 'Radiologist', 'Rheumatologist', 'Sexologist', 'Venerologist', 'Neurosurgeons', 'Psychiatrist', 'Orthopaedic', 'Surgeons', 'Plastic', 'Surgeon', 'FORENSIC', 'MEDICINE AND TOXICOLOGY', 'Urologist', 'Not Available'];
  specializationMap['CA'] = ['CA', 'CS', 'CWA', 'Not Available'];
  if (key)
   return specializationMap[key];
  else
   return specializationMap['all'];
 },
 getPracticeTypeMap: function(component, key) {

  //POS YK s added var to resolve error
  var PracticeTypeMap = [];
  //POS YK e added var to resolve error
  PracticeTypeMap['Doctor'] = ['Salaried', 'Salaried+Practicing', 'Consulting', 'Consulting+Practicing', 'SEP'];
  PracticeTypeMap['CA'] = ['SEP'];
  PracticeTypeMap['Engineers'] = ['Consulting', 'SEP'];
  PracticeTypeMap['all'] = ['Salaried', 'Salaried+Practicing', 'Consulting', 'Consulting+Practicing', 'SEP'];
  if (key)
   return PracticeTypeMap[key];
  else
   return PracticeTypeMap['all'];
 },
 getProfessionTypeData: function(component) {
  var result = ['Doctor', 'CA', 'Engineers']
  this.setSelectOptions(component, result, "Segment Type", "profession");
  component.set("v.lead.Profession_Type__c", "Doctor");
  /*this.executeApex(component, "getProfession", {}, function(error, result){
      if(!error && result){
         
          this.setSelectOptions(component, result, "Segment Type", "profession");
      }
  });*/
 },
 getExperienceData: function(component) {
  this.executeApex(component, "getExperienceDetails", {}, function(error, result) {
   if (!error && result) {

    if (component.find('practiceExperience')) { //Added by sneha 
     this.setSelectOptions(component, result, "Experience in Years", "practiceExperience");
    }

    this.setSelectOptions(component, result, "Post Grad. Experience", "postGradExperience");
    var po = component.get("v.po");
    var practiceExpValCMP = component.find("practiceExperience");
    if (practiceExpValCMP)
     practiceExpValCMP.set('v.value', po.Experience_in_Years__c);

    var postGradExpValCMP = component.find("postGradExperience");
    if (postGradExpValCMP)
     postGradExpValCMP.set('v.value', po.Total_work_experience__c);
   }
   component.set("v.po", po);
  });
 },
 // Bug 14509 s
 getDegreeData: function(component) {
  this.executeApex(component, "getDegree", {}, function(error, result) {
   if (!error && result) {
    component.set('v.degreeValues', result);
    this.setSelectOptions(component, result, "Degree", "degree");

   }
  });
 },
 // Bug 14509 E
 getCollegeCityData: function(component) {
  this.executeApex(component, "getCollegeCityDetails", {}, function(error, result) {
   if (!error && result) {
    // this.setSelectOptions(component, result, "College City", "collegeCity");
    component.set("v.collegeCities", result || []);
   }
  });
 },
 gethighestDegreeTypeData: function(component) {
  var result = ['Post Graduate', 'Graduate', 'Diploma'];
  this.setSelectOptions(component, result, "Highest Degree Type", "highestDegreeType");
  /*  this.executeApex(component, "gethighestDegreeTypeDetails", {}, function(error, result){
      if(!error && result){
          this.setSelectOptions(component, result, "Highest Degree Type", "highestDegreeType");
        }
  });*/
 },
 setSelectOptions: function(component, data, label, cmpId) {
  try {
   if (component.find(cmpId)) {
    var opts = [{
     "class": "optionClass",
     label: "Select " + label,
     value: ""
    }];
    for (var i = 0; i < data.length; i++) {
     opts.push({
      "class": "optionClass",
      label: '' + data[i],
      value: data[i]
     });
    }
    if(component.find(cmpId))
    component.find(cmpId).set("v.options", opts);
   }
  } catch (e) {
   console.log('for Component ' + component + 'cmpID' + cmpId + ' data ' + data);

  }
  if(component.find(cmpId))	
  component.find(cmpId).set("v.options", opts);
 },
 setSalutationOptions: function(component, data, cmpId) {

  var opts = [{
   "class": "optionClass",
   label: "-- None -- ",
   value: ""
  }];
  for (var i = 0; i < data.length; i++) {
   opts.push({
    "class": "optionClass",
    label: '' + data[i],
    value: data[i]
   });
  }
  component.find(cmpId).set("v.options", opts);
 },
 fetchOfficeAddress: function(component, helper) {
  //alert('In fetchOfficeAddress1');
  var lead = component.get("v.lead");
  //var poObj = component.get("v.po");
  if (lead.CheckINLocationAddress__c == '' || lead.Off_Pin_Code__c == '') {
   if (navigator.geolocation) {
    //alert('In fetchOfficeAddress2');
    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude;
      var lon = position.coords.longitude;

      var action = component.get("c.getAddressfromGeolocation");
      action.setParams({
       "latitude": lat,
       "longitude": lon
      });
      action.setCallback(this, function(response) {
       var state = response.getState();
       if (state === "SUCCESS") {
        var locationMap = response.getReturnValue();

        var officeAddress = locationMap.RestAddress;
        var str1 = '';
        var str2 = '';
        var str3 = '';
        var addarr = [];

        if (officeAddress) {
         addarr = officeAddress.split(' ');
         if (addarr.length > 0) {
          var count = Math.floor(addarr.length / 3);
          for (var i = 0; i < count; i++) {
           str1 = str1 + ' ' + addarr[i];
           str2 = str2 + ' ' + addarr[i + count];
           str3 = str3 + ' ' + addarr[i + count + count];
          }
          if (count * 3 < addarr.length) {
           for (var i = count * 3; i < addarr.length; i++)
            str3 = str3 + ' ' + addarr[i];
          }


         }
        }
        lead.Lead_Office_Address_Line1__c = str1;
        lead.Lead_Office_Address_Line2__c = str2;
        lead.Lead_Office_Address_Line3__c = str3;
        lead.CheckINLocationAddress__c = (lat) + '-' + (lon);
        //  lead.Lead_Office_City__c = locationMap.City;

        //YK 18553
        if (locationMap.Pincode == undefined || locationMap.Pincode == null || locationMap.Pincode == '') {
         lead.Off_Pin_Code__c = '000000';
         lead.Lead_Office_Pin_Code__c = '000000';
        } else {
         lead.Off_Pin_Code__c = locationMap.Pincode;
         lead.Lead_Office_Pin_Code__c = locationMap.Pincode;
        }


        component.set("v.lead", lead);



       }
      });
      $A.enqueueAction(action);
     },
     function(error) {
      // alert(error.code)
      if (error.code == 1) {
       helper.showToast(component, "Error!", "Please Turn on your Device Location. ", "error");
       return false;
      }

     }

    );
    return true;
   } else {
    // Added by PSL 28 Sept
    helper.showToast(component, "Error!", "Please Turn on your Device Location. ", "error");
    return false;
   }
  } else {
   return true;
  }
  return true;
 },
 getCustomerDetails: function(component, poId) {
  this.executeApex(component, "getCustomerDetails", {
   "poId": poId
  }, function(error, result) {
   if (!error && result) {
       
    this.setExistingCustomerDetails(component, JSON.parse(result));
    this.getMCPResult(component,poId); //Bug 22425 CC Code changes SME
	this.setIncSecFieldVisibility(component);// US : 19995
    if (component.get("v.offer.converted")) {
     this.disableForm(component);
     this.triggerPostSaveEvent(component, true);
     this.triggerDisplayOfferEvent(component); // bugId-18322
    } else {
     //PSL changes : Nikhil Bugfix #11800
     //calling trigger display event to update Offer details
     this.triggerDisplayOfferEvent(component);
    }
   }
  });
 },       // Bug 22425 CC Code changes SME S
 getMCPResult: function(component,poId) {
 	this.executeApex(component, "getMCPResults", {
   		"poId": poId
  	},function(error, result) {
   		if (!error && result) {
            console.log('resultMCP is'+result);
			if(result=='fail'){
                 component.set("v.isFailedMCP","true");
			}
        }
  	});
 },
    //Bug 22425 CC Code changes SME E
 updateForm: function(component, newPO) {

  this.getSpecializationData(component);
  this.getPracticeTypeData(component);
  var segmentValue = component.get("v.lead.Profession_Type__c") || component.find("profession").get("v.value");
  if (newPO) {
   var po = component.get("v.po");
   po.Practice_Type__c = newPO.Practice_Type__c || po.Practice_Type__c;
   po.Specialisation__c = newPO.Specialisation__c || po.Specialisation__c;

   component.set("v.po", po);
   component.find("specialization").set("v.value", po.Specialisation__c);
   //component.set("v.po.Specialisation__c","Computer Science");

  }
  // var segmentValue = component.get("v.lead.Profession_Type__c");
  if (segmentValue && segmentValue === 'Engineers') {
   this.showHideDiv(component, "highestDegreeTypeDiv", true);
   this.showHideDiv(component, "collegeNameDiv", true);
   this.showHideDiv(component, "collegeCityDiv", true);

   this.getCollegeCityData(component);

   this.gethighestDegreeTypeData(component);

   var specializationCMP = component.find("specializationLabel");
   if (specializationCMP)
    specializationCMP.set('v.value', 'Stream');

   var practiceExpCMP = component.find("practiceExperienceLabel");
   if (practiceExpCMP) {
    practiceExpCMP.set('v.value', 'Business Vintage');

    this.getExperienceData(component); //Added by sneha

   }
     
   var postGradExpCMP = component.find("postGradExperienceLabel");
   if (postGradExpCMP)
    postGradExpCMP.set('v.value', 'Post Graduate Experience');//'Post Qualification Experience'
   //Added by Rohan 31-05-2018
   var practiceExpValCMP = component.find("practiceExperience");
   if (practiceExpValCMP)
    practiceExpValCMP.set('v.value', po.Experience_in_Years__c);

   var postGradExpValCMP = component.find("postGradExperience");
   if (postGradExpValCMP)
    postGradExpValCMP.set('v.value', po.Total_work_experience__c);
    console.log('v.po.Total_Employment_Vintage__c'+component.get("v.po.Total_Employment_Vintage__c"));
   //this.addRemoveInputError(component, "highestDegreeType" , this.isEmpty(component.get("v.po.TypeOfDegreeforCA_Architect__c")) && "Select Highest Degree Type");

  } else {
   if (segmentValue && segmentValue === 'Doctor')
    this.getDoctorDegreeDependent(component);
   else
    this.getDegreeType(component);
     
   this.showHideDiv(component, "highestDegreeTypeDiv", false);
   this.showHideDiv(component, "collegeNameDiv", false);
   this.showHideDiv(component, "collegeCityDiv", false);

   var specializationCMP = component.find("specializationLabel");
   if (specializationCMP)
    specializationCMP.set('v.value', 'Specialization');

   var practiceExpCMP = component.find("practiceExperienceLabel")
   if (practiceExpCMP)
    practiceExpCMP.set('v.value', 'Practice Experience');

   var postGradExpCMP = component.find("postGradExperienceLabel")
   if (postGradExpCMP)
    postGradExpCMP.set('v.value', 'Post Graduate Experience');

   //this.addRemoveInputError(component, "highestDegreeType" , !this.isEmpty(component.get("v.po.TypeOfDegreeforCA_Architect__c")) && "Select Highest Degree Type");
  }

 },
 setExistingCustomerDetails: function(component, data) {
     //Bug 24927 S
     if(!$A.util.isEmpty(data) && !$A.util.isEmpty(data.lead)){
         component.set("v.isResidenceAddressChanged",data.lead.Resi_Address_Changed__c);
     }
     //Bug 24927 E
  this.setPOData(component, data.po);
  console.log('data.lead -->' + JSON.stringify(data.lead));
  this.setLeadData(component, data.lead);
  this.setOldLeadData(component);
  this.setOfferDetails(component, data.offer);
  
  component.get("v.po.Degree__c");
  component.set("v.isExistingOffer", true);
  // BugId- 22141 Mobile Validation S
  if(data.cibilTempObj!=null && data.cibilTempObj!=''&& data.cibilTempObj != undefined){
  	console.log(data.cibilTempObj.CIBIL_Mobile_Check__c);
  	component.set("v.MobileValidationResult",data.cibilTempObj.CIBIL_Mobile_Check__c);
    component.set("v.displayExotel",true); // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement start	
  }
  //BugId- 22141 Mobile Validation E   
  this.updateForm(component, data.po);
  // Bug Id : 24716 start
        debugger;
        if (data.ckycSP != null && data.ckycSP != '' && data.ckycSP != undefined) {
            console.log('data.ckycSP --> ' + data.ckycSP);
            //component.set('v.isReadOnlyCKYC', true);// Bug Id : 24716
            if (data.ckycSP.Policy_Name__c == 'Ckyc Download response' && data.ckycSP.Remarks__c == 'success') {// US : 13265 S
                component.set('v.isReadOnlyCKYC', true);
            }// US : 13265 E
            if(!$A.util.isEmpty(component.get("v.lead.DOB__c"))){
            	component.set("v.ckycDisable", true);
            }
            if(!$A.util.isEmpty(component.get("v.lead.PAN__c"))){
            	component.find("pannumber").set("v.disabled", true);
            }
            if(!$A.util.isEmpty(component.get("v.lead.LastName"))){
            	component.find("lastName").set("v.disabled", true);
            }
            if(!$A.util.isEmpty(component.get("v.lead.FirstName"))){
            	component.find("firstName").set("v.disabled", true);
            }
          /*  console.log('residence add --> ' + component.get("v.residenceAddress"));
            if(!$A.util.isEmpty(component.get("v.residenceAddress"))){
            	component.find("residenceAddress").set("v.disabled", true);
            }
            if(!$A.util.isEmpty(component.get("v.lead.Resi_City__c"))){
            	component.find("residenceCity").set("v.disabled", true);
            }
            if(!$A.util.isEmpty(component.get("v.lead.Resi_Pin_Code__c"))){
            	component.find("pincode").set("v.disabled", true);
            }  */         
        }
        // Bug Id : 24716 end
        debugger;
 },
    checkForExistingOffers: function(component, helper) {
        
        var lead = component.get("v.lead");
        var productFlow = component.get('v.productFlow') === 'RDL' ? 'RDL' : 'PRO';
        
        this.executeApex(component, "POScheckForExistingOffers", {
            "firstName": lead.FirstName,
            "lastName": lead.LastName,
            "mobile": lead.MobilePhone,
            "product": productFlow,
            "pan": lead.PAN__c
        }, function(error, result) {
            
            if (!error && result && result.length) {
                // Bug 24927 S
                var GCOCampaignLists = component.get("v.GCOCampaignList");
                var OfferGCOMap = [];
                for (var po in result){
                    console.log('GCOCampaignLists'+GCOCampaignLists);
                    if(GCOCampaignLists.includes(result[po].Campaign_Type__c)){
                        OfferGCOMap.push({value:result[po],key:'GCO'});
                    }
                    else{
                        OfferGCOMap.push({value:result[po],key:'NONGCO'});
                    }  
                }
                 component.set("v.existingOfferswithGCO",OfferGCOMap);
				 component.set("v.displayExotel",true); // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement start
                // Bug 24927 E
                console.log('existingOfferswithGCO'+JSON.stringify(component.get("v.existingOfferswithGCO")));
                
                component.set("v.spinnerFlag", "false");
                this.showHideDiv(component, "grabOffers", true);
            } else {
                //this.createLeadData(component, helper);
                // US : 13265 Start
        		if (component.get("v.CkycMandate") == true && $A.util.isEmpty(component.get("v.ckycSearch"))) {
            		this.showToast(component, "Error!", "CKYC Initiation is mandatory", "error");
        		} else {
           			this.createLeadData(component, helper);
        		}
        		// US : 13265 End
            }
        });
    },
 grabOffer: function(component, poId) {
  component.set("v.spinnerFlag", "false");
  this.executeApex(component, "grabExistingOffer", {
   "poId": poId
  }, function(error, result) {
   if (!error && result) {
    this.setExistingCustomerDetails(component, JSON.parse(result));
    //PSL changes : Nikhil Bugfix #11888
    this.triggerDisplayOfferEvent(component);
    this.showHideDiv(component, "grabOffers", false);
    debugger;
    this.validateLeadInputData(component); //pankaj
   // component.set("v.spinnerFlag", "false");
   }
  });
 },
 createLeadData: function(component, helper) {
  try {
   var lead = component.get("v.lead");
   console.log('createLeadData lead --> ' + JSON.stringify(lead));
   //Bug 12827 Point 1 S
   /*   if(component.get("v.po.Specialisation__c").toLowerCase() === 'ca'){
       lead.Profession_Type__c = 'CA';
       lead.LeadSource = 'ProMobility CA';
   } else {
       lead.Profession_Type__c = 'Doctor';
       lead.LeadSource = 'ProMobility Doctor';
   }*/
   //16621 : Changed by Rohan: Moved to helper for RSA saving during lead creation
   //Below added by Rohan for RSA Stamping during lead creation without clicking on toggle.
   this.setRSAValue(component);
   if (component.find("profession").get("v.value"))
    if (component.find("profession").get("v.value").toLowerCase() === 'ca') {
     lead.LeadSource = 'ProMobility CA';
    } else if (component.find("profession").get("v.value").toLowerCase() === 'doctor') {
    lead.LeadSource = 'ProMobility Doctor';
   } else if (component.find("profession").get("v.value").toLowerCase() === 'engineers') {
    lead.LeadSource = 'ProMobility Engineer';
   } else {
    lead.LeadSource = 'ProMobility';
   }
   //Above condition added by Rohan for Engineer specific condition.
   // Bug 14509 E - RDL Eligibility calculation
   // Bug 14509 s - RDL Eligibility calculation - Logic shifting
   lead.Company = 'Others';
   lead.Applicant_Type__c = 'Primary Applicant';
   lead.Customer_Type__c = 'Individual';

   //this.fetchOfficeAddress(component);


   if (component.get("v.lead.Is_Permanent_Resi_Addr_Different__c") == undefined) {

    lead.Is_Permanent_Resi_Addr_Different__c = false;


   }





   if (component.find("profession").get("v.value").toLowerCase() === 'engineers') {
    lead.Employment_Type__c = component.get("v.po.Practice_Type__c");
    //lead.Product__c = 'PRO';
   } else
    lead.Employment_Type__c = 'SEP';
   lead.Resi_Pin_Code__c = '' + lead.Resi_Pin_Code__c;
   lead.Product__c = 'PRO';
   // Bug 14509 E       
   //Rohit added ekyc record data S
   var kyc = component.get("v.kyc");

   if (kyc == null || kyc.eKYC_City__c == null || kyc.eKYC_City__c == '') {
    kyc = null;

   }
   //Rohit added ekyc record data E
   //alert('---Is_Permanent_Resi_Addr_Different__c->>'+lead.Is_Permanent_Resi_Addr_Different__c);
   //Bug 12827 Point 1 E 
   lead.Id = lead.Id !== '' ? lead.Id : null;
      //added by Gopika for segmentation v2
      this.setDoctorFamilyFlag(component); 
      this.setRunningHospitalFlag(component);
   this.executeApex(component, "createLead", {
    "lead": JSON.stringify(lead), //Bug-27399
    "ekyc": JSON.stringify(kyc) 
   }, function(error, result) {
    if (!error && result) {

     //Bug 14716 S
     var isRetrigger = this.isRetriggerCIBIL(component);
        console.log('isRetrigger -->' + isRetrigger);
       
        
     //isRetrigger = isRetrigger ? true : false ;
     component.set("v.isRetriggerCIBIL", isRetrigger);
     var isRetriggerddup = this.isRetriggerDEDUPE(component);
     //isRetrigger = isRetrigger ? true : false ;
     component.set("v.isRetriggerDEDUPE", isRetriggerddup);
     this.setLeadData(component, result);
     this.setOldLeadData(component);
        console.log('v.po.Total_Employment_Vintage__c testA'+component.get("v.po.Total_Employment_Vintage__c"));
     // Bug 14716 E
     this.createPOData(component);
    }
   });
      
   /*     // Bug Id : 22896
        //this.setTimeout(this.checkForCIBILScore, this, 5000, component);
        debugger;
        component.set("v.spinnerFlag", "true");
      console.log('calling  checkTatMaster method for prod issue-->' );
        this.executeApex(component, "checkTatMaster", {
   			"cibilTempId": component.get("v.cibilTempId"), "leadId": lead.Id
  		}, function(error, result) {
   			if (!error && result) {
                debugger;
                //var timeOutLabel = $A.get("$Label.c.NSDL_TIMEOUT_INT_SECS");
             console.log('All condition satisfied, called checkTatMaster method for prod issue-->' );
        		//this.setTimeout(this.callNSDLPan, this, timeOutLabel, component);
        		this.callNSDLPan(component);
                component.set("v.spinnerFlag", "false");
            } else {
                //this.showToast(component, 'Error!', "Please check cibil data", 'success');
                component.set("v.spinnerFlag", "false");
            }
  		});      
        // Bug Id : 22896   */
  } catch (exp) {}
 },
 createPOData: function(component) {
     
  var po = component.get("v.po");
  //YK 18553
  po.Office_Pin_Code__c = component.get("v.lead").Off_Pin_Code__c;
  po.Lead__c = component.get("v.lead").Id;
  po.Specialisation__c = component.find("specialization").get("v.value");
  console.log('v.po.Total_Employment_Vintage__c testA'+component.get("v.po.Total_Employment_Vintage__c"));
  if (component.find("practiceExperience")) { //added by sneha 

   po.Total_Employment_Vintage__c = component.find("practiceExperience").get("v.value");
  }

  po.Post_Graduate_Super_Specialist_Experienc__c = component.find("postGradExperience").get("v.value");
  po.Practice_Type__c = component.find("practiceType").get("v.value");
  //  var monthlyObligation = component.find("obligations").get("v.value"); 	// Bug 13675 - Hemant Keni
  //  po.Monthly_Obligation__c = component.find("obligations").get("v.value"); 	// Bug 13675 - Hemant Keni
  po.Id = po.Id !== '' ? po.Id : null;

  po.DOB__c = component.get("v.lead").DOB__c;
  po.Total_work_experience__c = po.Post_Graduate_Super_Specialist_Experienc__c;
  po.Experience_in_Years__c = po.Total_Employment_Vintage__c;
  po.Lead__r = component.get("v.lead");
  po.Data_Mart_Status__c = 'LIVE'; //Bug 14863

  //Bug 16207 - January 2018 BRD - Engineering program in mobility
  if (component.get("v.productFlow") === 'RDL')
   po.Mobile_Source__c = 'rdlmobility';
  else
   po.Mobile_Source__c = 'promobility';
  //Bug 16207 - January 2018 BRD - Engineering program in mobility
  //debugger;
  //18158 START
  if (po.COP_Date__c) {
	
    console.log(' po.Total_Employment_Vintage__c first'+ po.Total_Employment_Vintage__c);         
   var DifMs = Date.now() - Date.parse(component.get("v.po.COP_Date__c"));          
   var ExpDate = new Date(DifMs);            
   po.Total_Employment_Vintage__c = Math.abs(ExpDate.getUTCFullYear() - 1970);       
  } else if (component.find("practiceExperience")) {
   //debugger;
   po.Total_Employment_Vintage__c = component.find("practiceExperience").get("v.value"); 
      console.log(' po.Total_Employment_Vintage__c second'+ po.Total_Employment_Vintage__c); 
      
  }
  //18158 END

  // Bug 13675 S - Hemant Keni
  //Bug 12827 Point 2 S
  //Below check added by Rohan for CA/CS/CWA
  if (po.Specialisation__c == 'CA' || po.Specialisation__c == 'CS' || po.Specialisation__c == 'CWA') {
   po.Program_Type__c = 'SEP';
   po.Full_Time_COP_Holder__c = 'YES';
   po.Is_COP_Active__c = 'ACTIVE';
   //po.Monthly_Obligation_From_PO__c = monthlyObligation;	
   po.Lead_Source__c = 'ProMobility CA';
   //Added  by rohan for Bug 20422

   po.Degree__c = po.Specialisation__c;
  } else if (component.get("v.lead").Profession_Type__c.toLowerCase() === 'doctor') {
   //  po.Monthly_Obligation__c = monthlyObligation;
   po.Lead_Source__c = 'ProMobility Doctor';
  } else {
   //   po.Monthly_Obligation__c = monthlyObligation;
   po.Lead_Source__c = 'ProMobility Engineer';
  }
     // Bug 24927 S
     //this.isGCOImpactFieldsChanged(component);
     if(component.get("v.isGCOCampaign") == 'true'){
         var lead = component.get("v.lead");
         console.log('lead in GCO'+ lead);
         var oldPO_GCO = component.get("v.oldPO_GCO");
         if (po && oldPO_GCO) {
             var impactFieldsHistory ='Specialisation:';
             console.log('old Specialisation__c'+oldPO_GCO.Specialisation__c + 'new Specialisation__c'+po.Specialisation__c);
             if(po.Specialisation__c != oldPO_GCO.Specialisation__c){
                 impactFieldsHistory = impactFieldsHistory + oldPO_GCO.Specialisation__c+'~'+po.Specialisation__c;
                 component.set("v.isGCOImpFieldsChanged",true);
             }
             console.log('old Degree__c'+oldPO_GCO.Degree__c + 'new Degree__c'+po.Degree__c);
             impactFieldsHistory = impactFieldsHistory + '|'+'Degree:'
             if(lead.Profession_Type__c != 'CA' && lead.Profession_Type__c != 'Engineers' && po.Degree__c != oldPO_GCO.Degree__c){
                 impactFieldsHistory = impactFieldsHistory + oldPO_GCO.Degree__c+'~'+po.Degree__c;
                 component.set("v.isGCOImpFieldsChanged",true);
             }
             if(lead.Profession_Type__c == 'Engineers' && po.TypeOfDegreeforCA_Architect__c != oldPO_GCO.TypeOfDegreeforCA_Architect__c){
                 impactFieldsHistory = impactFieldsHistory + oldPO_GCO.TypeOfDegreeforCA_Architect__c+'~'+po.TypeOfDegreeforCA_Architect__c;
                 component.set("v.isGCOImpFieldsChanged",true);
             }
             /* 8595 Vikas 
             impactFieldsHistory = impactFieldsHistory + '|'+'DOR:';
             console.log('old date'+oldPO_GCO.COP_Date__c + 'new date'+po.COP_Date__c);
             
             var COP_new = new Date(po.COP_Date__c); 
             var COP_old = new Date(oldPO_GCO.COP_Date__c);
             console.log('COP_old', COP_old.getTime(),'COP_new', COP_new.getTime());
             //if(po.COP_Date__c != oldPO_GCO.COP_Date__c){
             if(lead.Profession_Type__c != 'Engineers' && !$A.util.isEmpty(COP_old) && !$A.util.isEmpty(COP_new) && COP_old.getTime() != COP_new.getTime()){
                 impactFieldsHistory = impactFieldsHistory + COP_old.toLocaleDateString() + '~'+COP_new.toLocaleDateString();
                 component.set("v.isGCOImpFieldsChanged",true);
             }
			  */
             console.log('old Practice_Type__c'+oldPO_GCO.Practice_Type__c + 'new Practice_Type__c'+po.Practice_Type__c);
             impactFieldsHistory = impactFieldsHistory + '|' + 'Practice Type:';
             if(po.Practice_Type__c != oldPO_GCO.Practice_Type__c &&  oldPO_GCO.Practice_Type__c == 'Salaried'){
                 impactFieldsHistory = impactFieldsHistory + oldPO_GCO.Practice_Type__c + '~' + po.Practice_Type__c;
                 component.set("v.isGCOImpFieldsChanged",true);
             }
             console.log('old Medical_registration_No__c'+oldPO_GCO.Medical_registration_No__c + 'new Medical_registration_No__c'+po.Medical_registration_No__c);
             impactFieldsHistory = impactFieldsHistory + '|'+ 'Registration Number:';
             if(po.Medical_registration_No__c != oldPO_GCO.Medical_registration_No__c){
                 impactFieldsHistory = impactFieldsHistory + oldPO_GCO.Medical_registration_No__c + '~' + po.Medical_registration_No__c;
                 component.set("v.isGCOImpFieldsChanged",true);
             }
             component.set("v.GCOImpactFieldsHistory",impactFieldsHistory);
         }
         po.Quality_Remarks__c = component.get("v.GCOImpactFieldsHistory");  
     }
     // Bug 24927 E
  //YK POS s
  if (component.get("v.kyc").Id != '' && (component.get("v.residenceAddress") != component.get("v.kyc").eKYC_Address_details__c)) // Bug Id : 19057
  {
   var po = component.get("v.po");
   po.eKYC_details_changed_flag__c = 'Yes';
   component.set("v.po", po);
  } else {
   var po = component.get("v.po");
   po.eKYC_details_changed_flag__c = 'No';
   component.set("v.po", po);
  }
  //YK POS e
  //Bug 12827 Point 2 E 
  // Bug 13675 E- Hemant Keni
  // Bug 24927 S
   console.log(' po.Total_Employment_Vintage__c second'+ po.Total_Employment_Vintage__c); 
  this.executeApex(component, "createPO", {
            "po": po
        }, function(error, result){
            if(!error && result){
                if(component.get("v.isGCOCampaign") == 'true' && component.get("v.isGCOImpFieldsChanged") == true){
                    this.executeApex(component, "GCOFieldsChanged", {
                        "po": po,
                    }, function(error, result) {
                        if (!error && result) {
                this.setPOData(component, result);                
                var kyc = component.get("v.kyc");
                kyc.Lead__c = component.get("v.lead").Id;
                kyc.Product_Offerings__c = component.get("v.po").Id;
               
                component.set('v.kyc', kyc);
                if(!$A.util.isEmpty(kyc.Id)){
                    this.updateKYC(component);
                } else {
                    this.createDedupe(component);
                    this.createCIBIL(component);
                    
                                this.createSmsSentObjs(component);
                                //this.callNSDLPan(component);
                            }  
                        }
                    });
                }
                else{
                    this.setPOData(component, result);
                    var kyc = component.get("v.kyc");
                    kyc.Lead__c = component.get("v.lead").Id;
                    kyc.Product_Offerings__c = component.get("v.po").Id;
                   
                    component.set('v.kyc', kyc);
                    if (!$A.util.isEmpty(kyc.Id)) {
                        this.updateKYC(component);
                    } else {
                        this.createDedupe(component);
                        this.createCIBIL(component);
                        
                        this.createSmsSentObjs(component);
                    //this.callNSDLPan(component);
                }
            }
                
            }
        });
    },
      // Bug 24927 E
 updateKYC: function(component) {
  var kyc = component.get("v.kyc");
  this.executeApex(component, "saveKYC", {
   "kycId": kyc.Id,
   "leadId": kyc.Lead__c,
   "poId": kyc.Product_Offerings__c
  }, function(error, result) {
   if (!error && result) {
    this.createDedupe(component);
    this.createCIBIL(component);
    //this.callNSDLPan(component);
   }
  });
 },
 createCIBIL: function(component, callback) {
  component.set("v.spinnerFlag", "false");
  debugger;
  if (this.validateLeadInputData(component)) {
   component.set("v.spinnerFlag", "true");
   // Bug 13114 - added new parameter to call createCibilTempRecord
   // Bug 14716 - changed retrigger parameter
   console.log('po -->', JSON.stringify(component.get("v.po"))); // Added 28Sept
   //alert('po -->' + JSON.stringify(component.get("v.po"))); // Added 28Sept
   this.executeApex(component, "createCibilTempRecord", {
    "leadObj": component.get("v.lead"),
    "po": component.get("v.po"),
    "retrigger": component.get("v.isRetriggerCIBIL")
   }, function(error, result) {
    if (!error && result) {
     //console.log('Result : '+ result.status);
     debugger;
     component.set("v.cibilTempId", result);
     this.setTimeout(this.showSpinner, this, 1, component);
     this.setTimeout(this.checkForCIBILScore, this, 5000, component);
     //this.callNSDLPan(component);
     // Bug Id : 21606
     var timeOutLabel = $A.get("$Label.c.NSDL_TIMEOUT_INT_SECS");
     this.setTimeout(this.callNSDLPan, this, timeOutLabel, component);
    } else if (!error) {
     this.showToast(component, "Error!", "Please check the data and reinitiate. " + error, "error");
    }
   });
  }
 },
 createDedupe: function(component) {
  debugger;
  if (this.validateLeadInputData(component)) {
	  debugger;
   this.executeApex(component, "createDedupeRecord", {
    "leadObj": component.get("v.lead"),
    "retrigger": component.get("v.isRetriggerDEDUPE")
   }, function(error, result) {

    if (!error && result) {

    } else if (!error) {

    }
   });
  }
 },
 callNSDLPan: function(component) {
  var lead = component.get("v.lead");
       
     //alert('Inside NSDL');
  if (component.get("v.oldPanNumber") !== lead.PAN__c) { //this.validateLeadInputData(component) 
   this.executeApex(component, "callNSDLPanCheck", {
    "lead": component.get("v.lead"),
   }, function(error, result) {
   if(result != null && result != '' && !error && result) { // Prod_Bug--22988
 //   if (!error && result) {
     component.set("v.oldPanNumber", component.get("v.lead").PAN__c);
     console.log('here if -->' + result);
     this.executeApex(component, "saveTatMaster", {
      "tatMasterRecord": JSON.stringify(result),
     }, function(error, result) {

     });
    } else  {
        
         // Prod_Bug--22988 start
         if(lead.PAN__c !=null && lead.PAN__c !=''){	
           var sampleTAT =  component.get("v.DummyTat")
           sampleTAT.PAN_Number__c = lead.PAN__c;
           sampleTAT.Lead__c = lead.Id;
           sampleTAT.TypeP__c ='NSDL PAN Check';
           sampleTAT.PAN_Check_Status__c ='Details could not be fetched';
           sampleTAT.PAN_Source__c = 'Input';
           
           
          this.executeApex(component, "saveTatMaster", {
          "tatMasterRecord": JSON.stringify(sampleTAT),
              }, function(error, result) {
    
           });
	   }
         // Prod_Bug--22988  end 
        
    }
   });
  }
 },
 checkForCIBILScore: function(component) {

  this.executeApex(component, "checkForCibilScore", {
   "cibilTempId": component.get("v.cibilTempId")
  }, function(error, result) {
   if (!error && result) {

    result = JSON.parse(result);
    if (result.status === "ERROR") {
     this.showToast(component, 'Error!', result.message, 'error');
     this.setOldLeadData(component);
    } else if (result.status === "RECEIVED") {
        // 22141 S
     	console.log('result.mobileFraudResult'+result.mobileFraudResult);
     	component.set("v.MobileValidationResult",result.mobileFraudResult);
		component.set("v.displayExotel",true); // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement start
        // 22141 E
     	this.getCIBILDataforDOL(component);
    } else {
     component.set("v.spinnerFlag", "false");
     this.showHideDiv(component, "alertDialog", true);
    }
   }
  });
 },
 getCIBILDataforDOL: function(component, cibilTempId) {
  debugger;
      component.set("v.spinnerFlag","true");
  this.executeApex(component, "getCIBILDataforDOL", {
   "flow": "1",
   "poId": component.get("v.po").Id,
   "leadId": component.get("v.lead").Id,
   "cibilTempId": component.get("v.cibilTempId")
  }, function(error, result) {
   //   component.set("v.spinnerFlag","false");
   //Rohit 16111 CR (added condition for ekyc) S
   var ekyc = component.get("v.kyc");
   if (!error && result) {
    result = JSON.parse(result);
    //Rohit 16111 CR (added condition for ekyc)
    ekyc = result.ekycmobility;
    if (result.status === 'SUCCESS') {
     component.set("v.spinnerFlag", "false");
     result = result.message.split('=') || [];
     console.log('result --> ' + result);// US: 2702
     if (!$A.util.isEmpty(result[20]) && !$A.util.isEmpty(result[21])) {
         console.log('result 20 --> ',result[20] + ' : ' +result[21]);
         component.set("v.po.Card_limit__c", result[21]);
     }// US: 2702
     this.setOldLeadData(component);
        //Bug 24927 S
        this.setOldPO_GCO_Data(component);
        //Bug 24927 E
     this.setOfferDetails(component, {
      "offerAmount": Math.round((result[1] || 0) * 100) / 100,
      "segmentation": result[5],
      "cibilScore": result[17],
      "Offer_Insurance": result[19],
      "Offer_ROI": result[7],
      "converted": result[9],
      "Offer_PF": result[11],
      "Offer_Tenor": result[13],
      "Offer_ProcessMaster": result[15],
     });
     this.triggerPostSaveEvent(component, true);
     this.triggerDisplayOfferEvent(component);
     this.showHideDiv(component, "nextButtonId", true);
     this.showToast(component, 'Success!', "Customer Details Saved successfully. Please proceed to the next Tab.", 'success');
     // Bug 13022 S
    } else if (result.status === 'Skipping BRE') {
     console.log('Skipping BRE : ');
     this.setOldLeadData(component);
     this.triggerPostSaveEvent(component, true);
     this.triggerDisplayOfferEvent(component);
     this.showHideDiv(component, "nextButtonId", true);
     this.showToast(component, 'Success!', "Customer Details Saved successfully. Please proceed to the next Tab.", 'success');
     // Bug 13022 E                 
    } else if (result.status === 'MCP FAILED' || (result.status === 'FAILED' && result.message != null && result.message != '')) {
     var oldOffer = component.get("v.offer");
     if (!this.isEmpty(oldOffer) && !(typeof oldOffer === 'string' || oldOffer instanceof String)) {
      oldOffer.offerAmount = 0;
      this.setOfferDetails(component, oldOffer);
     } else {
      this.setOfferDetails(component, {
       "offerAmount": 0
      });
         
     }
     $A.util.addClass(component.find("nextButtonId"), "slds-hide");
     $A.util.removeClass(component.find("nextButtonId"), "slds-show");
        component.set("v.isFailedMCP","true");    // Bug 22425 CC Code changes SME 
     this.triggerDisplayOfferEvent(component);
     this.triggerPostSaveEvent(component, false);
     this.showToast(component, 'Error!', 'MCP Failed: ' + result.message, 'error');
    } else {
     //alert(result.status);
     //PSL changes : Nikhil Bugfix #11800
     var oldOffer = component.get("v.offer");
     //result = result.message.split('=') || [];
     if (!this.isEmpty(oldOffer) && !(typeof oldOffer === 'string' || oldOffer instanceof String)) {
      oldOffer.offerAmount = 0;
      this.setOfferDetails(component, oldOffer);
     } else {
      this.setOfferDetails(component, {
       "offerAmount": 0
      });
     }
     //calling trigger display event to update Offer details
     this.triggerDisplayOfferEvent(component);
     this.showHideDiv(component, "nextButtonId", false);

     //16621 Added by Rohan - result.status added in Error Toast
     this.showToast(component, 'Error!', 'There is some error at BRE', 'error');
    }
   }
  });
 },
 triggerPostSaveEvent: function(component, isSubmitted) {

  var customerSaveEvent = $A.get("e.c:CustomerSaveEvent");
  customerSaveEvent.setParams({
   "kyc": component.get("v.kyc"),
   "po": component.get("v.po"),
   "lead": component.get("v.lead"),
   "offer": component.get("v.offer"),
   "isSubmitted": isSubmitted
  });
  customerSaveEvent.fire();
 },
 //PSL changes : Nikhil Bugfix #11800  
 /*
  * @author	: Nikhil S
  * @date	: 03/10/2017 
  * @desc	: This method trigger offer details display event
  * 
  */
 triggerDisplayOfferEvent: function(component) {
   //Bug 22425 CC Code changes SME S
 var segmentlabel  = $A.get("$Label.c.CC_Pro_Loan_Seg");
   var segmentList = segmentlabel.split(',');
   //component.set('v.segmentList'+segmentList);
   var profession  = component.get("v.lead.Profession_Type__c")
   var SegmentMatched = "false" ;
   if(profession && segmentList.includes(profession.toUpperCase())){
       SegmentMatched = "true";
   } 
     
     console.log('failedMCp ##'+component.get("v.isFailedMCP"));
  var displayOfferEvent = $A.get("e.c:POS_DisplayOfferEvent");
  displayOfferEvent.setParams({
   "offer": component.get("v.offer"),
   "poObj": component.get("v.po"),
   "Lead": component.get("v.lead"),
   "MCPResult": component.get("v.isFailedMCP"),
    "SegmentMatched":SegmentMatched
  });
  displayOfferEvent.fire();
 //Bug 22425 CC Code changes SME E
 },
 searchCity: function(component) {
  var keyword = component.get("v.residenceCitySearchKeyword");
  if (keyword.length > 0) {
   var all = component.get("v.residenceCities") || [];
   var filterValues = [];
   for (var i = 0; i < all.length; i++) {
    var value = all[i];
    if (value.toLowerCase().includes(keyword.toLowerCase())) {
     filterValues.push(value);
    }
   }
   component.set("v.filteredResidenceCities", filterValues);
   this.showHideMessage(component, "residenceCity", !filterValues.length);
   this.openCloseSearchResults(component, "residenceCity", true);
  } else {
   component.set("v.filteredResidenceCities", null);
   this.openCloseSearchResults(component, "residenceCity", false);
  }
 },

 //POS YK s
 searchPermanentCity: function(component) {
  var keyword = component.get("v.permanentCitySearchKeyword");
  if (keyword.length > 0) {
   var all = component.get("v.residenceCities") || [];
   var filterValues = [];
   for (var i = 0; i < all.length; i++) {
    var value = all[i];
    if (value.toLowerCase().includes(keyword.toLowerCase())) {
     filterValues.push(value);
    }
   }
   component.set("v.filteredPermanentCities", filterValues);
   this.showHideMessage(component, "permanentCity", !filterValues.length);
   this.openCloseSearchResults(component, "permanentCity", true);
  } else {
   component.set("v.filteredPermanentCities", null);
   this.openCloseSearchResults(component, "permanentCity", false);
  }
 },
 //POS YK e

 searchCollegeCity: function(component) {
  var keyword = component.get("v.collegeCitySearchKeyword");
  if (keyword.length > 0) {
   var all = component.get("v.collegeCities") || [];
   var filterValues = [];
   for (var i = 0; i < all.length; i++) {
    var value = all[i];
    if (value.toLowerCase().includes(keyword.toLowerCase())) {
     filterValues.push(value);
    }
   }
   console.log(filterValues);
   component.set("v.filteredCollegeCities", filterValues);
   this.showHideMessage(component, "collegeCity", !filterValues.length);
   this.openCloseSearchResults(component, "collegeCity", true);
  } else {
   component.set("v.filteredCollegeCities", null);
   this.openCloseSearchResults(component, "collegeCity", false);
  }
 },
 startSearch: function(component, key) {
  var keyword = component.get("v." + key + "SearchKeyword");
  if (keyword.length > 2 && !component.get('v.searching')) {
   component.set('v.searching', true);
   component.set('v.oldSearchKeyword', keyword);
   this.searchHelper(component, key, keyword);
  } else if (keyword.length <= 2) {
   component.set("v." + key + "List", null);
   this.openCloseSearchResults(component, key, false);
  }
 },
 searchHelper: function(component, key, keyword) {
  this.executeApex(component, "fetch" + this.toCamelCase(key), {
   'searchKeyWord': keyword
  }, function(error, result) {
   if (!error && result) {
    this.handleSearchResult(component, key, result);
   }
  });
 },
 handleSearchResult: function(component, key, result) {
  component.set('v.searching', false);
  if (component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
   component.set("v." + key + "List", null);
   this.startSearch(component, key);
  } else {
   component.set("v." + key + "List", result);
   this.showHideMessage(component, key, !result.length);
   this.openCloseSearchResults(component, key, true);
  }
 },
 //PSL changes : Nikhil Bugfix #11767
 //replace " city" text from residense city field
 setKycData: function(component, kyc) {
  component.set("v.residenceAddress", kyc.eKYC_Address_details__c);
  component.set("v.permanentAddress", kyc.eKYC_Address_details__c);
  component.set("v.kyc", kyc);
  this.setResidenceAddress(component);
  //POS YK s


  var leadSalutation;
  var leadGender;
  if (kyc) {

   if (kyc.eKYC_Gender__c == 'F') {
    leadSalutation = 'Mrs.';
    leadGender = 'Female';
    component.find('Salutation').set('v.value', 'Mrs.');
   } else {
    leadSalutation = 'Mr.';
    leadGender = 'Male';
    component.find('Salutation').set('v.value', 'Mr.');

   }



   

  }

  //POS YK e
  this.setLeadData(component, {
   /* FirstName: kyc.eKYC_First_Name__c,
    LastName: kyc.eKYC_Last_Name__c,*/
   FirstName: (kyc.eKYC_First_Name__c).replace(/\s/g, ''),
   LastName: (kyc.eKYC_Last_Name__c).replace(/\s/g, ''),
   Email: kyc.eKYC_E_mail__c,
   // DOB__c: kyc.eKYC_Date_of_Birth__c,
   Resi_City__c: kyc.eKYC_City__c == undefined ? '' : kyc.eKYC_City__c.replace(' City', ''),
   MobilePhone: kyc.eKYC_Mobile_Number__c,
   Resi_Pin_Code__c: kyc.eKYC_Pin_Code__c,
   //POS YK s
   Per_Pin_Code__c: kyc.eKYC_Pin_Code__c,
   Per_City__c: kyc.eKYC_City__c == undefined ? '' : kyc.eKYC_City__c.replace(' City', ''),
   //Salutation : leadSalutation,
   Gender__c: leadGender
   //POS YK e
  });
 },
 setLeadData: function(component, newLead) {
  var lead = component.get("v.lead");
  console.log('lead ---> ' + JSON.stringify(lead));
  debugger;
  lead.Id = newLead.Id || lead.Id;
  lead.FirstName = newLead.FirstName || lead.FirstName;
  lead.LastName = newLead.LastName || lead.LastName;
  lead.Email = newLead.Email || lead.Email;
  lead.PAN__c = newLead.PAN__c || lead.PAN__c;
  lead.CheckINLocationAddress__c = newLead.CheckINLocationAddress__c || lead.CheckINLocationAddress__c;
  lead.Lead_Office_Address_Line1__c = newLead.Lead_Office_Address_Line1__c || lead.Lead_Office_Address_Line1__c;
  lead.Lead_Office_Address_Line2__c = newLead.Lead_Office_Address_Line2__c || lead.Lead_Office_Address_Line2__c;
  lead.Lead_Office_Address_Line3__c = newLead.Lead_Office_Address_Line3__c || lead.Lead_Office_Address_Line3__c;
  lead.Off_Pin_Code__c = newLead.Off_Pin_Code__c || lead.Off_Pin_Code__c;

 // CC Code changes SME S
 lead.Customer_Interest__c = newLead.Customer_Interest__c || lead.Customer_Interest__c;
     
 // US : 13265 Set CKYCDocumentType values from backend
 lead.CKYCDocumentType__c = newLead.CKYCDocumentType__c || lead.CKYCDocumentType__c;
     console.log('lead.CC_Disposition__c ------>' + lead.CC_Disposition__c);
 lead.CC_Disposition__c = newLead.CC_Disposition__c || lead.CC_Disposition__c; // US : 2702
 //lead.CC_Variant__c = newLead.CC_Variant__c || lead.CC_Variant__c;
 // CC Code changes SME E
 console.log('newLead.Doctor_s_Family__c',newLead.Doctor_s_Family__c);
        //Added for Segementation V2 Bug 23971 by GC s
        if(newLead.Doctor_s_Family__c === 'Yes'){
            component.set("v.DoctorFlag",true);
            component.set("v.MandatoryFamilyRegistration",true);   
        }
        else
            component.set("v.DoctorFlag",false); 
        
        if(newLead.Running_Hospital__c=== 'Yes')
            component.set("v.RunningHospitalFlag",true);  
        else
            component.set("v.RunningHospitalFlag",false);   
        lead.Family_Member_Reg_No__c= newLead.Family_Member_Reg_No__c;
        lead.Annual_Individual_Income_in_Lacs__c = newLead.Annual_Individual_Income_in_Lacs__c;
        console.log('Hospital_of_Consultancy__c',newLead.Annual_Individual_Income_in_Lacs__c);
        lead.Hospital_of_Consultancy__c = newLead.Hospital_of_Consultancy__c; 
        if(newLead.Hospital_of_Consultancy__r)
            component.set("v.hospitalSearchKeyword",newLead.Hospital_of_Consultancy__r.Name);
        debugger;
       lead.SegmentionOne__c = newLead.SegmentionOne__c||lead.SegmentionOne__c;
        //Added for Segementation V2 Bug 23971 by GC e
	    // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement start
		lead.CallRecodingURL__c = newLead.CallRecodingURL__c||lead.CallRecodingURL__c;
        lead.StartTime__c = newLead.StartTime__c||lead.StartTime__c;
        // May-2019 Enhancement :-- 2275: USERSTORY_Calling through Exotel  Enhancement end
  lead.DOB__c = newLead.DOB__c || lead.DOB__c;
  lead.State__c = newLead.State__c || lead.State__c;
  lead.Resi_City__c = newLead.Resi_City__c || lead.Resi_City__c;
  lead.Salutation = newLead.Salutation || lead.Salutation;
  component.find('Salutation').set('v.value', newLead.Salutation || lead.Salutation);
  console.log('lead.Salutation ---->> ' + lead.Salutation)
    if (lead.Salutation == 'Mrs.' || lead.Salutation == 'Ms.') { // CC Code changes SME S
       lead.Gender__c = 'Female';
    } else {
        lead.Gender__c = 'Male';
    } // CC Code changes SME E
  lead.RSA_Flag__c = newLead.RSA_Flag__c || lead.RSA_Flag__c;
  lead.Is_Permanent_Resi_Addr_Different__c = newLead.Is_Permanent_Resi_Addr_Different__c || lead.Is_Permanent_Resi_Addr_Different__c;
  console.log('lead.Is_Permanent_Resi_Addr_Different__c ---->> ' + newLead.Resi_City__c)
  //PSL changes : Nikhil Bugfix #11801
  //regex to replace all non numeric fields from mobile field
  var newMobile = newLead.MobilePhone;
  if (newLead.MobilePhone != undefined && typeof newLead.MobilePhone == "string")
   newMobile = newMobile.replace(/[^0-9.]/g, "");

  lead.MobilePhone = '' + (newMobile || lead.MobilePhone);
  lead.SBS_Branch__c = newLead.SBS_Branch__c || lead.SBS_Branch__c;
  lead.Resi_Pin_Code__c = '' + (newLead.Resi_Pin_Code__c || lead.Resi_Pin_Code__c);
  lead.Off_Pin_Code__c = '' + (newLead.Off_Pin_Code__c || lead.Off_Pin_Code__c);
  lead.Residential_type__c = newLead.Residential_type__c || lead.Residential_type__c;
  lead.Profession_Type__c = newLead.Profession_Type__c || lead.Profession_Type__c;
  lead.Residence_Address_Line1__c = newLead.Residence_Address_Line1__c || lead.Residence_Address_Line1__c;
  lead.Residence_Address_Line2__c = newLead.Residence_Address_Line2__c || lead.Residence_Address_Line2__c;
  lead.Residence_Address_Line3__c = newLead.Residence_Address_Line3__c || lead.Residence_Address_Line3__c;
  lead.Lead_Office_Address_Line1__c = newLead.Lead_Office_Address_Line1__c || lead.Lead_Office_Address_Line1__c;
  lead.Lead_Office_Address_Line2__c = newLead.Lead_Office_Address_Line2__c || lead.Lead_Office_Address_Line2__c;
  lead.Lead_Office_Address_Line3__c = newLead.Lead_Office_Address_Line3__c || lead.Lead_Office_Address_Line3__c;


  //POS YK s
  //  lead.Salutation = newLead.Salutation || lead.Salutation;
  lead.Gender__c = newLead.Gender__c || lead.Gender__c;
  lead.Per_Pin_Code__c = '' + (newLead.Per_Pin_Code__c || lead.Per_Pin_Code__c);
  lead.Per_City__c = newLead.Per_City__c || lead.Per_City__c;
  lead.Medical_Council__c = newLead.Medical_Council__c || lead.Medical_Council__c;
  if (lead.RSA_Flag__c == 'Yes')
   component.set("v.rsaFlag", true);
  else
   component.set("v.rsaFlag", false);

  var list = ["firstName", "lastName"];
  for (var i = 0; i < list.length; i++) {
   component.find(list[i]).set("v.disabled", true);
  }
  lead.Permanent_Line_1_New__c = newLead.Permanent_Line_1_New__c || lead.Permanent_Line_1_New__c;
  lead.Address_Line_2_New__c = newLead.Address_Line_2_New__c || lead.Address_Line_2_New__c;
  lead.Permanent_Address_3__c = newLead.Permanent_Address_3__c || lead.Permanent_Address_3__c;
  //POS YK e
     //Bug 24927 S
     lead.Resi_Address_Changed__c = newLead.Resi_Address_Changed__c || lead.Resi_Address_Changed__c;
     console.log('tespankaj'+lead.Resi_Address_Changed__c);
     //Bug 24927 E
  if (newLead.SBS_Branch__r) {
   component.set("v.branchSearchKeyword", newLead.SBS_Branch__r.Name);
   var selectedBranch = component.get("v.selectedBranch");
   selectedBranch.Id = newLead.SBS_Branch__c;
   selectedBranch.Name = newLead.SBS_Branch__r.Name;
   component.set("v.selectedBranch", selectedBranch);
  }
  //Bug 24927-24716 GCO-ckyc address change S
        lead.CKYC_No__c = newLead.CKYC_No__c || lead.CKYC_No__c;
        console.log('lead.CKYC_No__c'+lead.CKYC_No__c);
        if(!$A.util.isEmpty(lead.CKYC_No__c) && !$A.util.isUndefined(lead.CKYC_No__c)){
            component.set("v.addrChangeToggleCKYC",true);
            if((!$A.util.isEmpty(component.get("v.isResidenceAddressChanged")) && component.get("v.isResidenceAddressChanged")==true) || (!$A.util.isEmpty(component.get("v.lead.Resi_Address_Changed__c")) && component.get("v.lead.Resi_Address_Changed__c") == true)){
                component.find("isResiAddrChanged").set("v.disabled", true);
                var list = ["residenceAddress", "residenceCity","pincode"];
                    for (var i = 0; i < list.length; i++) {
                        component.find(list[i]).set("v.disabled", false);
                    }
                console.log('inside if gco ckyc');
            }
            else{
                var list = ["residenceAddress", "residenceCity","pincode"];
                    for (var i = 0; i < list.length; i++) {
                        component.find(list[i]).set("v.disabled", true);
                        console.log('inside else gco ckyc');
                    }
            }
            
        }
        //Bug 24927-24716 GCO-ckyc address change E
        debugger;
  component.set("v.lead", lead);
  component.set("v.residenceAddress", lead.Residence_Address_Line1__c + lead.Residence_Address_Line2__c + lead.Residence_Address_Line3__c);
  //YK POS s
  component.set("v.permanentAddress", lead.Permanent_Line_1_New__c + lead.Address_Line_2_New__c + lead.Permanent_Address_3__c);
  component.set("v.permanentCitySearchKeyword", lead.Per_City__c);
  //YK POS e
  component.set("v.residenceCitySearchKeyword", lead.Resi_City__c);
 
    

 },
 setPOData: function(component, newPO) {
  var po = component.get("v.po");
  
     
  console.log('Post_Graduate_Super_Specialist_Experienc__c'+newPO.Post_Graduate_Super_Specialist_Experienc__c);
  po.Id = newPO.Id || po.Id;
  //Bug 23801 S
  po.Ref__c=newPO.Ref__c || po.Ref__c; 
  //Bug 23801 E
  po.Lead__c = newPO.Lead__c || po.Lead__c;
  po.Product_Offering_Converted__c = newPO.Product_Offering_Converted__c || po.Product_Offering_Converted__c;   
   // Bug Id : 22896  --Prod issue start
      if(po.Product_Offering_Converted__c == false )
         {
            console.log('calling checktat master for prod issue '  + po.Lead__c);
                component.set("v.spinnerFlag", "true");
                this.executeApex(component, "checkTatMaster", {
                     "leadId": po.Lead__c
                }, function(error, result) {
                    if (!error && result) {
                    component.set("v.spinnerFlag", "false");
                } else {
                    component.set("v.spinnerFlag", "false");
                }
  		    });      
        
        }      
     // Bug Id : 22896 --Prod issue end 
     // 
  // CC Code changes SME S
        po.Card_limit__c = newPO.Card_limit__c || po.Card_limit__c;
        po.Credit_Card_Type__c = newPO.Credit_Card_Type__c || po.Credit_Card_Type__c;
  // CC Code changes SME E
  po.Practice_Type__c = newPO.Practice_Type__c || po.Practice_Type__c;
  po.Specialisation__c = newPO.Specialisation__c || po.Specialisation__c;
  po.Sourcing_Channel__c = newPO.Sourcing_Channel__c || po.Sourcing_Channel__c;
  // 24th Jan 2019 prod issue to avoid Post_Graduate_Super_Specialist_Experienc__c with 0 error S
  if(newPO.Total_Employment_Vintage__c!=undefined && newPO.Total_Employment_Vintage__c!=null)
  {
	po.Total_Employment_Vintage__c = '' + newPO.Total_Employment_Vintage__c ;      
  }
  else if(po.Total_Employment_Vintage__c!=undefined && po.Total_Employment_Vintage__c!=null)
  {
   	po.Total_Employment_Vintage__c = '' + po.Total_Employment_Vintage__c;      
  }  	 
  if(newPO.Post_Graduate_Super_Specialist_Experienc__c!=undefined && newPO.Post_Graduate_Super_Specialist_Experienc__c!=null)
  {
  	po.Post_Graduate_Super_Specialist_Experienc__c = '' + newPO.Post_Graduate_Super_Specialist_Experienc__c ; 
  }
  else
  {
  	po.Post_Graduate_Super_Specialist_Experienc__c = '' + po.Post_Graduate_Super_Specialist_Experienc__c;  
  }
 // 24th Jan 2019 prod issue to avoid Post_Graduate_Super_Specialist_Experienc__c with 0 error E
 console.log('po.Degree__c-->'+newPO.Degree__c);
  po.Degree__c = newPO.Degree__c || po.Degree__c; // bug 14509
  po.Product_Offering_Type1__c = newPO.Product_Offering_Type1__c || po.Product_Offering_Type1__c; // Bug 15353
  po.Products__c = newPO.Products__c || po.Products__c; //	Bug 15353
  po.Process_Master__c = newPO.Process_Master__c || po.Process_Master__c;
  //18158 STRAT
  po.COP_Date__c = newPO.COP_Date__c || po.COP_Date__c;
 //18158 END
     //Bug 24927 S
     po.Medical_registration_No__c = newPO.Medical_registration_No__c || po.Medical_registration_No__c;
     po.Campaign_Type__c = newPO.Campaign_Type__c || po.Campaign_Type__c;
     if(!$A.util.isEmpty(po.Campaign_Type__c)){
         var GCOCampaignList =  component.get("v.GCOCampaignList");
         if(!$A.util.isEmpty(GCOCampaignList) && GCOCampaignList.includes(po.Campaign_Type__c)){
             component.set("v.isGCOCampaign",'true');
             console.log('component.get("v.lead.Resi_Address_Changed__c")t'+component.get("v.lead.Resi_Address_Changed__c"));
             if(component.get("v.isResidenceAddressChanged")==true || component.get("v.lead.Resi_Address_Changed__c") == true){
                 component.find("isResiAddrChanged").set("v.disabled", true);
             }else{
                 var list = ["residenceAddress", "residenceCity","pincode"];
                 for (var i = 0; i < list.length; i++) {
                     component.find(list[i]).set("v.disabled", true);
                 } 
             }
             
         }
         else	// Below is required when we submit GCO case and it becomes NON GCO.
         {
             component.set("v.isGCOCampaign",'false');
             var list = ["residenceAddress", "residenceCity","pincode"];
             for (var i = 0; i < list.length; i++) {
                 component.find(list[i]).set("v.disabled", false);
             }
         }  
     }
     
     //Bug 24927 E

  //Bug 16207 - January 2018 BRD - Engineering program in mobility
  po.Resi_Pick_City__c = newPO.Resi_Pick_City__c || po.Resi_Pick_City__c;
  component.set("v.collegeCitySearchKeyword", po.Resi_Pick_City__c);
  po.UTM_Source__c = newPO.UTM_Source__c || po.UTM_Source__c;
  po.TypeOfDegreeforCA_Architect__c = newPO.TypeOfDegreeforCA_Architect__c || po.TypeOfDegreeforCA_Architect__c;
  if (newPO.Sector_Industry__r) {
   component.set("v.collegeDoctorSearchKeyword", newPO.Sector_Industry__r.Name);
   component.set("v.collegeSearchKeyword", newPO.Sector_Industry__r.Name);
   var selectedCollege = component.get("v.selectedCollege");
   selectedCollege.Id = newPO.Sector_Industry__c;
   selectedCollege.Name = newPO.Sector_Industry__r.Name;
   component.set("v.selectedCollege", selectedCollege);
  }
  //Bug 16207 - January 2018 BRD - Engineering program in mobility

  // Bug 13675 S - Hemant Keni
  //  if(newPO.Specialisation__c == 'CA' || newPO.Specialisation__c == 'CS' || newPO.Specialisation__c == 'CWA') // Bug 15858 - December_2017_CS/CWA Program start
  //     component.set("v.monthlyObligation", newPO.Monthly_Obligation_From_PO__c);
  // else if(newPO.Specialisation__c)
  //         //   component.set("v.monthlyObligation", newPO.Monthly_Obligation__c);



  // Bug 13675 E - Hemant Keni
  if (newPO.Sourcing_Channel__r) {
   var sourcingChannel = newPO.Sourcing_Channel__r.Name;
   if (newPO.Sourcing_Channel__r.FinnOne_Code__c) {
    sourcingChannel += ' - ' + newPO.Sourcing_Channel__r.FinnOne_Code__c;
   }
   if (newPO.Sourcing_Channel__r.Branch__r) {
    sourcingChannel += ' - ' + newPO.Sourcing_Channel__r.Branch__r.Name;
   }
   component.set("v.sourceSearchKeyword", sourcingChannel);
   var selectedSource = component.get("v.selectedSource");
   selectedSource.Id = newPO.Sourcing_Channel__c;
   selectedSource.Name = newPO.Sourcing_Channel__r.Name;
   selectedSource.FinnOne_Code__c = newPO.Sourcing_Channel__r.FinnOne_Code__c;
   selectedSource.Branch__c = newPO.Sourcing_Channel__r.Branch__c;
   //Bug 24237 S
   debugger;
   var listOfBranchs = component.get("v.listOfBranch");
   if(listOfBranchs.includes(newPO.Sourcing_Channel__r.Branch_Name__c.toUpperCase())){ //.toUpperCase()
		component.set("v.sourcingVaildationFlag","true");
   }
   component.set("v.SourcingEmpId",newPO.Sourcing_Channel__r.PSF_Employee_ID__c);
   selectedSource.PSF_Employee_ID__c = newPO.Sourcing_Channel__r.PSF_Employee_ID__c;     
   //Bug 24237 E   
   component.set("v.selectedSource", selectedSource);
  }
  //Added by Rohan on 31-05-2018
  po.Total_work_experience__c = '' + (newPO.Total_work_experience__c || po.Total_work_experience__c);
  po.Experience_in_Years__c = '' + (newPO.Experience_in_Years__c || po.Experience_in_Years__c);
     // Bug 24927 S
     this.setOldPO_GCO_Data(component);
     // Bug 24927 E
     // Added by PSL 28 Sept
  var lead = component.get("v.lead");
  if (lead != undefined && lead != null) {
   var poId = (po.Id == null ? (newpo.Id == null ? null : newpo.Id) : po.Id);
   lead.Recent_PO_for_cibil_requested__c = poId;
   component.set("v.lead", lead);
  }
  component.set("v.po", po);
  //Bug 24716 ID Start 
        if(!$A.util.isEmpty(component.get("v.ckycResp")))
        {
        	console.log('here it is');
            this.setCkycFieldsafterGrab(component);
            this.createCkycSOL(component);
        } else {// US : 13265 S
            if (!$A.util.isEmpty(component.get("v.ckycSearch")) || !$A.util.isEmpty(component.get("v.downResponse"))) {
                this.createCkycSearchSOL(component);
            }
        } // US : 13265 E
        //Bug 24716 ID End
 },
 setOfferDetails: function(component, offer) {
  component.set("v.offer", offer);

  /*component.set("v.cibilScore", offer.cibilScore);
  component.set("v.offerAmount", offer.offerAmount);
  component.set("v.segmentation", offer.segmentation);
  component.set("v.LAN", offer.loanNumber);*/

 },
 setOldLeadData: function(component) {
  var lead = component.get("v.lead");
  var oldLead = component.get("v.oldLead") || {};
  oldLead.FirstName = lead.FirstName;
  oldLead.LastName = lead.LastName;
  oldLead.MobilePhone = lead.MobilePhone;
  oldLead.PAN__c = lead.PAN__c;
  oldLead.DOB__c = lead.DOB__c; // Bug 14716 
  oldLead.Resi_Pin_Code__c = lead.Resi_Pin_Code__c;
  oldLead.Resi_City__c = lead.Resi_City__c;
  component.set("v.oldLead", oldLead);

 },
    // Bug 24927 S for Fetching OLD GCO Impacted field values
    setOldPO_GCO_Data: function(component) {
        var po = component.get("v.po");
        var oldPO_GCO = component.get("v.oldPO_GCO") || {};
        console.log('po val in gco'+JSON.stringify(po));
        oldPO_GCO.Specialisation__c = po.Specialisation__c;
        oldPO_GCO.Degree__c = po.Degree__c;
        //oldPO_GCO.COP_Date__c = po.COP_Date__c; //8595 vikas 
        oldPO_GCO.Practice_Type__c = po.Practice_Type__c;
        oldPO_GCO.Medical_registration_No__c = po.Medical_registration_No__c;
        oldPO_GCO.TypeOfDegreeforCA_Architect__c = po.TypeOfDegreeforCA_Architect__c;
        component.set("v.oldPO_GCO", oldPO_GCO);
        console.log('oldPO_GCO'+JSON.stringify(component.get("v.oldPO_GCO")));
        
    },
    // Bug 24927 E
 isRetriggerRequired: function(component) {
  var lead = component.get("v.lead");
  var oldLead = component.get("v.oldLead");
  if (lead && oldLead && oldLead.FirstName) {
   // Bug 14716 - removed pan condition 
   return (oldLead.FirstName !== lead.FirstName ||
    oldLead.LastName !== lead.LastName ||
    oldLead.MobilePhone !== lead.MobilePhone
   );
  }
  return false;
 },
 //Bug 14716 S
 isRetriggerCIBIL: function(component) {
  var lead = component.get("v.lead");
  var oldLead = component.get("v.oldLead");
  if (lead && oldLead && oldLead.FirstName) {

   //16221: Added by Rohan for Address change to be added in Cibil Re-Trigger cases

   var isRetrigger = (oldLead.FirstName !== lead.FirstName ||
    oldLead.LastName !== lead.LastName ||
    oldLead.MobilePhone !== lead.MobilePhone ||
    oldLead.PAN__c !== lead.PAN__c ||
    oldLead.DOB__c !== lead.DOB__c ||
    oldLead.Resi_Pin_Code__c !== lead.Resi_Pin_Code__c ||
    oldLead.Resi_City__c !== lead.Resi_City__c
   );

   return isRetrigger;
  }
  return false;
 },
 // Bug 14716  E 
 isRetriggerDEDUPE: function(component) {
  var lead = component.get("v.lead");
  var oldLead = component.get("v.oldLead");
  if (lead && oldLead && oldLead.FirstName) {


   var isRetrigger = (oldLead.FirstName !== lead.FirstName ||
    oldLead.LastName !== lead.LastName ||
    oldLead.MobilePhone !== lead.MobilePhone ||
    oldLead.PAN__c !== lead.PAN__c ||
    oldLead.DOB__c !== lead.DOB__c
   );
   //(oldLead.FirstName !== lead.FirstName || 
   // oldLead.LastName !== lead.LastName || 
   //  oldLead.PAN__c !== lead.PAN__c //|| 
   //  oldLead.Resi_City__c !== lead.Resi_City__c ||
   // oldLead.Residence_Address_Line1__c !== lead.Residence_Address_Line1__c ||
   //  oldLead.Residence_Address_Line2__c !== lead.Residence_Address_Line2__c ||
   //   oldLead.Residence_Address_Line3__c !== lead.Residence_Address_Line3__c
   // );

   return isRetrigger;
  }
  return false;
 },
    //Bug 24927 S 
    EnableAddressFields: function(component) {
        var list = ["residenceAddress", "residenceCity","pincode"];
        for (var i = 0; i < list.length; i++) {
            component.find(list[i]).set("v.disabled", false);
        }
        component.set("v.lead.Resi_Address_Changed__c",true);
        component.find("isResiAddrChanged").set("v.disabled", true);
    },
    //Bug 24927 E
 setResidenceAddress: function(component) {
  var lead = component.get("v.lead");
  var residenceAddress = component.get("v.residenceAddress");
  if (residenceAddress) {
   var totalLength = residenceAddress.length;
   var length = totalLength / 3;
   if (totalLength > 120) {
    residenceAddress = residenceAddress.substring(0, 120);
    length = 40;
   }
   lead.Residence_Address_Line1__c = residenceAddress.substring(0, length);
   lead.Residence_Address_Line2__c = residenceAddress.substring(length, length * 2);
   lead.Residence_Address_Line3__c = residenceAddress.substring(length * 2, totalLength);
  } else {
   lead.Residence_Address_Line1__c = lead.Residence_Address_Line2__c = lead.Residence_Address_Line3__c = '';
  }
  this.setPermanentAddress(component);
 },

 //POS YK s
 setPermanentAddress: function(component) {
  var lead = component.get("v.lead");
  var permanentAddress = component.get("v.permanentAddress");
  if (permanentAddress) {
   var totalLength = permanentAddress.length;
   var length = totalLength / 3;
   if (totalLength > 120) {
    permanentAddress = permanentAddress.substring(0, 120);
    length = 40;
   }
   lead.Permanent_Line_1_New__c = permanentAddress.substring(0, length);
   lead.Address_Line_2_New__c = permanentAddress.substring(length, length * 2);
   lead.Permanent_Address_3__c = permanentAddress.substring(length * 2, totalLength);
  } else {
   lead.Permanent_Line_1_New__c = lead.Address_Line_2_New__c = lead.Permanent_Address_3__c = '';
  }

 },

 copyPermanentAddr: function(component, event) {

  if (component.get("v.lead.Is_Permanent_Resi_Addr_Different__c") == false || component.get("v.lead.Is_Permanent_Resi_Addr_Different__c") == undefined) {
   var resiAddr = component.get("v.residenceAddress");
   component.set("v.permanentAddress", resiAddr);
   var resiCity = component.get("v.lead.Resi_City__c")
   component.set("v.lead.Per_City__c", resiCity);
   component.set("v.permanentCitySearchKeyword", resiCity);
   var resiPIN = component.get("v.lead.Resi_Pin_Code__c");
   component.set("v.lead.Per_Pin_Code__c", resiPIN);

   // $("#permanentAddress").slideToggle();
   // $("#permanentCity").slideToggle();
   //  $("#permPincode").slideToggle();
  } else {
   // $("#permanentAddress").slideToggle();
   // $("#permanentCity").slideToggle();
   // $("#permPincode").slideToggle();
  }
 },
 //POS YK e

 validateLeadInputData: function(component) {
  var lead = component.get("v.lead");
  var isEmpty, isValid = true;
  var lst = [{
    value: lead.Email,
    auraId: "email",
    message: "Enter Email Address"
   },
   {
    value: lead.PAN__c,
    auraId: "pannumber",
    message: "Enter PAN Number"
   },
   {
    value: lead.DOB__c,
    auraId: "dateOfBirth",
    message: "Enter Date of Birth"
   },
   {
    value: lead.Resi_Pin_Code__c,
    auraId: "pincode",
    message: "Enter Pin Code"
   },
   {
    value: lead.Resi_City__c,
    auraId: "residenceCity",
    message: "Enter Residence City"
   },
   {
    value: component.get("v.po.Practice_Type__c"),
    auraId: "practiceType",
    message: "Select Practice Type"
   },
   {
    value: lead.Residence_Address_Line1__c,
    auraId: "residenceAddress",
    message: "Enter Residence Address"
   },
   {
    value: lead.Residence_Address_Line2__c,
    auraId: "residenceAddress",
    message: "Enter Residence Address"
   },
   {
    value: lead.Residence_Address_Line3__c,
    auraId: "residenceAddress",
    message: "Enter Residence Address"
   },
   {
    value: lead.MobilePhone,
    auraId: "mobileNumber",
    message: "Enter Mobile Number"
   }, // 18493

  ];
  // bug 14509 - RDL Mobility s
  if (component.get("v.productFlow") === 'RDL') {
   lst.push({
    value: component.get("v.po.Degree__c"),
    auraId: "degree",
    message: "Select Degree"
   });
  }
  // bug 14509 - RDL Mobility E

  //Bug 16207 - January 2018 BRD - Engineering program in mobility Rajesh
  if (component.find("profession").get("v.value") == 'Engineers') {
   lst.push({
    value: component.get("v.selectedCollege"),
    auraId: "collegeName",
    message: "Enter College Name"
   });
   lst.push({
    value: component.get("v.po.Resi_Pick_City__c"),
    auraId: "collegeCity",
    message: "Enter College City"
   });
   lst.push({
    value: component.get("v.po.TypeOfDegreeforCA_Architect__c"),
    auraId: "highestDegreeType",
    message: "Select Highest Degree Type"
   });
  }
  //Bug 16207 - January 2018 BRD - Engineering program in mobility Rajesh

  //POS YK s
  // Bug 25272  added null checks here for 24927
  if(!$A.util.isEmpty(component.get("v.lead")) && !$A.util.isEmpty(component.get("v.lead").Profession_Type__c)  && component.get("v.lead").Profession_Type__c == 'Doctor')
  {
      lst.push({
      value: component.get("v.lead.Medical_Council__c"),
      auraId: "medicalCouncil",
      message: "Enter Medical Council"
      });
   lst.push({
    value: component.get("v.po.Degree__c"),
    auraId: "degreeProspect",
    message: "Select Degree"
   });
   if (component.get("v.incFieldVisibility") == false) {// US : 19995
                       lst.push({
                   value:lead.Annual_Individual_Income_in_Lacs__c ,
                   auraId:"annualincome",
                   message :"Enter Annual Income"
                   });  
				   }
                  var RegNumbrFamily =component.get("v.MandatoryFamilyRegistration");    
                   console.log('RegNumbrFamily',RegNumbrFamily);
                   debugger;
                   if(RegNumbrFamily === true){
                   console.log('inside MandatoryFamilyRegistration');
                   lst.push({
                   value: lead.Family_Member_Reg_No__c,
                   auraId: "membershipNoFamily",
                   message: "Enter Family Member Reg. No"
                   });
                   }else{
                    if (component.find("membershipNoFamily")) { //added by sneha  
                     component.find("membershipNoFamily").set("v.errors","");
                    }
                   }
				   if (component.get("v.incFieldVisibility") == false) {// US : 19995
                   console.log('component.get("v.hospitalSearchKeyword")',component.get("v.hospitalSearchKeyword"));
                   lst.push({
                   value: component.get("v.hospitalSearchKeyword"),
                   auraId: "hospitalOfconst",
                   message: "Enter Hospital Of Consultancy"
                   });
                   lst.push({
                   value: lead.Annual_Individual_Income_in_Lacs__c,
                   auraId: "annualincome",
                   message: "Enter Annual Income"
                  });
				  }
                   lst.push({
                   value: component.get("v.collegeDoctorSearchKeyword"),
                   auraId: "collegeName1",
                   message: "Enter College Name"
                   });         
   lst.push({
    value: component.get("v.po.COP_Date__c"),
    auraId: "dateOfRegistration",
    message: "Enter Registration Date"
   });
  }
  lst.push({
   value: component.get("v.lead.Profession_Type__c"),
   auraId: "profession",
   message: "Select Segment Type"
  });
  lst.push({
   value: component.get("v.po.Specialisation__c"),
   auraId: "specialization",
   message: "Select Specialization"
  });
  if (component.find("profession").get("v.value") == 'Engineers')
   lst.push({
    value: component.get("v.po.Total_Employment_Vintage__c"),
    auraId: "practiceExperience",
    message: "Select Business Vintage"
   });
  //   else
  //	lst.push({value: component.get("v.po.Total_Employment_Vintage__c"), auraId: "practiceExperience", message: "Select Practice Experience"});

  if (component.find("profession").get("v.value") == 'Engineers')
   lst.push({
    value: component.get("v.po.Post_Graduate_Super_Specialist_Experienc__c"),
    auraId: "postGradExperience",
    message: " Select Post Qualification Experience"
   });
  else
   lst.push({
    value: component.get("v.po.Post_Graduate_Super_Specialist_Experienc__c"),
    auraId: "postGradExperience",
    message: "Select Post Graduate Experience"
   });
  //  lst.push({value: component.get("v.monthlyObligation"), auraId: "obligations", message: "Enter Monthly Obligation"});
  lst.push({
   value: component.get("v.residenceAddress"),
   auraId: "residenceAddress",
   message: "Enter Residence Address"
  }); // bug-18030
  lst.push({
   value: component.get("v.lead.Resi_City__c"),
   auraId: "residenceCity",
   message: "Enter Residence City"
  });
  lst.push({
   value: component.get("v.lead.Resi_Pin_Code__c"),
   auraId: "pincode",
   message: "Enter Pin Code"
  });
  lst.push({
   value: component.get("v.lead.Residential_type__c"),
   auraId: "residentialType",
   message: "Enter Residential Type"
  });
  lst.push({
   value: component.get("v.po.Sourcing_Channel__c"),
   auraId: "sourceName",
   message: "Enter Sourcing Channel"
  });
  lst.push({
   value: component.get("v.lead.DOB__c"),
   auraId: "dateOfBirth",
   message: "Enter Date of Birth"
  });
  lst.push({
   value: component.get("v.lead.Salutation"),
   auraId: "Salutation",
   message: "Select Salutation"
  });

  //POS YK e
  // Bug 25272  added null checks here for 24927
             if(!$A.util.isEmpty(component.get("v.lead")) && !$A.util.isEmpty(component.get("v.lead").Profession_Type__c) && component.get("v.lead").Profession_Type__c == 'Doctor'|| component.get("v.lead").Profession_Type__c == 'CA'){ //Aded by sneha
             
             lst.push({value: component.get("v.po.COP_Date__c"), auraId: "dateOfRegistration", message: "Enter Registration Date"});
             }
             
  for (var i = 0; i < lst.length; i++) {
   isEmpty = this.isEmpty(lst[i].value);

   isValid = isValid && !isEmpty;
   this.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
  }






  //isValid = isValid && this.checkLocation(component,helper);

debugger;
  return isValid;
 },
 validateField: function(component, key, pattern, error) {
  var field = component.find(key);
  var value = '' + field.get("v.value");

  // Bug 14908 S
  var valid = true;
  if (key === 'firstName')
   valid = !!(value == '' || pattern.test(value));
  else
   valid = !!(value == '' || pattern.test(value.trim()));

  //var valid = !!(value == '' || pattern.test(value.trim()));
  // Bug 14908 E
  //alert('valid ---->> '+valid+' field--->> '+field);
  field.set("v.errors", [{
   message: valid ? "" : "Enter a valid " + error
  }]);


  return valid;
 },
 validateMobileNumber: function(component) {
  component.set("v.lead.MobilePhone", ('' + component.get("v.lead.MobilePhone")).replace(/[a-zA-z]/g, ''));
  if (this.validateField(component, "mobileNumber", /^[6-9]\d{9}/, "Mobile Number") != true) {
   component.find("smsSendId").set("v.disabled", true);
   component.set("v.isvalidmobile", false);

  } else {
   component.find("smsSendId").set("v.disabled", false);
   component.set("v.isvalidmobile", true);
  }
  //22141 S
  component.set("v.MobileValidationResult",''); 
  //22141 E
  return this.validateField(component, "mobileNumber", /^[6-9]\d{9}/, "Mobile Number"); //Vikas 18593
 },
 validateEmail: function(component) {
  var pattern = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return this.validateField(component, "email", pattern, "Email");
 },
 validatePIN: function(component) {

  component.set("v.lead.Resi_Pin_Code__c", component.get("v.lead.Resi_Pin_Code__c").replace(/[a-zA-z]/g, ''));
  return this.validateField(component, "pincode", /^[1-9]\d{5}$/, "Pin Code");

 },
 validatePAN: function(component) {
  component.set("v.lead.PAN__c", (component.get("v.lead.PAN__c") || "").toUpperCase());
  return this.validateField(component, "pannumber", /[A-Za-z]{5}\d{4}[A-Za-z]{1}/, "PAN number");
 },
 validateName: function(component, key, error) {
  var regex;
  // Bug 14908 S
  if (key === 'firstName')
   return this.validateField(component, key, /^[A-Za-z]{1,100}$/, error);
  else
   return this.validateField(component, key, /^[a-zA-z]+([ ][a-zA-Z]+)*$/, error);
  // Bug 14908 E
 },
 validateFirstName: function(component) {
  return this.validateName(component, "firstName", "First Name");
 },
 validateLastName: function(component) {
  return this.validateName(component, "lastName", "Last Name");
 },
 validateAddress: function(component) {
  return this.validateField(component, "residenceAddress", /^.{9,}$/, "Residence Address");
 },
 // Bug 13675 S - hemant Keni
 //  validateObligation : function(component){
 //      component.set("v.monthlyObligation", (''+component.get("v.monthlyObligation")).replace(/[a-zA-z]/g, ''));
 //      return this.validateField(component, "obligations", /^[0-9]{1,10}$/, "Monthly obligations");
 //  },
 // Bug 13675 E - hemant Keni
 //PSL changes : Nikhil Bugfix #11805, #11806
 validateDOB: function(component) {
 debugger;
  var dob = new Date(component.get('v.lead').DOB__c).getTime();
  if (isNaN(dob)) return true;
  var dtToday = (new Date()).getTime();
  var timeDiff = dtToday - dob;
  // Bug 15381 S - Hemant Keni
  var diffDays = (timeDiff / (1000 * 3600 * 24 * 365.25)).toFixed(3);
  var result = this.isEmpty(dob) || (diffDays > 23.999 && diffDays <= 72.00);
  // Bug 15381 E - Hemant Keni
  var errorstr = result ? "" : "Your age should be greater than 24 and less than 72";
 	console.log('component.find("dateOfBirth")'+component.find("dateOfBirth"));
  if (component.find("dateOfBirth") != undefined) { // Bug Id : 24716
  component.find("dateOfBirth").set("v.errors", [{
   message: errorstr
  }]);
  } else {
      component.find("dateOfBirthRead").set("v.errors", [{
          message: errorstr
      }]);
  }
  debugger;
  // component.find("sourceName").set("v.errors", [{message: result ? "" : "Please select a valid Sourcing Channel"}]);
  return result;
 },

 validateDORWithDOB: function(component) {
  var DOR = component.get("v.po.COP_Date__c");
  var DOB = (component.get("v.lead.DOB__c"));
  console.log('dob' + DOB + 'DOR' + DOR);
  if (DOB != '' && DOR != '') {
   var result = DOR > DOB
   console.log('dob validation' + result);
   var errorstr = result ? "" : "Please select Date of Registration greater than DOB";
   component.find("dateOfRegistration").set("v.errors", [{
    message: errorstr
   }]);

  }
 },

 validateMedicalCouncil: function(component) {
  return this.validateField(component, "medicalCouncil", /^[A-Za-z]{1,100}$/, "Medical Council");
 },
 checkLocation: function(component, helper) {
  var lead = component.get("v.lead");

  if (this.isEmpty(lead.Off_Pin_Code__c) || this.isEmpty(lead.CheckINLocationAddress__c)) {

   navigator.geolocation.getCurrentPosition(function(position) {
     helper.fetchOfficeAddress(component, helper);
    },
    function(error) {
     if (error.code == error.PERMISSION_DENIED) {

      helper.showToast(component, "Error!", "Please Turn on your Device Location. ", "error");
      return false;
     }
    });


  }
  return true
 },
 validate: function(component, helper) {

  var isValid = true,
   result;

  result = this.validateFirstName(component);
  isValid = isValid && result;
  result = this.validateLastName(component);
  isValid = isValid && result;
  result = this.validateMobileNumber(component);
  isValid = isValid && result;
  result = this.validateEmail(component);
  isValid = isValid && result;
  result = this.validatePAN(component);
  isValid = isValid && result;
  result = this.validatePIN(component);
  isValid = isValid && result;
  //PSL changes : Nikhil Bugfix #11805, #11806


  result = this.validateAddress(component);
  isValid = isValid && result;
  /*
        if(component.get("v.lead").Profession_Type__c == 'Doctor')
        {
            
            result = this.validateMedicalCouncil(component);
        	isValid = isValid && result;
            alert('isValid====>> '+isValid);
            
            if(component.find("medicalCouncil")){
                result = component.get("v.lead").Medical_Council__c !== '';
                component.find("medicalCouncil").set("v.errors", [{message: result ? "" : "Please enter medical council"}]);
                isValid = isValid && result;
                alert('isValid==medicalCouncil==>> '+isValid);
    		}
        }
        */
  //PSL changes : Nikhil Bugfix #11765
  ////added by gopika 
 if(component.get("v.lead").Profession_Type__c == 'Doctor' && component.get("v.incFieldVisibility") == false)// US : 19995
        {
    		console.log('component.get("v.annualincome")',component.find("annualincome").get("v.value"));
			if(component.find("annualincome").get("v.value") && isNaN(component.find("annualincome").get("v.value"))){
          		result = false;
                component.find("annualincome").set("v.errors",[{message: result ? "" : "Please Enter Number Only !"}]);
         		isValid = isValid && result;
        	}
		}

  result = !(component.get("v.sourceSearchKeyword") !== '' && component.get("v.selectedSource").Id == undefined);
  component.find("sourceName").set("v.errors", [{
   message: result ? "" : "Please select a valid Sourcing Channel"
  }]);
  isValid = isValid && result;
     
 //BugId 24237 S    
  if(result)
  {
   	console.log('currentUserEmpId'+component.get("v.currentUserEmpId") +'SourcingEmpId'+component.get("v.SourcingEmpId"));
    if(!$A.util.isEmpty(component.find("sourceName").get("v.value"))){
            if(component.get("v.sourcingVaildationFlag")=="true"){
            debugger;
        	result = (component.get("v.currentUserEmpId") === component.get("v.SourcingEmpId"));
        	component.find("sourceName").set("v.errors", [{message: result ? "" : "Selected Sourcing Channel is not associated with your User ID !"}]);
        	isValid = isValid && result; 
        }
    	
    }
            
 }
        
 //BugId 24237 E  
  var lead = component.get("v.lead");





  // if((this.isEmpty(lead.Lead_Office_Address_Line1__c) && this.isEmpty(lead.Lead_Office_Address_Line2__c) && this.isEmpty(lead.Lead_Office_Address_Line3__c)) || this.isEmpty(lead.Off_Pin_Code__c || this.isEmpty(lead.CheckINLocationAddress__c)) )
  //if((this.isEmpty(lead.Lead_Office_Address_Line1__c) && this.isEmpty(lead.Lead_Office_Address_Line2__c) && this.isEmpty(lead.Lead_Office_Address_Line3__c)) || this.isEmpty(lead.Off_Pin_Code__c || this.isEmpty(lead.CheckINLocationAddress__c)) )

  console.log(lead.Off_Pin_Code__c + 'pincode and address' + lead.CheckINLocationAddress__c);
  //if(this.isEmpty(lead.Off_Pin_Code__c) || this.isEmpty(lead.CheckINLocationAddress__c)) 
  //{
  //   this.showToast(component, "Error!", "Please turn on your Device Location!", "error");
  //  return false;
  // }


  if (isValid) {
   debugger;
   this.validateLeadInputData(component);
  }
  result = this.validateDOB(component);
  debugger;
  // if(!result)
  //  component.find("dateOfBirth").set("v.errors", [{message: result ? "" : "Your age should be greater than 25 and less than 71"}]);
  isValid = isValid && result;

  //Practice Exp Vs Post Graduate Exp validation
 //Added for Segementation V2 Bug 23971 by GC
      var Firstdate = new Date(component.get("v.po.COP_Date__c"));
      console.log('First date',Firstdate);
           var today = new Date();
       console.log('After formatting Firstdate',Firstdate);
         console.log('datetoday',today);
    /* var data = (today-Firstdate)/86400000;
     data= data/30;
     data=(data/12).toFixed(3);*/
     console.log('Difference of date',(today-Firstdate));
     var data= ((today-Firstdate)/(1000 * 3600 * 24 * 365.25)).toFixed(3);                                                  
     console.log('Months between',data);   
              //Practice Exp Vs Post Graduate Exp validation
     var practiceExp = parseFloat(data);
  var postGrExp = parseInt(component.get("v.po.Post_Graduate_Super_Specialist_Experienc__c"));
  var IsEngineer = component.find("profession").get("v.value")
  if (IsEngineer != 'Engineers') {
   if (isNaN(practiceExp) || isNaN(postGrExp))
    result = true;
   else
    result = component.get("v.productFlow") === 'RDL' ? (practiceExp >= postGrExp) : (practiceExp > postGrExp); // Bug 15550 - Hemant Keni


   


   component.find("postGradExperience").set("v.errors", [{
    message: result ? "" : component.find("profession").get("v.value") == 'Engineers' ? "Post Qualification Experience should always be less than Business Vintage" : "Post Graduate Experience should always be less than Practice Experience"
   }]);
   isValid = isValid && result;


  }



  /*
        result = !(component.get("v.branchSearchKeyword") !== '' && component.get("v.selectedBranch").Id == undefined);
        component.find("branchName").set("v.errors", [{message: result ? "" : "Please select a valid Branch"}]);
        isValid = isValid && result;
        
        if(component.find("collegeName")){
            result = !(component.get("v.collegeSearchKeyword") !== '' && component.get("v.selectedCollege").Id == undefined);
            component.find("collegeName").set("v.errors", [{message: result ? "" : "Please select a valid College"}]);
            isValid = isValid && result;
            console.log('isValid --444--->> '+isValid);
    	}
        */
debugger;
  return isValid;
 },//added for Bug 23971 Segmentation V2
 disableForm: function(component) {
  var list = [
   "firstName", "lastName", "mobileNumber", "email", "residenceAddress", "residenceCity",
   "pincode", "dateOfBirth", "specialization", "pannumber", "branchName", "sourceName",
   "practiceType", "practiceExperience", "postGradExperience", "residentialType", "Salutation",
   "membershipNo", "medicalCouncil", "isPermAddrDiff", "permanentAddress", "permanentCity",
   "permPincode", "profession", "degree", "collegeName", "collegeCity", "highestDegreeType",
   "rsaFlag", "submitButtonId", "dateOfRegistration", "degreeProspect", "nextButtonId",,"annualincome",
    "collegeName1","membershipNoFamily","hospitalOfconst"
  ];
  for (var i = 0; i < list.length; i++) {
   if (component.find(list[i]))
    component.find(list[i]).set("v.disabled", true);
  }
  component.find("submitButtonId").getElement().disabled = true;
  component.set("v.disablesms", "true");
  // Bug Id : 24716 S
        component.set("v.isReadOnlyCKYC", "true");
         // Bug Id : 24716 E
     // //Bug 24927
     if(component.find("isResiAddrChanged")){
         component.find("isResiAddrChanged").set("v.disabled", true);
     }
     


 },
 isEmpty: function(value) {
  return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
 },
 addRemoveInputError: function(component, key, message) {


  if (component.find(key)) { //added by sneha  
   component.find(key).set("v.errors", [{
    message: message ? ("Please " + message) : ""
   }]);
  }
 },
 toCamelCase: function(str) {
  return str[0].toUpperCase() + str.substring(1);
 },
 executeApex: function(component, method, params, callback) {
  var action = component.get("c." + method);
  action.setParams(params);
  //component.set("v.spinnerFlag","true");
  action.setCallback(this, function(response) {
   //component.set("v.spinnerFlag","false")
   var state = response.getState();
   if (state === "SUCCESS") {
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
    this.showToast(component, "Error!", errors.join(", "), "error");
    callback.call(this, errors, response.getReturnValue());
   }
  });
  $A.enqueueAction(action);
 },
 openCloseSearchResults: function(component, key, open) {
  var resultPanel = component.find(key + "SearchResult");
  $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
  $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
 },
 showHideMessage: function(component, key, show) {
  component.set("v.message", show ? 'No Result Found...' : '');
  this.showHideDiv(component, key + "Message", show);
 },
 showToast: function(component, title, message, type) {
  component.set("v.spinnerFlag", "false");
  var toastEvent = $A.get("e.force:showToast");
  if (toastEvent) {
   toastEvent.setParams({
    "title": title,
    "message": message,
    "type": type,
    "mode": "dismissible",
    "duration": "10000"
   });
   toastEvent.fire();
  } else {
   var toastTheme = component.find("toastTheme");
   $A.util.removeClass(toastTheme, "slds-theme--error");
   $A.util.removeClass(toastTheme, "slds-theme--success");
   if (type == 'error') {
    $A.util.addClass(toastTheme, "slds-theme--error");
   } else if (type == 'success') {
    $A.util.addClass(toastTheme, "slds-theme--success");
   } else if (type == 'info') {
    $A.util.addClass(toastTheme, "slds-theme--info");
    //console.log('inside info condition');
   }

   component.find("toastText").set("v.value", message);
   component.find("toastTtitle").set("v.value", title + ' ');
   this.showHideDiv(component, "customToast", true);
  }
 },
 closeToast: function(component) {
  var toastTheme = component.find("toastTheme");
  $A.util.removeClass(toastTheme, "slds-theme--error");
  $A.util.removeClass(toastTheme, "slds-theme--success");
  this.showHideDiv(component, "customToast", false);
 },
 showSpinner: function(component) {
  this.showHideDiv(component, "waiting", true);
 },
 hideSpinner: function(component) {
  this.showHideDiv(component, "waiting", false);
 },
 showHideDiv: function(component, divId, show) {
  if (divId !== "nextButtonId") {
   $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
  }
  $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
 },
 setTimeout: function(callback, context, time, component) {
  window.setTimeout(
   $A.getCallback(function() {
    if (!component || component.isValid()) {
     callback.call(context || this, component);
    }
   }), time
  );
 },
 setRSAValue: function(component) {
  if (component.get("v.rsaFlag")) {
   component.get("v.lead").RSA_Flag__c = 'Yes';
  } else {
   component.get("v.lead").RSA_Flag__c = 'No';
  }
 },
     //added for bug id 21851 start
    getHideAadhaarSectionHelper:function(component)
    {

        var action = component.get("c.getHideAadhaarSection");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log('hide aadhaaar DSS>>>'+response.getReturnValue());
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
    },//added for bug id 21851 stop
//Added for Segementation V2 Bug 23971 by GC s
    setDoctorFamilyFlag: function(component) {
        console.log('DoctorFlag',component.get("v.DoctorFlag"));
        if (component.get("v.DoctorFlag")) {
            component.set("v.MandatoryFamilyRegistration",true);
            component.get("v.lead").Doctor_s_Family__c = 'Yes';
        } else {
            component.set("v.MandatoryFamilyRegistration",false);
            component.get("v.lead").Doctor_s_Family__c = 'No';
        }
        console.log('Value of MandatoryFamilyRegistration',component.get("v.MandatoryFamilyRegistration"));
    },
	setRunningHospitalFlag: function(component) {
        if (component.get("v.RunningHospitalFlag")) {
                    component.get("v.lead").Running_Hospital__c = 'Yes';
                } else {
                    component.get("v.lead").Running_Hospital__c = 'No';
                }
            
        },
            setFamilyHospitalflag:function(component){
                 component.get("v.lead").Doctor_s_Family__c = 'No';
                component.get("v.lead").Running_Hospital__c = 'No';
            },
//Added for Segementation V2 Bug 23971 by GC e
// Bug Id : 24716 start
    setCkycFields: function(component, event) {
        //this.showhidespinner(component, event, true);
        console.log('inside ckyc &&');
        component.set("v.isShow", false);
        component.set("v.spinnerFlag", "true");
		var respMap;var sRes=null;// US : 13265
        var respMap;
        debugger;
        if(!$A.util.isEmpty(event) ||  !$A.util.isUndefined(event)){
             respMap = event.getParam("infObj");
			 sRes = event.getParam("dSource");// US : 13265
        }
        else{
            respMap = component.get("v.ckycResp");
        }
        
        	//var months = {"Jan": "01","Feb": "02","Mar": "03","Apr": "04","May": "05","Jun": "06","Jul": "07","Aug": "08","Sep": "09","Oct": "10","Nov": "11","Dec": "12"};
       		var months = {"Jan":"01", "Feb":"02", "Mar":"03", "Apr":"04", "May":"05", "Jun":"06", "Jul":"07", "Aug":"08", "Sep":"09", "Oct":"10", "Nov":"11", "Dec":"12"};                

        if (!$A.util.isEmpty(respMap["CKYCDOB"]) ||  !$A.util.isUndefined(respMap["CKYCDOB"])) {
            var dobStr = respMap["CKYCDOB"].split("-");
            console.log('1 ckyc dob --> ' + dobStr[2] + ' : ' + dobStr[1] + ' : ' + dobStr[0]);
            console.log('date '+respMap["CKYCDOB"]);
             var mon = dobStr[1];
            if (dobStr[1].length > 2) {
               mon = months[dobStr[1]];
            }
            console.log('mon --> ' + mon);
            debugger;
            var modifedDob = dobStr[2]+ '-' + mon + '-' + dobStr[0];
            try { // Bug id : 25631 Ckyc bug
                var d = new Date(modifedDob);
                debugger;
                console.log('dobStr[2].length --> ' + dobStr[2].length);
                if (dobStr[2].length != 4) {
                    console.log('inside if modifedDob --> ' + modifedDob);
                    modifedDob = dobStr[0]+ '-' + mon + '-' + dobStr[2];
                }
                respMap["CKYCDOB"] = modifedDob;
            } catch (e) {
                console.log('execption of date --> ' + e);
                var dob1 = modifedDob.split("-");
                if (
                    !$A.util.isEmpty(dob1[0]) && !$A.util.isUndefined(dob1[0]) &&
                    !$A.util.isEmpty(dob1[1]) && !$A.util.isUndefined(dob1[1]) &&
                    !$A.util.isEmpty(dob1[2]) && !$A.util.isUndefined(dob1[2]) 
                ) {
                    debugger;
                    console.log('dob1[2] --> ' + dob1[2]);
                    modifedDob = dob1[2]+ '-' + dob1[1] + '-' + dob1[0];
                    respMap["CKYCDOB"] = modifedDob;
                }
                //respMap["CKYCDOB"] = null;
            } // Bug id : 25631 Ckyc bug
        }
        console.log('ckyc dob --> ' + respMap["CKYCDOB"]);
        console.log();
        if (respMap["CKYCOccupation"]) {
            var occMapping = {
                "B-01": "Business",
                "O-01": "Professional",
                "O-02": "Self Employed",
                "O-03": "Retired",
                "O-04": "Housewife",
                "O-05": "Others",
                "S-01": "Public Sector",
                "S-02": "Private Sector",
                "S-03": "Government Sector",
                "X-01": "Others"
            };
            var occupation = respMap["CKYCOccupation"];
            respMap["CKYCOccupation"] = occMapping[occupation];
        }
        if (respMap["CKYCMaritalStatus"]) {
            var marMapp = {
                "01": "Married",
                "02": "Single",
                "03": "Others"
            }
            var marStatus = respMap["CKYCMaritalStatus"];
            respMap["CKYCMaritalStatus"] = marMapp[marStatus];
        }
        respMap["object"] = "Product_Offerings__c"; // Bug Id : 24716
        component.set("v.ckycResp", respMap);
        
         if(!$A.util.isEmpty(event) ||  !$A.util.isUndefined(event)){
             component.set("v.ckycsmsLst", event.getParam("ckycsmsLst"));
        }

        /*var app = JSON.stringify(component.get("v.applicant"));
        var con = JSON.stringify(component.get("v.contact"));
        var acc = JSON.stringify(component.get("v.account"));
        console.log('ckyc response --> ', respMap);
        respMap["Applicant__c"] = app;
        respMap["Account"] = acc;
        respMap["Contact"] = con;*/
        //TBD
        var self = this;
        console.log('respMap --> ' , respMap);
        this.executeApex(component, "fetchCkycdata", {
            "data": JSON.stringify(respMap)
        }, function(error, result) {
           //var response = result;
            var response = JSON.parse(result);
            console.log('this is check --> ' , response);
            //self.showhidespinner(component, event, false);
            try{
                 if (response && response.status == 'success') {
                    component.set("v.isCkycDone", true);
                    self.sendSmsForCkyc(component);
                     //below needs to be corrected
                    if (response.po) { // Set PO details TBD
                        var ckycPoObj = response.po;
                        if(!$A.util.isEmpty(ckycPoObj.CKYCMobileNumber)) {
                            console.log('ckycPoObj.Alternate_Mobile_No__c --> ' + ckycPoObj.Alternate_Mobile_No__c);
                            component.set("v.po.Alternate_Mobile_No__c", ckycPoObj.CKYCMobileNumber);
                        }
                    }
                    debugger;
                     console.log('response.lead --> ', response.lead);
                      console.log('respMap.CKYCIDDetails -->', respMap.CKYCIDDetails);
                    if (response.lead) { // Set Lead details TBD
                        var ckyLeadObj = response.lead;                    
                        var ckycIdentity = JSON.parse(component.get("v.ckycResp")["CKYCIDDetails"]);
                    	if(ckycIdentity){
                            for(var j=0;j<ckycIdentity.length;j++){
                                if(ckycIdentity[j]["CKYCIDType"] && ckycIdentity[j]["CKYCIDType"] == "C"){
                                     component.set("v.lead.PAN__c",ckycIdentity[j]["CKYCIDNumber"]);
                                     component.find("pannumber").set("v.disabled", true);
                                }
                            }
                            
                    	}
                    	console.log('test ckyc --> '+ ckycIdentity);
                        if (!$A.util.isEmpty(component.get("v.lead")) && !$A.util.isEmpty(sRes)) {// US : 13265 S
                            component.set("v.lead.Data_Source__c", sRes);
                        }// US : 13265 E
                        if(!$A.util.isEmpty(ckyLeadObj.CKYC_No__c)){
                            component.set("v.lead.CKYC_No__c",ckyLeadObj.CKYC_No__c); 
                        }
                        //Bug 24927-24716 GCO-ckyc address change
                        component.set("v.addrChangeToggleCKYC",true);
                        //Bug 24927-24716 GCO-ckyc address change
                        debugger;
                        console.log('before ckyLeadObj.Salutation --> ' + ckyLeadObj.Salutation);
                        if(!$A.util.isEmpty(ckyLeadObj.Salutation)){
                            //Need to append '.' in order to match values on Lead
                            var s = ckyLeadObj.Salutation.charAt(0).toUpperCase() + ckyLeadObj.Salutation.toLowerCase().substring(1, ckyLeadObj.Salutation.length);
                            console.log('ckyLeadObj.Salutation --> ' + s);
                            ckyLeadObj.Salutation = s + '.';
                            component.set("v.lead.Salutation",ckyLeadObj.Salutation); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.FirstName)){
                            var str = ckyLeadObj.FirstName.split(' ');
                            console.log('str --> ' + str);
                            if (str != undefined && str.length == 2) {
                                component.set("v.lead.FirstName",str[0]); 
                                component.find("firstName").set("v.disabled", true);
                                component.set("v.lead.LastName",str[1]);
                                component.find("lastName").set("v.disabled", true);
                            } else if (str != undefined && str.length == 3) {
                                console.log('str --> ' + str.length);
                                component.set("v.lead.FirstName",str[0]); 
                                component.find("firstName").set("v.disabled", true);
                                component.set("v.lead.LastName",str[2]);
                                component.find("lastName").set("v.disabled", true);
                                component.set("v.lead.Middle_Name__c",str[1]);                                
                            } else {
                                component.set("v.lead.FirstName",ckyLeadObj.FirstName); 
                                component.find("firstName").set("v.disabled", true);
                            }
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.LastName)){
                            component.set("v.lead.LastName",ckyLeadObj.LastName);
                            component.find("lastName").set("v.disabled", true);
                        }
                        
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Middle_Name__c)){
                            component.set("v.lead.Middle_Name__c",ckyLeadObj.Middle_Name__c); 
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.DOB__c)){
                            console.log('date of birth');
                            component.set("v.lead.DOB__c",ckyLeadObj.DOB__c); 
                            //component.find("dateOfBirth").set("v.disabled", "true");
                            component.set("v.ckycDisable", true);
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Gender__c)){
                            component.set("v.lead.Gender__c",ckyLeadObj.Gender__c);
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Email)){
                            component.set("v.lead.Email",ckyLeadObj.Email); 
                        }                        
                        // To check below - doubt
                        var residenceAddress = '';
                        if(!$A.util.isEmpty(ckyLeadObj.Residence_Address_Line1__c)){
                            component.set("v.lead.Residence_Address_Line1__c",ckyLeadObj.Residence_Address_Line1__c); 
                            residenceAddress = residenceAddress+ckyLeadObj.Residence_Address_Line1__c;
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Residence_Address_Line2__c)){
                            component.set("v.lead.Residence_Address_Line2__c",ckyLeadObj.Residence_Address_Line2__c); 
                            residenceAddress = residenceAddress+ckyLeadObj.Residence_Address_Line2__c;
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Residence_Address_Line3__c)){
                            component.set("v.lead.Residence_Address_Line3__c",ckyLeadObj.Residence_Address_Line3__c); 
                            residenceAddress = residenceAddress+ckyLeadObj.Residence_Address_Line3__c;
    
                        }
                        //Setting the residence address on UI- to check if splitting is needed?
                        if(!$A.util.isEmpty(residenceAddress)){
                            component.set("v.residenceAddress",residenceAddress);
                            //Bug 24927-24716 GCO-ckyc address change S
                            component.find("residenceAddress").set("v.disabled", true);
                             //Bug 24927-24716 GCO-ckyc address change E
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Resi_City__c)){
                            // Need to set the search value of lookup to same
                            component.set("v.residenceCitySearchKeyword", ckyLeadObj.Resi_City__c);
                            component.set("v.lead.Resi_City__c",ckyLeadObj.Resi_City__c);
                             //Bug 24927-24716 GCO-ckyc address change S
                            component.find("residenceCity").set("v.disabled", true);
                             //Bug 24927-24716 GCO-ckyc address change E
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Resi_Pin_Code__c)){
                            component.set("v.lead.Resi_Pin_Code__c",ckyLeadObj.Resi_Pin_Code__c);
                             //Bug 24927-24716 GCO-ckyc address change S
                             component.find("pincode").set("v.disabled", true);
                             //Bug 24927-24716 GCO-ckyc address change E
                            
                        }
                      /*  //not present in ckyc response
                        if(!$A.util.isEmpty(ckyLeadObj.Residential_type__c)){
                            // This need to be corrected
                            console.log('v.lead.Residential_type__c'+ckyLeadObj.Residential_type__c);
                            component.set("v.lead.Residential_type__c",ckyLeadObj.Residential_type__c); 
                        }
                        */
                        if(!$A.util.isEmpty(ckyLeadObj.Is_Permanent_Resi_Addr_Different__c)){
                            console.log('Is_Permanent_Resi_Addr_Different__c'+ckyLeadObj.Is_Permanent_Resi_Addr_Different__c);
                            component.set("v.lead.Is_Permanent_Resi_Addr_Different__c",!(ckyLeadObj.Is_Permanent_Resi_Addr_Different__c));
                            ckyLeadObj.Is_Permanent_Resi_Addr_Different__c = !(ckyLeadObj.Is_Permanent_Resi_Addr_Different__c);
                        }
                        // To set Permanent Address and toggle box only if Permanent address is different
                        if(!$A.util.isEmpty(ckyLeadObj.State__c)){
                                component.set("v.lead.State__c",ckyLeadObj.State__c); 
                        }
                        debugger;
                        if(ckyLeadObj.Is_Permanent_Resi_Addr_Different__c == true){
                            var permanentAddress = '';
                            if(!$A.util.isEmpty(ckyLeadObj.Permanent_Line_1_New__c)){
                                component.set("v.lead.Permanent_Line_1_New__c",ckyLeadObj.Permanent_Line_1_New__c); 
                                permanentAddress = permanentAddress+ckyLeadObj.Permanent_Line_1_New__c;
        
                            }
                            if(!$A.util.isEmpty(ckyLeadObj.Address_Line_2_New__c)){
                                component.set("v.lead.Address_Line_2_New__c",ckyLeadObj.Address_Line_2_New__c); 
                                permanentAddress = permanentAddress+ckyLeadObj.Address_Line_2_New__c;
                            }
                            if(!$A.util.isEmpty(ckyLeadObj.Permanent_Address_3__c)){
                                component.set("v.lead.Permanent_Address_3__c",ckyLeadObj.Permanent_Address_3__c); 
                                permanentAddress = permanentAddress+ckyLeadObj.Permanent_Address_3__c;
                            }
                            //Setting the permanent address on UI - to check if splitting is needed?
                            if(!$A.util.isEmpty(permanentAddress)){
                                console.log('permanentAddress --> ', permanentAddress);
                                component.set("v.permanentAddress",permanentAddress);
                            }
                            // To check below - doubt Ends
                            if(!$A.util.isEmpty(ckyLeadObj.Per_City__c)){
                                component.set("v.lead.Per_City__c",ckyLeadObj.Per_City__c); 
                                component.set("v.permanentCitySearchKeyword",ckyLeadObj.Per_City__c);
                            }
                            
                            if(!$A.util.isEmpty(ckyLeadObj.Per_Pin_Code__c)){
                                component.set("v.lead.Per_Pin_Code__c",ckyLeadObj.Per_Pin_Code__c); 
                            }
                            
                            if(!$A.util.isEmpty(ckyLeadObj.Per_State__c)){
                                component.set("v.lead.Per_State__c",ckyLeadObj.Per_State__c); 
                            }
                            
                        }
                        else{
                            this.copyPermanentAddr(component);
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Marital_Status__c)){
                            component.set("v.lead.Marital_Status__c",ckyLeadObj.Marital_Status__c); 
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Father_Spouse_Salutation__c)){
                            component.set("v.lead.Father_Spouse_Salutation__c",ckyLeadObj.Father_Spouse_Salutation__c); 
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Father_Spouse_First_Name__c) && $A.util.isEmpty(component.get("v.lead.Father_Spouse_First_Name__c"))){//US:2702
                            component.set("v.lead.Father_Spouse_First_Name__c",ckyLeadObj.Father_Spouse_First_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Father_Spouse_Middle_Name__c) && $A.util.isEmpty(component.get("v.lead.Father_Spouse_Middle_Name__c"))){//US:2702
                            component.set("v.lead.Father_Spouse_Middle_Name__c",ckyLeadObj.Father_Spouse_Middle_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Father_Spouse_Last_Name__c) && $A.util.isEmpty(component.get("v.lead.Father_Spouse_Last_Name__c"))){//US:2702
                            component.set("v.lead.Father_Spouse_Last_Name__c",ckyLeadObj.Father_Spouse_Last_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Mother_First_Name__c) && $A.util.isEmpty(component.get("v.lead.Mother_First_Name__c"))){//US:2702
                            component.set("v.lead.Mother_First_Name__c",ckyLeadObj.Mother_First_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Mother_Middle_Name__c) && $A.util.isEmpty(component.get("v.lead.Mother_Middle_Name__c"))){//US:2702
                            component.set("v.lead.Mother_Middle_Name__c",ckyLeadObj.Mother_Middle_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Mother_Last_Name__c) && $A.util.isEmpty(component.get("v.lead.Mother_Last_Name__c"))){//US:2702
                            component.set("v.lead.Mother_Last_Name__c",ckyLeadObj.Mother_Last_Name__c); 
                        }  
                        // Commented below as it is giving restricted picklist value error/Different value received from API
                       if(!$A.util.isEmpty(ckyLeadObj.Proof_of_Residence_Address_Submitted__c)){
                            component.set("v.lead.Proof_of_Residence_Address_Submitted__c",ckyLeadObj.Proof_of_Residence_Address_Submitted__c); 
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Occupation_CKYC__c)){
                            component.set("v.lead.Occupation_CKYC__c",ckyLeadObj.Occupation_CKYC__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Proof_of_Identity__c)){
                            component.set("v.lead.Proof_of_Identity__c",ckyLeadObj.Proof_of_Identity__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Identity_Document_No__c)){
                            component.set("v.lead.Identity_Document_No__c",ckyLeadObj.Identity_Document_No__c); 
                        }
                        
                    }
                // Add code to set value in demographic section TBD
                 
                   component.set("v.spinnerFlag", "false");
                    
                }
                else{
                    console.log('Some error occurred');
                    component.set("v.spinnerFlag", "false");
                }
            }
            catch(err){
                console.log('exception is'+err);
                component.set("v.spinnerFlag", "false");
            }
           
           
        });
    },
       setCkycFieldsafterGrab: function(component, event) {
        //this.showhidespinner(component, event, true);
        console.log('inside ckyc after grab');
        component.set("v.isShow", false);
        component.set("v.spinnerFlag", "true");
        var respMap;
        respMap = component.get("v.ckycResp");

        var self = this;
        console.log('respMap aftre grab--> ' , respMap);
        this.executeApex(component, "fetchCkycdata", {
            "data": JSON.stringify(respMap)
        }, function(error, result) {
           //var response = result;
            var response = JSON.parse(result);
            console.log('this is check after grab--> ' , response);
            //self.showhidespinner(component, event, false);
            try{
                 if (response && response.status == 'success') {
                    component.set("v.isCkycDone", true);
                     //below needs to be corrected
                    if (response.po) { // Set PO details TBD
                        var ckycPoObj = response.po;
                        if(!$A.util.isEmpty(ckycPoObj.CKYCMobileNumber)) {
                            console.log('ckycPoObj.Alternate_Mobile_No__c --> ' + ckycPoObj.Alternate_Mobile_No__c);
                            component.set("v.po.Alternate_Mobile_No__c", ckycPoObj.CKYCMobileNumber);
                        }
                    }
                    debugger;
                     console.log('response.lead after grab--> ', response.lead);
                      console.log('respMap.CKYCIDDetails after grab-->', respMap.CKYCIDDetails);
                    if (response.lead) { // Set Lead details TBD
                        var ckyLeadObj = response.lead;                    
                        var ckycIdentity = JSON.parse(component.get("v.ckycResp")["CKYCIDDetails"]);
                    	if(ckycIdentity){
                            for(var j=0;j<ckycIdentity.length;j++){
                                if(ckycIdentity[j]["CKYCIDType"] && ckycIdentity[j]["CKYCIDType"] == "C"){
                                     component.set("v.lead.PAN__c",ckycIdentity[j]["CKYCIDNumber"]);
                                     component.find("pannumber").set("v.disabled", true);
                                }
                            }
                            
                    	}
                    	console.log('test ckyc aftre grab--> '+ ckycIdentity);
                      
                        if(!$A.util.isEmpty(ckyLeadObj.CKYC_No__c)){
                            component.set("v.lead.CKYC_No__c",ckyLeadObj.CKYC_No__c); 
                        }
                        //Bug 24927-24716 GCO-ckyc address change
                        component.set("v.addrChangeToggleCKYC",true);
                        //Bug 24927-24716 GCO-ckyc address change
                        debugger;
                        console.log('before ckyLeadObj.Salutation --> ' + ckyLeadObj.Salutation);
                        if(!$A.util.isEmpty(ckyLeadObj.Salutation)){
                            //Need to append '.' in order to match values on Lead
                            var s = ckyLeadObj.Salutation.charAt(0).toUpperCase() + ckyLeadObj.Salutation.toLowerCase().substring(1, ckyLeadObj.Salutation.length);
                            console.log('ckyLeadObj.Salutation after grab--> ' + s);
                            ckyLeadObj.Salutation = s + '.';
                            component.set("v.lead.Salutation",ckyLeadObj.Salutation); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.FirstName)){
                            var str = ckyLeadObj.FirstName.split(' ');
                            Console.log('str --> ' + str);
                            if (str != undefined && str.length == 2) {
                                component.set("v.lead.FirstName",str[0]); 
                                component.find("firstName").set("v.disabled", true);
                                component.set("v.lead.LastName",str[1]);
                                component.find("lastName").set("v.disabled", true);
                            } else if (str != undefined && str.length == 3) {
                                component.set("v.lead.FirstName",str[0]); 
                                component.find("firstName").set("v.disabled", true);
                                component.set("v.lead.LastName",str[1]);
                                component.find("lastName").set("v.disabled", true);
                                component.set("v.lead.Middle_Name__c",str[2]);
                            } else {
                                component.set("v.lead.FirstName",ckyLeadObj.FirstName); 
                                component.find("firstName").set("v.disabled", true);
                            }
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.LastName)){
                            component.set("v.lead.LastName",ckyLeadObj.LastName);
                            component.find("lastName").set("v.disabled", true);
                        }
                        
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Middle_Name__c)){
                            component.set("v.lead.Middle_Name__c",ckyLeadObj.Middle_Name__c); 
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.DOB__c)){
                            console.log('date of birth after grab');
                            component.set("v.lead.DOB__c",ckyLeadObj.DOB__c); 
                            //component.find("dateOfBirth").set("v.disabled", "true");                            
                            component.set("v.ckycDisable", true);
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Gender__c)){
                            component.set("v.lead.Gender__c",ckyLeadObj.Gender__c);
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Email)){
                            component.set("v.lead.Email",ckyLeadObj.Email); 
                        }                        
                        // To check below - doubt
                        var residenceAddress = '';
                        if(!$A.util.isEmpty(ckyLeadObj.Residence_Address_Line1__c)){
                            component.set("v.lead.Residence_Address_Line1__c",ckyLeadObj.Residence_Address_Line1__c); 
                            residenceAddress = residenceAddress+ckyLeadObj.Residence_Address_Line1__c;
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Residence_Address_Line2__c)){
                            component.set("v.lead.Residence_Address_Line2__c",ckyLeadObj.Residence_Address_Line2__c); 
                            residenceAddress = residenceAddress+ckyLeadObj.Residence_Address_Line2__c;
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Residence_Address_Line3__c)){
                            component.set("v.lead.Residence_Address_Line3__c",ckyLeadObj.Residence_Address_Line3__c); 
                            residenceAddress = residenceAddress+ckyLeadObj.Residence_Address_Line3__c;
    
                        }
                        //Setting the residence address on UI- to check if splitting is needed?
                        if(!$A.util.isEmpty(residenceAddress)){
                            component.set("v.residenceAddress",residenceAddress);
                            //Bug 24927-24716 GCO-ckyc address change S
                            component.find("residenceAddress").set("v.disabled", true);
                             //Bug 24927-24716 GCO-ckyc address change E
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Resi_City__c)){
                            // Need to set the search value of lookup to same
                            component.set("v.residenceCitySearchKeyword", ckyLeadObj.Resi_City__c);
                            component.set("v.lead.Resi_City__c",ckyLeadObj.Resi_City__c);
                             //Bug 24927-24716 GCO-ckyc address change S
                            component.find("residenceCity").set("v.disabled", true);
                             //Bug 24927-24716 GCO-ckyc address change E
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Resi_Pin_Code__c)){
                            component.set("v.lead.Resi_Pin_Code__c",ckyLeadObj.Resi_Pin_Code__c);
                             //Bug 24927-24716 GCO-ckyc address change S
                             component.find("pincode").set("v.disabled", true);
                             //Bug 24927-24716 GCO-ckyc address change E

                        }
                        //not present in ckyc response
                      /*  if(!$A.util.isEmpty(ckyLeadObj.Residential_type__c)){
                            // This need to be corrected
                            console.log('v.lead.Residential_type__c'+ckyLeadObj.Residential_type__c);
                            component.set("v.lead.Residential_type__c",ckyLeadObj.Residential_type__c); 
                        }
                        */
                        if(!$A.util.isEmpty(ckyLeadObj.Is_Permanent_Resi_Addr_Different__c)){
                            console.log('Is_Permanent_Resi_Addr_Different__c'+ckyLeadObj.Is_Permanent_Resi_Addr_Different__c);
                            component.set("v.lead.Is_Permanent_Resi_Addr_Different__c",!(ckyLeadObj.Is_Permanent_Resi_Addr_Different__c)); 
                        }
                        // To set Permanent Address and toggle box only if Permanent address is different
                        if(ckyLeadObj.Is_Permanent_Resi_Addr_Different__c == true){
                            var permanentAddress = '';
                            if(!$A.util.isEmpty(ckyLeadObj.Permanent_Line_1_New__c)){
                                component.set("v.lead.Permanent_Line_1_New__c",ckyLeadObj.Permanent_Line_1_New__c); 
                                permanentAddress = permanentAddress+ckyLeadObj.Permanent_Line_1_New__c;
        
                            }
                            if(!$A.util.isEmpty(ckyLeadObj.Address_Line_2_New__c)){
                                component.set("v.lead.Address_Line_2_New__c",ckyLeadObj.Address_Line_2_New__c); 
                                permanentAddress = permanentAddress+ckyLeadObj.Address_Line_2_New__c;
                            }
                            if(!$A.util.isEmpty(ckyLeadObj.Permanent_Address_3__c)){
                                component.set("v.lead.Permanent_Address_3__c",ckyLeadObj.Permanent_Address_3__c); 
                                permanentAddress = permanentAddress+ckyLeadObj.Permanent_Address_3__c;
                            }
                            //Setting the permanent address on UI - to check if splitting is needed?
                            if(!$A.util.isEmpty(permanentAddress)){
                                component.set("v.permanentAddress",permanentAddress);
                            }
                            // To check below - doubt Ends
                            if(!$A.util.isEmpty(ckyLeadObj.Per_City__c)){
                                component.set("v.lead.Per_City__c",ckyLeadObj.Per_City__c); 
                                component.set("v.permanentCitySearchKeyword",ckyLeadObj.Per_City__c);
                            }
                            
                            if(!$A.util.isEmpty(ckyLeadObj.Per_Pin_Code__c)){
                                component.set("v.lead.Per_Pin_Code__c",ckyLeadObj.Per_Pin_Code__c); 
                            }
                            
                            if(!$A.util.isEmpty(ckyLeadObj.Per_State__c)){
                                component.set("v.lead.Per_State__c",ckyLeadObj.Per_State__c); 
                            }
                            
                        }
                        else{
                            this.copyPermanentAddr(component);
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Marital_Status__c)){
                            component.set("v.lead.Marital_Status__c",ckyLeadObj.Marital_Status__c); 
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Father_Spouse_Salutation__c)){
                            component.set("v.lead.Father_Spouse_Salutation__c",ckyLeadObj.Father_Spouse_Salutation__c); 
                        }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Father_Spouse_First_Name__c) && $A.util.isEmpty(component.get("v.lead.Father_Spouse_First_Name__c"))){//US:2702
                            component.set("v.lead.Father_Spouse_First_Name__c",ckyLeadObj.Father_Spouse_First_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Father_Spouse_Middle_Name__c) && $A.util.isEmpty(component.get("v.lead.Father_Spouse_Middle_Name__c"))){//US:2702
                            component.set("v.lead.Father_Spouse_Middle_Name__c",ckyLeadObj.Father_Spouse_Middle_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Father_Spouse_Last_Name__c) && $A.util.isEmpty(component.get("v.lead.Father_Spouse_Last_Name__c"))){//US:2702
                            component.set("v.lead.Father_Spouse_Last_Name__c",ckyLeadObj.Father_Spouse_Last_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Mother_First_Name__c) && $A.util.isEmpty(component.get("v.lead.Mother_First_Name__c"))){//US:2702
                            component.set("v.lead.Mother_First_Name__c",ckyLeadObj.Mother_First_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Mother_Middle_Name__c) && $A.util.isEmpty(component.get("v.lead.Mother_Middle_Name__c"))){//US:2702
                            component.set("v.lead.Mother_Middle_Name__c",ckyLeadObj.Mother_Middle_Name__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Mother_Last_Name__c) && $A.util.isEmpty(component.get("v.lead.Mother_Last_Name__c"))){//US:2702
                            component.set("v.lead.Mother_Last_Name__c",ckyLeadObj.Mother_Last_Name__c); 
                        }  
                        // Commented below as it is giving restricted picklist value error/Different value received from API
                       if(!$A.util.isEmpty(ckyLeadObj.Proof_of_Residence_Address_Submitted__c)){
                            component.set("v.lead.Proof_of_Residence_Address_Submitted__c",ckyLeadObj.Proof_of_Residence_Address_Submitted__c); 
                       		//User Story 2357:POADocName added as part of document uploader
                           component.set("v.POADocName",ckyLeadObj.Proof_of_Residence_Address_Submitted__c);
                       }
                        
                        if(!$A.util.isEmpty(ckyLeadObj.Occupation_CKYC__c)){
                            component.set("v.lead.Occupation_CKYC__c",ckyLeadObj.Occupation_CKYC__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Proof_of_Identity__c)){
                            component.set("v.lead.Proof_of_Identity__c",ckyLeadObj.Proof_of_Identity__c); 
                        }
                        if(!$A.util.isEmpty(ckyLeadObj.Identity_Document_No__c)){
                            component.set("v.lead.Identity_Document_No__c",ckyLeadObj.Identity_Document_No__c); 
                        }
                        
                    }
                // Add code to set value in demographic section TBD
                 
                   component.set("v.spinnerFlag", "false");
                    
                }
                else{
                    console.log('Some error occurred');
                    component.set("v.spinnerFlag", "false");
                }
            }
            catch(err){
                console.log('exception is'+err);
                component.set("v.spinnerFlag", "false");
            }
           
           
        });
    },
    createCkycSOL: function(component) { 
        console.log('createCkycSOL start ckycresponse --> ', component.get("v.ckycResp"));
        console.log('createCkycSOL start PO ID '+component.get("v.po").Id);
        
        var ckycResp = Object.assign({}, component.get('v.ckycResp'));
        var allDocResp = new Object();
        debugger;
        // Need To Delete the Photo and Image from response, else backend field size is small
        if(ckycResp["CKYCPhoto"]){
            delete ckycResp["CKYCPhoto"];
        }

        if(ckycResp["CKYCImageDetails"]){
            allDocResp["CKYCImageDetails"] = ckycResp["CKYCImageDetails"];
            delete ckycResp["CKYCImageDetails"];
        }
		if (ckycResp["ApiToken"]) { // US : 13265 S
            delete ckycResp["ApiToken"];
        }
		var searchResp = Object.assign({}, component.get('v.ckycSearch'));
        if (searchResp["ApiToken"]) {
            delete searchResp["ApiToken"];
        } // US : 13265 E
		console.log('poadocname'+component.get("v.lead.Proof_of_Residence_Address_Submitted__c"));
       //User Story 2357:POADocName added as part of document uploader
        this.executeApex(component, "createSolPolicy", {
            "poId": component.get("v.po").Id,
            "ckycResponse": JSON.stringify(ckycResp),
            "allDoc": JSON.stringify(allDocResp),
            "POADocName":component.get("v.lead.Proof_of_Residence_Address_Submitted__c"),
            "searchData" : JSON.stringify(searchResp) // US : 13265
        }, function(error) {
             debugger;
             if (error) {
                console.log('solpolicy and doc records not created!! ' + error);
            } else {
                console.log('solpolicy and doc records created!! ');
                // disable the ckyc UI
                component.set('v.isReadOnlyCKYC', true);// Bug Id : 24716
            }
        });
    },
    createCkycSearchSOL :  function(component) { // US : 13265 S
        try {
        var searchResp = Object.assign({}, component.get('v.ckycSearch'));
        var status = 'success';
        var dResp = null;
        debugger;
        console.log('downResp -->', component.get("v.downResponse"));
            if (!$A.util.isEmpty(component.get("v.downResponse"))) {
                dResp = Object.assign({}, component.get("v.downResponse"));
            }
            console.log('dResp -->', dResp);
        if (searchResp["ApiToken"]) {
            delete searchResp["ApiToken"];
        }
        if (dResp != null && dResp["ApiToken"]) {
            delete dResp["ApiToken"];
        }
        console.log('searchResp["RequestStatus"] --> ' + searchResp["RequestStatus"]);
        console.log('searchResp["TransactionStatus"] --> ' + searchResp["TransactionStatus"]);
        if (searchResp["RequestStatus"] == "RejectedByTW" || searchResp["TransactionStatus"] == "CKYCRejected" || searchResp["TransactionStatus"] == "TWRejected") {
            status = 'failure';
        }
        console.log("*******status: "+status);
        this.executeApex(component, "ckycSearchSOL", {
            "poId": component.get("v.po").Id,
            "data": JSON.stringify(searchResp),
            "dData" : JSON.stringify(dResp),
            "sStatus" : status
        }, function(error, result) {
            debugger;
            if (error) {
                console.log('solpolicy search record not created!! ' + error);
            } else {
                console.log('solpolicy search record created!! ');
                // disable the ckyc UI
                //component.set('v.isReadOnlyCKYC', true); //Bug Id : 27033
            }
        });
        } catch (e) {
            console.log('error in createCkycSearchSOL --> ', e);
        }
    },// US : 13265 E
    sendSmsForCkyc: function(component, event) {
        var params = new Object();
        params["event"] = 'CKYC Consent SMS';
        console.log(component.get("v.ckycResp")["mobNo"]);
        params["mobNo"] = component.get("v.ckycResp")["mobNo"];
        params["smsName"] = 'CKYC Consent SMS';
        params["receiver"] = 'Customer';
        params["object"] = "Product_Offerings__c"; // Bug Id : 24716
        console.log('sendSmsForCkyc poId --> ' + component.get("v.poId"));
        //POID will not be available at this stage
        params["RecId"] = component.get("v.poId");
        this.executeApex(component, "sendCkycSms", {
            "data": params
        }, function(error, result) {
            if (result) {
                var response = JSON.parse(result);
                console.log('ckycsmsLst response --> ' , response);
                component.set("v.ckycsmsLst", response);
            }
        });
    },
    // Bug Id : 24716 stop
    setSearchCkyc: function(component, event) { // US : 13265 S
        try {
            if(!$A.util.isEmpty(event) ||  !$A.util.isUndefined(event)) {
                var respMap = event.getParam("SearchInfo");
                if (!$A.util.isEmpty(respMap)) {
                    console.log("Search event data --> ", respMap);
                    component.set("v.ckycSearch", respMap);
                }
                var downResp = event.getParam("downInfo");
                if (!$A.util.isEmpty(downResp)) {
                    console.log("down error event data --> ", JSON.stringify(downResp));
                    component.set("v.downResponse", downResp);
                } else {
                    component.set("v.downResponse", null);
                }
                var res = event.getParam("dSource");
                console.log("Search event res --> ", res);
                console.log("CKYCDocumentType --> ", component.get("v.CKYCDocumentType"));
                if (!$A.util.isEmpty(component.get("v.lead")) && !$A.util.isEmpty(res) && !$A.util.isEmpty(component.get("v.CKYCDocumentType"))) {
                    component.set("v.lead.Data_Source__c", res);
                    component.set("v.lead.CKYCDocumentType__c", component.get("v.CKYCDocumentType"));
                }
            }
        } catch (e) {
            console.log('exception --> ', e);
        }
    }, // US : 13265 E
	setIncSecFieldVisibility: function(component) { // US : 19995 S
        var prod = null;
        if (!$A.util.isEmpty(component.get("v.po")) && !$A.util.isEmpty(component.get("v.po.Products__c"))) {
            console.log('prod --> '+ component.get("v.po.Products__c"));
            prod = component.get("v.po.Products__c");
        } else {
            prod = 'PRO';
        }
        console.log('prod -->'+prod);
            debugger;
            this.executeApex(component, "isIncSecFieldsRestricted", {
                "strProduct": prod
            }, function(error, result) {
                    debugger;
                    console.log('result --> ' + result);
                    component.set('v.incFieldVisibility', result);                    
            });
        } // US : 19995 E
})