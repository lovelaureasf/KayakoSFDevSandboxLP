@isTest
public class TestLeadTriggersOnMQL {

public static testMethod void positiveScenario(){

lead l = new lead();
l.lastname = 'test';
l.email ='test@test.com';
l.Stage__c='MQL';
l.Status='Open';
l.company='kayako';
l.KA_Product__c = 'test';
l.KA_ProductType__c ='test';
insert l;

l.Stage__c ='SRL';
l.Status ='Nuture';
update l;

l.Stage__c='MQL';
l.Status='Open';
update l;



}



}