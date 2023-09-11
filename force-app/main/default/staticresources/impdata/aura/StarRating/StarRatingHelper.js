({
    loadRatingElement: function(component, helper, ratingElement){
      
        $( ratingElement ).raty({
            starOff  : '/resource/RatingPlugin/images/star_off_darkgray.png',
            starOn   : '/resource/RatingPlugin/images/star_on.png',
         /*   click: function(score, evt) {
                
                if(score == null ) score = 0;
                if(component.get("v.currentRating") != score ){
                    //var result = confirm('Click OK button to confirm update Rating.');
                    if( result ){
                        
                        component.set("v.newRating", score);
                        $(".star-rating").toggle();
                        helper.updateRating( component );
                    }else{
                        return false;
                    }
                } 
            }*/
        });
    },
    
})