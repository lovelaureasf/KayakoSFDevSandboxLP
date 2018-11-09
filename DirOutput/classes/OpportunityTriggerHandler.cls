//******************************************************************
// Name: OpportunityTriggerHandler
// Purpose: This Class is being Used to write the business logic for various event on Opportunity
// Author: Gaurav Agarwal
// Date: 24/08/2018 
//******************************************************************
public class OpportunityTriggerHandler
{
    public static Set<Id> ownerlistids = new Set<Id>(); 
    public static map<id,String> userEmail = new map<id, String>();
    public static void handlebeforeUpdate(List<Opportunity> oppnewList, Map<id, Opportunity> oppoldmap)
    {
    }
    
    public static void handleAfterUpdate(List<Opportunity> oppnewList, Map<id, Opportunity> oppoldmap)
    {
        // Check if owner has been changed on Lead then pull email for previous and new owner
        for(Opportunity opp: oppnewList)
        {
             if(opp.OwnerId != oppoldmap.get(opp.id).OwnerId)
            {
                ownerlistids.add(opp.OwnerId);
                ownerlistids.add(oppoldmap.get(opp.id).OwnerId);
            }
        }
        
        for(User usr: [select id, email from user where id IN:ownerlistids])
        {
            userEmail.put(usr.id,usr.email); 
        }
        for(Opportunity opp: oppnewList)
        {
            if(opp.OwnerId != oppoldmap.get(opp.id).OwnerId)
            {
                // If Owner has been changed then call method to send email notification.
                sendNotifcation(opp.id,opp.OwnerId, oppoldmap.get(opp.id).OwnerId);
            }
        }
    }
    
    public static void sendNotifcation(String oppid,String newOwner, String OldOwner)
    {
     
        String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+oppid;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.toAddresses = new String[] { userEmail.get(newOwner), userEmail.get(OldOwner) };
        mail.subject = 'Opportunity Owner Changed';
        String messageBody = '<html><body>Hi, A Opportunity has been reassigned to a new owner. Click the link below to view the record in Salesforce.  &nbsp;&nbsp;&nbsp; <a href="' + Recordlink + '"> Record link </a></body>  </html>';
        mail.setHtmlBody(messageBody); 
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        System.debug('@@@ mail details');
        System.debug(mail);
        try{    
            Messaging.sendEmail(allmsg,false);
           }
           catch(exception e)
           {
               system.debug('@@@ error' + e.getMessage());
           }

    }
}