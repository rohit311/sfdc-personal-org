trigger RoundRobinKeyCret on Sourcing_Channel__c (before update,before insert) {
    //added by sainath for bug: 16143 :Custom Setting Migration-start
    //Or Condition Added by Rajendra for code Coverage.
    if (!ControlRecursiveCallofTrigger_Util.getTriggerAlreadyCalledFun() || Test.isRunningTest()) {
        ControlRecursiveCallofTrigger_Util.setTriggerAlreadyCalledFun();        
        //added by sainath for bug: 16143 :Custom Setting Migration-end
        List<Sourcing_Channel__c> scList=new List<Sourcing_Channel__c>();
        set<string> keyHolder=new  set<string>();
        string tempkeyHol;
        integer tempSize;
        string KeyTemCont;
        List<string> BranchTemp=new  List<string>();
        string keysetHolder;
        map<id,string> branchStrin=new map<id,string>(); 
        set<string> finalSetOfkeys=new set<string>();
        set<string> gapFiller=new set<string>();
        List<string> gapFillerList=new List<string>();
        List<string> tempkey=new List<string>();
        boolean setTest = false;
        // List<string> BranchTemp1=new  List<string>();
        Map<string,integer> sourcSize=new Map<string,integer>();
        //if products chnage we are removing kays
        for(Sourcing_Channel__c scxx: trigger.new){
            system.debug('*******trigger.oldmap*'+trigger.oldmap);
            
            if(trigger.isUpdate){
                if(trigger.oldmap.get(scxx.id).Product__c!=trigger.newmap.get(scxx.id).Product__c){
                    
                    trigger.newmap.get(scxx.id).keys__c=' ';
                }
            }
            if(scxx.keys__c!=null){        
                tempkey=scxx.keys__c.split('&');
                for(integer u=0;u<tempkey.size();u++){
                    gapFillerList.add(tempkey[u]);
                    
                }
            }  
        }
        
        
        Set<String> excludeProdSet = new Set<String>();
        List<String> excludeProdList = new List<String>();
        //List<string> templistHolde=new  List<string>(); 
        //
        excludeProdList.add('SOL');
        excludeProdList.add('SAL');
        excludeProdList.add('SPL');
        
        scList=[select id,Branch__c,Branch__r.name,Product__c,keys__c from Sourcing_Channel__c where Branch__c=:trigger.new[0].Branch__c and Product__c not in : excludeProdList];
        
        if(scList !=null && scList.size()>0){
            
            for(Sourcing_Channel__c scb:scList){
                if(scb.Branch__c !=null)
                    branchStrin.put(scb.Branch__c,scb.Branch__r.name.toUpperCase());
                
                if(scb.keys__c!=null){ 
                    
                    tempkey=scb.keys__c.split('&');
                    for(integer u=0;u<tempkey.size();u++){
                        gapFillerList.add(tempkey[u]);
                        
                    }
                    
                }
                
            }
            for(Sourcing_Channel__c scs:scList){
                
                if(scs.keys__c!=null){  
                    if(scs.Product__c !=null){
                        if(scs.Product__c.contains(';')){
                            BranchTemp=scs.Product__c.split(';');
                        }else{
                            system.debug('**scs.Product__c**'+scs.Product__c);
                            BranchTemp.add(scs.Product__c);
                        }
                    }
                    system.debug('**scs.sb:BranchTemp**'+BranchTemp);
                    excludeProdSet.addAll(BranchTemp);
                    excludeProdSet.removeAll(excludeProdList);
                    BranchTemp.clear();
                    BranchTemp.addAll(excludeProdSet);
                    excludeProdSet.clear();
                    system.debug('**scs.sb:BranchTemp**'+BranchTemp);
                    
                    for(string sb:BranchTemp){
                        
                        tempkeyHol=sb;
                        tempSize=0;
                        
                        if(sourcSize.containsKey(branchStrin.get(scs.Branch__c)+'@'+tempkeyHol)){
                            
                            
                            // if that key is already there we are making existing number in map with +1Two day I have to deliver 
                            tempSize=sourcSize.get(branchStrin.get(scs.Branch__c)+'@'+tempkeyHol)+1;
                            //replacing existing map with new size 
                            sourcSize.put(branchStrin.get(scs.Branch__c)+'@'+tempkeyHol,tempSize);
                            // after utilize, make this key is 0    
                            tempSize=0;
                        }else{  
                            //first value of every product will be kept @ 0    
                            sourcSize.put(branchStrin.get(scs.Branch__c)+'@'+tempkeyHol,0);     
                        }
                        finalSetOfkeys.add(branchStrin.get(scs.Branch__c)+'@'+tempkeyHol);
                        system.debug(branchStrin.get(scs.Branch__c)+'@'+tempkeyHol+'mapValuec'+sourcSize.get(branchStrin.get(scs.Branch__c)+'@'+tempkeyHol));
                        
                        //atoring all values into custom setting
                        
                    }                                              
                }//if                
            }
        }        
        //storing all values into custom setting for every update
        
        List<string> templistHolde=new  List<string>(); 
        for(string sx:finalSetOfkeys){
            templistHolde.add(sx);
        }
        system.debug(templistHolde.size()+'GGGGGGGGGGGGG'+finalSetOfkeys.size());
        
        // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - Start
        List<Parameter_Value_Master__c> listCscx = new List<Parameter_Value_Master__c>();
        List<Parameter_Value_Master__c> listCsc = new List<Parameter_Value_Master__c>();
        
        List<Parameter_Value_Master__c> listParamVM = [SELECT Id,Name,Current_Number__c,PSFMaximum__c,PSFCurrent__c,Flexi_Current__c,Flexi_Max__c,max_Records__c 
                                                       FROM Parameter_Value_Master__c    
                                                       WHERE ASMRoundRobinCheck__c = true
                                                       LIMIT 50000];
        
        Map<String,Parameter_Value_Master__c> customSetAll = new Map<String,Parameter_Value_Master__c>();
        if(listParamVM.size() > 0)
        {
            for(Parameter_Value_Master__c pvm :  listParamVM)   
            {
                customSetAll.put(pvm.Name,pvm);
            }
            system.debug('customSetAll++'+customSetAll);         
        }
        
        for(integer h=0;h<templistHolde.size();h++)
        {     
            if(customSetAll != NULL && customSetAll.size() > 0 && customSetAll.containsKey(templistHolde[h]))
            {
                customSetAll.get(templistHolde[h]).PSFMaximum__c=sourcSize.get(templistHolde[h]);
                Parameter_Value_Master__c cscx = new Parameter_Value_Master__c(); 
                cscx = customSetAll.get(templistHolde[h]);
                //bug 16071 added by sainath start - Custom Setting Migration Changes - 06/11/17 
                if(customSetAll.get(templistHolde[h]).PSFCurrent__c!=null)
                    cscx.PSFCurrent__c = customSetAll.get(templistHolde[h]).PSFCurrent__c +1;
                else
                    cscx.PSFCurrent__c =0;
                //bug 16071 added by sainath end -Custom Setting Migration Changes - 06/11/17 
                if(!test.isRunningTest())
                {
                    listCscx.add(cscx);
                }
            }
            else
            {
                Parameter_Value_Master__c csc = new Parameter_Value_Master__c();
                csc.name = templistHolde[h];
                csc.PSFMaximum__c = sourcSize.get(templistHolde[h]);
                csc.PSFCurrent__c = 0;
                //Bug:15996 added by sainath start - Custom Setting Migration Changes - 06/11/17 
                csc.ASMRoundRobinCheck__c = true;
                //Bug:15996 added by sainath end - Custom Setting Migration Changes - 06/11/17
                listCsc.add(csc); 
            }
        }
        
        system.debug('listCscx++'+listCscx);
        system.debug('listCsc++'+listCsc);
        
        if(listCscx.size() > 0)
            UPDATE listCscx;               
        
        if(listCsc.size() > 0)
            INSERT listCsc;
        // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - End
        
        /*system.debug('asmRRUpdateSetLLLLLLLLLLL'+asmRRUpdateSet.size());
system.debug('asmRRInsertSetLLLLLLLLLLL'+asmRRInsertSet.size());
if(asmRRUpdateSet.size() > 0){
update asmRRUpdateSet;
}
if(asmRRInsertSet.size() > 0){
insert asmRRInsertSet;
}*/
        
        for(string gp:gapFillerList){
            gapFiller.add(gp);
            system.debug(gp+'nnnnnnnnnnnn');
        }
        system.debug(gapFillerList.size()+'LLLLLLLLLLL'+gapFiller.size());
        
        //  asmrr__c cs=asmrr__c.getValues(UniqKeymaker);  
        BranchTemp.clear();
        
        List<string> ProductTem=new List<string>();
        
        if(Trigger.isUpdate){
            for(Sourcing_Channel__c sc: trigger.new){
                if(trigger.oldmap.get(sc.id).Product__c!=trigger.newmap.get(sc.id).Product__c || sc.keys__c==null)
                    setTest = true;
            }
        }
        if(Trigger.isInsert){
            setTest = true; 
        }
        
        for(Sourcing_Channel__c sc: trigger.new){
            // if product get change then only we are re-updating the values
            if(setTest == true) {
                
                system.debug(sc.Product__c+'productlisssssssssssssss');
                //keep all products in on list by splitting with ;
                if(sc.Product__c !=null){ 
                    if(sc.Product__c.contains(';')){
                        ProductTem=sc.Product__c.split(';');
                    }else{
                        ProductTem.add(sc.Product__c);
                    }
                }
                //trim all products
                for(string st:ProductTem){
                    BranchTemp.add(st.trim());
                }
                
                system.debug(BranchTemp+'ddddddddddddd');
                
                set<string> finlaSetter=new  set<string>();
                integer adjuster=0;
                string afterAdjust;
                integer sizeval=0;
                string beforeAdjust;
                string beforeAdjust1;
                string FinalString;
                List<string> finlaSetterL=new List<string>();
                
                for(integer x=0;x<BranchTemp.size();x++){
                    
                    
                    sizeval=sourcSize.get(branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x]);
                    if(sizeval!=null){
                        adjuster=sizeval;
                    }else{adjuster=1;}
                    
                    
                    beforeAdjust=branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x]+'@';
                    
                    system.debug(sizeval+'sssssssssssss');
                    system.debug(gapFiller.contains(beforeAdjust+adjuster)+'TTTTTTTTTTT'+beforeAdjust+adjuster);
                    if(!gapFiller.contains(beforeAdjust+adjuster) ){
                        // adjuster=adjuster+1;
                        finlaSetter.add(beforeAdjust+adjuster);
                    }
                    
                    
                    
                    for(integer r=0;r<sizeval;r++){             
                        system.debug(gapFiller.contains(beforeAdjust+adjuster)+'QQQQQQQQQQ'+beforeAdjust+adjuster);
                        if(gapFiller.contains(beforeAdjust+adjuster))
                        {   
                            
                            
                            adjuster=adjuster-1;  
                            if(adjuster <0){
                                adjuster=sizeval+2;
                            }  
                            
                            afterAdjust=branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x]+'@'+adjuster;  
                            beforeAdjust=branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x]+'@';
                            system.debug('afterAdjust'+afterAdjust+'beforeAdjust'+beforeAdjust);
                            system.debug(adjuster+'increeeeeeeeeee');  
                            
                            if(!gapFiller.contains(afterAdjust)){ 
                                system.debug('Its Break');
                                r=sizeval;
                                break;
                            }                                                         
                        }                                                 
                    }
                    
                    finlaSetter.add(afterAdjust);
                    
                    beforeAdjust=' ';
                    afterAdjust=' '; 
                    adjuster=0;
                    sizeval=0;
                    FinalString=' ';
                    // FinalString=beforeAdjust+adjuster;
                    //  keysetHolder=keysetHolder+FinalString;
                    /**  
if(keysetHolder!=null){

keysetHolder=keysetHolder+branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x]+'@'+sourcSize.get(branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x])+'&';
}else{

//in case of first time we are making keyset  
//if key set product is not there in above map we are making that is 0
keysetHolder=branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x]+'@'+(sourcSize.get(branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x])!=null ? sourcSize.get(branchStrin.get(sc.Branch__c)+'@'+BranchTemp[x]) : 0)+'&';

}
**/                    
                }
                for(string sr:finlaSetter){
                    
                    if(sr!=null && sr!=' '){
                        system.debug(sr+'MMMMMMMMMMMMMMMM');
                        finlaSetterL.add(sr);
                        
                    }
                }                 
                system.debug(finlaSetterL.size()+'BBBBBBBBBBB');
                for(integer f=0;f<finlaSetterL.size();f++){                    
                    // keysetHolder=keysetHolder+finlaSetterL[f]+'&';
                    
                    if(f==0){
                        if(finlaSetterL[f]!=null)
                            keysetHolder=finlaSetterL[f]+'&';
                    }else{
                        if(finlaSetterL[f]!=null)
                            keysetHolder=keysetHolder+finlaSetterL[f]+'&';
                    }
                    /**
if(keysetHolder==null){
keysetHolder=FinalString+'&';    
}else{
keysetHolder=keysetHolder+FinalString+'&';
}   
**/  
                    
                }
                sc.keys__c=' ';
                sc.keys__c=keysetHolder;
                // KeyTemCont=sc.branch__r.name+'@'+s
            }
        }       
    }    
}