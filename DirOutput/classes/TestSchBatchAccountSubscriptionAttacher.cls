@isTest
public class TestSchBatchAccountSubscriptionAttacher {

static  testMethod void TestSchedule(){

String chron1 = '0 2 * * * ? *';      
System.schedule('Account Subscription Attacher', chron1, new ScheduleBatchAccountSubscriptionAttacher());

}


}