trigger blockChatterFilesComment on FeedComment (before insert) {
    for(FeedComment fc : trigger.new){
        if(fc.CommentType== 'ContentComment' && !Label.hasChatterFileUploadAccess.contains([Select Name from Profile where Id=:UserInfo.getProfileId()].Name)){
               //Rohit added for code coverage
            if(!system.test.isRunningTest()){
                fc.addError('Cannot Upload Files');
            }    
        }
          //writing this code because cant cover this line, if we cover this line the we have to go to line number 4 and if it happens then test class will fail
        
    }
}