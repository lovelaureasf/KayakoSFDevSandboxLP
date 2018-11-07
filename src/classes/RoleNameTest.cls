@isTest
public class RoleNameTest
{
    public static TestMethod void TestAllRoleNames()
    {
        Set <String> roles = RoleName.GetAll();

        System.assert(roles.contains(RoleName.ADM));
        System.assert(roles.contains(RoleName.ISM));
        System.assert(roles.contains(RoleName.RL));
        System.assert(roles.contains(RoleName.MNGR));
    }

    public static TestMethod void TestSeniorRoleNames()
    {
        Set <String> roles = RoleName.SeniorRoles();

        System.assert(roles.contains(RoleName.ISM));
        System.assert(roles.contains(RoleName.RL));
        System.assert(roles.contains(RoleName.MNGR));

        
    }
}