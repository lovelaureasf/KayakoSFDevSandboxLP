@isTest
public class TestBatchInstanceExpiryUpdater {
    static testmethod void test() {
        
      
       KayakoMetricsKey__c kmk = new KayakoMetricsKey__c();
       kmk.name = 'test';
       kmk.key__c = 'testing';
       insert kmk;
       
       KayakoAuditorKey__c km = new KayakoAuditorKey__c();
       km.name = 'tester';
       km.key__c = 'testing123';
       insert km;
       
       List<Instance__c> aList = new List<Instance__c>();
       
            Instance__c a = new Instance__c();
            a.name='test.instance.com';
            a.uuid__c ='fhjk373374fhfjdkshfjks';
            a.Expiry_Date__c = DateTime.Now();
            a.instance_id__c = 444;
            insert a;
        
             
           Lead l = new Lead();
           l.lastName = 'test';
           l.Email = 'test@test.com';
           l.Company = 'test company';
           l.Instance__c = a.id;
           l.ka_product__c = 'Standard';
           insert l;
           
        
           Account acc = new Account();
           acc.name = 'test';
           insert acc ;
        
           Opportunity o = new Opportunity();
           o.Name = 'test';
           o.accountId =  acc.id;
           o.StageName = 'Value Proposition';
           o.CloseDate = Date.today()+30;
           o.Instance__c = a.id;
           o.type = 'New Business';
           insert o;
        
            Zuora__Subscription__c zs= new Zuora__Subscription__c();
            zs.Zuora__Status__c ='Active';
            zs.InstanceId__c = a.id;
            insert zs;
        
                       
            
      
           

       Test.startTest();
       BatchInstanceExpiryUpdater bieu= new  BatchInstanceExpiryUpdater();
       Database.executeBatch(bieu);
       Test.stopTest();

       
       
    }
    
     static testmethod void test2() {
        
      
       KayakoMetricsKey__c kmk = new KayakoMetricsKey__c();
       kmk.name = 'test';
       kmk.key__c = 'testing';
       insert kmk;
       
       KayakoAuditorKey__c km = new KayakoAuditorKey__c();
       km.name = 'tester';
       km.key__c = 'testing123';
       insert km;
       
       List<Instance__c> aList = new List<Instance__c>();
       
            Instance__c a = new Instance__c();
            a.name='test.instance.com';
            a.uuid__c ='fhjk373374fhfjdkshfjks';
            a.Expiry_Date__c = DateTime.Now();
            a.instance_id__c = 444;
            insert a;
        
             
           
           
        
           Account acc = new Account();
           acc.name = 'test';
           insert acc ;
        
           Opportunity o = new Opportunity();
           o.Name = 'test';
           o.accountId =  acc.id;
           o.StageName = 'Value Proposition';
           o.CloseDate = Date.today()+30;
           o.Instance__c = a.id;
           o.type = 'New Business';
           insert o;
        
          
        
                       
            
      
           

       Test.startTest();
       BatchInstanceExpiryUpdater bieu= new  BatchInstanceExpiryUpdater();
       Database.executeBatch(bieu);
       Test.stopTest();

       
       
    }
}