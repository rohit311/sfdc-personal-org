({
    doInit : function(component, event, helper) {
        component.set("v.bankSearchKeyword", component.get("v.solObjLandLord.Bank_Name__c"));
        console.log('in rental doinit1::'+component.get("v.solObjLandLord.Property__c"));
        console.log('in rental doinit2::'+component.get("v.solObjLandLord.Accessories__c"));
        var varMap;
        if(component.get("v.solObjLandLord.Variable_Rent__c")!= undefined)
         varMap = JSON.parse(component.get("v.solObjLandLord.Variable_Rent__c"));
       // if(component.get("v.solObjLandLord.isVarChecked__c")== true){
        if(varMap != undefined && varMap != 'null' && varMap.rent1 != null && varMap.rent1 !=''){
           // var varMap = JSON.parse(component.get("v.solObjLandLord.Variable_Rent__c"));
            component.set("v.rent1",varMap.rent1);
            component.set("v.rent2",varMap.rent2);
            component.set("v.rent3",varMap.rent3);
            component.set("v.rent4",varMap.rent4);
            component.set("v.rent5",varMap.rent5);
            component.set("v.month1",varMap.month1);
            component.set("v.month2",varMap.month2);
            component.set("v.month3",varMap.month3);
            component.set("v.month4",varMap.month4);
            component.set("v.month5",varMap.month5);
           	component.set("v.isVarRent",true);
      } 
      if(component.get("v.solObjLandLord.property__c") != 'null' && component.get("v.solObjLandLord.Property__c")!= undefined){
            var varMap = JSON.parse(component.get("v.solObjLandLord.Property__c"));
            component.set("v.galleryArea",varMap.galleryArea);
            component.set("v.parkingArea",varMap.parkingArea);
            component.set("v.areaUnit",varMap.areaUnit);
            component.set("v.buildingName",varMap.buildingName);
            component.set("v.flatNo",varMap.flatNo);
            component.set("v.floorNo",varMap.floorNo);
            component.set("v.sector",varMap.sector);
            component.set("v.locality",varMap.locality);
            component.set("v.village",varMap.village);
            component.set("v.houseNumberType",varMap.houseNumberType);
           component.set("v.houseNumberValue",varMap.houseNumberValue);
           component.set("v.pinCode",varMap.pinCode);
      } 
       if(component.get("v.solObjLandLord.Accessories__c") != 'null' && component.get("v.solObjLandLord.Accessories__c")!= undefined){
            var varMap = JSON.parse(component.get("v.solObjLandLord.Accessories__c"));
            component.set("v.fan",varMap.fan);
            component.set("v.tubelight",varMap.tubelight);
            component.set("v.bed",varMap.bed);
            component.set("v.sofa",varMap.sofa);
            component.set("v.table",varMap.table);
            component.set("v.chair",varMap.chair);
            component.set("v.geyser",varMap.geyser);
            component.set("v.ac",varMap.ac);
      } 
        
    },
     sourceKeyPressController: function (component, event, helper) {
        console.log('insourcekey');
        component.set("v.ValidSourceChannel",false);
        console.log(component.get("v.bankSearchKeyword"));
        var cmpTarget = component.find('sourceName');//Bug 23949
        $A.util.removeClass(cmpTarget, 'reqClass'); //Bug 23949
        helper.startSearch(component, 'bank');
      
    }, 
    selectBank: function (component, event, helper) {
        
        var index = event.currentTarget.dataset.record;
        console.log('called selectSource>>>'+index);
        var selectedSource = component.get("v.bankList")[index];
        console.log('selectedSource'+selectedSource.Bank__c);
        var keyword = selectedSource.Bank__c;
       // var branchtype =selectedSource.Branch__c;
      //  component.set("v.loan.Branch_Name__c",branchtype);    
        //component.set("v.ValidSourceChannel",true);
        component.set("v.solObjLandLord.Bank_Name__c", keyword);
        component.set("v.bankSearchKeyword", keyword);
        helper.openCloseSearchResults(component, "bank", false);
        component.find("bankName").set("v.errors", [{
            message: ""
        }
                                                     ]);
    },
    saveDetails   : function(component, event, helper) {
        helper.showhidespinner(component,event,true);
        helper.saveLandlordDetailsHelper(component,event);        
        //  this.displayToastMessage(component,event,'Error','Please enter correct data','error');
    },
    toggletab : function(component, event, helper) {
        console.log('hi'+event.target.id);
     
        helper.toggleAccordion(component,event);
    },
    toggleCheck : function(component, event, helper) {
        	var isCheck=component.find("isVarChecked").get("v.checked") ;
        if(isCheck == true){
            	component.set("v.isVarRent",true);
             component.set("v.solObjLandLord.Rent__c",'');
        }
        else{
            component.set("v.isVarRent",false);
             var varMap = JSON.parse(component.get("v.solObjLandLord.Variable_Rent__c"));
            component.set("v.rent1",'');
            component.set("v.rent2",'');
            component.set("v.rent3",'');
            component.set("v.rent4",'');
            component.set("v.rent5",'');
            component.set("v.month1",'');
            component.set("v.month2",'');
            component.set("v.month3",'');
            component.set("v.month4",'');
            component.set("v.month5",'');
        }
    }
    
})