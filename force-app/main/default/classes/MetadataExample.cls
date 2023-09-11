public class MetadataExample {

    public void updateMetadata(){
        Metadata.DeployContainer deployContainer = new Metadata.DeployContainer();
    
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        customMetadata.fullName = 'MyNamespace__MyMetadataTypeName.MyMetadataRecordName';
        
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = 'customField__c';
        customField.value = 'New value';
        
        customMetadata.values.add(customField);
        
        deployContainer.addMetadata(customMetadata);
        
        Id asyncResultId = Metadata.Operations.enqueueDeployment(deployContainer, null);
    }
}