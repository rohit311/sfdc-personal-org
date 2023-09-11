public class OpportunityPageController{

public List<Opportunity> getopportunities()
{

   return [SELECT id,Name,Account.Name,CloseDate FROM Opportunity WHERE OwnerID=:UserInfo.getUserID()];
}
}