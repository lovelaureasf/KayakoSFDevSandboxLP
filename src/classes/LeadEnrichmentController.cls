public without sharing class LeadEnrichmentController extends LeadFlowButtonHandler
{
    public String industry { get; set; }
    public Lead activeLead { get; set; }

    public LeadEnrichmentController(ApexPages.StandardController controller)
    {
        super(controller);
        industry = lead.Industry;
        activeLead = lead;
    }

    public PageReference EnrichLead()
    {
        lead.NumberOfEmployees = activeLead.NumberOfEmployees;
        lead.Industry = industry;

        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public List <SelectOption> GetListOfIndustries()
    {
        return Util.GetPicklistValues(lead, 'Industry');
    }
}