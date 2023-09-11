public class AccountUtility {

    public static void viewAnnualRevenue(){
        List<Account> accountsList = [SELECT Name,AnnualRevenue FROM Account];
        
        for(Account acc : accountsLIst){
            String acctRev = acc.Name + ':'+ acc.AnnualRevenue;
            System.debug(acctRev);
        }
    }

}