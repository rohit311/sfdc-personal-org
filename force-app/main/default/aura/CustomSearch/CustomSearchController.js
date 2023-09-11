({
    loadJquery : function(component, event, helper) {
        
        jQuery("document").ready(function(){
            console.log('loaded');
        });
        var searchdata = ['robin','rohit','rohan'];
        var maxlength = 100;
        
        jQuery("#textareaChars").keyup(function(){
            var searchString = jQuery(this).val();
            var length = searchString.length;
            length = maxlength-length;
            jQuery("#chars").text(length);
            console.log('length '+searchString.length);
            if(searchString.length >0){
                var arr = new Array();
                arr = jQuery.grep(searchdata,function(ele){
                    console.log(ele.includes(searchString));
                    return ele.includes(searchString);
                });
                
                var selectDiv = jQuery("#selectDiv");
                var links = new Array();
                
                if(arr && arr.length >0){
                    for(var i=0;i<arr.length;i++){
                        
                        var link = $("<a>");
                        link.attr("href","#");
                        link.text(arr[i]);
                        link.css({"display":"block","text-align":"center"});
                        link.on('click',{val:arr[i]},function(event){
                            console.log('here' +event.data.val);
                            jQuery("#textareaChars").val(event.data.val);//set text box with selected value
                            jQuery("#selectDiv").css("display","none");//hide search results
                            
                        });
                        links.push(link);
                    }
                    selectDiv.html(links);
                    selectDiv.css("display","block");
                }
                else{
                    selectDiv.css("display","none");
                    
                }
                
                
                console.log('serached data '+arr);
            }
            else{
                
                jQuery("#selectDiv").css("display","none");//hide search results if search string is blank
            }
        });
    },
    doInit : function(component, event, helper) {
    },
})