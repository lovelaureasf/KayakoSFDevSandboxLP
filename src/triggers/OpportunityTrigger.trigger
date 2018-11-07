//******************************************************************
// Name: OpportunityTrigger 
// Purpose: This Opportunity trigger is being created to execute after updtae
// Author: Gaurav Agarwal
// Date: 24/08/2018 
//******************************************************************
trigger OpportunityTrigger on Opportunity (after update, before update) {

    if(trigger.isAfter && trigger.IsUpdate)
    {
        OpportunityTriggerHandler.handleAfterUpdate(trigger.new, trigger.oldmap);
    }
    
    if(trigger.isbefore && trigger.IsUpdate)
    {
        OpportunityTriggerHandler.handlebeforeUpdate(trigger.new, trigger.oldmap);
    }
}