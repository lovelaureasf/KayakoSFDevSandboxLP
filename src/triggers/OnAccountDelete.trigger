trigger OnAccountDelete on Account (before delete)
{
	List <Account> accounts = Trigger.old;
    Integer size = accounts.size();
    String clause = '';
    
    if(size > 1) 
    {
        clause = ' accounts';
    }
    else
    {
        clause = ' accounts';
    }
    
	if(System.isBatch() && !Test.isRunningTest()){Webhook.TriggerSlackAlert(UserInfo.getName() + ' deleted ' + size + clause + ' in bulk mode.');}
    
    if(accounts.size() > 10 && !Test.isRunningTest()){Webhook.TriggerSlackAlert(UserInfo.getName() + ' deleted ' + size + clause + ', cannot show all the details for more than 10 records.');
    }
    else
    {
        if(!Test.isRunningTest()){Webhook.TriggerSlackAlert(Slack.BuildPayload('', UserInfo.getName() + ' deleted an account', accounts));}
     }
}