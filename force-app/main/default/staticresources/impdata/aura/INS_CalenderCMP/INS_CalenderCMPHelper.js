({
    loadDataToCalendar :function(component,data){
        //alert('Inside loaddatatocalendar');
        //Find Current date for default date
        var d = new Date();
        var month = d.getMonth()+1;
        var day = d.getDate();
        var currentDate = d.getFullYear() + '/' +
            (month<10 ? '0' : '') + month + '/' +
            (day<10 ? '0' : '') + day;
        var self = this;
        $('#calendar').fullCalendar({
            height: 450,
            
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            selectable : true,
            defaultDate: currentDate,
            editable: true,
            eventLimit: true,
            events:data,
            dragScroll : false,
            droppable: true,
            weekNumbers : true,
            displayEventTime: true,
            eventDrop: function(event, delta, revertFunc) {
                
                alert(event.title + " was dropped on " + event.start.format());
                
                if (!confirm("Are you sure about this change?")) {
                    revertFunc();
                }
                else{
                    var eventid = event.id;
                    var eventdate = event.start.format();
                    self.editEvent(component,eventid,eventdate);
                }
                
            },
            eventClick: function(event, jsEvent, view) {
                //component.set("v.openCustDetails", true);
                
                var mapData = component.get("v.objMap");
                var customerMap=mapData['Customer'];
                console.log('customerMap ::' + JSON.stringify(customerMap));
                
                var customerKeys = [];
                var customerID;
                for(var key in customerMap){
                    customerKeys.push(key);
                }
                for(var i=0 ; i<customerKeys.length; i++){
                    if(customerKeys[i] == event.WhatId){
                      customerID = customerMap[customerKeys[i]];
                        /*var editRecordEvent = $A.get("e.force:editRecord");
                        editRecordEvent.setParams({
                            "recordId": customerID
                        });
                        editRecordEvent.fire();*/
                    }
                    
                }
             
                var paramJSON ={};
                paramJSON.tabId = 'cust_intr_btn';
                paramJSON.recId = customerID;
                paramJSON.objType = 'cust';
                paramJSON.calledFrm = 'CalendarCMP';
                
                console.log('paramJSON :::' + JSON.stringify(paramJSON));
                component.set("v.childParam",paramJSON);
                 component.set("v.showCalendarCmp", false);
                component.set("v.openCustDetails", true);
                
            },
            dayClick :function(date, jsEvent, view) {
                
                var datelist = date.format().toString().split('-');
                
                var datetime = new Date(datelist[0],parseInt(datelist[1])-1,parseInt(datelist[2])+1,0,0,0,0);
                
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Event",
                    "defaultFieldValues": {
                        'StartDateTime' :  datetime
                        
                    }
                });
                createRecordEvent.fire();
            },
            
            eventMouseover : function(event, jsEvent, view) {
                
            }
        });
    },
    convertJSDateTimeToStringAmPmTime: function(dateVal){
        var hours = dateVal.getHours();
        var minutes = dateVal.getMinutes();
        var ampm = hours >= 12 ? 'pm' : 'am';
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        minutes = minutes < 10 ? '0' + minutes : minutes;
        var strTime = (dateVal.getMonth() + 1) + '/' + dateVal.getDate() + '/' + dateVal.getFullYear() + ' ' + hours + ':' + minutes + ' ' + ampm;
        return strTime;
    },
   
    formatFullCalendarData : function(component,Data) {
        
        var josnDataArray = [];
        var profArr = ['Partner Insurance Telecaller', 'Insurance Telecaller'];
        component.set("v.objMap",Data);
        var mapData = component.get("v.objMap");
        var eventMap=mapData['EventData'];
        var profileMap = mapData['ProfileData'];
        console.log('profileMap ::' + JSON.stringify(profileMap));
        var Description;
        for(var key in  eventMap){
            var singleEvent=eventMap[key];
            var ProfileName = profileMap[singleEvent['OwnerId']];
            console.log('ProfileName ::' + ProfileName);
            console.log('evt.OwnerId :::' + singleEvent['OwnerId']);
            
            if(!singleEvent['Description'])
                singleEvent['Description'] = '';
          
            /*if(profArr.indexOf(ProfileName) == -1)
                Description = 'Profile :'+ profileMap[singleEvent['OwnerId']] + '-' + singleEvent['Description'] ;
            else
                Description = 'CC :'+ profileMap[singleEvent['OwnerId']] + '-' + singleEvent['Description'] ;
			*/
            if(profArr.indexOf(ProfileName) == -1)
                Description = singleEvent['Description'];
            //Description = 'Profile :'+ profileMap[singleEvent['OwnerId']] + '-' + singleEvent['Description'] ;
            else
                Description = 'CC :' + singleEvent['Description'] ;
            //Description = 'CC :'+ profileMap[singleEvent['OwnerId']] + '-' + singleEvent['Description'] ;
            
            var WhatId = singleEvent['WhatId'];
            var startdate = new Date(singleEvent['StartDateTime']);
            var strTime = this.convertJSDateTimeToStringAmPmTime(startdate);
           
            startdate = strTime;
            console.log('startdate ::' + startdate);
            var enddate = singleEvent['EndDateTime'];
            var Id = singleEvent['Id'];
            josnDataArray.push({
                'title':Description,
                'start':startdate,
                'end':enddate,
                'id':Id,
                'WhatId':WhatId
                
            });
        }
        return josnDataArray;
    },
    
    fetchCalenderEvents : function(component) {
        var action=component.get("c.fetchCalenderData");
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data= response.getReturnValue();
                console.log('data:::'+JSON.stringify(data));
                var josnArr = this.formatFullCalendarData(component,data);
                this.loadDataToCalendar(component,josnArr);
                
            } else if (state === "ERROR") {
                
            }
        });
        
        $A.enqueueAction(action);
        
    }, 
    
    editEvent : function(component,eventid,eventdate){
        var action=component.get("c.updateEvent");
        
        action.setParams({ eventid : eventid ,
                          eventdate : eventdate});
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                
            } else if (state === "ERROR") {
                
            }
        });
        
        $A.enqueueAction(action);
        
    },
    backToHomeHelper: function(component, event, helper){
        component.set("v.showCalendarCmp",false);
        var compEvent = component.getEvent("INSHomePgEvent");
        var evtParam = {};
        evtParam.homeFlag = true;
        compEvent.setParams({"HomeEventParam" : evtParam });
        compEvent.fire();  
    }
})