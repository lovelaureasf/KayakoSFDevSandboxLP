/*
*This class is used to schedule the batch payment due marker.
*This is called from Developer console with the cron expression.
*/

global class SchedulePaymentDueMarker implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchPaymentDueMarker  b = new  BatchPaymentDueMarker (); 
      database.executebatch(b);
    }
}