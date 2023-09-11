/*Created by Mahima Gandhe- 01 MOB Offer communication At sanction level- Date 20/1/2017 */
trigger ScriptOffersCRUD on ScripsHistory__c ( after insert) 
{

    ProductSMS__C prodsms = new ProductSMS__C();
    prodsms = ProductSMS__C.getValues('01MOB_Offers_Saction');
    //set[] prods= prodsms.Produtc__c.split(',');
    static Set < Id > mobSOLoanIdList = new Set < Id > ();
    Map<ID,List<ScripsHistory__c >> SODetailsMap = new Map<ID,List<ScripsHistory__c >>();
    Map<Id,ScripsHistory__c> mapWithParentData = new Map<ID,ScripsHistory__c >();
    if (trigger.isInsert && Trigger.isAfter) 
    {
        Set<id> triggerIds = Trigger.newMap.keyset();
        mapWithParentData = new Map<ID,ScripsHistory__c >([select Loan_Application__r.Sourcing_Channel__r.Channel_Type__c, Loan_Application__r.Product__c from ScripsHistory__c where id in :triggerIds]);
        system.debug('Scripts/Offers===>' +Trigger.new);
            OnAfterInsert(Trigger.new);
    }

    // SEND OFFER EMAIL ON INSERT
    public void OnAfterInsert(List <ScripsHistory__c> SciptsOffersList) 
    {
        system.debug('inside ScriptOffersCRUD After trigger');
        for (ScripsHistory__c SOtemp :SciptsOffersList)
        {        
            system.debug('Inside ScriptOffersCRUD loop for scrips offers list');
            if(SOtemp.Source__c == '01MOB')
            { 
                    
                //Added Null Check to check if Channel Type is null to avoid null reference error, Added on 1st March 2017 Added By Rajendra Bharti. 
                if( mapWithParentData.get(SOtemp.id).Loan_Application__r.Sourcing_Channel__r.Channel_Type__c != null && prodsms != null)
                {
                    // For all D2C cases  PSBL, DOCTORS ||  For all cases PRO
                       //BUG-17470 HPRO S
                    Boolean isPROProductLineProduct = false;
                    transient set < string > setPROProdName = new set < string > ();
                    if(!commonUtility.isEmpty(Label.PRO_ProductLine_Products))
                        setPROProdName.addAll(Label.PRO_ProductLine_Products.split(';'));
                        String Product = mapWithParentData.get(SOtemp.id).Loan_Application__r.Product__c;
                        if(setPROProdName.size() > 0 && Product != null){
                            isPROProductLineProduct = setPROProdName.contains(Product.toUpperCase());
                    }
                    //BUG-17470 HPRO E
                    if( (mapWithParentData.get(SOtemp.id).Loan_Application__r.Sourcing_Channel__r.Channel_Type__c !=prodsms.Channel__c
                    && prodsms.Produtc__c.contains(mapWithParentData.get(SOtemp.id).Loan_Application__r.Product__c) )|| isPROProductLineProduct  )
                    {
                        system.debug('D2C identified');
                        List<ScripsHistory__c > SOObjTemp = new List<ScripsHistory__c >(); 
                        if (SOtemp.Loan_Application__c != null) {
                            mobSOLoanIdList .add(SOtemp.Loan_Application__c );
                        }
                        if(SODetailsMap.get(SOtemp.Loan_Application__c ) == null){
                            SOObjTemp .add(SOtemp);
                            SODetailsMap.put(SOtemp.Loan_Application__c ,SOObjTemp );
                        }
                        else
                        {
                            SOObjTemp = SODetailsMap.get(SOtemp.Loan_Application__c );
                            SOObjTemp .add(SOtemp);
                            SODetailsMap .put(SOtemp.Loan_Application__c ,SOObjTemp );
                        }
                    }
                }
            }
        
        }
               
    }
    if (mobSOLoanIdList .size() > 0) 
    {
        system.debug('mobPOIdList Entered');
        // Send Email
        system.debug('Sending Email');
        ScriptOffersCRUDHandler.productOffersEmail(mobSOLoanIdList );
        //Send sms
        system.debug('Sending SMS');
        ScriptOffersCRUDHandler handlerObj = new ScriptOffersCRUDHandler ();
        handlerObj.OnAfterInsert(mobSOLoanIdList ,SODetailsMap );
    }
}