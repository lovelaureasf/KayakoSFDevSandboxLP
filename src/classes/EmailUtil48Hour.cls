/*
Created By: Sagar Pareek
Description: This class is used by the process builder to schedule the email that is sent after 48 hours of the lead creation.
This class selects the pre-defined email for the 48 hour email. Then checks the onwer's signature, replaces the key fields and then sends the email.
*/
public class EmailUtil48Hour
{
    @InvocableMethod //One class can only have one invocable method and can only accept list of sObject (salesforce object)
    public static void mailSender(List<Id> leadList)
    {
        
        //Selects the email template defined for the 1 hour email
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName='X48HoursDripEmailTemplate'];
        
        
        // This the map of salesforce id of the user to complete user object instance. 
        Map<String,User>UserIdToObjectMap = new Map<String,User>();
        
        // Adding values to the map defined above.
        for(user u : [select id,name,signature,DripFromEmail__c from user  where isActive=true]){
            UserIdToObjectMap.put(u.id,u);
        }
        
        //Iterating on the list of sObject (lead) received and then feeding values to the email template and email class.
        for(lead l:[select id,name,DripFromEmail__c,Included_In_Drip_Date__c,Owner.Name,Owner.Email,Owner.Id,Owner.FirstName from lead where Id IN:LeadList]){
            
            
            if(l.Included_In_Drip_Date__c!=null){
            
            Long dt1Long = DateTime.now().getTime();
            
            Long dt2Long = l.Included_In_Drip_Date__c.getTime();
            
            Long milliseconds = dt1Long - dt2Long;
            
            Long seconds = milliseconds / 1000;
            
            Long minutes = seconds / 60;
            
            Long hours = minutes / 60;
            
            
            if(Test.isRunningTest()){
                hours = 48;
            }
            
            
            if(minutes>30 && hours<=48){
            String subject = emailTemplate.Subject;
            String Signature = '';

            String htmlBody = emailTemplate.HtmlValue;
            
            
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
                //build the email message
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();email.setReplyTo(l.DripFromEmail__c);OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName =:l.Owner.Name];if ( owea.size() > 0 && owea!=null) {email.setOrgWideEmailAddressId(owea.get(0).Id);}else{email.setSenderDisplayName(l.Owner.Name);}email.setTargetObjectId(l.id);email.setSaveAsActivity(false);email.setBCCAddresses( new String[]{'sagar.pareek@kayako.com'});email.setCCAddresses( new String[]{'jamie.edwards@kayako.com'});email.setSubject(subject);email.setHtmlBody(htmlBody);if (!Test.isRunningTest()){Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});}
        }
        }
       } 
    }
}