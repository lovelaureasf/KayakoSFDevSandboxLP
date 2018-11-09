@isTest(SeeAllData = true)
public class TestUpdateExistingCustomer {

    public static testMethod void positiveScenario(){
       
        
        
        lead l = new lead();
        l.lastName = 'test';
        l.Email = 'sagar.pareek@kayako.com';
        l.Company = 'kayakotest';
        l.LeadSource = 'website';
        l.Stage__c='MQL';
        l.Status = 'Open';
        
        insert l;
        
        
        
        
    }
    
    
}