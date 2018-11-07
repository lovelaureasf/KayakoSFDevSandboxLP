global without sharing class BatchUnresponsiveLeadCleanerJob implements Database.Batchable<sObject>
{
     global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all leads with unresponsive date.
        
        String query = 'select id,name,Status,Stage__c,StageToSRLDate__c,StatusToNurtureDate__c,StatusLastUpdatedDate__c,StatusToUnresponsiveDate__c  from lead where  isConverted=false AND Status=\'Unresponsive\' ';
        
        return Database.getQueryLocator(query);  
    }
    
     global void execute(Database.BatchableContext BC, List<Lead> scope){
        List<Lead>unresponsiveLeads = new List<Lead>();
        for(Lead l : scope){
        
            if(l.StatusToUnresponsiveDate__c.daysBetween(Date.Today())>=30){    
            
            l.Status = LeadStatus.NURTURE;
            l.Stage__c = LeadStage.SRL;
            l.StageToSRLDate__c = Date.today();
            l.StatusToNurtureDate__c = Date.today();
            l.StatusLastUpdatedDate__c = Date.today();
            unresponsiveLeads.add(l);
            
            }
        
        }
        
        update unresponsiveLeads;
    }
    
     global void finish(Database.BatchableContext BC) {
    
    }
}