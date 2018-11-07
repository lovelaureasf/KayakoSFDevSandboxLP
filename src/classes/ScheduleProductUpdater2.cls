/*
*This class is used to schedule the BatchProductUpdater2.
*This is called from Developer console with the cron expression.
*/

global class ScheduleProductUpdater2 implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchProductUpdater2  b = new  BatchProductUpdater2 (); 
      database.executebatch(b);
    }
}