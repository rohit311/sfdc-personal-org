({
     AddtionalMsg:'',
    fetchData : function(component, event) {
        var repObjList = ["Repayment_Mode__c","A_C_Type__c","Open_ECS_Facility__c"];
        var selectListNameMap = {};
        selectListNameMap["RePayment_mode_detail__c"] = repObjList;
        this.showhidespinner(component,event,true);
        this.executeApex(component, "fetchRepaymentObject", {//22017
            "repayId": component.get("v.repayId"),
            "objectFieldJSON":JSON.stringify(selectListNameMap),
            "oppId":component.get("v.loanId"),
            "PrimaryAppId":component.get("v.primaryAppId")
        }, function (error, result) {
            
            if (!error && result) {
                var result = JSON.parse(result);
                var picklistFields = result.picklistData;
                var repPickFlds = picklistFields["RePayment_mode_detail__c"];
                component.set("v.repModeList", repPickFlds["Repayment_Mode__c"]);
                component.set("v.accTypeList", repPickFlds["A_C_Type__c"]);
                component.set("v.openEcsList", repPickFlds["Open_ECS_Facility__c"]);
                if(result.status == 'Fail'){
                    if($A.util.isEmpty(component.get("v.repay.Id"))){
                        
                        var disbList = component.get("v.disbList");
                        //Bug:23402**S**
                        var favouring = '';
                        for(var i=0;i<disbList.length;i++){
                            if(disbList[i].isTopUp__c == false){
                              favouring = disbList[i].Favouring__c;
                               break;
                            }
                        }
                        result.repObj.Account_Holder_Name__c = favouring;
                        result.repObj.PDC_By_Name__c = favouring;
                        //Bug:23402 **E**
                        component.set("v.repay",result.repObj);
                        //22017 start
                        component.set("v.oldrepay",result.repObj);
                        component.set("v.bankObj",result.bankObj);
                        //22017 end
                        component.find('repay_mode').set('v.value','ECS');
                        component.find('ecs_facility').set('v.value','Yes');
                        component.set("v.disableECSFields",true); //by default 
                        this.selectRepay(component, event);
                        
                    }
                    this.showhidespinner(component,event,false);
                }
                else{
                    component.set("v.repay",result.repObj);
                    //22017 start
                    component.set("v.oldrepay",result.repObj);
                    component.set("v.bankObj",result.bankObj);
                    //22017 end
                    component.find('micr_code').set('v.value',component.get('v.repay.MICR_Code__c'));
                    component.find('repay_mode').set('v.value', component.get("v.repay.Repayment_Mode__c"));
                    
                    component.find('ac_type').set('v.value', component.get("v.repay.A_C_Type__c"));
                    component.find('ecs_facility').set('v.value', component.get("v.repay.Open_ECS_Facility__c"));
                    
                    var data=result.repObj;
                    if(!$A.util.isEmpty(data.Mandate_Process_Stage__c) && data.Mandate_Process_Stage__c=='In Progress')
                    {
                        component.find("saveButton").set("v.disabled",true);
                    }
                    this.selectRepay(component,event);
                    this.showhidespinner(component,event,false);
                }
                //22017 start
                if(!$A.util.isEmpty(result.bankObj))
                {
                    component.set("v.disablecopyperfios",false);
                }
                var bankobj = component.get("v.bankObj");
 if(!$A.util.isEmpty(result.bankObj) && (!result.bankObj.Perfios_account_same_as_Salary_account__c))  //24315 added condition 
                {                   // alert('alert2');

                    console.log('pk');
                    component.set("v.disablecopyperfios",false);
                }
                if(!$A.util.isEmpty(result.bankObj) && (result.bankObj.Perfios_account_same_as_Salary_account__c == true))  {//24315 added condition 
                    component.find("acc_no").set("v.disabled",true);
                    
                }
                var repayobj =  component.get("v.repay");
                if(component.get("v.repay.Copy_Perfios_Details__c") && !$A.util.isEmpty(bankobj) && !$A.util.isEmpty(repayobj))
                {
                    if(!$A.util.isEmpty(bankobj.IFSC_Code__c) && !$A.util.isEmpty(repayobj.IFSC_Code__c) && bankobj.IFSC_Code__c == repayobj.IFSC_Code__c){
                        component.find("ifsc_code").set("v.disabled",true);
                    }
                    if(!$A.util.isEmpty(bankobj.MICR_Code__c) && !$A.util.isEmpty(repayobj.MICR_Code__c) && bankobj.MICR_Code__c == repayobj.MICR_Code__c){
                        component.find("micr_code").set("v.disabled",true);
                    }
                    if(!$A.util.isEmpty(bankobj.Perfios_Account_Holder_Name__c) && !$A.util.isEmpty(repayobj.Account_Holder_Name__c) && bankobj.Perfios_Account_Holder_Name__c == repayobj.Account_Holder_Name__c){
                        component.find("acc_holder").set("v.disabled",true);
                    }
                    if(!$A.util.isEmpty(bankobj.Perfios_Bank_Name__c) && !$A.util.isEmpty(repayobj.Bank_Name__c) && bankobj.Perfios_Bank_Name__c == repayobj.Bank_Name__c){
                       // component.find("bank_name").set("v.disabled",true);//added for prod adhoc 23631
                    }
                    if(!$A.util.isEmpty(bankobj.Perfios_Account_No__c) && !$A.util.isEmpty(repayobj.A_C_NO__c) && bankobj.Perfios_Account_No__c == repayobj.A_C_NO__c){
                        component.find("acc_no").set("v.disabled",true);
                    }
                    if(!$A.util.isEmpty(bankobj.Account_Type__c) && !$A.util.isEmpty(repayobj.A_C_Type__c) && bankobj.Account_Type__c == repayobj.A_C_Type__c){
                        component.find("ac_type").set("v.disabled",true);
                    }
                }
                //22017 end
            }
        });
        //component.find('loan_app_field').set('v.value', component.get("v.loanId"));
        
        // added by priyanka for ECS barcode validation -- start
        this.executeApex(component, "getNachDef", {
            "oppId": component.get("v.loanId")
        }, function (error, result) {
            
            if(result == 'success'){
                component.set("v.mandatoryECSBarcode",true);
                
            }
            else{
                
                component.set("v.mandatoryECSBarcode",false);  
              
                
            }
        });
        
        // added by priyanka for ECS barcode validation -- end
    },
    selectRepay : function(component, event){
        component.find("ecs_facility").set("v.disabled",false);//added for 22017
        $("#openValidError").html("");
        $("#bankBranchError").html("");
        $("#pdcNameError").html("");
        $("#pdcNameError").html("");
        $("#ecsAmtError").html("");
        $("#ecsEndError").html("");
        $("#startDateError").html("");
        $("#maxLimitError").html("");
        $("#openECSError").html("");
        $("#bankNameError").html("");
        $("#acTypeError").html("");
        $("#acNoError").html("");
        $("#accHolderError").html("");
        $("#micrError").html("");
        $("#ifscError").html("");
        $("#repayError").html("");
        $("#ECSBarError").html("");
        $("#chqFrom").html("");
        $("#chqTo").html("");
        $("#noChq").html("");
        if(component.find('repay_mode').get("v.value") == 'Security Cheque'){
           	component.find('chq_frm').set("v.required",true); 
            component.find('chq_to').set("v.required",true); 
            component.find('no_chq').set("v.required",true); 
            component.find('ECS_maxLimit').set("v.required",false); 
            component.find('ECS_startDate').set("v.required",false); 
            component.find('ECS_endDate').set("v.required",false); 
            component.find('ECS_amount').set("v.required",false); 
            component.find('open_valid').set("v.required",false); 
            component.find('bank_branch').set("v.required",false); 
            component.find('ecs_barcode').set("v.required",true); 
            component.find('pdcname').set("v.required",true); 
            component.find('umrn').set("v.required",false); 
            component.set("v.disableChq",false);
            component.set("v.disableECSFields",true);
             component.set("v.disableSIFields",false);
            component.set("v.disablecsbarFields",true);
            //Bug:22501**S**
           if(component.get("v.isDisbDashboard") == true){
            	component.find('chq_frm').set("v.required",false);
            	component.find('chq_to').set("v.required",false);
            	component.find('no_chq').set("v.required",false);
                component.find('ecs_barcode').set("v.required",false);
            	component.set("v.disableECSFields",false);
                component.set("v.disablecsbarFields",false); 
            	component.find('cheque_serial_numbers').set("v.required",true);
            	component.find('cheque_date').set("v.required",true);
            	component.find('bank_name').set("v.required",false);
            	component.find('ifsc_code').set("v.required",false);
            	component.find('micr_code').set("v.required",false);
            	component.find('ecs_facility').set("v.required",false);
            	component.find('ecs_ex_cust').set("v.required",false);
            }
            //Bug:22501**E**
        }
        else if(component.find('repay_mode').get("v.value") == 'ECS'){
            component.find('chq_frm').set("v.required",false); 
            component.find('chq_to').set("v.required",false); 
            component.find('no_chq').set("v.required",false); 
            component.find('pdcname').set("v.required",true); 
            component.find('ECS_maxLimit').set("v.required",true); 
            component.find('ECS_startDate').set("v.required",true); 
            component.find('ECS_endDate').set("v.required",true); 
            component.find('ECS_amount').set("v.required",true); 
            component.find('open_valid').set("v.required",false); 
            component.find('bank_branch').set("v.required",false); 
             component.set("v.disablecsbarFields",false);
            component.set("v.disableChq",true);
            component.find('cheque_serial_numbers').set("v.required",false); //22501
            component.find('cheque_date').set("v.required",false); //22501
           
            //Added by swapnil
            if(component.find('ecs_facility').get("v.value") == 'Existing'){
                component.find('ecs_barcode').set("v.required",false); 
                component.set("v.mandatoryECSBarcode",false);
             
            }
            else
            {
                component.find('ecs_barcode').set("v.required",true); 
                component.set("v.mandatoryECSBarcode",true);
            }  
            component.set("v.disableECSFields",false);
            component.set("v.disableSIFields",false);
        }
       
        
        // added by priyanka for SI repayment mode validation -- start
            else if(component.find('repay_mode').get("v.value") == 'SI'){
                component.find('chq_frm').set("v.required",false); 
                component.find('chq_to').set("v.required",false); 
                component.find('no_chq').set("v.required",false); 
                component.set("v.disableChq",true);
                component.find("ecs_facility").set("v.disabled",true);//added for 22017
                component.find('umrn').set("v.required",false); 
                component.find('open_valid').set("v.required",true); 
                component.find('pdcname').set("v.required",true); 
                component.find('ECS_maxLimit').set("v.required",true); 
                component.find('ECS_startDate').set("v.required",true); 
                component.find('ECS_endDate').set("v.required",true); 
                component.find('ECS_amount').set("v.required",true);
                component.find('bank_name').set("v.required",true);
                component.find('bank_branch').set("v.required",true);
                component.set("v.disablecsbarFields",false);
                component.find('cheque_serial_numbers').set("v.required",false); //22501
            	component.find('cheque_date').set("v.required",false); //22501
                //Added by swapnil
                
                if(component.find('ecs_facility').get("v.value") == 'Yes' || component.find('ecs_facility').get("v.value") == 'Existing'){ //Bug 22928 Added check for Open ECS facility Existing as well
                    component.find('ecs_barcode').set("v.required",false);
                    component.set("v.mandatoryECSBarcode",false);
                }
                component.set("v.disableSIFields",true);
                component.set("v.disableECSFields",false);
            }
                else{
                    component.find('chq_frm').set("v.required",false);
                    component.find('chq_to').set("v.required",false);
                    component.find('no_chq').set("v.required",false);
                    component.find('ECS_maxLimit').set("v.required",false);
                    component.find('ECS_startDate').set("v.required",false);
                    component.find('ECS_endDate').set("v.required",false);
                    component.find('ECS_amount').set("v.required",false);
                    component.find('open_valid').set("v.required",false);
                    component.find('bank_branch').set("v.required",false);
                    component.find('pdcname').set("v.required",true);
                    component.find('umrn').set("v.required",false);
                    component.set("v.disableChq",true);
                    component.set("v.disableECSFields",true);
                    component.find('ecs_barcode').set("v.required",true); 
                    component.set("v.mandatoryECSBarcode",true);
                    component.set("v.disableSIFields",false);
                     component.set("v.disablecsbarFields",false);
                    component.find('cheque_serial_numbers').set("v.required",false); //22501
            		component.find('cheque_date').set("v.required",false); //22501
                }
        // added by priyanka for SI repayment mode validation -- end
    },
    // added by priyanka for ECS barcode validation -- start
    checkDuplicateBarcode : function(component, event) {
        var ecs_barcode_number=component.find("ecs_barcode").get("v.value");
        
        this.executeApex(component, "checkDuplicateLan", {
            "oppId" : component.get("v.loanId"),
            "currentBarcode":component.find("ecs_barcode").get("v.value")
        }, function (error, result) {
            
            if (!error && result) {
                if(result!= 'fail'){
                    var duplicates=[];
                    duplicates = result.split('\n');
                    var dups=[];
                    dups=duplicates[1].split('=');
                    var returnedBarCode=dups[1];
                    
                    if(returnedBarCode!=null && ecs_barcode_number!=null && returnedBarCode.trim()==ecs_barcode_number.trim()){
                        this.displayToastMessage(component,event,'Error',result,'error');
                        this.showhidespinner(component,event,false);
                    }
                    
                }               
            }
        });
    },
    // added by priyanka for ECS barcode validation -- end
    saveRepay : function(component, event) {
        this.showhidespinner(component,event,true);
        var error = false;
        // added by priyanka for ECS barcode validation -- start
        var ecs_error=false;
        var messege;
        var total=0;
        var ecs_barcode_number=component.find("ecs_barcode").get("v.value");
        var flag= component.get("v.mandatoryECSBarcode");
        var bankName=component.find("bank_name").get("v.value"); //CR added by swapnil 25021 
        //Bug:22501**S**
        var sec_cheque_error = false;
        var chequeSerialNumbers = component.find("cheque_serial_numbers").get("v.value");
        console.log('Cheque serial Numbers***'+chequeSerialNumbers);
        var count=0;
        if(chequeSerialNumbers){
            var count=0;
                    var chequeNumberRegex1 =new RegExp("^[a-zA-Z0-9,]+$");
                    if(chequeNumberRegex1.test(chequeSerialNumbers)==false){
                            count++;
                    }
                    else{
                        var temp = chequeSerialNumbers.split(',');
                        var chequeNumberRegex =new RegExp("^[a-z A-Z 0-9]");
                        for(var x=0;x<temp.length;x++){
                            if(temp[x]==' ' || temp[x]=='' || temp[x]==null || chequeNumberRegex.test(temp[x])==false){
                                count++;
                            }
                        }
                    }
            if(count>0){
            messege='Enter correct value for Cheque Serial Numbers';
            sec_cheque_error = true;
            }
        }
        //Bug:22501**E**
        if(flag==true && ecs_barcode_number==null )
        {   
            messege="Since Document Value is Nach Deferral, So the Barcode Number can be Blank";
            this.displayToastMessage(component,event,'Success',messege,'success');
            this.showhidespinner(component,event,false);
        } 
        else if(ecs_barcode_number != null && flag==true)
        {
            if(ecs_barcode_number.length != null && ecs_barcode_number.length !=10)
            {
                $("#ECSBarError").css({"color": "red"});
                messege='Enter the correct Barcode No...Length must be 10 character';
                ecs_error = true;
            }
            else
            {
                if(ecs_barcode_number.includes(" "))
                {
                    $("#ECSBarError").css({"color": "red"});
                    messege='Barcode number must not include white spaces';
                    ecs_error = true;
                }  
                else
                {
                    var Regex1 =    new RegExp("^[0-9]{8}");
                    if(Regex1.test(ecs_barcode_number.substr(0,8))==false)
                    {
                        $("#ECSBarError").css({"color": "red"});
                        messege='Enter correct value for barcode no...First 9 characters must be Numbers';
                        ecs_error = true;
                    }
                    
                    else
                    {
                        var Regex2 = new RegExp("^[A-Z 0-9 ! @ # $ / ^ % &]");
                        if(Regex2.test(ecs_barcode_number.substr(9,1))==false)
                        {
                            messege='Enter correct value for barcode no. Last Character must be either alphanumeric in upper case or contain one of the special characters(!, @, #, $, /, ^, %, &)';
                            ecs_error = true;
                            $("#ECSBarError").css({"color": "red"});
                        } 
                        else
                        {
                            for(var j=0;j<9;j++)
                            {
                                
                                total += parseInt(ecs_barcode_number.substr(j,1));
                            }
                            var checkSumMaster = {"0":"0","1":"1","2":"2","3":"3","4":"4","5":"5","6":"6","7":"7","8":"8","9":"9","10":"A","11":"B","12":"C","13":"D","14":"E","15":"F","16":"G","17":"H","18":"I","19":"J","20":"K","21":"L","22":"M","23":"N","24":"O","25":"P","26":"Q","27":"R","28":"S","29":"T","30":"U","31":"V","32":"W","33":"X","34":"Y","35":"Z","36":"!","37":"@","38":"#","39":"$","40":"/","41":"^","42":"%" };
                            var modValue = total % 43;
                            if((ecs_barcode_number.substr(9,1))!=checkSumMaster[modValue])
                            {
                                messege='The entered barcode number have wrong checksum bit'; 
                                ecs_error = true;
                                $("#ECSBarError").css({"color": "red"});
                            }  
                            
                        }
                    }
                }
            }   
            
        }/*CR added by swapnil 25021 s */else if(!$A.util.isEmpty(bankName)){
            if(bankName.length > 24){
                messege='Enter Bank name with length of 24 characters or less'; 
                ecs_error = true;
                $("#bankNameError").css({"color": "red"});
            }
                
        }/*CR added by swapnil 25021 e */
        // added by priyanka for ECS barcode validation -- end  
       /* if (flag==false && (component.find("ecs_barcode").get("v.value") == '' || component.find("ecs_barcode").get("v.value") == null)  && component.find("repay_mode").get("v.value") != 'SI' && component.find("repay_mode").get("v.value") != 'ECS' ){
            $("#ECSBarError").css({"color": "red"});
            $("#ECSBarError").html("Please Enter Data");
            error = true;
        }
        if(component.find("repay_mode").get("v.value") == '' || component.find("repay_mode").get("v.value") == null){
            $("#repayError").css({"color": "red"});
            $("#repayError").html("Please Enter Data");
            error = true;
        }
        if(component.find("ifsc_code").get("v.value") == '' || component.find("ifsc_code").get("v.value") == null){
            $("#ifscError").css({"color": "red"});
            $("#ifscError").html("Please Enter Data");
            error = true;
        }
        if(component.find("micr_code").get("v.value") == '' || component.find("micr_code").get("v.value") == null){
            $("#micrError").css({"color": "red"});
            $("#micrError").html("Please Enter Data");
            error = true;
        }
        if(component.find("acc_holder").get("v.value") == '' || component.find("acc_holder").get("v.value") == null){
            $("#accHolderError").css({"color": "red"});
            $("#accHolderError").html("Please Enter Data");
            error = true;
        }
        if(component.find("acc_no").get("v.value") == '' || component.find("acc_no").get("v.value") == null){
            $("#acNoError").css({"color": "red"});
            $("#acNoError").html("Please Enter Data");
            error = true;
        }
        if(component.find("ac_type").get("v.value") == '' || component.find("ac_type").get("v.value") == null){
            $("#acTypeError").css({"color": "red"});
            $("#acTypeError").html("Please Enter Data");
            error = true;
        }
        if(component.find("bank_name").get("v.value") == '' || component.find("bank_name").get("v.value") == null){
            $("#bankNameError").css({"color": "red"});
            $("#bankNameError").html("Please Enter Data");
            error = true;
        }
        if(component.find("ecs_facility").get("v.value") == '' || component.find("ecs_facility").get("v.value") == null){
            $("#openECSError").css({"color": "red"});
            $("#openECSError").html("Please Enter Data");
            error = true;        }
        if((component.find("pdcname").get("v.value") == '' || component.find("pdcname").get("v.value") == null) && component.find("repay_mode").get("v.value") != 'SI'){
            $("#pdcNameError").css({"color": "red"});
            $("#pdcNameError").html("Please Enter Data");
            error = true;
        }
        if(component.find('repay_mode').get("v.value") == 'ECS' || component.find('repay_mode').get("v.value") == 'SI'){
            if(component.find("ECS_maxLimit").get("v.value") == '' || component.find("ECS_maxLimit").get("v.value") == null){
                $("#maxLimitError").css({"color": "red"});
                $("#maxLimitError").html("Please Enter Data");
                error = true;
            }
            if(component.find("ECS_startDate").get("v.value") == '' || component.find("ECS_startDate").get("v.value") == null){
                $("#startDateError").css({"color": "red"});
                $("#startDateError").html("Please Enter Data");
                error = true;
            }
            if(component.find("ECS_endDate").get("v.value") == '' || component.find("ECS_endDate").get("v.value") == null){
                $("#ecsEndError").css({"color": "red"});
                $("#ecsEndError").html("Please Enter Data");
                error = true;
            }
            if(component.find("ECS_amount").get("v.value") == '' || component.find("ECS_amount").get("v.value") == null){
                $("#ecsAmtError").css({"color": "red"});
                $("#ecsAmtError").html("Please Enter Data");
                error = true;
             
            }
            
            
        }
        if(component.find('repay_mode').get("v.value") == 'SI'){
            if(component.find("open_valid").get("v.value") == '' || component.find("open_valid").get("v.value") == null){
                $("#openValidError").css({"color": "red"});
                $("#openValidError").html("Please Enter Data");
                error = true;
            }
            if(component.find("bank_branch").get("v.value") == '' || component.find("bank_branch").get("v.value") == null){
                $("#bankBranchError").css({"color": "red"});
                $("#bankBranchError").html("Please Enter Data");
                error = true;
            }
            if(component.find("pdcname").get("v.value") == '' || component.find("pdcname").get("v.value") == null){
                $("#pdcNameError").css({"color": "red"});
                $("#pdcNameError").html("Please Enter Data");
                error = true;
            }
           
        }
        if(component.find('repay_mode').get("v.value") == 'Security Cheque'){
            if(component.find("chq_frm").get("v.value") == '' || component.find("chq_frm").get("v.value") == null){
                $("#chqFrom").css({"color": "red"});
                $("#chqFrom").html("Please Enter Data");
                error = true;
            }
            if(component.find("chq_to").get("v.value") == '' || component.find("chq_to").get("v.value") == null){
                $("#chqTo").css({"color": "red"});
                $("#chqTo").html("Please Enter Data");
                error = true;
            }
            if(component.find("no_chq").get("v.value") == '' || component.find("no_chq").get("v.value") == null){
                $("#noChq").css({"color": "red"});
                $("#noChq").html("Please Enter Data");
                error = true;
            }
           
        }*/
        //22501--Added "cheque_date","cheque_serial_numbers" to below list for mandatory field
        var list = ["cheque_date","cheque_serial_numbers","no_chq","chq_to","chq_frm","cheque_amt","repay_mode","pdcname","bank_branch","bank_name","ECS_amount","ECS_endDate","ECS_startDate","ecs_facility","ac_type","acc_no","acc_holder","micr_code","ifsc_code","ecs_barcode"];
        for (var i = 0; i < list.length; i++) {
            if (component.find(list[i]) && !component.find(list[i]).get("v.validity").valid)
            {
                error = true;
                component.find(list[i]).showHelpMessageIfInvalid();
            }
        }
        //Bug:22501**S**
        if(sec_cheque_error){
           this.displayToastMessage(component,event,'Error',messege,'error');
            this.showhidespinner(component,event,false); 
        }
        else /*Bug:22501 End*/if(error){
            this.displayToastMessage(component,event,'Error','Please fill all mandatory details!','error');
            console.log('Please fill all mandatory details!');
            this.showhidespinner(component,event,false);
        }
        // added by priyanka for ECS barcode validation -- start
        else if(ecs_error){
            this.displayToastMessage(component,event,'Error',messege,'error');
            this.showhidespinner(component,event,false);
        }//22017 start
            else if((component.find('repay_mode').get("v.value") == 'SI' || component.find('repay_mode').get("v.value") == 'ECS') &&
                    !$A.util.isEmpty(component.get("v.repay.Open_Valid_till__c")) && !$A.util.isEmpty(component.get("v.repay.ECS_End_Date__c")) && component.get("v.repay.Open_Valid_till__c") != component.get("v.repay.ECS_End_Date__c")){
                $("#openValidError").css({"color": "red"});
                $("#openValidError").html("ECS end date & Open Valid Till should be same");
                this.displayToastMessage(component,event,'Error',"ECS end date & Open Valid Till should be same",'error');
                this.showhidespinner(component,event,false);
            }//22017 end
         /* US_1476 S*/
            else if(!component.get("v.ifscActive")){
             this.displayToastMessage(component,event,'Error',"IFSC is not Active",'error');
            this.showhidespinner(component,event,false); 
            }
         /* US_1476 E*/
        // added by priyanka for ECS barcode validation -- start
            else{
                    var bankobj = component.get("v.bankObj"); //22017 
                        
                    if(bankobj!=null && !this.checkValidEcs(component,event) && !$A.util.isEmpty(bankobj.Perfios_Account_No__c))
                    {
                        //this.displayToastMessage(component,event,'Info',"ECS Bank details i.,e, Bank A/c No/IFSC/MICR/Bank Name is not same as Perfios",'info');
                        this.AddtionalMsg='ECS Bank details i.,e, Bank A/c No/IFSC/MICR/Bank Name is not same as Perfios, ';
								this.showhidespinner(component,event,false); 
                    }
                   
                    this.showhidespinner(component,event,true);
                // Bug 22967**Start** If ECS Ex customer id is blank, assign null to it.
                if(!component.get("v.repay.Open_ECS_Ex_Customer_Id__c")){
                    component.set("v.repay.Open_ECS_Ex_Customer_Id__c",'');
                }
            	//Bug 22967 **End**
                console.log('loan obj::'+component.get("v.loan"));
                 console.log('repay obj::'+component.get("v.repay"));
                console.log('loan str::'+JSON.stringify(component.get("v.loan")));
                 console.log('repay str::'+JSON.stringify(component.get("v.repay")));
                component.set("v.repay.Loan_Application__c",component.get("v.loan").Id) ;
				var repayObj = component.get("v.repay"); //Bug 24313
                    if($A.util.isEmpty(repayObj.Loan_Application__c)) ////Bug 24313
                        repayObj.Loan_Application__c = component.get("v.loanId");//Bug 24313
                this.executeApex(component, "saveRepaymentObjnew", {
                    "repay": JSON.stringify(component.get("v.repay")),
                    "loanObj" : JSON.stringify(component.get("v.loan"))
                }, function (error, result) {
                    
                    this.showhidespinner(component,event,true);
                    console.log('result '+result);
                    if(!error && result && !result.includes('Exception')){//US 6216
                           // user story 978 s
                            var updateidentifier =  $A.get("e.c:Update_identifier");
                            updateidentifier.setParams({
                                "eventName": 'Pricing Repayment Details',
                                "oppId":component.get("v.loan").Id
                            });
                            updateidentifier.fire();
                            // user story 978 e
                        var disbId = result;
                            component.set("v.oldrepay",component.get("v.repay"));//22017
                        this.handleSuccess(component,event,disbId);
                        //this.displayToastMessage(component,event,'Success','Repayment Record saved successfully!','success');
                        //this.displayToastMessage(component,event,'Success','Record saved successfully!','error');
                        this.showhidespinner(component,event,false);
                    }   
                    else{
                        this.displayToastMessage(component,event,'Error','Failed to save record!','error');
                        this.showhidespinner(component,event,false);
                    }});
                    
                //component.find("edit").submit();
                this.showhidespinner(component,event,false);
            }
        
    },
    handleOnLoad : function(component, event) {
        
        /*  else
            component.set("v.disableECSFields",true);*/
        if(component.find('repay_mode').get("v.value") == 'ECS'){
            component.find('ecs_barcode').set("v.required",true); 
            component.find('pdcname').set("v.required",true); 
            component.find('ECS_maxLimit').set("v.required",true); 
            component.find('ECS_startDate').set("v.required",true); 
            component.find('ECS_endDate').set("v.required",true); 
            component.find('ECS_amount').set("v.required",true); 
            /*$A.util.addClass(component.find('ecs_barcode'), 'slds-has-error');
            $A.util.addClass(component.find('pdcname'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_maxLimit'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_startDate'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_endDate'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_amount'), 'slds-has-error');*/
            //Added by swapnil
            component.set("v.disableChq",true);
            if(component.find('ecs_facility').get("v.value") == 'Existing'){
                component.find('ecs_barcode').set("v.required",false); 
                //$A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
                component.set("v.mandatoryECSBarcode",false);
            }
            component.set("v.disableECSFields",false);
            
            component.set("v.disableSIFields",false);
        }
        
        // added by priyanka for SI repayment mode validation -- start
        else if(component.find('repay_mode').get("v.value") == 'SI'){
            component.find('ecs_barcode').set("v.required",false); 
            component.find('pdcname').set("v.required",false); 
            component.find('umrn').set("v.required",false); 
            /*$A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
            $A.util.removeClass(component.find('pdcname'), 'slds-has-error');
            $A.util.removeClass(component.find('umrn'), 'slds-has-error');*/
            //Added by swapnil
            if(component.find('ecs_facility').get("v.value") == 'Yes'){
                component.find('ecs_barcode').set("v.required",false); 
                //$A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
                component.set("v.mandatoryECSBarcode",false);
            }
            component.set("v.disableSIFields",true);
            component.set("v.disableECSFields",false);
        }
            else{
                component.find('ECS_maxLimit').set("v.required",false); 
                component.find('ECS_startDate').set("v.required",false); 
                component.find('ECS_endDate').set("v.required",false); 
                component.find('ECS_amount').set("v.required",false); 
                component.find('umrn').set("v.required",false); 
                /*$A.util.removeClass(component.find('ECS_maxLimit'), 'slds-has-error');
                $A.util.removeClass(component.find('ECS_startDate'), 'slds-has-error');
                $A.util.removeClass(component.find('ECS_endDate'), 'slds-has-error');
                $A.util.removeClass(component.find('ECS_amount'), 'slds-has-error');*/
                component.set("v.disableECSFields",true);
                //$A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
                // $A.util.removeClass(component.find('pdcname'), 'slds-has-error');
                //$A.util.removeClass(component.find('umrn'), 'slds-has-error');
                component.set("v.disableSIFields",false);
                
            }
        // added by priyanka for SI repayment mode validation -- end
    },
    handleSuccess : function(component, event,repayId){
        this.showhidespinner(component,event,true);
        var repayEvent = $A.get("e.c:updateRepayList");
        repayEvent.setParams({
            "repay" : repayId
        });
        repayEvent.fire();
        if(repayId != null && component.get("v.repay.Id") == null){
            component.destroy();
            this.displayToastMessage(component,event,'Success',this.AddtionalMsg+'Repayment Record saved successfully!','success');
        }
        else{
            component.destroy();
            this.displayToastMessage(component,event,'Success',this.AddtionalMsg+'Repayment Details saved successfully!','success');
        }
        
        //this.showhidespinner(component,event,false);
    },
    handleOnBlur : function(component, event, ifscMicr){
        try{
            //US5431- below if condtion commented as not needed
        //if ($A.util.isEmpty(component.find("ifsc_code").get("v.value")) || $A.util.isEmpty(component.find("micr_code").get("v.value"))){
        this.showhidespinner(component,event,true);
        var ifscMicrCode;
        var isBlank;
        if(ifscMicr.includes("IFSC")){
            
            ifscMicrCode = component.find("ifsc_code").get("v.value");
            if(ifscMicrCode == '')
                isBlank = true;
        }
        else if(ifscMicr.includes("MICR")){
            ifscMicrCode = component.find("micr_code").get("v.value");
            if(ifscMicrCode == '')
                isBlank = true;
        }
        
        if(!isBlank){
            this.executeApex(component, "fetchIFSCData", {
                "ifscmicrCode": ifscMicrCode,
                "fieldAPI": ifscMicr
            }, function (error, result) {
                if (!error && result) {
                    if(result == 'Fail'){
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Error','Record not found or MICR is inactive!','error');//5431 message updated for MICR
                    }
                    else if(result.includes("Error")){
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Error','Error occured!','error');
                    }
                        else{
                            
                           // alert('Abhi::'+ifscObj);
                           // US5431s
                            //var ifscObj = JSON.parse(result);
                            //component.find('micr_code').set('v.value', ifscObj.MICR__c);
                                                        
                            var ifscList = JSON.parse(result);                            
                            var micrList= [];
                            
                            for(var i=0;i<ifscList.length;i++){
                                micrList.push(ifscList[i].MICR__c);
                                component.set("v.micrActive", true);
                            }
                            component.set("v.micrList", micrList);
                            
                            console.log('result='+result);
                            console.log('ifscObj0='+ifscList[0]);                            
                            console.log('micrList='+micrList);
                            
                            //component.set("v.ifscActive",ifscObj.IFSC_Active__c);/*US_1476 S */
                            component.set("v.ifscActive",ifscList[0].IFSC_Active__c);/*US_1476 */ 
                            
                           // alert('Abhi::'+component.get("v.ifscActive"));
                             if(component.get("v.ifscActive")){
                            //component.find('ifsc_code').set('v.value', ifscObj.IFSC_Code__c);
                            //component.find('bank_name').set('v.value', ifscObj.Bank__c);
                            //component.find('bank_branch').set('v.value', ifscObj.Branch__c);
                            
                            component.find('ifsc_code').set('v.value', ifscList[0].IFSC_Code__c);
                            if(!component.get("v.repay.Copy_Perfios_Details__c"))
                            component.find('bank_name').set('v.value', ifscList[0].Bank__c);
                            component.find('bank_branch').set('v.value', ifscList[0].Branch__c);
                            //component.find('micr_code').set('v.disabled', true);
                            //US5431e
                            component.find('ifsc_code').set('v.disabled', true);
                            
                          // component.find('bank_name').set('v.disabled', true);//added for prod adhoc 23631
                            component.find('bank_branch').set('v.disabled', true);
                            this.showhidespinner(component,event,false);
                            this.displayToastMessage(component,event,'Success','Data fetched!','success');
                             }
                             else{
                             this.displayToastMessage(component,event,'Error','IFSC is not active.Please enter another IFSC code','error');
                             this.showhidespinner(component,event,false);
                             return null;
                            }/*US_1476 E*/
                        }
                }
            });
        }
        else
            this.showhidespinner(component,event,false);
        
    //}//US5431- condtion commented as not needed
        }catch(e){console.error('handleOnBlur Error '+e);}   
}, 
    executeApex : function(component, method, params,callback){
        
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
    displayToastMessage:function(component,event,title,message,type)
    {
        try{
            
        var showhideevent =  $A.get("e.c:ShowCustomToast");
            console.log('Toast err : '+showhideevent);
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
        }catch(err){
            console.log('Toast err : '+err);
        }
    },
    showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
            
        });
        showhideevent.fire();
    },
    //Added by swapnil
    HandleChangeECSFacility : function(component, event){
        if(component.find('repay_mode').get("v.value") == 'ECS'  && component.find('ecs_facility').get("v.value") == 'Existing' ){
            component.find('ecs_barcode').set("v.required",false);
            component.set("v.mandatoryECSBarcode",false);
            component.set("v.disableSIFields",false);
        }else if(component.find('repay_mode').get("v.value") == 'SI' && (component.find('ecs_facility').get("v.value") == 'Yes' || component.find('ecs_facility').get("v.value") == 'Existing')){ //Bug 22928 Added check for Open ECS facility Existing as well
            component.find('ecs_barcode').set("v.required",false);
            component.set("v.mandatoryECSBarcode",false);
            component.set("v.disableSIFields",true);
        } else if(component.find('repay_mode').get("v.value") == 'ECS'  && component.find('ecs_facility').get("v.value") == 'Yes' ){
            component.find('ecs_barcode').set("v.required",true);
            component.set("v.mandatoryECSBarcode",true);
             component.set("v.disableSIFields",false);
        }else 
        {
            component.find('ecs_barcode').set("v.required",true);
            component.set("v.mandatoryECSBarcode",true);
            component.set("v.disableSIFields",false);
            
            
        }
        if(component.find('ecs_facility').get("v.value") == 'Existing' ){
            var loanObj = component.get("v.loan");
            if(!$A.util.isEmpty(loanObj.CUSTOMER__r) && !$A.util.isEmpty(loanObj.CUSTOMER__r.Name))
            component.set("v.repay.Open_ECS_Ex_Customer_Id__c",loanObj.CUSTOMER__r.Name);
        }
        else{
            component.set("v.repay.Open_ECS_Ex_Customer_Id__c",'');
        }
        
    },
    copyperfiosDetails: function(component, event){
        var bankobj = component.get("v.bankObj");
        if(component.get("v.repay.Copy_Perfios_Details__c"))
        {
            if(!$A.util.isEmpty(bankobj.IFSC_Code__c)){
                component.find("ifsc_code").set("v.value",bankobj.IFSC_Code__c);
                this.handleOnBlur(component,event, "IFSC_Code__c");
                component.find("ifsc_code").set("v.disabled",true);
            }
            if(!$A.util.isEmpty(bankobj.MICR_Code__c)){
                component.find("micr_code").set("v.value",bankobj.MICR_Code__c);
                //US5431s
                //this.handleOnBlur(component, event,"MICR__c");
                if(component.get("v.micrActive")){//US5431e
                    component.find("micr_code").set("v.disabled",true);}
    } 
            if(!$A.util.isEmpty(bankobj.Perfios_Account_Holder_Name__c)){
                component.find("acc_holder").set("v.value",bankobj.Perfios_Account_Holder_Name__c);
                component.set("v.repay.Account_Holder_Name__c",bankobj.Perfios_Account_Holder_Name__c);
                component.find("acc_holder").set("v.disabled",true);
            }
            if(!$A.util.isEmpty(bankobj.Perfios_Bank_Name__c)){
                component.find("bank_name").set("v.value",bankobj.Perfios_Bank_Name__c);
                //component.find("bank_name").set("v.disabled",true);//added for prod adhoc 23631
    } 
            if(!$A.util.isEmpty(bankobj.Perfios_Account_No__c)){
                component.find("acc_no").set("v.value",bankobj.Perfios_Account_No__c);
                component.find("acc_no").set("v.disabled",true);
            }
            if(!$A.util.isEmpty(bankobj.Account_Type__c)){
                component.find("ac_type").set("v.value",bankobj.Account_Type__c);
                component.find("ac_type").set("v.disabled",true);
            }
        }
        else
        {
            component.set("v.repay",component.get("v.oldrepay")); 
            component.find("ifsc_code").set("v.disabled",false);
            component.find("micr_code").set("v.disabled",false);
            component.find("acc_holder").set("v.disabled",false);
            component.find("bank_name").set("v.disabled",false);
            component.find("acc_no").set("v.disabled",false);
            component.find("ac_type").set("v.disabled",false);
        }
    },
    checkValidEcs:function(component, event){
        var repay = component.get("v.repay");
        var bankobj = component.get("v.bankObj");
        if(!$A.util.isEmpty(repay) && !$A.util.isEmpty(bankobj))
        {
            if(!$A.util.isEmpty(repay.A_C_NO__c) && !$A.util.isEmpty(bankobj.Perfios_Account_No__c) && repay.A_C_NO__c == bankobj.Perfios_Account_No__c
               &&  !$A.util.isEmpty(repay.MICR_Code__c) && !$A.util.isEmpty(bankobj.MICR_Code__c) && repay.MICR_Code__c == bankobj.MICR_Code__c 
               &&  !$A.util.isEmpty(repay.Bank_Name__c) && !$A.util.isEmpty(bankobj.Perfios_Bank_Name__c) && repay.Bank_Name__c == bankobj.Perfios_Bank_Name__c
               &&  !$A.util.isEmpty(repay.IFSC_Code__c) && !$A.util.isEmpty(bankobj.IFSC_Code__c) && repay.IFSC_Code__c == bankobj.IFSC_Code__c)
                return true;
            else
                return false;
        }
    }
    
  
})