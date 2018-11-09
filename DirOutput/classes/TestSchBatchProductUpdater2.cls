@isTest
public class TestSchBatchProductUpdater2{

static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('SchProductUpdater2', chron1, new ScheduleProductUpdater2());

}


}