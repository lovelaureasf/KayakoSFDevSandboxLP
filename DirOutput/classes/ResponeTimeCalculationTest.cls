@isTest
    public class ResponeTimeCalculationTest
    {
        public static TestMethod void LeadInsertTest()
        {
                
                User userAE = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 //UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'System administrator' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles',
                                 SDR__c = true, 
                                 username='userTest343232@kayako.com');
                insert userAE;

                Lead lead = new Lead(
                    email = 'newlead@mail.com', 
                    CountryCode = 'US', 
                    lastName = 'last name', 
                    firstName = 'first name', 
                    company = 'test company'
                    
                );

                
                lead.put('Email', 'kayako.testing@kayako.com');
                lead.put('CountryCode', 'US');
                lead.put('Phone', '+8888888888');
                lead.put('KA_Product__c','test');
                lead.put('KA_ProductType__c','test');
                lead.put('OwnerId',userAE.Id);
                
                insert lead;
                
                lead.Status='Contacted';
                
                update lead;
        }   
    }