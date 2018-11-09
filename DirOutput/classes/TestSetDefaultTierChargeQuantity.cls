@isTest
public class TestSetDefaultTierChargeQuantity {

    public static testMethod void positiveScenario(){
        
        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
        Opportunity o = new Opportunity();
        o.closedate = Date.today();
        o.StageName = 'Closed Wont';
        o.Amount = 100;
        o.name = 'test opp';
        insert o;
        
        
        
        zqu__Quote__c q = new zqu__Quote__c();
        q.name = 'test';
        q.zqu__Opportunity__c = o.id;
        q.SecurityToken__c = 'zzzz';
        q.InstanceID__c = 123;
        insert q;
        
        zqu__QuoteAmendment__c qa = new zqu__QuoteAmendment__c();
        qa.zqu__Quote__c = q.id;
        insert qa;
        
        
        zqu__QuoteRatePlan__c qrp = new zqu__QuoteRatePlan__c();
        qrp.name = 'test';
        qrp.zqu__Quote__c = q.id;
        qrp.zqu__QuoteAmendment__c = qa.id;
        insert qrp;
        
        zqu__QuoteRatePlanCharge__c qrpc = new zqu__QuoteRatePlanCharge__c();
        qrpc.name = 'Collaborators';
        qrpc.zqu__QuoteRatePlan__c = qrp.id;
        qrpc.zqu__Quantity__c = 15;
        qrpc.zqu__Model__c = 'Tiered Pricing';
        insert qrpc;
        
        zqu__QuoteCharge_Tier__c qct = new zqu__QuoteCharge_Tier__c();
        qct.name = 'test';
        qct.zqu__QuoteRatePlanCharge__c = qrpc.id;
        qct.zqu__StartingUnit__c = 11;
        qct.zqu__EndingUnit__c = 20;
        qct.zqu__PriceFormat__c = 'Flat Fee';
        insert qct;
    }
}