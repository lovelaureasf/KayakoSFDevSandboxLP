@isTest
public class LeadStageTest 
{
    public static TestMethod void testAllLeadStages()
    {
        Set <String> stages = LeadStage.getAll();

        System.assert(stages.contains(LeadStage.MQL));
        System.assert(stages.contains(LeadStage.SAL));
        System.assert(stages.contains(LeadStage.SRL));
        System.assert(stages.contains(LeadStage.SQL));
        System.assert(stages.contains(LeadStage.SDL));
    }	
}