trigger propertyId on Property_Details__c(before insert, after update, before update) {
    Integer newpropId;
    List < Id > propLoanID = new List < Id > ();
    
    //-----------Mortgage Re-Engg Start----------
        Set<String> MortgageProducts = new Set<String>();
    //-----------Mortgage Re-Engg End----------
    
    system.debug('ControlRecursiveCallofTrigger -> ' + ControlRecursiveCallofTrigger_Util.hasAlreadyPropertyId());
    if (!ControlRecursiveCallofTrigger_Util.hasAlreadyPropertyId()) {
        ControlRecursiveCallofTrigger_Util.setAlreadyPropertyId();
        
        //-----------Mortgage Re-Engg Start----------
            if (LaonApplicationCreation__c.getValues('Mortgage Products') != null) {
              String MortgageSalProducts = LaonApplicationCreation__c.getValues('Mortgage Products').Current_product__c;
              if (MortgageSalProducts != null) {
                system.debug('***MortgageSalProducts***' + MortgageSalProducts);
                String[] arr = MortgageSalProducts.split(';');
                for (String str: arr) {
                    /*if(Loan.id!=null){
                      if(str.equalsIgnoreCase(Loan.Product__c)){
                            Mortgageflag = true;  
                        }  
                    }
                    else{
                      if(str.equalsIgnoreCase(newOpp.Product__c)){
                            Mortgageflag = true;  
                        }  
                    }*/
                  MortgageProducts.add(str);
                }
              }
              System.debug('MortgageProducts.size()='+MortgageProducts.size()+'=MortgageProducts='+MortgageProducts);
        }
        
        //-----------Mortgage Re-Engg End----------
        
        // Start of PPI v2 changes
        if(trigger.isUpdate && trigger.isBefore) {
            System.debug('<-- Before update ---> ');
            
            Map<String,String> mapOfAverageRate = new Map<String,String>();
            
            mapOfAverageRate.put('SORP-Flat','Average_Price_Individual_Flat__c');
            //mapOfAverageRate.put('SORP-Plot','Average_Price_Individual_Plot__c');
            mapOfAverageRate.put('SORP-Bungalow','Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('SORP-Floor','Average_Price_Builder_Floor__c');
            
            
            mapOfAverageRate.put('UnderConstruction Property-Flat','Average_Price_Individual_Flat__c');
            mapOfAverageRate.put('UnderConstruction Property-Bungalow','Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('UnderConstruction Property-Floor','Average_Price_Builder_Floor__c');
            
            mapOfAverageRate.put('Mixed usage-Flat','Average_Price_Individual_Flat__c');
            //mapOfAverageRate.put('Mixed usage-Plot','Average_Price_Individual_Plot__c');
            mapOfAverageRate.put('Mixed usage-Bungalow','Average_Price_Individual_Bungalow__c');
            //mapOfAverageRate.put('Mixed usage-Floor','Average_Price_Builder_Floor__c');
            
            mapOfAverageRate.put('Vacant Residential-Flat','Average_Price_Individual_Flat__c');
            mapOfAverageRate.put('Vacant Residential-Bungalow','Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Vacant Residential-Floor','Average_Price_Builder_Floor__c');
            mapOfAverageRate.put('Vacant Residential-Plot','Average_Price_Individual_Plot__c');
            
            mapOfAverageRate.put('Vacant Commercial-Bungalow','Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Vacant Commercial-Floor','Average_Price_Builder_Floor__c');
            
            mapOfAverageRate.put('Rented Residential-Floor','Average_Price_Builder_Floor__c');
            mapOfAverageRate.put('Rented Residential- Bungalow ', 'Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Rented Residential-Flat','Average_Price_Individual_Flat__c');
            
            mapOfAverageRate.put('Rented Commercial-Floor','Average_Price_Builder_Floor__c');
            mapOfAverageRate.put('Rented Commercial-Bungalow ', 'Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Rented Commercial-Flat','Average_Price_Individual_Flat__c');
            
            mapOfAverageRate.put('Rented Mixed Usage-Floor','Average_Price_Builder_Floor__c');
            mapOfAverageRate.put('Rented Mixed Usage-Bungalow ', 'Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Rented Mixed Usage-Flat','Average_Price_Individual_Flat__c');
            
            mapOfAverageRate.put('Self Occupied Mixed Usage-Floor','Average_Price_Builder_Floor__c');
            mapOfAverageRate.put('Self Occupied Mixed Usage-Bungalow ','Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Self Occupied Mixed Usage-Flat','Average_Price_Individual_Flat__c');
            
            mapOfAverageRate.put('Self Occupied Residential-Floor','Average_Price_Builder_Floor__c');
            mapOfAverageRate.put('Self Occupied Residential-Bungalow','Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Self Occupied Residential-Flat','Average_Price_Individual_Flat__c');
            
            mapOfAverageRate.put('Plot + Construction-Bungalow','Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Self Occupied Commercial-Floor','Average_Price_Builder_Floor__c');
            mapOfAverageRate.put('Self Occupied Commercial-Bungalow', 'Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Self Occupied Commercial-Flat','Average_Price_Individual_Flat__c');
            
            mapOfAverageRate.put('Self Construction- Bungalow','Average_Price_Individual_Bungalow__c');
            //mapOfAverageRate.put('Rented Residential-','Average_Rented_Price_Individual_Flat__c');
            //mapOfAverageRate.put('Rented Residential-Bungalow','Avg_Rented_Price_Individual_Bungalow__c');
            
            //mapOfAverageRate.put('Vacant Commercial-Plot','Average_Price_Individual_Plot__c');
            //mapOfAverageRate.put('Vacant Commercial-Floor','Average_Price_Builder_Floor__c');
            
            //mapOfAverageRate.put('Rented Commercial-Plot','Average_Price_Individual_Plot__c');
            //mapOfAverageRate.put('Rented Commercial-Floor','Average_Rented_Price_Builder_Floor__c');
            
            mapOfAverageRate.put('Individual Property-Flat','Average_Price_Individual_Flat__c');
            mapOfAverageRate.put('Individual Property-Plot','Average_Price_Individual_Plot__c');
            mapOfAverageRate.put('Individual Property-Bungalow','Average_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Individual Property-Floor','Average_Price_Builder_Floor__c');
            
            mapOfAverageRate.put('Rented Property-Flat','Average_Rented_Price_Individual_Flat__c');
            mapOfAverageRate.put('Rented Property-Bungalow','Avg_Rented_Price_Individual_Bungalow__c');
            mapOfAverageRate.put('Rented Property-Floor','Average_Rented_Price_Builder_Floor__c');
            
            //mapOfAverageRate.put('Resale Property-Flat','Average_Resale_Price_Individual_Flat__c');
            //mapOfAverageRate.put('Resale Property-Bungalow','Average_Resale_Price_Ind_Bungalow__c');
            //mapOfAverageRate.put('Resale Property-Floor','Average_Resale_Price_Builder_Floor__c');
            
            mapOfAverageRate.put('Construction Property-Flat','Average_Price_Individual_Flat__c');
            //mapOfAverageRate.put('Construction Property-Plot','Average_Price_Plot_Construction__c');
            mapOfAverageRate.put('Construction Property-Bungalow','Average_Price_Individual_Bungalow__c');
            //mapOfAverageRate.put('Construction Property-Floor','Average_Price_Builder_Floor__c');
            
            mapOfAverageRate.put('Plot-Plot','Average_Price_Individual_Plot__c');
        
        //mapOfAverageRate.put('SOCP-','');
        
        for(Property_Details__c  pd : trigger.New){
            double averagePropPrice;
            double averageConstructionRate;
            
            List < Area_Locality__c > areaList = [Select id, name, City__r.name, Pincode__c, State__c from Area_Locality__c where id = : pd.Area_Locality__c];
            
            if(areaList != null && areaList.size() > 0) {
                
                System.debug('<-- Inside area/locality logic ---> ');
                String propertyNatureAndTransaction = pd.Property_Type__c + '-' + pd.Nature_of_property__c;
                String fieldName = mapOfAverageRate.get(propertyNatureAndTransaction);
                
                if(fieldName != null) {
                    ID ppiid = areaList[0].id;
                    String query = 'Select id, name, Area_Locality__c, Average_Price__c, Primary_partner_value__c, Average_construction_rate_per_sqr_feet__c, ' + fieldName + ' from Property_Price_Index__c where Area_Locality__c = : ppiid and Primary_partner_value__c = true AND From_Date__c <= TODAY AND Till_Date__c >= TODAY';
                    System.debug('Query ---> ' + query);
                    List < sObject > ppiList = Database.query(query);
                    System.debug('ppiList ---> ' + ppiList);   
                    
                    if (ppiList != null && ppiList.size() > 0) {
                        Property_Price_Index__c obj = (Property_Price_Index__c)ppiList[0];
                        System.debug('Field to be retrieved ---> ' + obj.get(fieldName));
                        averagePropPrice = (Double)obj.get(fieldName);
                        pd.Avg_Property_price__c = String.valueOf(averagePropPrice);
                        //Start of changes for bungalow construction 
                        averageConstructionRate = (Double)obj.get('Average_construction_rate_per_sqr_feet__c');
                        pd.Average_Construction_Rate_per_Sq_Ft__c = String.valueOf(averageConstructionRate);
                        //End of changes for bungalow construction
                        System.debug('averagePropPrice ---> ' + averagePropPrice);
                        System.debug('averageConstructionRate ---> ' + averageConstructionRate);
                    } else {
                        averagePropPrice = 0;
                        System.debug('averagePropPrice ---> ' + averagePropPrice);
                        System.debug('averageConstructionRate ---> ' + averageConstructionRate);
                    }
                
                } else {
                    if( pd.Property_Type__c != 'SOCP' && pd.Property_Type__c != 'Rented Mixed Usage' && pd.Property_Type__c != 'Self Occupied Mixed Usage' && pd.Property_Type__c != 'Vacant Residential' && pd.Property_Type__c != 'Rented Residential' && pd.Property_Type__c != 'Self Occupied Residential' && pd.Property_Type__c != 'Self Occupied Commercial' && pd.Property_Type__c != 'UnderConstruction Property' && pd.Property_Type__c != 'Vacant Commercial'  && pd.Property_Type__c != 'Rented Commercial' && pd.Property_Type__c != 'Shares' && pd.Property_Type__c != 'Self Construction' && pd.Property_Type__c != 'Plot + Construction')
                    {
                        pd.addError('Please enter property usage and property type !!');
                    } else {
                        pd.Avg_Property_price__c = '0';
                        pd.Average_Construction_Rate_per_Sq_Ft__c = '0';
                    }
                } 
            } else {
                
                System.debug('<-- Inside project name logic ---> ');
                List < Project_Master__c > projectList = [Select id, name, Current_Rate_per_Sq_Ft__c
                                                          from Project_Master__c where id = : pd.Project_Name__c];
                
                if(projectList != null && projectList.size() > 0) {                                        
                    averagePropPrice = Double.valueOf(projectList[0].Current_Rate_per_Sq_Ft__c);
                    pd.Avg_Property_price__c = String.valueOf(averagePropPrice);
                    System.debug('averagePropPrice ---> ' + averagePropPrice);
                } else {
                    System.debug('averagePropPrice ---> ' + averagePropPrice);
                    if(pd.Product__c != null && pd.Product__c != 'FAS' && !MortgageProducts.contains(pd.Product__c)) // Added if condition for bug - 7093
                        pd.addError('Please enter either area/locality or project name to save record !!');
                }    
            }
        }
    }
    // End of PPI v2 changes
    
if (trigger.isInsert) {
            list < Property_Details__c > PropId = new list < Property_Details__c > ();

            PropId = [select id,createddate, Search_Parameter__c,Clone__c from Property_Details__c where Clone__c != true order by createddate desc Limit 1];

            if (PropId.size() > 0) {
                system.debug('xxxxxxxxxxxxx' + PropId);
                if (PropId[0].Search_Parameter__c != null) newpropId = integer.valueof(PropId[0].Search_Parameter__c) + 1;
            }
            for (Property_Details__c prop: trigger.new) {
                if (prop.Clone__c != true) {
                    prop.Search_Parameter__c = newpropId;
                }
                prop.Number_of_Shares__c = prop.Digital_Scrips_Count__c;
            }
        }

        //harsit---optimization START
        //Merged this logic in propertydigitalvalues trigger
        /*List < Property_Details__c > proplist = new List < Property_Details__c > ();

        if (trigger.isUpdate || trigger.isInsert) {
            Opportunity opp = new Opportunity(Id = trigger.new[0].Loan_Application__c);
            Double sum = 0;
            system.debug('wwwwwww');
            for (Property_Details__c prop: trigger.new) {
                if (prop.Loan_Application__c != null) {
                    propLoanID.add(prop.Loan_Application__c);
                }
            }
            system.debug('wwwwpropLoanIDwww' + propLoanID.size());
            if (propLoanID != null && propLoanID.size() > 0) {
                proplist = [select id, name, Amount_fund_property__c, Digital_Scrip_market_price__c, Number_of_Shares__c, Contribution__c from Property_Details__c where Loan_Application__c in : propLoanID limit 1000];
            }
            if (proplist != null && proplist.size() > 0) {
                for (Property_Details__c prop1: proplist) {
                    if (prop1.Amount_fund_property__c != null) {
                        sum = sum + prop1.Amount_fund_property__c;
                    }
                }
            }
            opp.Sum_of_Property_Funded_Amount__c = sum;
            if (opp.id != null && opp.Sum_of_Property_Funded_Amount__c!= null) {
                update opp;
            }
        }*/
        //harsit---optimization END
      
    }
}