/*
*This class is used to schedule the BatchSubscriptionVersionDateUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleSubscriptionVersionDateUpdater  implements schedulable
{
	


    global void execute(SchedulableContext sc)
    {
     BatchSubscriptionVersionDateUpdater  b = new  BatchSubscriptionVersionDateUpdater (); 
     database.executebatch(b,50);
    }
    
}