@isTest(SeeAllData = true)
public with sharing class LeadInstanceDetailsControllerTest {
    public static TestMethod void testInstance(){
       
        Lead l = new Lead();
        l = [select id,KA_TrialExpiryDate__c from lead limit 1];
        Test.setCurrentPage(Page.InputLeadInstanceDetails);
        System.currentPageReference().getParameters().put('id',l.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(l);
        LeadInstanceDetailsController lic = new LeadInstanceDetailsController(controller);
        
        lic.UpdateInstance();
   }
}