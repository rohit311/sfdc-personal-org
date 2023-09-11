({
    doInit : function(component, event, helper) {
       
        var page = component.get("v.page") || 1;
     
        helper.getData(component, event);
    },
    displayValue :function(component, event, helper) {
        
        console.log(event.target.id);
        var evtId = event.target.id;
        var tagValue = document.getElementById(evtId).value;                        
        var valEmaildiv = document.getElementById(evtId+"_Email");
        var valPaydiv =  document.getElementById(evtId+"_pay");
        var valIddiv = document.getElementById(evtId+"_leadId");
        var valProddiv =  document.getElementById(evtId+"_prod");
        var valInsdiv = document.getElementById(evtId+"_insId");
        
        if(document.getElementById(evtId).innerHTML != null && document.getElementById(evtId).innerHTML != '' && document.getElementById(evtId).innerHTML.includes('+')){
            document.getElementById(evtId).innerHTML = '-';
        }
        else{
            document.getElementById(evtId).innerHTML = '+';
        }
        
        if (valEmaildiv.style.display === "none") {
            
            valEmaildiv.style.display = "block";
            valPaydiv.style.display = "block";
            valIddiv.style.display = "block";
            valProddiv.style.display = "block";
            valInsdiv.style.display = "block";
        } else {
            valEmaildiv.style.display = "none";
            valPaydiv.style.display = "none";
            valIddiv.style.display = "none";
            valProddiv.style.display = "none";
            valInsdiv.style.display = "none";
        }
    },
    submitAndMakePaymt : function(component, event, helper) {
        console.log('lead Id '+event.target.id);
        var leadId = event.target.id; 
        var paginationList = component.get("v.PaginationList");
        for(var i =0;i<paginationList.length;i++){
            
            if(leadId === paginationList[i].leadId){                
                component.set("v.leadWrp",paginationList[i]);
                break;
            }
        }
    	helper.submitAndPay(component, event);    
    },
    filterdata : function(component, event, helper) {
        var leadLst = component.get("v.Leadlst");
        var mobNo =  component.get("v.filter");
        var results = leadLst;
        var regex = new RegExp(mobNo);
        console.log('leadLst size '+results.length);
        results = leadLst.filter(row=>regex.test(row.mobNo));  
        console.log('result size '+results.length);
        component.set("v.filteredData",results);
        helper.setPagedData(component, event);
    },  
    next : function(component, event){
        var sObjectList = component.get("v.filteredData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= end ; i<end+pageSize; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")+1);
    },
    
    previous : function(component, event){
        var sObjectList = component.get("v.filteredData");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        // component.set("v.sortAsc",false);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set("v.currentPage",component.get("v.currentPage")-1);
    },
    onCrossButton : function(component,event,helper)
    {
        var modalname = component.find("dashboardModel");
        $A.util.removeClass(modalname, "slds-show");
        $A.util.addClass(modalname, "slds-hide");
    },
    gotoFirst : function(component,event,helper){
        var currentPage = component.get("v.currentPage");
        var firstPage = component.get('c.previous');
        
        for(var i=0;i<currentPage-1;i++){
            
            $A.enqueueAction(firstPage);
        }
        

    },
    gotoLast : function(component,event,helper){
        var currentPage = component.get("v.currentPage");
        var totalPages = component.get("v.totalPages");
        
         var lastPage = component.get('c.next');
        
        for(var i=currentPage;i<totalPages;i++){
            
            $A.enqueueAction(lastPage);
        }
        
        
    },
    toggleAssVersion : function(component, event, helper)
    {
        console.log(event.target.getAttribute('id'));
        var click=event.target.getAttribute('id');
        console.log('click'+click);
        component.set('v.myid',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
})