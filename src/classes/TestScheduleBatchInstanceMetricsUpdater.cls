/*
    This class schedules the Batch Instance Metrics Updater, which in turn runs the batch over the instances.
*/

@isTest
public class TestScheduleBatchInstanceMetricsUpdater  {
    
    static  testMethod void TestSchedule(){
       
       KayakoMetricsKey__c kmk = new KayakoMetricsKey__c();
       kmk.name = 'test';
       kmk.key__c = 'testing';
       insert kmk;
       
       
       
       String chron1 = '0 2 * * * ? *';      
       System.schedule('ScheduleBatchInstanceMetricsUpdater', chron1, new ScheduleBatchInstanceMetricsUpdater());
    
    }



}