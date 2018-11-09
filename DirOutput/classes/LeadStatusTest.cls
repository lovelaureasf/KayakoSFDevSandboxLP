@isTest
public class LeadStatusTest
{
    public static TestMethod void TestAllLeadStatuses()
    {
        Set <String> statuses = LeadStatus.getAll();

        System.assert(statuses.contains(LeadStatus.OPEN));
        System.assert(statuses.contains(LeadStatus.QUALIFIED));
        System.assert(statuses.contains(LeadStatus.INTERESTED));
        System.assert(statuses.contains(LeadStatus.NURTURE));
        System.assert(statuses.contains(LeadStatus.UNRESPONSIVE));
        System.assert(statuses.contains(LeadStatus.CONVERTED));
        System.assert(statuses.contains(LeadStatus.CONTACTED));
        System.assert(statuses.contains(LeadStatus.UNQUALIFIED));
        System.assert(statuses.contains(LeadStatus.DEAD));
    }	
}