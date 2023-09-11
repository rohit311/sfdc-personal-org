({
		initNTBCmp : function(component, event, helper) {
			 helper.initNTBHelper(component, event, helper);
		},
		searchCust: function(component, event, helper) {
			helper.searchCustHelper(component, event, helper);
		},
		openCustInfo: function(component, event, helper){
			helper.openCustInfoHelper(component, event, helper);
		},
		next: function (component, event, helper) {
			helper.next(component, event, helper);
		},
		previous: function (component, event, helper) {
			helper.previous(component, event, helper);
		},
		clearFields: function(component,event,helper){
			component.set("v.searchObj",{});
			component.set("v.PaginationList",null)
		},
		backToHome: function(component,event,helper){
			helper.backToHomeHelper(component,event,helper);
		},
		closeModel: function(component,event,helper){
			component.set("v.showConfirm",false);
		},
		setAssignFlag: function(component,event,helper){
			var btnId =event.currentTarget.id;
            component.set("v.showConfirm",false);

			console.log('btnId ::' + btnId);
			if(btnId == 'idYes')
				component.set("v.assignToMeFlg",true);
			else
				component.set("v.assignToMeFlg",false);
			if(component.get("v.assignToMeFlg"))
				helper.doAssignment(component,event,helper);
		},
		
		assignToMe: function(component,event,helper){
			
			var previousSOLName,msg;
			var custId = event.currentTarget.name;
			var PaginationList = component.get("v.PaginationList");
			var CustPgRecMap = component.get("v.CustPgRecMap");
			var loggedInUserID =  component.get("v.wrapperObj.mapWrpData.LoggedInUserId");
			console.log('loggedInUserID ::' + loggedInUserID);
			var custList = component.get("v.CustomerList");
			console.log('custList ::' + JSON.stringify(custList))
			for(var i=0; i<custList.length; i++ ){
				if(custList[i].Id ==custId ){
					if(custList[i].Insurance_Agent__c){
						if( custList[i].Insurance_Agent__r.Sales_Officer_Name__c != loggedInUserID){
                            component.set("v.showConfirm",true);
							previousSOLName= custList[i].Insurance_Agent__r.Sales_Officer_Name__r.Name;
							msg = 'Customer does not belongs to your serviceable area and is already allocated to '+previousSOLName+'. Do you still want to assign this customer ?';
							component.set("v.assignMeMsg",msg);
							
							component.set("v.assignToMeFlg",true);
							component.set("v.assignMeCust",custList[i]);
							console.log('Do assignment');
							/*if(confirm(msg)){
								helper.fetchAssignSOL(component,event,helper, custList[i]);
								//if(CustPgRecMap[custList[i].Id])
								   //CustPgRecMap[custList[i].Id].BtnDisableFlag = false;
								console.log('Do assignment');
							}*/
						   
						}
						else{
							helper.showNotification(event,"SuccessToast1","successmsg1","<b>Success!</b>,Customer is already assigned to you");	
							if(CustPgRecMap[custList[i].Id])
								CustPgRecMap[custList[i].Id].BtnDisableFlag = false;  
							console.log('Do Nothing');
						}
					}
					else{
					   //Customer is not allocated to any Agent
						//helper.fetchAssignSOL(component,event,helper,custList[i]);
						//if(CustPgRecMap[custList[i].Id])
							//CustPgRecMap[custList[i].Id].BtnDisableFlag = false;
						//component.set("v.assignToMeFlg",true);
						component.set("v.assignMeCust",custList[i]);
						helper.doAssignment(component,event,helper);
						console.log('Assign to me');
					}
						
				}
			}
			//if(component.get("v.assignToMeFlg"))
				//helper.doAssignment(component,event,helper);
		   component.set("v.PaginationList",PaginationList);
			
		}
		
	})