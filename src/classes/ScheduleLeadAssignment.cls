/*
*This class is used to schedule the batch lead assignment.
*This is called from Developer console with the cron expression.

****************************************************************
Modification Log
Author     Date Modified    Purpose
Manoj S    21-09-2018       For Fixing Too Many SQOL Statements.
*/
global class ScheduleLeadAssignment implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     BatchLeadAssignment  b = new  BatchLeadAssignment (); 
      database.executebatch(b, 50); // updated the scope from 100 to 50 for KAYAKOSF-238
    }
}