({
	doInit : function(component, event, helper) {
		if (typeof(localStorage) === undefined) 
        {
            
            console.log("Sorry, your browser does not support Web Storage...");
		} 
        else 
        {
			if(localStorage.getItem("BranchName") != null)
            {
                console.log('Branch code retrieved : ' + localStorage.getItem("BranchName") );
                component.set("v.brnName", localStorage.getItem("BranchName") );
            }
            else
			{
                var brCode = prompt("Please Enter Branch Code ", ""); 
              	if(!isNaN(brCode))
                {
                    if (brCode != null) 
                    {
                        console.log('brCode---'+brCode);
                        component.set("v.brnCode", brCode);
                        
                        var act = component.get("c.BranchDetails");
                        act.setParams({"bCode":brCode});
                        act.setCallback(this, function(response){
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var returnVal = response.getReturnValue();
                                component.set("v.brnName", returnVal);
                                
                                if(response.getReturnValue() == 'Failed'){
                                    component.set("v.isErrorMsg",true);
                                }
                                else
                                {
                                	localStorage.setItem("BranchName", returnVal);    
                                    localStorage.setItem("BranchCode", brCode);
                                }
                                
                            }
                        });   
                        $A.enqueueAction(act);
                 	}
            	}
                else{
                     component.set("v.isErrorMsg",true);
                }
            }
		}
	},
    
    
    createToken : function(component, event, helper) {
        var mobField = component.find("MobileNumber");
        var mobNo = mobField.get("v.value");
        var brCode; 
        
        if(localStorage.getItem("BranchCode") != null)
        {
            brCode = localStorage.getItem("BranchCode");
        }
        else{
            brCode = component.get("v.brnCode");
        }
            
        console.log('createToken - BranchCode retrieved : '+brCode);
        
        if (isNaN(mobNo)||mobNo==''){
        	mobField.set("v.errors", [{message:"Please Enter Valid Mobile Number."}]);
        }
        else if(mobNo.length != 10){
            mobField.set("v.errors", [{message:"Please Enter Valid 10 digit Mobile Number."}]);
        }
        else
        {
            mobField.set("v.errors", null);
            var action = component.get("c.createCase");
            action.setParams({
                				"mobNo":mobNo,
                				"bCode":brCode
            				});
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnVal = response.getReturnValue();
                    console.log('returnVal after creating the token  - ' + returnVal );
                    
                    var strMsg = '';
                    if(returnVal.indexOf('SUCCESS') != -1 ){
                        console.log('we got success.Lets split the token number now. '+returnVal);
						var tkn = returnVal.substr(returnVal.indexOf('-')+1 ,returnVal.length);                        
                        component.set('v.msgType', 'confirm');
            			strMsg = 'You will get Token Number('+ tkn +') on '+ mobField.get("v.value") +' through SMS .';
                    }
                    else{
                        
                        strMsg ='Something went wrong. Please contact your branch.';
                        component.set('v.msgType', 'error');
                    }
                    
                    component.set("v.errorMessage" , strMsg);
                    mobField.set("v.value", "");    
                    var successMsg = document.getElementById('successMsgId');
                    successMsg.style.display = "block"; 
                    
                }
            });   
            $A.enqueueAction(action);
            
                                      
        }
    },
    
    
    resetData : function(component, event, helper) {
        //clear mobile number field and error messages
        var mobField =component.find("MobileNumber");
        mobField.set("v.value", "");
        mobField.set("v.errors", "");
        
        //hide the error block
        var successMsg = document.getElementById('successMsgId');
        successMsg.style.display = "none";
        
        //clear the error message
        component.set("v.errorMessage" , '');
        
    },
    showSpinner :   function(component, event, helper) {
        component.set('v.isSpinnerActivated' , 'true');
    },
    hideSpinner:	function(component, event, helper) {
        component.set('v.isSpinnerActivated' , 'false');
    }
})