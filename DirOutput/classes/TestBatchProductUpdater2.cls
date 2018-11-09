// This is test class for BatchProductUpdater class.
// We create mock zproducts in this class.
@isTest(SeeAllData=true)
public class TestBatchProductUpdater2 {

    public static testMethod void positiveScenario(){
        
        Zuora__Product__c zp = new Zuora__Product__c();
        zp.name = 'test';
        zp.Family__c = 'testfamily';
        zp.Type__c = 'testtype';
        zp.Zuora__SKU__c = 'sku001';
    	insert zp;
    
    
       Test.startTest();
       BatchProductUpdater2 bpu= new BatchProductUpdater2();
       Database.executeBatch(bpu);
       Test.stopTest();
    
    }    
    
    
}