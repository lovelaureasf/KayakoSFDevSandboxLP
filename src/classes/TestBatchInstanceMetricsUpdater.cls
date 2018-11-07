@isTest
public class TestBatchInstanceMetricsUpdater {
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
       
       for (Integer i=0;i<10;i++) {
            Instance__c a = new Instance__c();
            a.name='test.instance.com';
            a.uuid__c ='fhjk373374fhfjdkshfjks';
            a.Expiry_Date__c = DateTime.Now();
            a.instance_id__c = 444;
           
            aList.add(a);
       }
           insert aList;

       Test.startTest();
       BatchInstanceMetricsUpdater bieu= new  BatchInstanceMetricsUpdater();
       Database.executeBatch(bieu);
       Test.stopTest();

       
       
    }
}