({
    filterPO : function(component) {
        var poList = component.get("v.poListInit")
        var loanAmt = component.find("loan_amt").get("v.value");
        var leadOPoSrc = component.get("v.sourceVal");
        var leadOPoSrcVal = component.find("src_Val").get("v.value");
        var prgType = component.find("prg_type").get("v.value");
        var offerDate = component.find("off_date").get("v.value");
        var empVar = component.find("EmpVal").get("v.value");//Bug 18539
        //console.log('empVar :'+empVar);
        var filteredPOList = [];
        var filteredPOs = poList;
        if(!$A.util.isEmpty(offerDate) || !$A.util.isEmpty(loanAmt) || !$A.util.isEmpty(leadOPoSrcVal) || !$A.util.isEmpty(prgType) || !$A.util.isEmpty(empVar)){//added empVar for Bug 18539
            if(!$A.util.isEmpty(loanAmt)){
                filteredPOs = this.filterPoList(filteredPOs,'Number','Availed_Amount__c',loanAmt,'>=');
            }
            if(!$A.util.isEmpty(leadOPoSrcVal)){
                if(leadOPoSrc == 'lead_source'){
                    filteredPOs = this.filterPoList(filteredPOs,'Text','Lead_Source__c',leadOPoSrcVal,'==');
                }
                else if(leadOPoSrc == 'po_source'){
                    //console.log('posource');
                    filteredPOs = this.filterPoList(filteredPOs,'Text','Product_Offering_Source__c',leadOPoSrcVal,'==');
                }
            }
            if(!$A.util.isEmpty(prgType)){
                filteredPOs = this.filterPoList(filteredPOs,'Text','Program_Type__c',prgType,'==');
            }
            /*Bug 18539 Start*/
            if(!$A.util.isEmpty(empVar)){
                filteredPOs = this.filterPoList(filteredPOs,'Text','Lead__r.Employer__r.Name',empVar,'==');
            }
            /*Bug 18539 End*/
            if(!$A.util.isEmpty(offerDate)){
                filteredPOs = this.filterPoList(filteredPOs,'Date','Field_In_Time__c',offerDate,'==');
            }
            //console.log('new Filtered'+filteredPOs.length);
            //console.log('filteredPOList'+filteredPOList.length);
            component.set("v.filteredPOList",filteredPOs);
            $A.util.removeClass(component.find("backBtn"), 'slds-hide');
            $A.util.addClass(component.find("backBtn"), 'slds-show');
            $A.util.removeClass(component.find("tabSection"), 'slds-show');
            $A.util.addClass(component.find("tabSection"), 'slds-hide');
            $A.createComponent(
                "c:SAL_POListViewTable",
                {
                    "lstPo" : component.get("v.filteredPOList")
                },
                function(newComponent){
                    component.set("v.body",newComponent);
                }
            );
            $("#filterDivTog").slideToggle();
        }
        else{
            this.displayToastMessage(component,event,'Info','Please enter filter criteria','info');
            //this.ShowToast(component, "Error", "Please enter filter criteria", "error")
        }
        
        //$A.util.toggleClass(component.find("filterDivTog"), "slds-hide");
    },
    filterPoList : function(poList,type,field,val,op){
        var filteredPOList = [];
        //console.log('poList : '+poList.length);
        for(var j=0;j<poList.length;j++){
			var curPO = poList[j];
            //console.log('curPO : '+JSON.stringify(curPO));
            if(!$A.util.isEmpty(curPO.Product_Offering_Converted__c) && curPO.Product_Offering_Converted__c == false){
                if(type == 'Date'){
                    var d1 = new Date(val);
                    var d2;
                    if(!$A.util.isEmpty(curPO[field]))
                       d2 = new Date(curPO[field].substring(0, 10));
                    if(d2 >= d1){
                        filteredPOList.push(curPO);
                    }
                }
                else if(type == 'Number'){
                    if(op == '>='){
                        if(!$A.util.isEmpty(curPO[field]) && curPO[field] >= val){
                            filteredPOList.push(curPO);
                        }
                    }
                    else if(op == '<'){
                        if(!$A.util.isEmpty(curPO[field]) && curPO[field] <= val){
                            filteredPOList.push(curPO);
                        }
                    }
                        else if(op == '=='){
                            if(!$A.util.isEmpty(curPO[field]) && curPO[field] == val){
                                filteredPOList.push(curPO);
                            }
                        }
                }
                    else if(type == 'Text'){
                        //console.log('text'+field+val);
                        //console.log('Values is ::'+curPO[field]);
                        if(field.includes('.')){
                            var arrField = field.split('.');
                            //console.log('arrfield'+arrField.length);
                            var name = curPO;
                            for(var i in arrField){
                                if(!$A.util.isEmpty(name))
                                	name = name[arrField[i]];
                            }
                        }
                        else{
                            name = curPO[field];
                        }
                        //console.log('name is'+name+val);
                        if(!$A.util.isEmpty(name) && name.toUpperCase() == val.toUpperCase()){
                            //console.log('in po filter');
                            filteredPOList.push(curPO);
                        }
                    }
            }
            
        }
        return filteredPOList;
    },
    clearSearch : function(component) {
        component.find("loan_amt").set("v.value",'');//assign value from 0 to '' ,bug 17687
        component.find("src_Val").set("v.value",'');
        component.find("prg_type").set("v.value",'');
        component.find("off_date").set("v.value",'');
        component.find("EmpVal").set("v.value",'');
        
        //employerSearchKeyword
        //$("#filterDivTog").slideToggle();
        //$A.util.toggleClass(component.find("filterDivTog"), "slds-hide");
        $A.util.removeClass(component.find("tableView"), 'slds-show');
        $A.util.addClass(component.find("tableView"), 'slds-hide');
    },
    goBack : function(component) {
        this.clearSearch(component);
        var a = component.get('c.tabSelected');
        $A.enqueueAction(a);
        $A.util.removeClass(component.find("backBtn"), 'slds-show');
        $A.util.addClass(component.find("backBtn"), 'slds-hide');
        $A.util.addClass(component.find("tabSection"), 'slds-show');
        $A.util.removeClass(component.find("tabSection"), 'slds-hide');
    },
    fetchPO : function(component) {
        var action = component.get("c.getPOList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var listPo = JSON.parse(response.getReturnValue());
                //console.log('listPo : '+listPo);
                //console.log('listPo.poList : '+listPo.poList);
                component.set("v.poListInit", listPo.poList);
                component.set("v.isTeleCaller", listPo.isTeleCaller);
                component.set("v.isFieldAgent", listPo.isFieldAgent);
                //console.log('check'+component.get("v.isFieldAgent")+component.get("v.isTeleCaller"));
                console.log('list is>>>'+listPo.poList.length);
                if(!$A.util.isEmpty(component.get("v.poListInit"))){
                    var POList = component.get("v.poListInit");
                    var sortedPOList = component.get("v.poListInit");
                    var sortedPONameList = component.get("v.poListInit");
                    //console.log('po list>>'+POList); 
                    
                    sortedPONameList.sort(function(a, b) {
                        
                        if($A.util.isEmpty(a.Lead_Name__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Lead_Name__c)){
                            return -1;
                        }
                            else if(a.Lead_Name__c === b.Lead_Name__c){
                                return 0;
                            }
                        
                        
                        if(!$A.util.isEmpty(a.Lead_Name__c) && !$A.util.isEmpty( b.Lead_Name__c) ){
                            var textA = a.Lead_Name__c.toUpperCase();
                            var textB = b.Lead_Name__c.toUpperCase();
                            return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
                        }
                        
                    });
                    
                    component.set('v.allpoList',sortedPONameList);
                    
                    //console.log('after sort');
                    //console.log(sortedPONameList);
                    //20939 added  NIList,NEList,NCList removed dispositionList
                    var NIList=[],NEList=[],NCList=[],freshPOlst =[],priorityPOlst =[],followupPOlst =[],followupPOTodayToFuture =[],subPOlst =[],programPOList =[],CibilPOList =[],otherPOList=[],allPolst=[],ccLeadsPOlst = [];//ccLeadsPOlst added for Bug 18623
                    var todaysdate = new Date();
                    var curPOtest = POList[0];
                    //console.log('employer11'+curPOtest['Lead__r']['Employer__r']['Name']);
                    //Bug 18623 Start
                    /*for(var i in sortedPONameList){
                        if(!$A.util.isEmpty(sortedPONameList[i].Product_Offering_Converted__c) && sortedPONameList[i].Product_Offering_Converted__c == false){
                            if((!$A.util.isEmpty(sortedPONameList[i].TeleCalling_Desposition_Status__c)) && sortedPONameList[i].TeleCalling_Desposition_Status__c == 'Transfer to Field')  {
                                //console.log('follow up date inside : '+sortedPONameList[i].TeleCalling_Desposition_Status__c);
                                ccLeadsPOlst.push(sortedPONameList[i]);
                            }
                        }
                    } 
                	component.set('v.ccLeadpoList',ccLeadsPOlst);*/
                    //console.log('ccLeadpoList : '+component.get('v.ccLeadpoList'));
                     //Bug 18623 End
                   
                    for(var i=0;i<POList.length;i++){
                        
                        var today = new Date();
                        var d;
                        var targetDate= new Date();
                            targetDate.setDate(today.getDate() - 30);
                            targetDate.setHours(0);
                            targetDate.setMinutes(0);
                            targetDate.setSeconds(0);
                            console.log('dat is'+targetDate);
                        if(!$A.util.isEmpty(POList[i].Field_In_Time__c))
                        	d = new Date(POList[i].Field_In_Time__c.substring(0, 10)); 
                        //20939 added else
                        else 
                            d ='';
                        console.log('TIKE'+d+POList[i].Name);
                        //20939 added conditions
                        if(((!$A.util.isEmpty(component.get("v.isFieldAgent")) && component.get("v.isFieldAgent") && POList[i].Field_Disposition_1__c != 'Docs Received' && POList[i].TeleCalling_Desposition_Status__c != 'Sale') || (!$A.util.isEmpty(component.get("v.isTeleCaller")) && component.get("v.isTeleCaller") && POList[i].TeleCalling_Desposition_Status__c != 'Sale' && POList[i].Field_Disposition_1__c != 'Docs Received' )) && !$A.util.isEmpty(POList[i].Product_Offering_Converted__c) && POList[i].Product_Offering_Converted__c == false){
                            if(!$A.util.isEmpty(d) && d.getDate() == today.getDate() && d.getYear() == today.getYear() && d.getMonth() == today.getMonth() ){
                                freshPOlst.push(POList[i]);
                            }
                            console.log('freshPOlst'+POList[i].Field_In_Time__c);
                            var fITime = new Date(POList[i].Field_In_Time__c);
                            //20939 added if condition
                            if((component.get("v.isFieldAgent")==true && POList[i].Field_Disposition_1__c != 'Not Interested' &&POList[i].Field_Disposition_1__c != 'Not Contactable' &&POList[i].Field_Disposition_1__c != 'Not Eligible/Rejected' && POList[i].Field_Disposition_1__c != 'Not eligible'  ) ||(component.get("v.isTeleCaller")==true && POList[i].TeleCalling_Desposition_Status__c != 'Not Interested' &&POList[i].TeleCalling_Desposition_Status__c != 'Not Contactable' &&POList[i].TeleCalling_Desposition_Status__c != 'Not Eligible/Rejected')){
                                if(d <= today && d > targetDate){//changed for bug id 25040/22018
                                    if(!$A.util.isEmpty(POList[i].Program_Type__c) && (POList[i].Program_Type__c).toUpperCase() == 'PRE-APPROVED'){
                                        programPOList.push(POList[i]);
                                    }
                                    else if(!$A.util.isEmpty(POList[i].Product_Offering_Source__c) &&  (POList[i].Product_Offering_Source__c).toUpperCase()  == 'CIBIL 2'){
                                        CibilPOList.push(POList[i]);
                                    }
                                        else{
                                            otherPOList.push(POList[i]);
                                        }
                                }
                            }
                            if(component.get("v.isFieldAgent")==true){
                                if(POList[i].Field_Disposition_1__c == 'Not Interested' ||POList[i].Field_Disposition_1__c == 'Not Contactable' ||POList[i].Field_Disposition_1__c == 'Not Eligible/Rejected' )
                                {
                                     var today= new Date().getDate();
                                    //console.log(today);
                                    if(1<=today && today<=5)
                                    {
                                        var now_month=new Date().getMonth();
                                        var fromDate=now_month-1;
                                        var toDate= now_month;
                                        var now_year=new Date().getFullYear();
                                        var start = new Date(now_year, fromDate,5, 0, 0, 0, 0);
                                        var stop = new Date(now_year, toDate,4, 0, 0, 0, 0);
                                        //console.log('start Date'+start);
                                        //console.log('stop date '+stop );
										//changed for bug id 25040 / 22018 start
                                        var orgdate;
                                        if(!$A.util.isEmpty(POList[i].First_Field_Desposition_Status__c))
                                        	orgdate = new Date(POList[i].First_Field_Desposition_Status__c.substring(0, 10)); 
                                        else
                                            orgdate = '';
										//changed for bug id 25040  / 22018 stop
                                       // alert('test dates'+orgdate+start+stop);
                                        //console.log('org date'+new Date( POList[i].First_Field_Desposition_Status__c));
                                        if(  start <= orgdate && orgdate<=stop )
                                        {
                                            /*20939 s*/
                                            if(POList[i].Field_Disposition_1__c == 'Not Interested')
                                            	NIList.push(POList[i]);
                                            else if(POList[i].Field_Disposition_1__c == 'Not Contactable')
                                            	NCList.push(POList[i]); 
                                            else if(POList[i].Field_Disposition_1__c == 'Not Eligible/Rejected' || POList[i].Field_Disposition_1__c == 'Not eligible')
                                            	NEList.push(POList[i]); 
                                            /*20939 e*/
                                        }
                                    }
                                    if(6<=today && today<=31)
                                    {
                                        var now_month=new Date().getMonth();	
                                        var fromDate=now_month;
                                        var toDate= now_month+1;
                                        var now_year=new Date().getFullYear();
                                        var start = new Date(now_year, fromDate,5, 0, 0, 0, 0);
                                        var stop = new Date(now_year, toDate,4, 0, 0, 0, 0);
                                        //console.log('start Date'+start);
                                        //console.log('stop date '+stop );
											//changed for bug id 25040  / 22018 start
                                        if(!$A.util.isEmpty(POList[i].First_Field_Desposition_Status__c))
                                        	orgdate = new Date(POList[i].First_Field_Desposition_Status__c.substring(0, 10)); 
                                        else
                                            orgdate = '';//console.log('org date'+new Date( POList[i].First_Field_Desposition_Status__c));
                                       	//changed for bug id 25040  / 22018 stop
										 if(  start <= orgdate && orgdate<=stop )
                                        {
                                            /*20939 s*/
                                            if(POList[i].Field_Disposition_1__c == 'Not Interested')
                                                NIList.push(POList[i]);
                                            else if(POList[i].Field_Disposition_1__c == 'Not Contactable')
                                                NCList.push(POList[i]); 
                                            else if(POList[i].Field_Disposition_1__c == 'Not Eligible/Rejected' || POList[i].Field_Disposition_1__c == 'Not eligible')
                                                NEList.push(POList[i]); 
                                            /*20939 e*/
                                        }
                                    }
                                }
                            }
                            if(component.get("v.isTeleCaller")==true){
                                if(POList[i].TeleCalling_Desposition_Status__c == 'Not Interested' ||POList[i].TeleCalling_Desposition_Status__c == 'Not Contactable' ||POList[i].TeleCalling_Desposition_Status__c == 'Not Eligible/Rejected' )
                                {
									 var today= new Date().getDate();
                                    if(1<=today && today<=5)
                                    {
                                        var now_month=new Date().getMonth();
                                        var fromDate=now_month-1;
                                        var toDate= now_month;
                                        var now_year=new Date().getFullYear();
                                        var start = new Date(now_year, fromDate,5, 0, 0, 0, 0);
                                        var stop = new Date(now_year, toDate,4, 0, 0, 0, 0);
                                        //console.log('start Date'+start);
                                        //console.log('stop date '+stop );
                                        var orgdate;
                                        if(!$A.util.isEmpty(POList[i].First_TeleCalling_Desposition_Status__c))
                                        	orgdate = new Date(POList[i].First_TeleCalling_Desposition_Status__c.substring(0, 10)); 
                                        else
                                            orgdate = '';
                                        //var orgdate=new Date( POList[i].First_TeleCalling_Desposition_Status__c	);
                                        //console.log('org date'+new Date( POList[i].First_TeleCalling_Desposition_Status__c	));
                                        if(  start <= orgdate && orgdate<=stop )
                                        {
                                            /*20939 s*/
                                            if(POList[i].TeleCalling_Desposition_Status__c == 'Not Interested')
                                            	NIList.push(POList[i]);
                                            else if(POList[i].TeleCalling_Desposition_Status__c == 'Not Contactable')
                                            	NCList.push(POList[i]); 
                                            else if(POList[i].TeleCalling_Desposition_Status__c == 'Not Eligible/Rejected')
                                            	NEList.push(POList[i]); 
                                            /*20939 e*/
                                        }
                                    }
                                    if(6<=today && today<=31)
                                    {
                                        var now_month=new Date().getMonth();	
                                        var fromDate=now_month;
                                        var toDate= now_month+1;
                                        var now_year=new Date().getFullYear();
                                        var start = new Date(now_year, fromDate,5, 0, 0, 0, 0);
                                        var stop = new Date(now_year, toDate,4, 0, 0, 0, 0);
                                        //console.log('start Date'+start);
                                        //console.log('stop date '+stop );
                                        var orgdate;
                                        if(!$A.util.isEmpty(POList[i].First_TeleCalling_Desposition_Status__c))
                                        	orgdate = new Date(POList[i].First_TeleCalling_Desposition_Status__c.substring(0, 10)); 
                                        else
                                            orgdate = '';
                                        //console.log('org date'+new Date( POList[i].First_TeleCalling_Desposition_Status__c	));
                                        if(  start <= orgdate && orgdate<=stop )
                                        {
                                            /*20939 s*/
                                            if(POList[i].TeleCalling_Desposition_Status__c == 'Not Interested')
                                            	NIList.push(POList[i]);
                                            else if(POList[i].TeleCalling_Desposition_Status__c == 'Not Contactable')
                                            	NCList.push(POList[i]); 
                                            else if(POList[i].TeleCalling_Desposition_Status__c == 'Not Eligible/Rejected')
                                            	NEList.push(POList[i]); 
                                            /*20939 e*/
                                        }
                                    }                                
                                }
                            }
                            
                            
                        }
                        /*if(!$A.util.isEmpty(POList[i].Product_Offering_Converted__c) && POList[i].Product_Offering_Converted__c == true){
                            subPOlst.push(POList[i]);
                        }*/
      var date = new Date(POList[i].Follow_Up_Date__c);
      var mnth = ("0" + (date.getMonth()+1)).slice(-2);
      var day  = ("0" + date.getDate()).slice(-2);
      var convertedFollowDate= [ date.getFullYear(), mnth, day ].join("-");
      var date1 = new Date();
      var mnth1 = ("0" + (date1.getMonth()+1)).slice(-2);
      var day1  = ("0" + date1.getDate()).slice(-2);
      var convertedToday= [ date1.getFullYear(), mnth1, day1 ].join("-");
                        
                        //alert(pppp);
                         var today = new Date();
                         console.log('today: '+today.getTime());
                        var followDate= new Date(POList[i].Follow_Up_Date__c); //981
                        if(!$A.util.isEmpty(followDate))
                        console.log('follow up date inside : '+followDate.getTime());
						if(!$A.util.isEmpty(POList[i].Product_Offering_Converted__c) && POList[i].Product_Offering_Converted__c == false){
                       if((convertedFollowDate >= convertedToday) && ((!$A.util.isEmpty(POList[i].TeleCalling_Desposition_Status__c) && component.get("v.isTeleCaller") && (POList[i].TeleCalling_Desposition_Status__c).toUpperCase() == 'FOLLOW UP') || (!$A.util.isEmpty(POList[i].Field_Disposition_1__c) && component.get("v.isFieldAgent") && (POList[i].Field_Disposition_1__c).toUpperCase() == 'FOLLOWUP'))){
                                followupPOTodayToFuture.push(POList[i]);
                            }
                            if((!$A.util.isEmpty(POList[i].TeleCalling_Desposition_Status__c) && component.get("v.isTeleCaller") && (POList[i].TeleCalling_Desposition_Status__c).toUpperCase() == 'FOLLOW UP') || (!$A.util.isEmpty(POList[i].Field_Disposition_1__c) && component.get("v.isFieldAgent") && (POList[i].Field_Disposition_1__c).toUpperCase() == 'FOLLOWUP')){
                                //console.log('follow up date inside : '+sortedPOList[i].Follow_Up_Date__c);
                                followupPOlst.push(POList[i]);
                            }
                        }
                    }

                    freshPOlst.sort(function(a, b) {
                       
                        if($A.util.isEmpty(a.Field_In_Time__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Field_In_Time__c)){
                            return -1;
                        }
                        return (a.Field_In_Time__c < b.Field_In_Time__c) ? 1 : (a.Field_In_Time__c > b.Field_In_Time__c) ? -1 : 0;
                        
                    }); 
                    //Bug 17810 Start
                    followupPOlst.sort(function(a, b) {
                       
                        if($A.util.isEmpty(a.Follow_Up_Date__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Follow_Up_Date__c)){
                            return -1;
                        }
                        return (a.Follow_Up_Date__c < b.Follow_Up_Date__c) ? -1 : (a.Follow_Up_Date__c > b.Follow_Up_Date__c) ? 1 : 0;
                        
                    }); 
 followupPOTodayToFuture.sort(function(a, b) {
                       
                        if($A.util.isEmpty(a.Follow_Up_Date__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Follow_Up_Date__c)){
                            return -1;
                        }
                        return (a.Follow_Up_Date__c < b.Follow_Up_Date__c) ? -1 : (a.Follow_Up_Date__c > b.Follow_Up_Date__c) ? 1 : 0;
                        
                    }); 
                    //Bug 17810 End
                    
                    //console.log('--------------');
                    //console.log(followupPOlst);
                    if(!$A.util.isEmpty(followupPOlst)){
                        component.set('v.flwuppoList',followupPOlst);
                    } 
                     if(!$A.util.isEmpty(followupPOTodayToFuture)){
                        component.set('v.followupPOTodayToFuture',followupPOTodayToFuture);
                    }
                   //console.log('--------------');
                    //console.log(component.get('v.flwuppoList'));
                    
                    /*console.log('priorityview>>'+listPo.priorityView);
                    console.log('programPOList'+programPOList.length);
                    console.log('CibilPOList'+CibilPOList.length);
                    console.log('otherPOList'+otherPOList.length);
                    console.log('Desp list ['+JSON.stringify(dispositionList));
                                        console.log('Desp list END');*/
                    programPOList.sort(function(a, b) {
                        
                        if($A.util.isEmpty(a.Field_In_Time__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Field_In_Time__c)){
                            return -1;
                        }
                        return (a.Field_In_Time__c < b.Field_In_Time__c) ? -1 : (a.Field_In_Time__c > b.Field_In_Time__c) ? 1 : 0;
                        
                    }); 
                    CibilPOList.sort(function(a, b) {
                        
                        if($A.util.isEmpty(a.Field_In_Time__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Field_In_Time__c)){
                            return -1;
                        }
                        return (a.Field_In_Time__c < b.Field_In_Time__c) ? -1 : (a.Field_In_Time__c > b.Field_In_Time__c) ? 1 : 0;
                        
                    }); 
                    otherPOList.sort(function(a, b) {
                        
                        if($A.util.isEmpty(a.Field_In_Time__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Field_In_Time__c)){
                            return -1;
                        }
                        return (a.Field_In_Time__c < b.Field_In_Time__c) ? -1 : (a.Field_In_Time__c > b.Field_In_Time__c) ? 1 : 0;
                        
                    });        
                    /*20939 s*/
                    NCList.sort(function(a, b) {
                        
                        if($A.util.isEmpty(a.Field_In_Time__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Field_In_Time__c)){
                            return -1;
                        }
                        return (a.Field_In_Time__c < b.Field_In_Time__c) ? -1 : (a.Field_In_Time__c > b.Field_In_Time__c) ? 1 : 0;
                        
                    });   
                    NEList.sort(function(a, b) {
                        
                        if($A.util.isEmpty(a.Field_In_Time__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Field_In_Time__c)){
                            return -1;
                        }
                        return (a.Field_In_Time__c < b.Field_In_Time__c) ? -1 : (a.Field_In_Time__c > b.Field_In_Time__c) ? 1 : 0;
                        
                    });     
                    NIList.sort(function(a, b) {
                        
                        if($A.util.isEmpty(a.Field_In_Time__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Field_In_Time__c)){
                            return -1;
                        }
                        return (a.Field_In_Time__c < b.Field_In_Time__c) ? -1 : (a.Field_In_Time__c > b.Field_In_Time__c) ? 1 : 0;
                        
                    });  
                    console.log('NIList'+NIList.length);
                    /*20939 e*/
  /*azure981*/
                    console.log('CIBI  '+CibilPOList);
                     if(!$A.util.isEmpty(CibilPOList)){
							component.set('v.CibilPO_Priority',CibilPOList);
                        } 
                      if(!$A.util.isEmpty(programPOList)){
							component.set('v.ProgramType_Priority',programPOList);
                        } 
                         if(!$A.util.isEmpty(otherPOList)){
							component.set('v.OthersPriority',otherPOList);
                        }
                    
                    if(!$A.util.isEmpty(listPo.priorityView) && listPo.priorityView == 'Product_Offering_Source__c' ){
                        if(!$A.util.isEmpty(CibilPOList)){
                            priorityPOlst.push.apply(priorityPOlst, CibilPOList);
                        } 
                        if(!$A.util.isEmpty(programPOList)){
                            priorityPOlst.push.apply(priorityPOlst, programPOList);
                        }
                    }
                    if( (!$A.util.isEmpty(listPo.priorityView) &&  listPo.priorityView == 'Program_Type__c') ||  $A.util.isEmpty(listPo.priorityView) ){
                        if(!$A.util.isEmpty(programPOList)){
                            priorityPOlst.push.apply(priorityPOlst, programPOList);
                        }
                        if(!$A.util.isEmpty(CibilPOList)){
                            priorityPOlst.push.apply(priorityPOlst, CibilPOList);
                        }     
                    }
					//console.log('loop is iterated for'+count+' times');                    
                    if(!$A.util.isEmpty(otherPOList)){
                        //  priorityPOlst.push(otherPOList);
                        priorityPOlst.push.apply(priorityPOlst, otherPOList);
                    }   
                    if(!$A.util.isEmpty(priorityPOlst)){
                        component.set('v.prioritypoList',priorityPOlst);
                    }   
                    /*Bug 20939 s*/
                    if(!$A.util.isEmpty(NEList)){
                        component.set('v.notEligibleList',NEList);
                    }  
                    if(!$A.util.isEmpty(NCList)){
                        component.set('v.notContactList',NCList);
                    }  
                    if(!$A.util.isEmpty(NIList)){
                        component.set('v.notInterestedList',NIList);
                    }  
                    /*Bug 20939 e*/
                    /*if(!$A.util.isEmpty(subPOlst)){
                        subPOlst.sort(function(a, b) {
                       
                        if($A.util.isEmpty(a.Converted_Date_Time__c)){
                            return 1;
                        }
                        else if($A.util.isEmpty(b.Converted_Date_Time__c)){
                            return -1;
                        }
                        return (a.Converted_Date_Time__c < b.Converted_Date_Time__c) ? 1 : (a.Converted_Date_Time__c > b.Converted_Date_Time__c) ? -1 : 0;
                        
                    }); 
                        component.set('v.subpoList',subPOlst);
                    } */
                    /*console.log('priorityPOlst'+priorityPOlst.length);
                    console.log('priiiiiiiiiiii');
                    console.log(component.get('v.prioritypoList'));*/
                    if(!$A.util.isEmpty(freshPOlst)){
                        //alert('freshPOlst>>>');
                        //console.log(freshPOlst);
                        component.set('v.freshpoList',freshPOlst);
                        
                    }
                    component.set('v.onload',false);
                    /* Adhoc s*/
                    var tabID=component.get("v.view");
                    component.set("v.selTabId",tabID);
                    if(tabID == 'fresh'){
                        component.set("v.lstPo",component.get('v.freshpoList'));
                    }
                    else if(tabID == 'priority'){
                        component.set("v.lstPo",component.get('v.prioritypoList')); 
                    } 
                    else if(tabID == 'submitted'){
                        component.set("v.lstPo",component.get('v.subpoList'));
                    }
                    else if(tabID ==  'followUp'){
                         component.set("v.lstPo",component.get('v.flwuppoList'));    
                    } 
                    else if(tabID ==  'disposition'){
                         component.set("v.lstPo",component.get('v.dispositionList'));    
                    } 
                    /*Bug 18623 start*/
                    else if(tabID ==  'ccLead'){
                         component.set("v.lstPo",component.get('v.ccLeadpoList'));    
                    }
                    /*Bug 18623 end*/
                    else if(tabID ==  'all'){
                         component.set("v.lstPo",component.get('v.allpoList'));    
                    }
                    
                    /* Adhoc e*/
                    
                    $A.createComponent(
                        "c:SAL_POListViewTable",
                        {
                            // "loggedInuser" :component.get("v.loggedInuser"),
                            // "DMAId" : component.get("v.DMAId"),
                            // "oppType":component.get('v.oppType'),
                            "lstPo" : component.get("v.lstPo"),
                            "aura:id": "childcmp"
                            
                        },
                        function(newComponent){
                            component.set("v.body",newComponent);
                        }
                    );
                    this.showhidespinner(component,event,false);
                    //console.log('onloadddd createcmp'+component.get("v.onload"));
                }
                //Else part added for Bug 17650 Start
                else
                {
                    $A.createComponent(
                        "c:SAL_POListViewTable",
                        {
                            "lstPo" : component.get("v.freshpoList"),
                            "aura:id": "childcmp"
                        },
                        function(newComponent){
                            component.set("v.body",newComponent);
                        }
                    );
                    this.showhidespinner(component,event,false);
                }
                //Else part added for Bug 17650 End
            }
            else {
                this.showhidespinner(component,event,false);
                //console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    showhidespinner:function(component, event, showhide){
        console.log('in show hide spinner');
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
    
     /*bug 18539 start*/
    startSearch: function (component, key) {
		var keyword = component.get("v." + key + "SearchKeyword");
		console.log("keyword" + keyword);
		if (keyword.length > 2 && !component.get('v.searching')) {
			component.set('v.searching', true);
			component.set('v.oldSearchKeyword', keyword);
			this.searchHelper(component, key, keyword);
		} else if (keyword.length <= 2) {
			component.set("v." + key + "List", null);
			this.openCloseSearchResults(component, key, false);
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
    handleSearchResult: function (component, key, result) {
		console.log('key : ' + key)
		console.log('v.oldSearchKeyword :' + component.get('v.oldSearchKeyword') + '  -> SearchKeyword : ' + component.get("v." + key + "SearchKeyword"));
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
    showHideMessage: function (component, key, show) {
		component.set("v.message", show ? 'No Result Found...' : '');
		this.showHideDiv(component, key + "Message", show);
	},
    showHideDiv: function (component, divId, show) {
		//console.log('divId>>' + divId + '  ' + show);
		$A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
		$A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");

	},
    openCloseSearchResults: function (component, key, open) {
		var resultPanel = component.find(key + "SearchResult");
		$A.util.addClass(resultPanel, open ? 'slds-is-open' : 'slds-is-close');
		$A.util.removeClass(resultPanel, open ? 'slds-is-close' : 'slds-is-open');
	},
    toCamelCase: function (str) {
		return str[0].toUpperCase() + str.substring(1);
	},
    executeApex: function (component, method, params, callback) {
		var action = component.get("c." + method);
		action.setParams(params);
		console.log('calling method' + method);
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log('response.getReturnValue()' + JSON.stringify(response.getReturnValue()));
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
				this.showToast(component, "Error!", errors.join(", "), "error");
				callback.call(this, errors, response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	}
     /*bug 18539 start*/
})