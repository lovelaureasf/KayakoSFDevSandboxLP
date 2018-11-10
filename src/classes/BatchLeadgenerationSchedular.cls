global class BatchLeadgenerationSchedular implements Schedulable {
  global void execute(SchedulableContext SC) {
     
      database.executeBatch(new BatchLeadGeneration());
   }
}