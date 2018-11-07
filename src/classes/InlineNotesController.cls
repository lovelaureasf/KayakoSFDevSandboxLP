public without sharing class InlineNotesController
{
    public List <Note> notes { get; private set; }
    
	public InlineNotesController(ApexPages.StandardController controller)
    {
        Id leadId = System.currentPageReference().getParameters().get('id');

        notes = LeadDataAccess.GetNotesOnLead(leadId);
    }
}