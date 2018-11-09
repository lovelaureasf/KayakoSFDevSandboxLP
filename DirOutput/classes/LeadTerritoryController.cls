public without sharing class LeadTerritoryController extends LeadFlowButtonHandler
{
    public String selectedCountry { set; get; }

    public LeadTerritoryController(ApexPages.StandardController controller)
    {
        super(controller);
    }

    public List <SelectOption> GetListOfCountriesForUser()
    {
        Set <Territory2> countries = null;
        List <SelectOption> options = new List <SelectOption> ();
        String role = TerritoryDataAccess.GetUserRole(UserDataAccess.GetCurrentUser(), TerritoryDataAccess.GetLeadRegion(lead));

        if(RoleName.SeniorRoles().contains(role))
        {
            countries = new Set <Territory2> (TerritoryDataAccess.GetAllCountries());
        }
        else
        {
            List <Territory2> userRegion = TerritoryDataAccess.GetUsersRegion(user.Id);
            countries = TerritoryDataAccess.GetCountriesInRegion(userRegion);
        }

        for(Territory2 country : countries)
        {
            options.add(new SelectOption(country.Id, country.Name));
        }

        return options;
    }

    public PageReference SetTerritory()
    {
    	if(String.IsBlank(selectedCountry))
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Country cannot be blank. Make sure the lead is in your region and you have proper role permissions to set country.'));

            return ApexPages.currentPage();
    	}
    	
        Territory2 country = TerritoryDataAccess.GetCountryById(selectedCountry);

        User currentUser = UserDataAccess.GetCurrentUser();

        lead.KA_Territory__c = country.ParentTerritory2.Name;
        lead.Country = country.Name;
        update lead;

        Set <Territory2> userRegions = new Set <Territory2> (TerritoryDataAccess.GetUsersRegion(currentUser.Id));

        if( ! userRegions.contains(TerritoryDataAccess.GetLeadRegion(lead)))
        {
            LeadOwnerAssigner.AssignLeadOwner(new List <Lead> { lead });
        }

        return Util.RedirectTo(GetLeadId());
    }
}