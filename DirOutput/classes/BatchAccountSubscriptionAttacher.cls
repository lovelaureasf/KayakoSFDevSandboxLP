/* Author : Sagar Pareek
   Description: This trigger attaches the lastest subscription to the account. 
*/

global class BatchAccountSubscriptionAttacher implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all accounts in chunk of 200.
        
        String query = 'select id,name,subscription__c,( select id,name,Zuora__Status__c from Zuora__Subscriptions__r where InstanceID__c != null AND InstanceID__c   != \'0\' order by Zuora__SubscriptionStartDate__c DESC  ) from account';
        
        return Database.getQueryLocator(query);  
    }
   
    global void execute(Database.BatchableContext BC, List<Account> scope) { 
           
           Set<String>accountIds = new Set<String>();
           
           Map<String,List<Zuora__Subscription__c>>mapOfAccountAndListOfActiveSubscriptions = new Map<String,List<Zuora__Subscription__c>>();
           
           Map<String,List<Zuora__Subscription__c>>mapOfAccountAndListOfCancelledSubscriptions = new Map<String,List<Zuora__Subscription__c>>();

            for(account ac : scope){ //fetching the list of subscriptions.
            
               if(ac.Zuora__Subscriptions__r.size()!=0 && ac.Zuora__Subscriptions__r.size()>0){ //filling up the map of account id with number of subscriptions. 
                  for(Zuora__Subscription__c zs: ac.Zuora__Subscriptions__r){
                      if(zs.Zuora__Status__c == 'Active'){
                          if(mapOfAccountAndListOfActiveSubscriptions.keySet().contains(ac.id)){
                              mapOfAccountAndListOfActiveSubscriptions.get(ac.id).add(zs);
                          }else{
                              mapOfAccountAndListOfActiveSubscriptions.put(ac.id,new List<Zuora__Subscription__c>{zs});
                          }
                      }else if (zs.Zuora__Status__c == 'Cancelled'){
                          if(mapOfAccountAndListOfCancelledSubscriptions.keySet().contains(ac.id)){
                              mapOfAccountAndListOfCancelledSubscriptions.get(ac.id).add(zs);
                          }else{
                              mapOfAccountAndListOfCancelledSubscriptions.put(ac.id,new List<Zuora__Subscription__c>{zs});
                          }
                      }
                  }
               }
               accountIds.add(ac.id);
            }
            
            
            List<account>aList = new List<account>();
        
            for(Account a:[select id,Status__c,Subscription__c from account where id IN: accountIds]){
                
                                    
                  if(mapOfAccountAndListOfActiveSubscriptions.KeySet().contains(a.id)){
                        a.Subscription__c = mapOfAccountAndListOfActiveSubscriptions.get(a.id)[0].id;
                        aList.add(a);
                  } 
                   
                   
                    else if (mapOfAccountAndListOfCancelledSubscriptions.KeySet().contains(a.id)){
                   
                        a.Subscription__c = mapOfAccountAndListOfCancelledSubscriptions.get(a.id)[0].id;
                        aList.add(a);
                    
                }    
                
                
                
            

            
        
        
    }
      update aList;
  }      
       
    
    global void finish(Database.BatchableContext BC) {
    
    }


}