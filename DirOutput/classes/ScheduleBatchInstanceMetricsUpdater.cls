/*
*This class is used to schedule the BatchInstanceMetricsUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchInstanceMetricsUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
      BatchInstanceMetricsUpdater  b = new BatchInstanceMetricsUpdater(); 
      database.executebatch(b,1);
    }
}