@isTest
    public class ConvertToOpportunityControllerTest
    {
        @testSetup static void setup() {
                // Create common test accounts
                Shift_Plan__c obj1 = new Shift_Plan__c( Shift_Name__c = 'Shift1',Start_Time__c= Time.newInstance(0, 0, 0,0),
                                                  End_Time__c = Time.newInstance(11, 59, 59, 59));
                insert obj1;
                Shift_Plan__c obj2 = new Shift_Plan__c( Shift_Name__c = 'Shift2',Start_Time__c= Time.newInstance(12, 0, 0,0),
                                                  End_Time__c = Time.newInstance(23, 59, 59, 59));
                insert obj2;
                User userSDR = new User(alias = 'standt', 
                                         email='testingkayako@testorg.com', 
                                         emailencodingkey='UTF-8', 
                                         lastname='Testing', languagelocalekey='en_US', 
                                         localesidkey='en_US',
                                         Shift__c = 'Shift1',
                                         //UserRoleId = csmRoleId[0].Id,
                                         profileid = [Select Id From Profile where Name like 'Sales Development Representative' limit 1 ].id, 
                                         timezonesidkey='America/Los_Angeles', 
                                         username='usersdr_Leadtest@kayako.com');
                User userSDR1 = new User(alias = 'standt', 
                                         email='testingkayako@testorg.com', 
                                         emailencodingkey='UTF-8', 
                                         lastname='Testing', languagelocalekey='en_US', 
                                         localesidkey='en_US',
                                         Shift__c = 'Shift2',
                                         //UserRoleId = csmRoleId[0].Id,
                                         profileid = [Select Id From Profile where Name like 'Sales Development Representative' limit 1 ].id, 
                                         timezonesidkey='America/Los_Angeles', 
                                         username='usersdr_Leadtest2@kayako.com');
                List<User> listUsers = new list<User>();
                listUsers.add(userSDR1);
                listUsers.add(userSDR);
                insert listUsers;

            }
        public static TestMethod void ConvertToOpportunityTest()
        {
            Test.setMock(HttpCalloutMock.class, new WebhookTest());

            SObject lead = ObjectMocker.mock('Lead');
            lead.put('Email', 'mail@example.com');
            lead.put('Stage__c','Qualified');
            lead.put('KA_Product__c', 'test');
            lead.put('KA_ProductType__c', 'test');
            lead.put('countryCode','IN');
            lead.put('leadsource','Demo Request');
            lead.put('Status','Open');
            
            insert lead;
            
            Lead ld= [Select id, Status,IsResponded__c,SLA_Breached__c from lead where id=:lead.id];
            ld.Status='Qualified';
            ld.IsResponded__c = true;
            ld.SLA_Breached__c = true;
            ld.ownerid= userinfo.getuserid();
            update ld;
            test.startTest();
            ApexPages.currentPage().getParameters().put('id', ld.Id);

            ApexPages.StandardController controller = new ApexPages.StandardController(ld);
            ConvertToOpportunityController handler = new ConvertToOpportunityController(controller);
            
            handler.opportunity.Amount     = 33.5;
            handler.opportunity.Type       = Util.GetPicklistValues(handler.opportunity, 'Type').get(0).getValue();
            handler.opportunity.Plan__c    = Util.GetPicklistValues(handler.opportunity, 'Plan__c').get(0).getValue();
            handler.opportunity.Product__c = Util.GetPicklistValues(handler.opportunity, 'Product__c').get(0).getValue();
            handler.opportunityCompetitors = new List <String> ();
            
            
            PageReference response = handler.ConvertToOpportunity();

            Lead refreshedLead = [SELECT Id, Email, IsConverted, Status 
                        FROM Lead WHERE Id = :lead.Id LIMIT 1];

            System.assert(refreshedLead.IsConverted);
            System.assert(refreshedLead.Status == LeadStatus.CONVERTED);
            
            List<String>compList = new List<String>();
            complist.add('firstComp');
            
            handler.SetOpportunityCompetitors(handler.opportunity,compList);
            test.stopTest();
        }
    }