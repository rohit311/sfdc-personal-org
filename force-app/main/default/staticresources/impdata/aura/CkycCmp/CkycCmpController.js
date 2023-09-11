({
    doInit : function(component, event, helper) {
        console.log('ckyc -->' , component.get("v.ckycFlow"));
        // Bug Id : 24716 added common spinner
        if (component.get("v.isReadOnly") == true) {
            console.log('ckyc isReadOnly -->' + component.get("v.isReadOnly"));
            helper.displayToastMessage(component,event,"Success","CKYC data is already downloaded sucessfully!",'success');
        }
        helper.showhidespinner(component,event,true);
        
        //component.set("v.Spinner",true);
        if (component.get("v.ckycFlow") && !$A.util.isEmpty(component.get("v.ckycFlow")["mobNo"])) { // Bug Id : 24716 start
            console.log('init --> ' + component.get("v.ckycFlow")["mobNo"]);
            component.set("v.mobNo", component.get("v.ckycFlow")["mobNo"]);
            component.find("mobval").set("v.disabled", true);
        } 
        if (component.get("v.ckycFlow") && !$A.util.isEmpty(component.get("v.ckycFlow")["panNo"])) {
            console.log('init --> ' + component.get("v.ckycFlow")["panNo"]);
            if(component.get("v.poiType") == 'PAN') {
                component.set("v.poiNumber", component.get("v.ckycFlow")["panNo"]);
            }
        }// Bug Id : 24716 end
        console.log('CKYCDocumentType --> ', component.get("v.CKYCDocumentType"));// US : 13265 S
        if (!$A.util.isEmpty(component.get("v.CKYCDocumentType"))) {
            try {
                var splitVal = component.get("v.CKYCDocumentType").split(':');
                console.log('splitVal -->', splitVal);
                if (!$A.util.isEmpty(splitVal) && !$A.util.isEmpty(splitVal[0]) && !$A.util.isEmpty(splitVal[1])) {
                    component.set("v.poiType",splitVal[0]);
                    component.set("v.poiNumber", splitVal[1]);
                }
            } catch (e) {
                console.log('CKYCDocumentType issue --> ' + e);
            }
        }// US : 13265 E
        // Bug Id : 24716 added common spinner
        helper.showhidespinner(component,event,false);
       // component.set("v.Spinner",false);
    },
    onPOIChange : function(component, event, helper) {
        console.log(component.get("v.poiType"));
        var poi = component.get("v.poi");
        if(component.get("v.poiType") == 'Passport'){
            poi = 'A';
        }
        else if(component.get("v.poiType") == 'Voter ID'){
            poi = 'B';
        }
        else if(component.get("v.poiType") == 'PAN'){
            poi = 'C';
            if (component.get("v.ckycFlow") && !$A.util.isEmpty(component.get("v.ckycFlow")["panNo"])) {// Bug Id : 24716
                component.set("v.poiNumber", component.get("v.ckycFlow")["panNo"]);
            }// Bug Id : 24716
        }
        else if(component.get("v.poiType") == 'Driving License'){
            poi = 'D';                
        }
        else if(component.get("v.poiType") == 'C-KYC'){
            poi = 'Z';
        }
        component.find("poiNumName").set("v.value","");
        component.set("v.poi",poi);
        console.log('poi --> '+component.get("v.poi"));
    },
    validatePANVal : function(component, event, helper) {
        console.log('validatePANVal poi --> '+component.get("v.poi"));
        if (component.get("v.poi") == 'C') {
            component.set("v.poiNumber", (component.get("v.poiNumber") || "").toUpperCase());
        }
    },
    searchdata : function(component, event, helper) {
        try{
        
        if(component.get("v.poiNumber") && component.get("v.mobNo") && component.find("mobval").get("v.validity").valid && helper.validatepanField(component,event)){
            helper.fetchData(component, event);
            helper.showhidespinner(component,event,true);
			
			component.set("v.CKYCDocumentType", (component.get("v.poiType") + ":" + component.get("v.poiNumber")));//US11371            
            component.set("v.dataSource","CKYC Search");//US11371
			
            /*if(component.get("v.ckycFlow").flowtype != 'Salaried'){
            	component.set("v.Spinner",true);
            }
            else{
                helper.showhidespinner(component,event,true);
            }*/
        //    component.set("v.Spinner",true);
                //component.set("v.isfirstRespfetched",true);               
        }
        else if($A.util.isEmpty(component.get("v.poiNumber"))){
            helper.displayToastMessage(component,event,'Error','Please enter POI Number','error');
        }
        else if($A.util.isEmpty(component.get("v.mobNo"))){
            helper.displayToastMessage(component,event,'Error','Please enter mobile number','error');
        } 
        
        if(!$A.util.isEmpty(component.get("v.mobNo"))&& (!component.find("mobval").get("v.validity").valid)){
            
        }
        }catch(e){console.error('searchdata Error '+e);}//US11371
    },
    submit : function(component, event, helper) {
        console.log('here');
        try {
		event.preventDefault();// Bug id : 25631 Ckyc bug
        event.stopPropagation();
		} catch (e) {
		    console.log('e --> ', e);
		}
        if(component.get("v.dateOfBirth")){
            helper.fetchCkyc(component, event);     
        }
        else{
            helper.displayToastMessage(component,event,'Error','Please enter Date of birth','error');            
        }
        
    }
})