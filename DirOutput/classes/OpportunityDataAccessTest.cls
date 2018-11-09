@isTest
public class OpportunityDataAccessTest 
{
    public static TestMethod void testOpportunityForQuote()
    {
        SObject mock = ObjectMocker.mock('Opportunity');
        System.assert( ! OpportunityDataAccess.OpportunityHasQuote(mock.Id));
    }
    
    @isTest(SeeAllData = true)
    public static void getOpportunity()
    {
        Opportunity o = [select id from opportunity limit 1];
        
        Opportunity found = OpportunityDataAccess.GetOpportunityById(o.Id);
        
        System.assertEquals(o.Id, found.Id);
        
        found = OpportunityDataAccess.GetOpportunityById(o.Id);
        
        System.assertEquals(o.Id, found.Id);
        
        try
        {
            OpportunityDataAccess.GetOpportunityById('00000000000A0AAAA0');
        }
        catch(UnderflowException e)
        {
            System.assertEquals('Cannot find the opportunity with Id 00000000000A0AAAA0', e.getMessage());
        }
    }
    
    @isTest(seealldata = true)
    public static void getOpportunityHistory()
    {
        Opportunity o = [select id from opportunity limit 1];
        List <OpportunityHistory> historyEvents = OpportunityDataAccess.GetHistory(o.Id);
    }
}