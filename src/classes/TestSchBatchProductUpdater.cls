@isTest
public class TestSchBatchProductUpdater{

static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('SchProductUpdater', chron1, new ScheduleProductUpdater());

}


}