public with sharing class DEController {

public final account acc; 
 public string greetings{get;set;}
 /*public string getGreetings(){
 return 'hello';
 }*/
 
    public DEController(ApexPages.StandardController controller) {
             this.acc=(account)controller.getRecord();
    }


public PageReference dosomething()
{
greetings='hello' +acc.ID;
return null;
}
}