@isTest
public class TestScheduleLeadAssignment{


static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('Batch Lead Assignment', chron1, new ScheduleLeadAssignment());

}


}