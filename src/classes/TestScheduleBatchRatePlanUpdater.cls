@isTest
public class TestScheduleBatchRatePlanUpdater{

static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('ScheduleBatchRatePlanUpdater', chron1, new ScheduleBatchRatePlanUpdater());

}


}