/*
*This class is used to schedule the  BatchSubscriptionCMRRWUpdater
*This is called from Developer console with the cron expression.
*/

global class ScheduleSubscriptionCMRRWUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     
      BatchSubscriptionCMRRWUpdater b = new  BatchSubscriptionCMRRWUpdater(); 
      database.executebatch(b);
    }
}