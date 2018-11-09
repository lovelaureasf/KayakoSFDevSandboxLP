@isTest
public class ValidateVATValidationTest {
    public static testMethod void validateVATTest1(){
        
        account acc = new account();
        acc.name = 'test';
        insert acc;
        
        Instance__c i = new Instance__c();
        i.Name='test.kayako.com';
        i.Expiry_Date__c = date.today();
        i.Instance_ID__c = 1234567;
        i.UUID__c = 'uuid1236513789567238';
        insert i; 
        
        
        opportunity o = new opportunity();
        o.name = 'test';
        o.AccountId = acc.id;
        o.CloseDate =date.today()+30;
        o.StageName = 'Review & Negotiation';
        o.Instance__c = i.Id;
        
        insert o;
        
        
        zqu__quote__c q = new zqu__quote__c();
        q.zqu__VAT_ID__c = 'NL121345';
        q.Name = 'test';
        q.zqu__Opportunity__c = o.id; 
        q.SecurityToken__c = '67123895fgahjsfk';
        q.InstanceID__c = 37893;
        
        insert q;
        
        Test.setCurrentPage(Page.validatevat);
        ValidateVATValidation vatvalidation = new ValidateVATValidation(new ApexPages.StandardController(q));
       
        vatvalidation.validate();
        
		

        
        
    }
    
    public static testMethod void validateVATTest2(){
        
        account acc = new account();
        acc.name = 'test';
        insert acc;
        
        Instance__c i = new Instance__c();
        i.Name='test.kayako.com';
        i.Expiry_Date__c = date.today();
        i.Instance_ID__c = 1234567;
        i.UUID__c = 'uuid1236513789567238';
        insert i; 
        
        
        opportunity o = new opportunity();
        o.name = 'test';
        o.AccountId = acc.id;
        o.CloseDate =date.today()+30;
        o.StageName = 'Review & Negotiation';
        o.Instance__c = i.Id;
        
        insert o;
        
        
        zqu__quote__c q = new zqu__quote__c();
        q.zqu__VAT_ID__c = '';
        q.Name = 'test';
        q.zqu__Opportunity__c = o.id; 
        q.SecurityToken__c = '67123895fgahjsfk';
        q.InstanceID__c = 37893;
        
        insert q;
        
        Test.setCurrentPage(Page.validatevat);
        ValidateVATValidation vatvalidation = new ValidateVATValidation(new ApexPages.StandardController(q));
        vatvalidation.validate();
        
		

        
        
    }
    
    
   
}