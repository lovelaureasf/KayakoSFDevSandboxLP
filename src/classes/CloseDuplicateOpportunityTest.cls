@isTest
public class CloseDuplicateOpportunityTest{

    public static testMethod void positiveScenario(){
        
        account acc = new account();
        acc.name = 'test account';
        insert acc;
        
        opportunity o = new opportunity();
        o.name = 'test opportunity';
        o.stageName = 'Created';
        o.closeDate = date.today();
        o.orderId__c = 123456;
        o.type = 'Existing - K4 to Kayako';
        insert o;
        
        opportunity o2 = new opportunity();
        o2.name = 'test opportunity 2';
        o2.stageName = 'Created';
        o2.closeDate = date.today();
        o2.orderId__c = 123456;
        o2.type = 'Existing - K4 to Kayako';
        insert o2;
    
    }


}