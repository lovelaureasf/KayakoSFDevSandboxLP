trigger OnLeadDelete on Lead (before delete)
{
    String host = Url.getCurrentRequestUrl().getHost();
    String path = Url.getCurrentRequestUrl().getPath();
    String authority = Url.getCurrentRequestUrl().getAuthority();
    
    if(host.contains('dupcheck') || host.contains('dc3') || path.contains('dc3') || 
        path.contains('dupcheck') || authority.contains('dupcheck') || authority.contains('dc3'))
    {
        return;
    }
    
    List <Lead> leads = Trigger.old;
    Integer size = leads.size();
    String clause = '';
    
    if(size > 1) 
    {
        clause = ' leads';
    }
    else
    {
        clause = ' lead';
    }

    if(System.isBatch() && !Test.isRunningTest()){Webhook.TriggerSlackAlert(UserInfo.getName() + ' deleted ' + size + clause + ' in bulk mode.');}
    
    if(leads.size() > 10 && !Test.isRunningTest()){Webhook.TriggerSlackAlert(UserInfo.getName() + ' deleted ' + size + clause + ', cannot show all the details for more than 10 records.');
    }
    else
    {
        if(!Test.isRunningTest()){Webhook.TriggerSlackAlert(Slack.BuildPayload('', UserInfo.getName() + ' deleted a lead', leads));
        }
    }
}