global class BatchAccountCMRRWUpdater implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all subscriptions in chunk of 200.
        
        String query = 'select id,name,Status__c,CMRRWithDiscount__c,(select id,CMRRWithDiscount__c,Zuora__Status__c from Zuora__Subscriptions__r) from Account';
        System.debug('in locator');
        return Database.getQueryLocator(query);  
    }
    
    
    global void execute(Database.BatchableContext BC, List<Account> scope) { 
        List<Account>accList = new List<Account>();
        
        for(Account a: scope){
            Decimal oldCmrrwd = a.CMRRWithDiscount__c;
        if(a.Status__c =='Active' ||a.Status__c=='Payment Due'){
            Decimal cmrrwd = 0;
            for(Zuora__Subscription__c s: a.Zuora__Subscriptions__r){
              if(s.CMRRWithDiscount__c!=null && s.Zuora__Status__c=='Active'){
                    cmrrwd = cmrrwd+s.CMRRWithDiscount__c;
                }    
            }
            
            a.CMRRWithDiscount__c = cmrrwd;
            
            if(oldCmrrwd!=cmrrwd){
                accList.add(a);
            }
                
        }else if(a.Status__c =='Cancelled'){
                Decimal cmrrwd = 0;
                for(Zuora__Subscription__c s: a.Zuora__Subscriptions__r){
              if(s.CMRRWithDiscount__c!=null && s.Zuora__Status__c=='Cancelled'){
                    cmrrwd = cmrrwd+s.CMRRWithDiscount__c;
                }    
            }
            
            a.CMRRWithDiscount__c = cmrrwd;
           
           
           if(cmrrwd!=oldcmrrwd){    
            accList.add(a); 
           } 
        }            
        
        }
        
        update accList;
    }        
        
    global void finish(Database.BatchableContext BC) {
    
    }
        
    
}