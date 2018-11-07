@isTest
public class TestBatchCustomerAccCreationDateUpdater{
    
    public static testMethod void positiveScenario(){
        
       
        
        Account acc = new Account();
        
        acc.Name = 'test account';
        
        acc.Status__c = 'Active';
        
        insert acc;  //step 1 insert account
        
        Zuora__CustomerAccount__c zca = new Zuora__CustomerAccount__c();
        
        zca.name = 'test billing account';
        
        zca.Zuora__Zuora_Id__c= '2cbejfhdjkddghe';
        
        zca.Zuora__Account__c = acc.id;
        
        insert zca;
        
        //Test.startTest(); //get all the limits back
        
        
        
        BatchCustomerAccountCreationDateUpdater b = new BatchCustomerAccountCreationDateUpdater(); //call the batch
        
        Database.executeBatch(b,1);
        
        //Test.stopTest(); //out of limit execution block
    }
    
}