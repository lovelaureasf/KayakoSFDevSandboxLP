@isTest
public class TestBatchAccountSubscriptionAttacher {
    public static testMethod void positiveScenario(){
        
        Account acc = new Account();
        acc.Name = 'test account 1';
        insert acc;              // inserting test account1
        
                  
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.Zuora__Status__c = 'Active';
        zs.Zuora__Account__c = acc.Id;
        zs.InstanceID__c = '456';
        insert zs; // inserting active subscription for the test account 1
        
        
        
        Test.startTest(); //get all the limits back
        
        BatchAccountSubscriptionAttacher b = new BatchAccountSubscriptionAttacher(); //call the batch
        
        Database.executeBatch(b);
        
        Test.stopTest(); //out of limit execution block
    } 
    
     
        
        
    
}