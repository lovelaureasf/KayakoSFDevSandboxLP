trigger LeadAssignment on Lead (after insert, after update) {

        if(trigger.isAfter && trigger.IsInsert)
        {
            LeadTriggerHandler.leadAssignment(trigger.new,'Insert');
        }
        
        if(trigger.isAfter && trigger.Isupdate)
        {
            LeadTriggerHandler.handleAfterUpdate(trigger.new, trigger.oldmap);
        }
    
}