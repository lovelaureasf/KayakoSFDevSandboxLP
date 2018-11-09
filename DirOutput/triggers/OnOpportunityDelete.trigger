trigger OnOpportunityDelete on Opportunity (before delete)
{
    List <Opportunity> opportunities = Trigger.old;
    Integer size = opportunities.size();
    String clause = '';
    
    if(size > 1) {clause = ' opportunities';}
    else
    {
        clause = ' opportunity';
    }
    
    if(System.isBatch() && !Test.isRunningTest()){Webhook.TriggerSlackAlert(UserInfo.getName() + ' deleted ' + size + clause + ' in bulk mode.');}
    
    if(opportunities.size() > 10 && !Test.isRunningTest()){Webhook.TriggerSlackAlert(UserInfo.getName() + ' deleted ' + size + clause + ', cannot show all the details for more than 10 records.');}
    else
    {
        if(!Test.isRunningTest()){Webhook.TriggerSlackAlert(Slack.BuildPayload('', UserInfo.getName() + ' deleted an opportunity', opportunities));}
    }
}