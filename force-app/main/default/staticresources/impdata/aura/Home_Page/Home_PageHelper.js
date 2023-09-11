({
    
 //Added by Hrishekesh  to change diary color at home page ==>Bug id 19263 start-->
 getDiaryColorCode : function(component, event) {
       console.log('Diary color started ');
       this.showhidespinner(component,event,true);
        this.executeApex(component, 'getDiaryColorMethod', {},
                         function (error, result) {
                             console.log('getDiaryColorMethod  '+result);
                             if (!error && result) {
									var color=result;
                                 if(color=='red')
                                 {
                       $A.util.addClass(component.find('diary'), 'red-color');         
                                 }
                                 if(color=='yellow')
                                 {
                           $A.util.addClass(component.find('diary'), 'yellow-color');            
                                 }
                                 if(color=='green')
                                 {
                          $A.util.addClass(component.find('diary'), 'green-color');           
                                 }
                               
                             }
                             else{
                                // this.displayToastMessage(component,event,'error','Error in Saving','error');
                             }
                                                         console.log('Diary color end ');
                                                         this.showhidespinner(component,event,false);
                         });   
    },
	//Added by Hrishekesh  to change diary color at home page ==>Bug id 19263 end-->
     executeApex: function(component, method, params,callback){
       
        var action = component.get("c."+method); 
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
          console.log('Print '+state+' '+action+' response'+response);
            if(state === "SUCCESS"){
                
                callback.call(this, null, response.getReturnValue());
            } else if(state === "ERROR") {
                var errors = ["Some error occured. Please try again. "];
                var array = response.getError();
                for(var i = 0; i < array.length; i++){
                    var item = array[i];
                    if(item && item.message){
                        errors.push(item.message);
                    }
                }
                callback.call(this, errors, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
      showhidespinner:function(component, event, showhide){
        console.log('in showhidespinner');
        var showhideevent =  $A.get("e.c:Show_Hide_Spinner");
        showhideevent.setParams({
            "isShow": showhide
        });
        showhideevent.fire();
    },

        // US 1649 added by Gaurav
    showPsfCheck : function (component,event){
      
        console.log ('control flow check');
    
      
       this.executeApex (component , 
                         'psfProfileCheck' ,
                          {"loggedInUserProfile":component.get ("v.profileName")},
                          function (error , result){
                              console.log ('profile check callback');
                              console.log (component.get ("v.profileName"));
                              console.log ('profile value='+JSON.stringify (component.get ("v.profileName")));
                              console.log ('error='+error);
                              console.log ('result='+result);
                              if (!error && result){
                                  if (result == true){
                                  component.set ("v.showPsf",true);
                                      console.log ('true psf check ');}
                                  else{
                                      console.log ('false check');
                                   	  component.set ("v.showPsf",false);   
                              			}
                              					}
                              else
                                 component.set ("v.showPsf",false); 
                              
                          }); 
        
        
    }
    
    
    // US 1649 end    
    
    
})