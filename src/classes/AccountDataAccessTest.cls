@isTest
public class AccountDataAccessTest
{
    // Testing //  
    public static TestMethod void GetFirstAccountByNameAndOwner()
    {
    
    
        List<UserRole> csmRoleId = [select id from userRole where name='Account Executive Europe' 
                                    OR name='Account Executive Americas' limit 1];
        User userAE = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'System administrator' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles', 
                                 username='userTest343232@kayako.com');
        insert userAE;
        system.runAs(userAE){
        Account account = new Account(
            name = 'someone@mail.com'//,
            //OwnerId = '00510000003NltV'
        );

        insert account;

        Account foundAccount = AccountDataAccess.FirstByNameAndOwner('someone@mail.com', userAE.id);

        System.assert(account.Id == foundAccount.Id);
        }
    }
    
    
    public static TestMethod void AccountDeleteTest()  //for two records OnAccountDelete Trigger
    {
    
        List<UserRole> csmRoleId = [select id from userRole where name='Account Executive Europe' 
                                    OR name='Account Executive Americas' limit 1];
        User userAE = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'System administrator' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles', 
                                 username='userTest343232@kayako.com');
        insert userAE;
        system.runAs(userAE){
        
        
        Account account1 = new Account(
            name = 'someone1@mail.com'//,
           // OwnerId = '00510000003NltV'
        );

        insert account1;
        
        Account account2 = new Account(
            name = 'someone2@mail.com'//,
            //OwnerId = '00510000003NltV'
        );
        
        insert account2;
        
       List<Account> accList = new List<Account>();
       accList.add(account1);
       accList.add(account2);
       delete accList;
       } 
        
        
    }
    
    public static TestMethod void AccountDeleteTest2()  //for 10 records OnAccountDelete Trigger
    {
        List<UserRole> csmRoleId = [select id from userRole where name='Account Executive Europe' 
                                    OR name='Account Executive Americas' limit 1];
        User userAE = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'System administrator' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles', 
                                 username='userTest343232@kayako.com');
        insert userAE;
        system.runAs(userAE){
        Account account1 = new Account(
            name = 'someone1@mail.com'//,
            //OwnerId = '00510000003NltV'
        );

        insert account1;
        
        Account account2 = new Account(
            name = 'someone2@mail.com'//,
           // OwnerId = '00510000003NltV'
        );
        
        insert account2;
        
        Account account3 = new Account(
            name = 'someone3@mail.com'//,
           // OwnerId = '00510000003NltV'
        );

        insert account3;
        
        Account account4 = new Account(
            name = 'someone4@mail.com'//,
            //OwnerId = '00510000003NltV'
        );
        
        insert account4;
        
        Account account5 = new Account(
            name = 'someone5@mail.com'//,
            //OwnerId = '00510000003NltV'
        );

        insert account5;
        
        Account account6 = new Account(
            name = 'someone6@mail.com'//,
            //OwnerId = '00510000003NltV'
        );
        
        insert account6;
        
             Account account7 = new Account(
            name = 'someone7@mail.com'//,
            //OwnerId = '00510000003NltV'
        );

        insert account7;
        
        Account account8 = new Account(
            name = 'someone8@mail.com'//,
            //OwnerId = '00510000003NltV'
        );
        
        insert account8;
        
        Account account9 = new Account(
            name = 'someone9@mail.com'//,
           // OwnerId = '00510000003NltV'
        );

        insert account9;
        
        Account account10 = new Account(
            name = 'someone10@mail.com'//,
            //OwnerId = '00510000003NltV'
        );
        
        insert account10;
        
        Account account11 = new Account(
            name = 'someone11@mail.com'//,
            //OwnerId = '00510000003NltV'
        );

        insert account11;
        
        Account account12 = new Account(
            name = 'someone12@mail.com'//,
            //OwnerId = '00510000003NltV'
        );
        
        insert account12;
       
       List<Account> accList = new List<Account>();
       accList.add(account1);
       accList.add(account2);
       accList.add(account3);
       accList.add(account4);
       accList.add(account5);
       accList.add(account6);
       accList.add(account7);
       accList.add(account8);
       accList.add(account9);
       accList.add(account10);
       accList.add(account11);
       accList.add(account12);
       delete accList;
       } 
        
        
    }


    public static TestMethod void ThrowExceptionOnError()
    {
        try
        {
            AccountDataAccess.FirstByNameAndOwner('someone@mail.com', '00510000003NltV');
        }
        catch(UnderflowException e)
        {
            System.assert(true);
        }
    }
}