global without sharing class UnresponsiveLeadCleanerJob implements Schedulable
{
	global void execute(SchedulableContext context)
    {
        List <Lead> unresponsiveLeads = LeadDataAccess.GetUnresponsiveLeadsSinceDate(Date.today().addMonths(-1));
        
        RejectLeads(unresponsiveLeads);
    }
    
    private void RejectLeads(List <Lead> unresponsiveLeads)
    {
        for(Lead lead : unresponsiveLeads)
        {
            lead.Status = LeadStatus.NURTURE;
            lead.Stage__c = LeadStage.SRL;
            lead.StageToSRLDate__c = Date.today();
            lead.StatusToNurtureDate__c = Date.today();
            lead.StatusLastUpdatedDate__c = Date.today();
        }
        
        update unresponsiveLeads;
    }
}