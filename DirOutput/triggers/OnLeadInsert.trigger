trigger OnLeadInsert on Lead (after insert)
{
    try{LeadOwnerAssigner.assignLeadOwner(trigger.new);}catch(UnderflowException leadOwnerNotAssigned){}
}