public class PdfLwcCntrl {

    @AuraEnabled
    public static Attachment generatePdf(Id recordId) {
        PageReference pg = Page.VF_samplepdf;
        pg.getParameters().put('vfProperty', recordId);
                
        Attachment att = new Attachment();
        att.name = 'mydoc';
        att.ParentId = recordId;
        att.Body = pg.getContentAsPdf();
        att.IsPrivate = false;
        
        insert att;
        
        return att;
    }
}