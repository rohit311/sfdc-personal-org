({
   
    
    
    getPOSData : function(component,event) {
        var oppSelectList = ["Type_Of_Loan__c","Loan_Variant__c","End_Use__c","If_Yes__c"]; /*"Loan_Variant__c"  */
        var teleSelectList = ["DisbursementType__c"];
        var accountlist = ["Purpose_of_Facility__c","Program__c"];//22017 /*US_18345 added Program__c*/
        var selectListNameMap = {};
        var loanVarList=[]; /*US_18345 CR-27573 S*/
        selectListNameMap["Opportunity"] = oppSelectList;
        selectListNameMap["TelePDQuestionMaster__c"] = teleSelectList;
        selectListNameMap["Account"] = accountlist;
        this.executeApex(component, "getPOSData", {'oppId':component.get("v.oppId"),'objectFieldJSON':JSON.stringify(selectListNameMap)}, function(error, result){
            if (!error && result) {
                var data = JSON.parse(result);
                var picklistFields = data.picklistData;
                var oppPickFlds = picklistFields["Opportunity"];
                component.set("v.loanTypeList", oppPickFlds["Type_Of_Loan__c"]);
                component.set("v.endUseList", oppPickFlds["End_Use__c"]);/*US_982*/
                component.set("v.loanVariantList", oppPickFlds["Loan_Variant__c"]);
                var telePickFlds = picklistFields["TelePDQuestionMaster__c"];
                component.set("v.disTypeList", telePickFlds["DisbursementType__c"]);
                //22017 start
                var accountpick = picklistFields["Account"];
                component.set("v.proposedLoan", accountpick["Purpose_of_Facility__c"]);
                //22017 end
                  /*US_18345 S*/
                component.set("v.programTypeList", accountpick["Program__c"]);
                 /*US_18345 E*/
                /*US_18345 CR-27573 S*/
                 var hybridflexiflag=component.get("v.camObj").Business_Continuty__c;
                 if(hybridflexiflag=='Yes' || $A.util.isEmpty(hybridflexiflag))
                  {
                    loanVarList.push('REGULAR','HYBRID','DROPLINE FLEXI');
                    component.set("v.loanVariantList",loanVarList);
                  }
               else {
                   loanVarList.push('REGULAR','DROPLINE FLEXI');
                   component.set("v.loanVariantList",loanVarList);
                    }
                /*US_18345 CR-27573 E*/  
                if(!$A.util.isEmpty(data) && data.NoOfSolPolicyWithBreFlagTrue > 0){
                    component.set("v.showRetrigger",true);  
                }
                var posList = data.posList;
                component.set("v.oppObj",data.opp);
                var loanType = component.get("v.oppObj").Type_Of_Loan__c;
                 /*US_982 S*/
                  if(!$A.util.isEmpty(loanType) && (loanType=="Parallel 1"|| loanType=="Parallel 2"||loanType=="Parallel 3" ))
                 {
                console.log('inside two');
                component.set("v.endUseFlag",true);  
                console.log('enduseflag::'+"v.endUseFlag");
                  }
                else
                    component.set("v.endUseFlag",false);
                /*US_982 E*/
                component.set("v.topUpList",data.topUpList);
                component.set("v.BTList",data.BTList);
                var posListTU = [];
                for(var i=0;i<posList.length;i++){
                    if(posList[i].POS_Type__c == 'Top Up'){
                        posListTU.push(posList[i]);
                    }
                    else if(posList[i].POS_Type__c == 'BT'){
                        component.set("v.posRecBT",posList[i]);
                    }
                }
                console.log('posRecBT'+component.get("v.posRecBT"));
                component.set("v.posListTU",posListTU);
                component.set("v.theme",data.theme);
                console.log('component.get("v.theme")'+component.get("v.theme"));
                //underwriter screen change start
                if(!$A.util.isEmpty(data.opp) && !$A.util.isEmpty(data.opp.Scheme_Master__c)){
                    component.set("v.schemeSearchKeyword", data.opp.Scheme_Master__r.Name);
                }
                //underwriter screen change end
                this.renderSec(component,event);
            }
            else{
                this.showhidespinner(component,event,false);
            }
        });
    },
    fetchPOSData : function(component,event){
        var posRecBT = component.get("v.posRecBT");
        var posListTU = component.get("v.posListTU");
        var oppObj = component.get("v.oppObj");
        var data = component.get('v.lstTopUp');
        
        var flag = false;
        for(var i=0;i<posListTU.length;i++)
        {
            
            if(!flag)
            {
                var tempLAN = posListTU[i].ExistingLAN__c;
                var tempbal = posListTU[i].BalanceAmount__c;
                var tempType= posListTU[i].DisbursementType__c;
                for(var j=0;j<posListTU.length;j++)
                {
                    if(($A.util.isEmpty(tempLAN)))
                    {
                        flag = true;
                        this.displayToastMessage(component,event,'Error','Please enter Existing LAN','error');
                        break;
                    }
                    if(j === i){
                        console.log(j + ' == ' + i);
                        continue;
                    }
                    else
                    {
                        if(tempLAN === posListTU[j].ExistingLAN__c){
                            flag = true;
                            this.displayToastMessage(component,event,'Error','Same ID found','error');
                            break;
                        }
                        
                    }
                }    
            }
            else
            {
                break;
            }
            
        }
        if(flag==false){
            console.log('flag'+flag);
            for(var i=0;i<posListTU.length;i++){
                posListTU[i].LoanApplication__c = oppObj.Id;
                posListTU[i].POS_Type__c = 'Top Up';
            }
            this.executeApex(component, "fetchPOSTU", {'oppObj':JSON.stringify(oppObj),'posObj':JSON.stringify(posRecBT),'posList':JSON.stringify(posListTU)}, function(error, result){
                if (!error && result) {
                    var data = JSON.parse(result);
                    posListTU = [];
                    if(data.posList.length > 0){
                        var posList = data.posList;
                        console.log('posList'+posList.length);
                        for(var i=0;i<posList.length;i++){
                            if(posList[i].POS_Type__c == 'Top Up'){
                                posListTU.push(posList[i]);
                            }
                        }
                        var telePDBT = {'sobjectType':'TelePDQuestionMaster__c'};
                        component.set("v.posRecBT",telePDBT);   
                        component.set("v.posListTU",posListTU);
                        this.displayToastMessage(component,event,'Success','Data fetched successfully','success');
                    }
                    else{
                        this.displayToastMessage(component,event,'Error','Error in fetching data','error');
                    }
                    this.showhidespinner(component,event,false);
                    
                }
                else{
                    this.showhidespinner(component,event,false);
                    this.displayToastMessage(component,event,'Error','Failed to fetch data','error');
                }
            }); 
        }
        else{
            this.showhidespinner(component,event,false);
        }
    },
   
    savePOSDataBT : function(component,event){
        var posRecBT = component.get("v.posRecBT");
        var posListTU = component.get("v.posListTU");
        var oppObj = component.get("v.oppObj");
        console.log('oppOBJ>>>>'+JSON.stringify(oppObj));
        var validData = true;
        var fieldName = component.find("posVal");
        if($A.util.isEmpty(fieldName) || !fieldName.get("v.validity").valid){
            fieldName.showHelpMessageIfInvalid();
            validData = false;
        }
        console.log('Abhi Valid::'+validData);
        if(validData){
            posRecBT.LoanApplication__c = oppObj.Id;
            posRecBT.POS_Type__c = 'BT';
            console('Abhi:::'+validData);
            this.executeApex(component, "savePOSDataBT", {'oppObj':JSON.stringify(oppObj),'posObj':JSON.stringify(posRecBT),'posList':JSON.stringify(posListTU),'accJSON':JSON.stringify(component.get("v.account"))}, function(error, result){
                console.log('Abhi Error::'+error);
                console.log('Abhi result::'+result);
                if (!error && result) {
                    var data = JSON.parse(result);
                    var posList = data.posList;
                    component.set("v.oppObj",data.opp);
                    console.log('posList.length'+posList.length);
                    if(posList.length > 0){
                        for(var i=0;i<posList.length;i++){
                            if(posList[i].POS_Type__c == 'BT'){
                                component.set("v.posRecBT",posList[i]);
                            }
                        }
                    }
                    else{
                        component.set("v.posRecBT",{'sobjectType':'TelePDQuestionMaster__c'});
                    }
                    var telePDList = [];
                    telePDList.push({'sobjectType':'TelePDQuestionMaster__c'});
                    component.set("v.posListTU",telePDList);  
                    this.displayToastMessage(component,event,'Success','Details saved successfully','success');
                    this.showhidespinner(component,event,false);
                }
                else{
                    this.displayToastMessage(component,event,'Error','Failed to save data','error');
                    this.showhidespinner(component,event,false);
                }
            }); 
        }
        else{
            this.displayToastMessage(component,event,'Error','Please enter required data','error');
            this.showhidespinner(component,event,false);
        }
    },
    savePOSDataOth : function(component,event){
        var posRecBT = component.get("v.posRecBT");
        var posListTU = component.get("v.posListTU");
        var oppObj = component.get("v.oppObj");
        var loanType = component.get("v.oppObj").Type_Of_Loan__c;
        var endUse = component.get("v.oppObj").End_Use__c;/*US_982*/
        if($A.util.isEmpty(loanType)){
            this.displayToastMessage(component,event,'Error','Please enter Loan Type','error');
            this.showhidespinner(component,event,false);
            return;
        }
         /*US_982 S*/
        if(loanType!="Parallel 1" && loanType!="Parallel 2" && loanType!="Parallel 3" ){
           component.set("v.oppObj.End_Use__c",""); 
        }
       /*US_982 E*/
        this.executeApex(component, "savePOSDataOth", {'oppObj':JSON.stringify(oppObj),'posObj':JSON.stringify(posRecBT),'posList':JSON.stringify(posListTU),'accJSON':JSON.stringify(component.get("v.account"))}, function(error, result){
            console.log('Abhi Error::'+error);
            console.log('Abhi Result::'+result);
            if (!error && result) {
                console.log('in success pos');
                var data = JSON.parse(result);
                var posList = data.posList;
                component.set("v.oppObj",data.opp);
                var telePDBT = {'sobjectType':'TelePDQuestionMaster__c'};
                var telePDList = [];
                telePDList.push({'sobjectType':'TelePDQuestionMaster__c'});
                component.set("v.posRecBT",telePDBT);    
                component.set("v.posListTU",telePDList);  
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Success','Details saved successfully','success');

            }
            else{
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Failed to save data','error');
            }
        }); 
    },
    savePOSDataTU : function(component,event){
        var posListTU = component.get("v.posListTU");
        var posRecBT = component.get("v.posRecBT");
        var oppObj = component.get("v.oppObj");
        
        var flag = false;
        for(var i=0;i<posListTU.length;i++)
        {
            if(!flag)
            {
                var tempLAN = posListTU[i].ExistingLAN__c;
                var bal=posListTU[i].BalanceAmount__c;
                var type=posListTU[i].DisbursementType__c;
                if(($A.util.isEmpty(tempLAN)))
                {
                    flag = true;
                    this.displayToastMessage(component,event,'Error','Please enter existing LAN','error');
                    break;
                }
                if(($A.util.isEmpty(bal) || bal == 0) && type=='Close Existing')
                {
                    flag = true;
                    this.displayToastMessage(component,event,'Error','Can not save as balance amount is 0.','error');
                    break;
                }
                for(var j=0;j<posListTU.length;j++)
                {
                    if(j === i){
                        console.log(j + ' == ' + i);
                        continue;
                    }
                    else
                    {
                        if(tempLAN === posListTU[j].ExistingLAN__c){
                            flag = true;
                            this.displayToastMessage(component,event,'Error','Same ID found','error');
                            break;
                        }
                        
                    }
                }    
            }
            else
            {
                break;
            }
            
        }
        if(flag==false){
            console.log('flag'+flag);
            for(var i=0;i<posListTU.length;i++){
                posListTU[i].LoanApplication__c = oppObj.Id;
            }
            this.executeApex(component, "savePOSDataTU", {'oppObj':JSON.stringify(oppObj),'posObj':JSON.stringify(posRecBT),'posList':JSON.stringify(posListTU),'accJSON':JSON.stringify(component.get("v.account"))}, function(error, result){
                if (!error && result) {
                    var data = JSON.parse(result);
                    var posList = data.posList;
                    component.set("v.oppObj",data.opp);
                    console.log(posList.length);
                    posListTU = [];
                    for(var i=0;i<posList.length;i++){
                        if(posList[i].POS_Type__c == 'Top Up'){
                            posListTU.push(posList[i]);
                        }
                    }
                    var telePDBT = {'sobjectType':'TelePDQuestionMaster__c'};
                    component.set("v.posRecBT",telePDBT);    
                    component.set("v.posListTU",posListTU);
                    this.displayToastMessage(component,event,'Success','Details saved successfully','success');
                    this.showhidespinner(component,event,false);
                }
                else{
                    this.displayToastMessage(component,event,'Error','Failed to save data','error');
                    this.showhidespinner(component,event,false);
                }
            }); 
        }
        else{
            this.showhidespinner(component,event,false);
        }
    },
    renderSec : function(component,event) {
        var loanType = component.get("v.oppObj").Type_Of_Loan__c;
        var BTList = component.get("v.BTList");
        var topUpList = component.get("v.topUpList");
        console.log ('loan selected='+loanType);
        console.log('topUpList'+topUpList+'---'+BTList);
        if(!$A.util.isEmpty(loanType)){
            if(BTList.includes(loanType)){
                component.set("v.BTFlag",true);
                component.set("v.topUpFlag",false);
                component.set("v.otherFlag",false);
                var telePDBT = component.get("v.posRecBT");
                console.log('telePDBT'+telePDBT);
                if($A.util.isEmpty(telePDBT)){
                    telePDBT = {'sobjectType':'TelePDQuestionMaster__c'};
                }
                component.set("v.posRecBT",telePDBT);            
                
            }
            else if(topUpList.includes(loanType)){
                console.log ('top up loan check');
                component.set("v.BTFlag",false);
                component.set("v.topUpFlag",true);
                component.set("v.otherFlag",false);
                var telePDList = component.get("v.posListTU");
                console.log('telePDList'+telePDList.length);
                if($A.util.isEmpty(telePDList)){
                    telePDList.push({'sobjectType':'TelePDQuestionMaster__c'});
                }
                component.set("v.posListTU",telePDList);            
            }
                else{
                    component.set("v.otherFlag",true);
                    component.set("v.BTFlag",false);
                    component.set("v.topUpFlag",false);
                }
             /*US_982 S*/
              if(!$A.util.isEmpty(loanType) && (loanType=="Parallel 1"|| loanType=="Parallel 2"||loanType=="Parallel 3" ))
             {
                 console.log('inside two');
            component.set("v.endUseFlag",true);  
            console.log('enduseflag::'+"v.endUseFlag");
              }
            else{
                  var oppObj = component.get("v.oppObj");
                  oppObj.If_Yes__c = '';
                  component.set("v.oppObj",oppObj);  
                  component.set("v.endUseFlag",false);
            }
            this.showhidespinner(component,event,false);
        }/*US_982 E*/
        else{
            component.set("v.otherFlag",true);
            component.set("v.BTFlag",false);
            component.set("v.topUpFlag",false);
            component.set("v.endUseFlag",false);/*US_982 */
            this.showhidespinner(component,event,false);
        }
        
    },
    deletePOSRecord : function(component,event,recId){
        console.log('recId'+recId);
        var posListTU = component.get("v.posListTU");
        console.log('posListTU'+posListTU);
        var oppObj = component.get("v.oppObj");
        this.executeApex(component, 'delposList', 
                         {
                             'oppObj':JSON.stringify(oppObj),"recordId": recId,"posListTU":JSON.stringify(posListTU)
                         }, function(error, result){
                             console.log(error+'---'+result);
                             if (!error && result) {
                                 var data = JSON.parse(result);
                                 posListTU = data.posList;
                                 component.set("v.posListTU",posListTU);
                                 this.renderSec(component,event);
                                 this.displayToastMessage(component,event,'Success','Record deleted successfully','success');
                                 this.showhidespinner(component,event,false);
                             }
                             else{
                                 this.displayToastMessage(component,event,'Error','Failed to delete record','error');
                                 this.showhidespinner(component,event,false);
                             }
                             
                         });
    },
    executeApex: function(component, method, params,callback){
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
    //underwriter screen change start
    openCloseSearchResults: function (component, key, open) {
        var resultPanel = component.find(key + "SearchResult");
        $A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
        $A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
    },
    startSearch: function (component, key) {
        var keyword = component.get("v." + key + "SearchKeyword");
        //alert('keyword>>>'+keyword+'>>schemesearching>>'+component.get('v.schemesearching'));
        if (keyword.length > 2 && !component.get('v.schemesearching')) {
            console.log("keyword schemesearching" + keyword+"key"+key);
            component.set('v.schemesearching', true);
            component.set('v.oldSchemeKeyword', keyword);
            console.log ('from start search to search helper');
            this.searchHelper(component, key, keyword);
        }
        else if (keyword.length <= 2) {
            console.log("keyword" + keyword+"key"+key);
            component.set("v." + key + "List", null);
            this.openCloseSearchResults(component, key, false);
        }
        
    },
    searchHelper: function (component, key, keyword) {
        //alert('executeApex>>' + keyword + '>>key>>' + key);
        
        this.executeApex(component, "fetch" + this.toCamelCase(key), {
            'searchKeyWord': keyword,
            'oppId':component.get('v.oppId')
        }, function (error, result) {
            //alert('result : ' + result);
            if (!error && result) {
                console.log ('search helper apex result='+result);
                this.handleSearchResult(component, key, result);
            }
            else console.log ('else condition');
        });
    },
    handleSearchResult: function (component, key, result) {
        console.log('key :  handleSearchResult' + key);
        if(key == 'scheme')
        {
            component.set('v.schemesearching', false);
            if (!$A.util.isEmpty(component.get("v." + key + "SearchKeyword")) && component.get('v.oldSchemeKeyword') !== component.get("v." + key + "SearchKeyword")) {
                component.set("v." + key + "List", null);
                this.startSearch(component, key);
            }
            else {
                component.set("v." + key + "List", result);
                //this.showHideMessage(component, key, !result.length);
                this.openCloseSearchResults(component, key, true);
            }
        }
    },
    toCamelCase: function (str) {
        return str[0].toUpperCase() + str.substring(1);
    },
    //underwriter screen change start
    /*Retrigger 20939 s*/
    retriggerBRE : function(component,event)
    {
        this.showhidespinner(component,event,true);
        this.executeApex(component, "retriggerBRECalls", {
            'loanid': component.get("v.oppId")
            
        }, function (error, result) {
            var data = result;
            console.log('data>>>'+data);
            if (!error && data) {
                this.showhidespinner(component,event,false);
                if(result == 'success')
                {
                    this.displayToastMessage(component,event,'Success','BRE Retriggered Successfully.','success');
                    
                }
                else
                    this.displayToastMessage(component,event,'Error','Error Occoured!','error');	
            }
            else{
                this.showhidespinner(component,event,false);
                this.displayToastMessage(component,event,'Error','Error Occoured!','error');
                console.log(data);
            }
        });
    },
     /*Retrigger 20939 e*/
     /*US_18345 S*/
    varientChange:function(component,event){
        var loanTypeList=[];
        //alert('Abhi Programtype:::'+component.find('programType').get("v.value"));
        component.set("v.programType",component.find('programType').get("v.value"));
        component.set("v.loanType",component.find('loanType').get("v.value"));
       
        if(component.get("v.account").Program__c=='BAJAJ & TCS EMP'||component.get("v.account").Program__c=='BFL Employee')
        {
            loanTypeList.push('BT & top up','Fresh','BT','top up','Parallel')
            component.set("v.loanTypeList",loanTypeList);
        }
        else if(component.get("v.account").Program__c=='DEFENCE'||component.get("v.account").Program__c=='Line'||component.get("v.account").Program__c=='Line Field'
                ||component.get("v.account").Program__c=='Preapproved Bagic\Balic'||component.get("v.account").Program__c=='Preapproved DYNAMIC'||
                component.get("v.account").Program__c=='Preapproved Normal'|| component.get("v.account").Program__c=='Preapproved PROSPECT'||component.get("v.account").Program__c=='Preapproved PROSPECT Field'
                ||component.get("v.account").Program__c=='Preapproved PROSPECT PRO PLTB'||component.get("v.account").Program__c=='Preapproved STP'||component.get("v.account").Program__c=='RESCHEDULEMENT'||component.get("v.account").Program__c=='SECL Skilled')
        {
            loanTypeList.push('Fresh');
            component.set("v.loanTypeList",loanTypeList);
        }
            else if(component.get("v.account").Program__c=='PLTB'||component.get("v.account").Program__c=='PLTB EMP')
            {
                loanTypeList.push('Fresh','BT','top up','Parallel');
                component.set("v.loanTypeList",loanTypeList);
            }
                else if(component.get("v.account").Program__c=='Normal')
                {
                    loanTypeList.push('Fresh','BT','top up','Parallel','BT & top up','Parallel & BT','Parallel, BT & Top up')
                    component.set("v.loanTypeList",loanTypeList);
                }
                    else if(component.get("v.account").Program__c=='DOE Skilled')
                    {
                        loanTypeList.push('Fresh','top up');
                        component.set("v.loanTypeList",loanTypeList);
                    }
                        else if(component.get("v.account").Program__c=='Preapproved PLTB')
                        {
                            loanTypeList.push('Fresh','BT');
                            component.set("v.loanTypeList",loanTypeList);
                        }
        
    },
    updateSchemeList: function(component,event){
        var lntype = component.get("v.oppObj.Type_Of_Loan__c");
        component.set("v.loanType",lntype);
        var loanVariant='';
        if(!$A.util.isEmpty(component.find('loanVariant').get("v.value"))&&component.find('loanVariant').get("v.value")!='--None--'&& component.find('loanVariant').get("v.value")!='')
          loanVariant= component.find('loanVariant').get("v.value");
         if(!$A.util.isEmpty(component.get("v.oppObj")) &&!$A.util.isEmpty(component.get("v.oppObj").Product__c))
        var product=component.get("v.oppObj").Product__c;
        if(!$A.util.isEmpty(component.get("v.oppObj")) &&!$A.util.isEmpty(component.get("v.oppObj").Branch_Name__r) &&!$A.util.isEmpty(component.get("v.oppObj").Branch_Name__r.Market_Type__c))
        var branch=component.get("v.oppObj").Branch_Name__r.Market_Type__c;
       // alert(component.get("v.oppObj").Branch_Name__r.Market_Type__c);
       //alert('Abhi alert:::'+'loanVariant::'+loanVariant+'product::'+product+'branch::'+branch+'programType::'+component.get("v.programType")+'loanType::'+component.get("v.loanType"));
        if(!$A.util.isEmpty(product) && !$A.util.isEmpty(branch)&&!$A.util.isEmpty(component.get("v.programType")&&!$A.util.isEmpty(component.get("v.loanType"))))
        this.executeApex(component,"fetchSchemeMaster",{
            'program':component.get("v.programType"),
            'loanVariant':loanVariant,
            'product':product,
            'loanType':component.get("v.loanType"),
            'branch':branch
        },function (error, result) {
            console.log('result of fetch scheme');
            console.log(result);
            if (!error && result && result[0]) {
                //toast
                this.displayToastMessage(component,event,'Success','Scheme found !!','Success');
                component.set("v.selectedScheme", result[0]);
                component.set("v.oppObj.Scheme_Master__c", result[0].Id);
                component.set("v.schemeSearchKeyword",result[0].Name);
            }
            else if($A.util.isEmpty(result)){
                this.displayToastMessage(component,event,'Info','Scheme not found , please search .','Info');
                component.set("v.selectedScheme", new Object());
                component.set("v.oppObj.Scheme_Master__c", '');
                component.set("v.schemeSearchKeyword",'');
                
            }
        });
    },
    /*US_18345 E*/
})