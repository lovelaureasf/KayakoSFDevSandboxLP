public without sharing class UserDataAccess 
{
    /**
     * @var usersCache Cache users by Id.
     */
    private static Map <Id, User> usersCache = new Map <Id, User> ();

    /**
     * Get a user by Id.
     * 
     * @param userId
     * @return User
     * @author Mohammad Gufran <mohammad.gufran@kayako.com>
     */    
    public static User GetUser(Id userId)
    {
        if(usersCache.containsKey(userId)) return usersCache.get(userId);
        
        try
        {
            User user = [SELECT Id, Name, KA_LeadCounter__c , KA_Weightage__c, IsActive, ManagerId, Profile.Name,userRoleId FROM User WHERE id = :userId LIMIT 1];
            
            usersCache.put(userId, user);
            
            return user;
        }
        catch(QueryException nullResultException) { throw new UnderflowException('No user exists with ID ' + userId); }
    }

    /**
     * Get current user.
     *
     * @return User
     * @author Mohammad Gufran <mohammad.gufran@kayako.com>
     */
    public static User GetCurrentUser()
    {
        return GetUser(UserInfo.getUserId());
    }

    /**
     * Get user by UserTerritoryAssociation pivot.
     * 
     * @param userTerritory
     * @return User
     * @author Mohammad Gufran <mohammad.gufran@kayako.com>
     */
    public static User GetUser(UserTerritory2Association userTerritory)
    {
        return GetUser(userTerritory.UserId);
    }

    public static boolean MatchesUserRole(User user, Set <String> roles, Territory2 territory)
    {
        try
        {
            UserTerritory2Association pivot = TerritoryDataAccess.GetTerritoryPivotForUser(user, territory);

            return roles.contains(pivot.RoleInTerritory2);
        }
        catch(UnderflowException userDoesNotHaveRole){ return false; }
    }

    public static boolean MatchesUserRole(User user, String role, Territory2 territory)
    {
        return MatchesUserRole(user, new Set <String> { role }, territory);
    }
}