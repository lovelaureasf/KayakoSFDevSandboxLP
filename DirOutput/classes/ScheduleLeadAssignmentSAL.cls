/*
*This class is used to schedule the batch lead assignment at SAL stage.
*This is called from Developer console with the cron expression.
*/

global class ScheduleLeadAssignmentSAL implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchLeadAssignmentSAL  b = new  BatchLeadAssignmentSAL (); 
      database.executebatch(b,1);
    }
}