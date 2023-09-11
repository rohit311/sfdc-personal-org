({  
    calculateEMI : function(component,event){
        
        //   alert('Calculating EMI ');
        //   
        
        var loan_type=component.get("v.performance_report.Loan_Type__c");
        var loan_tenor=component.get("v.loanTenor")+'';
        var loan_amount=component.get("v.availedAmount")+'';
        var loan_tenor_initial=component.get("v.InitialTenorHybrid")+'';
        var rate=component.get("v.performance_report.Rate__c")+'';
        console.log('rohit '+loan_tenor);
     // alert(loan_type+' '+loan_tenor+' '+loan_amount+' '+rate+' '+loan_tenor_initial);
      //  alert(rate);
        
        this.executeApex(component,"calculateEMI", { 
            "loan_type":loan_type,
            "loan_tenor":loan_tenor,
            "loan_amount":loan_amount,
            "loan_tenor_initial":loan_tenor_initial,
            "rate":rate
        }, function (error, result) {
            console.log('  result@@ '+result);
            if (!error && result) {
                if(result.toString() != 'failed'){
                var dataList=JSON.parse(result);
                
                console.log('Data '+dataList);
                //uncomment below 1 line for bug 23005
                 var EMIlist=[]=result.split(" ");
                
                if(dataList.length == 1){
                    console.log('EMI Typevalue '+dataList[0]);
                    component.set("v.EMITypeValue",dataList[0]);
                    console.log('EMI Typevalue 222 '+component.get("v.EMITypeValue"));
                    
                }else{
                    component.set("v.subsequentEMI",dataList[1]);
                    component.set("v.InitialEMI",dataList[0]);
                }
            } 
            }
        });
    },
    getOffer: function(component,event){
        this.showhidespinner(component,event,true);
        var loanSelectList = ["Approved_Tenor__c","Loan_Type__c"];
        var selectListNameMap = {};
        selectListNameMap["Performance_reports__c"] = loanSelectList;
        var employeeId=component.get("v.EmployeeId");
        this.executeApex(component, "getEmployeeOffer", {
            'EmployeeId': employeeId, "objectFieldJSON":JSON.stringify(selectListNameMap)
        }, function (error, result) {
            if (!error && result) {
                var data=JSON.parse(result);
                console.log('hrushikesh is herer');
                console.log('Result '+JSON.stringify(data));

                component.set('v.performance_report',data.perList);
                var picklistFields = data.picklistData;
                var oppPickFlds = picklistFields["Performance_reports__c"];
                component.set("v.loanTenorList", oppPickFlds["Approved_Tenor__c"]);
                component.set("v.loanTypeList", oppPickFlds["Loan_Type__c"]); 
                component.set("v.InitialAmount",component.get("v.performance_report.Approved_Amt__c"));
                if($A.util.isEmpty(component.get("v.performance_report.Availed_Tenor__c")))
                {
                component.set("v.loanTenor",''+component.get("v.performance_report.Approved_Tenor__c"));
                }
                else
                    component.set("v.loanTenor",''+component.get("v.performance_report.Availed_Tenor__c"));
                component.set("v.hybridFullTenor",component.get("v.performance_report.Approved_Tenor__c")); //added later
                console.log('hrushikesh is 2');

                component.set("v.InitialTenor",component.get("v.performance_report.Approved_Tenor__c"));
                if(component.get("v.performance_report.Loan_Type__c")=='Term Loan' || component.get("v.performance_report.Loan_Type__c")=='Flexi Term Loan'){
                    component.set("v.isHybrid",false);
                }else if(component.get("v.performance_report.Loan_Type__c")=='Hybrid Loan'){
                    
                    component.set("v.isHybrid",true);
                    
                }
               // component.set("v.Rate",data.rate);
                var tenorList = component.get("v.loanTenorList");
                var approvedTenor = component.get("v.performance_report.Approved_Tenor__c");
                var newTenorList = [];
                component.set("v.Fees",data.processingFee);
                tenorList.forEach(function(listObj) {
                    if(parseInt(listObj, 10) <= parseInt(approvedTenor,10)){
                        newTenorList.push(listObj);
                    }
				});
                console.log('newTenorList is '+newTenorList);
                component.set("v.loanTenorList",newTenorList);
                this.showhidespinner(component,event,false);
            }
        });
        console.log('Final result '+ component.get('v.performance_report'));
        
    },
    availOffer: function(component,event){
        this.showhidespinner(component,event,true);
        if(component.get("v.performance_report.Approved_Amt__c") > component.get("v.InitialAmount") || component.get("v.performance_report.Approved_Tenor__c") < component.get("v.InitialTenor")){
            console.log('alert 2');
            component.set("v.isValid",false);
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Please enter correct loan details','error');
        }
        console.log('init Tenor::::'+component.get("v.InitialTenorHybrid")+'  Loan Type'+component.get("v.performance_report.Loan_Type__c"));
        if(component.get("v.performance_report.Loan_Type__c") == 'Hybrid Loan'){
            console.log('init Tenor::::'+component.get("v.InitialTenorHybrid"));
            if(!$A.util.isEmpty(component.get("v.InitialTenorHybrid")) && (component.get("v.InitialTenorHybrid") != 0 && component.get("v.InitialTenorHybrid") != '0' && component.get("v.InitialTenorHybrid") != '--None--') ){
                if(component.get("v.performance_report.Approved_Tenor__c") < component.get("v.performance_report.InitialTenorHybrid")){
                    component.set("v.isValid",false);
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Initial Tenor cannot be greater than Approved Tenor','error');
                }
                if(!(component.get("v.loanTenor") > 0)){
                    component.set("v.isValid",false);
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Subsequent tenor cannot be 0. Please choose another loan type','error');
                }
                if(component.get("v.InitialTenorHybrid") >= component.get("v.hybridFullTenor")) //added later
                {
                                        component.set("v.isValid",false);
            this.displayToastMessage(component,event,'Error','Pure Flexi Tenor cannot be greater or Equal to Selected total tenor','error')
                    this.showhidespinner(component,event,false);

                }
                    
                
                //Added by Aniket start
     		   if(component.get("v.performance_report.Bank_Acct_Number__c") == null){
                    component.set("v.isValid",false);
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Bank Account number should not be blank','error');
                }//Added by Aniket stop
        
                
            }
            else{
                component.set("v.isValid",false);
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Initial tenor cannot be empty.','error');
            }
   
        }
        console.log('here3');
        console.log('init Tenor::::'+component.get("v.InitialTenorHybrid")+'  Loan Type'+component.get("v.performance_report.Loan_Type__c"));

        if(component.get("v.isValid")){
        var SchemeObj = component.get("v.schemeObj");
        var SchemeId ;
        if(SchemeObj!=null)
        {
            SchemeId = SchemeObj.Id;
        }else{
             this.showhidespinner(component,event,false);
             this.displayToastMessage(component,event,'Error','Scheme is not available for '+component.get("v.performance_report.Loan_Type__c"),'error');
             return false;
        }       
        console.log('scheme is '+SchemeObj);
            //uncommented below 2 lines for bug 23005
        var OfferObj = JSON.stringify(component.get("v.performance_report"));
        //component.set("v.performance_report",OfferObj);
        var EMI = component.get("v.EMITypeValue");
        var InitEmi = component.get("v.InitialEMI");
        var SubEmi = component.get("v.subsequentEMI");
        var InitTenor = component.get("v.InitialTenorHybrid");
        var SubTenor = component.get("v.loanTenor");
        var Fees = component.get("v.Fees");
        var loan_amount=component.get("v.availedAmount");
        console.log('availed amount is::'+loan_amount);
            // below 1st line uncommented for bug 23005
        console.log(OfferObj);
        this.executeApex(component,'ConvertOffer',{
            "OfferObj":  OfferObj+'',
            "RejectReasons": component.get("v.mySelectedvalues")+'',
            "SchemeId": SchemeId+'',
            "EMI" : EMI+'',
            "InitEmi" : InitEmi+'',
            "SubEmi" : SubEmi+'',
            "InitTenor" : InitTenor+'',
            "SubTenor" : SubTenor+'',
            "Fees" : Fees+'',
            "availedAmount" : loan_amount+''
        },function(error, result){
            if(!error && result){
                console.log('loan created')
                console.log(result.toString().toUpperCase());
                if(result.toString().toUpperCase() != 'ERROR' && result.toString() != 'An Internal Error Occured.Unable to save PO Details'){
                    component.set('v.OppId',result.toString());
                    component.set('v.selTabId','tab2');
                     component.set('v.isDetailsAvailable',true);
                    var appEvent = $A.get("e.c:flowIdToLanding");
                    appEvent.setParams({ "Id" : result.toString(),
                                        "tabid" : 'tab2',
                                        "stageIsMyDetails":true,
                                       "detailsAvailable" : true});
                    appEvent.fire();
                    component.set("v.isOfferAvailabel",false);
                    console.log('POp'+component.get("v.performance_report.Loan_Type__c"));
                    /*var perf_report = component.get("v.performance_report");
                    perf_report.Offer_converted__c = true;
                    component.set("v.performance_report",perf_report);*/
                    component.set("v.isDetailsAvailable",true);
                    //window.location.href = 'https://saldev2-bflloans.cs58.force.com/EmployeeLoansLanding_VF?EmployeeId='+component.get("v.EmployeeId");
                //this.showhidespinner(component,event,false);
                
				}
                else{
                    this.displayToastMessage(component,event,'Error','Unable to save offer details.Please try again Later','error');
                                this.showhidespinner(component,event,false);

}
                //this.showhidespinner(component,event,false);
                
            }
            else{
                this.displayToastMessage(component,event,'Error','Unable to save offer details.Please try again Later','error');
                this.showhidespinner(component,event,false);
                
            }
            
        });
        } 
        else{
        this.showhidespinner(component,event,false);
        }
    },
    availLater: function(component,event){
        this.showhidespinner(component,event,true);
        if(component.get("v.performance_report.Approved_Amt__c") > component.get("v.InitialAmount") || component.get("v.performance_report.Approved_Tenor__c") < component.get("v.InitialTenor")){
            console.log('alert 2');
            component.set("v.isValid",false);
            this.showhidespinner(component,event,false);
            this.displayToastMessage(component,event,'Error','Please enter correct loan details','error');
        }
        console.log('init Tenor::::'+component.get("v.InitialTenorHybrid")+'  Loan Type'+component.get("v.performance_report.Loan_Type__c"));
        if(component.get("v.performance_report.Loan_Type__c") == 'Hybrid Loan'){
            console.log('init Tenor::::'+component.get("v.InitialTenorHybrid"));
            if(!$A.util.isEmpty(component.get("v.InitialTenorHybrid")) && (component.get("v.InitialTenorHybrid") != 0 && component.get("v.InitialTenorHybrid") != '0' && component.get("v.InitialTenorHybrid") != '--None--') ){
                if(component.get("v.performance_report.Approved_Tenor__c") < component.get("v.performance_report.InitialTenorHybrid")){
                    component.set("v.isValid",false);
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Initial Tenor cannot be greater than Approved Tenor','error');
                }
                if(!(component.get("v.loanTenor") > 0)){
                    component.set("v.isValid",false);
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Subsequent tenor cannot be 0. Please choose another loan type','error');
                }
                if(component.get("v.InitialTenorHybrid") >= component.get("v.hybridFullTenor")) //added later
                {
                                        component.set("v.isValid",false);
            this.displayToastMessage(component,event,'Error','Pure Flexi Tenor cannot be greater or Equal to Selected total tenor','error')
                    this.showhidespinner(component,event,false);

                }
            }
            else{
                component.set("v.isValid",false);
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Initial tenor cannot be empty.','error');
            }
   
        }
        console.log('here3');
        console.log('init Tenor::::'+component.get("v.InitialTenorHybrid")+'  Loan Type'+component.get("v.performance_report.Loan_Type__c"));
        if(component.get("v.isValid")){
        var SchemeObj = component.get("v.schemeObj");
        var SchemeId = '';
        if(SchemeObj != null && SchemeObj != undefined){    
       		SchemeId = SchemeObj.Id;
        }
        console.log('scheme is '+SchemeObj);
        var OfferObj = JSON.stringify(component.get("v.performance_report"));
        component.set("v.performance_report",OfferObj);
        var EMI = component.get("v.EMITypeValue");
        var InitEmi = component.get("v.InitialEMI");
        var SubEmi = component.get("v.subsequentEMI");
        var InitTenor = component.get("v.InitialTenorHybrid");
        var SubTenor = component.get("v.loanTenor");
        var Fees = component.get("v.Fees");
        var loan_amount=component.get("v.availedAmount");
        console.log('availed amount is::'+loan_amount);
        console.log(component.get("v.mySelectedvalues"));
        this.executeApex(component,'ConvertOffer',{
            "OfferObj": OfferObj+'',
            "RejectReasons": component.get("v.mySelectedvalues")+'',
            "SchemeId": SchemeId+'',
            "EMI" : EMI+'',
            "InitEmi" : InitEmi+'',
            "SubEmi" : SubEmi+'',
            "InitTenor" : InitTenor+'',
            "SubTenor" : SubTenor+'',
            "Fees" : Fees+'',
            "availedAmount" : loan_amount+''
        },function(error, result){
            if(!error && result){
                
                console.log(result);
                if(result.toString().toUpperCase() != 'ERROR'){
                    component.set("v.OppId",result.toString());
                    component.set("v.isExit",true);
                    console.log(' component.set("v.OppId",result.toString()) '+ component.get("v.OppId"));
                    console.log(' component.set("v.isExit",true);'+  component.get("v.isExit"));
                }
                this.showhidespinner(component,event,false);
            }
            else{
                console.log('error is::::'+error);
                component.set("v.isExit",true);
                this.showhidespinner(component,event,false);
            }
            
            this.showhidespinner(component,event,false);
        });
        }
          
    },
     executeApex: function(component, method, params,callback){
        var action = component.get("c."+method); 
         console.log('action'+action);
        action.setParams(params);
        console.log('params'+JSON.stringify(params));

        action.setCallback(this, function(response) {
            var state = response.getState();
console.log(state);
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
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },
    fetchScheme :  function(component, event) {
        
        
        
        this.executeApex(component, "fetchScheme", {  //, employee__c=true, flexi_flag__c=true, IsHybridFlexi__c
            
        }, function (error, result) {
            console.log('result : ' + result);
            if (!error && result) {
                var data=JSON.parse(result);
                component.set('v.schemeObjList',data);
                var schemeList=[]=component.get("v.schemeObjList");
                this.selectScheme(component,event);
            }
        });
    },
    selectScheme : function (component, event) {
        component.set("v.schemeObj",null);
        var loanType=component.get("v.performance_report.Loan_Type__c");
        
        if(loanType == 'Term Loan'){
            component.set("v.EMILabel","EMI");
             component.set("v.TenorLabel","Tenor");
        }else if(loanType == 'Flexi Term Loan'){
             component.set("v.EMILabel","EMI for Flexi Term Loan Duration");
             component.set("v.TenorLabel","Flexi Term Loan Tenor");
        }      
        
        var schemeList=[]=component.get("v.schemeObjList");
        console.log('selecting schemes 123'+loanType+'   '+schemeList.length);
        if(loanType == 'Term Loan' && schemeList.length>0 &&  !$A.util.isEmpty(schemeList)){
            component.set("v.isHybrid",false);
            for(var i=0; i<schemeList.length; i++){
                if(schemeList[i].employee__c==true && schemeList[i].flexi_flag__c==false && schemeList[i].is_Pure_Flexi__c==false && schemeList[i].IsHybridFlexi__c==false){
                    component.set("v.schemeObj",schemeList[i]);
                    console.log('3 '+component.get("v.schemeObj"));
                }
            }
           
        }else  if(loanType == 'Flexi Term Loan' && schemeList.length>0 &&  !$A.util.isEmpty(schemeList)){
            component.set("v.isHybrid",false);
            for(var i=0; i<schemeList.length; i++){
                
                if(schemeList[i].employee__c==true &&  schemeList[i].is_Pure_Flexi__c==true && schemeList[i].IsHybridFlexi__c==false){
                    component.set("v.schemeObj",schemeList[i]);
                    
                    console.log('2 '+component.get("v.schemeObj"));
                    
                }
            }
        }else if(loanType == 'Hybrid Loan' && schemeList.length>0 &&  !$A.util.isEmpty(schemeList)){
            component.set("v.isHybrid",true);
            console.log('Scheme3 found ');
            for(var i=0; i<schemeList.length; i++){
                if(schemeList[i].employee__c==true &&  schemeList[i].flexi_flag__c==true && schemeList[i].IsHybridFlexi__c==true && schemeList[i].is_Pure_Flexi__c==false){
                    component.set("v.schemeObj",schemeList[i]);
                    console.log('1 '+component.get("v.schemeObj"));
                }
            }
        }
        console.log('Selected scheme is '+component.get("v.schemeObj.employee__c"));
        console.log('Selected scheme is '+component.get("v.schemeObj.flexi_flag__c"));
        console.log('Selected scheme is '+component.get("v.schemeObj.IsHybridFlexi__c"));
        
        if((loanType == 'Hybrid Loan' && component.get("v.InitialTenorHybrid") != '--None--')|| ((loanType == 'Flexi Term Loan' || loanType == 'Term Loan')&& component.get("v.loanTenor") != '')){
        	this.calculateEMI(component, event); 
        }
    },
    setRejectReasons : function(component,event){
        var loanSelectList = ["Looking for Higher Loan Amount",
                              "Need Clarification on Product Type",
                              "Need Clarification on Disbursement Process",
                              "High Rate of Interest",
                              "Need Clairification in Processing Fee",
                              "Not Interested",
                              "Others"];
        component.set("v.rejectReasons",loanSelectList);
        console.log(component.get("v.rejectReasons"));
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
    
})