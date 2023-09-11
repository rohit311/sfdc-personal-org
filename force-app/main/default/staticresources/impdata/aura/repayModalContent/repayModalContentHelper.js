({
    fetchData : function(component, event) {
        console.log('Fetch data');
        this.showhidespinner(component,event,true);
        this.executeApex(component, "fetchRepaymentObject", {
            "repayId": component.get("v.repayId")
        }, function (error, result) {
            
            if (!error && result) {
                if(result == 'Fail'){
                    if($A.util.isEmpty(component.get("v.repay.Id"))){
                        console.log('in empty');
                       component.find('repay_mode').set('v.value','ECS');
                                component.set("v.disableECSFields",true); //by default 

                    }
                    this.showhidespinner(component,event,false);
                }
                else{
                    component.set("v.repay",JSON.parse(result));
                    console.log('Data we get '+result);
                    console.log('MICR SI '+component.get('v.repay.MICR_Code__c'));
                    component.find('micr_code').set('v.value',component.get('v.repay.MICR_Code__c'));
                    component.find('repay_mode').set('v.value', component.get("v.repay.Repayment_Mode__c"));
                    console.log('in empty');
                    
                    component.find('ac_type').set('v.value', component.get("v.repay.A_C_Type__c"));
                    component.find('ecs_facility').set('v.value', component.get("v.repay.Open_ECS_Facility__c"));
                    
                    var data=JSON.parse(result);
                    console.log('Emandate stage is '+data.Mandate_Process_Stage__c);
                    if(!$A.util.isEmpty(data.Mandate_Process_Stage__c) && data.Mandate_Process_Stage__c=='In Progress')
                    {
                        component.find("saveButton").set("v.disabled",true);
                    }
                    this.selectRepay(component,event);
                    this.showhidespinner(component,event,false);
                }
                
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
           
            $A.util.addClass(component.find('chq_frm'), 'slds-has-error');
            $A.util.addClass(component.find('chq_to'), 'slds-has-error');
            $A.util.addClass(component.find('no_chq'), 'slds-has-error');
            component.set("v.disableChq",false);
            $A.util.removeClass(component.find('ECS_maxLimit'), 'slds-has-error');
            $A.util.removeClass(component.find('ECS_startDate'), 'slds-has-error');
            $A.util.removeClass(component.find('ECS_endDate'), 'slds-has-error');
            $A.util.removeClass(component.find('ECS_amount'), 'slds-has-error');
            $A.util.removeClass(component.find('open_valid'), 'slds-has-error');
            $A.util.removeClass(component.find('bank_branch'), 'slds-has-error');
            component.set("v.disableECSFields",true);
            $A.util.addClass(component.find('ecs_barcode'), 'slds-has-error');
            $A.util.addClass(component.find('pdcname'), 'slds-has-error');
            $A.util.removeClass(component.find('umrn'), 'slds-has-error');
            component.set("v.disableSIFields",false);
        }
        else if(component.find('repay_mode').get("v.value") == 'ECS'){
            $A.util.removeClass(component.find('chq_frm'), 'slds-has-error');
            $A.util.removeClass(component.find('chq_to'), 'slds-has-error');
            $A.util.removeClass(component.find('no_chq'), 'slds-has-error');
            component.set("v.disableChq",true);
console.log('HI ');
            $A.util.addClass(component.find('pdcname'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_maxLimit'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_startDate'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_endDate'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_amount'), 'slds-has-error');
            $A.util.removeClass(component.find('open_valid'), 'slds-has-error');
            $A.util.removeClass(component.find('bank_branch'), 'slds-has-error');
            //Added by swapnil
            if(component.find('ecs_facility').get("v.value") == 'Existing'){
                $A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
                component.set("v.mandatoryECSBarcode",false);
             
            }
            component.set("v.disableECSFields",false);
            //component.set("v.disableSIFields",false);
            //component.find('ecs_barcode').set('v.disabled',false);
            //alert('s');
        }
        /* else{
            $A.util.removeClass(component.find('ECS_maxLimit'), 'slds-has-error');
            $A.util.removeClass(component.find('ECS_startDate'), 'slds-has-error');
            $A.util.removeClass(component.find('ECS_endDate'), 'slds-has-error');
            $A.util.removeClass(component.find('ECS_amount'), 'slds-has-error');
            component.set("v.disableECSFields",true);
        }*/
        
        // added by priyanka for SI repayment mode validation -- start
            else if(component.find('repay_mode').get("v.value") == 'SI'){
                $A.util.removeClass(component.find('chq_frm'), 'slds-has-error');
                $A.util.removeClass(component.find('chq_to'), 'slds-has-error');
                $A.util.removeClass(component.find('no_chq'), 'slds-has-error');
                component.set("v.disableChq",true);
                
                $A.util.removeClass(component.find('umrn'), 'slds-has-error');
                $A.util.addClass(component.find('open_valid'), 'slds-has-error');
                $A.util.addClass(component.find('pdcname'), 'slds-has-error');
                $A.util.addClass(component.find('ECS_maxLimit'), 'slds-has-error');
                $A.util.addClass(component.find('ECS_startDate'), 'slds-has-error');
                $A.util.addClass(component.find('ECS_endDate'), 'slds-has-error');
                $A.util.addClass(component.find('ECS_amount'), 'slds-has-error');
                $A.util.addClass(component.find('bank_name'), 'slds-has-error');
                $A.util.addClass(component.find('bank_branch'), 'slds-has-error');
                
                //Added by swapnil
                
                if(component.find('ecs_facility').get("v.value") == 'Yes'){
                    $A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
                    component.set("v.mandatoryECSBarcode",false);
                }
                
                
                component.set("v.disableSIFields",true);
                component.set("v.disableECSFields",false);
            }
                else{
                    $A.util.removeClass(component.find('chq_frm'), 'slds-has-error');
                    $A.util.removeClass(component.find('chq_to'), 'slds-has-error');
                    $A.util.removeClass(component.find('no_chq'), 'slds-has-error');
                    component.set("v.disableChq",true);
                    $A.util.removeClass(component.find('ECS_maxLimit'), 'slds-has-error');
                    $A.util.removeClass(component.find('ECS_startDate'), 'slds-has-error');
                    $A.util.removeClass(component.find('ECS_endDate'), 'slds-has-error');
                    $A.util.removeClass(component.find('ECS_amount'), 'slds-has-error');
                    $A.util.removeClass(component.find('open_valid'), 'slds-has-error');
                    $A.util.removeClass(component.find('bank_branch'), 'slds-has-error');
                    component.set("v.disableECSFields",true);
                    //  $A.util.addClass(component.find('ecs_barcode'), 'slds-has-error');
                    $A.util.addClass(component.find('pdcname'), 'slds-has-error');
                    $A.util.removeClass(component.find('umrn'), 'slds-has-error');
                    component.set("v.disableSIFields",false);
                    
                    
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
        console.log('in save');
        // added by priyanka for ECS barcode validation -- start
        var ecs_error=false;
        var messege;
        var total=0;
        var ecs_barcode_number=component.find("ecs_barcode").get("v.value");
        var flag= component.get("v.mandatoryECSBarcode");
        
        console.log('flag=='+flag);
        console.log('ecs_barcode_number=='+ecs_barcode_number);
        if(flag==true && ecs_barcode_number==null )
        {   
            console.log('***');
            messege="Since Document Value is Nach Deferral, So the Barcode Number can be Blank";
            this.displayToastMessage(component,event,'Success',messege,'success');
            this.showhidespinner(component,event,false);
        } 
        else if(ecs_barcode_number != null && flag==true)
        {
            console.log('ecs_barcode_number.length=='+ecs_barcode_number.length);
            if(ecs_barcode_number.length != null && ecs_barcode_number.length !=10)
            {
                $("#ECSBarError").css({"color": "red"});
                messege='Enter the correct Barcode No...Length must be 10 character';
                ecs_error = true;
            }
            else
            {
                console.log('ecs_barcode_number.includes(" ")=='+ecs_barcode_number.includes(" "));
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
            
        }
        console.log('$$$$$$');
        // added by priyanka for ECS barcode validation -- end  
        if (flag==false && (component.find("ecs_barcode").get("v.value") == '' || component.find("ecs_barcode").get("v.value") == null)  && component.find("repay_mode").get("v.value") != 'SI' && component.find("repay_mode").get("v.value") != 'ECS' ){
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
           
        }
        console.log('error=='+error);
        console.log('ecs_error=='+ecs_error);
        if(error){
            this.displayToastMessage(component,event,'Error','Please fill all mandatory details!','error');
            this.showhidespinner(component,event,false);
        }
        // added by priyanka for ECS barcode validation -- start
        else if(ecs_error){
            this.displayToastMessage(component,event,'Error',messege,'error');
            this.showhidespinner(component,event,false);
        }
        // added by priyanka for ECS barcode validation -- start
            else{
                console.log('**** in else');
                //component.set("v.repay.Loan_Application__c",component.get("v.loanId")) ;
                component.find("edit").submit();
                this.showhidespinner(component,event,false);
            }
        
    },
    handleOnLoad : function(component, event) {
        
        /*  else
            component.set("v.disableECSFields",true);*/
        if(component.find('repay_mode').get("v.value") == 'ECS'){
            $A.util.addClass(component.find('ecs_barcode'), 'slds-has-error');
            $A.util.addClass(component.find('pdcname'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_maxLimit'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_startDate'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_endDate'), 'slds-has-error');
            $A.util.addClass(component.find('ECS_amount'), 'slds-has-error');
            //Added by swapnil
            
            if(component.find('ecs_facility').get("v.value") == 'Existing'){
                $A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
                component.set("v.mandatoryECSBarcode",false);
            }
            component.set("v.disableECSFields",false);
            component.set("v.disableSIFields",false);
        }
        
        // added by priyanka for SI repayment mode validation -- start
        else if(component.find('repay_mode').get("v.value") == 'SI'){
            $A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
            $A.util.removeClass(component.find('pdcname'), 'slds-has-error');
            $A.util.removeClass(component.find('umrn'), 'slds-has-error');
            //Added by swapnil
            if(component.find('ecs_facility').get("v.value") == 'Yes'){
                $A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
                component.set("v.mandatoryECSBarcode",false);
            }
            component.set("v.disableSIFields",true);
            component.set("v.disableECSFields",false);
        }
            else{
                $A.util.removeClass(component.find('ECS_maxLimit'), 'slds-has-error');
                $A.util.removeClass(component.find('ECS_startDate'), 'slds-has-error');
                $A.util.removeClass(component.find('ECS_endDate'), 'slds-has-error');
                $A.util.removeClass(component.find('ECS_amount'), 'slds-has-error');
                component.set("v.disableECSFields",true);
                //$A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
                // $A.util.removeClass(component.find('pdcname'), 'slds-has-error');
                $A.util.removeClass(component.find('umrn'), 'slds-has-error');
                component.set("v.disableSIFields",false);
                
            }
        // added by priyanka for SI repayment mode validation -- end
    },
    handleSuccess : function(component, event){
        this.showhidespinner(component,event,true);
        var repayEvent = $A.get("e.c:updateRepayList");
        console.log('response is'+event.getParams().response);
        repayEvent.setParams({
            "repay" : event.getParams().response.id
        });
        repayEvent.fire();
        if(event.getParams().response.id != null && component.get("v.repay.Id") == null){
            component.destroy();
            this.displayToastMessage(component,event,'Success','Repayment Record added successfully!','success');
        }
        else{
            component.destroy();
            this.displayToastMessage(component,event,'Success','Repayment Details updated successfully!','success');
        }
        
        //this.showhidespinner(component,event,false);
    },
    handleOnBlur : function(component, event, ifscMicr){
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
                        this.displayToastMessage(component,event,'Error','Record not found!','error');
                    }
                    else if(result.includes("Error")){
                        this.showhidespinner(component,event,false);
                        this.displayToastMessage(component,event,'Error','Error occured!','error');
                    }
                        else{
                            var ifscObj = JSON.parse(result);
                            console.log('Hrus='+result);
                            console.log(component.find('micr_code').get('v.value')+'  '+ifscObj.MICR__c);
                            component.find('micr_code').set('v.value', ifscObj.MICR__c);
                            component.find('ifsc_code').set('v.value', ifscObj.IFSC_Code__c);
                            component.find('bank_name').set('v.value', ifscObj.Bank__c);
                            component.find('bank_branch').set('v.value', ifscObj.Branch__c);
                            
                            component.find('ifsc_code').set('v.disabled', true);
                            component.find('micr_code').set('v.disabled', true);
                            component.find('bank_name').set('v.disabled', true);
                            component.find('bank_branch').set('v.disabled', true);
                            
                            console.log('on Head'+component.get('v.micrObj'));
                            this.showhidespinner(component,event,false);
                            this.displayToastMessage(component,event,'Success','Data fetched!','success');
                        }
                }
            });
        }
        else
            this.showhidespinner(component,event,false);
        
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
        
        var showhideevent =  $A.get("e.c:ShowCustomToast");
        showhideevent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        showhideevent.fire();
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
            $A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
            component.set("v.mandatoryECSBarcode",false);
           
        }else if(component.find('repay_mode').get("v.value") == 'SI' && component.find('ecs_facility').get("v.value") == 'Yes'){
            $A.util.removeClass(component.find('ecs_barcode'), 'slds-has-error');
            component.set("v.mandatoryECSBarcode",false);
           
        } else if(component.find('repay_mode').get("v.value") == 'ECS'  && component.find('ecs_facility').get("v.value") == 'Yes' ){
            $A.util.addClass(component.find('ecs_barcode'), 'slds-has-error');
            component.set("v.mandatoryECSBarcode",true);
        }else 
        {
            $A.util.addClass(component.find('ecs_barcode'), 'slds-has-error');
            component.set("v.mandatoryECSBarcode",true);
            
            
            
        }
        console.log('test position'+component.find('ecs_facility').get("v.value") == 'Existing' );
        if(component.find('ecs_facility').get("v.value") == 'Existing' ){
            var loanObj = component.get("v.loan");
            console.log('loan is'+loanObj)
            component.set("v.Ex_customer_id",loanObj.CUSTOMER__r.Name);
        }
        else{
            component.set("v.Ex_customer_id",'');
        }
        
    } 
  
})