//******************************************************************
// Name: Lead Trigger
// Purpose: This Lead trigger is being created to execute after updtae
// Author: Gaurav Agarwal
// Date: 24/08/2018 
//******************************************************************
trigger LeadTrigger on Lead (before insert, after insert, after update, before update) {

    if(trigger.isAfter && trigger.IsUpdate)
    {
        LeadTriggerHandler.handleAfterUpdate(trigger.new, trigger.oldmap);
    }
    
    if(trigger.isBefore && trigger.IsInsert)
    {
        LeadTriggerHandler.handleBeforeInsert(trigger.new, trigger.oldmap);
    }
    
    if(trigger.isAfter && trigger.IsInsert)
    {
        LeadTriggerHandler.handleAfterInsert(trigger.new, trigger.oldmap);
    }
    
        if(trigger.isBefore && trigger.IsUpdate)
    {
        LeadTriggerHandler.handleBeforeUpdate(trigger.new, trigger.oldmap);
    }   
    
}