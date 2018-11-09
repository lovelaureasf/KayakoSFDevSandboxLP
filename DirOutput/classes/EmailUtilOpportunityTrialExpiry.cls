/*
Created By: Sagar Pareek
Description: This class is used by the Batch Apex to send the email that is sent after expiry of the Opportunity/trial.
This class selects the pre-defined email for the trial expiry. Then checks the onwer's signature, replaces the key fields and then sends the email.
*/

public class EmailUtilOpportunityTrialExpiry
{
    @InvocableMethod
    public static void mailSender(List<Id> OppList)
    {
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName='Lead_Trial_Expired_Email_Template'];
        
        Map<String,User>UserIdToObjectMap = new Map<String,User>();
        
        for(user u : [select id,name,signature,DripFromEmail__c from user  where isActive=true]){
            UserIdToObjectMap.put(u.id,u);
        }
        
        for(lead l:[select id,name,DripFromEmail__c,Owner.Name,Owner.Email,Owner.Id,convertedContactId from lead where ConvertedOpportunityId IN:OppList]){
            System.debug('email util opp exp lead id is'+l.id);
            String subject = emailTemplate.Subject;
            String signature ='';

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
        
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
        
        }
    }
}