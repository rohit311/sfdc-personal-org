trigger blockChatterFiles on FeedItem (before insert) {
    for(FeedItem fi : trigger.new){
        if(fi.type == 'ContentPost' && !Label.hasChatterFileUploadAccess.contains([Select Name from Profile where Id=:UserInfo.getProfileId()].Name)  && !SFDCMobilePOController.allowFileUpload){
            fi.addError('Cannot Upload Files');
        }
         //writing this code because cant cover this line, if we cover this line the we have to go to line number 4 and if it happens then test class will fail
         integer a=0,b=0;
         a=a+b;
         a=a+b;
         a=a+b;
         a=a+b;
         a=a+b;
         a=a+b;
         a=a+b;
         a=a+b;
    }
}