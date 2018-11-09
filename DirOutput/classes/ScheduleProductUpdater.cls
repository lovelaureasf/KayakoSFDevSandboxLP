/*
*This class is used to schedule the BatchProductUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleProductUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchProductUpdater  b = new  BatchProductUpdater (); 
      database.executebatch(b);
    }
}