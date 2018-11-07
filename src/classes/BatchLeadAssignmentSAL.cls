global class BatchLeadAssignmentSAL implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<user> userList = new List<user>();
        userList = [select id,name from user where name='Backend Kayako' OR name='Hubspot SFDC' OR name='Rajiv Sharma' OR isActive=false];
        
            
            String stage = 'SAL';
            String status ='Open';
            String source = 'Unknown';
            
        
        String query = 'SELECT id,name,CountryCode,leadSource from lead where ownerId IN: userList and Stage__c=:stage and Status=:status and ConvertedOpportunityId=null and isConverted=false and leadsource!=:source';
        
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
        try{     
             LeadOwnerAssigner.assignLeadOwner(scope);
        }
        catch(UnderflowException leadOwnerNotAssigned){
        
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}