({
    
    setDocLoader : function(component, event, helper) {
         var verType=component.find("VeriType").get('v.value');
       // alert('******'+component.get("v.WeakAccn.Id"));
		 component.set("v.parentId", component.get("v.WeakAccn.Id"));
        var locationArrayOld =[];
         var verRecordCount=0;
        var locationArray;
         component.set('v.isApplicable',true);
    var separators = [' ', '\n'];
        if(verType == 'Office'){
            if(component.get('v.isOfficeGeoavailable'))
             		locationArray=component.get("v.OfficelGeoLocation").split(new RegExp(separators.join('|')));
            else
                component.set('v.isApplicable',false);
            component.set('v.fileName','Office CPV verification ');
        }else if(verType == 'Residence'  && component.get('v.isResiGeoavailable')){
            if(component.get('v.isResiGeoavailable'))
            	locationArray=component.get("v.recidentialGeoLocation").split(new RegExp(separators.join('|')));
            else
                component.set('v.isApplicable',false);
            component.set('v.fileName','Residence CPV verification ');
        }else{
            verRecordCount=0;
        }
      
       // alert(component.get('v.isOfficeGeoavailable')+' ==>locationArray '+locationArray);
        console.log('rohit '+locationArray);
         if((verType == 'Office' || verType == 'Residence') && !$A.util.isEmpty(locationArray)){ 
       		 for(var i=0;i<locationArray.length;i++){
            		if(helper.checkDecimal(locationArray[i])){
                		locationArrayOld.push(locationArray[i]);
            		}
            		verRecordCount =(locationArrayOld.length)/2;
       		 }
         }      
      //  alert('verRecordCount '+verRecordCount+'  Old Array '+locationArrayOld);
        component.set('v.verRecordCount',verRecordCount);
                                         
    },
 	fetchLatLong : function(component, event, helper) {
       
	    var locationArrayOld =[];
        var locationArrayNew =[];
        var distance;
        var verType=component.find("VeriType").get('v.value');

         var locationArray;//23774 /22485
      
        var separators = [' ', '\n'];
        
       console.log('@@Swapnil@@@ office '+JSON.stringify(component.get("v.OfficelGeoLocation")));
         console.log('@@Swapnil@@@ recidentialGeoLocation' +JSON.stringify(component.get("v.recidentialGeoLocation")));
     
        if( !$A.util.isEmpty(component.get("v.OfficelGeoLocation")) && verType==='Office')//23774 /22485
        	 locationArray=component.get("v.OfficelGeoLocation").replace(/\n/g, " ").split('=').join(',').split('Lat').join('Long').split(' ');
        if( !$A.util.isEmpty(component.get("v.recidentialGeoLocation")) && verType==='Residence')//23774 /22485
        	 locationArray=component.get("v.recidentialGeoLocation").replace(/\n/g, " ").split('=').join(',').split('Lat').join('Long').split(' ');

           console.log('***recidentialGeoLocation '+locationArray+'  ===> '+locationArray.length);
         
        var locationNewArray=component.get("v.geoCoordintes1").replace(/\n/g, " ").split(new RegExp(separators.join('|')));
        
        
         console.log('***locationNewArray '+locationNewArray);
        if(locationArray != null){//23774 /22485 added null check
           
        for(var i=0;i<locationArray.length;i++){
            console.log('val ==> '+i);
            try{
                if(helper.checkDecimal(locationArray[i])){
                locationArrayOld.push(locationArray[i]+'');
               
                console.log('counting length '+locationArrayOld.length+' '+i+' '+locationArray[i]);
                }
            } catch(err){
                    alert(err.message);
                }
           
        }
          
        }
         for(var i=0;i<locationNewArray.length;i++){
            if(helper.checkDecimal(locationNewArray[i])){
                console.log(' new array Index '+i+' val'+ locationNewArray[i]);
                locationArrayNew.push(locationNewArray[i]);
                
            }
           
        }
        
      
        console.log('Lat Long List '+component.get('v.geoCoordintes1'));
        console.log('Calculate distance  '+component.get('v.fileNumber')+'  @@@   '+locationArrayOld+'  '+locationArrayOld.length);
        
        if(component.get('v.fileNumber') == 'ImageOne' && locationArrayOld.length >=2){
           // console.log('File 1 '+locationArrayOld[0]+' @@ '+locationArrayOld[1]+' @@ '+locationArrayNew[0]+' @@ '+locationArrayNew[1]);
            distance=helper.calcDistance(component,event,locationArrayOld[0],locationArrayOld[1],locationArrayNew[0],locationArrayNew[1]);
        }else if(component.get('v.fileNumber') == 'ImageTwo'){
           // console.log('File 2 '+locationArrayOld[2]+' @@ '+locationArrayOld[3]+' @@ '+locationArrayNew[0]+' @@ '+locationArrayNew[1]);
             if($A.util.isEmpty(locationArrayOld[2])||($A.util.isEmpty(locationArrayOld[3]))){
                distance=1000.00;
            }else
            	distance=helper.calcDistance(component,event,locationArrayOld[2],locationArrayOld[3],locationArrayNew[0],locationArrayNew[1]);
               
        }else if(component.get('v.fileNumber') == 'ImageThree'){
            console.log('File 3 '+locationArrayOld[4]+' @@ '+locationArrayOld[5]+' @@ '+locationArrayNew[0]+' @@ '+locationArrayNew[1]);
            if($A.util.isEmpty(locationArrayOld[4]) ||($A.util.isEmpty(locationArrayOld[5]))){
                distance=1000.00;
            }else
            	distance=helper.calcDistance(component,event,locationArrayOld[4],locationArrayOld[5],locationArrayNew[0],locationArrayNew[1]);
        }
       
      console.log('Final Distance is '+distance);  
      console.log('Opp id '+component.get("v.oppId")+'  result '+distance+'  VerType '+verType+' ImageNo'+component.get('v.fileNumber'));
        helper.executeApex(component,"saveResult",
                           {"OppId":component.get("v.oppId"),
                            "result" :distance+';'+locationArrayNew[0]+';'+locationArrayNew[1],
                            "verType" : verType,
                            "ImageNo" : component.get('v.fileNumber')
                           },function(error, result){
                if(!error && result){
                    
                  var data = JSON.parse(result);
                    console.log('data '+data);
                  //component.set('v.WeakAccn',data);
                  console.log('Result here '+JSON.stringify(component.get('v.WeakAccn')));
               
            			
           				 var getResult =$A.get("e.c:getAuditResult");
            			console.log('getResult'+getResult);
              			getResult.fire();
                                   
                }    
                
                
            });
	},
    save : function(component, event, helper) {
        console.log('in checklist insert event');
        //helper.showhidespinner(component,event,true);
        
        var checklistInsertEvent = $A.get("e.c:checklistInsertEvent");
      //  alert(component.get("v.parentId"));
        checklistInsertEvent.setParams({ 
            "checklistId": component.get("v.parentId"),
            "selectFileErrorFlag": false
        });
        checklistInsertEvent.fire();
        
      
    },
    doInit : function(component, event, helper) {
        //component.set("v.latLongMap",new Map());
        console.log(component.get("v.verifList"));
        component.set("v.parentId",component.get("v.WeakAccn.Id"));
       
    }
})