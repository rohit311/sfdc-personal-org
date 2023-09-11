public class myextension {

private final Speaker__c sp;

public string photourl{get;set;}

public string imageUrl{get;set;}

public blob Photo{get;set;}

    public string fname{get;set;}
    public string lname{get;set;}
    public string email{get;set;}
    public string bio{get;set;}



public myextension (apexpages.standardController controller){
            sp=(Speaker__c)controller.getRecord();
        }


public void addrecord(){
            try{
                
                sp.FirstName__c=fname;
                sp.LastName__c=lname;
                sp.Email__c=email;
                sp.Bio__c=bio;
                upsert sp;
                Attachment objA=new Attachment();
                objA.body = photo;
                objA.name = 'testname';
                //objA.parentid=ApexPages.currentPage().getParameters().get('id');
                objA.parentid=sp.id;
                objA.ContentType = 'application/jpg';
                insert objA;
                string Attid= objA.id;
                string attachmentid=Attid.substring(0,15);
                sp.Picture_path__c = '/servlet/servlet.FileDownload?file='+attachmentid;
                photourl = sp.Picture_path__c;
                update sp;
               
            }catch(Exception e){
                system.debug('Exception message'+e);
            }
         } 

public void UploadPhoto(){
}

}