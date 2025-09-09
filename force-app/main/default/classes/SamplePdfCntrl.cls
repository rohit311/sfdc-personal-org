public class SamplePdfCntrl {
    public String vfProperty{get;set;}
    
    public SamplePdfCntrl() {
    	vfProperty = ApexPages.currentPage().getParameters().get('vfProperty');
    }
}