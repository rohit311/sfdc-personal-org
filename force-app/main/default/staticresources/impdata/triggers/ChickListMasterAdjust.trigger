/**
Description :
This trigger is to adjust the records in before condition.
1.When user has selected add property document in Loan Detailed ac>document checklist > add Property document
2. records will save to Checklist__c
3. before saving this trigger will adjust DocumentFmlyName__c values
Example :
We have 5 Address proofs in picklist those are basically different internally by having number from 1 to 5,
When user has selected 4th address proof at the time of creation this time trigger will replace 4th address proof with 1st address proof next time user has selected 3rd one again this trigger will adjusted to 2nd 

**/

trigger ChickListMasterAdjust on Checklist__c(before insert,before update) {
    id oppids;
    public Date productMortgageDate {
        get;
        set;
    }
    public Date LoanCreatedDate {
        get;
        set;
    }
    Public Opportunity loan{
        get;
        set;
    }
    public String productMortgage {
        get;
        set;
    }
    public Set < String > mortgagrProd = new Set < String > ();
    //16723--added if condition
    if(Trigger.isBefore && Trigger.isInsert){
        List < Checklist__c > CheckListOfLoan = new List < Checklist__c > ();
        for (Checklist__c t: trigger.new) {
            oppids = t.Loan_Application__c;
        }
        
        if (oppids != null){
            loan = [select CreatedDate, Product__c from Opportunity where Id = : oppids];
        }
        //getting custom setting for Objects - CDD New Flow Date
        if (Object__c.getValues('CDD New Flow Date') != null) {
            productMortgageDate = Object__c.getValues('CDD New Flow Date').CDD_New_Flow_Date__c;
            // system.debug('CDD New Flow Date-----' + productMortgageDate);
        }
        
        //getting custom setting for Objects - Mortgage Products
        System.debug('Product Value-----' + Object__c.getValues('Mortgage Products'));
        if (Object__c.getValues('Mortgage Products') != null) {
            productMortgage = Object__c.getValues('Mortgage Products').Mortgage_Products__c;
            system.debug('Mortgage-----' + productMortgage);
            //spliting custom setting string
            String[] arr = productMortgage.split(';');
            if (oppids != null  ){
                system.debug('***mortgagrProd***' + mortgagrProd+!(mortgagrProd.contains(loan.Product__c.ToUpperCase()))+ 'Date.ValueOf(loan.CreatedDate) '+Date.ValueOf(loan.CreatedDate)+'productMortgageDate' +productMortgageDate );
                
                system.debug(oppids + 'xxxxxxxxxxxxxx');
            }
            for (String str: arr) {
                mortgagrProd.add(str.ToUpperCase());
            }
            
        }
        // This loop is to bypass fetching Doc family name for pdd
        
        if ( loan != null && loan.Product__c != null && !(mortgagrProd.contains(loan.Product__c.ToUpperCase())) && Date.ValueOf(loan.CreatedDate) <= productMortgageDate) {
            List < Document_Family__c > DocFami = [select id, name, FinnOne_Document_id__c from Document_Family__c];
            if (!test.isRunningTest()) {
                if (oppids != null)
                    CheckListOfLoan = [select id, name, DocumentFmlyName__c, DocumentFmlyName__r.name, DocumentFmlyName__r.FinnOne_Document_id__c from Checklist__c where Loan_Application__c = : oppids];
                system.debug('rrrrrr');
            }
            
            Map < string, id > DocFamiMap = new Map < string, id > ();
            Map < id, string > DocFamiMapProcessVal = new Map < id, string > ();
            Map < id, string > checklistMap = new Map < id, string > ();
            set < string > CurrentChelistDocmF = new set < string > ();
            
            
            for (integer i = 0; i < DocFami.size(); i++) {
                //keeping name and number as a key for doc family ids
                if (DocFami[i].name != null && DocFami[i].FinnOne_Document_id__c != null) {
                    DocFamiMap.put(DocFami[i].name + '-' + DocFami[i].FinnOne_Document_id__c, DocFami[i].id);
                    DocFamiMapProcessVal.put(DocFami[i].id, DocFami[i].name + '-' + DocFami[i].FinnOne_Document_id__c);
                }
            }
            
            for (integer y = 0; y < CheckListOfLoan.size(); y++) {
                //keeping all checklist of opp in a map and list
                system.debug(CheckListOfLoan[y].DocumentFmlyName__r.name + 'eeeeeeeeeeeee');
                if (CheckListOfLoan[y].DocumentFmlyName__r.name != null && CheckListOfLoan[y].DocumentFmlyName__r.FinnOne_Document_id__c != null) {
                    checklistMap.put(CheckListOfLoan[y].id, CheckListOfLoan[y].DocumentFmlyName__r.name + '-' + CheckListOfLoan[y].DocumentFmlyName__r.FinnOne_Document_id__c);
                    CurrentChelistDocmF.add(string.valueof(CheckListOfLoan[y].DocumentFmlyName__r.name + '-' + CheckListOfLoan[y].DocumentFmlyName__r.FinnOne_Document_id__c));
                }
            }
            
            string processValue = '';
            integer processnub = 0;
            string finalKeyMaker;
            List < integer > templit = new List < integer > ();
            List < integer > possibleNumbers = new List < integer > ();
            //  List<string> valuestringAndNumber=new List<string>();        
            for (Checklist__c cl: trigger.new) {
                string chddd;
                try {
                    //  chddd=((DocFamiMapProcessVal.get(cl.DocumentFmlyName__c)).split('-'))[0];
                    // valuestringAndNumber=((DocFamiMapProcessVal.get(cl.DocumentFmlyName__c)).split('-'))[0];
                    system.debug('***********cl: + ' + cl);
                    system.debug('***********cl.DocumentFmlyName__c: ' + cl.DocumentFmlyName__c);
                    system.debug('***********DocFamiMapProcessVal.get(cl.DocumentFmlyName__c): ' + DocFamiMapProcessVal.get(cl.DocumentFmlyName__c));
                    if (cl.DocumentFmlyName__c != null) {
                        if (DocFamiMapProcessVal.get(cl.DocumentFmlyName__c) != null) {
                            processValue = ((DocFamiMapProcessVal.get(cl.DocumentFmlyName__c)).split('-'))[0];
                            processnub = integer.valueof(((DocFamiMapProcessVal.get(cl.DocumentFmlyName__c)).split('-'))[1]);
                        }
                    } else {
                        processValue = '';
                    }
                    
                    
                    for (integer yy = 0; yy < CheckListOfLoan.size(); yy++) {
                        if (DocFamiMapProcessVal.get(CheckListOfLoan[yy].DocumentFmlyName__c) != null) {
                            if (((DocFamiMapProcessVal.get(CheckListOfLoan[yy].DocumentFmlyName__c)).split('-'))[0] == processValue)
                                // if(CheckListOfLoan[yy].DocumentFmlyName__r.name==processValue)
                                templit.add(integer.valueof((DocFamiMapProcessVal.get(CheckListOfLoan[yy].DocumentFmlyName__c).split('-'))[1]));
                        }
                    }
                    // templit.sort();
                    
                    for (integer w = 0; w < DocFami.size(); w++) {
                        if (DocFami[w].name == processValue) {
                            possibleNumbers.add(integer.valueof(DocFami[w].FinnOne_Document_id__c));
                        }
                        //we have to clear the things at the end          
                    }
                    possibleNumbers.sort();
                    system.debug(templit + 'fffffffffffff');
                    for (integer q = 0; q < possibleNumbers.size(); q++) {
                        
                        finalKeyMaker = processValue + '-' + string.valueof(possibleNumbers[possibleNumbers.size() - (possibleNumbers.size() - (0 + q))]);
                        system.debug(finalKeyMaker + 'AAAAAAAAAA');
                        
                        //system.debug('cl.DocumentFmlyName__r.Product__c' + cl.DocumentFmlyName__r.Product__c);
                        // if (!mortgagrProd.contains(cl.DocumentFmlyName__r.Product__c)) {
                        if (!CurrentChelistDocmF.contains(finalKeyMaker)) {
                            
                            cl.DocumentFmlyName__c = DocFamiMap.get(finalKeyMaker);
                            CurrentChelistDocmF.add(finalKeyMaker);
                            system.debug(cl.DocumentFmlyName__c+'cl.DocumentFmlyName__c');
                            
                            break;
                        }
                        // }
                    }
                    possibleNumbers.clear();
                } catch (exception e) {
                    system.debug(e + 'ddddddddd');
                }
                
            }
        }
    }
    //16723-- S
    if(Trigger.isBefore && Trigger.isUpdate )
    {
        
        for(Checklist__c chk:Trigger.new){
            Checklist__c oldChecklist; 
            if(Trigger.oldMap.get(chk.ID)!=null)
            {
                oldChecklist = Trigger.oldMap.get(chk.ID);    
            }
            
            

            if(oldChecklist!=NULL && oldChecklist.Finnone_Response__c!=NULL && oldChecklist.Doc_Upload_Status__c=='M' && (!oldChecklist.Finnone_Response__c.toUpperCase().contains(Label.finnoneChecklistUpdated)) && (!oldChecklist.Finnone_Response__c.toUpperCase().contains(Label.finnoneChecklist)))   
            {
                system.debug('in trigger0');
                chk.Doc_Upload_Status__c='Y';
            }
            if( (oldChecklist.Finnone_Response__c ==chk.Finnone_Response__c) && (oldChecklist.Property_Document__c!=chk.Property_Document__c || oldChecklist.DocStatus__c!=chk.DocStatus__c 
               || oldChecklist.Bar_Code__c !=chk.Bar_Code__c || oldChecklist.Centralized_Ops_Maker_Status__c !=chk.Centralized_Ops_Maker_Status__c
               || oldChecklist.Centralized_OPs_Maker_Remarks__c != chk.Centralized_OPs_Maker_Remarks__c || oldChecklist.COPs_Received_Date__c !=chk.COPs_Received_Date__c
               || oldChecklist.DocumentFmlyName__c != chk.DocumentFmlyName__c || oldChecklist.Target_Date__c != chk.Target_Date__c 
               || oldChecklist.Document_Type__c != chk.Document_Type__c || oldChecklist.IsCritical__c  != chk.IsCritical__c
               || oldChecklist.to_be_approved_by__c != chk.to_be_approved_by__c) )
            {
                system.debug('in trigger1');
                chk.Doc_Upload_Status__c='Y';
                chk.Actual_Modified_Date__c=Datetime.now();
            }
        }
        
    }
    //16723--E
}