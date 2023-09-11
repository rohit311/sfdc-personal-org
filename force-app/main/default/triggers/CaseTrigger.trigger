// 66
trigger CaseTrigger on Case (before update) {

  for (Case caseRec : Trigger.new) {
    if (caseRec.origin == 'Phone') {
      caseRec.Priority = 'High';
    }
  }

}