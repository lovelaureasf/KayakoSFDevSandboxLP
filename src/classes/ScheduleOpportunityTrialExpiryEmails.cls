/*
*This class is used to schedule the batch trial expiry emails.
*
*/

global class ScheduleOpportunityTrialExpiryEmails implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchOpportunityTrialExpiryEmail  b = new  BatchOpportunityTrialExpiryEmail (); 
      database.executebatch(b);
    }
}