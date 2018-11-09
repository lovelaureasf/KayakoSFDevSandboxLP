@isTest
public class CreateNewLeadControllerTest
{
    public static TestMethod void createNewLead()
    {
        // override callout.
        Test.setMock(HttpCalloutMock.class, new WebhookTest());

        SObject lead = ObjectMocker.mock('Lead');
        lead.put('Phone', '+9192939495');
        lead.put('firstName', 'some name');
        lead.put('lastName', 'last name');
        lead.put('company', 'company name');
        lead.put('KA_Product__c', 'Case');
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        CreateNewLeadController controller = new CreateNewLeadController(standardController);
        controller.save();
        controller.getPickLstValue();
        PageReference response = controller.finalsave();
        
        System.assertEquals(response.getParameters().get('id'), lead.Id);
    }
    
    public static TestMethod void errorOnInvalidPhone()
    {
        // override callout.
        Test.setMock(HttpCalloutMock.class, new WebhookTest());

        Lead lead = (Lead) ObjectMocker.mock('Lead');
        lead.Phone = '91-929 (39) 495';
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(lead);
        CreateNewLeadController controller = new CreateNewLeadController(standardController);
        
        PageReference response = controller.finalsave();
        
        System.assert(response.getRedirect());
        
    }
}