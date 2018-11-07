@IsTest
public class TestBatchUnresponsiveLeadCleanerJob
{
    public static TestMethod void CleanOldUnresponsiveLeads()
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());

        SObject lead = ObjectMocker.mock('Lead');
        lead.put('Status', LeadStatus.UNRESPONSIVE);
        lead.put('StatusToUnresponsiveDate__c', Date.today().addMonths(-3));
        lead.put('Email', 'unresponsive@kayako.test');
        lead.put('KA_Product__c', 'test');
        lead.put('KA_ProductType__c','test');
        
        insert lead;
        
        Test.startTest(); //get all the limits back
        
        BatchUnresponsiveLeadCleanerJob b = new BatchUnresponsiveLeadCleanerJob(); //call the batch
        
        Database.executeBatch(b);
        
        Test.stopTest(); //out of limit execution block
    }
}