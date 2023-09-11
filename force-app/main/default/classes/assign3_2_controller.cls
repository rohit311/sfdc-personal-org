public class assign3_2_controller{

public string l{get;set;}
public string a{get;set;}
public List<SelectOption> animals{get;set;}
 public list<SelectOption> options {get; set;}
  {
  options = new List<SelectOption>();
  options.add(new SelectOption('A','A'));
   options.add(new SelectOption('B','B'));
    options.add(new SelectOption('C','C'));
    options.add(new SelectOption('D','D'));
    options.add(new SelectOption('E','E'));
         }


public pageReference disp()
{

animals=new List<SelectOption>();
    if(l=='A')
    {
                animals.add(new SelectOption('Apple','Apple'));
        animals.add(new SelectOption('Apricot','Apricot'));
                
    }
    else if(l=='B')
    {
         animals.add(new SelectOption('Bannana','Bannana'));
        animals.add(new SelectOption('B2','B2'));
    
    }
    else if(l=='C')
    { 
          animals=new List<SelectOption>();
        animals.add(new SelectOption('Carrot','Carrot'));
        animals.add(new SelectOption('Cabbage','Cabbage'));
        animals.add(new SelectOption('Cucumber','Cucumber'));
    }
    else if(l=='D')
    {
     animals=new List<SelectOption>();
        animals.add(new SelectOption('D1','D1'));
        animals.add(new SelectOption('D2','D2'));
        animals.add(new SelectOption('D3','D3'));
        
    }
    else
    {
        animals=new List<SelectOption>();
        animals.add(new SelectOption('E1','E1'));
        animals.add(new SelectOption('E2','E2'));
        animals.add(new SelectOption('E3','E3'));

    }
    
    return null;

}

}