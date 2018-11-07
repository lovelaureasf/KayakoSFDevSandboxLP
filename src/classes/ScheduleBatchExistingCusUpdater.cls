/*
*This class is used to schedule the BatchExistingCustomerUpdater
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchExistingCusUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchExistingCustomerUpdater  b = new  BatchExistingCustomerUpdater (); 
      database.executebatch(b,500);
    }
}