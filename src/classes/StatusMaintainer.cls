public class StatusMaintainer{


        public Set<String>AccountIds = new Set<String>(); //Set that will hold all the accountids.
        public Map<String,List<Zuora__Subscription__c>>MapOfAccountIdsWithSubscriptionList = new Map<String,List<Zuora__Subscription__c>>();
        public List<Account>accountsToUpdate = new List<Account>();
        public List<Account>activeAccounts = new List<Account>();
        public Set<Account>DueAccountSet = new Set<Account>(); //account set to avoid duplicates.
        public Set<Account>NonDueAccountSet = new Set<Account>(); //account set to avoid duplicates.
        
        
   public void updater(List<Account> accList){        
        for(Account a:accList){
            AccountIds.add(a.id);
        }
        
        for(Account a:[select id,name,(select id,name,Zuora__Status__c from Zuora__Subscriptions__r) from account where Id IN:accountIds]){ //looking for all the subscriptions related to an account
            
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
              accountsToUpdate.add(a);
          
          }  
        
        }
        System.debug('the first list'+accountsToUpdate);
        
        for(Account a:[select id,name from account where id IN:MapOfAccountIdsWithSubscriptionList.keySet()]){
            
            Integer totalSubs = MapOfAccountIdsWithSubscriptionList.get(a.id).size();
            Integer totalActive = 0;
            Integer totalCancelled =0;
            System.debug('the account we are working on'+a.id);
            System.debug('the number of subscriptions we have corresponding to this account are'+totalSubs);
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
                accountsToUpdate.add(a);
                System.debug('adding as cancelled'+a);
            }
        
        }
         System.debug('the second list'+accountsToUpdate);
        
        
        for(Zuora__ZInvoice__c zi:[select id,name,Zuora__Account__c,Zuora__PaymentAmount__c,Zuora__Account__r.id,(select id,name,Zuora__Payment__c,Zuora__Payment__r.Zuora__EffectiveDate__c,Zuora__Payment__r.Zuora__Status__c from Zuora__PaymentInvoices__r order by Zuora__Payment__r.Zuora__EffectiveDate__c desc) from Zuora__ZInvoice__c where Zuora__Account__r.id IN:activeAccounts]){
            if(zi.Zuora__PaymentAmount__c!=0){ // for non zero take actions for zero value invoice no action.
                if(zi.Zuora__Payments__r!=null && zi.Zuora__PaymentInvoices__r.size()!=0){
                    if(zi.Zuora__PaymentInvoices__r[0].Zuora__Payment__r.Zuora__Status__c=='Error'){
                        account a = new account();
                        a.id = zi.Zuora__Account__r.id;
                        a.Status__c = 'Payment Due';
                        
                            DueAccountSet.add(a);
                        
                        System.debug('adding to due'+a);
                        
                    }else if(zi.Zuora__PaymentInvoices__r[0].Zuora__Payment__r.Zuora__Status__c=='Processed'){
                        account a = new account();
                        a.id = zi.Zuora__Account__r.id;
                        a.Status__c = 'Active';
                        if(!DueAccountSet.contains(a)){
                            NonDueAccountSet.add(a);
                        }
                        System.debug('adding to non'+a);
                    }
                }else{
                    account a = new account();
                    a.id = zi.Zuora__Account__r.id;
                    a.Status__c = 'Payment Due';
                    DueAccountSet.add(a);
                    System.debug('adding to due 2nd one'+a);
                }
            }
        }
        
        
        for(Account a: [select id,name,Status__c from account where id IN:DueAccountSet]){
               
            a.Status__c = 'Payment Due';
            System.debug('adding to final due'+a);
            accountsToUpdate.add(a);
         
        
        }
        System.debug('the third list'+accountsToUpdate);
        
        for(Account a: [select id,name,Status__c from account where id IN:NonDueAccountSet AND id NOT IN:DueAccountSet]){
            
            a.Status__c = 'Active';
            System.debug('adding to final active'+a);
            accountsToUpdate.add(a);
           
        
        }
        System.debug('the 4th list'+accountsToUpdate);
        
        
        for(account a:accountstoupdate){
            System.debug('the list to be updated'+a);
        }
        
        update accountsToUpdate;



}
}