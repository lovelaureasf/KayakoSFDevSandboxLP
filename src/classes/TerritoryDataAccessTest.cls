@isTest
public class TerritoryDataAccessTest 
{
    @isTest(SeeAllData = true)
    public static void testGetLeadRegion()
    {
        Lead lead = new Lead (email = 'mail@mail.com', CountryCode = 'IN', lastName = 'last name', company = 'kayako',KA_Product__c='test',KA_ProductType__c='test');

        insert lead;
        
        Territory2 found = TerritoryDataAccess.GetLeadRegion(lead);
        System.assert(found.DeveloperName == 'APAC');
    }
    
    @isTest(SeeAllData = true)
    public static void testGetUsersRegion()
    {
        User user = [select id from user limit 1];

        List <Territory2> region = TerritoryDataAccess.GetUsersRegion(user.Id);
    }
    
    @isTest(SeeAllData = true)
    public static void testGetUserTerritoryPivots()
    {
        Territory2 territory = [select id from Territory2 limit 1];
        Profile prof = [Select id from profile where name = 'Account Executive' limit 1];
        List <UserTerritory2Association> region = TerritoryDataAccess.GetUserTerritoryPivots(territory, prof.Id);
    }

    @isTest(SeeAllData = true)
    public static void testGetTerritoryPivotForUser()
    {
        UserTerritory2Association association = [SELECT Id, User.Id, territory2.Id, RoleInTerritory2 
                                                    FROM UserTerritory2Association LIMIT 1];

        User user = [SELECT Id FROM User WHERE Id = :association.User.Id LIMIT 1];
        user.KA_Weightage__c = 10;
        update user;
        
        Territory2 territory = [SELECT Id, Name FROM Territory2 WHERE Id = :association.Territory2.Id LIMIT 1];

        UserTerritory2Association pivot = TerritoryDataAccess.GetTerritoryPivotForUser(user, territory);
        UserTerritory2Association userWithTerritory = TerritoryDataAccess.GetUserWithTerritory(user.Id, territory.Id);

        String role = TerritoryDataAccess.GetUserRole(user, territory);

        System.assert(pivot.RoleInTerritory2 == association.RoleInTerritory2);
        System.assert(association.RoleInTerritory2 == role);
    }
    
    public static TestMethod void GetAllCountries()
    {
        List <Territory2> allCountries = TerritoryDataAccess.GetAllCountries();

        System.assert(allCountries.size() > 0);
    }

    public static TestMethod void GetCountriesById()
    {
        Territory2Type typeCountry = [SELECT Id From Territory2Type WHERE DeveloperName = 'Sales_Regions' LIMIT 1];
        Territory2 someCountry = [SELECT Id FROM Territory2 WHERE Territory2Type.Id = :typeCountry.Id LIMIT 1];

        Territory2 foundCountry = TerritoryDataAccess.GetCountryById(someCountry.Id);

        System.assert(someCountry.Id == foundCountry.Id);
    }

    public static TestMethod void GetCountriesInRegion()
    {
        Territory2Type regionType = [SELECT Id FROM Territory2Type WHERE DeveloperName = 'Sales_Regions' LIMIT 1];
        List <Territory2> regions = [SELECT Id FROM Territory2 WHERE Territory2TypeId = :regionType.Id LIMIT 2];

        Set <Territory2> allCountriesByMultipleRegions = TerritoryDataAccess.GetCountriesInRegion(regions);
        Set <Territory2> allCountriesByRegion = TerritoryDataAccess.GetCountriesInRegion(regions.get(0));

        System.assert(allCountriesByRegion.size() > 0);
        System.assert(allCountriesByMultipleRegions.size() > 0);
    }
}