({       
    pageskus : function(component, page) {
        var totalRecs=component.get("v.TotalRecords");	
        var recordToDisply = component.get("v.pagesize");
        var total = totalRecs.length;
        var pages = Math.ceil(total / recordToDisply) ;
        var offset= (page-1)*recordToDisply;
        var pageRec = [];
        
        for(var i=offset;i<(total<(page*recordToDisply) ? total:page*recordToDisply);i++)
        {
            pageRec.push(totalRecs[i]); 
        }
        component.set("v.PageRecords",pageRec);
        component.set("v.page", page);
        component.set("v.total", total);
        component.set("v.pages", pages);
        
        var pnums = []; 
        var noOfPages=pages<10?pages:10;
        for(var i=1;i<=noOfPages;i++){
            pnums.push(i);
        }
        component.set("v.pagenumbers",pnums);
    },
    
})