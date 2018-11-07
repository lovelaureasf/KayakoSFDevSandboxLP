@isTest
public class TestSchSubVersionDateUpdater{

    public static  testMethod void TestSchedule(){
    
    String chron1 = '0 2 * * * ? *';      
    System.schedule('ScheduleVersionDateUpdate', chron1, new ScheduleSubscriptionVersionDateUpdater());
   
    }


}