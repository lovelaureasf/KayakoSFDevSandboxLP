@isTest
public class TestScheduleAccountCMRRWUpdater{


static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('Account CMRRW Updater', chron1, new ScheduleAccountCMRRWUpdater());

}


}