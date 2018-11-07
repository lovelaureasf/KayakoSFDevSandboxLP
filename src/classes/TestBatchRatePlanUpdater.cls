@isTest
public class TestBatchRatePlanUpdater{

public static testMethod void positiveScenario(){

        Account acc = new Account();
        
        acc.Name = 'test account';
        
        insert acc;  //step 1 insert account
        
        Zuora__Subscription__c s = new Zuora__Subscription__c();
        
        s.name = 'test';
        
        s.Zuora__Account__c = acc.id;
        
        s.Seats__c = 2;    
        
        insert s; //step 2 insert subscription
        
        Zuora__UnitOfMeasure__c uom = new Zuora__UnitOfMeasure__c();
        
        uom.Name = 'Agents';
        
        insert uom; // step 3 insert unit of measure.
        
        
        zqu__ZProduct__c p = new zqu__ZProduct__c();
        
        p.Name = 'testproduct';
        
        p.zqu__SKU__c = '1234';
        
        p.zqu__ZuoraId__c= 'test123';
        
        insert p; //step 4 insert product.
        
        
        zqu__ProductRatePlan__c prc = new zqu__ProductRatePlan__c();
        
        prc.Name = 'testcharge';
        
        prc.Type__c = 'Primary';
        
        prc.zqu__ZProduct__c = p.id;
        
        prc.zqu__ZuoraId__c = 'test123';
        
        insert prc; // step 5 insert product rate plan.
        

        Zuora__SubscriptionProductCharge__c zspc = new Zuora__SubscriptionProductCharge__c ();
        
        zspc.Zuora__UnitOfMeasure__c = uom.id;
        
        zspc.Zuora__Subscription__c = s.id;
        
        zspc.Name = 'testcharge';
        
        zspc.Zuora__Quantity__c = 4;
        
        insert zspc; // step 6 insert the subscription product and charges
        
       
        Test.startTest(); //get all the limits back
        
        BatchRatePlanUpdater b = new BatchRatePlanUpdater(); //call the batch
        
        Database.executeBatch(b);
        
        Test.stopTest(); //out of limit execution block
        
        


}


}