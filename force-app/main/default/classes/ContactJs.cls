global with sharing class ContactJs {  
    /**
    * Webkul Software.
    *
    * @category  Webkul
    * @author    Webkul
    * @copyright Copyright (c) 2010-2016 Webkul Software Private Limited (https://webkul.com)
    * @license   https://store.webkul.com/license.html
    */
    public ContactJs() { } // empty constructor    

    @RemoteAction //the function to be called in remote action should use this annotation
    global static list<Contact> getcon() {
        //function should be static and global else it will throw error
        list<Contact> con1 = [SELECT id,name FROM contact limit 5];
        if(con1!=null && !con1.isEmpty()){        
            return con1;        
        }else{        
            return  new list<contact>();        
        }
    }
    
    @RemoteAction 
    global static String fetchName(){
        return '';
    }
}