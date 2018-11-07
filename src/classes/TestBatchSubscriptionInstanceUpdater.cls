@isTest
public class TestBatchSubscriptionInstanceUpdater{
    
    static  testMethod  void positiveScenario(){
        
        Instance__c i = new Instance__c();
        i.Name = 'test.kayako.com';
        i.Expiry_Date__c = Date.today()+30;
        i.Instance_ID__c = 2234;
        i.Seats__c = 23;
        insert i;
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.InstanceId__c = '2234';
        insert zs;    
    
        Test.startTest();
        BatchSubscriptionInstanceUpdater b = new BatchSubscriptionInstanceUpdater();
        Database.executeBatch(b);
        Test.stopTest();
    }


}