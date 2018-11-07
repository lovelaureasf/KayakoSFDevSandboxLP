@isTest
public class ObjectMockerTest 
{
    public static TestMethod void testMocker()
    {
        SObject leadMock = ObjectMocker.mock('Lead');
        SObject userMock = ObjectMocker.mock('User');
        SObject AccountMock = ObjectMocker.mock('Account');
        SObject ContactMock = ObjectMocker.mock('Contact');
        SObject OppMock = ObjectMocker.mock('Opportunity');
        
        System.assertEquals('TEST', leadMock.get('LastName'));
        System.assertEquals('TEST', userMock.get('LastName'));
    }
}