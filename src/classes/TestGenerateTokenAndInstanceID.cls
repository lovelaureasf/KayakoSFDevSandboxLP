@isTest(SeeAllData=true)
public class TestGenerateTokenAndInstanceID {
    public static testMethod void positiveScenario(){
        
         zqu__Quote__c q = new zqu__Quote__c();
         q.SecurityToken__c = 'test';
         q.InstanceID__c=0001;
         q.zqu__Opportunity__c = [select id,name,OwnerId from opportunity where instance__c!=null limit 1][0].id;
         insert q;
        
    }
}