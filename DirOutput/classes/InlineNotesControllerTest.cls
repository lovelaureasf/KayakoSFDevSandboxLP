@isTest
public with sharing class InlineNotesControllerTest {
	    
	public static testMethod void positiveScenario(){	    
	    
	    List<Note>notesList = new List<Note>();
	    
	    SObject lead = ObjectMocker.mock('Lead');
        lead.put('Email', 'mail@example.com');
        lead.put('Stage__c','Qualified');
        insert lead;
        
        Note n1 = new Note();
        n1.parentId = lead.id;
        n1.body = 'test note 1';
        n1.title = 'test note1';
        insert n1;
        
        notesList.add(n1);
        
        Note n2 = new Note();
        n2.parentId = lead.id;
        n2.body = 'test note 2';
        n2.title = 'test note2';
        insert n2;
         
         notesList.add(n2);
         
         
       
         ApexPages.StandardController sc = new ApexPages.StandardController(lead);
         InlineNotesController inc  = new InlineNotesController(sc);
         PageReference pr = Page.InlineNotesOnLead;
         pr.getParameters().put('id',lead.id);
         Test.setCurrentPage(pr);
         
         
         
	}   
}