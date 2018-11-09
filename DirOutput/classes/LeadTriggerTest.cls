@isTest
    public class LeadTriggerTest
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
                lead.put('KA_Product__c','test');
                lead.put('KA_ProductType__c','test');
                insert lead;
                
                lead.Reassign_Lead__c =true;
                lead.OwnerId= userAE.id;
                update lead;
        }   
    }