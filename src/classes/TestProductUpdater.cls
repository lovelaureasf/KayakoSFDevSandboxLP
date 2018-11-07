@isTest
public class TestProductUpdater {
    public static testMethod void positiveScenario(){
        	Instance__c i = new Instance__c();
        	i.name = 'test.kayako.com';
            i.State__c = 'trial';
            insert i;
        
        	lead l = new lead ();
            l.lastname = 'test';
            l.Company = 'test';
            l.Email = 'sagar@sagar.com';
            l.Instance__c = i.id;
            insert l;
        
            opportunity o = new opportunity();
            o.name = 'sagar';
            o.Instance__c = i.id;
            o.CloseDate = date.today();
            o.StageName = ' value proposition';
            insert o;
        
        
            opportunity o2 = new opportunity();
            o2.name = 'sagar';
            o2.Instance__c = i.id;
            o2.CloseDate = date.today();
            o2.StageName = 'New Business';
            insert o2;
        
           PageReference VFPage = Page.productupdater;
   	       Test.setCurrentPageReference(VFPage);
           VFPage.getParameters().put('rec', o.id);
           VFPage.getParameters().put('Id', i.id);
           ProductUpdater pu = New ProductUpdater();
           pu.updateOpp();
           pu.cancel();
        
           PageReference VFPage2 = Page.productupdater;
   	       Test.setCurrentPageReference(VFPage2);
           VFPage2.getParameters().put('rec', l.id);
           VFPage.getParameters().put('Id', i.id);
           ProductUpdater pu2 = New ProductUpdater();
           pu2.updateLead();
        
           PageReference VFPage3 = Page.productupdater;
   	       Test.setCurrentPageReference(VFPage3);
           VFPage3.getParameters().put('rec', o2.id);
           VFPage3.getParameters().put('Id', i.id);
           ProductUpdater pu3 = New ProductUpdater();
           pu3.updateOpp();
           pu3.cancel();
           
           
    }
}