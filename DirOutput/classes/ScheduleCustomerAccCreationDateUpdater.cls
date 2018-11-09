/*
*This class is used to schedule the BatchCustomerAccountCreationDateUpdater.
*This is called from Developer console with the cron expression.
*/

global class ScheduleCustomerAccCreationDateUpdater implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchCustomerAccountCreationDateUpdater  b = new  BatchCustomerAccountCreationDateUpdater (); 
      database.executebatch(b,1);
    }
}