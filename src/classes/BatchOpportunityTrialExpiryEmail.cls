/*
Created By: Sagar Pareek
Description: This class sends out the opportunity trial expiry emails to the users.
*/

global class BatchOpportunityTrialExpiryEmail implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'select id from opportunity where ExpiryEmailSent__c=false AND KA_ExpiryDate__c=TODAY AND isClosed=false limit 10'; //string to collect the expired trials.
        
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
        
        List<id>oppList = new List<id>(); //converting the scope list (object list) into list of ids.
        for(Opportunity o: scope){
            OppList.add(o.id);
            System.debug('opp trial , opp id is'+o.id);
        }
        
        EmailUtilLeadTrialExpiry.mailSender(OppList);
        
        List<Opportunity>oList = new List<opportunity>();
        for(opportunity o:[select id,ExpiryEmailSent__c from opportunity where id IN:opplist]){
            o.ExpiryEmailSent__c=true;
            oList.add(o);
        }
        
        update oList;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
    
    }