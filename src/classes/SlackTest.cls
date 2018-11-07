@IsTest
public class SlackTest
{
	public static TestMethod void PayloadAsJsonString()
    {
        String payload = Slack.PayloadAsString('this is the text content');
        
        Map <String, Object> decoded = (Map <String, Object>) JSON.deserializeUntyped(payload);
        
        System.assert(decoded.containsKey('icon_emoji'));
        System.assert(decoded.containsKey('username'));
        System.assert(decoded.containsKey('text'));
        System.assertEquals('this is the text content', decoded.get('text'));
    }
    
    @IsTest(SeeAllData = true)
    public static void LeadAsAttachmentPayload()
    {
        List<Lead> lead = [SELECT id, email, name, phone, stage__c, status, CreationStage__c, 
                     leadSource, country, ownerid, createdDate 
                     FROM lead limit 2];
        
        Map <String, Object> payload = Slack.BuildPayload('this is the text', 'this is some text content', lead);
        
        System.assert(payload.containsKey('attachments'));
        System.assert(payload.containsKey('username'));
        System.assert(payload.containsKey('icon_emoji'));
    }
    
    @IsTest(SeeAllData = true)
    public static void OpportunityAsAttachmentPayload()
    {
        List<Opportunity> o = [select name, stagename, ownerid, amount, product__c, type, plan__c, leadsource from opportunity limit 2];
        
        Map <String, Object> payload = Slack.BuildPayload('this is the text', 'this is some text content', o);
        
        System.assert(payload.containsKey('attachments'));
        System.assert(payload.containsKey('username'));
        System.assert(payload.containsKey('icon_emoji'));
    }
    
    @IsTest(SeeAllData = true)
    public static void AccountAsAttachmentPayload()
    {
        List <Account> a = [select ownerId, name, phone, website from account limit 2];
        
        Map <String, Object> payload = Slack.BuildPayload('this is the text', 'this is some text content', a);
        
        System.assert(payload.containsKey('attachments'));
        System.assert(payload.containsKey('username'));
        System.assert(payload.containsKey('icon_emoji'));
    }
    
    @IsTest(SeeAllData = true)
    public static void ContactAsAttachmentPayload()
    {
        List <Contact> c = [select ownerId, name, phone, email from contact limit 2];
        
        Map <String, Object> payload = Slack.BuildPayload('this is the text', 'this is some text content', c);
        
        System.assert(payload.containsKey('attachments'));
        System.assert(payload.containsKey('username'));
        System.assert(payload.containsKey('icon_emoji'));
    }
}