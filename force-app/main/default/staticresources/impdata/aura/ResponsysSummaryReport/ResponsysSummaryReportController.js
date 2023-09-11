({
    onInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: '#', fieldName: 'SrNum', type: 'number'},
            {label: 'Product', fieldName: 'product', type: 'text'},
            {label: 'Total Disbursed', fieldName: 'ApplCnt', type: 'number'},
            {label: 'Mandatory Customer Communication', fieldName: 'MandCnt', type: 'number'},
            {label: 'Correct App Count', fieldName: 'CorrectCnt', type: 'number'},
            {label: 'Incorrect App Count', fieldName: 'InCrrCnt', type: 'number'},
            {label: 'Total SMS Sent', fieldName: 'TotalSms', type: 'number'},
            {label: 'Responsys', fieldName: 'ResponsysSms', type: 'number'},
            {label: 'ValueFirst', fieldName: 'ValueFirst', type: 'number'}
        ]);
    },
    poplData : function(component, event, helper){
        console.log('in handler');
        component.set("v.data",event.getParam("RespData").wrapList);
        console.log(component.get("v.data"));
        component.set("v.IncorrAppl",false);
    },
    onClickLink : function(component, event, helper){
        console.log('--> '+event.target.id); 
        var clickedId = event.target.id;
        var product = clickedId.split("|");
        var data = component.get("v.data");
        var selProd = new Object();
        
        for(var i =0;i<data.length;i++){
            if((product[0] === data[i].product) && data[i].InCrrCnt >0){
                selProd = data[i];
            }
        }
        
        if(selProd.product != undefined && selProd.product != null && selProd.inCorrList != undefined && selProd.inCorrList.length >0){
            component.set("v.selProd",product);
            component.set("v.inCorrList",selProd.inCorrList);
             component.set("v.IncorrAppl",true);
        }
        else{
            component.set("v.IncorrAppl",false);
        }
        console.log('--> '+selProd.inCorrList);
        
    }
})