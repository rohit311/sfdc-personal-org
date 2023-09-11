({
	housekeepingstuffs : function(component, event, helper, response) {
        console.log( component.get('v.lineDetailRecordError') );
		var optsLineOpted = JSON.parse(response.LineOpted);        
                    var optsFeesPaid = JSON.parse(response.FeesPaid);
                    var optsLineFlag = JSON.parse(response.LineFlag);

                    var optsLO = [];    optsLO.push({label:'--None--', value: null});
                    var optsFP = [];    optsFP.push({ label: '--None--', value: null });
                    var optsLF = [];    optsLF.push({ label: '--None--', value: null });
                    
                    if (optsLineOpted)
                    {
                        for(var i =0; i< optsLineOpted.length; i++)
                        {
                            if (optsLineOpted[i])
                            {
                                optsLO.push({
                                    label : optsLineOpted[i],
                                    value : optsLineOpted[i]
                                });
                            }
                        }
                    }

                    if (optsFeesPaid) 
                    {
                        for (var i = 0; i < optsFeesPaid.length; i++) 
                        {
                            if (optsFeesPaid[i]) 
                            {
                                optsFP.push({
                                    label: optsFeesPaid[i],
                                    value: optsFeesPaid[i]
                                });
                            }
                        }
                    }
                    if (optsLineFlag) 
                    {
                        for (var i = 0; i < optsLineFlag.length; i++) 
                        {
                            if (optsLineFlag[i]) 
                            {
                                optsLF.push({
                                    label: optsLineFlag[i],
                                    value: optsLineFlag[i]
                                });
                            }
                        }
                    }
                    
                    component.find("lineDetailRecordHandler").reloadRecord();

                    component.set("v.optionsLineOpted" ,optsLO);
                    component.set("v.optionsFeesPaid",optsFP);
                    component.set("v.optionsLineFlag",optsLF);
                                        
                    
                    if(component.get("v.loanRecord.StageName")=='Moved To Finnone'){
                        component.set("v.isDisabled",true);
                    }
                    else{
                        component.set("v.isDisabled",false);
                    }
	}
})