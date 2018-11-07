/*
*This class is used to schedule the BatchLifetimeBilledAmountUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchLifetimeBilledAmountUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchLifetimeBilledAmountUpdater  b = new  BatchLifetimeBilledAmountUpdater (); 
      database.executebatch(b);
    }
}