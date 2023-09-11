public class NewCaseListController{

List<Case> NewCases;
public List<Case> getNewCases(){

return [SELECT ID,CaseNumber FROM Case WHERE Status=:'New'];
}


}