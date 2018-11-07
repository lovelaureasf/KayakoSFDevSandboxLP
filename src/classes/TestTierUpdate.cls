@isTest(SeeAllData = true)
public class TestTierUpdate{

public static testMethod void positiveScenario(){

 zqu__Quote__c q = new zqu__Quote__c();
 q.name = 'test';
 q.zqu__Opportunity__c = [select id,name,OwnerId from opportunity where instance__c!=null limit 1][0].id;
 q.SecurityToken__c ='cvb';
 q.InstanceID__c=121;
 insert q;


}

}