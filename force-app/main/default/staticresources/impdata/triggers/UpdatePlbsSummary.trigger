trigger UpdatePlbsSummary on PL_BS__c (after insert,after update) {

if (!ControlRecursiveCallofTrigger_Util.hasUpdatePlbsSummary()) {
      ControlRecursiveCallofTrigger_Util.setUpdatePlbsSummary();
system.debug('UpdatePSBLSumm.hasCallUpdatePSBLData()'+UpdatePSBLSumm.hasCallUpdatePSBLData());

String proid=userinfo.getProfileId();
    //if(!proid.contains('00e90000000ZHIp')){

if (!UpdatePSBLSumm.hasCallUpdatePSBLData()) {  
    
    UpdatePSBLSumm u =new UpdatePSBLSumm();
    u.setCallUpdatePSBLData();
    u.UpdatePSBLData(Trigger.new);
    
}
    //}
    }//End Of Recur
}// end of trigger