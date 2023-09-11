trigger PreUpdate on SOL_CAM__c (after Insert) {
    list<SOL_CAM__C> so1l =new list<SOL_CAM__C>();
    List<Opportunity> Loan = new List<Opportunity>();
    if (!ControlRecursiveCallofTrigger_Util.hasPreUpdate()){
        ControlRecursiveCallofTrigger_Util.setPreUpdate();   
        Loan=[select id,Loan_Application_Number__c,Customer_email_id__c,Branch_Type1__c,Amount_Rs__c,Approved_Tenor__c,Loan_Amount__c,      Tenor__c,Approved_Rate__c,StageName,Approved_Loan_Amount__c,Payment_Successful__c,Product__c from Opportunity where id=:Trigger.New[0].Loan_Application__c];
        if(Trigger.IsInsert){
            so1l=[select id,Applicant__r.Contact_Name__r.Employer__r.Company_Category__C,Monthly_Net_Salary__c from SOL_CAM__C where id=:Trigger.New[0].id];
            system.debug('category value*******'+SO1L[0].Applicant__r.Contact_Name__r.Employer__r.Company_Category__C);  
       
            for(SOL_CAM__C sol:so1l) {
                // system.debug('netsal*********'+sol.Monthly_Net_Salary__c+'xxx'+Loan[0].Branch_Type1__c+'ccc'+SOL.Applicant__r.Contact_Name__r.Employer__r.Company_Category__C);
                
                //Bug Id : 17501 SHL change
                boolean isSHOLProductLineProduct = false;  
                transient string SHOLProductLineProducts = Label.SHOL_ProductLine_Products;
                if(SHOLProductLineProducts != null && SHOLProductLineProducts != '' )
                {
                    set < string > setSHOLProdName = new set < string > ();
                    setSHOLProdName.addAll(SHOLProductLineProducts.split(';'));
                    if (setSHOLProdName != null && setSHOLProdName.size() > 0 && Loan != null &&Loan.size()>0&& Loan[0].Product__c != null) 
                    {
                        if(setSHOLProdName.contains(Loan[0].Product__c))
                        isSHOLProductLineProduct = true; 
                    }
                }
                
                if(sol.Monthly_Net_Salary__c!=null && Loan != null &&Loan.size()>0 && Loan[0].Branch_Type1__c!=null && SOL.Applicant__r.Contact_Name__r.Employer__r.Company_Category__C!=null && !(isSHOLProductLineProduct))
                {
           
                    list<SOL_Cam_Rackrate__c> solraclist=SOL_Cam_Rackrate__c.getall().values();
                    for(SOL_Cam_Rackrate__c onsol : solraclist)
                    {
                        //if(onsol.Product_Type__c=='SOL')
                        system.debug('****************'+onsol.Company_Category__c+'cccccccc'+SOL.Applicant__r.Contact_Name__r.Employer__r.Company_Category__C);
                      
                if(onsol.Company_Category__c==sol.Applicant__r.Contact_Name__r.Employer__r.Company_Category__C&& Loan != null&&Loan.size()>0 && Loan[0].Branch_Type1__c.toLowerCase().contains(onsol.City_Tier__c.toLowerCase())
                     && sol.Monthly_Net_Salary__c > onsol.Net_Sal_From__c && sol.Monthly_Net_Salary__c <= onsol.Net_Sal_To__c)
                        {
                            //moved from solcamcalculation START
                            loan[0].Processing_Fees__c=onsol.PF__c;
                           //moved from solcamcalculation END
                            sol.ROI__C=onsol.Rack_Rate__c;
                           
                           //commented code Replaced by above line
                           /* if(Loan[0].Branch_Type1__c.toLowerCase()=='tier ii'){
                                
                                if(Loan[0].Branch_Type1__c.toLowerCase()==onsol.City_Tier__c.toLowerCase()){
                                    sol.ROI__C=onsol.Rack_Rate__c;
                                    system.debug('1111bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'+Sol.ROI__C);
                                    //commented for optimization
                                    //update sol;
                                }
                            }else{
                                sol.ROI__C=onsol.Rack_Rate__c;
                                system.debug('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'+Sol.ROI__C);
                                //commented for optimization
                                //update sol;
                            }*/
                        }
                        //  update sol;
                 
                    }
                }else if(!CommonUtility.isEmpty(Loan)  && Loan[0].Product__c !=null && isSHOLProductLineProduct){
                  List<SHOL_IRR__c> mcs = SHOL_IRR__c.getall().values();
          Decimal NetSal = sol.Monthly_Net_Salary__c;     
          sol.ROI__c = decimal.valueof(label.SHOL_Default_ROI);
                Loan[0].Processing_Fees__c=decimal.valueof(label.SHOL_Default_PF);
                          
          for(SHOL_IRR__c x :mcs){
            if (sol.Applicant__r.Contact_Name__r.Employer__c!=null &&  x.Company_Category__c == sol.Applicant__r.Contact_Name__r.Employer__r.Company_Category__c && (NetSal>=x.Net_Salary_From__c && NetSal<=x.Net_salary_to__c)) {
                sol.ROI__c = x.ROI__c;
                Loan[0].Processing_Fees__c=x.PF__c;
                  System.debug(' Record Found For PF And ROI-->'+x.PF__c+' '+x.ROI__c);
                break;
            }
          }     
                }
            }
            //code for optimization. solcam moved 
            if(!CommonUtility.isEmpty(Loan) && Loan.size()>0 && !CommonUtility.isEmpty(so1l)){
              List<De_Dupe__c> deDupeList = [SELECT id , Source_Or_Target__c, Customer_ID__c, Ecs_Response__c FROM De_Dupe__c WHERE Loan_Application__c= :Loan[0].Id AND Source_Or_Target__c = 'Source' LIMIT 1];
              if(!CommonUtility.isEmpty(deDupeList)){
                String jsonStr = deDupeList[0].Ecs_Response__c;
                
                if(!CommonUtility.isEmpty(jsonStr)){
                  Map<String, Object> jsMap = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);
                  
                  so1l[0].Bank_Acc_No__c = jsMap.containsKey('accNo') ? (String) jsMap.get('accNo') : null;
                       // String EcsAmt = jsMap.containsKey('accNo') ? (String) jsMap.get('accNo') : '';
                        so1l[0].ECS_Amount__c = jsMap.containsKey('balLimit') ? Decimal.valueOf((String) jsMap.get('balLimit')) : null;
                        if(jsMap.containsKey('endDate')){
                            List<String> dateLst = ((String)jsMap.get('endDate')).split('-');
                            if(!CommonUtility.isEmpty(dateLst) && dateLst.size() == 3){
                                Date dt = Date.newinstance(Integer.valueOf(dateLst[0]), Integer.valueOf(dateLst[1]), Integer.valueOf(dateLst[2]));
                                so1l[0].ECS_validity_Date__c =  dt;
                            }
                        }
                }
              }
              update so1l;
            }
      update Loan;
        }
    }
    
}