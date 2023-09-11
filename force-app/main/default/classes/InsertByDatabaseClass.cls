public class InsertByDatabaseClass {

    public static void AccountInsertion(){
        List<Account> accList=new List<Account>();

        accList.add(new Account(Name='test1'));
        accList.add(new Account(Name='test2'));

        Database.SaveResult[] resList=Database.insert(accList,false);

        for(Database.SaveResult sr:resList)
        {
            if(sr.isSuccess())
            {
                System.debug('Account inserted successfully '+sr.getId());
			}
            else
            {
                for(Database.Error err:sr.getErrors())
                {
                    System.debug(err.getStatusCode()+' : '+err.getMessage());
                    System.debug( 'Account fields that caused this error '+err.getFields());
                }
			}
        }

    }

    // 75
    public static Boolean checkLeadSource(List<Lead> leadsList) {
      if (leadsList.size() < 1) {
        return false;
      }

      Boolean isSourceTest = false;
      String leadSourceToCheck = 'test';

      for (Lead leadRec : leadsList) {
        if (leadRec.source == leadSourceToCheck) {
          return true;
        }
      }

      return false;

    }
}