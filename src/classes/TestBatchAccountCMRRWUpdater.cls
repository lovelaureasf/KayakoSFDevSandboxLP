@isTest
public class TestBatchAccountCMRRWUpdater{
    public static testMethod void positiveScenario(){
        Account acc = new Account();
        
        acc.Name = 'test account';
        
        acc.Status__c = 'Active';
        
        insert acc;  //step 1 insert account
        
        Zuora__Subscription__c s = new Zuora__Subscription__c();
        
        s.name = 'test';
        
        s.CMRRWithDiscount__c=22;
        
        s.Zuora__Status__c='Active';
        
        s.Zuora__Account__c = acc.id;
        
        s.Seats__c = 2;    
        
        insert s; //step 2 insert subscription
        
        //Test.startTest(); //get all the limits back
        
        BatchAccountCMRRWUpdater b = new BatchAccountCMRRWUpdater(); //call the batch
        
        Database.executeBatch(b);
        
        //Test.stopTest(); //out of limit execution block
    }
    
    
    public static testMethod void negativeScenario(){
        Account acc = new Account();
        
        acc.Name = 'test account2';
        
        acc.Status__c = 'Cancelled';
        
        insert acc;  //step 1 insert account
        
        
        
        Zuora__Subscription__c s = new Zuora__Subscription__c();
        
        s.name = 'test2';
        
        s.CMRRWithDiscount__c=22;
        
        s.Zuora__Status__c='Cancelled';
        
        s.Zuora__Account__c = acc.id;
        
        s.Seats__c = 2;    
        
        insert s; //step 2 insert subscription
        
        Test.startTest(); //get all the limits back
        
        BatchAccountCMRRWUpdater b = new BatchAccountCMRRWUpdater(); //call the batch
        
        Database.executeBatch(b);
        
        Test.stopTest(); //out of limit execution block
    } 

}