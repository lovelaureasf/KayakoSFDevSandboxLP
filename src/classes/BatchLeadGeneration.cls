///public class BatchLeadGeneration {

//Batch to generate test lead into Sandbox every 15 mi
global class BatchLeadGeneration implements Database.Batchable<sObject>{
  
   global Iterable<sObject> start(Database.BatchableContext info){ 
       String query = 'SELECT Id,Name FROM Lead limit 1';

		return Database.getQueryLocator(query); 
   }     
   global void execute(Database.BatchableContext info, List<sObject> scope){
       FutureBatchClass.insertLead();
		// Creating some test leads
      
   }     
   global void finish(Database.BatchableContext info){     
   } 
}