/*
    This is a batch class that will update the Size field on Account Object based upon the related Subscription's Seats field.
*/

global class BatchAccountSizeUpdater implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //main query that defines the scope of the batch
        String query = 'select id,name from account';
        
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<account> scope) {
             
             List<String>accIds = new List<String>();
             Map<String,List<Zuora__Subscription__c>>AccountWithSubs = new Map<String,List<Zuora__Subscription__c>>(); // map of the Account id with list of Subs
            
             for(account a: scope){
                 accIds.add(a.id);
             }    
                 
            for(Zuora__Subscription__c s: [select id,name,Seats__c,Zuora__Account__c,Zuora__Status__c from Zuora__Subscription__c where Seats__c!=null and Zuora__Account__r.id IN:accIds]) {    
                 if(AccountWithSubs.containsKey(s.Zuora__Account__c)){ // putting values in the map defined above.
                     
                     AccountWithSubs.get(s.Zuora__Account__c).add(s);
                 
                 }else{
                     
                     AccountWithSubs.put(s.Zuora__Account__c,new List<Zuora__Subscription__c>{s});
                 }    
             }
             
             
             List<Account>accList = new List<Account>(); // List of account which will be updated at the end of this batch.
             
             for(account acc: [select id,name,Seats__c,Size__c from account where id IN:AccountWithSubs.keySet()]){ //iterate over the list of accounts then Subs list and then sum up the number of seats.
                 Decimal count = 0; // intialize count with 0
                 String oldsize = acc.Size__c;
                 Decimal oldSeats = acc.Seats__c;
                 for(Zuora__Subscription__c spc: AccountWithSubs.get(acc.id)){
                     if(spc.Zuora__Status__c == 'Active' ){    
                         count = count+spc.Seats__c;   //add the values.         
                     }
                     else {
                      count = count+0;
                     }
                 }    
                 if(count>=0 && count<=10){ // check the count level.
                     acc.Size__c = 'Small';   
                 }else if (count>10 && count<=50){
                     acc.Size__c = 'Medium';  
                 }else{
                     acc.Size__c ='Large';
                 }
                 
                 acc.Seats__c =count; // put the count in the seats field.
                 
                 
                if(oldsize!=acc.Size__c || oldSeats!=acc.Seats__c){ 
                 accList.add(acc);    //adding accounts into the update list 
                }     
             
             }
             
             update accList; // updating the list of accounts. 
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}