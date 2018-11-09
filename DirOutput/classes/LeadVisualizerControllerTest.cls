@isTest(SeeAllData = true)
public class LeadVisualizerControllerTest{

static testmethod void mqlTestLead(){
    
    String leadid;
    
    for(leadHistory lh :[select leadid,field,newvalue,oldvalue from leadhistory where id='017100000Iu61RkAQI' ]){
        if(lh.field=='Stage__c'  && lh.newvalue=='MQL'){
            leadid=lh.leadid;
        }
    }
    
    if(leadid!=null){
        List<lead> lList =[select id,Stage__c,Rejected__c,Status,DaysInMQL__c,DaysInSAL__c,DaysInSQL__c,DaysInSRL__c,DaysInSDL__c,ConvertedOpportunityId from lead where Stage__c='MQL'AND id=:leadid limit 1];
        Lead l;    
            if(lList.size()>0 &&lList!=null){
            l=lList[0];
        
        
            PageReference pg = Page.leadvisualizer;
            pg.getParameters().put('id',l.id);
            Test.setCurrentPage(pg);
            
        
            ApexPages.StandardController sc = new ApexPages.StandardController(l);
            LeadVisualizerController lvc = new LeadVisualizerController(sc);
            lvc.ownerOfMQL = 'test';
            lvc.ownerOfSAL = 'test';
            lvc.ownerOfSQL = 'test';
        
        } 
    }
}

static testmethod void salTestLead(){
    
     String leadid;
    
     for(leadHistory lh :[select leadid,field,newvalue,oldvalue from leadhistory where id='017100000Jxvl6AAQQ']){
        if(lh.field=='Stage__c' && lh.oldvalue=='MQL' && lh.newvalue=='SAL'){
            leadid=lh.leadid;
        }
    }

    
    
    if(leadid!=null){
        
        List<lead> lList = [select id,Stage__c,Rejected__c,Status,DaysInMQL__c,DaysInSAL__c,DaysInSQL__c,DaysInSRL__c,DaysInSDL__c,ConvertedOpportunityId from lead where Stage__c='SAL' AND id=:leadid limit 1];
        Lead l;    
            if(lList.size()>0 &&lList!=null){
                l=lList[0];
                PageReference pg = Page.leadvisualizer;
                pg.getParameters().put('id',l.id);
                Test.setCurrentPage(pg);
                
                ApexPages.StandardController sc = new ApexPages.StandardController(l);
                LeadVisualizerController lvc = new LeadVisualizerController(sc);
            }
    }

}

static testmethod void sqlTestLead(){
    
    String leadid;    
     
     for(leadHistory lh :[select leadid,field,newvalue,oldvalue from leadhistory where id='017100000JwB94XAQS']){
        if(lh.field=='Stage__c' && lh.oldvalue=='SAL' && lh.newvalue=='SQL'){
            leadid=lh.leadid;
        }
    }


    if(leadid!=null){
        List<lead> lList = [select id,Stage__c,Rejected__c,Status,DaysInMQL__c,DaysInSAL__c,DaysInSQL__c,DaysInSRL__c,DaysInSDL__c,ConvertedOpportunityId from lead where Stage__c='SQL' AND id=:leadid limit 1];
        Lead l;    
            if(lList.size()>0 &&lList!=null){
                l=lList[0];
        
                PageReference pg = Page.leadvisualizer;
                pg.getParameters().put('id',l.id);
                Test.setCurrentPage(pg);
    
                ApexPages.StandardController sc = new ApexPages.StandardController(l);
                LeadVisualizerController lvc = new LeadVisualizerController(sc);
            }
    }

    }

static testmethod void mqlToSrlTestLead(){
    
    String leadid;    
     
     for(leadHistory lh :[select leadid,field,newvalue,oldvalue from leadhistory where id='017100000Iu5AvKAQU']){
        if(lh.field=='Stage__c' && lh.oldvalue=='MQL' && lh.newvalue=='SRL'){
            leadid=lh.leadid;
        }
    }
    
    if(leadId!=null){
        List<lead> lList = [select id,Stage__c,Rejected__c,Status,DaysInMQL__c,DaysInSAL__c,DaysInSQL__c,DaysInSRL__c,DaysInSDL__c,ConvertedOpportunityId from lead where Stage__c='SRL' AND id=:leadid limit 1];
        Lead l;    
            if(lList.size()>0 &&lList!=null){
                l=lList[0];
                PageReference pg = Page.leadvisualizer;
                pg.getParameters().put('id',l.id);
                Test.setCurrentPage(pg);
    
                ApexPages.StandardController sc = new ApexPages.StandardController(l);
                LeadVisualizerController lvc = new LeadVisualizerController(sc);
            }    
    }

}

static testmethod void salToSrlTestLead(){
    
    String leadid;    
     
     for(leadHistory lh :[select leadid,field,newvalue,oldvalue from leadhistory where id='017100000JwARZMAQ4']){
        if(lh.field=='Stage__c' && lh.oldvalue=='SAL' && lh.newvalue=='SRL'){
            leadid=lh.leadid;
        }
    }
    
    if(leadId!=null){
        List<lead> lList = [select id,Stage__c,Rejected__c,Status,DaysInMQL__c,DaysInSAL__c,DaysInSQL__c,DaysInSRL__c,DaysInSDL__c,ConvertedOpportunityId from lead where Stage__c='SRL' AND id=:leadid limit 1];
        Lead l;  
        if(lList.size()>0 &&lList!=null){
                l=lList[0];
                PageReference pg = Page.leadvisualizer;
                pg.getParameters().put('id',l.id);
                Test.setCurrentPage(pg);
                ApexPages.StandardController sc = new ApexPages.StandardController(l);
                LeadVisualizerController lvc = new LeadVisualizerController(sc);
       } 
    }

}

}