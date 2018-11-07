/*
*This class is used to schedule the batch trial expiry emails.
*
*/

global class ScheduleLeadTrialExpiryEmails implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchLeadTrialExpiryEmail  b = new  BatchLeadTrialExpiryEmail (); 
      database.executebatch(b);
    }
}