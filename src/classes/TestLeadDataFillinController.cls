@isTest(SeeAllData = false)
public class TestLeadDataFillinController{
    
    public static testMethod void positiveScenario(){
        
        lead l = new lead();
        l.lastname = 'testlastname';
        l.firstname = 'testfirstname';
        l.email = 'test@test.com';
        l.Stage__c ='SRL';
        l.Status= 'Nuture';
        l.company = 'test';
        l.CountryCode = 'BE';
        insert l;
        
        
        
        PageReference pageRef = Page.leaddatafillin;
        pageRef.getParameters().put('id', String.valueOf(l.Id));
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        
        LeadDataFillinController ldc = new LeadDataFillinController (sc);
        
        
        
        ldc.submit();
    
    
    
    }



}