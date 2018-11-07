/*
Created By: Sagar Pareek
Description: This class is used by the process builder to schedule the email that is sent after 93 hours of the lead creation(works on opportunity).
This class selects the pre-defined email for the 93 hour email. Then checks the onwer's signature, replaces the key fields and then sends the email.
*/

public class EmailUtil93HourForOpp
{
    @InvocableMethod //One class can only have one invocable method and can only accept list of sObject (salesforce object)
    public static void mailSender(List<Id> oppList)
    {
        
        //Selects the email template defined for the 1 hour email
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName='X93HourEmail'];
        
        
        // This the map of salesforce id of the user to complete user object instance. 
        Map<String,User>UserIdToObjectMap = new Map<String,User>();
        
        // Adding values to the map defined above.
        for(user u : [select id,name,signature,DripFromEmail__c from user  where isActive=true]){
            UserIdToObjectMap.put(u.id,u);
        }
        
        //Iterating on the list of sObject (lead) received and then feeding values to the email template and email class.
        for(lead l:[select id,name,DripFromEmail__c,Owner.Name,Owner.Email,Owner.Id,convertedContactId from lead where ConvertedOpportunityId IN:oppList]){
            
            String subject = emailTemplate.Subject;
            String Signature = '';

            String htmlBody = emailTemplate.HtmlValue;
            
            htmlBody = htmlBody.replace('{!Lead.Name}', l.Name);
            htmlBody = htmlBody.replace('{!Lead.Name}', l.Name);
            htmlBody = htmlBody.replace('{!Lead.OwnerFullName}', l.Owner.Name);
            
          if(UserIdToObjectMap!=null && !(Test.isRunningTest())){
            if(UserIdToObjectMap.get(l.OwnerId).signature!=null){ // reading the new line/ new rows in the signature of the user and then replacing it with html markup.
               signature = UserIdToObjectMap.get(l.OwnerId).signature;
                if(signature.contains('\r\n')){signature = signature.replace('\r\n', '<br/>');}
                if(signature.contains('\r\n')){signature = signature.replace('\n', '<br/>');}
                if(signature.contains('\r\n')){signature = signature.replace('\r', '<br/>');}
                htmlBody = htmlBody.replace('{!Lead.OwnerEmail}',signature);
                
                
            }
            }else{
                htmlBody = htmlBody.replace('{!Lead.OwnerEmail}', '');
            
            }
            
           
        
                //build the email message
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        
            email.setReplyTo(l.DripFromEmail__c);
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName =:l.Owner.Name];
            
            if ( owea.size() > 0 && owea!=null) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }else{
                email.setSenderDisplayName(l.Owner.Name);
            }
            
            email.setTargetObjectId(l.convertedContactId);
            email.setSaveAsActivity(false);
            email.setBCCAddresses( new String[]{'sagar.pareek@kayako.com'});
            email.setSubject(subject);
            email.setHtmlBody(htmlBody);
            //email.setSenderDisplayName(l.Owner.Name);
            //email.setPlainTextBody(plainBody);
        
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email}); // this will shoot the email.
        
        }
    }
}