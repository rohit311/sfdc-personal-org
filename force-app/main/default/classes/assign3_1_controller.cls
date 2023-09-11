public class assign3_1_controller{

 public String s{get;set;}
public String s1{get;set;}
public String s2{get;set;}
 public list<SelectOption> options {get; set;}
  {
  options = new List<SelectOption>();
  options.add(new SelectOption('India','India'));
   options.add(new SelectOption('USA','USA'));
    options.add(new SelectOption('Canada','Canada'));
         }

public List<SelectOption> glist{get;set;}
{
   glist=new List<SelectOption>();
glist.add(new SelectOption('Male','Male'));
glist.add(new SelectOption('Female','Female'));
}

public List<SelectOption> hlist{get;set;}
{
   hlist=new List<SelectOption>();
hlist.add(new SelectOption('Reading','Reading'));
hlist.add(new SelectOption('Dancing','Dancing'));
hlist.add(new SelectOption('Cycling','Cycling'));
}


public PageReference go()
{
s='USA';
s1='Male';
s2='Dancing';
return null;

}

     
      }