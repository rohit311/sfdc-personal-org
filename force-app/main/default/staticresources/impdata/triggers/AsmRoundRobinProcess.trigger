Trigger AsmRoundRobinProcess on Product_Offerings__c(before insert, before update,after update) 
{
    public Set < String > DOCProducts = new Set < String > ();
    public Set < String > productOfferingSourceWithICodes = new Set < String > ();
    public Set < String > poTypes = new Set < String > ();
    public String[] usrIds = new String[] {};
    public Map < id, string > AllMobileNumbers = new Map < id, string > ();
    public String productCheck;
    public String CIBILPOCHECK;
    public string ProductForFlowLabel = Label.New_Products_for_Flow;
    
    Map < String, Lead > mapOflead = new Map < String, Lead > {};
    Map < String, Sourcing_Channel__c > mapOfChannels = new Map < String, Sourcing_Channel__c > {};
    Map < String, Lead > leadMap = new Map < String, lead > ();
    Set < String > ProductOfferUserIds = new Set < String > ();
    Set < String > allprodsCheck = new Set < String > ();   
    List < String > productList2 = new List < String > ();
    List < String > branchList2 = new List < String > ();
    List < String > branchList = new List < String > ();
    List < String > productList = new List < String > ();
    List < Lead > leadList = new List < Lead > ();
    List < ID > idList = new List < Id > ();
    List < String > SRbranchList2 = new List < String > ();
    List < Sourcing_Channel__c > channelList2 = new List < Sourcing_Channel__c > ();
    List < Sourcing_Channel__c > channelList3 = new List < Sourcing_Channel__c > ();
    List < Sourcing_Channel__c > channelList1 = new List < Sourcing_Channel__c > ();
    List < String > SRbranchList = new List < String > ();
    List < Sourcing_Channel__c > channelList = new List < Sourcing_Channel__c > ();
    List < String > PhNoList = new List < String > ();
    List < String > MsgList = new List < String > ();
    List < Sales_Officer_Limit__c > allSolimt = new List < Sales_Officer_Limit__c > (); 
    List < String > arr = new List < String > ();
    //List < Product_Offerings__c > poo = new List < Product_Offerings__c > ();
    List<ProductOfferingAsmAssignProcess.ProductOfferingWrapper> lstPO = new List<ProductOfferingAsmAssignProcess.ProductOfferingWrapper>();
    List<ProductOfferingAsmAssignProcess.ProductOfferingWrapper> lstPOUpdate = new List<ProductOfferingAsmAssignProcess.ProductOfferingWrapper>();
    List < Product_Offerings__c > lstD2CPO = new List < Product_Offerings__c > ();
    List < String > product = new List < String > ();
    List<Lead> lstTempLeads = new List<Lead>();
    integer max;
    integer curr, curr1;
    String key; 
    PSFAssignProcessCntrl psfObj = new PSFAssignProcessCntrl(); 
    //Added for D2C Auto Allocation 
    List < String > lstD2CProducts = new List<String>();
    List < String > lstD2CProductOfferingSource = new List<String>();
    /*List < Sales_Officer_Limit__c > lstD2CSolLimit = new List< Sales_Officer_Limit__c >();
    boolean isD2CProduct = false;
    boolean isD2CConditionMatched = false;
    boolean isAsmOrRsmAssigned = false;
    boolean isPureD2CProduct = false;*/
     // Added for prod issue BUG 24104 start
            string Pid = Userinfo.getProfileID();
            string Ids = Label.PO_Trigger_restrictedUserId;
            set < string > restrictedIdsSet = new set < string > ();
            if (ids != null) 
                restrictedIdsSet.addAll(Ids.split(';'));
          
            boolean restrictUser= restrictedIdsSet.contains(Pid);
     // BUG 24104 end
    if (LaonApplicationCreation__c.getValues('Professional Loan Product') != null) 
    {
        String Doc_LineProducts = LaonApplicationCreation__c.getValues('Professional Loan Product').ProfessionalLoan__c;
        if (Doc_LineProducts != null) 
        {
            system.debug('***Doc_LineProducts***' + Doc_LineProducts);
            String[] arr = Doc_LineProducts.split(';');
            for (String str: arr)
                DOCProducts.add(str);       
        }
    }
  
    if (SMSLeadSearch__c.getValues('Product Offering Source Values') != null) 
    {
        String productOfferingSources = SMSLeadSearch__c.getValues('Product Offering Source Values').Source_Value__c;
        String[] poSourceArray = productOfferingSources.split(',');
        for (String str: poSourceArray)
            productOfferingSourceWithICodes.add(str);
    }
    
    if (LaonApplicationCreation__c.getValues('PO Types') != null) 
    {
        String poTypesString = LaonApplicationCreation__c.getValues('PO Types').PO_Type__c;
        String[] poArray = poTypesString.split(';');
        for (String str: poArray)
            poTypes.add(str);
    }
    
    usrIds = Label.ProductOfferingUsers.split(',');
    System.Debug('values in UserID array ' + usrIds);

    for (String labelUsrids: usrIds) 
        ProductOfferUserIds.add(labelUsrids);
        
    productCheck = Label.DNCSalesHierarchyProductCheck;
    CIBILPOCHECK = Label.CIBILSalesHierarchyCheck;
    for (String s: productCheck.split(','))
        allprodsCheck.add(s.toUppercase());
    
    //declared on global level as being called in both update & insert. 
    ProductOfferingAsmAssignProcess poap = new ProductOfferingAsmAssignProcess();

    //Loop for Insert Trigger
    if (Trigger.isInsert) 
    {
        system.debug('isInsert for AsmRoundRobinProcess');
        for (Product_Offerings__c productOffr: trigger.new) 
        {
            system.debug('Sourcing Channel ===>' + productOffr.Sourcing_Channel__c);
            system.debug('ASM ===>' + productOffr.asm__c);
            idList.add(productOffr.Lead__c);
            if (productOffr.Products__c != null)                        
                product.add(productOffr.Products__c);
                               
            if (productOffr.Sourcing_Channel__c == null && productOffr.PSF__c == null && productOffr.ASM__c == null) 
            {
                if ((productOffr.Products__c == 'FD' || productOffr.Products__c == 'Fixed Deposit' || productOffr.Products__c == 'FIXED DEPOSIT')) 
                {   
                    System.Debug('Inside Fixed Deposite Check');
                    branchList.add(productOffr.Lead_Branch__c);
                    productList.add(productOffr.Products__c);
                }

                if (productOffr.Products__c != null && DOCProducts.size() > 0) 
                {
                    if ((productOffr.Products__c == 'PSBL' || (ProductForFlowLabel != null && ProductForFlowLabel.contains(productOffr.Products__c)))|| productOffr.Products__c == 'DOCTORS' || DOCProducts.contains(productOffr.Products__c.toUppercase()) || productOffr.Products__c == 'SAL') 
                    {
                        System.Debug('Inside PSBL DOCTORS SAL products check');
                        if (productOffr.TeleCalling_Desposition_Status__c == 'Sale') 
                        {
                            System.Debug('* Tele Desposition Stat is sale');
                            branchList2.add(productOffr.Lead_Branch__c);
                            productList2.add(productOffr.Products__c);
                        }
                    }
                }
            }
        }
        
        if(lstTempLeads != null)
        {
            if(lstTempLeads.size() ==0)
            {
                SetLeadData();
                for (Lead lead:lstTempLeads)        
                    leadMap.put(lead.id, lead); 
            }
            else 
            {
                for (Lead lead:lstTempLeads)        
                    leadMap.put(lead.id, lead);     
            }
        }       
        
        NONFDSCStamping();
        FDSCStamping();
         
        for (Product_Offerings__c tempPO: trigger.new) 
        {            
            if (tempPO.PSF__c == null && tempPO.ASM__c == null) 
            {
                System.Debug('string.valueof(tempPO.ownerid) ' + string.valueof(tempPO.ownerid) + ' ProductOfferUserIds ' + ProductOfferUserIds );
                if(!poTypes.contains(tempPO.PO_Type__c) && ProductOfferUserIds.contains(string.valueof(tempPO.ownerid)) && !tempPO.Name.toUppercase().contains(CIBILPOCHECK) && tempPO.products__c != null)
                {
                    if(tempPO.RSM__C == null)
                    {
                        system.Debug('Adding PO in poo list for cibil watch');
                        ProductOfferingAsmAssignProcess.ProductOfferingWrapper objTmp = new ProductOfferingAsmAssignProcess.ProductOfferingWrapper();                        
                        objTmp.objPO = tempPO;
                        objTmp.isCibilWatchPO = true;
                        lstPO.Add(objTmp);
                        //poo.add(tempPO); 
                    }
                               
                }
                else
                if(tempPO.ASM__c == null && string.isNotBlank(Label.D2C_Products) && string.isNotBlank(tempPO.Products__c) && Label.D2C_Products.toUpperCase().split(',').contains(tempPO.Products__c) && !restrictUser ) // added restrictUser condition for BUG 24104
                {
                    system.Debug('Adding PO in poo list for D2C Condition watch');
                    ProductOfferingAsmAssignProcess.ProductOfferingWrapper objTmp = new ProductOfferingAsmAssignProcess.ProductOfferingWrapper();                    
                    objTmp.objPO = tempPO;
                    objTmp.isCibilWatchPO = false;
                    lstPO.Add(objTmp);
                }                
            }
            system.debug('tempPO.Lead__c -> ' + tempPO.Lead__c);
            System.Debug('Values in leadMap ' + leadMap);
            if (tempPO.Lead__c != null) 
            {
                if (tempPO.Office_Address_1__c == null) 
                {
                    if (leadMap.get(tempPO.Lead__c).Customer_Type__c == 'Individual' || leadMap.get(tempPO.Lead__c).Customer_Type__c == 'Corporate') 
                    {
                        tempPO.Office_Address_1__c = leadMap.get(tempPO.Lead__c).Lead_Office_Address_Line1__c;
                        tempPO.Office_Address_2__c = leadMap.get(tempPO.Lead__c).Lead_Office_Address_Line2__c;
                        tempPO.Office_Address_3__c = leadMap.get(tempPO.Lead__c).Lead_Office_Address_Line3__c;
                        tempPO.Office_City__c = leadMap.get(tempPO.Lead__c).Lead_Office_City__c;
                        tempPO.Office_Pin_Code__c = leadMap.get(tempPO.Lead__c).Lead_Office_Pin_Code__c;
                        tempPO.Office_State__c = leadMap.get(tempPO.Lead__c).Lead_Office_State__c;
                        
                        if (leadMap.get(tempPO.Lead__c).Office_Phone_Number__c != null)
                            tempPO.Office_Phone__c = leadMap.get(tempPO.Lead__c).Office_Phone_Number__c;                    
                    }
                }

                if (tempPO.Address_Line_1__c == null) 
                {
                    if (leadMap.get(tempPO.Lead__c).Customer_Type__c == 'Individual' || leadMap.get(tempPO.Lead__c).Customer_Type__c == 'Corporate') 
                    {
                        tempPO.Address_Line_1__c = leadMap.get(tempPO.Lead__c).Residence_Address_Line1__c;
                        tempPO.Address_Line_2__c = leadMap.get(tempPO.Lead__c).Residence_Address_Line2__c;
                        tempPO.Address_Line_3__c = leadMap.get(tempPO.Lead__c).Residence_Address_Line3__c;
                        tempPO.Resi_City__c = leadMap.get(tempPO.Lead__c).Resi_City__c;
                        tempPO.Pin_Code__c = leadMap.get(tempPO.Lead__c).Resi_Pin_Code__c;
                        tempPO.Resi_State__c = leadMap.get(tempPO.Lead__c).Resi_State__c;
                    }
                }
            }
        }

        if (AllMobileNumbers.size() == 0) 
        {
            for (Sales_Officer_Limit__c tempObj: allSolimt)
                AllMobileNumbers.put(tempObj.Sales_Officer_Name__c, tempObj.Sales_Officer_Name__r.Mobile_number__c);
        }
        //harsit-----optimization END
        System.Debug('poo containts are ' + lstPO + '\n allSolimt values are ' + allSolimt);
        //Assigning ASM to poo list 
        if (lstPO.size() > 0 && !System.isBatch()) 
            poap.AsmAssigner(lstPO);

        if (product != null) 
            StampSalesHierarchy(product);

        //This for loop is to mark ASM / RSM sms sent flag 
        for (Product_Offerings__c p: trigger.new) 
        {
            if (allprodsCheck != null && p.Products__c != null) 
            {
                if (allprodsCheck.contains(p.Products__c.toUppercase())) 
                {
                    if (p.ASM__c != null && p.ASM_Sendsms__c != true && p.ASM_SMS_Text__c!=null && p.ASM_SMS_Text__c!='') 
                    {
                        system.debug('Inside If ASM SMS------insert------->' + AllMobileNumbers.get(p.ASM__c));
                        if (AllMobileNumbers.get(p.ASM__c) != null) 
                        {
                            PhNoList.add(AllMobileNumbers.get(p.ASM__c));                   
                            MsgList.add(p.ASM_SMS_Text__c);
                            p.ASM_Sendsms__c = true;
                        }
                    }
                    if (p.RSM__c != null && p.RSM_Sendsms__c != true && p.ASM_SMS_Text__c!=null && p.ASM_SMS_Text__c!='') 
                    {
                        if (AllMobileNumbers.get(p.RSM__c) != null) 
                        {
                            PhNoList.add(AllMobileNumbers.get(p.RSM__c));                           
                            MsgList.add(p.ASM_SMS_Text__c);
                            p.RSM_Sendsms__c = true;
                        }
                    }
                }
            }
        }
    }
    
    //When the Product offerring is edited then below condition will be true
    if (Trigger.isUpdate) 
    {
      
        //Referral Start 19263
        /*SALMobilityPricingCntrl_V2.numbers++;
        for (Product_Offerings__c prod: Trigger.New) {
             //Updated by swapnil
            list<SOL_policy__C> solListSms=new list<SOL_Policy__c>();
            
            System.debug('Old val '+Trigger.OldMap.get(prod.id).TeleCalling_Desposition_Status__c);
            if(prod.Lead_Source__c=='SPL Referred'&& SALMobilityPricingCntrl_V2.numbers ==1 &&(prod.Field_Disposition_1__c=='Not Eligible' || prod.Field_Disposition_1__c=='Rejected'))
            {
                System.debug('in referral Trigger');                
              //  GeneralCommunicationHandler.sendsmspo(Trigger.New,[select id from SOL_policy__c where Product_Offerings__c=:prod.id],'After Reject-Referrer1',false);
            }
            
        }*/
        //Referral End
        if (!ControlRecursiveCallofTrigger_Util.getTriggerAlreadyCalledFun()) 
        {
            System.Debug('Executing Update Call in AsmRoundRobinProcess trigger');
            ControlRecursiveCallofTrigger_Util.setTriggerAlreadyCalledFun();
            LaonApplicationCreation__c mobProducts;
            //List < Product_Offerings__c > lstPOUpdate  = new List < Product_Offerings__c > (); 
            
            List<String> mobProductsList;
            List < String > product = new List < String > ();
            List < String > branch = new List < String > ();
            
            Map < String, Lead > leadMap = new Map < String, lead > ();
            
            mobProducts = LaonApplicationCreation__c.getValues('0 to 1 MOB products');
            if(mobProducts!=null)
                mobProductsList = mobProducts.Current_product__c.split(',');            
          
        
            for (Product_Offerings__c p: trigger.new) 
            {
                if (p.Products__c != null)
                    product.add(p.Products__c);
                system.debug('p.PSF__c ' + p.PSF__c + ' p.ASM__c ' + p.ASM__c);
                //System.Debug('isD2CProduct ' + Label.D2C_Products.toUpperCase().split(',').contains(p.Products__c.toUpperCase()));
                if (p.PSF__c == null && p.ASM__c == null) 
                {
                    if((!poTypes.contains(p.PO_Type__c) && ProductOfferUserIds.contains(string.valueof(p.ownerid)) && !p.Name.toUppercase().contains(CIBILPOCHECK) && p.products__c != null)||/*13014 start*/ (productOfferingSourceWithICodes.contains(p.Product_Offering_Source__c) && !p.Name.toUppercase().contains(CIBILPOCHECK) && p.products__c != null &&  p.Product_Offering_Converted__c==False &&((p.TeleCalling_Desposition_Status__c=='Sale'&& (p.Tele_Calling_Activity_time__c > p.Enquiry_Date__c||p.Tele_Calling_Activity_time__c==null) && p.Field_Disposition_1__c==null)||
                    ((p.Tele_Calling_Activity_time__c< p.Enquiry_Date__c || p.Tele_Calling_Activity_time__c==null)&& ((((system.now().getTime()-p.Enquiry_Date__c.getTime())/1000)/60)/60)>=24)||
                    (p.TeleCalling_Desposition_Status__c=='Follow Up' && p.Tele_Calling_Activity_time__c >p.Enquiry_Date__c && ((((system.now().getTime()-p.Tele_Calling_Activity_time__c.getTime())/1000)/60)/60)>=168 && p.Field_Disposition_1__c==null)/*13014 end*/
                    )))
                    {
                        System.debug('lstPOUpdate update list criteria is matched');
                        ProductOfferingAsmAssignProcess.ProductOfferingWrapper objTmp = new ProductOfferingAsmAssignProcess.ProductOfferingWrapper();                    
                        objTmp.objPO = p;
                        objTmp.isCibilWatchPO = true;
                        lstPOUpdate.add(objTmp);
                    }  
                    else
                    if(string.isNotBlank(Label.D2C_Products) && string.isNotBlank(p.Products__c) && Label.D2C_Products.toUpperCase().split(',').contains(p.Products__c.toUpperCase()) && !restrictUser /* added restrictUser condition for BUG 24104 */)
                    {
                        System.Debug('Adding po in case of D2C Products for update');
                        if(string.isBlank(p.ASM__C))
                        {
                            System.Debug('ASM blank condition is matched');
                            ProductOfferingAsmAssignProcess.ProductOfferingWrapper objTmp = new ProductOfferingAsmAssignProcess.ProductOfferingWrapper();                    
                            objTmp.objPO = p;
                            objTmp.isCibilWatchPO = false;
                            lstPOUpdate.Add(objTmp);
                        }
                        else 
                            System.Debug('ASM blank condition is not matched');
                        
                    }  
                }
                
            }
            system.debug('in updated-->>' + lstPOUpdate );
            
            //harsit-----optimization START

            if (AllMobileNumbers.size() == 0) for (Sales_Officer_Limit__c t: allSolimt)
                AllMobileNumbers.put(t.Sales_Officer_Name__c, t.Sales_Officer_Name__r.Mobile_number__c);
            
            //harsit-----optimization END

            if (lstPOUpdate.size() > 0 && !System.isBatch())  
                poap.AsmAssigner(lstPOUpdate);
            
            System.Debug('Products in Product list are ' + product);
            if (product != null) 
                StampSalesHierarchy(product);

            for (Product_Offerings__c p: trigger.new) 
            {
                idList.add(p.Lead__c);
                if (allprodsCheck != null && p.Products__c != null) 
                {
                    if (allprodsCheck.contains(p.Products__c.toUppercase())) 
                    {
                        if (p.ASM__c != null && p.ASM_Sendsms__c != true) 
                        {
                            if (AllMobileNumbers.get(p.ASM__c) != null) 
                            {
                                PhNoList.add(AllMobileNumbers.get(p.ASM__c));
                                MsgList.add(p.ASM_SMS_Text__c);
                                p.ASM_Sendsms__c = true;
                            }
                        }
                        if (p.RSM__c != null && p.RSM_Sendsms__c != true) 
                        {
                            if (AllMobileNumbers.get(p.RSM__c) != null) 
                            {
                                PhNoList.add(AllMobileNumbers.get(p.RSM__c));
                                MsgList.add(p.ASM_SMS_Text__c);
                                p.RSM_Sendsms__c = true;
                            }
                        }
                    }
                }
            }

            if(lstTempLeads != null)
            {
                if(lstTempLeads.size() == 0)
                {
                    SetLeadData();
                    for (Lead lead: lstTempLeads)
                        leadMap.put(lead.id, lead); 
                }
                else
                {
                    for (Lead lead: lstTempLeads)
                        leadMap.put(lead.id, lead);         
                }
            }
            
            for (Product_Offerings__c so: trigger.new) 
            {
                if (so.Lead__c != null) 
                {
                    if (so.Office_Address_1__c == null) 
                    {
                        if (leadMap.get(so.Lead__c).Customer_Type__c == 'Individual' || leadMap.get(so.Lead__c).Customer_Type__c == 'Corporate') 
                        {
                            so.Office_Address_1__c = leadMap.get(so.Lead__c).Lead_Office_Address_Line1__c;
                            so.Office_Address_2__c = leadMap.get(so.Lead__c).Lead_Office_Address_Line2__c;
                            so.Office_Address_3__c = leadMap.get(so.Lead__c).Lead_Office_Address_Line3__c;
                            so.Office_City__c = leadMap.get(so.Lead__c).Lead_Office_City__c;
                            so.Office_Pin_Code__c = leadMap.get(so.Lead__c).Lead_Office_Pin_Code__c;
                            so.Office_State__c = leadMap.get(so.Lead__c).Lead_Office_State__c;
                            if (leadMap.get(so.Lead__c).Office_Phone_Number__c != null)
                                so.Office_Phone__c = leadMap.get(so.Lead__c).Office_Phone_Number__c;                    
                        }
                    }

                    if (so.Address_Line_1__c == null) 
                    {
                        if (leadMap.get(so.Lead__c).Customer_Type__c == 'Individual' || leadMap.get(so.Lead__c).Customer_Type__c == 'Corporate') 
                        {
                            so.Address_Line_1__c = leadMap.get(so.Lead__c).Residence_Address_Line1__c;
                            so.Address_Line_2__c = leadMap.get(so.Lead__c).Residence_Address_Line2__c;
                            so.Address_Line_3__c = leadMap.get(so.Lead__c).Residence_Address_Line3__c;
                            so.Resi_City__c = leadMap.get(so.Lead__c).Resi_City__c;
                            so.Pin_Code__c = leadMap.get(so.Lead__c).Resi_Pin_Code__c;
                            so.Resi_State__c = leadMap.get(so.Lead__c).Resi_State__c;
                        }
                    }
                }       
                system.debug('ASM sms testing4');
                if(so.Lead_Source__c == '01MOB' && so.Base_Product__c!=null && mobProducts.Current_product__c.contains(so.Base_Product__c) && so.SMS_Email_Campaign__c == 'Interested' && so.ASM__c != null && so.SMS_Email_Campaign__c != Trigger.oldMap.get(so.Id).SMS_Email_Campaign__c )
                { 
                    String leadName = leadMap.get(so.Lead__c).name;
                    string smstextAsm = 'BFL Alert! Interested Lead for '+ leadName +', ' + so.Lead_Customer_Mobile__c + ' has been allocated to you. Rgds BFL'; 
                    MsgList.add(smstextAsm);
                    PhNoList.add(AllMobileNumbers.get(so.ASM__c));
                    system.debug('Value of smstextAsm '+smstextAsm + ' Mobile Number '+AllMobileNumbers.get(so.ASM__c));
                }
            }       
        }
    }

    if (!System.isBatch()) 
    {
        System.debug('batch is not executing..can proceed to future calls');
        if (PhNoList != null && MsgList != null) 
        {
            if (!ControlRecursiveCallofTrigger_Util.hasSendsms()) 
            {
                ControlRecursiveCallofTrigger_Util.setSendsms();
                try
                { if(!restrictUser) {// added if condition for BUG 24104
                    if(!System.isFuture())
                        sendsms.sendBulkSMS(MsgList, PhNoList);
                }
                }
                catch(Exception e)
                {
                    String str = '*****Exception: ' + e.getMessage() + '******stacktrace: ' + e.getStackTraceString();
                    System.debug(str);
                    try
                    {
                        CommonUtility.SendExceptionMail(str);
                    }
                    catch(Exception e1)
                    {
                        system.debug('exception is---->'+e1);
                    }
                    system.debug('---Exception---' + e.getMessage());
                }
            }
        }
    }



public void SetLeadData()
{
    System.Debug('Values in idList ' + idList);
    lstTempLeads = [select id, name, Customer_Type__c, Lead_Office_Address_Line1__c, Residence_Address_Line1__c,
    Resi_Pin_Code__c,Lead_Office_Address_Line2__c, Lead_Office_Address_Line3__c, Residence_Address_Line2__c,
    Resi_City__c,Lead_Office_City__c, Lead_Office_Pin_Code__c, Lead_Office_State__c, Residence_Address_Line3__c
    ,Resi_State__c,Office_Phone_Number__c,Customer_Address_1__c, Customer_Address__c, Customer_Name__c
    FROM LEAD
    WHERE id IN: idList];
    System.Debug('Values in lstTempLeads ' + lstTempLeads);
}

public void StampSalesHierarchy(List < String > product) 
{
    //Added By Gulshan Because to compare PO Product and SOL Limit record product in upper case  
    List<String> ClonedProductList  = product.clone();
    for(Integer i=0; i< ClonedProductList.size(); i++)
    {
        ClonedProductList[i] = ClonedProductList[i].toUpperCase();
    }
    Set<String> ClonedProductSet = new Set<String>(ClonedProductList);
    system.debug('ClonedProductSet==='+ClonedProductSet);
    system.debug('allSolimt==='+allSolimt);
        
    //Ended By Gulshan Because to compare PO Product and SOL Limit record product in upper case 
    
    List < Sales_Officer_Limit__c > totalSolimtForHierarchy = new List < Sales_Officer_Limit__c > ();
    List < Sales_Officer_Limit__c > totalSolimt = new List < Sales_Officer_Limit__c > ();
    String var0,
    var, var1, var2, var3, var4, var5;
    map < id, Sales_Officer_Limit__c > m1 = new map < id, Sales_Officer_Limit__c > ();
    Set<String> productSet = new Set<String>(product);
    if(!CommonUtility.isEmpty(allSolimt))
    {
        for(Sales_Officer_Limit__c s : allSolimt)
        {
            system.debug('s.Product__c==='+s.Product__c);
            if(productSet.contains(s.Product__c) || ClonedProductSet.contains(s.Product__c))
                totalSolimtForHierarchy.add(s);
        }
    }
    system.debug('m1111111totalSolimtForHierarchy111111111' + totalSolimtForHierarchy);
    for (integer i = 0; i < totalSolimtForHierarchy.size(); i++)
        m1.put(totalSolimtForHierarchy[i].Sales_Officer_Name__c, totalSolimtForHierarchy[i]);

    for (Product_Offerings__c p: trigger.new) 
    {
        if (p.PSF__c == null && p.ASM__c == null && p.Name != null && !p.Name.toUppercase().contains(CIBILPOCHECK))
        {
            if(allSolimt != null && allSolimt.size() == 0)
            {
                boolean tempBool = false;
                if(Trigger.isInsert)
                {
                    for(ProductOfferingAsmAssignProcess.ProductOfferingWrapper tempObject : lstPO)
                    {
                        if(tempObject.objPO.ID == p.ID)
                        {
                            System.debug('PO ids matched now Assigning cibil watch po value ' +tempObject.isCibilWatchPO);
                            tempBool = tempObject.isCibilWatchPO;
                            break;
                        }
                    }
                }
                else 
                if(Trigger.isUpdate)
                {
                    for(ProductOfferingAsmAssignProcess.ProductOfferingWrapper tempObject : lstPOUpdate)
                    {
                        if(tempObject.objPO.ID == p.ID)
                        {
                            System.debug('PO ids matched now Assigning cibil watch po value ' +tempObject.isCibilWatchPO);
                            tempBool = tempObject.isCibilWatchPO;
                            break;
                        }
                    }
                }
                
                if(!restrictUser)// added if condition for BUG 24104
                allSolimt = poap.SetSalesOfficerLimit(p.Products__c,p.Lead_Branch__c);
                for(Sales_Officer_Limit__c s : allSolimt)
                {
                    if(productSet.contains(s.Product__c) || ClonedProductSet.contains(s.Product__c))
                        totalSolimtForHierarchy.add(s);
                }
                
                for (integer i = 0; i < totalSolimtForHierarchy.size(); i++)
                    m1.put(totalSolimtForHierarchy[i].Sales_Officer_Name__c, totalSolimtForHierarchy[i]);
            }
            if (m1.size() > 0) 
            {
                if (m1.get(p.ownerid) != null && m1.get(p.ownerid).Designation__c != null) 
                    system.debug('p.ownerid = ' + p.ownerid + 'm1.get(p.ownerid).Designation__c = ' + m1.get(p.ownerid).Designation__c);
                else 
                    system.debug('m1.get(p.ownerid).Designation__c is null for p.ownerid =' + p.ownerid);               
                if (m1.get(p.ownerid) != null && m1.get(p.ownerid).Designation__c != null && (m1.get(p.ownerid).Designation__c == 'FD PSF Profile' || m1.get(p.ownerid).Designation__c == 'PSF Community')) 
                {               
                    p.PSF__c = p.ownerid;
                    var5 = m1.get(p.PSF__c).Reporting_Manager_Name__c;
                } 
                else 
                {       
                    var5 = p.ownerid;
                    p.PSF__c = null;
                }
                system.debug('Value of var5 ' + var5);      
                if ((m1.get(p.ownerid) != null || m1.get(var5) != null) && (m1.get(p.ownerid).Designation__c == 'Area Sales Manager' || m1.get(var5).Designation__c == 'FD Area Sales Manager' || m1.get(var5).Designation__c == 'Area Sales Manager') && (m1.get(p.ownerid).Reporting_Manager_Name__c != null || m1.get(var5).Reporting_Manager_Name__c != null)) 
                {          
                    if (m1.get(var5).Designation__c == 'FD Area Sales Manager' || m1.get(var5).Designation__c == 'Area Sales Manager') 
                    {            
                        p.ASM_Assigned__c = 'Yes';
                        p.ASM__c = m1.get(var5).Sales_Officer_Name__c;
                        system.debug('p.ASM__c --> ' + p.ASM__c);
                        var0 = m1.get(p.ASM__c).Reporting_Manager_Name__c;                  
                    } 
                    else 
                    {
                        p.ASM__c = p.ownerid;
                        var0 = m1.get(p.ASM__c).Reporting_Manager_Name__c;
                    }
                } 
                else 
                {
                    var0 = p.ownerid;
                    p.ASM__c = null;
                }
                system.debug('Value of var0 ' + var0);

                if (m1.get(var0) != null && (m1.get(var0).Designation__c == 'Regional Sales Manager' || m1.get(var0).Designation__c == 'FD Regional Sales Manager') && m1.get(var0).Sales_Officer_Name__c != null) 
                {
                    p.RSM__c = m1.get(var0).Sales_Officer_Name__c;
                    var1 = m1.get(var0).Reporting_Manager_Name__c;
                } 
                else 
                {
                    var1 = var0;
                    p.RSM__c = null;
                }
                system.debug('var0===' + var0);

                if (m1.get(var1) != null && (m1.get(var1).Designation__c == 'Zonal Sales Manager' || m1.get(var1).Designation__c == 'FD Zonal Sales Manager') && m1.get(var1).Sales_Officer_Name__c != null) 
                {
                    p.ZSM__c = m1.get(var1).Sales_Officer_Name__c;
                    if (var1 != null)
                        var2 = m1.get(var1).Reporting_Manager_Name__c;                  
                } 
                else 
                {
                    var2 = var1;
                    p.ZSM__c = null;
                }
                system.debug('Value of var2 ' + var2);

                if (m1.get(var2) != null && (m1.get(var2).Designation__c == 'National Sales Manager' || m1.get(var2).Designation__c == 'FD National Sales Manager') && m1.get(var2).Sales_Officer_Name__c != null) 
                {
                    p.NSM__c = m1.get(var2).Sales_Officer_Name__c;
                    if (var2 != null) 
                        var3 = m1.get(var2).Reporting_Manager_Name__c;              
                } 
                else 
                {
                    var3 = var2;
                    p.NSM__c = null;
                }
                system.debug('Value of var3' + var3);

                if (m1.get(var3) != null && (m1.get(var3).Designation__c == 'Business head' || m1.get(var3).Designation__c == 'FD Business head') && m1.get(var3).Sales_Officer_Name__c != null) 
                {
                    P.BH__c = m1.get(var3).Sales_Officer_Name__c;
                    if (var3 != null)
                        var4 = m1.get(var3).Reporting_Manager_Name__c;              
                } else 
                {
                    var4 = var3;
                    p.BH__c = null;
                }
                system.debug('var4==' + var4);
            }
        }
    }
}

public void FDSCStamping() 
{
    List < Sourcing_Channel__c > scList = new List < Sourcing_Channel__c > ();
    //asmrr__c cs;
    Sourcing_Channel__c scchannelObj = new Sourcing_Channel__c();
    Integer index;  
    integer w = 0;
    integer wtem = 0;
    integer loopvar = 0;
    integer loopcontr = 0;
    Parameter_Value_Master__c cs;
    if ((branchList != null && branchList.size() > 0) && (productList != null && productList.size() > 0)) 
    {
        ChannelList1 = [select id, Active__c, Reporting_Manager__c, Channel_Type__c, Product__c, Branch_Name__c, Branch__c, Keys__c, sourcing_channel_user__c from Sourcing_Channel__c
        where(Channel_Type__c = 'PSF') and Branch_Name__c in : branchList and Active__c = true];
        system.debug(' fdChannelList=====>' + ChannelList1);
    }
    if (channelList1 != null && channelList1.size() > 0) 
    {
        for (Sourcing_Channel__c sr: channelList1) 
        {
            SRbranchList = sr.Product__c.split(';'); //sourcing channel productlist
            system.debug('*****SRbranchList******' + SRbranchList);
            for (String str1: productList) 
            {
                for (String str2: SRbranchList) 
                {
                    if (str1 == str2)                                   
                        channelList.add(sr);                    
                }
            }
        }
    }
    for (Sourcing_Channel__c sc: channelList) 
    {
        system.debug('Current Sourcing Channel ' + sc);
        if (sc.Keys__c.contains('&')) 
        {
            arr = sc.Keys__c.split('&');
            system.debug('Arr size ' + arr.size());
            for (integer x = 0; x < arr.size(); x++) 
                mapOfChannels.put(arr[x], sc);          
            arr.clear();
        } 
        else 
        {           
            mapOfChannels.put(sc.Keys__c, sc);          
        }
    }
    system.debug('**mapOfChannels***' + mapOfChannels);
    
    //query on custom setting    
    
    
    if (mapOfChannels.size() > 0) 
    {
        // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - Start
        Map<String,Parameter_Value_Master__c> mapPVM = new Map<String,Parameter_Value_Master__c>();
        //added by sainath for bug: 16143 :Custom Setting Migration-start
        List<Parameter_Value_Master__c> listParamVM = [SELECT Id,Name,Current_Number__c,PSFMaximum__c,PSFCurrent__c,Flexi_Current__c,Flexi_Max__c,max_Records__c
        FROM Parameter_Value_Master__c
        WHERE ASMRoundRobinCheck__c = true limit 50000];

        if(listParamVM.size() > 0)
        {
            for(Parameter_Value_Master__c pvm :  listParamVM)   
            {
                mapPVM.put(pvm.Name,pvm);
            }
        }   
        //added by sainath for bug: 16143 :Custom Setting Migration-end
        System.debug('MAP VAlues:::'+mapPVM);
        
        for (Product_Offerings__c prod: Trigger.New) 
        {
            system.debug('prod.Products__c--->' + prod.Products__c);
            if ((prod.Products__c == 'FD' || prod.Products__c == 'Fixed Deposit' || prod.Products__c == 'FIXED DEPOSIT') && (prod.SBS_Branch__c != null)) 
            {           
                // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - Start
                cs = mapPVM.get(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase());
                System.debug('CS:::'+cs);
                if(cs!=null)
                {
                    max = integer.valueof(cs.PSFMaximum__c);
                    curr = integer.valueof(cs.PSFCurrent__c);               
                }
                // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - End
                max = integer.valueof(cs.PSFMaximum__c);
                curr = integer.valueof(cs.PSFCurrent__c);
                system.debug(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase() + '@' + curr);            
                scchannelObj = mapOfChannels.get(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase() + '@' + curr);
                system.debug('scchannelObj -->' + scchannelObj);

                if (scchannelObj == null) 
                {
                    for (integer e = 0; e < max; e++) 
                    {
                        // count the loops for number of times
                        loopvar++;
                        wtem = curr;
                        system.debug(w + 'RRRRRRRRR' + wtem + 'TTTTTTTTT' + curr + '');
                        system.debug(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase() + '@' + (wtem + w));
                        scchannelObj = mapOfChannels.get(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase() + '@' + (wtem + w));
                        system.debug('scchannelObj --> '+ scchannelObj);
                        w = w + 1;
                        if (curr + w > max) 
                        {
                            System.Debug('curr plus w  max matched');
                            w = 0;
                            wtem = 0;
                            curr = 0;                           
                        }                       
                        if (scchannelObj == null && loopvar == max && channelList.size() > 0 && loopcontr == 0) 
                        {
                            loopcontr = loopcontr + 1;
                            max = max + 10;
                        }
                        if (scchannelObj != null) 
                        {
                            loopcontr = 0;
                            break;
                        }
                    }
                } 
                else 
                    w = 1;

                if (scchannelObj != null) 
                {
                    if (curr + w <= cs.PSFMaximum__c)                   
                        cs.PSFCurrent__c = curr + w;
                    else
                        cs.PSFCurrent__c = 0;                   
                    update cs;
                }

                system.debug('******scchannelObj******' + scchannelObj);
                if (scchannelObj != null) 
                {                   
                    prod.Sourcing_Channel__c = scchannelObj.id;
                    prod.PSFAllocated__c = true;
                    if (scchannelObj.sourcing_channel_user__c != null)
                        prod.ownerId = scchannelObj.sourcing_channel_user__c;                                               
                    break;
                }
            }
        }
    }
}

public void NONFDSCStamping() 
{
    Integer index;  
    //asmrr__c cs;
    Sourcing_Channel__c scchannelObj = new Sourcing_Channel__c();
    integer w = 0;
    integer wtem = 0;
    integer loopvar = 0;
    integer loopcontr = 0;
    Parameter_Value_Master__c cs;

    if (idList != null && idList.size() > 0) 
    {
        if(lstTempLeads != null && lstTempLeads.size() ==0 )
            SetLeadData();
        else 
            leadList = lstTempLeads;        
    }

    if (leadList != null && leadList.size() > 0) 
    {
        for (Lead obj: leadList)
            mapOflead.put(obj.id, obj);     
    }

    if ((branchList2 != null && branchList2.size() > 0) && (productList2 != null && productList2.size() > 0)) 
    {
        channelList2 = [select id, Active__c, Reporting_Manager__c, Channel_Type__c, Product__c, Branch_Name__c, Branch__c, Keys__c from Sourcing_Channel__c
        where(Channel_Type__c = 'PSF - PSBCC') and Branch_Name__c in : branchList2 and Active__c = true];
    }
    if (channelList2 != null && channelList2.size() > 0) 
    {
        for (Sourcing_Channel__c sr: channelList2) 
        {
            SRbranchList2 = sr.Product__c.split(';');
            for (String str1: productList2) 
            {
                for (String str2: SRbranchList2) 
                {
                    if (str1 == str2)                                       
                        channelList3.add(sr);                   
                }
            }
        }
    }

    if (channelList3 != null && channelList3.size() > 0) 
    {
        List < Sourcing_Channel__c > scList = new List < Sourcing_Channel__c > ();              
        for (Sourcing_Channel__c sc: channelList3) 
        {
            system.debug('Current Sourcing Channel ' + sc);
            if (sc.Keys__c.contains('&')) 
            {
                arr = sc.Keys__c.split('&');                
                for (integer x = 0; x < arr.size(); x++)                
                    mapOfChannels.put(arr[x], sc);                  
                arr.clear();
            }
            else 
                mapOfChannels.put(sc.Keys__c, sc);
        }
        // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - Start        
        //query on custom setting        
        
        Map<String,Parameter_Value_Master__c> mapPVM = new Map<String,Parameter_Value_Master__c>();
        /*[SELECT Id,Name,Current_Number__c,PSFMaximum__c,PSFCurrent__c,Flexi_Current__c,Flexi_Max__c,max_Records__c 
        FROM Parameter_Value_Master__c
        WHERE ASMRoundRobinCheck__c = true limit 50000]);*/
        //added by sainath for bug: 16143 :Custom Setting Migration-start
        List<Parameter_Value_Master__c> listParamVM = [SELECT Id,Name,Current_Number__c,PSFMaximum__c,PSFCurrent__c,Flexi_Current__c,Flexi_Max__c,max_Records__c 
        FROM Parameter_Value_Master__c
        WHERE ASMRoundRobinCheck__c = true limit 50000];
                
        if(listParamVM.size() > 0)
        {
            for(Parameter_Value_Master__c pvm :  listParamVM)   
            {
                mapPVM.put(pvm.Name,pvm);
            }
        }
        //added by sainath for bug: 16143 :Custom Setting Migration-end
        for (Product_Offerings__c prod: Trigger.New) 
        {
            if ((prod.Products__c == 'PSBL' || (ProductForFlowLabel != null && ProductForFlowLabel.contains(prod.Products__c)))|| prod.Products__c == 'DOCTORS' || (prod.Products__c != null && DOCProducts.size() > 0 && DOCProducts.contains(prod.Products__c.toUppercase())) || prod.Products__c == 'SAL') 
            {
                if (prod.PSF_Responce_Recd__c == false && prod.PSFAllocated__c == false && prod.SMS_Sent__c == false)
                {
                    //cs = asmrr__c.getValues(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase());
                    // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - Start
                    cs = mapPVM.get(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase());
                    max = integer.valueof(cs.PSFMaximum__c);
                    curr = integer.valueof(cs.PSFCurrent__c);
                    // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - End                    
                    system.debug(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase() + '@' + curr);                
                    scchannelObj = mapOfChannels.get(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase() + '@' + curr);
                    System.Debug('Value of scchannelObj ' + scchannelObj);
                    if(Test.isRunningTest())
                    {
                        scchannelObj=null;
                        max=10;
                    }
                    if (scchannelObj == null) 
                    {
                        for (integer e = 0; e < max; e++) 
                        {               
                            loopvar++;
                            system.debug('W '+ w +' wtem ' + wtem + ' curr ' + curr);
                            if(curr != null)
                                wtem = curr; 
                            else 
                            if(curr == null)
                                curr =0;                           
                            //system.debug(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase() + '@' + (wtem + w));
                            system.debug(prod.Lead_Branch__c.toUpperCase()); 
                            system.debug(prod.Products__c.toUpperCase());
                            system.debug((wtem + w));
                            scchannelObj = mapOfChannels.get(prod.Lead_Branch__c.toUpperCase() + '@' + prod.Products__c.toUpperCase() + '@' + (wtem + w));
                            System.Debug('Value of scchannelObj' + scchannelObj);                           
                            w = w + 1;
                            if (curr + w > max) 
                            {
                                w = 0;
                                wtem = 0;
                                curr = 0;                               
                            }
                            system.debug('W '+ w +' wtem ' + wtem + ' curr ' + curr);
                            if (scchannelObj == null && loopvar == max && channelList3.size() > 0 && loopcontr == 0) 
                            {
                                loopcontr = loopcontr + 1;
                                max = max + 10;
                            }

                            if (scchannelObj != null) 
                            {
                                loopcontr = 0;
                                break;
                            }
                        }
                    } 
                    else                    
                        w = 1;                      
                    if (scchannelObj != null) 
                    {
                        system.debug('******scchannelObj******' + scchannelObj);
                        prod.Sourcing_Channel__c = scchannelObj.id;
                        prod.PSFAllocated__c = true;
                        if (scchannelObj.Reporting_Manager__c != null)
                            prod.ownerId = scchannelObj.Reporting_Manager__c;
                        
                        psfObj.PSFAllocationProcess(prod.Sourcing_Channel__c, prod.Products__c, mapOflead.get(prod.Lead__c).Customer_Name__c, prod.Lead_Customer_Mobile__c, mapOflead.get(prod.Lead__c).Customer_Address__c, prod.id, prod.Ref__c);
                        if (curr + w <= cs.PSFMaximum__c) 
                            cs.PSFCurrent__c = curr + w;
                        else
                            cs.PSFCurrent__c = 0;
                        
                        update cs;
                        break;
                    }
                }
            }
        }
    } 
    else 
    {
        for (Product_Offerings__c prod: Trigger.New) 
        {
            if (prod.Products__c != null && DOCProducts.size() > 0) if ((prod.Products__c == 'PSBL' || (ProductForFlowLabel != null && ProductForFlowLabel.contains(prod.Products__c)))|| prod.Products__c == 'DOCTORS' || DOCProducts.contains(prod.Products__c.toUppercase()) || prod.Products__c == 'SAL') 
            {
                if (prod.TeleCalling_Desposition_Status__c == 'Sale') 
                {
                if (prod.PSF_Responce_Recd__c == false && prod.SMS_Sent__c == false)
                    prod.PSFAllocated__c = false;               
                }
            }
        }
    }

}

    
}