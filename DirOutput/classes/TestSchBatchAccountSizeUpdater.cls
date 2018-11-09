@isTest
public class TestSchBatchAccountSizeUpdater{

static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('BatchAccountSizeUpdater', chron1, new ScheduleAccountSizeUpdater());

}


}