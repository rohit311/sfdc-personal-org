({
	doInit  : function(component, event, helper) {
         console.log('Comp  doInit');
         var checkMap = [];
         checkMap.push({
             name: 'Customer consent on e-Agreement',
             toggle: 'false',
             type : 'CustomerConsent',
             showDocUploader : 'true',
             isComplete : 'false'
         });
         checkMap.push({
             name: 'Customer consent on Application Form',
             toggle: 'false',
             type : 'AppForm',
             showDocUploader : 'true',
             isComplete : 'false'
         });
          /*  Start of Bug 25333 chnages
        checkMap.push({
             name: 'KYC',
             toggle: 'false',
             type : 'eKyc',
             showDocUploader : 'true',
             isComplete : 'false'
         }); end of Bug 25333 chnages
         */
		 checkMap.push({
             name: 'Perfios Response Recieved',
             toggle: 'false',
             type : 'Perfios',
             showDocUploader : 'true',
             isComplete : 'false'
         });
         checkMap.push({
             name: 'SPDC Applicability',
             toggle: 'false',
             type : 'SPDC',
             showDocUploader : 'true',
             isComplete : 'false'
         });
        /*     Start of Bug 25333 chnages 
        checkMap.push({
             name: 'Banking',
             toggle: 'false',
             type : 'BankCheck',
             showDocUploader : 'true',
             isComplete : 'false'
         });
           end of Bug 25333 chnages 
         */
		  checkMap.push({
             name: 'Geo Tagging',
             toggle: 'false',
             type : 'Geo',
             showDocUploader : 'true',
             isComplete : 'false'
         });
        checkMap.push({
             name: 'Degree',
             toggle: 'false',
             type : 'Deg',
             showDocUploader : 'true',
             isComplete : 'false'
         });
         /* Start of Bug 25333 chnages */
        checkMap.push({
             name: 'Rate Approval',
             toggle: 'false',
             type : '',
             showDocUploader : 'true',
             isComplete : 'true'
         });
           checkMap.push({
             name: 'Repayment and Disbursal Match',
             toggle: 'false',
             type : 'BankCheck',
             isComplete : 'true',
             showDocUploader : 'true'
         });
        
		  //23578 Start
          checkMap.push({
             name: 'C-KYC',
             toggle: 'false',
             toggle_img: 'false',
             type : '',
             isComplete : 'true',
             showUpload_img : 'true',
             showDocUploader : 'true'
         }); 
        /* End of Bug 25333 chnages */
        component.set("v.checklistMap",checkMap);

        helper.getDashboardDetails(component,event);
    },/*DMS uploader 24317 s*/
    updateChkRecords : function(component,event,helper){
       
       var params = event.getParam('arguments');
        if (params) {
            console.log('FileName >> '+params.filename+'>>');
            var FileName = params.filename;
            var uploadStatus=params.uploadStatus;
         	if(uploadStatus == 'false')            
               helper.deleteDocToggle(component,event,FileName);
            else
                  helper.getDashboardDetails(component,event);
        }
        
    }
   /*DMS uploader 24317 e*/
})