({
    doInit : function(component, event, helper) {
        
    },
    
    fetchFifteenDays:function(component, event, helper) {
        component.set('v.selectedRadio','15');
    }, 
    fetchThirtyDays:function(component, event, helper) {
        component.set('v.selectedRadio','30');
    },
    fetchLastMonth :function(component, event, helper) {
        //logic for last month                          
        var today= new Date().getDate();
        console.log(today);
        if(1<=today && today<=5)
        {
            var now_month=new Date().getMonth();
            var fromDate=now_month-2;
            var toDate= now_month-1;
            var now_year=new Date().getFullYear();
            var start = new Date(now_year, fromDate,6, 0, 0, 0, 0);
            var stop = new Date(now_year, toDate,5, 0, 0, 0, 0);
            console.log('start Date'+start);
            console.log('stop date '+stop );
            
        }
        if(6<=today && today<=31)
        {
            var now_month=new Date().getMonth();	
            var fromDate=now_month-1;
            var toDate= now_month;
            var now_year=new Date().getFullYear();
            var start = new Date(now_year, fromDate,6, 0, 0, 0, 0);
            var stop = new Date(now_year, toDate,5, 0, 0, 0, 0);
            console.log('start Date2 '+start);
            console.log('stop date2 '+stop );
            
        }
        
        //parsing from and To Date in string
        var dd = start.getDate();
        var mm = start.getMonth()+1; //January is 0!
        
        var yyyy = start.getFullYear();
        if(dd<10){
            dd='0'+dd;
        } 
        if(mm<10){
            mm='0'+mm;
        } 
        var startDate = mm+'/'+dd+'/'+yyyy;  //month-day-year format
        console.log(startDate);
        
        var dd = stop.getDate();
        var mm = stop.getMonth()+1; //January is 0!
        
        var yyyy = stop.getFullYear();
        if(dd<10){
            dd='0'+dd;
        } 
        if(mm<10){
            mm='0'+mm;
        } 
        var stopDate = mm+'/'+dd+'/'+yyyy;
        console.log(stopDate);
        //logic for last month    End                      
        
        
        var StringToPass = startDate+';'+stopDate;
        component.set('v.selectedRadio',StringToPass);    
    },
    
    fetchProductOfferings:function(component, event, helper) {
        // console.log(component.find('    radioValue').get('v.value'));
        /*     var refEvent = $A.get("e.c:referradDashboardSearch");
                refEvent.setParams({
                    "searchLimit": "15"
                });
                refEvent.fire();*/
        //console.log('RADIO IS '+component.find('radioValue').get('v.value'));
        console.log(component.get('v.selectedRadio'));
        
        
        $A.createComponent(
            "c:ReferralDashboardTable",{"selectedRadio":component.get("v.selectedRadio")},
            function(newComponent){
                component.set("v.body",newComponent);
                
            }
        ) 
    },
})