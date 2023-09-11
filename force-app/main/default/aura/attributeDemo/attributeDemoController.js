({
    saveRec: function(component,event,helper){
      console.log("save Button Is click");
      var RecordData=component.get("v.customerObj");
      console.log('RecordData',JSON.parse(JSON.stringify(RecordData)));
  },

  doInit : function(component, event, helper) {
    //console.log(component.get("v.pageReference").state.c__param);
  }
})
