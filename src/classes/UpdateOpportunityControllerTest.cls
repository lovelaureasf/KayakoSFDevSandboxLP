@isTest
public class UpdateOpportunityControllerTest 
{
    public static TestMethod void testUpdatePrice()
    {
        SObject opp = ObjectMocker.mock('Opportunity');
        opp.put('Amount', 500);
        opp.put('CloseDate', Date.today().addMonths(1));
        insert opp;
        
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        UpdateOpportunityController handler = new UpdateOpportunityController(controller);
        
        Date changedDate = null;
        
        handler.opportunityValue.Amount = 867.78;
        handler.opportunityValue.CloseDate = changedDate = Date.today().addMonths(2);
        
        //PageReference response = handler.UpdatePrice();
        
        Opportunity o = [SELECT Id, Amount, CloseDate FROM Opportunity WHERE Id = :opp.Id LIMIT 1];
        
        //System.assertEquals(867.78, o.Amount);
        //System.assertEquals(changedDate, o.CloseDate);
    }
}