public class assign6_2_extension {

public Speaker__c sp{get;set;}
public string str{get;set;}

    public assign6_2_extension(ApexPages.StandardController controller) {
         this.sp=new Speaker__c();
         document=new Document();
    }
    
    public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }
 
  public PageReference upload() {
 
    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); // put it in running user's folder
 
    try {
      insert document;
     sp.picture_path__c=document.URL;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
      return null;
    } finally {
      document.body = null; // clears the viewstate
      document = new Document();
    }
 
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    return null;
  }

    

}