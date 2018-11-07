/* Author : Sagar Pareek
   Description : This batch job checks for the accounts which do not have any payments and mark the account as Payment Due.
*/

global class BatchPaymentDueMarker implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all accounts in chunk of 200.
        
        String query = 'select id,name,type,status__c,(select id,name,Zuora__Status__c from Zuora__Payments__r order by Zuora__EffectiveDate__c desc) from account';
        
        return Database.getQueryLocator(query);  
    }
   
    global void execute(Database.BatchableContext BC, List<Account> scope) { //The execute context performs the main operation that is marking of account status as payment due in case there is no child payment record is found.
        
        List<account>accountList = new List<account>(); // End result will be stored in this list and will be updated at the end of the execution.
        
        Set<Id>accountIds = new Set<id>();  // this will store the account ids that are part of the scope.
      
        Map<String,Integer>mapOfAccountAndSubs = new Map<String,Integer>(); //Map of Account ids with the subscription list.
        
        for(account a : scope){  //collecting account ids from the scope.
            accountIds.add(a.id);
        }
        
        System.debug('The account Ids are'+accountIds);
        
        for(account ac : [select id,name,(select id,name from Zuora__Subscriptions__r where Zuora__Status__c='Active') from account where id IN:accountIds]){ //fetching the list of subscriptions.
            
           if(ac.Zuora__Subscriptions__r.size()!=0 && ac.Zuora__Subscriptions__r.size()>0){ //filling up the map of account id with number of subscriptions. 
           
            mapOfAccountAndSubs.put(ac.id,ac.Zuora__Subscriptions__r.size()); 
                  
          
          }    
        
        }
        
        System.debug('the subscriptions with account'+mapOfAccountAndSubs);
        
        for(account ac : scope){
            if(ac.Zuora__Payments__r.size()==0 && mapOfAccountAndSubs.get(ac.id)>0){  // __r denotes child records of payment, if its null that means there is no payment record.
                ac.status__c='Payment Due';        // mark the account as payment due here.
                System.debug('record to be marked as payment due in normal'+ac);
                accountList.add(ac); 
            }else if (ac.Zuora__Payments__r.size()!=0 && ac.Zuora__Payments__r.size()>0){ // if account have payment records but the recent one is in error state then mark the account as payment due.
                if(ac.Zuora__Payments__r[0].Zuora__Status__c=='Error'){
                    ac.status__c='Payment Due';
                    System.debug('record to be marked as payment due in error'+ac);  
                    accountList.add(ac);
                }
            }else if (ac.Zuora__Payments__r.size()==0 && mapOfAccountAndSubs.get(ac.id)==null){
                  ac.status__c='Prospect';
                  System.debug('record to be marked as prospect'+ac);  
                  accountList.add(ac);
            }    
        }
        update accountList;  //updating the account which had no payment records.
        System.debug('the list that is being updated'+accountList);
        
        
        /*List<account> acc = new List<account>();
        for(account ac : [select id,name,(select id,name from Zuora__Subscriptions__r) from account where Status__c='Active' limit 1000]){ 
            
           if(ac.Zuora__Subscriptions__r.size()==0){ 
           
                               acc.add(ac);
          
          }    
        
        }

        List<account> aList = new List<account>();
        
        for(account a: acc){
            a.Status__c = 'Prospect';
            aList.add(a);
        }
        
        update aList;
        
        */
        
        
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    }
}