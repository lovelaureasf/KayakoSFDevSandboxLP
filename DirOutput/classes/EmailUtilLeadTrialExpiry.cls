/*
Created By: Sagar Pareek
Description: This class is used by the Batch Apex to send the email that is sent after expiry of the lead/trial.
This class selects the pre-defined email for the trial expiry. Then checks the onwer's signature, replaces the key fields and then sends the email.
*/

public class EmailUtilLeadTrialExpiry
{
    @InvocableMethod //One class can only have one invocable method and can only accept list of sObject (salesforce object)
    public static void mailSender(List<Id> leadList)
    {
        
        //Selects the email template defined for lead trial expiry.
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName='Lead_Trial_Expired_Email_Template'];
       
        
        // This the map of salesforce id of the user to complete user object instance. 
        Map<String,User>UserIdToObjectMap = new Map<String,User>();
        
        // Adding values to the map defined above.
        for(user u : [select id,name,signature,DripFromEmail__c from user  where isActive=true]){
            UserIdToObjectMap.put(u.id,u);
        }
        
        //Iterating on the list of sObject (lead) received and then feeding values to the email template and email class.
        for(lead l:[select id,name,DripFromEmail__c,Owner.Name,Owner.Email,Owner.Id,KA_Product__c from lead where Id IN:LeadList]){
            System.debug('working on lead email util'+l.id);
              String subject = '';
               String htmlBody ='';
            if(l.KA_Product__c=='Fusion' || l.KA_Product__c=='Case' || l.KA_Product__c=='Engage'){
               subject = emailTemplate.Subject;
               htmlBody = emailTemplate.HtmlValue;
            }else{
                 subject = emailTemplate.Subject;
                 htmlBody = emailTemplate.HtmlValue;
            
            }
             String Signature = '';
            
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
            
            email.setTargetObjectId(l.id);
            email.setSaveAsActivity(false);
            email.setCCAddresses( new String[]{'jamie.edwards@kayako.com'});
            email.setBCCAddresses( new String[]{'sagar.pareek@kayako.com'});
            email.setSubject(subject);
            email.setHtmlBody(htmlBody);
            //email.setSenderDisplayName(l.Owner.Name);
            //email.setPlainTextBody(plainBody);
        
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email}); // this will shoot the email.
        
        }
    }
}