/*
    This class schedules the Batch Instance Expiry Class, which in turn runs the batch over the instances.
*/

@isTest
public class TestScheduleBatchInstanceExpiry {
    
    static  testMethod void TestSchedule(){
       
       KayakoMetricsKey__c kmk = new KayakoMetricsKey__c();
       kmk.name = 'test';
       kmk.key__c = 'testing';
       insert kmk;
       
       KayakoAuditorKey__c km = new KayakoAuditorKey__c();
       km.name = 'tester';
       km.key__c = 'testing123';
       insert km;
       
        String chron1 = '0 2 * * * ? *';      
        System.schedule('ScheduleBatchInstanceExpiryUpdater', chron1, new ScheduleBatchInstanceExpiryUpdater());
    
    }



}