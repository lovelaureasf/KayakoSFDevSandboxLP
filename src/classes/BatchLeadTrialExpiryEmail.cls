global class BatchLeadTrialExpiryEmail implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        
        
        String query = 'select id from Instance__c where Expiry_Date__c=TODAY limit 10 '; //string to collect the expired trials.
        
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Instance__c> scope) {
        
        List<id>leadList = new List<id>(); //converting the scope list (object list) into list of ids.
        for(Lead l: [select id,name,Instance__c,ExpiryEmailSent__c,isconverted,KA_Product__c from lead where ExpiryEmailSent__c=false and isConverted=false and Instance__c IN:scope]){
            leadList.add(l.id);
        }
        
        EmailUtilLeadTrialExpiry.mailSender(leadList);
        
        List<lead>lList = new List<lead>();
        for(lead l :[select id,ExpiryEmailSent__c from lead where id IN:leadList]){
            l.ExpiryEmailSent__c=true;
            l.SLA_Breached__c = true;
            lList.add(l);
        }
        update lList;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}