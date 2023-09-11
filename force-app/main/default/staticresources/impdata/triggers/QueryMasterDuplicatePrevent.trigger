trigger QueryMasterDuplicatePrevent on Queue_Master__c (before insert, before update) {
    if(trigger.isBefore){
        Map<String,String> mapQueueLocation = new Map<String,String>();
        Map<String,String> mapQueueLocationQID = new Map<String,String>();
        Set<String> setLocation = new Set<String>();
        List <Queue_Master__c> QueueMaster = new list<Queue_Master__c>();
        String ErrorMsg;
        Set <String> MatchingQueue = new Set<String>();
        Set <String> MatchingQueueID = new Set<String>();
        List <String> Location1List = new List<String>();
        List <String> Location2List = new List<String>();
        List <String> Location3List = new List<String>();
        Set<String> prodSet = new Set<String>();

        for (Queue_Master__c Q : trigger.new) {
            prodSet.add(Q.Product__c);
            List<String> s = Q.Product__c.split(';');
            for (String ss : s) {
                prodSet.add(ss);
            }
        }
        system.debug('prodSet===>'+prodSet);
        if (prodSet.size() > 0) {
            boolean hasCondition = false;
            String query = 'select QID__c,Name,Product__c,Location__c,Qtype__c,SourceType__c from Queue_Master__c ';//added SourceType__c in query for bug id 22019
            List<String> opts = new List<String> (prodSet);
             system.debug('opts===>'+opts);
            if(!opts.isempty()) {
                hasCondition = true;
                query += '  where Active__c = true AND Product__c INCLUDES (\''+opts[0]+'\'';
                opts.remove(0);
            }
            while(!opts.isempty()) {
                query += ',\''+opts[0]+'\'';
                opts.remove(0);
            }
            if(hasCondition)
                query += ')';
            System.debug('query -->' + query);
            QueueMaster = Database.query(query);
            /*for (Queue_Master__c qm : QueueMaster) {
                System.debug(qm);
            }*/
            System.debug('QueueMaster --> ' + QueueMaster);
        }
        
           
        for(Queue_Master__c Q : trigger.new){
            String flag = '0';
            Decimal counter = 0;//22019
            system.debug('Product is '+Q.Product__c);
            if(Q.Product__c != null){
                List <String> ProductList = Q.Product__c.split(';');
                if(ProductList != null && ProductList.size() > 0){
                    //for(String prod :ProductList){
                        //System.debug('prod'+prod);
                        //QueueMaster = [select QID__c,Name,Product__c,Location__c,Qtype__c from Queue_Master__c where Active__c = true AND Product__c includes (:prod)];
                        system.debug('total : '+QueueMaster.size());  
                        system.debug('Q.qtype : '+Q.Qtype__c); 
                        if(Q.Qtype__c == null){
                            Q.addError('Please select Queue type.');
                        }
                        // only 1 centralized queue per product
                        if(Q.Qtype__c != null && Q.Qtype__c == 'Centralized Queue'){
                            system.debug('centralized queue');
                            for(Queue_Master__c qm : QueueMaster){
                            //added for bug id 22019 start
                                if(qm.Qtype__c !=null && qm.Qtype__c == Q.Qtype__c && Q.Product__c == qm.Product__c){
                                    counter ++;
                                }
                                //added for bug id 22019 stop
                                if(qm.Qtype__c !=null && qm.Qtype__c == Q.Qtype__c && qm.SourceType__c != null && qm.SourceType__c == Q.SourceType__c){//added sourcetype condition for bug id 22019 shilpa autoqueue phase 2 
                                    system.debug('centralized queue already exists in '+qm.Name);
                                    system.debug('Q.Name : '+Q.Name);
                                    if(qm.QID__c != Q.QID__c){
                                        Q.addError('Centralized queue already exists in '+qm.Name);
                                        break;
                                    }
                                }
                            }
                            //added for bug id 22019 start
                            if(Label.CentralizedQueueCount != null && (counter >= Integer.valueOf(Label.CentralizedQueueCount))){
                                Q.addError('Centralized queue cannot be more than 3 for single product');
                            }
                            //added for bug id 22019 stop
                        }   
                        else{ 
                        if(Q.Qtype__c == 'Branch Queue'){
                            /*if(Q.Location__c == null){
                                Q.addError('Location cannot be null for branch queue ');
                            }*/
                        }                 
                        for(Queue_Master__c qm : QueueMaster){                        
                            if(qm.Location__c !=null){                                
                                Location1List = qm.Location__c.split(',');
                                system.debug('Location1List.size() ---> '+Location1List.size());
                                if(Location1List != null && Location1List.size() > 0){
                                    for(String loc1 :Location1List){
                                        system.debug('loc1 : ' +loc1);
                                        setLocation.add(loc1.toUppercase());
                                        mapQueueLocation.put(loc1.toUppercase(),qm.Name);  
                                        mapQueueLocationQID.put(qm.Name,qm.QID__c);                                      
                                    }
                                }
                            }
                            
                        }
                        }//else
                        system.debug('setLocation : '+setLocation.size());
                        system.debug('Q.location is  : '+Q.Location__c);
                        //system.debug('loc2 : '+Q.Location2__c);
                        //system.debug('loc3 : '+Q.Location3__c);                        
                        //if(setLocation.contains(Q.Location__c)){
                        if(Q.Location__c != null){
                            //ErrorMsg = 'Queue will not be duplicate with product and location, selected product and location are already maintained in';
                            //if(Q.Location__c != null){  
                                List<String> LocationList = Q.Location__c.split(',');
                                system.debug('LocationList size: '+LocationList.size());
                                if(LocationList != null && LocationList.size() > 0){  
                                    for(String loc1 :LocationList){   
                                        if(loc1 != null && setLocation.contains(loc1.toUppercase())){     
                                            //ErrorMsg = 'Queue will not be duplicate with product and location, selected product and location are already maintained in';                    
                                            System.debug('location 1 : '+mapQueueLocation.get(Q.Location__c));
                                            MatchingQueue.add(mapQueueLocation.get(loc1.toUppercase()));
                                            MatchingQueueID.add(mapQueueLocationQID.get(loc1.toUppercase()));
                                            //break;                                        
                                        }
                                    }
                                }
                           // }
                        }
                        //}
                        //system.debug('ErrorMsg --->' +ErrorMsg);
                        
                    //}
                }
                system.debug('ErrorMsg  ---->  '+ErrorMsg );
                boolean errorflag = false;
                //if(ErrorMsg != null){
                    if(MatchingQueue != null && MatchingQueue.size() > 0){
                        system.debug('MatchingQueue.size : '+MatchingQueue.size());
                        
                        ErrorMsg = 'Queue will not be duplicate with product and location, selected product and location are already maintained in';                    
                        for(String qname : MatchingQueue){   
                            system.debug('mapQueueLocationQID.get(qname) : '+mapQueueLocationQID.get(qname));                                                 
                            if(mapQueueLocationQID.get(qname) != Q.QID__c){                                
                                ErrorMsg = ErrorMsg + ' ' +qname;  
                                errorflag = true;                              
                                //Qnames = Qnames + ' '+qname; //MatchingQueueID
                            }
                            /*else
                                ErrorMsg = null;*/

                        }                                           
                    }
                    
                //}
                //if(ErrorMsg != null){
                if(errorflag){
                    system.debug('ErrorMsg --->' +ErrorMsg);
                    Q.addError(ErrorMsg); 
                }
            }
            else{
                Q.addError('Please select Product.');    
            }
        }
        
    }
}