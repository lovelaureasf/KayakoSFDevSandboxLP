@isTest
public class TestBatchAccountSizeUpdater {
    public static testMethod void positiveScenario(){
        
        Account acc = new Account();
        
        acc.Name = 'test account';
        
        insert acc;  //step 1 insert account
        
        Zuora__Subscription__c s = new Zuora__Subscription__c();
        
        s.name = 'test';
        
        s.Zuora__Account__c = acc.id;
        
        s.Seats__c = 2;    
        
        insert s; //step 2 insert subscription
        
        Test.startTest(); //get all the limits back
        
        BatchAccountSizeUpdater b = new BatchAccountSizeUpdater(); //call the batch
        
        Database.executeBatch(b);
        
        Test.stopTest(); //out of limit execution block
    } 
}