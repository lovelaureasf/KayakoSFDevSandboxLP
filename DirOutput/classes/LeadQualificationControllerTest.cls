@isTest
public class LeadQualificationControllerTest
{
    public static TestMethod void VerifyLeadQualification()
    {   
        SObject lead = ObjectMocker.mock('Lead');
        lead.put('Email', 'mail@example.com');
        lead.put('CountryCode', 'IN');
        lead.put('KA_Product__c','test');
        lead.put('KA_ProductType__c','test');
        insert lead;

        ApexPages.currentPage().getParameters().put('id', lead.Id);

        ApexPages.StandardController controller = new ApexPages.StandardController(lead);
        LeadQualificationController handler = new LeadQualificationController(controller);

        handler.budgeted = handler.GetBudgetedOptions().get(0).getValue();
        handler.role = handler.GetRoleOptions().get(0).getValue();
        handler.authority = handler.GetAuthorityOptions().get(0).getValue();
        handler.currentSystem = handler.GetCurrentSystemOptions().get(0).getValue();
        handler.intendedUse = handler.GetIntendedUseOptions().get(0).getValue();
        handler.department = handler.GetDepartmentOptions().get(0).getValue();
        handler.industry = handler.GetIndustryOptions().get(0).getValue();
        handler.notes = 'Here is a note, Yo!';

        PageReference response = handler.QualifyLead();

        System.assert(response.getRedirect());
    }   
}