@isTest
public class QuoteCreationControllerTest{
    
public static testMethod void positiveScenario(){    
    
    
    Account acc = new Account();
    acc.Name = 'test';
    insert acc;
    
    Opportunity o = new Opportunity();
    o.name = 'test';
    o.stageName = 'Proposal and Quote';
    o.closeDate = Date.Today();
    o.accountId = acc.id;
    insert o;
    
    ApexPages.StandardController sc = new ApexPages.StandardController(o);
    QuoteCreationController qc = new QuoteCreationController(sc);
    
    qc.proceed();
}


public static testMethod void negativeScenario(){    
    
    
    Account acc = new Account();
    acc.Name = 'test';
    insert acc; 
    
    Instance__c i = new Instance__c();
    i.name = 'test.kayako.com';
    i.Expiry_Date__c = date.today()-30;
    i.UUID__c = '23434234523456456';
    insert i ;
    
    Opportunity o = new Opportunity();
    o.name = 'test';
    o.stageName = 'Proposal and Quote';
    o.closeDate = Date.Today();
    o.accountId = acc.id;
    o.Instance__c = i.id;
    insert o;
    
    zqu__Quote__c zq = new zqu__Quote__c();
    zq.zqu__Opportunity__c =o.id;
    zq.SecurityToken__c='sc';
    zq.InstanceId__c=123;
    insert zq;
    
    Zuora__CustomerAccount__c zca = new Zuora__CustomerAccount__c();
    zca.Zuora__Account__c = acc.id;
    insert zca;
    
    ApexPages.StandardController sc = new ApexPages.StandardController(o);
    QuoteCreationController qc = new QuoteCreationController(sc);
    
    qc.proceed();
}
    
    
public static testMethod void negativeScenario2(){    
    
    
    Account acc = new Account();
    acc.Name = 'test';
    insert acc;
    
    
    Instance__c i = new Instance__c();
    i.name = 'test.kayako.com';
    i.Expiry_Date__c = date.today();
    i.UUID__c = '23434234523456456';
    i.State__c = 'DELETED';
    insert i ;
    
    Opportunity o = new Opportunity();
    o.name = 'test';
    o.stageName = 'Proposal and Quote';
    o.closeDate = Date.Today();
    o.accountId = acc.id;
    o.Product__c = 'Kayako 4 Upgrade';
    insert o;
    
    zqu__Quote__c zq = new zqu__Quote__c();
    zq.zqu__Opportunity__c =o.id;
    zq.SecurityToken__c='sc';
    zq.InstanceId__c=123;
    insert zq;
    
    Zuora__CustomerAccount__c zca = new Zuora__CustomerAccount__c();
    zca.Zuora__Account__c = acc.id;
    insert zca;
    
    ApexPages.StandardController sc = new ApexPages.StandardController(o);
    QuoteCreationController qc = new QuoteCreationController(sc);
    
    qc.proceed();
}
    

}