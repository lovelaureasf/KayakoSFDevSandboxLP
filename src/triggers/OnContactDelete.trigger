trigger OnContactDelete on Contact (before delete)
{
    List <Contact> contacts = Trigger.old;
    Integer size = contacts.size();
    String clause = '';
    
    if(size > 1) 
    {
        clause = ' contacts';
    }
    else
    {
        clause = ' contact';
    }
    
    if(System.isBatch() && !Test.isRunningTest()){Webhook.TriggerSlackAlert(UserInfo.getName() + ' deleted ' + size + clause + ' in bulk mode.');}
    
    if(contacts.size() > 10 && !Test.isRunningTest()){Webhook.TriggerSlackAlert(UserInfo.getName() + ' deleted ' + size + clause + ', cannot show all the details for more than 10 records.');
    }
    else
    {
        if(!Test.isRunningTest()){Webhook.TriggerSlackAlert(Slack.BuildPayload('', UserInfo.getName() + ' deleted a contact', contacts));
        }
    }
}