@isTest
public class convertToContactTest {
    public static testMethod void positiveScenario(){
        lead l = new lead();
        l.lastname = 'test';
        l.Company='test';
        l.Email='s@s.com';
        l.KA_Product__c='test';
        l.KA_ProductType__c='test';
        l.LeadSource = 'Demo Request';
        insert l;
        l.status='Qualified';
        l.IsResponded__c = true;
        l.CancelDripFlow__c=true;
        update l;
        Apexpages.currentpage().getparameters().put('id' , l.Id);
        convertToContact c = new convertToContact();
        
        c.acr.role ='Decision Maker' ;
        
        c.convert();
        
    }
}