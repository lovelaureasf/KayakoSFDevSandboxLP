/*
*This class is used to schedule the BatchUnresponsiveLeadCleanerJob.
*This is called from Developer console with the cron expression.
*/

global class ScheduleBatchUnresponsiveLeadCleanerJob implements schedulable
{
    global void execute(SchedulableContext sc)
    {
         
         
         BatchUnresponsiveLeadCleanerJob b = new BatchUnresponsiveLeadCleanerJob();
         Database.executebatch(b,20);
          
      
    }
}