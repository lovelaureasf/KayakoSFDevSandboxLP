@isTest
public class WebhookTest implements HttpCalloutMock 
{

    private static HttpRequest request;
    private static HttpResponse response;

    public HTTPResponse respond(HTTPRequest req)
    {
        request = req;
        response = new HttpResponse();
        response.setStatusCode(200);
        return response;
    }

    public static TestMethod void testSendRequest() 
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());

        SObject o = ObjectMocker.mock('Lead');

        Test.startTest();
            insert o;
        Test.stopTest();
        
        if(response!=null){
            System.assertEquals(200, response.getStatusCode());
            System.assertEquals('https://my.kayako.com/Backend/SFWebhookListener/Handle', request.getEndpoint());
        }
        if (request != null) 
        {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(request.getBody());
            System.assertNotEquals(null, jsonResponse.get('userId'));
        }
    }
    
    public static TestMethod void sendTextSlackAlert()
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());
        
        Test.startTest();
            Webhook.TriggerSlackAlert('some text here');
        Test.stopTest();
        
        if(response!=null){
            System.assertEquals(200, response.getStatusCode());
            System.assertEquals(Slack.WebhookDestination, request.getEndpoint());
        }
        String responseBody = request.getBody();
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.assertEquals('some text here', jsonResponse.get('text'));
    }
    
    public static TestMethod void sendObjectSlackAlert()
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());
        
        Test.startTest();
            Webhook.TriggerSlackAlert(new Map <String, Object> { 'Key' => 'value' });
        Test.stopTest();
        
        if(response!=null){
            System.assertEquals(200, response.getStatusCode());
            System.assertEquals(Slack.WebhookDestination, request.getEndpoint());
        }
        String responseBody = request.getBody();
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.assertEquals('value', jsonResponse.get('Key'));
    }
    
    public static TestMethod void triggerEvents()
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());
        
        Lead lead = (Lead) ObjectMocker.mock('Lead');
        lead.KA_Product__c = 'test';
        lead.KA_ProductType__c ='test';
        
        Opportunity opportunity = (Opportunity) ObjectMocker.mock('Opportunity');
        Account account = (Account) ObjectMocker.mock('Account');
        Contact contact = (Contact) ObjectMocker.mock('Contact');
        
        Test.startTest();
        insert lead;
        insert opportunity;
        insert account;
        insert contact;
        
        update lead;
        update opportunity;
        update account;
        update contact;

        delete lead;
        delete opportunity;
        delete account;
        delete contact;
        Test.stopTest();
    }
    public static TestMethod void testAsJson(){
        
        account acc = new account();
        acc.name='test';
        
        insert acc;
        List<Account> accList = new List<account>();
        accList.add(acc);
        
        
        
        Webhook.AsJson(accList,accList);
    }
}