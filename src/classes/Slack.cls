global without sharing class Slack
{
    global static final String WebhookDestination = 'https://hooks.slack.com/services/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';
    
    global static String PayloadAsString(String text)
    {
        return JSON.serialize(BuildPayload(text));
    }
    
    global static Map <String, Object> BuildPayload(String text)
    {
        return new Map <String, Object> {
            'icon_emoji' => ':trollface:',
            'username'   => 'Salesforce',
            'parse' => 'full',
            'text' => text
        };
    }
    
    private static Map <String, Object> NewAttachment(List <Map <String, Object>> fields, String text)
    {
        return new Map <String, Object>
        {
            'fields' => fields,
            'title'  => text,
            'color'  => '#ff0000'
        };
    }
    
    private static Map <String, Object> PayloadWithAttachment(Set <List <Map <String, Object>>> fieldSet, String text, String title)
    {
        List <Map <String, Object>> attachments = new List <Map <String, Object>> ();
        Map <String, Object> payload = BuildPayload(text);
        
        for(List<Map<String, Object>> fields : fieldSet)
        {
            attachments.add(NewAttachment(fields, title));
        }
        
        payload.put('attachments', attachments);
        
        return payload;
    }
    
    global static Map <String, Object> BuildPayload(String text, String title, List <Lead> leads)
    {
        Set <List <Map <String, Object>>> attachmentFields = new Set <List <Map <String, Object>>> ();

        for (Lead lead : leads)
        {
            List <Map <String, Object>> fields = new List <Map <String, Object>> ();
            
            fields.add(AttachmentField('Id', lead.Id, true));
            fields.add(AttachmentField('Name', lead.Name, true));
            fields.add(AttachmentField('Email', lead.Email, true));
            fields.add(AttachmentField('Stage', lead.Stage__c, true));
            fields.add(AttachmentField('Status', lead.Status, true));
            fields.add(AttachmentField('Phone', lead.Phone, true));
            fields.add(AttachmentField('Creation Stage', lead.CreationStage__c, true));
            fields.add(AttachmentField('Source', lead.LeadSource, true));
            fields.add(AttachmentField('Country', lead.Country, true));
            fields.add(AttachmentField('Owner', GetUserName(lead.OwnerId), true));
            fields.add(AttachmentField('Creation date', lead.CreatedDate.format(), true));
            
            attachmentFields.add(fields);
        }
        
        return PayloadWithAttachment(attachmentFields, text, title);
    }
    
    global static Map <String, Object> BuildPayload(String text, String title, List <Opportunity> opportunities)
    {
        Set <List <Map <String, Object>>> attachedFields = new Set <List <Map <String, Object>>> ();
        
        for(Opportunity opportunity : opportunities)
        {
            List <Map <String, Object>> fields = new List <Map <String, Object>> ();
            
            Decimal amount = (Decimal) opportunity.Amount;
            
            if(amount == null) amount = 0;
            
            fields.add(AttachmentField('Id', opportunity.Id, true));
            fields.add(AttachmentField('Name', opportunity.Name, true));
            fields.add(AttachmentField('Stage', opportunity.StageName, true));
            fields.add(AttachmentField('Owner', GetUserName(opportunity.OwnerId), true));
            fields.add(AttachmentField('Amount', amount.setScale(2).format(), true));
            fields.add(AttachmentField('Product', opportunity.Product__c, true));
            fields.add(AttachmentField('Type', opportunity.Type, true));
            fields.add(AttachmentField('Plan', opportunity.Plan__c, true));
            fields.add(AttachmentField('Lead Source', opportunity.LeadSource, true));
            
            attachedFields.add(fields);
        }
            
        return PayloadWithAttachment(attachedFields, text, title);
    }
    
    global static Map <String, Object> BuildPayload(String text, String title, List <Account> accounts)
    {
        Set <List <Map <String, Object>>> attachedFields = new Set <List <Map <String, Object>>> ();
        
        for (Account account : accounts)
        {
            List <Map <String, Object>> fields = new List <Map <String, Object>> ();
            
            fields.add(AttachmentField('Id', account.Id, true));
            fields.add(AttachmentField('Owner', GetUserName(account.OwnerId), true));
            fields.add(AttachmentField('Name', account.Name, true));
            fields.add(AttachmentField('Phone', account.Phone, true));
            fields.add(AttachmentField('Website', account.Website, true));
            
            attachedFields.add(fields);
        }
        
        return PayloadWithAttachment(attachedFields, text, title);
    }
    
    global static Map <String, Object> BuildPayload(String text, String title, List <Contact> contacts)
    {
        Set <List <Map <String, Object>>> attachedFields = new Set <List <Map <String, Object>>> ();
        
        for (Contact contact : contacts)
        {
            List <Map <String, Object>> fields = new List <Map <String, Object>> ();
            
            fields.add(AttachmentField('Id', contact.Id, true));
            fields.add(AttachmentField('Owner', GetUserName(contact.OwnerId), true));
            fields.add(AttachmentField('Name', contact.Name, true));
            fields.add(AttachmentField('Phone', contact.Phone, true));
            fields.add(AttachmentField('Email', contact.Email, true));
            
            attachedFields.add(fields);
        }
    
        return PayloadWithAttachment(attachedFields, text, title);
    }
    
    global static Map <String, Object> AttachmentField(String title, String value, Boolean isShort)
    {
        return new Map <String, Object>
        {
            'title' => title,
            'value' => value,
            'short' => isShort
        };
    }
    
    private static String GetUserName(Id userId)
    {
        User user = null;
        
        try
        {
            user = UserDataAccess.GetUser(userId);
        }
        catch(UnderflowException noUserFound){return '';}
        
        return user.Name;
    }
}