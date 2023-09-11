({
    getPicklistval : function(component){
        component.set("v.flag",true);
        component.set("v.spinnerFlag","true");
        console.log('Inside all picklist');
        var listofAPIname = ["Type_Of_Property_MCP__c","Area_of_Property_Commercial_in_sqft__c","Acquisition__c","No_of_Tenants_rental_income__c","Area_of_Property_Resi_MixedUsage_sqft__c","Title_Deed__c","Approach_Road_in_ft__c","Jurisdiction__c","Property_MCP_Result__c"];
        var selectListNameMap = {};
        selectListNameMap["Personal_Discussion_Details__c"] = listofAPIname;
        this.executeApex(component, "getAllPicklistvals",{"mapOfFeilds": JSON.stringify(selectListNameMap)}, function(error, result) {
            console.log('Result is :'+result);
             
            if (!error && result) {
                console.log('Result'+result);
                var PDDpicklist = result["Personal_Discussion_Details__c"];
                component.set("v.TypeOfpropertyList",PDDpicklist["Type_Of_Property_MCP__c"]);
                component.set("v.AreaOfPropResiList",PDDpicklist["Area_of_Property_Resi_MixedUsage_sqft__c"]);
                component.set("v.AreaOfpropCommList",PDDpicklist["Area_of_Property_Commercial_in_sqft__c"]);
                component.set("v.AquisitionList",PDDpicklist["Acquisition__c"]);
                component.set("v.NoTenantList",PDDpicklist["No_of_Tenants_rental_income__c"]);
                component.set("v.TitleDeedList",PDDpicklist["Title_Deed__c"]);
                component.set("v.JurisdictnList",PDDpicklist["Jurisdiction__c"]);
                component.set("v.MCPResultList",PDDpicklist["Property_MCP_Result__c"]);
                component.set("v.ApproachRdList",PDDpicklist["Approach_Road_in_ft__c"]);
                component.set("v.spinnerFlag","false");    
            }else{
                console.log('Errorrr');
                component.set("v.spinnerFlag","false");
            }
        });
        
    },
    editableOrNot : function(component){
       var stageN = component.get("v.StageName"); 
        this.executeApex(component, "isEditableComponent",{"Stage":stageN }, function(error, result) {
            console.log('Result is editable or not :'+result);
            if (!error) {
                
           component.set("v.EditableFlag",result);
           console.log('EditableFlag '+component.get("v.EditableFlag"));
            }else{
                console.log('EditableFlag error'+error);
            }
         });
    },
    executeApex: function(component, method , params , callback){
        var action = component.get("c."+method);
        action.setParams(params);
        console.log('In executeapex');
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('reponse, ',response);
            if (state === "SUCCESS") {
                console.log('Success... ');
                callback.call(this, null, response.getReturnValue());
            } 
            else if (state === "ERROR") {
                console.log('Error calling method'+response.getReturnValue()+method);
                callback.call(this, null, response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    },
    submitpropertydata : function(component,event, helper){
        debugger;
        component.set("v.spinnerFlag","true");
        var PD = component.get("v.PDObj");
        var PDD = component.get("v.PDD");
        console.log('Pd value is ', PDD.id);
        var isvalid = true;
        var list = [];
        list = ["degree","AreaCommercial","Aquisition","NoTenant","ValofProp","AreaOfPropResi","TitleDeed","ApproachRd","Jurisdictn"];
        for (var i = 0; i < list.length; i++) {
            console.log('Component find --> '+component.find(list[i]));
            console.log('Required flag '+component.find(list[i]).get("v.required"));
            console.log('Is empty--->'+(component.find(list[i]).get("v.value")));
            if (component.find(list[i]) && component.find(list[i]).get("v.required") == true && $A.util.isEmpty(component.find(list[i]).get("v.value")))
            {
                isvalid = false;
                component.find(list[i]).showHelpMessageIfInvalid();
                $A.util.addClass(component.find(list[i]), "slds-has-error"); 
                $A.util.removeClass(component.find(list[i]), "hide-error-message");
            }
        }
        var PDOld = component.get("v.PDDoldChange");
        var isChanged ;
        if(PDD.Id){
            console.log('Inside isChanged check');
            isChanged = (PDOld.Type_Of_Property_MCP__c !== PDD.Type_Of_Property_MCP__c ||
                         PDOld.Area_of_Property_Resi_MixedUsage_sqft__c !== PDD.Area_of_Property_Resi_MixedUsage_sqft__c ||
                         PDOld.Area_of_Property_Commercial_in_sqft__c !== PDD.Area_of_Property_Commercial_in_sqft__c ||
                         PDOld.No_of_Tenants_rental_income__c !== PDD.No_of_Tenants_rental_income__c ||
                         PDOld.Approach_Road_in_ft__c !== PDD.Approach_Road_in_ft__c 
                        );
        }
       // if(PDOld.Property_MCP_Result__c !== PDD.Property_MCP_Result__c)
         //    PDD.Property_MCP_fail_reason__c='';
            
        if(isvalid){
            var Idd = PD;
            if(!PDD.Id){
                PDD.Personal_Discussion__c = Idd; 
                PDD.PDD_Type__c ='BLSE Property';
                console.log('stringifies'+JSON.stringify(PDD));
                var LoanIDHelp = component.get("v.LoanId");
                PDD.Loan_Application__c = LoanIDHelp;
                PDD.Property_MCP_Result__c = 'Pending';
                PDD.Property_MCP_fail_reason__c='';
                PDD.BRE_response_status__c = false;
            }
            if(isChanged){
                PDD.Property_MCP_Result__c = 'Pending';
                PDD.Property_MCP_fail_reason__c='';
                PDD.BRE_response_status__c = false;  
            }
            
            this.executeApex(component, "createPDDobj", {
                "PDDObj": JSON.stringify(PDD),
                "PDObj": JSON.stringify(PD)
            }, function(error, result) {
                if (!error && result) {
                    debugger;
                    console.log('Sucessfully Created PDD......');
                    console.log('PDD.Id-->'+PDD.Id);
                    if(!PDD.Id){
                        console.log('Inside my condition PDD.Id ');
                        var PDDlstTemp = component.get("v.PDDList");
                        PDDlstTemp.push(result);
                        console.log('PDDlstTemp-->'+PDDlstTemp);
                        component.set("v.PDDList",PDDlstTemp); 
                        
                    }else{
                        this.getAddedpropertyList(component); 
                    }
                    component.set("v.PDD",{'sobjectType':'Personal_Discussion_Details__c',Type_Of_Property_MCP__c:'',Acquisition__c:'',Approach_Road_in_ft__c:'',
                                           Area_of_Property_Commercial_in_sqft__c:'',Area_of_Property_Resi_MixedUsage_sqft__c:'',Jurisdiction__c:'',
                                           No_of_Tenants_rental_income__c:'',Property_MCP_Result__c:'',Property_Name__c:'',Title_Deed__c:'',
                                           Value_of_Property_in_Lakhs__c:''});
                    component.set("v.spinnerFlag","false");
                    component.set("v.showExtraValue",'');
                    this.displayToastMessage(component,event,'Success!','Property details submitted sucessfully !!','success');
                    
                }else{
                    console.log('Error Occured'+error);
                    component.set("v.showExtraValue",'');
                    this.displayToastMessage(component,event,'Error!','Error ocuured while saving the data!!','error');
                    component.set("v.spinnerFlag","false");
                }
            }); 
        }else{
            console.log('Invalid data');
            this.displayToastMessage(component,event,'Error!','Please fill the values before submitting!!','error');
            component.set("v.spinnerFlag","false");
        }
    },
    getAddedpropertyList : function(component){
        debugger;
        var PD = component.get("v.PDObj");
        this.executeApex(component, "getupdateddata", {
            "PdObjlst": PD
        }, function(error, result) {
            if (!error && result) {
                console.log('Sucessfully Updated added PDD......');
                component.set("v.PDDList",result); 
                component.set("v.spinnerFlag","false");
            }else{
                console.log('Error Occured');
            }
        });
        
        
    },
    showOnUpdateSectionHelper : function(component, event, helper){
       component.set("v.spinnerFlag","true");
        component.set("v.showExtraValue",'false'); 
        var PDDold = component.get("v.PDD");
        var showextra = component.get("v.showExtraValue");
        var idx = event.target.id;
        console.log('id is gopika--> '+idx);
        this.executeApex(component, "updatedPersonalDisdetails", {
            "PDDObj": idx
        }, function(error, result) {
            if (!error && result) {
                console.log('result is'+result);
                component.set("v.PDD",result);
                var PDD1 = component.get("v.PDD");
                var oldPDD = component.get("v.PDDoldChange");
                oldPDD=JSON.parse(JSON.stringify(PDD1));
               
              /*  oldPDD.Type_Of_Property_MCP__c = PDD1.Type_Of_Property_MCP__c;
                oldPDD.Area_of_Property_Commercial_in_sqft__c = PDD1.Area_of_Property_Commercial_in_sqft__c;
                oldPDD.Acquisition__c = PDD1.Acquisition__c;
                oldPDD.No_of_Tenants_rental_income__c = PDD1.No_of_Tenants_rental_income__c;
                oldPDD.Value_of_Property_in_Lakhs__c = PDD1.Value_of_Property_in_Lakhs__c;
                oldPDD.Area_of_Property_Resi_MixedUsage_sqft__c = PDD1.Area_of_Property_Resi_MixedUsage_sqft__c;
                oldPDD.Property_MCP_Result__c = PDD1.Property_MCP_Result__c;
                oldPDD.Title_Deed__c = PDD1.Title_Deed__c;
                oldPDD.Approach_Road_in_ft__c = PDD1.Approach_Road_in_ft__c;
                oldPDD.Jurisdiction__c = PDD1.Jurisdiction__c;*/
                component.set("v.PDDoldChange",oldPDD);
                console.log('PDD.Property_MCP_Result__c --> '+PDD1.Property_MCP_Result__c);
                if(PDD1.Property_MCP_Result__c=='Error'){
                    component.set("v.showExtraValue",'true'); 
                }
                console.log('here');
                  var list = [];
            list = ["degree","AreaCommercial","Aquisition","NoTenant","ValofProp","AreaOfPropResi","TitleDeed","ApproachRd","Jurisdictn"];
            for (var i = 0; i < list.length; i++) {
                $A.util.removeClass(component.find(list[i]), "slds-has-error"); // remove red border
                $A.util.addClass(component.find(list[i]), "hide-error-message"); // hide error message
                console.log(list[i], component.find(list[i]));
                if ( component.find(list[i]) && component.find(list[i]).get("v.value") == 'undefined')
                    component.find(list[i]).set("v.value",'');
                }
                console.log('here--> gopika');
                 component.set("v.spinnerFlag","false");
               this.areaOfPropertyVisibilityHelper(component, event, helper);
                 console.log('jquery ', $);
               
                if(typeof $ != 'undefined'){
                    console.log('%c scrolling to top ', 'color: green;' ,$("#id-property-edit"));
                    //console.log('js', document.getElementById('id-property-edit'));
                    //document.getElementById('id-property-edit').focus();
                	//$("#id-property-edit").scrollTop(0);   
                    //var ele = component.find("id-property-edit");//.getElement();
                    //console.log('ele', JSON.stringify(ele) );
                    component.find("id-property-edit").getElement().focus();
                    console.log('component.find("id-property-edit").getElement()',component.find("id-property-edit").getElement());
                    $(ele).scrollTop(0);  
              component.set("v.spinnerFlag","false");         
            }
            else{
                console.log('Error Occured');
                 component.set("v.spinnerFlag","false");
            }
            }else{
                component.set("v.spinnerFlag","false");  
                console.log('Perror occured');
            }
            
        });
       
    },
    displayToastMessage:function(component,event,title,message,type)
    { 
        console.log('inside displayToastMessage'+message+type);
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        console.log('showhideevent--> '+showhideevent);
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
    },
    invokeBREMCP : function(component,event,helper)
    {  
        component.set("v.spinnerFlag","true");
        console.log('inside helper for BRE');
        var PD = component.get("v.PDObj");
        this.executeApex(component, "propertyMCPcheckBRE", {
            "PDrecordID": PD
        }, function(error, result) {
            if (!error && result) {
               component.set("v.PDDListtest",result); // added by amar
					 var retrnlst = component.get("v.PDDListtest");
	        if( retrnlst != null && retrnlst.length > 0 ){
                this.getAddedpropertyList(component);
                this.displayToastMessage(component,event,'Sucess!','Property MCP result updated successfully!!','success');
               // component.set("v.spinnerFlag","false");
             }
              else
                  this.displayToastMessage(component,event,'Info!','No records available for MCP check','info');
					component.set("v.PDDListtest",''); // added by amar
                 console.log('Dummy PDD lst after mcp API call--'+component.get("v.PDDListtest"));
                    component.set("v.spinnerFlag","false");
            } else{
                this.getAddedpropertyList(component);
                this.displayToastMessage(component,event,'Error!','There is some error !!','error');
                component.set("v.spinnerFlag","false");
            }
        });
        console.log('Updated value');
        
    },
    cancelDetailsHelper : function(component,event,helper)
    {
        component.set("v.showExtraValue",'');
        component.set("v.PDD",{'sobjectType':'Personal_Discussion_Details__c',Type_Of_Property_MCP__c:'',Acquisition__c:'',Approach_Road_in_ft__c:'',
                               Area_of_Property_Commercial_in_sqft__c:'',Area_of_Property_Resi_MixedUsage_sqft__c:'',Jurisdiction__c:'',
                               No_of_Tenants_rental_income__c:'',Property_MCP_Result__c:'',Property_Name__c:'',Title_Deed__c:'',
                               Value_of_Property_in_Lakhs__c:''});
        
    },
    
    //Added By Gulshan
     areaOfPropertyVisibilityHelper: function(component,event,helper){
         debugger;
        var typeOfProperty = component.find("degree").get("v.value");
        if (typeOfProperty != null &&  typeOfProperty != '' && typeOfProperty != undefined)
         {
             if (typeOfProperty == 'Commercial' ||  typeOfProperty == 'Agri' )
             {
            	//$A.util.addClass(component.find("DivAreaOfPropResi"),"slds-hide");
                component.find("AreaOfPropResi").set("v.required",false); 
                
                 //$A.util.removeClass(component.find("DivAreaOfComm"),"slds-hide");
                 component.find("AreaCommercial").set("v.required",true); 
                
             } 
             if (typeOfProperty == 'Residential' ||  typeOfProperty == 'Mixed Usage' || typeOfProperty == 'Plot' )
             {
            	//$A.util.addClass(component.find("DivAreaOfComm"),"slds-hide");
                component.find("AreaCommercial").set("v.required",false); 
                 
                //$A.util.removeClass(component.find("DivAreaOfPropResi"),"slds-hide"); 
                component.find("AreaOfPropResi").set("v.required",true); 
                
             }
         }
   console.log('Gulshan end');
    }
    //Ended By Gulshan
})