@isTest(SeeAllData = true)
public class LeadTerritoryControllerTest
{
    public static TestMethod void GetListOfCountriesForUser()
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());
        
        UserTerritory2Association association = [select user.id, territory2.Id from UserTerritory2Association where territory2.id='0MI100000008OPM' limit 1];
        association.RoleInTerritory2 = RoleName.ISM;
        update association;
        
        Territory2 region = [select id from territory2 where(Id = :association.territory2.Id) limit 1];
        Territory2 country = [select developername from territory2 where parentterritory2.id = :region.Id limit 1];
        User tester = [select id, email, username from User where Id = :association.user.Id limit 1];
        
        System.runAs(tester) {
    
            Lead lead = new Lead(
                email = 'newlead@mail.com', 
                CountryCode = 'US', 
                lastName = 'last name', 
                firstName = 'first name', 
                company = 'test company'
            );
            
            lead.put('Email', 'kayako.testing@kayako.com');
            lead.put('CountryCode', country.developername);
            lead.put('KA_Product__c','test');
            lead.put('KA_ProductType__c','test');
            insert lead;
    
            ApexPages.currentPage().getParameters().put('id', lead.Id);
    
            ApexPages.StandardController controller = new ApexPages.StandardController(lead);
            LeadTerritoryController handler = new LeadTerritoryController(controller);
    
            //List <SelectOption> countries = handler.GetListOfCountriesForUser();
    
            //System.assert(countries.size() > 0);
    
            //handler.selectedCountry = countries.get(0).getValue();
    
            //PageReference response = handler.SetTerritory();
    
            //System.assert(response.getRedirect());          
        }

    }   
}