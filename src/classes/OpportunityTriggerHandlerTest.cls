@isTest
    public class OpportunityTriggerHandlerTest  
    {
        public static TestMethod void OpportunityInsertTest()
        {
                
                User userAE = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 //UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'System administrator' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles', 
                                 username='userTest343232@kayako.com');
                insert userAE;

                Opportunity opp = new Opportunity(
                    Name='TestOpp',
                    StageName ='Value Proposition',
                    CloseDate = date.today()
                    
                );

                
                insert opp;
                
                opp.OwnerId= userAE.id;
                update opp;
        }   
    }