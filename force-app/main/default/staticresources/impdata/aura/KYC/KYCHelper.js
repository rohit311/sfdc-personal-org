({
    getResidentialCity: function(component) {
        this.executeApex(component, "getResidenceCity", {}, function(error, result) {
            if (!error && result) {
                component.set("v.residenceCities", result || []);
            }
        });
    },
    getResidentialTypeData: function(component) {
        this.executeApex(component, "getResidentialType", {}, function(error, result) {
            if (!error && result) {
                this.setSelectOptions(component, result, "Residential Type", "residentialType");
            }
        });
    },
    getPracticeTypeData: function(component) {
        console.log('inside getPracticeTypeData');
        var segmentValue = component.find("profession").get("v.value") || component.get("v.lead.Profession_Type__c");
        var result = this.getPracticeTypeMap(component, segmentValue);
        if (result){
            console.log('inside result');
            this.setSelectOptions(component, result, "Practice Type", "practiceType");
        }
        //this.getExperienceData(component);
        /*this.executeApex(component, "getPracticeType", {}, function(error, result){
            if(!error && result){
                this.setSelectOptions(component, result, "Practice Type", "practiceType");
            }
        });*/
    },
    
    getSpecializationData: function(component) {
        var segmentValue = component.find("profession").get("v.value") || component.get("v.lead.Profession_Type__c");
        console.log(segmentValue + 'lsdfj;');
        var result = this.getspecializationMap(component, segmentValue);
        var speczcmpFound=component.find("specialization");
        if(result && speczcmpFound)
            this.setSelectOptions(component, result, "Specialization", "specialization");
        
        /*  this.executeApex(component, "getSpecialization", {}, function(error, result){
              if(!error && result){
                  this.setSelectOptions(component, result, "Specialization", "specialization");
              }
          });*/
    },
    getspecializationMap: function(component, key) {
        
        var specializationMap = [];
        specializationMap['Doctor'] = ['Allergist', 'Anaesthesist', 'Anatomy and physiology', 'Andrologist', 'Audiologist', 'Ayurveda and Homeopath', 'Ayurveda', 'Homeopath', 'Cardiologist', 'Cosmetic Surgeon', 'Dentist', 'Dentistry', 'Dermatologist', 'Diabetologist', 'Diagnostic', 'Endocrinologist', 'Endodontist', 'ENT', 'EPIDEMEOLOGIST', 'Gastroenterologist', 'General Physician', 'General Surgeon', 'Geriatrician', 'Gynaecologist and Obstetrician', 'HAEMOTOLOGISTS', 'Histopathology', 'Immunologist', 'Implantologist', 'Neonatologist', 'Nephrologist', 'Neurologist', 'Oncologist', 'Opthalmologist', 'ORAL and MAXILOFACIAL', 'Orthodontists', 'Pathologist', 'Pediatrician', 'Periodontics', 'Pharmacologist', 'Physiotherapist', 'Podiatrist', 'Psychologist', 'Pulmonologist', 'Radiologist', 'Rheumatologist', 'Sexologist', 'Venerologist', 'Neurosurgeons', 'Psychiatrist', 'Orthopaedic Surgeons', 'Plastic Surgeon', 'FORENSIC MEDICINE AND TOXICOLOGY', 'Urologist', 'Dermatologist(DNB/DM/MS/FNB/MCH)', 'Diabetologist(DNB/DM/MS/FNB/MCH)', 'ENT(DNB/DM/MS/FNB/MCH)', 'EPIDEMEOLOGIST(DNB/DM/MS/FNB/MCH)', 'Forensic Medicine and Toxicology (DNB/DM/MS/FNB/MCH)', 'Gastroenterologist (DNB/DM/MS/FNB/MCH)', 'General Surgeon(DNB/DM/MS/FNB/MCH)', 'Gynaecologist and Obstetrician(DNB/DM/MS/FNB/MCH)', 'HAEMOTOLOGISTS(DNB/DM/MS/FNB/MCH)', 'Histopathology(DNB/DM/MS/FNB/MCH)', 'Leprhologist (DNB/DM/MS/FNB/MCH)', 'Neonatologist(DNB/DM/MS/FNB/MCH)', 'Opthalmologist(DNB/DM/MS/FNB/MCH)', 'Orthopaedic(DNB/DM/MS/FNB/MCH)', 'Pathologist(DNB/DM/MS/FNB/MCH)', 'Pediatrician(DNB/DM/MS/FNB/MCH)', 'Pharmacologist(DNB/DM/MS/FNB/MCH)', 'Podiatrist(DNB/DM/MS/FNB/MCH)', 'Psychiatrist(DNB/DM/MS/FNB/MCH)', 'Radiologist(DNB/DM/MS/FNB/MCH)', 'Urologist(DNB/DM/MS/FNB/MCH)', 'Venerologist(DNB/DM/MS/FNB/MCH)', 'Others(DNB/DM/MS/FNB/MCH)', 'General Medicine (DNB/DM/MS/FNB/MCH)', 'GENERAL MEDICINE', 'Leprhologist', 'Not Available'];
        specializationMap['CA'] = ['CA', 'CS', 'CWA', 'Not Available'];
        specializationMap['Pharmacist'] = ['Pharmacist'];
        specializationMap['Engineers'] = ['Chemical Engg', 'Electronics Instrumentation', 'mechanical engg', 'Computer Science', 'Textile Chemistry', 'Electronics And Comm', 'Civil Engg', 'electrical engg', 'automobile engg', 'Computer Engg', 'IT', 'Production Engg', 'Not Available'];
        specializationMap['all'] = ['Chemical Engg', 'Electronics Instrumentation', 'mechanical engg', 'Computer science', 'Textile Chemistry', 'Electronics And Comm', 'Civil Engg', 'electrical engg', 'automobile engg', 'Computer Engg', 'IT', 'Production Engg', 'CA', 'CS', 'CWA', 'Allergist', 'Anaesthesist', 'Anatomy and physiology', 'Andrologist', 'Audiologist', 'Ayurveda and Homeopath', 'Ayurveda', 'Homeopath', 'Cardiologist', 'Cosmetic Surgeon', 'Dentist', 'Dentistry', 'Dermatologist', 'Diabetologist', 'Diagnostic', 'Endocrinologist', 'Endodontist', 'ENT', 'EPIDEMEOLOGIST', 'Gastroenterologist', 'General Physician', 'General Surgeon', 'Geriatrician', 'Gynaecologist and Obstetrician', 'HAEMOTOLOGISTS', 'Histopathology', 'Immunologist', 'Implantologist', 'Neonatologist', 'Nephrologist', 'Neurologist', 'Oncologist', 'Opthalmologist', 'ORAL and MAXILOFACIAL', 'Orthodontists', 'Pathologist', 'Pediatrician', 'Periodontics', 'Pharmacologist', 'Physiotherapist', 'Podiatrist', 'Psychologist', 'Pulmonologist', 'Radiologist', 'Rheumatologist', 'Sexologist', 'Venerologist', 'Neurosurgeons', 'Psychiatrist', 'Orthopaedic Surgeons', 'Plastic Surgeon', 'FORENSIC MEDICINE AND TOXICOLOGY', 'Urologist', 'Dermatologist(DNB/DM/MS/FNB/MCH)', 'Diabetologist(DNB/DM/MS/FNB/MCH)', 'ENT(DNB/DM/MS/FNB/MCH)', 'EPIDEMEOLOGIST(DNB/DM/MS/FNB/MCH)', 'Forensic Medicine and Toxicology (DNB/DM/MS/FNB/MCH)', 'Gastroenterologist (DNB/DM/MS/FNB/MCH)', 'General Surgeon(DNB/DM/MS/FNB/MCH)', 'Gynaecologist and Obstetrician(DNB/DM/MS/FNB/MCH)', 'HAEMOTOLOGISTS(DNB/DM/MS/FNB/MCH)', 'Histopathology(DNB/DM/MS/FNB/MCH)', 'Leprhologist (DNB/DM/MS/FNB/MCH)', 'Neonatologist(DNB/DM/MS/FNB/MCH)', 'Opthalmologist(DNB/DM/MS/FNB/MCH)', 'Orthopaedic(DNB/DM/MS/FNB/MCH)', 'Pathologist(DNB/DM/MS/FNB/MCH)', 'Pediatrician(DNB/DM/MS/FNB/MCH)', 'Pharmacologist(DNB/DM/MS/FNB/MCH)', 'Podiatrist(DNB/DM/MS/FNB/MCH)', 'Psychiatrist(DNB/DM/MS/FNB/MCH)', 'Radiologist(DNB/DM/MS/FNB/MCH)', 'Urologist(DNB/DM/MS/FNB/MCH)', 'Venerologist(DNB/DM/MS/FNB/MCH)', 'Others(DNB/DM/MS/FNB/MCH)', 'General Medicine (DNB/DM/MS/FNB/MCH)', 'GENERAL MEDICINE', 'Leprhologist', 'Not Available'];
        if (key)
            return specializationMap[key];
        else
            return specializationMap['all'];
    },
    getPracticeTypeMap: function(component, key) {
        
        var PracticeTypeMap = [];
        PracticeTypeMap['Doctor'] = ['Salaried', 'Salaried+Practicing', 'Consulting', 'Consulting+Practicing', 'SEP'];
        PracticeTypeMap['CA'] = ['SEP'];
        PracticeTypeMap['Engineers'] = ['Consulting', 'SEP'];
        PracticeTypeMap['Pharmacist'] = ['Salaried', 'Salaried+Practicing', 'Consulting', 'Consulting+Practicing', 'SEP'];
        PracticeTypeMap['Taxconsultant'] = ['Salaried', 'Salaried+Practicing', 'Consulting', 'Consulting+Practicing', 'SEP'];
        PracticeTypeMap['all'] = ['Salaried', 'Salaried+Practicing', 'Consulting', 'Consulting+Practicing', 'SEP'];
        if (key)
            return PracticeTypeMap[key];
        else
            return PracticeTypeMap['all'];
    },
    getProfessionTypeData: function(component) {
        var result = ['Doctor', 'CA', 'Engineers', 'Pharmacist', 'Taxconsultant']
        console.log('profession===>'+component.find("profession").get("v.value"));
        this.setSelectOptions(component, result, "Segment Type", "profession");
        /*this.executeApex(component, "getProfession", {}, function(error, result){
            if(!error && result){
                console.log(result);
                this.setSelectOptions(component, result, "Segment Type", "profession");
            }
        });*/
    },
    
    getExperienceData: function(component) {
        console.log('getExperienceDetails function called');
        console.log('practiceExperience===>'+component.find("practiceExperience"));
        console.log('postGradExperience===>'+component.find("postGradExperience"));
        this.executeApex(component, "getExperienceDetails", {}, function(error, result){
            if(!error && result){
                console.log('result===>'+result);
                this.setSelectOptions(component, result, "Business Vintage", "practiceExperience");
                this.setSelectOptions(component, result, "Post Qualification Experience", "postGradExperience");
            }
        });
    },
    calculateDegree: function(component) {
        console.log('inside calculateDegree');
        if (component.get("v.lead.Profession_Type__c") == 'Pharmacist') {
            component.set("{!v.po.Specialisation__c}", 'Pharmacist');
            if (component.get("{!v.po.Degree__c}") == 'B.Pharm') {
                component.set("{!v.po.Type_of_Degree__c}", 'Graduate');
            }
            if (component.get("{!v.po.Degree__c}") == 'M.Pharm') {
                component.set("{!v.po.Type_of_Degree__c}", 'Post Graduate');
            }
            if (component.get("{!v.po.Degree__c}") == 'D.Pharm') {
                component.set("{!v.po.Type_of_Degree__c}", 'Diploma ');
            }
        }
        if (component.get("v.lead.Profession_Type__c") == 'CA') {
            component.set("{!v.po.Type_of_Degree__c}", 'CA');
            component.set("{!v.po.Specialisation__c}", 'CA');
        }
        if (component.get("v.lead.Profession_Type__c") == 'Taxconsultant') {
            component.set("{!v.po.Degree__c}", 'Other');
            component.set("{!v.po.Specialisation__c}", 'Taxconsultant');
        }
        console.log('inside calculateDegree tyoe of degree is'+component.get("{!v.po.Type_of_Degree__c}"));
    },
    // Bug 14509 s
    getDegreeData: function(component) {
        
        console.log('inside degree fetching' + component.get("v.lead.Profession_Type__c"));
        var resultpharma = ['B.Pharm', 'M.Pharm', 'D.Pharm']
        var resulttax = ['Graduate', 'Post Graduate']
        if (component.get("v.lead.Profession_Type__c") == 'Pharmacist') {
            this.setSelectOptions(component, resultpharma, "Degree", "degree");
        } else if (component.get("v.lead.Profession_Type__c") == 'Taxconsultant') {
            this.setSelectOptions(component, resulttax, "Qualification", "qualifications");
        } else {
            this.executeApex(component, "getDegree", {}, function(error, result) {
                if (!error && result) {
                    console.log('Degree---->' + result);
                    this.setSelectOptions(component, result, "Degree", "degree");
                    component.set('v.degreeValues', result);
                }
            });
        }
        
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
        var result = ['Post Graduate', 'Graduate'];
        this.setSelectOptions(component, result, "Highest Degree Type", "highestDegreeType");
        /*  this.executeApex(component, "gethighestDegreeTypeDetails", {}, function(error, result){
              if(!error && result){
                  this.setSelectOptions(component, result, "Highest Degree Type", "highestDegreeType");
                }
          });*/
    },
    setSelectOptions: function(component, data, label, cmpId) {
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
        component.find(cmpId).set("v.options", opts);
    },
    getCustomerDetails: function(component, poId) {
        this.executeApex(component, "getCustomerDetails", {
            poId: poId
        }, function(error, result) {
            if (!error && result) {
                // console.log('result==>'+result.po.Degree__c);
                //  this.getExperienceData(component);
                
                this.setExistingCustomerDetails(component, JSON.parse(result));
                if (component.get("v.offer.converted")) {
                    this.disableForm(component);
                    this.triggerPostSaveEvent(component);
                } else {
                    //PSL changes : Nikhil Bugfix #11800
                    //calling trigger display event to update Offer details
                    this.triggerDisplayOfferEvent(component);
                }
            }
        });
    },
    showFinancialSection: function(component) {
        if (component.get("v.scam.PY_Type_of_Financial__c") == 'Financial') {
            var resultMethod = ['Cash Profit', 'Gross Receipt']
            this.setSelectOptions(component, resultMethod, "Method", "method");
            
        }
        else
        {
            var field = component.find("obligations");
            field.set("v.errors", [{
                message: ""
            }]);
        }
        
    },
    updateFormNew: function(component, newPO) {
        this.updateForm(component, newPO);
        console.log('inside degree fetching' + component.get("v.lead.Profession_Type__c"));
        if(component.get("v.productFlow") === 'RDL')
            this.getDegreeData(component);
        
        
        
    },
    updateForm: function(component, newPO) {
        console.log('=in update form  here=>'+component.get("v.po.Type_of_Degree__c"));
        this.getSpecializationData(component);
        this.getPracticeTypeData(component);
        console.log('=in update form  here=>'+component.get("v.po.Type_of_Degree__c"));
        // if(component.get("v.productFlow") === 'RDL')
        //this.getDegreeData(component);
        
        
        var resultpharma = ['B.Pharm', 'M.Pharm', 'D.Pharm']
        
        if (component.get("v.lead.Profession_Type__c") == 'Pharmacist') {
            this.setSelectOptions(component, resultpharma, "Degree", "degree");
        } 
        console.log('=in update form  here=>'+component.get("v.po.Type_of_Degree__c"));
        console.log(component.get("v.lead.Profession_Type__c"));
        var segmentValue = component.get("v.lead.Profession_Type__c") || component.find("profession").get("v.value");
        if (newPO) {
            console.log(newPO);
            var po = component.get("v.po");
            po.Practice_Type__c = newPO.Practice_Type__c || po.Practice_Type__c;
            po.Specialisation__c = newPO.Specialisation__c || po.Specialisation__c;
            console.log('newPO.Degree__c==>'+newPO.Degree__c);
            po.Degree__c = newPO.Degree__c || po.Degree__c;
            po.Type_of_Degree__c = newPO.Type_of_Degree__c || po.Type_of_Degree__c;
            console.log(po.Specialisation__c);
            component.set("v.po", po);
            console.log("test pankaj"+component.get("v.po.Degree__c"));
            var speczFounc=component.find("specialization");
            if(speczFounc)
                component.find("specialization").set("v.value", po.Specialisation__c);
            //component.set("v.po.Specialisation__c","Computer Science");
            po.Total_Employment_Vintage__c =  newPO.Total_Employment_Vintage__c || po.Total_Employment_Vintage__c
            po.Post_Graduate_Super_Specialist_Experienc__c =  newPO.Post_Graduate_Super_Specialist_Experienc__c || po.Post_Graduate_Super_Specialist_Experienc__c
            console.log(' here in update form po.Total_Employment_Vintage__c =>'+ po.Total_Employment_Vintage__c);
            console.log('here in update form po.Post_Graduate_Super_Specialist_Experienc__c =>'+ po.Post_Graduate_Super_Specialist_Experienc__c);
            
        }
        if (segmentValue && segmentValue === 'Doctor') {
            console.log('inside doctor');
            this.showHideDiv(component, "qualificationTax", false);
            this.showHideDiv(component, "qualificationAll", true);
            this.showHideDiv(component, "qualificationDoctor", true);
            this.showHideDiv(component, "qualificationPharma", false);
            this.showHideDiv(component, "qualificationCA", false);
            this.showHideDiv(component, "officeCAFinancial", false);
            this.showHideDiv(component, "qualificationEngineers", false);
            // component.find("degree").set("v.disabled", false);
            this.showHideDiv(component, "incomeAll", true);
            this.showHideDiv(component, "incomeCAcashFinancial", false);
            this.showHideDiv(component, "incomeCAGrossFinancial", false);
            console.log('test doctor first'+component.get("v.po.Degree__c"));
            
        }
        if (segmentValue && segmentValue === 'Pharmacist') {
            var result = ['Yes', 'No']
            this.setSelectOptions(component, result, "Shop Owned", "ShopOwned");
            this.setSelectOptions(component, result, "Degree Owned", "DegreeOwned");
            this.setSelectOptions(component, result, "Any other unsecured loan from BFL", "unsecuredloan");
            this.showHideDiv(component, "qualificationAll", true);
            this.showHideDiv(component, "qualificationDoctor", false);
            this.showHideDiv(component, "qualificationTax", false);
            this.showHideDiv(component, "qualificationCA", false);
            this.showHideDiv(component, "officeCAFinancial", false);
            this.showHideDiv(component, "qualificationPharma", true);
            // component.find("degree").set("v.disabled", false);
            this.showHideDiv(component, "incomeAll", false);
            this.showHideDiv(component, "incomeCAcashFinancial", false);
            this.showHideDiv(component, "incomeCAGrossFinancial", false);
            this.showHideDiv(component, "qualificationEngineers", false);
            console.log('test Pharmacist first'+component.get("v.po.Degree__c"));
            
        }
        if (segmentValue && segmentValue === 'Taxconsultant') {
            console.log('qualificationTax inside'+component.get("v.po.Type_of_Degree__c"));
            
            this.showHideDiv(component, "qualificationAll", true);
            this.showHideDiv(component, "qualificationTax", true);
            var result = ['Post Graduate', 'Graduate'];
            this.setSelectOptions(component, result, "Qualification", "qualifications");
            
            console.log('qualificationTax inside'+component.get("v.po.Type_of_Degree__c"));
            this.showHideDiv(component, "officeCAFinancial", false);
            this.showHideDiv(component, "qualificationCA", false);
            this.showHideDiv(component, "qualificationPharma", false);
            this.showHideDiv(component, "incomeAll", false);
            this.showHideDiv(component, "incomeCAcashFinancial", false);
            this.showHideDiv(component, "incomeCAGrossFinancial", false);
            this.showHideDiv(component, "qualificationEngineers", false);
            
            
            
        }
        if (segmentValue && segmentValue === 'CA') {
            var resultprogramType = ['Financial', 'NonFinancial']
            this.setSelectOptions(component, resultprogramType, "Program Type", "programType");
            
            var result = ['Owned', 'Rented'];
            this.setSelectOptions(component, result, "Office Ownership", "officeOwnership");
            console.log('componentfind method'+component.find("method"));
            var methodFind=component.find("method");
            if(methodFind){
                var resultMethod = ['Cash Profit', 'Gross Receipt']
                this.setSelectOptions(component, resultMethod, "Method", "method");
            }
            
            this.showHideDiv(component, "qualificationAll", true);
            this.showHideDiv(component, "qualificationCA", true);
            this.showHideDiv(component, "officeCAFinancial", false);
            this.showHideDiv(component, "qualificationDoctor", false);
            this.showHideDiv(component, "qualificationPharma", false);
            this.showHideDiv(component, "qualificationEngineers", false);
            this.showHideDiv(component, "incomeAll", true);
            
            
            // this.showHideDiv(component, "incomeCAcashFinancial", false);
            // this.showHideDiv(component, "incomeCAGrossFinancial", false);
            
        }
        // var segmentValue = component.get("v.lead.Profession_Type__c");
        if (segmentValue && segmentValue === 'Engineers') {
            
            
            console.log(' here in engineers form po.Total_Employment_Vintage__c =>'+ po.Total_Employment_Vintage__c);
            console.log('here in engineers form po.Post_Graduate_Super_Specialist_Experienc__c =>'+ po.Post_Graduate_Super_Specialist_Experienc__c);
            this.showHideDiv(component, "qualificationTax", false);
            this.showHideDiv(component, "qualificationEngineers", true);
            var result=['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40']
            if(po.Total_Employment_Vintage__c=='')
            {
                this.setSelectOptions(component, result, "Business Vintage", "practiceExperience");
            }
            if(po.Post_Graduate_Super_Specialist_Experienc__c==''){
                this.setSelectOptions(component, result, "Post Qualification Experience", "postGradExperience");
            }
            console.log(' here in engineers form po.Total_Employment_Vintage__c =>'+ po.Total_Employment_Vintage__c);
            console.log('here in engineers form po.Post_Graduate_Super_Specialist_Experienc__c =>'+ po.Post_Graduate_Super_Specialist_Experienc__c);
            this.showHideDiv(component, "qualificationAll", true);
            // this.showHideDiv(component, "qualificationDoctor", true);
            this.showHideDiv(component, "qualificationPharma", false);
            this.showHideDiv(component, "qualificationCA", false);
            this.showHideDiv(component, "officeCAFinancial", false);
            
            
            this.showHideDiv(component, "incomeAll", true);
            this.showHideDiv(component, "incomeCAcashFinancial", false);
            this.showHideDiv(component, "incomeCAGrossFinancial", false);
            
            
            this.showHideDiv(component, "highestDegreeTypeDiv", true);
            this.showHideDiv(component, "collegeNameDiv", true);
            this.showHideDiv(component, "collegeCityDiv", true);
            
            this.getCollegeCityData(component);
            this.gethighestDegreeTypeData(component);
            console.log('calling from here');
            //this.getExperienceData(component);
            var specializationCMP = component.find("specializationLabel");
            if (specializationCMP)
                specializationCMP.set('v.value', 'Stream');
            
            var practiceExpCMP = component.find("practiceExperienceLabel");
            if(practiceExpCMP)
                practiceExpCMP.set('v.value','Business Vintage');
            
            var postGradExpCMP = component.find("postGradExperienceLabel");
            if(postGradExpCMP)
                postGradExpCMP.set('v.value','Post Qualification Experience');
            
            
            
            
            
            //this.addRemoveInputError(component, "highestDegreeType" , this.isEmpty(component.get("v.po.TypeOfDegreeforCA_Architect__c")) && "Select Highest Degree Type");
            
        } else {
            //console.log('test pan middle'+component.get("v.po.Degree__c"));
            this.showHideDiv(component, "highestDegreeTypeDiv", false);
            this.showHideDiv(component, "collegeNameDiv", false);
            this.showHideDiv(component, "collegeCityDiv", false);
            
            var specializationCMP = component.find("specializationLabel");
            if (specializationCMP)
                specializationCMP.set('v.value', 'Specialization');
            
            var practiceExpCMP = component.find("practiceExperienceLabel")
            if(practiceExpCMP)
                practiceExpCMP.set('v.value','Practice Experience*');
            
            var postGradExpCMP = component.find("postGradExperienceLabel")
            if(postGradExpCMP)
                postGradExpCMP.set('v.value','Post Graduate Experience*');
            
            //this.addRemoveInputError(component, "highestDegreeType" , !this.isEmpty(component.get("v.po.TypeOfDegreeforCA_Architect__c")) && "Select Highest Degree Type");
        }
        // console.log('test pan first'+component.get("v.po.Degree__c"));
        
    },
    setExistingCustomerDetails: function(component, data) {
        console.log('degree here==>'+data.po.Degree__c);
        
        this.setPOData(component, data.po);
        this.setLeadData(component, data.lead);
        this.setOldLeadData(component);
        this.setOfferDetails(component, data.offer);
        console.log('=tyoe of  here=>'+component.get("v.po.Type_of_Degree__c"));
        var professionValue = component.get("v.lead.Profession_Type__c") || component.find("profession").get("v.value");
        console.log('profession hrere==>'+professionValue);
        if(professionValue=='Engineers')
        {
            this.showHideDiv(component, "qualificationEngineers", true);
            
            var result=['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40']
            this.setSelectOptions(component, result, "Business Vintage", "practiceExperience");
            this.setSelectOptions(component, result, "Post Qualification Experience", "postGradExperience");
        }
        console.log('here  po.Post_Graduate_Super_Specialist_Experienc__c before update form=>'+ component.get("v.po.Post_Graduate_Super_Specialist_Experienc__c"));
        console.log('here  po.Total_Employment_Vintage__c before update form=>'+ component.get("v.po.Total_Employment_Vintage__c"));
        this.setSurrogateCAM(component, data.scam);
        component.set("v.isExistingOffer", true);
        this.updateForm(component, data.po);
        console.log('here  po.Post_Graduate_Super_Specialist_Experienc__c before update form=>'+ component.get("v.po.Post_Graduate_Super_Specialist_Experienc__c"));
        console.log('here  po.Total_Employment_Vintage__c before update form=>'+ component.get("v.po.Total_Employment_Vintage__c"));
        console.log('=degree here=>'+component.get("v.po.Degree__c"));
        console.log('=tyoe of  here=>'+component.get("v.po.Type_of_Degree__c"));
        
        
    },
    calculateExp: function(component, event, helper) {
       //US: 10981 Data flow from mobility to DSS S: Removed if condition 
          var DifMs = Date.now() - Date.parse(component.get("v.po.Date_of_Incorporation__c"));
           var ExpDate = new Date(DifMs); 
          component.set("v.po.Total_Employment_Vintage__c",Math.abs(ExpDate.getUTCFullYear() - 1970));
            console.log('experience in year ====>'+component.get("v.po.Total_Employment_Vintage__c"));
        
    },
    setSurrogateCAM: function(component,newSam){
        var srgtcam = component.get("v.scam"); 
        srgtcam.Id = newSam.Id || srgtcam.Id;
        srgtcam.Program_Type__c=newSam.Program_Type__c || srgtcam.Program_Type__c;
        srgtcam.Rural_Loan_Type__c=newSam.Rural_Loan_Type__c || srgtcam.Rural_Loan_Type__c;
        srgtcam.CY_Net_Profit__c= newSam.CY_Net_Profit__c || srgtcam.CY_Net_Profit__c;
        srgtcam.Gross_Receipts__c=newSam.Gross_Receipts__c || srgtcam.Gross_Receipts__c;
        srgtcam.PY_Type_of_Financial__c=newSam.PY_Type_of_Financial__c || srgtcam.PY_Type_of_Financial__c;
        
        component.set("v.scam", srgtcam);
    },
    checkForExistingOffers: function(component) {
        console.log('Checking existing offer');
        var lead = component.get("v.lead");
        var productFlow = component.get('v.productFlow') === 'RDL' ? 'RDL' : 'PRO';
        console.log('Produtc : ' + productFlow);
        this.executeApex(component, "checkForExistingOffers", {
            "firstName": lead.FirstName,
            "lastName": lead.LastName,
            "mobile": lead.MobilePhone,
            "product": productFlow
        }, function(error, result) {
            console.log('error: ' + error);
            console.log('result : ' + result);
            if (!error && result && result.length) {
                component.set("v.existingOffers", result);
                this.showHideDiv(component, "grabOffers", true);
            } else {
                this.createLeadData(component);
            }
        });
    },
    grabOffer: function(component, poId) {
        console.log('inside grabOffer');
        this.executeApex(component, "grabExistingOffer", {
            "poId": poId
        }, function(error, result) {
            if (!error && result) {
                this.setExistingCustomerDetails(component, JSON.parse(result));
                //PSL changes : Nikhil Bugfix #11888
                this.triggerDisplayOfferEvent(component);
                this.showHideDiv(component, "grabOffers", false);
            }
        });
    },
    createLeadData: function(component) {
        
        var lead = component.get("v.lead");
        //Bug 12827 Point 1 S
        /*   if(component.get("v.po.Specialisation__c").toLowerCase() === 'ca'){
               lead.Profession_Type__c = 'CA';
               lead.LeadSource = 'ProMobility CA';
           } else {
               lead.Profession_Type__c = 'Doctor';
               lead.LeadSource = 'ProMobility Doctor';
           }*/
        // Bug 14509 s - RDL Eligibility calculation
        var flow = component.get("v.productFlow");
        console.log('flow here is', flow);
        if (flow === 'PROMOBILITY') {
            //Bug 12827 Point 1 S
            if (component.get("v.po.Specialisation__c").toLowerCase() === 'ca') {
                lead.Profession_Type__c = 'CA';
                lead.LeadSource = 'ProMobility CA';
            }
            //Bug 12827 Point 1 E
        } else if (flow === 'RDL') {
            //lead.Profession_Type__c = 'Doctor';
            lead.LeadSource = 'RDL Mobility';
            lead.Product__c = 'RDL'; //Added By Gulshan for Stampping the Product in Lead
        } else {
            lead.Profession_Type__c = 'Doctor';
            lead.LeadSource = 'ProMobility Doctor';
            lead.Product__c = 'PRO'; //Added By Gulshan for Stampping the Product in Lead
        }
        /*if(component.find("profession").get("v.value"))
        if(component.find("profession").get("v.value").toLowerCase() === 'ca'){
           lead.LeadSource = 'ProMobility CA';
        }else if(component.find("profession").get("v.value").toLowerCase() === 'doctor'){
           lead.LeadSource = 'ProMobility Doctor';
        }else{
           lead.LeadSource = 'ProMobility Engineer';
        }
        commentted after moving above var flow code*/
        
        
        // Bug 14509 E - RDL Eligibility calculation
        // Bug 14509 s - RDL Eligibility calculation - Logic shifting
        lead.Company = 'Others';
        lead.Applicant_Type__c = 'Primary Applicant';
        lead.Customer_Type__c = 'Individual';
        
        if (component.find("profession").get("v.value").toLowerCase() === 'Engineers') {
            lead.Employment_Type__c = component.get("v.po.Practice_Type__c");
            lead.Product__c = 'PRO';
        } else
            lead.Employment_Type__c = 'SEP';
        lead.Resi_Pin_Code__c = '' + lead.Resi_Pin_Code__c;
        // Bug 14509 E       
        //Rohit added ekyc record data S
        console.log('here===>');
        var kyc = component.get("v.kyc");
        if (kyc == null || kyc.eKYC_City__c == null || kyc.eKYC_City__c == '') {
            kyc = null;
            console.log('here===>');
        } else { //added else by shilpa for prod issue 18669
            console.log('here===>');
            kyc = JSON.stringify(component.get("v.kyc"));
        }
        //Rohit added ekyc record data E
        lead.Id = lead.Id !== '' ? lead.Id : null;
        this.executeApex(component, "createLead", {
            "lead": JSON.stringify(lead),
            "ekyc": JSON.stringify(kyc)
        }, function(error, result) {
            console.log('result===>'+result);
            if (!error && result) {
                //Bug 14716 S
                var isRetrigger = this.isRetriggerCIBIL(component);
                console.log("isRetrigger from Lead : " + isRetrigger);
                //isRetrigger = isRetrigger ? true : false ;
                component.set("v.isRetriggerCIBIL", isRetrigger);
                this.setLeadData(component, result);
                this.setOldLeadData(component);
                // Bug 14716 E
                this.createPOData(component);
                
            }
        });
    },
    createSurogateCam: function(component) {
        console.log('component.get("v.po").Id==>'+component.get("v.po").Id);
        component.set("v.scam.Product_Offerings__c" , component.get("v.po").Id); 
        console.log('inside createSurogateCam'+component.get("v.scam").Product_Offerings__c);
        if (component.find("profession").get("v.value") == 'Taxconsultant' || component.find("profession").get("v.value") == 'Pharmacist' || component.find("profession").get("v.value") == 'Doctor' || component.find("profession").get("v.value") == 'Engineers') {
            console.log('inside finanical');
            component.set("v.scam.PY_Type_of_Financial__c" ,'NonFinancial'); 
            console.log('v.scam.PY_Type_of_Financial__c' , component.get("v.scam").PY_Type_of_Financial__c);
        }
        //US: 10981 Data flow from mobility to DSS S
        component.set("v.scam.Program_Type__c" ,'RDL NO FINANCIALS CHAMPION CHALLENGER'); 
        //US: 10981 Data flow from mobility to DSS E 
        var srgtcam = component.get("v.scam");
        this.executeApex(component, "createSCam", {
            "scam": srgtcam
        }, function(error, result) {
            console.log('result over here in scam is==>'+result);
            if (!error && result) {
                this.setSurrogateCAM(component, result);
                
            }
        });
    },
    createPOData: function(component) {
        console.log('inside createPOData');
        
        this.calculateDegree(component);
        var po = component.get("v.po");
        po.Lead__c = component.get("v.lead").Id;
        po.Data_Mart_Status__c = 'LIVE'; //Bug 14863
        var spzFound;
        spzFound=component.find("specialization");
        if(spzFound)
            po.Specialisation__c = component.find("specialization").get("v.value");
        var segmentValue = component.get("v.lead.Profession_Type__c") || component.find("profession").get("v.value");
        console.log('segmentValue here ==>'+segmentValue);
        if(component.find("profession").get("v.value") == 'Engineers'){
            this.showHideDiv(component, "qualificationEngineers", true);
            console.log('inside Engineers');
            var practiceExcmp,postGradExp;
            practiceExcmp=component.find("practiceExperience");
            postGradExp=component.find("postGradExperience");
            console.log('practiceExcmp==>'+practiceExcmp);
            console.log('postGradExp==>'+postGradExp);
            if(practiceExcmp){
                console.log('practiceExcmp value id ==>'+component.find("practiceExperience").get("v.value"));
                po.Total_Employment_Vintage__c = component.find("practiceExperience").get("v.value");
            }
            if(postGradExp){
                console.log('postGradExperience value id ==>'+component.find("postGradExperience").get("v.value"));
                po.Post_Graduate_Super_Specialist_Experienc__c = component.find("postGradExperience").get("v.value");
            }
        }
        po.Practice_Type__c = component.find("practiceType").get("v.value");
        var obligationFound;
        obligationFound=component.find("obligations");
        var monthlyObligation;
        if(obligationFound){
            monthlyObligation= component.find("obligations").get("v.value"); // Bug 13675 - Hemant Keni
            po.Monthly_Obligation__c = component.find("obligations").get("v.value"); // Bug 13675 - Hemant Keni
        }
        
        po.Id = po.Id !== '' ? po.Id : null;
        
        console.log('test UTM' + po.UTM_Source__c);
        po.DOB__c = component.get("v.lead").DOB__c;
        po.Total_work_experience__c = po.Post_Graduate_Super_Specialist_Experienc__c;
        po.Experience_in_Years__c = po.Total_Employment_Vintage__c;
        
        // Bug 14509 S - RDL Eligibility calculation - logic shifting from apex to helper - createProductOffering
        var flow = component.get("v.productFlow");
        po.Process_Type__c = 'PRE APPROVED';
        console.log('flow : ' + flow);
        if (flow === 'PROMOBILITY') {
            console.log('po.Product_Offering_Type1__c : ' + po.Product_Offering_Type1__c + ' po.Products__c : ' + po.Products__c);
            if (po.Product_Offering_Type1__c === 'DLUS_Preapproved' && po.Products__c === 'DOCTORS')
                po.Products__c = 'DOCTORS';
            else
                po.Products__c = 'PRO';
            
            po.UTM_Source__c = 'proMobile';
        } else if (flow === 'RDL') {
            po.Products__c = 'RDL';
            po.UTM_Source__c = 'RDLMobile';
        }
        //Bug 14509 E - RDL Eligibility calculation
        
        
        //Bug 16207 - January 2018 BRD - Engineering program in mobility
        if (component.get("v.productFlow") === 'RDL')
            po.Mobile_Source__c = 'rdlmobility';
        else
            po.Mobile_Source__c = 'promobility';
        //Bug 16207 - January 2018 BRD - Engineering program in mobility
        
        
        // Bug 13675 S - Hemant Keni
        //Bug 12827 Point 2 S
        if (component.get("v.productFlow") != 'RDL') {
            if (po.Specialisation__c == 'CA' || po.Specialisation__c == 'CS' || po.Specialisation__c == 'CWA') { // Bug 15858 - December_2017_CS/CWA Program start
                po.Program_Type__c = 'SEP';
                po.Full_Time_COP_Holder__c = 'YES';
                po.Is_COP_Active__c = 'ACTIVE';
                po.Monthly_Obligation_From_PO__c = monthlyObligation;
                po.Lead_Source__c = 'ProMobility CA';
            } else if (component.get("v.lead").Profession_Type__c.toLowerCase() === 'doctor') {
                po.Monthly_Obligation__c = monthlyObligation;
                po.Lead_Source__c = 'ProMobility Doctor';
            } else {
                po.Monthly_Obligation__c = monthlyObligation;
                po.Lead_Source__c = 'ProMobility Engineer';
            }
        }
        
        if (component.get("v.productFlow") === 'RDL') {
            if (po.Specialisation__c == 'CA' || po.Specialisation__c == 'CS' || po.Specialisation__c == 'CWA') { // Bug 15858 - December_2017_CS/CWA Program start
                po.Program_Type__c = 'SEP';
                po.Full_Time_COP_Holder__c = 'YES';
                po.Is_COP_Active__c = 'ACTIVE';
                po.Monthly_Obligation_From_PO__c = monthlyObligation;
                po.Lead_Source__c = 'RDLMobility CA';
            } 
            else if(component.get("v.lead").Profession_Type__c.toLowerCase() === 'doctor')
            {
                po.Monthly_Obligation__c = monthlyObligation;
                po.Lead_Source__c = 'RDLMobility Doctor';
            }
                else if(component.get("v.lead").Profession_Type__c.toLowerCase() === 'pharmacist'){
                    po.Monthly_Obligation__c = monthlyObligation;
                    po.Lead_Source__c = 'RDLMobility Pharmacist';
                }
                    else if (po.Specialisation__c === 'Taxconsultant') {
                        console.log('inside Taxconsulatant');
                        po.Monthly_Obligation__c = monthlyObligation;
                        po.Lead_Source__c = 'RDLMobility Taxconsulatant';
                    } else {
                        po.Monthly_Obligation__c = monthlyObligation;
                        po.Lead_Source__c = 'RDLMobility Engineer';
                    }
        }
        //Bug 12827 Point 2 E 
        // Bug 13675 E- Hemant Keni
        this.executeApex(component, "createPO", {
            "po": po
        }, function(error, result) {
            if (!error && result) {
                this.setPOData(component, result);
                
                this.createSurogateCam(component);
                var kyc = component.get("v.kyc");
                kyc.Lead__c = component.get("v.lead").Id;
                kyc.Product_Offerings__c = component.get("v.po").Id;
                component.set('v.kyc', kyc);
                if (!$A.util.isEmpty(kyc.Id)) {
                    this.updateKYC(component);
                } else {
                    this.createCIBIL(component);
                }
            }
        });
    },
    updateKYC: function(component) {
        var kyc = component.get("v.kyc");
        this.executeApex(component, "saveKYC", {
            "kycId": kyc.Id,
            "leadId": kyc.Lead__c,
            "poId": kyc.Product_Offerings__c
        }, function(error, result) {
            if (!error && result) {
                this.createCIBIL(component);
            }
        });
    },
    createCIBIL: function(component, callback) {
        console.log('inside createCIBIL');
        if (this.validateLeadInputData(component)) {
            // Bug 13114 - added new parameter to call createCibilTempRecord
            // Bug 14716 - changed retrigger parameter
            this.executeApex(component, "createCibilTempRecord", {
                "leadObj": component.get("v.lead"),
                "po": component.get("v.po"),
                "retrigger": component.get("v.isRetriggerCIBIL")
            }, function(error, result) {
                if (!error && result) {
                    //console.log('Result : '+ result.status);
                    component.set("v.cibilTempId", result);
                    this.setTimeout(this.showSpinner, this, 1, component);
                    this.setTimeout(this.checkForCIBILScore, this, 5000, component);
                } else if (!error) {
                    this.showToast(component, "Error!", "Please check the data and reinitiate. " + error, "error");
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
                    this.getCIBILDataforDOL(component);
                } else {
                    this.showHideDiv(component, "alertDialog", true);
                }
            }
        });
    },
    getCIBILDataforDOL: function(component, cibilTempId) {
        this.executeApex(component, "getCIBILDataforDOL", {
            "flow": "1",
            "poId": component.get("v.po").Id,
            "leadId": component.get("v.lead").Id,
            "cibilTempId": component.get("v.cibilTempId")
        }, function(error, result) {
            //Rohit 16111 CR (added condition for ekyc) S
            var ekyc = component.get("v.kyc");
            console.log('result', result);
            if (!error && result) {
                result = JSON.parse(result);
                //Rohit 16111 CR (added condition for ekyc)
                ekyc = result.ekycmobility;
                console.log(result);
                console.log("robin33 " + ekyc + "----" + result.status + "---" + result.eKYCState);
                console.log('result===>'+result);
                if (result.status === 'SUCCESS') {
                    
                    result = result.message.split('=') || [];
                    this.setOldLeadData(component);
                    this.setOfferDetails(component, {
                        "offerAmount": (Math.round((result[1] || 0) * 100) / 100)/100000,
                        /*"segmentation": result[4],
                        "cibilScore": result[5]*/
                        "segmentation": result[5],
                        "cibilScore": result[17],
                        "strPOID" : component.get("v.po").Id
                    });
                    this.triggerPostSaveEvent(component);
                    this.showHideDiv(component, "nextButtonId", true);
                    this.showToast(component, 'Success!', "Customer Details Saved successfully. Please proceed to the next Tab.", 'success');
                    // Bug 13022 S
                } else if (result.status === 'Skipping BRE') {
                    console.log('Skipping BRE : ');
                    this.setOldLeadData(component);
                    this.triggerPostSaveEvent(component);
                    this.showHideDiv(component, "nextButtonId", true);
                    this.showToast(component, 'Success!', "Customer Details Saved successfully. Please proceed to the next Tab.", 'success');
                    // Bug 13022 E                 
                } else {
                    console.log('failed to call getCIBILDataforDOL');
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
                    //Rohit 16111 CR (added condition for ekyc) S
                    console.log(ekyc);
                    /* if((result.eKYCState=='YES'  && ekyc != null && ekyc.eKYC_City__c != '' && ekyc.eKYC_City__c != undefined) || result.eKYCState=='NO'){
                      	this.showToast(component,'Error!', result.message, 'error');
                      }
                      else{
                            this.showToast(component,'Error!', "Please initiate E-kyc !", 'error');
                      }*/
                    //Added by mahima - 17527
                    // if(result.status=='MCP FAILED')
                    //{
                    //  this.showToast(component,'Error!', result.status, 'error');
                    //}                    
                    //else  //Added by mahima - 17527
                    this.showToast(component, 'Error!', result.message, 'error');
                     $A.util.addClass(component.find("nextButtonId"),"slds-hide");
                    //Rohit 16111 CR (added condition for ekyc) E    
                }
            }
        });
    },
    triggerPostSaveEvent: function(component) {
        var customerSaveEvent = $A.get("e.c:CustomerSaveEvent");;
        customerSaveEvent.setParams({
            "kyc": component.get("v.kyc"),
            "po": component.get("v.po"),
            "lead": component.get("v.lead"),
            "offer": component.get("v.offer")
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
        var displayOfferEvent = $A.get("e.c:DisplayOfferEvent");;
        displayOfferEvent.setParams({
            "offer": component.get("v.offer")
        });
        displayOfferEvent.fire();
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
        if(key == 'source')
        {
            var branchName = component.get('v.branchSearchKeyword');
            console.log('branchName-->',branchName);
            this.executeApex(component, "fetchSourcingChannel", {
                'searchKeyWord': keyword,            
                'searchBranch' :branchName
            }, function(error, result){
                if(!error && result){
                    this.handleSearchResult(component, key, result); 
                }
            });
        }
        else 
        {
            this.executeApex(component, "fetch" + this.toCamelCase(key), {
                'searchKeyWord': keyword
            }, function(error, result) {
                if (!error && result) {
                    this.handleSearchResult(component, key, result);
                }
            });
        }
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
        component.set("v.kyc", kyc);
        //Rohit S
        var eKycCity = kyc.eKYC_City__c;
        if (eKycCity != undefined && eKycCity != '') {
            eKycCity.replace(' City', '');
        }
        //Rohit e
        //Rohit commented Line 614 for Bug 20753
        this.setResidenceAddress(component);
        this.setLeadData(component, {
            FirstName: kyc.eKYC_First_Name__c,
            LastName: kyc.eKYC_Last_Name__c,
            Email: kyc.eKYC_E_mail__c,
            /*DOB__c: kyc.eKYC_Date_of_Birth__c,*/
            Resi_City__c: eKycCity,
            MobilePhone: kyc.eKYC_Mobile_Number__c,
            Resi_Pin_Code__c: kyc.eKYC_Pin_Code__c
        });
    },
    setLeadData: function(component, newLead) {
        var lead = component.get("v.lead");
        lead.Id = newLead.Id || lead.Id;
        lead.FirstName = newLead.FirstName || lead.FirstName;
        lead.LastName = newLead.LastName || lead.LastName;
        lead.Email = newLead.Email || lead.Email;
        lead.PAN__c = newLead.PAN__c || lead.PAN__c;
        lead.DOB__c = newLead.DOB__c || lead.DOB__c;
        lead.State__c = newLead.State__c || lead.State__c;
        lead.Resi_City__c = newLead.Resi_City__c || lead.Resi_City__c;
        lead.Property_Owner__c  = newLead.Property_Owner__c  || lead.Property_Owner__c ;
        lead.Vintage_in_Business__c  = newLead.Vintage_in_Business__c  || lead.Vintage_in_Business__c ;
        //PSL changes : Nikhil Bugfix #11801
        //regex to replace all non numeric fields from mobile field
        var newMobile = newLead.MobilePhone;
        if (newLead.MobilePhone != undefined && typeof newLead.MobilePhone == "string")
            newMobile = newMobile.replace(/[^0-9.]/g, "");
        
        lead.MobilePhone = '' + (newMobile || lead.MobilePhone);
        lead.SBS_Branch__c = newLead.SBS_Branch__c || lead.SBS_Branch__c;
        lead.Resi_Pin_Code__c = '' + (newLead.Resi_Pin_Code__c || lead.Resi_Pin_Code__c);
        lead.Residential_type__c = newLead.Residential_type__c || lead.Residential_type__c;
        lead.Profession_Type__c = newLead.Profession_Type__c || lead.Profession_Type__c;
        lead.Residence_Address_Line1__c = newLead.Residence_Address_Line1__c || lead.Residence_Address_Line1__c;
        lead.Residence_Address_Line2__c = newLead.Residence_Address_Line2__c || lead.Residence_Address_Line2__c;
        lead.Residence_Address_Line3__c = newLead.Residence_Address_Line3__c || lead.Residence_Address_Line3__c;
        
        if (newLead.SBS_Branch__r) {
            component.set("v.branchSearchKeyword", newLead.SBS_Branch__r.Name);
            var selectedBranch = component.get("v.selectedBranch");
            selectedBranch.Id = newLead.SBS_Branch__c;
            selectedBranch.Name = newLead.SBS_Branch__r.Name;
            component.set("v.selectedBranch", selectedBranch);
        }
        component.set("v.lead", lead);
        component.set("v.residenceAddress", lead.Residence_Address_Line1__c + lead.Residence_Address_Line2__c + lead.Residence_Address_Line3__c);
        component.set("v.residenceCitySearchKeyword", lead.Resi_City__c);
    },
    setPOData: function(component, newPO) {
        var po = component.get("v.po");
        console.log('po.Degree__c : ' + po.Degree__c);
        console.log('newPO.Degree__c : ' + newPO.Degree__c);
        po.Id = newPO.Id || po.Id;
        po.Lead__c = newPO.Lead__c || po.Lead__c;
        po.Practice_Type__c = newPO.Practice_Type__c || po.Practice_Type__c;
        po.Specialisation__c = newPO.Specialisation__c || po.Specialisation__c;
        po.Sourcing_Channel__c = newPO.Sourcing_Channel__c || po.Sourcing_Channel__c;
        po.Total_Employment_Vintage__c = '' + (newPO.Total_Employment_Vintage__c || po.Total_Employment_Vintage__c);
        console.log('po.Total_Employment_Vintage__c==>'+po.Total_Employment_Vintage__c);
        po.Post_Graduate_Super_Specialist_Experienc__c = '' + (newPO.Post_Graduate_Super_Specialist_Experienc__c || po.Post_Graduate_Super_Specialist_Experienc__c);
        console.log('po.Post_Graduate_Super_Specialist_Experienc__c==>'+po.Post_Graduate_Super_Specialist_Experienc__c);
        po.Degree__c = newPO.Degree__c || po.Degree__c; // bug 14509
        console.log('po.Degree__c : ' + po.Degree__c);
        po.Product_Offering_Type1__c = newPO.Product_Offering_Type1__c || po.Product_Offering_Type1__c; // Bug 15353
        console.log('Products__c : NEW PO - ' + newPO.Products__c + '  PO - ' + po.Products__c);
        po.Products__c = newPO.Products__c || po.Products__c; //	Bug 15353
        po.Date_of_Incorporation__c = newPO.Date_of_Incorporation__c || po.Date_of_Incorporation__c;
        console.log('Type_of_Degree__c===>'+newPO.Type_of_Degree__c);
        po.Type_of_Degree__c =  newPO.Type_of_Degree__c || po.Type_of_Degree__c;
        po.Clinic_Type__c  = newPO.Clinic_Type__c  || po.Clinic_Type__c ;
        po.Turnover__c  = newPO.Turnover__c  || po.Turnover__c ;
        po.Any_top_taken_in_last_12_months__c  = newPO.Any_top_taken_in_last_12_months__c  || po.Any_top_taken_in_last_12_months__c ;
        po.Customer_Declined_under_BL_HL_LAP__c = newPO.Customer_Declined_under_BL_HL_LAP__c || po.Customer_Declined_under_BL_HL_LAP__c;
        
        
        //Bug 16207 - January 2018 BRD - Engineering program in mobility
        po.Resi_Pick_City__c = newPO.Resi_Pick_City__c || po.Resi_Pick_City__c;
        po.UTM_Source__c = newPO.UTM_Source__c || po.UTM_Source__c;
        po.TypeOfDegreeforCA_Architect__c = newPO.TypeOfDegreeforCA_Architect__c || po.TypeOfDegreeforCA_Architect__c;
        if (newPO.Sector_Industry__r) {
            component.set("v.collegeSearchKeyword", newPO.Sector_Industry__r.Name);
            var selectedCollege = component.get("v.selectedCollege");
            selectedCollege.Id = newPO.Sector_Industry__c;
            selectedCollege.Name = newPO.Sector_Industry__r.Name;
            component.set("v.selectedCollege", selectedCollege);
        }
        //Bug 16207 - January 2018 BRD - Engineering program in mobility
        
        // Bug 13675 S - Hemant Keni
        if (newPO.Specialisation__c == 'CA' || newPO.Specialisation__c == 'CS' || newPO.Specialisation__c == 'CWA') // Bug 15858 - December_2017_CS/CWA Program start
            component.set("v.monthlyObligation", newPO.Monthly_Obligation_From_PO__c);
        else if (newPO.Specialisation__c)
            component.set("v.monthlyObligation", newPO.Monthly_Obligation__c);
        
        console.log('obligation here==>'+component.get("v.monthlyObligation"));
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
            component.set("v.selectedSource", selectedSource);
        }
        console.log('Needhi Degree__c : ' , po.Degree__c);
        //component.set("v.po.Degree__c", 'Other'); // just checking
        console.log('Needhi find comp -->', component.find("degree"));
        console.log('Needhi val comp -->', component.get("v.po.Degree__c"));
        console.log('Type_of_Degree__c===>'+component.get("v.po.Type_of_Degree__c"));
        
        
        console.log('Needhi Total_Employment_Vintage__c -->', component.get("v.po.Total_Employment_Vintage__c"));
        console.log('Needhi Post_Graduate_Super_Specialist_Experienc__c===>'+component.get("v.po.Post_Graduate_Super_Specialist_Experienc__c"));
        
        
        component.set("v.po", po);
        console.log('Needhi Total_Employment_Vintage__c -->', component.get("v.po.Total_Employment_Vintage__c"));
        console.log('Needhi Post_Graduate_Super_Specialist_Experienc__c===>'+component.get("v.po.Post_Graduate_Super_Specialist_Experienc__c"));
        
    },
    setOfferDetails: function(component, offer) {
        component.set("v.offer", offer);
    },
    setOldLeadData: function(component) {
        var lead = component.get("v.lead");
        var oldLead = component.get("v.oldLead") || {};
        oldLead.FirstName = lead.FirstName;
        oldLead.LastName = lead.LastName;
        oldLead.MobilePhone = lead.MobilePhone;
        oldLead.PAN__c = lead.PAN__c;
        oldLead.DOB__c = lead.DOB__c; // Bug 14716 
        component.set("v.oldLead", oldLead);
        console.log('old lead here==>'+JSON.stringify(component.get("v.oldLead")));
    },
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
            console.log(oldLead.FirstName + " FirstName : " + lead.FirstName);
            console.log(oldLead.LastName + " Last name : " + lead.LastName);
            console.log(oldLead.MobilePhone + " Mobile NO : " + lead.MobilePhone);
            console.log(oldLead.PAN__c + " PAN : " + lead.PAN__c);
            console.log(oldLead.DOB__c + " DOB : " + lead.DOB__c);
            console.log("DOB = " + (oldLead.DOB__c !== lead.DOB__c));
            
            var isRetrigger = (oldLead.FirstName !== lead.FirstName ||
                               oldLead.LastName !== lead.LastName ||
                               oldLead.MobilePhone !== lead.MobilePhone ||
                               oldLead.PAN__c !== lead.PAN__c ||
                               oldLead.DOB__c !== lead.DOB__c
                              );
            console.log("isRetrigger : " + isRetrigger);
            return isRetrigger;
        }
        return false;
    },
    // Bug 14716  E    
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
    },
    validateLeadInputData: function(component) {
        console.log('inside validateLeadInputData');
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
                       value: component.get("v.po.Sourcing_Channel__c"),
                       auraId: "sourceName",
                       message: "Enter Sourcing Channel"
                   },
                   {
                       value: lead.Profession_Type__c,
                       auraId: "profession",
                       message: "Enter Segment Type"
                   }
                   
                  ];
        if(component.get("v.lead.Profession_Type__c")!=''){
            if (component.find("practiceType")){
                lst.push({
                    value: component.get("v.po.Practice_Type__c"),
                    auraId: "practiceType",
                    message: "Select Practice Type"
                });
            }
            if (component.find("dateOfRegstrtion")){
                console.log('inside find dateOfRegstrtion');
                lst.push({
                    value: component.get("v.po.Date_of_Incorporation__c"),
                    auraId: "dateOfRegstrtion",
                    message: "Enter Date of Registration"
                });
            } 
            // bug 14509 - RDL Mobility s
            if (component.find("profession").get("v.value") != 'Taxconsultant') {
                if (component.get("v.productFlow") === 'RDL' &&  component.find("degree")) {
                    console.log('inside find degree');
                    lst.push({
                        value: component.get("v.po.Degree__c"),
                        auraId: "degree",
                        message: "Select Degree"
                    });
                }
            }
        }
        // bug 14509 - RDL Mobility E
        if (component.find("profession").get("v.value") == 'Taxconsultant') {
            lst.push({
                value: component.get("v.po.Type_of_Degree__c"),
                auraId: "qualifications",
                message: "Select Qualification"
            });
            
        }
        if (component.find("profession").get("v.value") == 'Doctor') {
            lst.push({
                value: component.get("v.po.Specialisation__c"),
                auraId: "specialization",
                message: "Select specialization"
            });
        }
        if (component.find("profession").get("v.value") == 'CA') {
            lst.push({
                value: component.get("v.scam.PY_Type_of_Financial__c"),
                auraId: "programType",
                message: "Select Program Type"
            });
            lst.push({
                value: component.get("v.po.Clinic_Type__c"),
                auraId: "officeOwnership",
                message: "Select Office Ownership"
            });
            
        }
        if (component.find("profession").get("v.value") == 'CA' && component.find("programType").get("v.value")=='Financial') 
        {
            lst.push({
                value: component.get("v.scam.Rural_Loan_Type__c"),
                auraId: "method",
                message: "Select method"
            });
            
            lst.push({
                value: component.get("v.monthlyObligation"),
                auraId: "obligations",
                message: "Enter Monthly Obligation"
            });
            if(component.find("method").get("v.value") == 'Cash Profit'){
                lst.push({
                    value: component.get("v.scam.CY_Net_Profit__c"),
                    auraId: "netProfit",
                    message: "Enter Cash Profit"
                }); 
            }
            if(component.find("method").get("v.value") == 'Gross Receipt'){
                lst.push({
                    value: component.get("v.scam.Gross_Receipts__c"),
                    auraId: "grossReceipt",
                    message: "Enter Gross Receipt"
                }); 
            }
        }
        if (component.find("profession").get("v.value") == 'Pharmacist') {
            lst.push({
                value: component.get("v.lead.Vintage_in_Business__c"),
                auraId: "shopVintage",
                message: "Enter Shop Vintage"
            });
            
            lst.push({
                value: component.get("v.po.Turnover__c"),
                auraId: "Turnover",
                message: "Enter Turnover"
            });
            lst.push({
                value: component.get("v.po.Customer_Declined_under_BL_HL_LAP__c"),
                auraId: "ShopOwned",
                message: "Enter Shop Owned"
            });
            lst.push({
                value: component.get("v.po.Any_top_taken_in_last_12_months__c"),
                auraId: "unsecuredloan",
                message: "Enter Any other unsecured loan from BFL"
            });
            lst.push({
                value: component.get("v.lead.Property_Owner__c"),
                auraId: "DegreeOwned",
                message: "Enter Degree Owned"
            });
            
        }
        //Bug 16207 - January 2018 BRD - Engineering program in mobility Rajesh
        if (component.find("profession").get("v.value") == 'Engineers') {
            lst.push({
                value: component.get("v.po.TypeOfDegreeforCA_Architect__c"),
                auraId: "highestDegreeType",
                message: "Select Highest Degree Type"
            });
        }
        //Bug 16207 - January 2018 BRD - Engineering program in mobility Rajesh
        
        for (var i = 0; i < lst.length; i++) {
            isEmpty = this.isEmpty(lst[i].value);
            isValid = isValid && !isEmpty;
            console.log('calling error method for==>');
            this.addRemoveInputError(component, lst[i].auraId, isEmpty && lst[i].message);
        }
        return isValid;
    },
    validateField: function(component, key, pattern, error) {
        
        var field = component.find(key);
        
        var value = '' + field.get("v.value");
        // Bug 14908 S
        var valid = true;
        //console.log('key : '+ key +" = "+ (key === 'lastName')+ " Pattern : "+ pattern.test(value) );
        if (key === 'firstName')
            valid = !!(value == '' || pattern.test(value));
        else
            valid = !!(value == '' || pattern.test(value.trim()));
        //console.log('valid : '+ valid);
        //var valid = !!(value == '' || pattern.test(value.trim()));
        // Bug 14908 E
        
        field.set("v.errors", [{
            message: valid ? "" : "Enter a valid " + error
        }]);
        return valid;
        
    },
    validateMobileNumber: function(component) {
        component.set("v.lead.MobilePhone", ('' + component.get("v.lead.MobilePhone")).replace(/[a-zA-z]/g, ''));
        return this.validateField(component, "mobileNumber", /^[7-9]\d{9}/, "Mobile Number");
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
        var keyFound=component.find(key);
        if(keyFound){
            if (key === 'firstName')
                return this.validateField(component, key, /^[A-Za-z]{1,100}$/, error);
            else
                return this.validateField(component, key, /^[a-zA-z]+([ ][a-zA-Z]+)*$/, error);
            // Bug 14908 E
        }
    },
    validateFirstName: function(component) {
        console.log('inside validateFirstName');
        return this.validateName(component, "firstName", "First Name");
    },
    validateLastName: function(component) {
        console.log('inside lastName');
        return this.validateName(component, "lastName", "Last Name");
    },
    validateAddress: function(component) {
        console.log('inside residenceAddress');
        return this.validateField(component, "residenceAddress", /^.{9,}$/, "Residence Address");
    },
    validateCashProfit: function(component) {
        return this.validateField(component, "netProfit", /^[0-9]{1,10}$/, "Net profit + Depreciation");
    },
    validateGrossReceipt: function(component) {
        return this.validateField(component, "grossReceipt", /^[0-9]{1,10}$/, "Gross Receipt Amount");
    },
    validateTurnOver: function(component) {
        return this.validateField(component, "Turnover", /^[0-9]{1,10}$/, "Turnover");
    },
    // Bug 13675 S - hemant Keni
    validateObligation: function(component) {
        
        return this.validateField(component, "obligations", /^[0-9]{1,10}$/, "Monthly obligations");
    },
    validateShopVintage: function(component) {
        return this.validateField(component, "shopVintage", /^[0-9]{1,10}$/, "Shop Vintage");
    },
    // Bug 13675 E - hemant Keni
    //PSL changes : Nikhil Bugfix #11805, #11806
    validateDOB: function(component) {
        var dob = new Date(component.get('v.lead').DOB__c).getTime();
        if (isNaN(dob)) return true;
        var dtToday = (new Date()).getTime();
        var timeDiff = dtToday - dob;
        // Bug 15381 S - Hemant Keni
        var diffDays = (timeDiff / (1000 * 3600 * 24 * 365.25)).toFixed(3);
        var result = this.isEmpty(dob) || (diffDays > 24.999 && diffDays <= 70.00);
        // Bug 15381 E - Hemant Keni
        component.find("dateOfBirth").set("v.errors", [{
            message: result ? "" : "Your age should be greater than 25 and less than 71"
        }]);
        return result;
    },
    validate: function(component) {
        var isValid = true,
            result;
        console.log('inside validate');
        result = this.validateFirstName(component);
        isValid = isValid && result;
        
        result = this.validateLastName(component);
        isValid = isValid && result;
        console.log('inside validateLastName');
        result = this.validateMobileNumber(component);
        isValid = isValid && result;
        console.log('inside validateMobileNumber');
        result = this.validateEmail(component);
        isValid = isValid && result;
        console.log('inside validateEmail');
        result = this.validatePAN(component);
        isValid = isValid && result;
        console.log('inside validatePAN');
        result = this.validatePIN(component);
        isValid = isValid && result;
        console.log('inside validatePIN');
        //PSL changes : Nikhil Bugfix #11805, #11806
        result = this.validateDOB(component);
        isValid = isValid && result;
        console.log('inside validateDOB');
        result = this.validateAddress(component);
        isValid = isValid && result;
        console.log('inside validateAddress');
        
        
        
        if (component.find("profession").get("v.value") == 'CA' && component.find("programType")!='undefined' && component.find("programType").get("v.value")=='Financial') {
            if(component.find("method").get("v.value") == 'Cash Profit'){
                result = this.validateCashProfit(component);
                isValid = isValid && result;
                console.log('inside validateCashProfit');
            }
            
            if(component.find("method").get("v.value") == 'Gross Receipt'){
                result = this.validateGrossReceipt(component);
                isValid = isValid && result;
                console.log('inside validateGrossReceipt');
            }
        }
        if (component.find("profession").get("v.value") == 'Pharmacist'){
            result = this.validateTurnOver(component);
            isValid = isValid && result;
            console.log('inside validateTurnOver');
            result = this.validateShopVintage(component);
            isValid = isValid && result;
            console.log('inside validateShopVintage');
        }
        
        //PSL changes : Nikhil Bugfix #11765
        //Practice Exp Vs Post Graduate Exp validation
        // var practiceExp = parseInt(component.get("v.po.Total_Employment_Vintage__c"));
        //  var postGrExp = parseInt(component.get("v.po.Post_Graduate_Super_Specialist_Experienc__c"));
        //  if (isNaN(practiceExp) || isNaN(postGrExp))
        //     result = true;
        //  else
        //    result = component.get("v.productFlow") === 'RDL' ? (practiceExp >= postGrExp) : (practiceExp > postGrExp); // Bug 15550 - Hemant Keni
        
        //S::Added by Rohan for 16207, as this check not required for Engineers
        // result = component.find("profession").get("v.value") == 'Engineers' ? true : result;
        //E::Ended by Rohan for 16207, as this check not required for Engineers
        // component.find("postGradExperience").set("v.errors", [{
        //     message: result ? "" : component.find("profession").get("v.value") == 'Engineers' ? "Post Qualification Experience should always be less than Business Vintage" : "Post Graduate Experience should always be less than Practice Experience"
        // }]);
        // isValid = isValid && result;
        
        //result = !(component.get("v.sourceSearchKeyword") !== '' && component.get("v.selectedSource").Id == undefined);
        if($A.util.isEmpty(component.get("v.lead.Profession_Type__c"))){
            component.find("profession").set("v.errors", [{
                message: result ? "" : "Please select Segment Type"
            }]);
            isValid = isValid && result;
        }
        
        
        result = !(component.get("v.branchSearchKeyword") !== '' && component.get("v.selectedBranch").Id == undefined);
        component.find("branchName").set("v.errors", [{
            message: result ? "" : "Please select a valid Branch"
        }]);
        isValid = isValid && result;
        
        result = !(component.get("v.collegeSearchKeyword") !== '' && component.get("v.selectedCollege").Id == undefined);
        component.find("collegeName").set("v.errors", [{
            message: result ? "" : "Please select a valid College"
        }]);
        isValid = isValid && result;
        
        return isValid;
    },
    disableForm: function(component) {
        var list = [
            "firstName", "lastName", "mobileNumber", "email", "residenceAddress", "residenceCity",
            "pincode", "dateOfBirth", "specialization", "pannumber", "branchName", "sourceName",
            "practiceType", "residentialType", "profession","degree","dateOfRegstrtion",
            "qualifications","shopVintage","Turnover","ShopOwned","unsecuredloan","programType",
            "method","officeOwnership","practiceExperience","postGradExperience","obligations","netProfit","grossReceipt","DegreeOwned"
        ];
        for (var i = 0; i < list.length; i++) {
            var cmpFind=component.find(list[i]);
            if(cmpFind)
                component.find(list[i]).set("v.disabled", true);
        }
        component.find("submitButtonId").getElement().disabled = true;
    },
    isEmpty: function(value) {
        return ($A.util.isEmpty(value) || $A.util.isUndefined(value) || value === 0);
    },
    addRemoveInputError: function(component, key, message) {
        var cmpFindkey=component.find(key);
        if(cmpFindkey){
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
        action.setCallback(this, function(response) {
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
                this.showToast(component, "Error in !", method, errors.join(", "), "error");
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
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type,
                "mode": "dismissible",
                "duration": "30000"
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
        // event.stopPropagation(); 
        
        this.showHideDiv(component, "waiting", true);
    },
    hideSpinner: function(component) {
        //event.stopPropagation(); 
        
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
    //added for bug id 21851 start
    getHideAadhaarSectionHelper: function(component) {
        
        var action = component.get("c.getHideAadhaarSection");
        
        action.setCallback(this, function(response) {
            console.log('response here=>'+response);
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('hi >>' + response.getReturnValue());
                component.set('v.hideAadhaarSection', response.getReturnValue());
            } else if (state === "ERROR") {
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
    } //added for bug id 21851 stop   
})