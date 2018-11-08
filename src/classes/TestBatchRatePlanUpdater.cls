//******************************************************************
// Name: TestBatchRatePlanUpdater
// Purpose: Test Class for batch BatchRatePlanUpdater which updates seats into subscription record
// Author: sruti Srivastava
// Date: 8/11/2018 
//******************************************************************
@isTest
Private class TestBatchRatePlanUpdater{

	static testMethod void test_BatchRatePlanUpdater(){

        Account acc = new Account(Name = 'test account');
        insert acc;  //step 1 insert account

        Zuora__Subscription__c s = new Zuora__Subscription__c(name = 'test', Zuora__Account__c = acc.id, Seats__c = 2);
		insert s; //step 2 insert subscription
        
        Zuora__UnitOfMeasure__c uom = new Zuora__UnitOfMeasure__c(Name = 'Agents');
		insert uom; // step 3 insert unit of measure.
        
        zqu__ZProduct__c p = new zqu__ZProduct__c(Family__c = 'novo', Name = 'Kayako 3 -> 4 OnDemand', zqu__SKU__c = '1234',zqu__EffectiveEndDate__c = Date.today().addDays(700), zqu__EffectiveStartDate__c = Date.today().addDays(-700) );
        insert p; //step 4 insert product. 
        
        Zuora__Product__c p1 = new Zuora__Product__c(Name = 'Kayako 3 -> 4 OnDemand', Zuora__SKU__c = '1234', Zuora__EntityID__c= 'test123', Zuora__EffectiveEndDate__c = date.today().addDays(90));
        insert p1; //step 4 insert product. 
        
        zqu__ProductRatePlan__c prc = new zqu__ProductRatePlan__c(Name = 'Case (Kayako 3 Upgrade)', Type__c = 'Primary', zqu__ZProduct__c = p.id, zqu__ZuoraId__c = 'test123');
        insert prc; // step 5 insert product rate plan.

        List<Zuora__SubscriptionProductCharge__c> listzspc = new List<Zuora__SubscriptionProductCharge__c> ();
		
        listzspc.add(new Zuora__SubscriptionProductCharge__c(Zuora__UnitOfMeasure__c = uom.id, Zuora__Subscription__c = s.id, Name = 'testcharge', Zuora__BillingPeriod__c= 'Month',Zuora__Quantity__c = 4, Zuora__Product__c = p1.id, Zuora__RatePlanName__c ='Fusion OnDemand (Kayako 3 Upgrade)'));
       	
		listzspc.add(new Zuora__SubscriptionProductCharge__c(Zuora__UnitOfMeasure__c = uom.id, Zuora__Subscription__c = s.id, Name = 'testcharge', Zuora__BillingPeriod__c= 'Annual',Zuora__Quantity__c = 4, Zuora__Product__c = p1.id, Zuora__RatePlanName__c ='Case test OnDemand (Kayako 3 Upgrade)'));
    	
       	listzspc.add(new Zuora__SubscriptionProductCharge__c(Zuora__UnitOfMeasure__c = uom.id, Zuora__Subscription__c = s.id, Name = 'testcharge',
        Zuora__Quantity__c = 4, Zuora__Product__c = p1.id, Zuora__RatePlanName__c ='Case OnDemand (Kayako 3 Upgrade)'));

    	insert listzspc; // step 6 insert the subscription product and charges
        
       
        Test.startTest(); //get all the limits back
        
        BatchRatePlanUpdater batchRP = new BatchRatePlanUpdater(); //call the batch
        
        Database.executeBatch(batchRP);
        
        Test.stopTest(); //out of limit execution block
		
		system.assertEquals([select Seats__c from Zuora__Subscription__c limit 1].Seats__c, 4);//Verifying the result
	}
}