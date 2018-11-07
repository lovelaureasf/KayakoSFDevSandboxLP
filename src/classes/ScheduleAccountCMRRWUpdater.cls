/*
*This class is used to schedule the BatchAccountCMRRWUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleAccountCMRRWUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
      BatchAccountCMRRWUpdater  b = new  BatchAccountCMRRWUpdater (); 
      database.executebatch(b);
    }
}