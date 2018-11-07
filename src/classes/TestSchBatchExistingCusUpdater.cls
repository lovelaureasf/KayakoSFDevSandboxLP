@isTest
public class TestSchBatchExistingCusUpdater{


static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('BatchExistingCusUpdater', chron1, new  ScheduleBatchExistingCusUpdater());

}


}