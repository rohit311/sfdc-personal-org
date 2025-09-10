public with sharing class RealTimeCaseController {
    @AuraEnabled(Cacheable=true)
    public static List<Case> getNewCases(Integer recordLimit){

      if (recordLimit == null || recordLimit == 0) {
        recordLimit = 20;
      }

      return [SELECT Id, CaseNumber, Subject, Priority, Status, Type FROM Case ORDER BY CreatedDate DESC LIMIT :recordLimit];
    }
}