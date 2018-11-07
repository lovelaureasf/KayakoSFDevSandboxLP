@isTest
public class UserDataAccessTest 
{
	@isTest(SeeAllData = true)
    public static void testGetUserById()
    {
        User user = [select id from user limit 1];
        
        User found = UserDataAccess.GetUser(user.Id);
        System.assertEquals(user.Id, found.Id);
    }

	@isTest(SeeAllData = true)
    public static void testGetUserByTerritoryAssociation()
    {
        UserTerritory2Association association = [select UserId from UserTerritory2Association limit 1];

	    User found = UserDataAccess.GetUser(association);
    }
    
    public static TestMethod void testCurrentUser()
    {
    	User currentUser = UserDataAccess.GetCurrentUser();
    	
    	System.assert(currentUser.Id == UserInfo.getUserId());
    }
    
    @isTest(SeeAllData = true)
    public static void matchesUserRole()
    {
    	UserTerritory2Association association = [select id, user.id, territory2.id, RoleInTerritory2 from UserTerritory2Association limit 1];
    	
    	System.assert(UserDataAccess.MatchesUserRole(association.user, new Set <String> { association.RoleInTerritory2 }, association.territory2));
    	System.assert(UserDataAccess.MatchesUserRole(association.user, association.RoleInTerritory2, association.territory2));
    }
}