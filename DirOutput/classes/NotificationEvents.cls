public without sharing class NotificationEvents
{
    public static void OpportunityAmountManipulation(List <Opportunity> oldRecord, List <Opportunity> newRecord)
    {
        System.debug('calling manupulation');
        Map <Id, Opportunity> newObjects = new Map <Id, Opportunity> (newRecord);
        Map <Id, Opportunity> oldObjects = new Map <Id, Opportunity> (oldRecord);
        System.debug('the new record is'+ newobjects);
        System.debug('the old record is'+oldrecord);
        for(Id index : newObjects.keySet())
        {
            Opportunity oldObject = oldObjects.get(index);
            Opportunity newObject = newObjects.get(index);
            
            // If the stage was changed to Lost then we need to check the history.
            if(newObject.StageName == OpportunityStage.LOST && oldObject.StageName != OpportunityStage.LOST)
            {
                SendAlertForAmount(newObject);
            }
        }
    }
    
    private static void SendAlertForAmount(Opportunity opportunity)
    {
        
        System.debug('checking history amount');
        Boolean wasLastDecremented = false;

        List <OpportunityHistory> historyEvents = OpportunityDataAccess.GetHistory(opportunity.Id);
        Map <Opportunity, OpportunityHistory> eventLog = new Map <Opportunity, OpportunityHistory> (); 

        for(OpportunityHistory history : historyEvents)
        {
            // We start traversing the history backwards, and check for first occurence when the amount was
            // either lower or higher than current amount. If the amount was incremented before marking the opportunity
            // as lost, then there is no need to worry about it. Otherwise, if the amount was lowered right before marking
            // it as lost, we gather all the events in history and line them up in ascending order, and add the date of event. 
            if(history.Amount > opportunity.Amount)
            {
               
                wasLastDecremented = true;
            }
             
            if(history.Amount > opportunity.Amount && wasLastDecremented)
            {
                // This should not be in a bulk operation because we need distinct captions on each attachment.
                // TODO: Implement a way to process triggers in bulk.
                String message = '*' + UserInfo.getName() + ' lowered the amount on opportunity and marked it lost*.\n' + EventLog(historyEvents);
                Map <String, Object> payload = Slack.BuildPayload(message, '', new List <Opportunity> { opportunity });
                System.debug('the payload is'+payload);
                Webhook.TriggerSlackAlert(payload);
            }
        }
    }

    private static String EventLog(List <OpportunityHistory> history)
    {
        System.debug('generating event log');
        
        List <String> amountUpdates = new List <String> ();
        
        Decimal lastAmount = 0;
        
        for(Integer i = history.size() - 1; i >= 0; i--)
        {
            OpportunityHistory event = history.get(i);
            Decimal amount = (Decimal) event.Amount;
            
            // OpportunityHistory is kept in a flat format rather than a list of events, we need to pick up
            // the records where the amount actually changed.
            if(lastAmount == amount) continue;
            
            // Amount can be null in initial lifetime of an opportunity, this won't let us proceed.
            if(amount == null) amount = 0;
            
            amountUpdates.add('$' + amount.setScale(2).format() + ' (on ' + event.CreatedDate.format() + ')');
            
            lastAmount = amount;
        }
        
        return String.join(amountUpdates, '\n');
    }
}