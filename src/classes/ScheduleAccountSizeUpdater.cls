/*
*This class is used to schedule the BatchAccountSizeUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleAccountSizeUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchAccountSizeUpdater  b = new  BatchAccountSizeUpdater (); 
      database.executebatch(b);
    }
}