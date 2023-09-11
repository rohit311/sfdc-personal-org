trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {

    List<Task> tlist=new List<Task>();
    for(Opportunity opp:[SELECT ID,Name FROM Opportunity WHERE StageName='Closed Won'])
    {
        Task t=new Task(Subject='Follow Up Test Task',WhatID=opp.Id);
        tlist.add(t);
    }
    insert tlist;
}