@isTest
public class TestSchCustomerAccCreationDateUpdater{

    static  testMethod void TestSchedule(){
    
        String chron1 = '0 2 * * * ? *';      
        System.schedule('BatchCustomerAccCreationDateUpdater', chron1, new ScheduleCustomerAccCreationDateUpdater());
        
    }


}