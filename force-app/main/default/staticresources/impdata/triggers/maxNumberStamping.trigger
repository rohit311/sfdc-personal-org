trigger maxNumberStamping on Sales_Officer_Limit__c(before insert, before update) {

 system.debug('in Trigger new Before**************');
 // Adhoc Change in SOL S
 SOLCitiesHandler SOLCitiesHandlerObj = new SOLCitiesHandler(Trigger.new, Trigger.oldMap, Trigger.newMap);
 // Adhoc Change in SOL E
 system.debug('in Trigger new After**************');
 List < Sales_Officer_Limit__c > AllRecords = new List < Sales_Officer_Limit__c > ();
 List < Sales_Officer_Limit__c > AllKeyRecords = new List < Sales_Officer_Limit__c > ();
 //Bug: 15535
 List <Parameter_Value_Master__c> asmRound = new List <Parameter_Value_Master__c> ();
 integer recordSize;
 string keyHolder, keyHolderFlexi;
 set < string > kayHolderList = new set < string > ();
 set < string > kayHolderListFlexi = new set < string > ();
 String DesignationCheck = '';
 //code start for  Bug 24104 
 string Pid = Userinfo.getProfileID();
 string Ids = Label.PO_Trigger_restrictedUserId;
 set < string > restrictedIdsSet = new set < string > ();
 if (ids != null) {
        restrictedIdsSet.addAll(Ids.split(';'));
    }
 if(restrictedIdsSet.contains(Pid))
 return;
 //code end for  Bug 24104
 for (Sales_Officer_Limit__c s: trigger.new) {

  // Adhoc Change in SOL S
  if (trigger.isinsert && trigger.isBefore) {
   system.debug('is Before and is Insert INNNNNsert');
   SOLCitiesHandlerObj.appendRuralCities();
  }
  // Adhoc Change in SOL E

  DesignationCheck = s.Designation__c;

  //if asm is not make key is blank
  if (s.Designation__c != 'Area Sales Manager' && s.Designation__c != 'FD PSF Profile') {
   s.Max_Number__c = null;
  }
  //if asm ,make the key uniq
  if (s.Designation__c == 'Area Sales Manager' || s.Designation__c == 'FD PSF Profile') {
   if (trigger.isinsert) {

    if (s.Selected_Flag__c == false) {
     AllRecords = [select Product__c, Selected_Flag__c, Max_Number__c, ASM_Branch__c from Sales_Officer_Limit__c where
      Designation__c = : DesignationCheck AND Product__c = : s.Product__c AND ASM_Branch__c = : s.ASM_Branch__c AND Selected_Flag__c = false
     ];
     system.debug('s record uis'+s);
system.debug('All records are'+AllRecords);
     // AllKeyRecords=[select id,Max_Number__c from Sales_Officer_Limit__c where Designation__c='Area Sales Manager' AND Product__c=:s.Product__c AND ASM_Branch__c=:s.ASM_Branch__c];


    }
    if (s.Selected_Flag__c == true) {
     AllRecords = [select Product__c, Selected_Flag__c, Max_Number__c, ASM_Branch__c from Sales_Officer_Limit__c where
      Designation__c = : DesignationCheck AND Product__c = : s.Product__c AND ASM_Branch__c = : s.ASM_Branch__c AND Selected_Flag__c = true
     ];
     system.debug(AllRecords.size() + 'rrrrrr');
    }


    recordSize = AllRecords.size();


    for (Sales_Officer_Limit__c sl: AllRecords) {
     if (sl.Selected_Flag__c == true) {
      kayHolderListFlexi.add(sl.Max_Number__c);
     } else {
      kayHolderList.add(sl.Max_Number__c);
     }

    }

    if (s.Selected_Flag__c == true) {
     keyHolderFlexi = s.ASM_Branch__c + '@' + s.Product__c + '@' + 'flexi@' + string.valueof(AllRecords.size());

     // this code is to fill key based on the gaps of inactive or asm chaged Solimt  

     system.debug(keyHolderFlexi + 'qqqqqqqqqqq');
     for (integer t = 0; t < kayHolderListFlexi.size(); t++) {
      system.debug(keyHolderFlexi + 'qqqqqqqqqqq');
      if (!kayHolderListFlexi.contains(keyHolderFlexi)) {
       break;
      } else {

       keyHolderFlexi = s.ASM_Branch__c + '@' + s.Product__c + '@' + 'flexi@' + t;
       system.debug(keyHolderFlexi + 'OOOOOOOO');
      }
     }

     if (AllRecords.size() == 0) {
      keyHolderFlexi = s.ASM_Branch__c + '@' + s.Product__c + '@' + 'flexi@' + (AllRecords.size());
     } else {
      if (keyHolderFlexi == null) {
       keyHolderFlexi = s.ASM_Branch__c + '@' + s.Product__c + '@' + 'flexi@' + (AllRecords.size() + 1);
       recordSize = (AllRecords.size() + 1);
      }
     }
     system.debug(keyHolderFlexi + 'OOOOOOOO');
     s.Max_Number__c = keyHolderFlexi;

    } else {
     keyHolder = s.ASM_Branch__c + '@' + s.Product__c + '@' + string.valueof(AllRecords.size());

     for (integer t = 0; t < kayHolderList.size(); t++) {
      system.debug(keyHolder + 'qqqqqqqqqqq');
      if (!kayHolderList.contains(keyHolder)) {
       break;
      } else {
       keyHolder = s.ASM_Branch__c + '@' + s.Product__c + '@' + t;
      }
     }

     if (AllRecords.size() == 0) {
      keyHolder = s.ASM_Branch__c + '@' + s.Product__c + '@' + (AllRecords.size());
     } else {
      if (keyHolder == null) {
       keyHolder = s.ASM_Branch__c + '@' + s.Product__c + '@' + (AllRecords.size() + 1);
       recordSize = (AllRecords.size() + 1);
      }
     }
     s.Max_Number__c = keyHolder;



    } //end of else      
   }

   // for update solimit 
   if (trigger.isupdate) {
       system.debug('trigger.oldmap.get(s.id).Product__c   '+trigger.oldmap.get(s.id).Product__c);
        system.debug('trigger.newmap.get(s.id).Product__c   '+trigger.newmap.get(s.id).Product__c);
        system.debug('trigger.oldmap.get(s.id).ASM_Branch__c   '+trigger.oldmap.get(s.id).ASM_Branch__c);
        system.debug('trigger.newmap.get(s.id).ASM_Branch__c   '+trigger.newmap.get(s.id).ASM_Branch__c);
        system.debug('trigger.oldmap.get(s.id).Designation__c   '+trigger.newmap.get(s.id).Designation__c);
    if (trigger.oldmap.get(s.id).Product__c != trigger.newmap.get(s.id).Product__c || trigger.oldmap.get(s.id).ASM_Branch__c != trigger.newmap.get(s.id).ASM_Branch__c || trigger.oldmap.get(s.id).Designation__c != trigger.newmap.get(s.id).Designation__c || trigger.oldmap.get(s.id).Selected_Flag__c != trigger.newmap.get(s.id).Selected_Flag__c) {

     if (s.Selected_Flag__c == true) {

      AllRecords = [select Product__c, Max_Number__c, ASM_Branch__c, Selected_Flag__c from Sales_Officer_Limit__c where
       Designation__c = : DesignationCheck AND
       Product__c = : trigger.newmap.get(s.id).Product__c AND
       ASM_Branch__c = : trigger.newmap.get(s.id).ASM_Branch__c AND
       Max_Number__c != null AND
       Selected_Flag__c = true
      ];
     } else {

      AllRecords = [select Product__c, Max_Number__c, ASM_Branch__c, Selected_Flag__c from Sales_Officer_Limit__c where
       Designation__c = : DesignationCheck AND
       Product__c = : trigger.newmap.get(s.id).Product__c AND
       ASM_Branch__c = : trigger.newmap.get(s.id).ASM_Branch__c AND
       Max_Number__c != null AND
       Selected_Flag__c = false
      ];

     }


     recordSize = AllRecords.size();


     for (Sales_Officer_Limit__c sl: AllRecords) {
      if (sl.Selected_Flag__c == true) {
       kayHolderListFlexi.add(sl.Max_Number__c);
      } else {
       kayHolderList.add(sl.Max_Number__c);
      }

     }
     if (s.Selected_Flag__c == true) {
      keyHolderFlexi = s.ASM_Branch__c + '@' + s.Product__c + '@' + 'flexi@' + string.valueof(AllRecords.size());

      // this code is to fill key based on the gaps of inactive or asm chaged Solimt  


      for (integer t = 0; t < kayHolderListFlexi.size(); t++) {
       system.debug(keyHolder + 'qqqqqqqqqqq');
       if (!kayHolderListFlexi.contains(keyHolderFlexi)) {
        break;
       } else {
        keyHolderFlexi = s.ASM_Branch__c + '@' + s.Product__c + '@' + 'flexi@' + t;
       }
      }
      if (keyHolder == null) {
       keyHolderFlexi = s.ASM_Branch__c + '@' + s.Product__c + '@' + 'flexi@' + (AllRecords.size() + 1);
       recordSize = (AllRecords.size() + 1);
      }

      s.Max_Number__c = keyHolderFlexi;

     } else {
      keyHolder = s.ASM_Branch__c + '@' + s.Product__c + '@' + string.valueof(AllRecords.size());

      for (integer t = 0; t < kayHolderList.size(); t++) {
       system.debug(keyHolder + 'qqqqqqqqqqq');
       if (!kayHolderList.contains(keyHolder)) {
        break;
       } else {
        keyHolder = s.ASM_Branch__c + '@' + s.Product__c + '@' + t;
       }
      }
      if (keyHolder == null) {
       keyHolder = s.ASM_Branch__c + '@' + s.Product__c + '@' + (AllRecords.size() + 1);
       recordSize = (AllRecords.size() + 1);
      }

      s.Max_Number__c = keyHolder;
     } //end of else 



    } else {

     if (s.Selected_Flag__c == true) {
      AllRecords = [select Product__c, Max_Number__c, ASM_Branch__c from Sales_Officer_Limit__c where
       Designation__c = : DesignationCheck AND
       Product__c = : s.Product__c AND
       ASM_Branch__c = : s.ASM_Branch__c AND
       Max_Number__c != null AND
       Selected_Flag__c = true
      ];
     } else {
      AllRecords = [select Product__c, Max_Number__c, ASM_Branch__c from Sales_Officer_Limit__c where
       Designation__c = : DesignationCheck AND
       Product__c = : s.Product__c AND
       ASM_Branch__c = : s.ASM_Branch__c AND
       Max_Number__c != null AND
       Selected_Flag__c = false
      ];

     }

     recordSize = AllRecords.size();

     //  if(trigger.oldmap.get(s.id).Max_Number__c==null)                                       
     //  s.Max_Number__c=s.ASM_Branch__c+'@'+s.Product__c+'@'+string.valueof(AllRecords.size()); 

     if (trigger.oldmap.get(s.id).Max_Number__c != null && (trigger.oldmap.get(s.id).Product__c == trigger.newmap.get(s.id).Product__c && trigger.oldmap.get(s.id).ASM_Branch__c == trigger.newmap.get(s.id).ASM_Branch__c))
      s.Max_Number__c = trigger.oldmap.get(s.id).Max_Number__c;

    }
   }

   string branchAndProduct = s.ASM_Branch__c + '@' + s.Product__c;

   try {
    // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - Start
    asmRound = [SELECT Name, Current_Number__c, max_Records__c, Flexi_Max__c, Flexi_Current__c 
                FROM Parameter_Value_Master__c 
                WHERE Name = :branchAndProduct
                AND ASMRoundRobinCheck__c = true];
    System.debug('ASM Round::'+asmRound );
    if (asmRound != null)
     if (asmRound.size() > 0) {
      if (s.Selected_Flag__c == true) {
       asmRound[0].Flexi_Max__c = recordSize;
       if (asmRound[0].Flexi_Current__c == null)
        asmRound[0].Flexi_Current__c = 0;
      } else {
       asmRound[0].max_Records__c = recordSize;
       if (asmRound[0].Current_Number__c == null)
        asmRound[0].Current_Number__c = 0;
      }
      UPDATE asmRound;
     } else {
      
      Parameter_Value_Master__c arr = new Parameter_Value_Master__c();        
      arr.Name = s.ASM_Branch__c + '@' + s.Product__c;
      arr.ASMRoundRobinCheck__c = true;
      if (s.Selected_Flag__c == true) {
       arr.Flexi_Current__c = 0;
       arr.Flexi_Max__c = recordSize;
      } else {
       arr.max_Records__c = recordSize;
       arr.Current_Number__c = 0; 
      }
      INSERT arr;
     }
     // Aman Porwal - Custom Setting Migration Changes - 06/11/17 - End

   } catch (exception e) {}

  } //only for asm 
  if (trigger.isupdate && trigger.isBefore) {
   // Adhoc Change in SOL S
   system.debug('is Before and is Insert INNNNN');
   SOLCitiesHandlerObj.appendRuralCities();
  }
  // Adhoc Change in SOL E
 } //for loop


}