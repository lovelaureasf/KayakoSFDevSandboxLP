@isTest
public class TestScheduleLeadAssignmentSAL{


static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('Batch Lead Assignment SAL', chron1, new ScheduleLeadAssignmentSAL());

}


}