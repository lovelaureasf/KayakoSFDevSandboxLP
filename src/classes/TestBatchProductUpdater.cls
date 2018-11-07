// This is test class for BatchProductUpdater class.
// We create mock zproducts in this class.
@isTest(SeeAllData=true)
public class TestBatchProductUpdater {

    public static testMethod void positiveScenario(){
        
        zqu__ZProduct__c zp = new zqu__ZProduct__c();
        zp.name = 'test';
        zp.Family__c = 'testfamily';
        zp.Type__c = 'testtype';
        zp.zqu__SKU__c = 'sku001';
    	insert zp;
    
    
       Test.startTest();
       BatchProductUpdater bpu= new BatchProductUpdater();
       Database.executeBatch(bpu);
       Test.stopTest();
    
    }    
    
    
}