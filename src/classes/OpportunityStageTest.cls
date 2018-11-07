@isTest
public class OpportunityStageTest
{
    public static TestMethod void TestOpportunityStages()
    {
        Set <String> stages = OpportunityStage.getAll();

        System.assert(stages.contains(OpportunityStage.WON));
        System.assert(stages.contains(OpportunityStage.LOST));
        System.assert(stages.contains(OpportunityStage.DEMO));
        System.assert(stages.contains(OpportunityStage.VALUE_PROPOSITION));
        System.assert(stages.contains(OpportunityStage.PROPOSAL_AND_QUOTE));
        System.assert(stages.contains(OpportunityStage.REVIEW_AND_NEGOTIATION));
    }
}