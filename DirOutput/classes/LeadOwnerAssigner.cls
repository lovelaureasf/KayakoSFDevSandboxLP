/**
 * This class handles the assignment of a Lead owner based on User Lead Counter
 * and Weightage for priority. It sift through users in round robin manner.
 */
public without sharing class LeadOwnerAssigner
{
    private static Map <Id, User> assignedOwners = new Map <Id, User> ();

    private static Map <Id, Lead> updatedLeads = new Map <Id, Lead> ();
    
    /**
     * Assign owner to a lead using available Lead counter and profile weightage
     * on user's profile. Assignments are done in round robin manner.
     *
     * @author Mohammad Gufran <mohammad.gufran@kayako.com>
     * @var    leadsList List of leads in context.
     * @return void
     */
    @InvocableMethod(label = 'Assign lead owner')
    public static void AssignLeadOwner(List<Lead> leadsList)
    {
        Map<id,Lead> updateLeadListSet = new Map<Id,Lead>();
        
        LeadOwnerAssigner assigner = new LeadOwnerAssigner();
        for (Lead LeadItem : leadsList)
        {
            if(LeadItem.CountryCode == null) continue;
                Lead freshLead = assigner.GetLeadWithRegion(LeadItem);
            
            updateLeadListSet.put(freshLead.id,freshLead);

        }

        
        if(updateLeadListSet.Size()>0)
            update updateLeadListSet.values();
    }
    
    private Lead GetLeadWithRegion(Lead lead)
    {
        Lead newLead = LeadDataAccess.GetLeadById(lead.Id);

        newLead.KA_Territory__c = TerritoryDataAccess.GetLeadRegion(lead).Name;
        
        updatedLeads.put(newLead.Id, newLead);
        
        return newLead;
    }
}