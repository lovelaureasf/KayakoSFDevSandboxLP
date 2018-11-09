/*
*This class is used to schedule the BatchSubscriptionInstanceUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchSubscriptionInstanceUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchSubscriptionInstanceUpdater  b = new  BatchSubscriptionInstanceUpdater (); 
      database.executebatch(b);
    }
}