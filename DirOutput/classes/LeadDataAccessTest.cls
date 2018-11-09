@isTest
public class LeadDataAccessTest 
{
    public static TestMethod void testGetMatchingLeads()
    {
        Shift_Plan__c obj = new Shift_Plan__c( Shift_Name__c = 'Shift1',Start_Time__c= Time.newInstance(0, 0, 0,0),
                                              End_Time__c = Time.newInstance(23, 59, 59, 0));
        insert obj;
        User userSDR = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 Shift__c = 'Shift1',
                                 //UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'Sales Development Representative' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles', 
                                 username='userTestsdr343232@kayako.com');
       insert userSDR;

        SObject mock = ObjectMocker.mock('Lead');
        mock.put('email', 'example@kayako.com');
        mock.put('ka_territory__c', 'APAC');
        
        SObject firstDuplicate = ObjectMocker.mock('Lead');
        firstDuplicate.put('email', 'example@kayako.com');
        firstDuplicate.put('ka_territory__c', 'APAC');
        
        SObject secondDuplicate = ObjectMocker.mock('Lead');
        secondDuplicate.put('email', 'example@kayako.com');
        secondDuplicate.put('ka_territory__c', 'APAC');
       
        insert mock;
        insert firstDuplicate;
        insert secondDuplicate;
        
        Lead lead = [select id, email, ka_territory__c from lead where id = :mock.Id limit 1];

        // First block coverage
        List<Lead> matching = LeadDataAccess.GetMatchingLeads(lead);
        List<Lead> cached = LeadDataAccess.GetMatchingLeads(lead);
        
        System.assertEquals(lead.Email, 'example@kayako.com');

    }
    
    @IsTest(SeeAllData = true)
    public static void GetListOfUnresponsiveLeads()
    {
        SObject lead = ObjectMocker.mock('Lead');
        lead.put('Status', LeadStatus.UNRESPONSIVE);
        lead.put('StatusToUnresponsiveDate__c', Date.today().addMonths(-3));
        lead.put('Email', 'unresponsive@kayako.test');
        
        insert lead;
      
        
        List <Lead> leads = LeadDataAccess.GetUnresponsiveLeadsSinceDate(Date.today().addMonths(-1));
        List<Note> nt = LeadDataAccess.GetNotesOnLead(lead.id);
        
        
        
    }
    
    @IsTest(SeeAllData = true)
    public static void GetAllNotesOnList()
    {
        Note note = [select id, parentid from note limit 1];
        List <Note> foundNote = LeadDataAccess.GetNotesOnLead(note.ParentId);     
    }
   
    private static testmethod void Test_GetLeadById()
    {
        Shift_Plan__c obj = new Shift_Plan__c( Shift_Name__c = 'Shift1',Start_Time__c= Time.newInstance(0, 0, 0,0),
                                              End_Time__c = Time.newInstance(23, 59, 59, 0));
        insert obj;
        User userSDR = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 Shift__c = 'Shift1',
                                 //UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'Sales Development Representative' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles', 
                                 username='userTests1dr343232@kayako.com');
       insert userSDR;
        SObject lead = ObjectMocker.mock('Lead');
        lead.put('Status', LeadStatus.UNRESPONSIVE);
        lead.put('StatusToUnresponsiveDate__c', Date.today().addMonths(-3));
        lead.put('Email', 'unresponsive@kayako.test');
        
        insert lead;
      
        Test.startTest();
        LeadDataAccess.GetLeadById(lead.Id);
        Test.stopTest();
    }
    
}