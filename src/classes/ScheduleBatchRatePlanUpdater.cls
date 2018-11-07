/*
*This class is used to schedule the batch Batch Rate Plan Updater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchRatePlanUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchRatePlanUpdater  b = new  BatchRatePlanUpdater (); 
      database.executebatch(b);
    }
}