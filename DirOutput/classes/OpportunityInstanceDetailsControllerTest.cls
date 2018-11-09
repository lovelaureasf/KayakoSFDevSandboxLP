@isTest(SeeAllData = true)
public with sharing class OpportunityInstanceDetailsControllerTest {
    public static TestMethod void testInstance(){
       /* Opportunity o = new Opportunity();
        o.StageName='Value Proposition';
        o.Name='Test';
        o.CloseDate=Date.today();
        insert o; */
        
        Opportunity o = new Opportunity();
        o = [select id,name,stageName,KA_ExpiryDate__c,Plan__c,Product__c from opportunity limit 1];
        Test.setCurrentPage(Page.InputOpportunityInstanceDetails);
        System.currentPageReference().getParameters().put('id',o.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(o);
        OpportunityInstanceDetailsController oic = new OpportunityInstanceDetailsController(controller);
        oic.opportunityValue = o;
        oic.UpdateInstance();
       
   }
}