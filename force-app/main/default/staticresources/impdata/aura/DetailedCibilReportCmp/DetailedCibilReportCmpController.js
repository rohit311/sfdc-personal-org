({
	toggleAssVersion : function(component, event, helper)
    {
       
        var click=event.target.getAttribute('id');
        component.set('v.itrId',click);
        
        var cls=component.get('v.class') ;
        if(cls=='hideCls'){
            component.set("v.class", 'showCls');
           
            
        }else{
            component.set("v.class", 'hideCls');
        }        
    },
    displayValue : function(component, event, helper){
        console.log(event.target.id);
        var evtId = event.target.id;
        var valdiv = document.getElementById(evtId+"_value");
        
        if(document.getElementById(evtId).innerHTML != null && document.getElementById(evtId).innerHTML != '' && document.getElementById(evtId).innerHTML.includes('+')){
            document.getElementById(evtId).innerHTML = '-&nbsp;&nbsp;&nbsp;';
        }
        else{
            document.getElementById(evtId).innerHTML = '+&nbsp;&nbsp;&nbsp;';
        }
        
        if (valdiv.style.display === "none") {
    		valdiv.style.display = "block";
  		} else {
    		valdiv.style.display = "none";
  		}
    }
})