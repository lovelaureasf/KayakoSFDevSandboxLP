@isTest(SeeAllData = true)
public class TestUpdateValuesOnQuote{
    public static testMethod void positiveScenario(){
        
        zqu__QuoteChargeSummary__c    q = new zqu__QuoteChargeSummary__c();
        q.name = 'Enterprise - Annual';
        q.zqu__QuoteRatePlan__c = [select id,name from zqu__QuoteRatePlan__c where name = 'Enterprise - Annual'][0].id;
        insert q;
    
    
    }



}