@isTest(SeeAllData = true)
public class TestUpdateProductAndRatePlan {
    public static testMethod void positiveScenario(){
        
        List<Zuora__Subscription__c> slist = [select id,name,Zuora__Version__c from Zuora__Subscription__c limit 1];
        
        slist[0].Zuora__Version__c = 4000;
        update slist;
        
        
    }
}