/*
Description: This trigger updates the TCV and Revenue field to null whenver an opportunity is marked as closed lost. 
*/

trigger OnOpportunityClosedLost on Opportunity (before update) {
    for(Opportunity o: Trigger.New){
        if(o.StageName.contains('Closed Lost') && !Trigger.OldMap.get(o.id).StageName.contains('Closed Lost')){
            o.TCV__c = null;
            o.Revenue__c = null;
        }
    }
}