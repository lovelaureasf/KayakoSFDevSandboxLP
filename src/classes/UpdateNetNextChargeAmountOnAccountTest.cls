@isTest
public class UpdateNetNextChargeAmountOnAccountTest {

    public static testMethod void positiveScenario(){
       
       
        account acc = new account();
        acc.Name='test';
        insert acc;
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.Zuora__Account__c = acc.id;
        zs.Zuora__Status__c='Active';
        insert zs;
        
        Zuora__SubscriptionProductCharge__c zsp = new Zuora__SubscriptionProductCharge__c();
        zsp.Zuora__Subscription__c = zs.id;
        zsp.Name='positive test';
        zsp.Zuora__Price__c=4;
        zsp.Zuora__ExtendedAmount__c=3;
        zsp.Zuora__Type__c='Recurring';
        zsp.Zuora__Account__c = acc.id;
        insert zsp;
        
        
        
        Zuora__SubscriptionProductCharge__c zsp2 = new Zuora__SubscriptionProductCharge__c();
        zsp2.Zuora__Subscription__c = zs.id;
        zsp2.Name='test Discount';
        zsp2.Zuora__Price__c=2;
        zsp2.Zuora__Type__c='Recurring';
        zsp2.Zuora__ExtendedAmount__c=4;
        zsp2.Zuora__Account__c = acc.id;
        insert zsp2;
        
        BatchNetNextChargeAmountOnAccountUpdater b = new BatchNetNextChargeAmountOnAccountUpdater();
        
        Test.startTest();
        Database.executeBatch(b);
        Test.stopTest();
    }
}