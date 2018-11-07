/*
Description: This controller works with list view button Reject SAL-Open Lead.
This controller will be used to reject the SAL Open leads.
*/


public with sharing class SALLeadRejection {
    
    public List<Lead> selectedLeads {get;set;}
    public List<Lead> rejectLeads {get;set;}
    public List<Lead>  nonRejectLeads {get;set;}
    public List<Lead> rejectionLeads {get;set;}
    
    public SALLeadRejection(ApexPages.StandardSetController controller) {
        selectedLeads = [select id,name,stage__c,status from lead where id IN: controller.getSelected()];
        rejectLeads = new List<Lead>();
        nonrejectLeads  = new List<Lead>();
        rejectionLeads = new List<lead>();
        for(Lead l : selectedLeads){
            if(l.Stage__c=='SAL' && l.Status=='Open'){
                rejectLeads.add(l);
                
            }else{
                nonRejectLeads.add(l);
            }
            
            
        }
    }
    
    public pageReference proceed(){
        if(rejectLeads.size()>0 && rejectLeads!=null){
            for(lead l:rejectLeads){
                l.stage__c = 'SRL';
                l.Status ='Nurture';
                l.StatusToNurtureDate__c = date.today();
                l.StageToSRLDate__c = date.today();
                l.StageLastUpdatedDate__c = Date.today();
                l.StatusLastUpdatedDate__c = Date.today();
                rejectionLeads.add(l);
                
            }
            update rejectionLeads;
        }
        pageReference pg = new pageReference('/'+ApexPages.currentPage().getParameters().get('retURL'));
        pg.setRedirect(true);
        return pg;
    }
    
}