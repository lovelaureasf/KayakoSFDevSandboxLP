@isTest
public class UpdateLifetimeBilledAmountOnAccountTest {
    public static testMethod void positiveScenario(){
        
        List<Zuora__Payment__c> zList = new List<Zuora__Payment__c >();
       
        
        
        account acc = new account();
        acc.Name='test';
        insert acc;
        
        Zuora__CustomerAccount__c zca = new Zuora__CustomerAccount__c();
        zca.name='test';
        zca.Zuora__Account__c = acc.id;
        insert zca;
        
        
        Zuora__Payment__c zi = new Zuora__Payment__c();
        zi.Zuora__Account__c = acc.Id;
        zi.Zuora__Amount__c =1;
        zi.Zuora__Status__c='Processed';
        zi.Zuora__BillingAccount__c =zca.id;
        insert zi;
        
         zlist.add(zi);
        
        Zuora__Payment__c zi2 = new Zuora__Payment__c();
        zi2.Zuora__Account__c = acc.Id;
        zi2.Zuora__Amount__c =2;
        zi2.Zuora__Status__c='Processed';
        zi2.Zuora__BillingAccount__c = zca.id;
        insert zi2;
        
         zlist.add(zi2);
        
        BatchLifetimeBilledAmountUpdater b = new BatchLifetimeBilledAmountUpdater();
        
        Test.startTest();
        Database.executeBatch(b);
        Test.stopTest();
    }
}