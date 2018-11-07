/*
*This class is used to schedule the BatchAccountSubscriptionAttacher
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchAccountSubscriptionAttacher implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchAccountSubscriptionAttacher  b = new  BatchAccountSubscriptionAttacher (); 
      database.executebatch(b,200);
    }
}