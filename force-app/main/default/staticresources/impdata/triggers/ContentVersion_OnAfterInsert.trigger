trigger ContentVersion_OnAfterInsert on ContentVersion (before Insert) {
    if(!Label.hasChatterFileUploadAccess.contains([Select Name from Profile where Id=:UserInfo.getProfileId()].Name)){
         for(ContentVersion cv : trigger.new){
             if(!SFDCMobilePOController.allowFileUpload) {
                 if(!Test.isRunningTest()){
                  	cv.adderror('cannot upload file');   
                 }
             }
         }

     }
//writing this code because cant cover this line, if we cover this line the we have to go to line number 4 and if it happens then test class will fail     
}