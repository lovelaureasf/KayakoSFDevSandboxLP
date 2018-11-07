/*
*This class is used to schedule the BatchAccountStatusMaintainer.
*This is called from Developer console with the cron expression.
*/

global class ScheduleAccountStatusMaintainer implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchAccountStatusMaintainer  b = new  BatchAccountStatusMaintainer (); 
      database.executebatch(b);
    }
}