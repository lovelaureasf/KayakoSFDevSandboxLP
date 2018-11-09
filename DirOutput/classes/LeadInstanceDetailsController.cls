public without sharing class LeadInstanceDetailsController extends LeadFlowButtonHandler
{
    public Date expiryDate { get; set; }

    public LeadInstanceDetailsController(ApexPages.StandardController controller)
    {
        super(controller);
        DateTime previousDate = lead.KA_TrialExpiryDate__c;

        if(previousDate == null) previousDate = DateTime.now();

        expiryDate = previousDate.date();
    }

    public PageReference UpdateInstance()
    {
        lead.KA_TrialExpiryDate__c = expiryDate;
        update lead;

        return Util.RedirectTo(GetLeadId());
    }
}