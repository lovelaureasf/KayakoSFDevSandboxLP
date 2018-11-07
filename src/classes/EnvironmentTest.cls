@IsTest
public class EnvironmentTest 
{
    public static TestMethod void checkForSandbox()
    {
        boolean isSandbox = [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;

        System.assertEquals(isSandbox, Environment.IsSandbox());
    }

    public static TestMethod void checkForProduction()
    {
        boolean isNotSandbox = [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;

        System.assertEquals(!isNotSandbox, Environment.IsProduction());
    }

    public static TestMethod void checkForTest()
    {
        System.assert(Environment.IsTest());
    }
}