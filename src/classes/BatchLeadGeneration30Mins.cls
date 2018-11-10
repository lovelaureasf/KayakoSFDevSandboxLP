global class BatchLeadGeneration30Mins implements Database.Batchable<sObject>{
  
   global Iterable<sObject> start(Database.BatchableContext info){ 
      String query = 'SELECT Id,Name FROM Lead limit 1';

		return Database.getQueryLocator(query); 
   }     
   global void execute(Database.BatchableContext info, List<sObject> scope){
		// Creating some test leads
       List<lead> lList = new List<lead>();
       
           lead l = new lead();
            l.lastname='Lead ' + string.valueOf(Datetime.now().getTime());
            l.email= string.valueOf(Datetime.now().getTime()) +'test30mins@test.com';
            l.country='Canada';
            l.company='abc';
            l.leadsource = 'Webinar';
            lList.add(l);
            lead l2 = new lead();
             l2.lastname='Lead testing 1' + string.valueOf(Datetime.now().getTime());
            l2.email= string.valueOf(Datetime.now().getTime()) +'1test@test.com';
            l2.country='Canada';
            l2.company='abc';
            l2.leadsource = 'Demo Request';
       lList.add(l2);    
       insert lList;
   }     
   global void finish(Database.BatchableContext info){     
   } 
}