@isTest
public class TestInstanceAndLead{

static testMethod void testScenario(){
    lead l = new lead();
    l.lastname = 'test';
    l.company ='test';
    l.email = 'test@test.com';
    l.KA_Product__c = 'test';
    l.KA_ProductType__c ='test';
    insert l;
    
    lead l2 = new lead();
    l2.lastname='test';
    l2.email = 'test@test.com';
    l2.company='test';
    l2.KA_Product__c = 'test';
    l2.KA_ProductType__c ='test';
    insert l2;
    
   
    Instance__c i = new Instance__c();
    i.id = l.Instance__c;
    i.Expiry_Date__c = date.today();
    insert i;
   
   
    lead l3 = new lead();
    l3.lastname='test';
    l3.email = 'test1@test.com';
    l3.company='test';
    l3.KA_TrialExpiryDate__c= date.today();
    l3.instance__c=i.id;
    l3.KA_Product__c = 'test';
    l3.KA_ProductType__c ='test';
    insert l3;
    
    l3.KA_TrialExpiryDate__c=date.today()+1;
    update l3;
    

}


}