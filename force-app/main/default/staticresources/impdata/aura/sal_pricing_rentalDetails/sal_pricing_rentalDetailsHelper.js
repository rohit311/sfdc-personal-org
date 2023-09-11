({
    saveLandlordDetailsHelper: function(component,event) {
        var solObj=component.get('v.solObj');
        var validData = true;
        var dataToVal = ['emailId','DOB','firstName','midName','lastName','pan','mob','propAddress','Gender','DOB','emailId','builtUpArea','aggType','aggStartDate','aggEndDate','refAmt','chqNo','chqDate','bankBranch','salutation','depoType','lAddress','lCity','lPin','buildingName','flatNo','floorNo','sector','locality','village','houseNumberType','houseNumberValue','pinCode'];//
        for(var i=0;i<dataToVal.length;i++){
            var fieldName = component.find(dataToVal[i]);
            //alert('flied is::'+fieldName);
            if($A.util.isEmpty(fieldName) || !fieldName.get("v.validity").valid){
                fieldName.showHelpMessageIfInvalid();
                validData = false;
            } 
        }
       if(component.get('v.isVarRent')== false){
            var fieldName = component.find('rentAmt');
            //alert('rentAmt::'+fieldName);
            if($A.util.isEmpty(fieldName) || !fieldName.get("v.validity").valid){
               // alert('rentAmt1::'+fieldName);
                fieldName.showHelpMessageIfInvalid();
                validData = false;
            } 
        }
         if(component.get('v.isVarRent')== true){
             
            var dataToVal = ['rent1','rent2','rent3','rent4','rent5','month1','month2','month3','month4','month5'];
        for(var i=0;i<dataToVal.length;i++){
            var fieldName = component.find(dataToVal[i]);
            //alert('fieldname3::'+fieldName);
            if($A.util.isEmpty(fieldName) || !fieldName.get("v.validity").valid){
                fieldName.showHelpMessageIfInvalid();
                validData = false;
            } 
        }
        }
            	
        // Bug 25637/24673 s
        if(!component.get("v.bankSearchKeyword"))
        {
            validData = false;
             component.find("bankName").set("v.errors", [{
            message: "Please Select Bank Name"
        }]);
        }
         // Bug 25637/24673 e
        if(validData){
            var solObjLandLord = component.get("v.solObjLandLord");
            solObjLandLord.Variable_Rent__c = '{"rent1":"'+component.get("v.rent1")+ '","month1":"'+component.get("v.month1")+'","rent2":"'+component.get("v.rent2")+'","month2":"'+component.get("v.month2")+'","rent3":"'+component.get("v.rent3")+'","month3":"'+component.get("v.month3")+'","rent4":"'+component.get("v.rent4")+'","month4":"'+component.get("v.month4")+'","rent5":"'+component.get("v.rent5")+'","month5":"'+component.get("v.month5")+'"}';
            solObjLandLord.property__c = '{"galleryArea":"'+component.get("v.galleryArea")+ '","parkingArea":"'+component.get("v.parkingArea")+'","areaUnit":"'+component.get("v.areaUnit")+'","buildingName":"'+component.get("v.buildingName")+'","flatNo":"'+component.get("v.flatNo")+'","floorNo":"'+component.get("v.floorNo")+'","sector":"'+component.get("v.sector")+'","locality":"'+component.get("v.locality")+'","village":"'+component.get("v.village")+'","houseNumberType":"'+component.get("v.houseNumberType")+'","houseNumberValue":"'+component.get("v.houseNumberValue")+'","pinCode":"' + component.get("v.pinCode")+ '"}';       
            solObjLandLord.accessories__c = '{"fan":"'+component.get("v.fan")+ '","tubelight":"'+component.get("v.tubelight")+'","bed":"'+component.get("v.bed")+'","sofa":"'+component.get("v.sofa")+'","table":"'+component.get("v.table")+'","chair":"'+component.get("v.chair")+'","geyser":"'+component.get("v.geyser")+'","ac":"'+component.get("v.ac")+'"}';
            solObjLandLord.Loan_Application__c = component.get("v.oppId");
            this.executeApex(component, 'saveLandlordDetails', {
                "solObjLandLord" :JSON.stringify(solObjLandLord)           
            }, 
                             function (error, result) {
                                 	console.log('result is'+result);
                                 if (!error && result) {
                                     var data = JSON.parse(result);
                                     component.set("v.solObjLandLord",data.solpolicyLandLord);
                                     this.displayToastMessage(component,event,'Success','Landlord details saved successfully','success');
                                     
                                     this.showhidespinner(component,event,false);
                                 }
                                 else{
                                     this.displayToastMessage(component,event,'Error','Failed to save details','error');
                                     this.showhidespinner(component,event,false);
                                 }
                             });
        }
        else{
        	this.displayToastMessage(component,event,'Error','Please fill all mandatory details','error');
            this.showhidespinner(component,event,false);    
        }
        
    },   
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        console.log("keyword" + keyword+"key"+key);
        console.log("sourcesearching>>>" + component.get('v.sourcesearching'));
        if(key == 'bank')
        {
            if (keyword.length > 2 && !component.get('v.sourcesearching')) {
                console.log("keyword sourcesearching" + keyword+"key"+key);
                component.set('v.sourcesearching', true);
                component.set('v.oldSearchKeyword', keyword);
                   console.log("oldSearchKeyword" + component.get('v.oldSearchKeyword'));
                this.searchHelper(component, key, keyword);
            }
            else if (keyword.length <= 2) {
                console.log("keyword" + keyword+"key"+key);
                component.set("v." + key + "List", null);
                this.openCloseSearchResults(component, key, false);
            }
        }
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
    toCamelCase: function (str) {
        console.log('str is>>>'+str[0].toUpperCase() + str.substring(1));
        return str[0].toUpperCase() + str.substring(1);
    }, 
    openCloseSearchResults: function (component, key, open) {
        console.log('search result'+key+open);
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    handleSearchResult: function (component, key, result) {
        console.log('key :  handleSearchResult' + key);
        console.log(result);
        console.log('v.oldSearchKeyword :' + component.get('v.oldSearchKeyword') + '  -> SearchKeyword : ' + component.get("v." + key + "SearchKeyword"));
        
        console.log('inside handleserach'+component.get('v.oldSearchKeyword')+component.get("v." + key + "SearchKeyword"));
        if(key == 'bank')
        {
            console.log('in bank');
            component.set('v.sourcesearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldSearchKeyword') !== component.get("v." + key + "SearchKeyword")) {
                console.log('in if');
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                console.log('in else'+key);
                component.set("v." + key + "List", result);
                console.log('in else>>>'+component.get("v." + key + "List") );
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
    },
    executeApex: function (component, method, params, callback) {
        var action = component.get("c." + method);
        action.setParams(params);
        console.log('calling method' + method);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()' + response.getReturnValue());
                callback.call(this, null, response.getReturnValue());
            } else if (state === "ERROR") {
                console.log('error');
                console.log(response.getError());
                
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for (var i = 0; i < array.length; i++) {
                    var item = array[i];
                    if (item && item.message) {
                        errors.push(item.message);
                    }
                }
                console.log('calling method failed ' + method);
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    showhidespinner:function(component, event, showhide){
        console.log('in show hide');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
        console.log('after event fire');
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
    toggleAccordion : function(component,event) {
        
        var targetId= event.target.getAttribute('id'); 
        console.log('TargetId : '+ targetId);
    	 if(targetId=="subname1" || targetId=="subicon1" || targetId=="subsection1"){
            this.showHideSubSection(component,"subicon1","subsection1Content")
        }
        else if(targetId=="subname2" || targetId=="subicon2" || targetId=="subsection2"){
            this.showHideSubSection(component,"subicon2","subsection2Content")
        }  else if(targetId=="subname3" || targetId=="subicon3" || targetId=="subsection3"){
            this.showHideSubSection(component,"subicon3","subsection3Content")
        }         
    },
    showHideSection: function(component,iconId,sectionId){
        var i;
        var length = 3;
        
        for(i=1 ; i<length ; i++){ 
            var icon = 'icon'+i;
            var section = 'section'+i+'Content';
            console.log('icon : '+ iconId);
            if(icon == iconId)
            {
                var x = document.getElementById(icon).innerHTML;
                if(x =="[-]")
                    document.getElementById(icon).innerHTML = "[+]"; 
                else
                    document.getElementById(icon).innerHTML = "[-]";    	
            }else
            {
                document.getElementById(icon).innerHTML = "[+]";
            }
            
            if(section == sectionId)
                $A.util.toggleClass(component.find(section), 'slds-hide'); 
            else
                $A.util.addClass(component.find(section), 'slds-hide'); 
        }
    },
    showHideSubSection: function(component,iconId,sectionId){
        var i;
        for(i=1 ; i<6 ; i++){ //23578 changed to 6
            var icon = 'subicon'+i;
            var section = 'subsection'+i+'Content';
            console.log('icon : '+ icon);
            if(icon == iconId && document.getElementById(icon)) //Added & condition for Bug 22047 commenting Aadhaar section
            {
                var x = document.getElementById(icon).innerHTML;
                if(x =="[-]")
                    document.getElementById(icon).innerHTML = "[+]"; 
                else
                    document.getElementById(icon).innerHTML = "[-]";    	
            }else
            {
                if( document.getElementById(icon)) //Added if condition for Bug 22047 commenting Aadhaar section
                    document.getElementById(icon).innerHTML = "[+]";
            }
            
            if(section == sectionId)
                $A.util.toggleClass(component.find(section), 'slds-hide'); 
            else
                $A.util.addClass(component.find(section), 'slds-hide'); 
        }
    }
})