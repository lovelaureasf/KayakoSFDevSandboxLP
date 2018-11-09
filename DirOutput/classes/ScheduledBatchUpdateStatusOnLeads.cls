/******************************************************************
// Name: ScheduledBatchUpdateStatusOnLeads
// Purpose: This is a schedular which schedules batch to update Trial leads 
// Author: sruti Srivastava
// Date: 27/09/2018 
/******************************************************************/
global class ScheduledBatchUpdateStatusOnLeads implements Schedulable  {
   global void execute(SchedulableContext sc) {
      BatchUpdateStatusOnLeads objBatch = new BatchUpdateStatusOnLeads (); 
      database.executebatch(objBatch , 5);
   }
}