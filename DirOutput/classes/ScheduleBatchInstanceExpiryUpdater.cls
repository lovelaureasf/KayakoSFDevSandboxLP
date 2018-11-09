/*
*This class is used to schedule the BatchInstanceExpiryUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchInstanceExpiryUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
      BatchInstanceExpiryUpdater  b = new  BatchInstanceExpiryUpdater (); 
      database.executebatch(b,1);
    }
}