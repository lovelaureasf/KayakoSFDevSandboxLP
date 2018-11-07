@isTest
public class TestScheduleSubscriptionCMRRWUpdater {

    static  testMethod void TestSchedule(){
    
    String chron1 = '0 2 * * * ? *';      
    System.schedule('Schedule Account Status Maintainer', chron1, new ScheduleSubscriptionCMRRWUpdater());
    
    }


}