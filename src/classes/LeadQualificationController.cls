public without sharing class LeadQualificationController extends LeadFlowButtonHandler
{
    public String budgeted { get; set; }
    public String role { get; set; }
    public String authority { get; set; }
    public String currentSystem { get; set; }
    public String intendedUse { get; set; }
    public String department { get; set; }
    public String notes { get; set; }
    public String industry { get; set; }
    public String opportunityType { get; set; }

    public LeadQualificationController(ApexPages.StandardController controller) 
    {
        super(controller);
        budgeted = lead.Budgeted__c;
        role = lead.Role__c;
        authority = lead.Authority__c;
        currentSystem = lead.CurrentSystem__c;
        intendedUse = lead.UsedFor__c;
        department = lead.Department__c;
        opportunityType = lead.OpportunityType__c;
        industry = lead.industry;
        notes = '';
    }

    public PageReference QualifyLead()
    {
        lead.Budgeted__c = budgeted;
        lead.Role__c = role;
        lead.Authority__c = authority;
        lead.CurrentSystem__c = currentSystem;
        lead.UsedFor__c = intendedUse;
        lead.Department__c = department;
        lead.StatusToQualifiedDate__c = Date.today();
        lead.StageToSQLDate__c = Date.today();
        lead.Industry = industry;
        lead.OpportunityType__c = opportunityType;

        update lead;

        if(String.isNotEmpty(notes))
        {
            Note newNote = new Note();
            newNote.Body = notes;
            newNote.Title = 'Notes by ' + UserDataAccess.GetCurrentUser().Name + ' on ' + Date.today().format();
            newNote.ParentId = lead.Id;
            newNote.OwnerId = UserDataAccess.GetCurrentUser().Id;

            insert newNote;
        }

        return Util.RedirectTo(GetLeadId());
    }

    public List <SelectOption> GetBudgetedOptions()
    {
        return Util.GetPicklistValues(lead, 'Budgeted__c');
    }

    public List <SelectOption> GetRoleOptions()
    {
        return Util.GetPicklistValues(lead, 'Role__c');
    }

    public List <SelectOption> GetAuthorityOptions()
    {
        return Util.GetPicklistValues(lead, 'Authority__c');
    }

    public List <SelectOption> GetCurrentSystemOptions()
    {
        return Util.GetPicklistValues(lead, 'CurrentSystem__c');
    }

    public List <SelectOption> GetIntendedUseOptions()
    {
        return Util.GetPicklistValues(lead, 'UsedFor__c');
    }

    public List <SelectOption> GetDepartmentOptions()
    {
        return Util.GetPicklistValues(lead, 'Department__c');
    }
    
    public List <SelectOption> GetIndustryOptions()
    {
        return Util.GetPicklistValues(lead, 'Industry');
    }
    
    public List <SelectOption> GetOpportunityTypeOptions()
    {
        return Util.GetPicklistValues(new Opportunity(), 'Type');
    }
}