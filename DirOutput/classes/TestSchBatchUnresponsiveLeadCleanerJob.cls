@isTest
public class TestSchBatchUnresponsiveLeadCleanerJob{

static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('Unresponsive Lead Cleaner', chron1, new ScheduleBatchUnresponsiveLeadCleanerJob());

}


}