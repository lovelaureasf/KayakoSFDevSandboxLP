public without sharing class OpportunityDataAccess 
{
    private static Map <Id, Opportunity> opportunityCache = new Map <Id, Opportunity> ();

    public static Opportunity GetOpportunityById(Id opportunityId)
    {
        if(opportunityCache.containsKey(opportunityId)) 
        {
            return opportunityCache.get(opportunityId);
        }

        try
        {
            Opportunity opportunity = [SELECT Id, StageName, CloseDate, Amount, Type, KA_TrialExpiryDate__c, Product__c, Plan__c From Opportunity WHERE Id = :opportunityId];

            opportunityCache.put(opportunityId, opportunity);

            return opportunity;
        }
        catch(QueryException noResultFound)
        {
            throw new UnderflowException('Cannot find the opportunity with Id ' + opportunityId);
        }
    }

    public static boolean OpportunityHasQuote(Id opportunityId)
    {
        List <zqu__Quote__c> quotes = [SELECT Id, zqu__Opportunity__c FROM zqu__Quote__c WHERE zqu__Opportunity__c = :opportunityId]; 

        return ! quotes.isEmpty();
    }
    
    public static List <OpportunityHistory> GetHistory(Id opportunityId)
    {
        return [SELECT Amount, CloseDate, CreatedById, CreatedDate,
                ExpectedRevenue, ForecastCategory, Id, IsDeleted, OpportunityId,
                Probability, StageName, SystemModstamp 
                FROM OpportunityHistory 
                WHERE OpportunityId = :opportunityId ORDER BY CreatedDate 
                DESC NULLS FIRST LIMIT 100];
    }
}