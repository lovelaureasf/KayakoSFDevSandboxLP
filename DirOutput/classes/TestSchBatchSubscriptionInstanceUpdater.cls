@isTest
public class TestSchBatchSubscriptionInstanceUpdater{

static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('BatchSubscriptionInstanceUpdater', chron1, new ScheduleBatchSubscriptionInstanceUpdater());

}


}