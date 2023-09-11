({
    count : 0,
	 updatedlistHelper :function(component, event) {
        var key = component.get("v.uploadedDataMapKey");
        var map = component.get("v.uploadedDataMap");
        // alert('in updatelisthelper');
        var subButtonMap = component.get("v.submitButtonMap");
        var apptype = key.substring(0 , key.indexOf("_"));
        component.set("v.ApplicantType" , apptype);
        var lgRegNo = key.substring(key.indexOf("_")+1 , key.indexOf("@"));
        component.set("v.LoanGuardRegNo" , lgRegNo);
        var appNo = key.substring(key.indexOf("@")+1 , key.indexOf("#"));
        var noOfApplicats = key.substring(key.indexOf("#")+1);
        component.set("v.NumberOfApplicants" , noOfApplicats);
        component.set("v.ApplicationNo" , appNo);
        component.set("v.uploadedDataMapValue" , map[key]);
        component.set("v.showSubmitButton" , subButtonMap[key]);
        var a = component.get("v.showSubmitButton");
        console.log("a--->");
        console.log(a);
        component.set("v.showToastOnce" , true);
    },
        showhidespinner:function(component, event, showhide){
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
            
        console.log(showhideevent);
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
    showToast: function(component, title, message, type){
        console.log('inside toast');
        //alert('Inside up showToast');
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({ 
                "title": title,
                "message": message,
                "type" : type,
                "mode" : "dismissible",
                "duration" : "30000"
            });    
            toastEvent.fire();
        }
    },
    
    displayMessage : function(component, title, message, type, fadeTimeout, isAutoClose) {
       //alert("inside displayMessage");
       
        console.log('inside generic flow...');
       console.log('Inside Display Message');
       			$A.createComponent(
                    "c:ToastMessage",
                    {
                        "title" : title,
                        "message" : message,
                        "type" : type,
                        "fadeTimeout" : fadeTimeout,
                        "isAutoClose" : isAutoClose
                    },
                    function(newComp) {
                        var body = [];
                        body.push(newComp);
                        component.set("v.body", body);
                    }
                );
    },
    
    closeLoaderHelper : function(component, event){
        if(this.count == 0){
            this.count += 1;
            component.set("v.count" ,'1');
            var cvids = [];
            //component.set("v.selectedDocuments",cvids);
            this.showhidespinner(component,event,false);
            var msg = event.getParam("message");
            if(component.get("v.NumberOfApplicants") == 1){
                this.count = 0;
            }
            this.displayToastMessage(component,'message',msg,'info');
            
        }
        else{
            this.count += 1;
            if(this.count == component.get("v.NumberOfApplicants")){
                this.count = 0;
            }
            this.showhidespinner(component,event,false);
        }
    },
})