({
    getDataHelper: function(component, event) {
        var action = component.get("c.getRecords");
        component.set("v.showSetsPagination", false);
        action.setParams({
            strObjectName: component.get("v.objectApiName"),
            refernceNumber: component.get("v.refNumber")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                if (response.getReturnValue() == null) {
                    console.log('Something wrong in static resource!');
                    return;
                } else {
                    var pageSize = component.get("v.pageSize");
                    component.set("v.mycolumns", response.getReturnValue().lstDataTableColumns);
                    component.set("v.mydata", response.getReturnValue().lstDataTableData);
                    component.set("v.lookupField", response.getReturnValue().lookupField);
                    //console.log('lookupField -->', component.get("v.lookupField"));
                    var tlength = component.get("v.mydata").length;
                    component.set("v.totalRecords", tlength);
                    //console.log('totalRecords -->', component.get("v.totalRecords"));
                    //Set the current Page as 0
                    component.set("v.currentPage", 0);
                    component.set("v.prevPage", 1);
                    // set star as 0
                    component.set("v.startPage", 0);
                    component.set("v.endPage", pageSize - 1);
                    var sv = component.get("v.selectedValues");
                    var PaginationList = [];
                    for (var i = 0; i < pageSize; i++) {
                        if (component.get("v.mydata").length > i) {
                            PaginationList.push(response.getReturnValue().lstDataTableData[i]);
                            //console.log('1 . on load sObjectList[i] -------------------->', response.getReturnValue().lstDataTableData[i]);
                        }
                    }
                    var ssd = [];
                    var other = [];
                    console.log('sv --> ', JSON.stringify(sv));
                    for (var i = 0; i < PaginationList.length; i++) {
                        if (sv.includes((PaginationList[i][component.get("v.lookupField")]).toUpperCase())) {
                            ssd.push(PaginationList[i]);
                        }
                    }
                    console.log('ssd --> ', JSON.stringify(ssd));
                    if (ssd.length > 0) {
                        console.log('inside -->');
                        var pN = component.get("v.currentPage");
                        component.get("v.SelectedData")[pN] = ssd;
                    }
                    console.log('selected data --> ', JSON.stringify(component.get("v.SelectedData")));
                    component.set('v.listToBeDisplayed', PaginationList);
                    component.set('v.showSetsPagination', true);
                    var dTable = component.find("dtId");
                    var selectedRows = dTable.getSelectedRows();
                    console.log('selectedRows -->', selectedRows);
                    //console.log('b selectedValues -->', JSON.stringify(component.get("v.selectedValues")));
                    if (selectedRows == undefined) {

                        var setValue = [];
                        //var sv = component.get("v.selectedValues");
                        var data = component.get("v.mydata");
                        var sw = [];
                        for (var i in data) {
                            //console.log('i --> ', i);
                            //console.log('1 i --> ', sv.includes(data[i][component.get("v.lookupField")]));
                            if (sv.includes((data[i][component.get("v.lookupField")]).toUpperCase())) {
                                setValue.push(data[i].Id);
                                sw.push(data[i]);
                            }
                        }
                        //console.log('setValue -->', setValue);
                        component.set("v.setValue", sw);
                        //console.log('sw -->', sw);
                        dTable.set("v.selectedRows", setValue);
                        component.set("v.selectedValues", sw);
                        console.log('a selectedValues -->', component.get("v.selectedValues"));
                    }
                }
            } else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } else {
                console.log('Something went wrong, Please check with your admin');
            }
        });
        $A.enqueueAction(action);
    },
    setSelectedValuesHelper: function(component, event, helper) {
        console.log('setSelectedValues SelectedData values --> ', JSON.stringify(component.get("v.SelectedData")));

        var dTable = component.find("dtId");
        var selectedRows = dTable.getSelectedRows();
        console.log('setSelectedValuesHelper selectedRows --> ', JSON.stringify(selectedRows));

        //var valuesFromChild1 = component.get("v.setValue");
        //console.log('valuesFromChild1 --> ', JSON.stringify(valuesFromChild1));

        console.log('current page -->', component.get("v.currentPage"));
        console.log('previous page -->', component.get("v.prevPage"));
        var pgN = component.get("v.currentPage");
        var sm1 = [];
        var found1 = false;
        if (selectedRows != undefined && selectedRows.length > 0) {
            if (this.isEmpty(component.get("v.SelectedData"))) {

                console.log("here selected data is completely empty ---->");
                // check for setValue
                console.log("setvalue -->", component.get("v.setValue"));
                console.log("listToBeDisplayed -->", component.get('v.listToBeDisplayed'));
                var difVal = [];
                var leftVal = component.get('v.listToBeDisplayed');
                var found = false;
                if (component.get("v.setValue") != undefined) {
                    var sv1 = component.get("v.setValue");
                    for (var i = 0; i < sv1.length; i++) {
                        found = false;
                        for (var j = 0; j < leftVal.length; j++) {
                            //console.log('leftVal -->'+ (leftVal[j].Id == sv1[i].Id));
                            if (leftVal[j].Id == sv1[i].Id) {
                                found = true;
                                break;
                            }
                        }
                        console.log('sv1[i] -->', sv1[i].Id + ' ..... ' + found);
                        if (!found) {
                            difVal.push(sv1[i]);
                        }
                    }
                }
                console.log('difVal -->', difVal);
                if (difVal.length > 0) selectedRows = difVal.concat(selectedRows);
                console.log('selectedRows -->', selectedRows);
                component.get("v.SelectedData")[pgN] = selectedRows;
            } else {
                console.log('1 else -->', component.get("v.SelectedData")[pgN]);
                console.log('1 else -->', pgN);
                if (component.get("v.SelectedData")[pgN] == undefined) {
                    // compare list to display and selected rows
                    // den that compare with set value
                    var diff1 = [];
                    var diff2 = component.get('v.listToBeDisplayed');
                    var diff3 = component.get("v.setValue");
                    if (selectedRows != undefined && selectedRows.length > 0) {
                        for (var i = 0; i < diff3.length; i++) {
                            var found = false;
                            for (var j = 0; j < diff2.length; j++) {
                                if (diff2[j].Id == diff3[i].Id) {
                                    found = true;
                                    break;
                                }
                            }
                            if (!found) {
                                diff1.push(diff3[i]);
                            }
                        }
                        console.log('setvalue diff1 ^^^^^^^6 ', JSON.stringify(diff1));
                        diff1 = diff1.concat(selectedRows);
                        console.log('complete diff1 ^^^^^^^6 ', JSON.stringify(diff1));
                        if (diff1.length > 0) {
                            component.get("v.SelectedData")[pgN] = diff1;
                        }
                    } else {
                        console.log('set value --> ', component.get("v.setValue"));
                        console.log('sel data aaa --> ', component.get("v.SelectedData"));
                        var leftVal = component.get("v.setValue");
                        var sdd1 = component.get("v.SelectedData");
                        var diff = [];
                        var found = false;
                        for (var i = 0; i < leftVal.length; i++) {
                            found = false;
                            for (var check in sdd1) {
                                for (var d in sdd1[check]) {
                                    if (leftVal[i].Id === sdd1[check][d].Id) {
                                        found = true;
                                        break;
                                    }
                                }
                                if (found) {
                                    break;
                                }
                            }
                            if (!found) {
                                diff.push(leftVal[i]);
                            }
                        }
                        console.log('UUUUUUUUUUUUUUUU MMMMMMMMMMMM diff -->', JSON.stringify(diff));
                        //selectedRows = selectedRows.concat(diff);
                        //compare diff with list to display, remove display wala elements
                        var diffV = component.get('v.listToBeDisplayed');
                        var fDiff = [];
                        for (var i = 0; i < diff.length; i++) {
                            var found = false;
                            for (var j = 0; j < diffV.length; j++) {
                                if (diff[i].Id == diffV[j].Id) {
                                    found = true;
                                    break;
                                }
                            }
                            if (!found) {
                                fDiff.push(diff[i].Id);
                            }
                        }
                        if (fDiff.length > 0) {
                            component.get("v.SelectedData")[pgN] = fDiff;
                        }

                    }
                } else {
                    console.log('required to merge --->');
                    var difVal = [];
                    var leftVal = component.get("v.SelectedData")[pgN];
                    console.log('leftVal -->', JSON.stringify(leftVal));
                    console.log('selectedRows -->', JSON.stringify(selectedRows));
                    var found = false;
                    //if (selectedRows == undefined && selectedRows.length == 0) {
                    if (component.get("v.setValue") != undefined) {
                        var sv1 = component.get("v.setValue");
                        for (var i = 0; i < sv1.length; i++) {
                            found = false;
                            for (var j = 0; j < leftVal.length; j++) {
                                if (leftVal[j].Id === sv1[i].Id) {
                                    found = true;
                                    break;
                                }
                            }
                            console.log('sv1[i] -->', JSON.stringify(sv1[i]) + ' ----> ' + (!found));
                            if (!found) {
                                difVal.push(sv1[i]);
                            }
                        }
                    }
                    //}
                    console.log('some difVal ---> ', JSON.stringify(difVal));
                    if (selectedRows != undefined && selectedRows.length > 0) {
                        console.log('not sr undefiend leftVal -->', leftVal);
                        console.log('selectedRows -->', selectedRows);
                        difVal = difVal.concat(selectedRows);
                        //difVal = selectedRows;
                        console.log('inside some difVal ---> ', JSON.stringify(difVal));
                    }
                    debugger;
                    console.log('hereeeeeeeeeeeeeeeeeeeeeee -------------->', difVal);
                    component.get("v.SelectedData")[pgN] = difVal;
                }
            }
        } else {
            if (!this.isEmpty(component.get("v.SelectedData"))) {
                var leftVal = component.get("v.SelectedData")[pgN];
                if (selectedRows.length == 0) {
                    leftVal = selectedRows;
                }                
                console.log('leftVal -->', leftVal);
                var difVal = [];
                if (leftVal != undefined && leftVal.length > 0) {
                    if (component.get("v.setValue") != undefined && component.get("v.setValue").length > 0) {
                        var sv1 = component.get("v.setValue");
                        for (var i = 0; i < sv1.length; i++) {
                            for (var j = 0; j < leftVal.length; j++) {
                                if (leftVal[j].Id != sv1[i].Id) {
                                    console.log('sv -->', sv1[i]);
                                    difVal.push(sv1[i]);
                                }
                            }
                        }
                    }
                    console.log('@@@@@@@@22  difVal ---> ', JSON.stringify(difVal));
                    component.get("v.SelectedData")[pgN] = difVal;
                } else {
                    if (selectedRows.length == 0) {
                        // if its undefined
                        var sv1 = component.get("v.setValue");
                    	console.log('sv1 -->', sv1);
                    	console.log('list to display -->', JSON.stringify(component.get('v.listToBeDisplayed')));
                        console.log('selected data on that page -->', JSON.stringify(component.get("v.SelectedData")[pgN]));
						component.get("v.SelectedData")[pgN] = selectedRows;
                        var ld = component.get('v.listToBeDisplayed');
                        var sdData = component.get("v.SelectedData");
                        var fdata = [];
                        //for (var check in sdData) {
                            for (var c in sv1) {
                                var found = false;
                                for (var i = 0; i< ld.length; i++) {
                                    if (ld[i].Id == sv1[c].Id) {
                                        found = true;
                                        break;
                                    }
                                }
                                if (!found) {
                                    fdata.push(sv1[c]);
                                }
                            }
                        //}
                        console.log('if fdata ----> ' , JSON.stringify(fdata));
                        component.get("v.SelectedData")[pgN] = fdata;
                    } else {
                        // selected row has value
                        console.log('selected rows in else -->', selectedRows);
                    	console.log('list to display -->', JSON.stringify(component.get('v.listToBeDisplayed')));
                        var sdData = component.get("v.SelectedData");
                        console.log('1 selected data on that page -->', JSON.stringify(sdData));
                        console.log('2 selected data on that page -->', JSON.stringify(sdData[pgN]));
                        var sv1 = component.get("v.setValue");
                        console.log('2 selected page -->', JSON.stringify(sv1));
                        // combine selected data and selected rows
                        var ld = selectedRows;
                        component.get("v.SelectedData")[pgN] = selectedRows;
                        sdData = component.get("v.SelectedData");
                        var fdata = [];
                        for (var check in sdData) {
                            for (var c in sdData[check]) {
                                var found = false;
                                for (var i = 0; i< ld.length; i++) {
                                    if (ld[i].Id == sdData[check][c].Id && !found) {
                                        fdata.push(sdData[check][c]);
                                        found = true;
                                        break;
                                    }
                                }
                                if (!found) {
                                    fdata.push(sdData[check][c]);
                                }
                            }
                        }
                        console.log('else fdata ----> ' , JSON.stringify(fdata));
                        // compare disply list and set value, remove list display elemnets from set val
                        var diffArr1 = [];
                        var ld1 = component.get('v.listToBeDisplayed');
                        for (var i = 0; i<sv1.length; i++) {
                            var found = false;
                            for (var j = 0; j<ld1.length; j++) {
                                if (ld1[j].Id == sv1[i].Id) {
                                    found = true;
                                    break;
                                }
                            }
                            if (!found) {
                                diffArr1.push(sv1[i]);
                            }
                        }
                        console.log('else diffArr1 ----> ' , JSON.stringify(diffArr1));
                        if (diffArr1.length > 0) {
                            fdata = diffArr1.concat(fdata);
                        }
                        component.get("v.SelectedData")[pgN] = fdata;
                    }
                }
            }
        }

        console.log('################# "v.SelectedData") --> ', JSON.stringify(component.get("v.SelectedData")));

        // check for duplicate value if any
        var dupCheck = component.get("v.SelectedData");
        var arr = [];
        var arrId = [];
        var finalArr = [];
        for (var check in dupCheck) {
            for (var d in dupCheck[check]) {
                if (!arrId.includes((dupCheck[check][d].Id))) {
                    arr.push(dupCheck[check][d][component.get("v.lookupField")]);
                    arrId.push(dupCheck[check][d].Id);
                    finalArr.push(dupCheck[check][d]);
                }
            }
        }
        console.log('finalArr -----***** ', JSON.stringify(finalArr));
        
        // merge the search data into selected data
        var searchData = component.get("v.lstSelectedRecords");
        var dd = component.get("v.SelectedData");
        console.log('################# searchData --> ', searchData);
        console.log('SelectedData length -->', dd);
        if (finalArr.length == 0) {
            var sv1 = component.get("v.setValue");
            console.log('search data sv1 --> ', JSON.stringify(sv1));
            for (var c in sv1) {
                finalArr.push(sv1[c]);
            }
            console.log('search data finalArr -----***** ', JSON.stringify(finalArr));
        }
        if (searchData != undefined && searchData.length > 0) {
            var sData = [];
            var found = false;
            var lkUp = component.get("v.lookupField");
            for (var check in searchData) {
                console.log('dd -->', JSON.stringify(searchData[check]));
                var found = false;
                for (var i = 0; i < finalArr.length; i++) {
                    if (finalArr[i].Id == searchData[check].Id) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    sData.push(searchData[check]);
                }
            }
            console.log('sdata -->', JSON.stringify(sData));            
            if (sData.length > 0) {
                 finalArr = finalArr.concat(sData); 
            }            
        }
        console.log('after setSelectedValues SelectedData values --> ', JSON.stringify(finalArr));        
        
        var selValueEvent = component.getEvent("oSelectedRecordIdListEvent");
        //console.log('selValueEvent -->', selValueEvent);
        selValueEvent.setParams({
            "selectedValuesList": finalArr,
            "isLoadDone": false,
            "lookupField": component.get("v.lookupField")
        });
        selValueEvent.fire();

        //console.log('selValueEvent after fire -->', selValueEvent);
    },
    isEmpty: function(someVar) {
        for (var key in someVar) {
            //console.log('key------------------------------------------------------------------->', key);
            if (someVar.hasOwnProperty(key)) {
                return false;
            }
        }
        return true;
    },
    checkSdata: function(sDat, values) {
        console.log('sData -->', JSON.stringify(sDat));
        console.log('values -->', JSON.stringify(values));
        for (var i = 0; i < values.length; i++) {
            console.log('sDat[j] -->', sDat);
            console.log('values[i] -->', values[i]);
            if (sDat.Id == values[i].Id) {
                return false;
            }
        }
        return true;
    },
    getNextElementsHelper: function(component, event, helper) {
        var current = component.get("v.currentPage");
        component.set("v.prevPage", component.get("v.currentPage"));
        var dTable = component.find("dtId");
        var selectedRows = dTable.getSelectedRows();
        var pgName = current;
        console.log('1 n pgName -------------->', pgName);
        if (selectedRows != undefined && selectedRows.length > 0) {
            component.get("v.SelectedData")[pgName] = selectedRows;
        }
        current = current + 1;
        pgName = current;
        console.log('2 n pgName -------------->', pgName);
        var selectedRows = component.get("v.SelectedData")[pgName];
        //console.log('2 selectedRows -------------->', selectedRows);
        if (selectedRows == undefined) {
            //component.get("v.SelectedData")[pgName] = component.get("v.setValue");
            selectedRows = component.get("v.setValue");
            //component.set("v.setValue","");
        }
        component.set("v.currentPage", current);
        //console.log("Next SelectedData ---> " + JSON.stringify(component.get("v.SelectedData")));
        //console.log("Next selectedRows ---> " + selectedRows);
        var sObjectList = component.get("v.mydata");
        var end = component.get("v.endPage");
        // console.log('1 . next end -->', end);
        var start = component.get("v.startPage");
        //console.log('1 . next start -->', start);
        var pageSize = component.get("v.pageSize");
        //console.log('1 . next pageSize -->', pageSize);
        var Paginationlist = [];
        var counter = 0;
        //console.log('sObjectList -->', JSON.stringify(sObjectList));
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            //   console.log('i --->' + i + ' value -->', sObjectList[i]);
            if (sObjectList.length >= i && sObjectList[i] != undefined) {
                Paginationlist.push(sObjectList[i]);
                //console.log('1 . next sObjectList[i] -------------------->', sObjectList[i]);
            }
            counter++;
        }
        //console.log('counter -->' + counter);
        start = start + counter;
        end = end + counter;
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        //console.log('after next startPage-->', component.get("v.startPage"));
        //console.log('after next endPage-->', component.get("v.endPage"));
        component.set('v.listToBeDisplayed', Paginationlist);
        if (typeof selectedRows != 'undefined' && selectedRows) {
            var selectedRowsIds = [];
            for (var i = 0; i < selectedRows.length; i++) {
                selectedRowsIds.push(selectedRows[i].Id);
            }
            var dTable = component.find("dtId");
            //console.log('selectedRowsIds -->', selectedRowsIds);
            dTable.set("v.selectedRows", selectedRowsIds);
        }
    },
    getPreviousElementsHelper: function(component, event, helper) {
        var current = component.get("v.currentPage");
        component.set("v.prevPage", component.get("v.currentPage"));
        var dTable = component.find("dtId");
        var selectedRows = dTable.getSelectedRows();
        //console.log('selectedRows p -------------->', selectedRows);
        var pgName = current;
        console.log('1 p pgName -------------->', pgName);
        if (selectedRows != undefined && selectedRows.length > 0) {
            component.get("v.SelectedData")[pgName] = selectedRows;
        }
        current = current - 1;
        pgName = current;
        console.log('2 p pgName -------------->', pgName);
        var selectedRows = component.get("v.SelectedData")[pgName];
        component.set("v.currentPage", current);
        //console.log('current p -------------->', current);
        //console.log("Prev SelectedData ---> " + JSON.stringify(component.get("v.SelectedData")));
        var sObjectList = component.get("v.mydata");
        var end = component.get("v.endPage");
        //console.log('prev end -------------->', end);
        var start = component.get("v.startPage");
        //console.log('prev start -------------->', start);
        var pageSize = component.get("v.pageSize");
        //console.log('prev pageSize -------------->', pageSize);
        var Paginationlist = [];
        var counter = 0;
        for (var i = start - pageSize; i < start; i++) {
            if (i > -1) {
                Paginationlist.push(sObjectList[i]);
                //    console.log('1 . prev sObjectList[i] -------------------->', sObjectList[i]);
                counter++;
            } else {
                start++;
            }
        }
        //console.log('after prev counter -------------->', counter);
        start = start - counter;
        //console.log('after prev start -------------->', start);
        end = end - counter;
        //console.log('after prev end -------------->', end);
        component.set("v.startPage", start);
        component.set("v.endPage", end);
        component.set('v.listToBeDisplayed', Paginationlist);
        if (typeof selectedRows != 'undefined' && selectedRows) {
            var selectedRowsIds = [];
            for (var i = 0; i < selectedRows.length; i++) {
                selectedRowsIds.push(selectedRows[i].Id);
            }
            var dTable = component.find("dtId");
            dTable.set("v.selectedRows", selectedRowsIds);
        }
    },
    getParticularPageNumberHelper: function(component, event, helper) {
        var pagenumber = component.find("EnteredPageNumber").get("v.value");
        component.set("v.pagenumber", pagenumber);
        component.set("v.prevPage", component.get("v.currentPage"));
        console.log('prevPage --> ', component.get("v.prevPage"));
        component.set("v.currentPage", pagenumber);
        console.log('pagenumber --> ', pagenumber);
        console.log('myData --> ', component.get("v.mydata"));
        var pages = Math.ceil(component.get("v.mydata").length / component.get("v.pageSize"));
        console.log('pages --> ', pages);

        var dList = component.get("v.listToBeDisplayed");
        if (pagenumber == null || pagenumber == undefined || pagenumber > pages) {
            var totalPages = component.get("v.pages");
            //alert("Please enter number, which is less than or equal to " + pages);

            component.set("v.currentPage", 0);
            component.set("v.prevPage", component.get("v.currentPage"));
            // set star as 0
            component.set("v.startPage", 0);
            component.set("v.endPage", (component.get("v.pageSize")) - 1);
            component.set("v.pagenumber", null);
            this.showToast(component, "Message!", 'Please enter number, which is less than or equal to ' + pages, "sucess");
            return null;
        } else {
            component.set("v.page", pagenumber);
            var dTable = component.find("dtId");
            var showHowManyRecs = component.get("v.pageSize");
            var startElement = component.get("v.page") * showHowManyRecs;
            console.log('startElement -->', startElement);
            //console.log('1 startPage -->', component.get("v.startPage"));
            //console.log('1 endPage -->', component.get("v.endPage"));
            var tempValuesToShow = [];

            if (startElement > component.get("v.mydata").length) {
                var difference = startElement - component.get("v.mydata").length;
                //console.log('diff startElement -->', difference);
                //console.log('greater if -->', (startElement - showHowManyRecs));
                for (var i = (startElement - showHowManyRecs); i < startElement - difference ; i++) {
                    tempValuesToShow.push(component.get("v.mydata")[i]);
                } 
                component.set("v.startPage", (startElement - showHowManyRecs));
                if ((component.get("v.pageSize") + component.get("v.startPage")) > component.get("v.mydata").length) {
                    component.set("v.endPage", (component.get("v.mydata").length - 1));
                }
                component.set("v.endPage", (component.get("v.pageSize") + component.get("v.startPage") - 1));
            } else {
                //console.log(' else -->', (startElement - showHowManyRecs));
                for (var i = (startElement - showHowManyRecs); i < startElement; i++) {
                    tempValuesToShow.push(component.get("v.mydata")[i]);
                }
                component.set("v.startPage", (startElement - showHowManyRecs));
                component.set("v.endPage", (component.get("v.pageSize") + component.get("v.startPage") - 1));
            }

            var selectedRowsId1 = [];
            var selVal = component.get("v.selectedValues");
            console.log('selVal -->', selVal);
            var rw = dTable.getSelectedRows();
            console.log('dTable rw -->', rw);
            var setSD = [];
            var counter = 0;
            for (var i = 0; i < selVal.length; i++) {
                for (var j = 0; j < tempValuesToShow.length; j++) {
                    //console.log('counter --> ', counter);
                    if (selVal[i] != undefined && tempValuesToShow[j].Id == selVal[i].Id) {
                        selectedRowsId1.push(tempValuesToShow[j].Id);
                        break;
                    }
                }
                console.log('selVal[i] --> ', selVal[i]);
                if (selVal[i][counter] != undefined) {
                    setSD.push(selVal[i]);
                }
                counter++;
            }
            component.set("v.listToBeDisplayed", tempValuesToShow);
            if (rw != undefined && rw.length > 0) {
                console.log('inside rw -------------------------------------------------------------------------->', rw);
                console.log('prev -->', component.get("v.prevPage"));
                if (component.get("v.SelectedData")[component.get("v.prevPage")] != undefined && component.get("v.SelectedData")[component.get("v.prevPage")].length > 0) {
                    var pgSpecificData = component.get("v.SelectedData")[component.get("v.prevPage")];
                    for (var i = 0; i < pgSpecificData.length; i++) {
                        for (var j = 0; j < rw.length; j++) {
                            if (pgSpecificData[i].Id == rw[j].Id) {
                                rw.splice(j, 0);
                            }
                        }
                    }
                    console.log('1 inside rw -------------------------------------------------------------------------->', rw);
                    if (rw.length > 0) component.get("v.SelectedData")[component.get("v.prevPage")] = rw;
                } else {
                    console.log('else inside rw -------------------------------------------------------------------------->', rw);
                    component.get("v.SelectedData")[component.get("v.prevPage")] = rw;
                }
            }

            if (selectedRowsId1 != undefined && selectedRowsId1.length > 0) {
                dTable.set("v.selectedRows", selectedRowsId1);
                component.get("v.SelectedData")[pagenumber] = setSD;
            } else {
                var selectedRows1 = component.get("v.SelectedData");
                if (!this.isEmpty(selectedRows1)) {
                    var sdIds = [];
                    var sdData = [];
                    for (var c in selectedRows1) {
                        for (var d in selectedRows1[c]) {
                            sdIds.push(selectedRows1[c][d].Id);
                            sdData.push(selectedRows1[c][d]);
                        }
                    }
                    if (sdIds.length > 0) {
                        dTable.set("v.selectedRows", sdIds);
                        console.log('else SelectedData -------------------------------------pagenumber------------------------------------->', component.get("v.SelectedData")[pagenumber]);
                        component.get("v.SelectedData")[pagenumber] = sdData;
                    }
                }
            }
            console.log('selectedRowsId1 --> ', selectedRowsId1);
            console.log('setSD -->', JSON.stringify(setSD));
            console.log('getParticularPageNumberHelper selected Values -->', JSON.stringify(component.get("v.selectedValues")));

            console.log('getParticularPageNumberHelper selectedRows1 -->', JSON.stringify(selectedRows1));
            /*if (typeof selectedRows1 != 'undefined' && selectedRows1) {
                var selectedRowsIds = [];
                for (var i in selectedRows1) {
                    console.log('getParticularPageNumberHelper selectedRows1 i  -->', selectedRows1[i]);
                    for (var j in selectedRows1[i]) {
                        selectedRowsIds.push(selectedRows1[i][j].Id);
                    }
                }
            }
            console.log("getParticularPageNumberHelper selectedRowsIds ------------->", selectedRowsIds);
            
            if (selectedRowsIds != undefined && selectedRowsIds.length > 0) {
                dTable.set("v.selectedRows", selectedRowsIds);
            }*/
            console.log('final startPage -->', component.get("v.startPage"));
            console.log('final endPage -->', component.get("v.endPage"));

        }
    },
    fetchRelavantDataHelper: function(component, event, helper) {
        var dTable = component.find("dtId");
        var selectedRows = dTable.getSelectedRows();
        //console.log('fetchRelavantDataHelper selectedRows -------------------------------------------> ', selectedRows);
        //console.log('search str --> ', component.find("searchId").get("v.value"));
        var searchStr = component.find("searchId").get("v.value");
        if (searchStr == null || searchStr == undefined) {
            alert('Please enter search string.');
            return null;
        }
        //console.log('complete data --> ', component.get("v.currentPage"));
        //console.log('fetchRelavantDataHelper SelectedData values --> ', component.get("v.SelectedData"));
        var rec = component.get("v.mydata");
        component.set('v.tempAllRecord', component.get("v.mydata"));
        var filteredVal = [];
        //console.log('rec --> ', rec);
        for (var i = 0; i < rec.length; i++) {
            //console.log('rec --> ' + rec[i]);
            if (rec[i].Name === searchStr) {
                filteredVal.push(rec[i]);
            }
        }
        //console.log('filteredVal --> ', filteredVal);
        if (filteredVal.length > 0) {
            helper.resetPageDataLogic(component, filteredVal);
        }
    },
    resetPageDataLogic: function(component, temp) {
        //console.log('currentPage --> ', temp);
        var dTable = component.find("dtId");
        var selectedRows = dTable.getSelectedRows();
        console.log('cp --> ' + component.get("v.currentPage") + '--------------------' + component.get("v.pagenumber"));
        var pg = component.get("v.pagenumber");
        console.log('resetPageDataLogic selectedRows -------------------------------------------> ', selectedRows);
        if (selectedRows != null && selectedRows != undefined && selectedRows.length > 0) {
            console.log('1 selectedRows -------------------------------------------> ', JSON.stringify(component.get("v.SelectedData")[pg]));
            if (component.get("v.SelectedData")[pg] != undefined) {
                //component.get("v.SelectedData")[0].push(selectedRows);
                var qw = component.get("v.SelectedData")[pg];
                var flag = 0;
                var dt = null;
                for (var i in selectedRows) {
                    for (var j in qw) {
                        console.log('1 qw -------------------------------------------> ', qw[j].Id + '------------------> ' + selectedRows[i].Id);
                        if (qw[j].Id == selectedRows[i].Id) {
                            flag = 1;
                            break;
                        }
                    }
                    if (flag == 0) {
                        component.get("v.SelectedData")[pg].push(selectedRows[i].Id);
                    }
                }

            } else {
                component.get("v.SelectedData")[pg] = selectedRows;
            }
            //console.log('2 selectedRows -------------------------------------------> ', JSON.stringify(component.get("v.SelectedData")[0]));
        }
        console.log('3 selectedRows -------------------------------------------> ' + JSON.stringify(component.get("v.SelectedData")) + '----------------' + component.get("v.SelectedData").length);
        if (component.get("v.SelectedData") != null && component.get("v.SelectedData") != undefined) {
            var sw = component.get("v.SelectedData");
            var fv = [];
            for (var i in sw) {
                //console.log('sw[i] --->', sw[i]);

                for (var j in sw[i]) {
                    //console.log('sw[i][j] --->', sw[i][j]);
                    fv.push(sw[i][j].Id);
                }
            }
            if (fv.length > 0) {
                //console.log('fv -------->', fv);
                dTable = component.find("dtId");
                dTable.set("v.selectedRows", fv);
            }
            //debugger;
            //console.log('3 selectedRows -------------------------------------------> ', dTable.getSelectedRows());
        }
        component.set("v.page", 0);
        //component.set("v.myData", temp);
        component.set("v.total", temp.length);
        var showHowManyRecs = component.get("v.pageSize"); 
        var tempValuesToShow = []; 
        for (var showLimitRecs = 0; showLimitRecs < temp.length; showLimitRecs++) {
            tempValuesToShow.push(temp[showLimitRecs]);
            if (showLimitRecs ==  showHowManyRecs - 1) {
                break;
            }
        }
        var currentPageNumber = component.get("v.page") + 1;
        component.set("v.page", currentPageNumber);
        component.set("v.pages", Math.ceil(temp.length / showHowManyRecs));
        component.set("v.listToBeDisplayed", tempValuesToShow);
    },
    closeToast: function(component) {
        var toastTheme = component.find("toastTheme");
        $A.util.removeClass(toastTheme, "slds-theme--error");
        $A.util.removeClass(toastTheme, "slds-theme--success");
        this.showHideDiv(component, "customToast", false);
    },
    showToast: function(component, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type,
                "mode": "dismissible",
                "duration": "30000"
            });
            toastEvent.fire();
        } else {
            var toastTheme = component.find("toastTheme");
            $A.util.removeClass(toastTheme, "slds-theme--error");
            $A.util.removeClass(toastTheme, "slds-theme--success");
            if (type == 'error') {
                $A.util.addClass(toastTheme, "slds-theme--error");
            } else if (type == 'success') {
                $A.util.addClass(toastTheme, "slds-theme--success");
            }
            component.find("toastText").set("v.value", message);
            component.find("toastTtitle").set("v.value", title + ' ');
            this.showHideDiv(component, "customToast", true);
        }
    },
    showHideDiv: function(component, divId, show) {
        $A.util.addClass(component.find(divId), show ? "slds-show" : "slds-hide");
        $A.util.removeClass(component.find(divId), show ? "slds-hide" : "slds-show");
    },
    searchHelper: function(component, event, getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName': component.get("v.objectApiName"),
            'ExcludeitemsList': component.get("v.lstSelectedRecords"),
            'refernceNumber': component.get("v.refNumber")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse -->', storeResponse);
                // if storeResponse size is equal 0 ,display No Records Found... message on screen.                }
                if (storeResponse == null) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                    // set searchResult list with return value from server.
                }
                component.set("v.listOfSearchRecords", storeResponse);
                console.log('list of --> ', component.get("v.listOfSearchRecords"));
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
})