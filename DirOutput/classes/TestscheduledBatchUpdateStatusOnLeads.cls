/**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * Type - Apex Test Class
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @Object      None  
  * @Description This class will be used to test the scheduler class created
  * @OrigialCls  scheduledBatchUpdateStatusOnLeads
  * @Author      Manoj Sankaran
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  * Modification Log
  * 09-21-2018 - Created by Manoj Sankaran
  * 
  */
@isTest
public class TestscheduledBatchUpdateStatusOnLeads{

    static  testMethod void TestSchedule(){    
        String chron1 = '0 2 * * * ? *';      
        System.schedule('Lead Expiry Date', chron1, new scheduledBatchUpdateStatusOnLeads());    
    }
    

}