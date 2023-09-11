({    
    doInit : function(component, event, helper) { 
        console.log('your portfolio called');
        component.set("v.secLst",new Array());
        component.set("v.inv","Investment Name");
        component.set("v.type","EQUITY");
        component.find("searchList").set("v.value", "SCRIP_NAME");
        
        var childcmp=component.find("child");
        childcmp.setCustfields('',"Scrips__c", 'SCRIP_NAME,EQUITY' ,"EQUITY");  
        
        var utility = component.find("toastCmp");        
        var id1=component.get("v.recordId");  
        var action = component.get("c.addPortfolio");          
        action.setParams({"AccId":id1});
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var name = a.getReturnValue();
                
                if( name && name.length > 0  )
                {
                    component.set("v.secLst",name);
                    //console.log("Add to portfolio" + JSON.stringify(name));
                    
                    var secLst = component.get("v.secLst");
                    //console.log('Sec list****'+secLst[0].invName);
                    
                    var totalPortfolioValue = 0;
                    if(secLst)
                    {
                        for(var i=0;i<secLst.length;i++)
                        {
                            if(! isNaN(secLst[i].marketValue))
                            {
                                totalPortfolioValue = totalPortfolioValue + (parseFloat( secLst[i].marketValue) * parseFloat(secLst[i].quantity));
                            }
                        }
                        //console.log("Total value " +totalPortfolioValue);
                        component.set("v.totalPortfolioValue",totalPortfolioValue);
                	}                
                }
            }
            else
            {
                //alert("Error while fetching data");
                utility.showToast('Error!', 'Something went wrong, while fetching the data.' , 'error');
            }
        });       
        $A.enqueueAction(action);      
    },
    
    OnChange : function(component, event, helper) {
        //event printing
        var evtLabel = event.getSource().get("v.label");
        var evtVal = event.getSource().get("v.value");
        console.log(evtLabel  + '---'  +  evtVal);
        let a = "";
        if(evtLabel == 'Search Criteria')
        {
            a= evtVal+"," ;
        }
        
        var op=component.find("contactList").get("v.value");   
        var childcmp=component.find("child");
        if( a == "")
        {
            a  =   component.find("searchList").get("v.value")+"," ;
        }
        
        if(op=="MUTUALFUND")
        {    
            component.set("v.inv","Scheme Name"); 
            component.set("v.type","MUTUALFUND");   
            component.find("input2").set("v.label","Unit of your scheme");            
            a += "MUTUALFUND";
        }else{  
            component.set("v.inv","Investment Name");
            component.set("v.type","EQUITY");
            component.find("input2").set("v.label","Quantity of your shares");     
            a+= "EQUITY";
        }
        childcmp.setCustfields('',"Scrips__c",a,"EQUITY");        
        component.set("v.invName",''); 
        
    },
    
    addPortfolioOnList : function(component, event, helper){
        event.preventDefault();
        var utility = component.find("toastCmp");
        var secLst = component.get("v.secLst");
        console.log("List " + JSON.stringify(secLst));
        var secObj = new Object();   
        var invname = component.get("v.invName");
        
        if(invname && component.get("v.quantity")){
            var Flag=0;
            for(var i=0;i<secLst.length;i++)
            {
                
                if(secLst[i].invName==invname.Name){
                    secLst[i].quantity=parseInt(secLst[i].quantity)+ parseInt(component.get("v.quantity"));
                    var secLst = component.get("v.secLst");
                    Flag=1;
                }
                // alert(Flag);
            }
            if(Flag==0){
                // alert(Flag);
                secObj.invName = invname.Name;
                secObj.invType = component.find("contactList").get("v.value");
                secObj.quantity = component.get("v.quantity");
                //secObj.countID = component.get("v.count1")+1;
                secLst.push(secObj);
                //component.set("v.count1",component.get("v.count1")+1);
            }
            
            component.set("v.secLst",secLst);   
            //console.log("add to portfolio " + JSON.stringify(component.get("v.secLst"))  + 'OBJECT \n '+ JSON.stringify(secLst) );
            //var cnt = +secObj.quantity+ +component.get("v.count");
            //component.set("v.count",cnt);
        }
        else{
            //alert("Please Enter Required Field")
            utility.showToast('Error!', 'Please enter required fields.' , 'error');
        }
        event.preventDefault();
    },
    deleteRow :function(component, event, helper)
    {   
        event.preventDefault();   
        var r= confirm("Are you sure you want to delete the entry? ");    
        var utility = component.find("toastCmp");
        if(r==true)
        {   
            try
            {
                var secLst = component.get("v.secLst");
                secLst.splice(event.target.id,1);
                component.set("v.secLst",secLst);
                /*for(var i=0;i<secLst.length;i++ )
                {  
                    //console.log(' Checking for  : ' +  event.target.id);
                    //if(secLst[i].countID==event.target.id)
                    if( i ==event.target.id )
                    {        
                        secLst.splice(i,1);
                        component.set("v.secLst",secLst);
                        break;
                    }
                }*/
                
                utility.showToast('Success!', 'Entry deleted successfully.' , 'success');
            }catch(err){
                utility.showToast('Error!', 'We have encountered an error. Please contact your administrator. ' , 'error');
            }
        }
        event.preventDefault();      
    },
    
    reset:function(component, event, helper){  
        component.find("input2").set("v.value",null);     
        component.set("v.invName",null);   
        //var input2=component.find("input2").get("v.value");   
        var invName=component.get("v.invName"); 
        var childcmp=component.find("child");
        childcmp.clearLookup();
        childcmp.setCustfields(invName,"Scrips__c","EQUITY","EQUITY");
    },
    saveDetails:function(component, event, helper){
        
        var utility = component.find("toastCmp");
        var r= confirm("Do you want to save Your Portfolio?");
        
        if(r==true)
        {
            component.set('v.isProcessing',true);
            var secLst = component.get("v.secLst");//new list prop details 
            //console.log("LSIT " + JSON.stringify(secLst));
            var id1=component.get("v.recordId");  
            var action = component.get("c.savePortfolio");
            action.setParams({ 
                "pdLst":component.get("v.newPropertyDetails"),
                "AccId":id1
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS")
                {
                    var name = a.getReturnValue();
                    if(name && name.includes('SUCCESS'))
                    {
                        utility.showToast('Success!', 'Congratulations, your portfolio saved successfully!' , 'success');
                    }
                    else{
                        utility.showToast('Error!', 'We have encountered an error while saving the portfolio. Please contact your administrator.' , 'error');
                    }
                    window.location.reload();
                }
                else
                {
                    utility.showToast('Error!', 'We have encountered an error while saving the portfolio. Please contact your administrator.' , 'error');
                }
                component.set('v.isProcessing',false);
            });
            $A.enqueueAction(action)
        }    
    }, 
    onProceed:function(component, event, helper){
        	var utility = component.find("toastCmp"); 
        
        	var secLst = component.get("v.secLst");
            var action = component.get("c.proceed");
            component.set('v.isProcessing',true);
            var id1=component.get("v.recordId");
            action.setParams({ 
                "secLst1":secLst,
                "AccId":id1
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    if(a.getReturnValue()){
                        //console.log( 'Return value :  '  + JSON.stringify(a.getReturnValue() ) );
                        var propertyDetails = a.getReturnValue();
                        var totalPortfolioValue = 0;
                        
                        for(var i=0;i<propertyDetails.length; i++){
                            for(var j=0;j<secLst.length;j++){
                                if(secLst[j].invName == propertyDetails[i].Digital_Scrip_Name__c)
                                {
                                    if(! isNaN(propertyDetails[i].Digital_Scrip_market_price__c)){
                                        secLst[j].marketValue = propertyDetails[i].Digital_Scrip_market_price__c;
                            			totalPortfolioValue = totalPortfolioValue + (parseFloat( propertyDetails[i].Digital_Scrip_market_price__c) * parseFloat(propertyDetails[i].Number_of_Shares__c));                            
                                    	break;
                                    }
                                    
                                }
                            }
                            
                        }
                        component.set("v.secLst", secLst);
                        component.set("v.newPropertyDetails",propertyDetails);
                        component.set("v.totalPortfolioValue",totalPortfolioValue);
                        //console.log('New property details****'+JSON.stringify(propertyDetails)+'and cmp***'+JSON.stringify(component.get("v.newPropertyDetails"))); 
                    }
                    if(totalPortfolioValue && totalPortfolioValue > 0 ){
                        utility.showToast('Success!', 'Congratulations, Market value fetched successfully!' , 'success');
                    }
                    else{
                        utility.showToast('Error!', 'Sorry, we had encountered an issue. Please contact your administrator.' , 'error');
                    }
                }
                else
                {
                    utility.showToast('Error!', 'We have encountered an error while fetching value for the portfolio. Please contact your administrator.' , 'error');
                }
                component.set('v.isProcessing',false);
            });
            $A.enqueueAction(action)
            
            
    },  
    onClose:function(component, event, helper)
    {
        var r= confirm("Are you sure to close the window");
        if(r==true){
            window.location.reload(true);  
        }    
    },
    /*CSV changes S*/
    uploadCSV :function(component, event, helper){
        component.set("v.isUploadCSV",true);
    },
    closeModel: function(component, event, helper) {
        // for Hide/Close Model/POP UP ,set the "isUploadCSV" attribute to "Fasle"  
        component.set("v.isUploadCSV", false);
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    readCSV: function(component, event, helper){
        var fileName = component.find("file").get("v.value") ;
        var fileInput = component.find("file").get("v.files");
        //console.log("File name " + fileName + "" + fileInput);
        var file = fileInput[0];
        var textData;
        var fileReader = new FileReader();
        fileReader.readAsText(file);
        
        fileReader.onload = function(evt) {
            //console.log("On load");
            var data = evt.target.result;
            //console.log("Data: ***" + data);
            var fileContent = helper.csvToJSON(component, data);
            //console.log('File content*** ' + fileContent);
            
            //console.log("SecList***" + component.get("v.secLst"));
            // helper.processFileData(component, fileContent);
            // assign to secLst
            helper.checkInvName(component);
            
            component.set("v.isUploadCSV", false);
        }
        fileReader.onerror = function (evt) {
            //console.log("error reading file");
        }
    }
    /*CSV changes E*/
})