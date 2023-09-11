({
    fetchInsData : function(component,event,helper) {
         component.set("v.InsMainFlag", true);
        component.set("v.isSpinner",true);
        var objParam = component.get("v.objParam");
        console.log('objParam::'+ JSON.stringify(objParam));
        component.set("v.tileId",objParam.tileId) 
   		
   		this.setTileName(component,event,helper);
        this.executeApex(component, "loadInsData", {
            "tileName":component.get("v.tileId")
            
        }, function(error, result){
            if(!error && result){
                console.log('result' + JSON.stringify(result))
                component.set("v.ListCustomer",result.lstCust);
                component.set("v.ListMem",result.lstFamMem);
                component.set("v.isSpinner",false);
				var combList = this.getLstOfRec(component,event,helper);
                this.setRecs(component,event,helper,combList);
              
                //Set Picklist Values
                this.setPickVals(component, event, helper, result); 
            }
            else{
                console.log('ERROR in Main Component');
                component.set("v.isSpinner",false);
            }
        });
    },
    setPickVals: function(component, event, helper, result){
        if(result.lstLeadSource)
            component.set("v.lstLeadSource", result.lstLeadSource);
        if(result.lstDisposition)
            component.set("v.lstDisposition", result.lstDisposition);
    },
    setTileName: function(component,event,helper){
      var tileName = component.get("v.tileId");
        console.log('tileName ::' + tileName);
        if(tileName == 'newLeadId')
            component.set("v.tileName","NEW LEAD");
        else if(tileName == 'leadListId')
             component.set("v.tileName","LEAD LIST");
         else if(tileName == 'followUpId')
             component.set("v.tileName","FOLLOW UP");
    },
    getLstOfRec: function(component,event,helper){
        console.log('length 1 >>>>'+component.get("v.ListCustomer").length);
        console.log('length 2 >>>>'+component.get("v.ListMem").length);
        var custLst = [] = component.get("v.ListCustomer");
        var famLst = [] = component.get("v.ListMem");
        var tempLst = [];
        
        //Below code is added to differentiate between Customer and Family record
        for(var i=0;i<custLst.length;i++){
            custLst[i].type= 'Customer';
        }
         for(var i=0;i<famLst.length;i++){
            famLst[i].type= 'Family';
        }
        for(var i=0;i<custLst.length;i++){
            tempLst.push(custLst[i]);
        }
        for(var i=0;i<famLst.length;i++){
            tempLst.push(famLst[i]);
        }   
        console.log('tempLst ::' + JSON.stringify(tempLst));
        component.set("v.totalRec",tempLst.length);
        return tempLst;
    },
    setRecs: function(component,event,helper,tempLst){
		
		//var tempLst = this.getLstOfRec(component,event,helper);
      
        var pageSize = component.get("v.pageSize");
        var totalRecs = tempLst.length;
        console.log('totalRecs ::' + totalRecs + 'type ::' + typeof totalRecs);
        component.set("v.totalRecords", totalRecs);
        component.set("v.startPage",0);
        component.set("v.currentPage",1);
        component.set("v.endPage",pageSize);
        //var totRec = component.get("v.ListCustomer").length;
        var rem = totalRecs % pageSize;
        if(rem > 0){
            component.set("v.totalPages",Math.floor((totalRecs/pageSize))+1);
        }
        else{
            component.set("v.totalPages",(totalRecs/pageSize));
        }
        
        var newPoList = [];
        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(tempLst.length > i){
                PaginationList.push(tempLst[i]);    
            }
        }  
        
        //component.set("v.ListCustomer",custLst);
        console.log('PaginationList'+PaginationList.length);
        component.set('v.PaginationList', PaginationList);
        
    },
    next : function(component, event, helper){
        var sObjectList;
		console.log('Seacrh ::' + component.get("v.searchText"));
		console.log('fltrList ::' + component.get("v.fltrList"));
		
		if(component.get("v.searchList").length > 0)
			sObjectList = component.get('v.searchList');
		else if (component.get("v.fltrList").length > 0)
			sObjectList = component.get('v.fltrList');
		else   
			sObjectList = this.getLstOfRec(component, event, helper);
		
				
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= end ; i<end+pageSize; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")+1);
    },
    
    previous : function(component, event, helper){
		var sObjectList;
		if(component.get("v.searchList").length > 0)
			sObjectList = component.get('v.searchList');
		else if (component.get("v.fltrList").length > 0)
			sObjectList = component.get('v.fltrList');
		else   
			sObjectList = this.getLstOfRec(component, event, helper);
		
		/*if(!component.get("v.searchText"))
			sObjectList = this.getLstOfRec(component, event, helper);
		else   
			sObjectList = component.get('v.searchList');*/
        //var sObjectList = component.get("v.ListCustomer");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")-1);
    },
    openCustInfoHelper: function(component, event, helper){
      
        var objId = event.currentTarget.name;
         console.log("objId::" + objId);
        console.log('dataset ::' + JSON.stringify(event.currentTarget.dataset));
        //cust_prof_btn
        //var custId = event.currentTarget.dataset.custid;
        var btnId = event.currentTarget.id;
        console.log("btnId::" + btnId);
        //console.log("custId::" +  JSON.parse(custId));
        var objType = btnId.split('_')[0];
        console.log("objType::" +  objType);
        
        var paramJSON ={};
        paramJSON.tabId = btnId;
        paramJSON.recId = objId;
        paramJSON.objType = objType;
        paramJSON.calledFrm = 'MAINCMP';
        
        console.log('paramJSON :::' + JSON.stringify(paramJSON));
        component.set("v.childParam",paramJSON);
        component.set("v.openCustDetails",true);
        //component.set("v.isSpinner", true);
        component.set("v.InsMainFlag", false);
        
        //Call INS_customerDetails init method 
         var custDetailCmp = component.find('custCmpId');
		 custDetailCmp.initMethod();

       
        /*$A.createComponent(
            "c:INS_CustomerDetails",{"objParam": paramJSON},
            function(newComponent,status,errorMessage){
                component.set("v.body",newComponent);
                if (status === "SUCCESS") {
                    console.log('SUCCESS');
                    component.set("v.isSpinner", false);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    component.set("v.isSpinner", false);
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        component.set("v.isSpinner", false);
                    }
            }
        )*/
        
    },
    openInteractionInfoHelper : function(component, event, helper){
        console.log("INSIDE INTERACTION!");
    },
    searchCustHelper: function(component,event,helper){
        component.set("v.openCustDetails",false);
        var searchTxt = component.get("v.searchText").trim();
        
        var searchList = [];
		var custSList = [];
		var memSList= [];
        var custList = component.get("v.ListCustomer");
		var memList = component.get("v.ListMem");
		if(searchTxt){
			for(var i=0;i<custList.length;i++){
                var strCustName= '';
                if(custList[i].Customer_Name__c)
                    strCustName =custList[i].Customer_Name__c;
                console.log('Mobile :::' + custList[i].Mobile__c + 'Fname::' + custList[i].First_Name__c + 'Lname::' + custList[i].Last_Name__c);
				console.log('Name ::' + strCustName + ' ID::' + custList[i].Name);
			   
                if( (custList[i].Mobile__c && custList[i].Mobile__c == searchTxt) || (custList[i].First_Name__c && (custList[i].First_Name__c.toLowerCase()).includes(searchTxt.toLowerCase())) || (custList[i].Last_Name__c && (custList[i].Last_Name__c.toLowerCase()).includes(searchTxt.toLowerCase())) || (strCustName.toLowerCase() == searchTxt.toLowerCase()) || (custList[i].Name && custList[i].Name == searchTxt)){
					//custSList.push(custList[i]);
					searchList.push(custList[i]);
				}
			}
			/*for(var i=0;i<memList.length;i++){
				console.log('Fname ::' + memList[i].First_Name__c + 'Lname::' + memList[i].Last_Name__c)
			   // Mobile__c Name First_Name__c Last_Name__c
			   var strName = memList[i].First_Name__c + ' ' + memList[i].Last_Name__c;
                console.log('strName:::' + strName + 'SearchTxt ::' + searchTxt);
				if(memList[i].Mobile__c ==  searchTxt || (memList[i].First_Name__c.toLowerCase()).includes(searchTxt.toLowerCase()) || (memList[i].Last_Name__c.toLowerCase()).includes(searchTxt.toLowerCase()) || strName.toLowerCase().includes(searchTxt.toLowerCase())){
					//memSList.push(memList[i]);
					searchList.push(memList[i]);
				}
			}*/
			
			console.log('searchList ::' + searchList.length);
			
			//console.log('custSList ::' + custSList.length);
			//console.log('memSList ::' + memSList.length);
			
			//component.set("v.ListCustomer",custSList);
			//component.set("v.ListMem",memSList);
			component.set('v.searchList',searchList);
			this.setRecs(component,event,helper, searchList);
			
			//console.log('searchList ::' + searchList.length);
			//component.set("v.PaginationList",searchList);
			//console.log('pglIst ' + component.get("v.PaginationList").length);
		}
       
    },
    filterCustHelper: function(component,event,helper){
        component.set("v.isSpinner", true);
        component.set("v.openCustDetails",false);
        var filterObj = component.get("v.FilterObj");
        var fltPincode = filterObj.pincode;
		var fltDisposition = filterObj.Disposition;
		var fltCustSeg = filterObj.custSeg;
		var fltLeadSource = filterObj.leadSource;
		var fltLeadType = filterObj.LeadType;;
		
		
		var duplRes;
		console.log('filterObj ::' + JSON.stringify(filterObj));
		var custPincode;
        var searchList = [];
		var custSList = [];
		var memSList= [];
		var query;
        var custList = component.get("v.ListCustomer");
		console.log('fltPincode ::' + fltPincode);
		
		var memList = component.get("v.ListMem");
		
		if(fltLeadType == 'New Lead' || !fltLeadType)
			query = 'Select id, Name, First_Name__c, Last_Name__c, Mobile__c, Lead_Source__c, Bureau_Segment__c,Disposition__c,Lead_Viewable__c,Channel__c,Pin_Code_New__c,Office_Pin_Code__c FROM customer_info__c WHERE Lead_Viewable__c = \'Yes\' AND Channel__c = \'Branch\'';
		//else
		//ADD QUERY FOR NTB LEAD HERE
			
		//if(filterObj){
            //if(fltLeadType == 'New Lead' || !fltLeadType ){
            if (fltPincode) {
                console.log('inside :::');
                query = query + ' AND ( Pin_Code_New__c = ' + fltPincode + ' OR Office_Pin_Code__c =' + fltPincode + ')';
            }
					
				if (fltLeadSource) 
					query = query + ' AND Lead_Source__c = \'' + fltLeadSource + '\'';
				if (fltCustSeg) 
					query = query + ' AND Bureau_Segment__c = \'' + fltCustSeg.trim() + '\'';
				if (fltDisposition) 
					query = query + ' AND Disposition__c = \'' + fltDisposition + '\'';
			//}
			//else if(fltLeadType == 'NTB Lead'){
				//ADD LOGIC FOR NTB LEAD HERE
			//}
		//}
		console.log('query ::' + query);
		this.executeApex(component, "getDataByQry", {
            "queryStr":query,
			            
        }, function(error, result){
            if(!error && result){
				console.log('result :::' +  JSON.stringify(result));
				component.set("v.isSpinner", false);
                if(result.resultRecords){
                    var respList = result.resultRecords;
                    //console.log('retObj :::' + JSON.stringify( retObj));
                    
                    component.set('v.fltrList',result.resultRecords);
                    console.log('fltrList ::' + JSON.stringify(component.get('v.fltrList')));
                    if(fltLeadType == 'New Lead' || !fltLeadType)
                        for(var i= 0; i< respList.length; i++){
                            respList[i].type= 'Customer';
                        }
                    
                    this.setRecs(component,event,helper,respList);
                }
                
            }else{
                console.log('ERROR in applying filter');
            }
		});
       
    },
	remvAttrKey: function(component,event,helper, jsonList){
		console.log('jsonList :::');
		for(var i = 0; i < jsonList.length; i++) {
			delete jsonList[i]['attributes'];
			console.log('jsonList ::' + JSON.stringify(jsonList));
		}
		return jsonList;
	},
	/*chkFltrDuplicateRec : function(component,event,helper, searchList, custRec){
		var recFound = false;
		var recIndex;
		console.log('searchList ::' + JSON.stringify(searchList));
		if(searchList){ 
		for(var i= 0; i<searchList.length; i++ ){
			console.log('searchList[i].Id ::' + searchList[i].Id + 'custRec ::' + custRec.Id);
			if(searchList[i].Id == custRec.Id)
				recFound = true;
				recIndex = i
		}
		}
		var retObj = {};
		retObj.recFound = recFound;
		retObj.recIndex = recIndex;
		console.log('retObj ::' + retObj);
		return retObj;
	},*/
    backToHomeHelper: function(component,event,helper){
        //component.set("v.isSpinner", true);
        component.set("v.InsMainFlag", false);
        component.set("v.openCustDetails",false);
        //component.set("v.isParentFlag",true);
        var compEvent = component.getEvent("INSHomePgEvent");
        var evtParam = {};
        evtParam.homeFlag = true;
        //evtParam.isTileCmpFlag= false;
        compEvent.setParams({"HomeEventParam" : evtParam });
		compEvent.fire();
        
        
        /*$A.createComponent(
            "c:INS_HOME_PAGE",{"homeFlag": "true"},
            function(newComponent,status,errorMessage){
                component.set("v.body",newComponent);
                if (status === "SUCCESS") {
                    console.log('SUCCESS');
                    component.set("v.isSpinner", false);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    component.set("v.isSpinner", false);
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        component.set("v.isSpinner", false);
                    }
            }
        )*/
    },
    executeApex: function(component, method, params, callback){
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
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
                //this.showNotification(event,'ErrorToast1', 'errormsg1', '<b>Error!</b>,'+ errors.join(", ") );
                callback.call(this, errors, response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    }
})