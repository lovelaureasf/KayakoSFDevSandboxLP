/* Author : Sagar Pareek
   Description : This batch collects the accounts in chunk of 200 and decides the status of account.
*/

global class BatchAccountStatusMaintainer implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all accounts in chunk of 200.
        
        String query = 'select id,name from account';
        
        return Database.getQueryLocator(query);  
    }
   
    global void execute(Database.BatchableContext BC, List<Account> scope) { //The execute context performs the main operation that is marking of account status as payment due in case there is no child payment record is found under an invoice.
        
         Set<String>AccountIds = new Set<String>(); //Set that will hold all the accountids.
         Map<String,List<Zuora__Subscription__c>>MapOfAccountIdsWithSubscriptionList = new Map<String,List<Zuora__Subscription__c>>();
         List<Account>accountsToUpdate = new List<Account>();
         List<Account>activeAccounts = new List<Account>();
         Set<Account>DueAccountSet = new Set<Account>(); //account set to avoid duplicates.
         Set<Account>NonDueAccountSet = new Set<Account>(); //account set to avoid duplicates.  
         Map<String,List<Zuora__ZInvoice__c>>MapOfAccountIdAndListOfInvs = new  Map<String,List<Zuora__ZInvoice__c>>(); // map of account with list of its related subscriptions.
         
         List<String>updatetheAccounts = new List<String>();
          for(Account a:scope){
            AccountIds.add(a.id);
         }
         
         
        
        for(Account a:[select id,name,Status__c,(select id,name,Zuora__Status__c from Zuora__Subscriptions__r) from account where Id IN:accountIds]){ //looking for all the subscriptions related to an account
          String oldStatus = a.Status__c;
          if(a.Zuora__Subscriptions__r!=null && a.Zuora__Subscriptions__r.size()!=0){  // checking the size of list of subscriptions, if the account is found to have no subscription then mark it as prospect.
            for(Zuora__Subscription__c z: a.Zuora__Subscriptions__r){
                if(MapOfAccountIdsWithSubscriptionList.keySet().contains(a.id)){
                    MapOfAccountIdsWithSubscriptionList.get(a.id).add(z);
                }else{
                    MapOfAccountIdsWithSubscriptionList.put(a.id,new List<Zuora__Subscription__c>{z});
                }
            }
          }else{
              
              a.Status__c = 'Prospect';
              System.debug('adding as prospect'+a);
              if(a.Status__c!=oldStatus){
              accountsToUpdate.add(a);
              }
          }  
        
        }
        
        
        System.debug('the first list'+accountsToUpdate);
        
        for(Account a:[select id,name,Status__c from account where id IN:MapOfAccountIdsWithSubscriptionList.keySet()]){
            String oldStatus = a.Status__c;
            Integer totalSubs = MapOfAccountIdsWithSubscriptionList.get(a.id).size();
            Integer totalActive = 0;
            Integer totalCancelled =0;
            
            for(Zuora__Subscription__c zs:MapOfAccountIdsWithSubscriptionList.get(a.id)){
                
                if(zs.Zuora__Status__c == 'Active'){
                    totalActive = totalActive+1;
                }else if(zs.Zuora__Status__c == 'Cancelled'){
                    totalCancelled = totalCancelled+1;
                }
                
            }
            if(totalSubs != totalCancelled){
                activeAccounts.add(a);
                System.debug('adding to active'+a);
            }else{
                a.Status__c = 'Cancelled';
                if(a.Status__c!=oldStatus){
                accountsToUpdate.add(a);
                }
            }
            
            
        }
         System.debug('the second list'+accountsToUpdate);
         
       
            for(Zuora__ZInvoice__c zi:[select id,name,Zuora__Account__c,Zuora__PaymentAmount__c,Zuora__Account__r.id from Zuora__ZInvoice__c where Zuora__Account__r.id IN:activeAccounts]){
                if(MapOfAccountIdAndListOfInvs.keySet().contains(zi.Zuora__Account__r.id)){
                        MapOfAccountIdAndListOfInvs.get(zi.Zuora__Account__r.id).add(zi);
                    }else{
                        MapOfAccountIdAndListOfInvs.put(zi.Zuora__Account__r.id,new List<Zuora__ZInvoice__c>{zi});
                    }
            } 
        
        
        
        for(account ac:[select id,name,Status__c from account where id IN:activeAccounts]){
        
         
        
        for(Zuora__ZInvoice__c zi:[select id,name,Zuora__Account__c,Zuora__PaymentAmount__c,Zuora__Account__r.id,Zuora__Balance2__c,(select id,name,Zuora__Payment__c,Zuora__Payment__r.Zuora__EffectiveDate__c,Zuora__Payment__r.Zuora__Status__c from Zuora__PaymentInvoices__r order by Zuora__Payment__r.Zuora__CreatedDate__c desc) from Zuora__ZInvoice__c where Zuora__Account__r.id =:ac.id]){
          
              if(zi.Zuora__Balance2__c<=0){
                        account a = new account();
                        a.id = zi.Zuora__Account__r.id;
                        a.Status__c = 'Active'; //active
                        if(!DueAccountSet.contains(a)){
                            NonDueAccountSet.add(a);
                        }
              
              }else {   
                        account a = new account();
                        a.id = zi.Zuora__Account__r.id;
                        a.Status__c = 'Payment Due';
                        DueAccountSet.add(a);
                            
                    }
              
                
                
        }
        
        
               // in case of no invoice
              if(MapOfAccountIdAndListOfInvs.containsKey(ac.id)){
                    if(MapOfAccountIdAndListOfInvs.get(ac.id).size()==0){
                         
                         // incase of no invoice, we set account to active
                            account a = new account();
                            a.id = ac.id;
                            a.Status__c = 'Active'; //active
                            if(!DueAccountSet.contains(a)){
                                NonDueAccountSet.add(a);
                            }
                     }
               }else{    
                       // incase of no invoice, we set account to active
                            account a = new account();
                            a.id = ac.id;
                            a.Status__c = 'Active'; //active
                            if(!DueAccountSet.contains(a)){
                                NonDueAccountSet.add(a);
                            }
                       
                    
                }   
        
       } 
        
       
        for(Account a: [select id,name,Status__c from account where id IN:DueAccountSet]){
            String oldStatus = a.Status__c;   
            a.Status__c = 'Payment Due';
            
            if(a.Status__c!=oldStatus){
                accountsToUpdate.add(a);
            }
        
        }
        System.debug('the third list'+accountsToUpdate);
        
        for(Account a: [select id,name,Status__c from account where id IN:NonDueAccountSet AND id NOT IN:DueAccountSet]){
            String oldStatus = a.Status__c;
            a.Status__c = 'Active';
            if(a.Status__c!=oldStatus){
                accountsToUpdate.add(a);
            }
        
        }
        
        
        
        
        
        update accountsToUpdate;

        
        
    } 
        
    
    global void finish(Database.BatchableContext BC) {
        
    
    }
}