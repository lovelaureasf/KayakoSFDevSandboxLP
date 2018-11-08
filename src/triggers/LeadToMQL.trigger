/*
Description: This trigger updates the Stage In MQL date on lead whenever the lead is created.
*/
trigger LeadToMQL on Lead (before insert) {
    for(lead l: Trigger.New){
        try{
            if(l.Stage__c=='MQL' && l.Status=='Open'){
                l.StageToMQLDate__c = Date.Today();
            }
        }catch(Exception e){
            
        }
    }
}