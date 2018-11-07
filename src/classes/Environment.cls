public without sharing class Environment {

    public static boolean IsSandbox()
    {
        return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }

    public static boolean IsProduction()
    {
        return ! IsSandbox();
    }

    public static boolean IsTest()
    {
        return Test.isRunningTest();
    }
}