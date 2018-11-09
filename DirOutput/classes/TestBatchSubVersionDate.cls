@isTest
public class TestBatchSubVersionDate {
    public static testMethod void positiveScenario(){
        
        
       
        Test.startTest(); //get all the limits back
        
        BatchSubscriptionVersionDateUpdater b = new BatchSubscriptionVersionDateUpdater(); //call the batch
        
        Database.executeBatch(b,1);
        
        Test.stopTest(); //out of limit execution block
        
        
        
        
        
        
        
    }
}