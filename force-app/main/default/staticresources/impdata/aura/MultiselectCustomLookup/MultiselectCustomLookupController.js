({
    doInit: function(component, event, helper) {
        //debugger;
        console.log('doInit -->', component.get("v.objectApiName") + ' --> ' + component.get("v.refNumber"));
        //debugger;
        if (component.get("v.objectApiName") != undefined && component.get("v.objectApiName") != null && component.get("v.refNumber") != undefined && component.get("v.refNumber") != null) {
            helper.getDataHelper(component, event);
        }
    },
    onChangeOfCheckedStatus: function(component, event, helper) {
        /*console.log("pageNumber -->", component.get("v.pagenumber"));
        console.log("current page --> ", component.get("v.currentPage"));
        var pgName = component.get("v.pagenumber");
        var dTable = component.find("dtId");
        var selectedRows = dTable.getSelectedRows();
        console.log('onChangeOfCheckedStatus selectedRows -------------------------------------------> ', selectedRows);
        if (component.get("v.pagenumber") != null && component.get("v.pagenumber") != undefined) {
            pgName = pgName - 1;

            var selectedRows1 = component.get("v.SelectedData")[pgName];
            console.log('onChangeOfCheckedStatus selectedRows1 -------------------------------------------> ', selectedRows1);
            if (typeof selectedRows1 != 'undefined' && selectedRows1) {
                var selectedRowsIds = [];
                var allD = selectedRows1;
                for (var i = 0; i < selectedRows1.length; i++) {
                    if (typeof selectedRows != 'undefined' && selectedRows && selectedRows.length == 0) {
                        selectedRowsIds.push(selectedRows1[i].Id);
                    }
                    for (var j = 0; j < selectedRows.length; j++) {
                        if (selectedRows1[i].Id == selectedRows[j].Id) {
                            selectedRowsIds.push(selectedRows1[i].Id);
                        } else {
                            allD.push(selectedRows[j]);
                            selectedRowsIds.push(selectedRows[j].Id);
                        }
                    }
                }
                console.log("onChangeOfCheckedStatus allD --> ", allD);
                component.get("v.SelectedData")[pgName] = allD;
                if (selectedRowsIds != undefined) {
                    dTable.set("v.selectedRows", selectedRowsIds);
                }
            }
        } else {
            var cp = component.get("v.currentPage");
            if (cp == 0) {
                cp = cp + 1;
            }
            var selectedRows1 = component.get("v.SelectedData")[cp];
            if (selectedRows1 == undefined && selectedRows != undefined && selectedRows.length > 0) {
                var selectedRowsIds = [];
                var allD = [];
                for (var j = 0; j < selectedRows.length; j++) {
                    allD.push(selectedRows[j]);
                    selectedRowsIds.push(selectedRows[j].Id);
                }
                console.log("else allD -->", allD);
                console.log("else selected data -->", component.get("v.SelectedData")[cp]);
                component.get("v.SelectedData")[cp] = allD;
                if (selectedRowsIds != undefined) {
                    dTable.set("v.selectedRows", selectedRowsIds);
                }
            }
        }*/
    },
    setSelectedValues: function(component, event, helper) {
        helper.setSelectedValuesHelper(component, event, helper);
    },
    getNextElements: function(component, event, helper) {
        helper.getNextElementsHelper(component, event, helper);
    },
    getPreviousElements: function(component, event, helper) {
        helper.getPreviousElementsHelper(component, event, helper);
    },
    getParticularPageNumber: function(component, event, helper) {
        helper.getParticularPageNumberHelper(component, event, helper);
    },
    fetchRelavantData: function(component, event, helper) {
        helper.fetchRelavantDataHelper(component, event, helper);
    },
    onKeyupAction: function(component, event, helper) {
        var searchStr = component.find("searchId").get("v.value");
        var goToNum = component.find("EnteredPageNumber").get("v.value");
        if (goToNum != "" && goToNum != undefined && goToNum != null) {
            component.set("v.pagenumber", goToNum);
        }
        if (searchStr == '' || searchStr == null || searchStr == undefined || goToNum == '' || goToNum == null || goToNum == undefined) {
            //console.log('onKeyupAction searchStr --> ', searchStr);
            //console.log('component.get("v.tempAllRecord") --> ', component.get("v.tempAllRecord"));
            //console.log('complete data --> ', component.get("v.mydata"));
            //console.log('reset --> ' , JSON.stringify(component.get("v.setValue")));
            var valuesFromChild = component.get("v.mydata");

            helper.resetPageDataLogic(component, valuesFromChild);
        }
    },
    closeCustomToast: function(component, event, helper) {
        helper.closeToast(component);
    },
    onblur : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component 
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus : function(component,event,helper){
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        //var getInputkeyWord = '';
        //helper.searchHelper(component,event,getInputkeyWord);
    },
    
    keyPressController : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord != undefined && getInputkeyWord.length > 3){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].Id == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );      
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        component.set("v.SearchKeyWord",null);
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" , listSelectedItems); 
        console.log('listSelectedItems -->', listSelectedItems);
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
}) 