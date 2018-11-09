@isTest
public class TestExpiryExtender {


    public static  testmethod void leadExtTest(){
      
        Instance__c zs = new Instance__c(); 
        zs.Expiry_Date__c = Date.today()+30;
        zs.Name = 'test.kayako.com';
        zs.Instance_ID__c = 222;
        insert zs;
        
        lead l = new lead();
        l.lastname ='test';
        l.Email= 'testZXCVAGHGHJGHJ@test.com';
        l.Company = 'test';
        l.Instance__c =zs.id;
        insert l;
    
        ApexPages.StandardController sc = new ApexPages.StandardController(zs);
        
        PageReference pageRef = new PageReference('/'+zs.Id);
        pageRef.getParameters().put('id', String.valueOf(zs.Id));
        Test.setCurrentPage(pageRef);
        
        
        
        ExpiryExtender see = new ExpiryExtender(sc);
        
       
        
        see.daySelected='7';
        
        see.backToDetailPage();
        
        see.submitExpiry();
    }
    
    
    public static  testmethod void oppExtTest(){
      
        Instance__c zs2 = new Instance__c(); 
        zs2.Expiry_Date__c = Date.today()+30;
        zs2.Name = 'test.kayako.com';
        zs2.Instance_ID__c = 222;
        insert zs2;
        
        Account a = new Account();
        a.name ='test acc';
        insert a;
        
        Opportunity o = new Opportunity();
        o.StageName = 'Value Proposition';
        o.Amount =2;
        o.AccountId = a.id;
        o.CloseDate = Date.today()+40;
        o.Name = 'test';
        insert o;
    
        ApexPages.StandardController sc = new ApexPages.StandardController(zs2);
        
        PageReference pageRef = new PageReference('/'+zs2.Id);
        pageRef.getParameters().put('id', String.valueOf(zs2.Id));
        Test.setCurrentPage(pageRef);
        
        
        
        ExpiryExtender see = new ExpiryExtender(sc);
        
       
        
        see.daySelected='7';
        
        see.backToDetailPage();
        
        see.submitExpiry();
    }
    
    
    public static  testmethod void subsExtTest(){
      
        Instance__c zs3 = new Instance__c(); 
        zs3.Expiry_Date__c = Date.today()+30;
        zs3.Name = 'test.kayako.com';
        zs3.Instance_ID__c = 222;
        insert zs3;
        
        Zuora__Subscription__c z = new Zuora__Subscription__c();
        z.Instance__c = zs3.id;
        z.SecurityToken__c ='xyz123';
        z.Name = 'S-123';
        insert z;
    
        ApexPages.StandardController sc = new ApexPages.StandardController(zs3);
        
        PageReference pageRef = new PageReference('/'+zs3.Id);
        pageRef.getParameters().put('id', String.valueOf(zs3.Id));
        Test.setCurrentPage(pageRef);
        
        
        
        ExpiryExtender see = new ExpiryExtender(sc);
        
       
        
        see.daySelected='7';
        
        see.backToDetailPage();
        
        see.submitExpiry();
    }
}