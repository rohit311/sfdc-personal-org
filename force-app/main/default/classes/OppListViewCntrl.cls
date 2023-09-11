public class OppListViewCntrl{

    @AuraEnabled
    public static List<OpportunityLineItem> fetchOppProducts(String oppId){
        return [SELECT Name,ListPrice,OpportunityId FROM OpportunityLineItem WHERE OpportunityId = :oppId];
    }

    @AuraEnabled
    public static String upsertOppProds(String jsonLst){
        String result = '';

        if(jsonLst != null && jsonLst != ''){
            List<OpportunityLineItem> oppProdsLst = (List<OpportunityLineItem>)JSON.deserialize(jsonLst,List<OpportunityLineItem>.class);

                try{
                    upsert oppProdsLst;
                    result = JSON.serialize(oppProdsLst);
                }catch(Exception ex){
                    result = 'Failure';
                }

        }
        return result;
    }

    // 77
    public static Decimal calculateAverageAmount(List<Opportunity> oppList) {
      Decimal totalAmount = 0.00;

      if (oppList.size() > 0) {
        for (Opportunity oppRec : oppList) {
          totalAmount = totalAmount + (oppRec.Amount == null? 0 : oppRec.Amount);
        }
      }
      else {
        return totalAmount;
      }

      return (totalAmount/oppList.size()).setScale(2);
    }

    // 74
    public static void updateOpportunityStages() {
      List<Opportunity> opps = [SELECT Name FROM Opportunity WHERE CreatedDate < TODAY LIMIT :Limits.getLimitQueryRows()];

      if (opps.size() < 1) {
        return;
      }

      for (Opportunity oppRec : opps) {
        oppRec.StageName = 'Closed';
      }

      update opps;

    }

    // 70
    public static List<Opportunity> filterOpportunities(List<Opportunity> oppList) {
      List<Opportunity> filteredList = new List<Opportunity>();

      for (Opportunity oppRec : oppList) {
        if (oppRec.stageName != 'Closed Won') {
          filteredList.add(oppRec);
        }
      }

      return filteredList;
    }

    //65
    public static Decimal calculateTotalValue() {
      List<AggregateResult> results = [SELECT SUM(Amount) FROM Opportunity];

      if (results.size() > 0) {
        return (Decimal)results[0].get('expr0');
      }

      return 0.00;
    }

}