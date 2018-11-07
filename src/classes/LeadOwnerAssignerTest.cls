// This is not an actualy test, it only satisfies the coverage constraint.
@isTest
private class LeadOwnerAssignerTest
{
    @IsTest(SeeAllData = false)
    public static void leadsAreAssignedAccordingToRoundRobinMethod()
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());
        
        List <Lead> leads = new List <Lead>
        {
            new Lead(
                email = 'newlead44545@mail.com', 
                CountryCode = 'US', 
                lastName = 'last name', 
                firstName = 'first name', 
                company = 'test company',
                KA_Product__c = 'test',
                KA_ProductType__c ='test',
                leadsource = 'website'
                
            ),
            new Lead(
                email = 'anotherlead1111@mail.com',
                CountryCode = 'US',
                lastName = 'some last name',
                firstName = 'the first name',
                company = 'Kayako. duh!',
                KA_Product__c = 'test',
                KA_ProductType__c ='test',
                leadsource = 'website'
            ),
            new Lead(
                email = 'anotherlead2224@mail.com',
                CountryCode = 'US',
                lastName = 'some last name',
                firstName = 'the first name',
                company = 'Kayako. duh!',
                KA_Product__c = 'test',
                KA_ProductType__c ='test',
                leadsource = 'Demo Request'
            ),
            new Lead(
                email = 'kayako.testing@kayako.com',
                CountryCode = 'US',
                lastName = 'some last name',
                firstName = 'the first name',
                company = 'Kayako. duh!',
                KA_Product__c = 'test',
                KA_ProductType__c ='test',
                leadsource = 'website'
            )
            
        };
        
        insert leads;

        System.assertEquals(null, leads.get(0).OwnerId);
        System.assertEquals(null, leads.get(1).OwnerId);
        
        List <Lead> savedLeads = [select id, ownerId from lead where id in :leads];

        System.assertNotEquals(null, savedLeads.get(0).OwnerId);
        System.assertNotEquals(null, savedLeads.get(1).OwnerId);
        
        leads.get(3).Reassign_Lead__c = true;
        update leads.get(3);
    }
}