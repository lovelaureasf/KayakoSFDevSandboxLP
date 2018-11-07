public without sharing class LeadDataAccess 
{
    /**
     * @var matchingListsCache Cache leads by email.
     */
    private static Map <String, List <Lead>> matchingListsCache = new Map <String, List<Lead>> ();

    /**
     * @var leadsCache Cache leads by Id
     */
    private static Map <Id, Lead> leadsCache = new Map <Id, Lead> ();

    /**
     * Get matching leads by email.
     * 
     * @param leadToMatch
     * @returns List <Lead>
     * @author Mohammad Gufran <mohammad.gufran@kayako.com>
     */
    public static List <Lead> GetMatchingLeads (Lead leadToMatch)
    {
        if(matchingListsCache.containsKey(leadToMatch.Email))
        {
            return matchingListsCache.get(leadToMatch.Email);
        }
        
        List <Lead> matchingLeads = [Select id,country,leadType__c, CountryCode, OwnerId, CreatedDate 
                                     FROM Lead WHERE (email = :leadToMatch.Email and id != :leadToMatch.Id and KA_Territory__c = :leadToMatch.KA_Territory__c) 
                                     ORDER BY CreatedDate DESC LIMIT 10];
        
        if(matchingLeads.isEmpty()) throw new UnderflowException('No matching lead exists for email ' + leadToMatch.Email);
        
        matchingListsCache.put(leadToMatch.Email, matchingLeads);
        
        return matchingLeads;
    }

    /**
     * Get a lead by its ID
     *
     * @param leadId Id
     * @returns Lead
     * @author Mohammad Gufran <mohammad.gufran@kayako.com>
     */
    public static Lead GetLeadById(Id leadId)
    {
        if(leadsCache.containsKey(leadId))
        {
            return leadsCache.get(leadId);
        }

        try
        {
            Lead lead = [SELECT Id,country, Email,leadType__c,Factors__c,Comments__c, Status, CountryCode, Industry, NumberOfEmployees, OpportunityType__c,
                            Stage__c, KA_Territory__c, HubSpot_Inc_Score__c, Company, KA_TrialExpiryDate__c,
                            StatusToContactedDate__c, Budgeted__c, Role__c, City, PreviousOwner__c,
                            Authority__c, CurrentSystem__c, UsedFor__c, Department__c, OwnerId,
                            State, PostalCode, Phone, MobilePhone, HasOptedOutOfEmail, LeadSource,ManualOwnerChange__c,Reassigned_To__c,Assigned_SDR__c,Budget_determined__c,Authority_determined__c,Needs_determined__c,Timeline_determined__c,The_number_of_seats__c,Proposed_Kayako_Plan__c,infer3__Infer_Rating__c,infer3__Infer_Score__c,
                            (SELECT Title, Body FROM Notes)
                        FROM Lead WHERE Id = :leadId LIMIT 1];

            leadsCache.put(leadId, lead);

            return lead;
        }
        catch(QueryException nullResultException)
        {
            throw new UnderflowException('No lead found by Id ' + leadId);
        }
    }
    
    public static List <Lead> GetUnresponsiveLeadsSinceDate(Date lastResponseTime)
    {
        List <Lead> unresponsiveLeads = new List <Lead> ();
        
        try
        {
            unresponsiveLeads = [SELECT Id,country,LeadType__c,CountryCode, Email, Status, Stage__c, 
                                    OwnerId, StageToSRLDate__c, StatusToNurtureDate__c, 
                                    StatusLastUpdatedDate__c
                                FROM Lead 
                                WHERE Status = 'Unresponsive' 
                                       AND StatusToUnresponsiveDate__c <= :lastResponseTime];
            
            return unresponsiveLeads;
        }
        catch(QueryException nullResultException)
        {
            return unresponsiveLeads;
        }
    }
    
    public static List <Note> GetNotesOnLead(Id leadId)
    {
        List <Note> notes = null;

        try
        {
            notes = [SELECT Title, Body FROM Note WHERE ParentId = :leadId];
        }
        catch(QueryException nullResultException)
        {
            notes = new List <Note> ();
        }
        
        return notes;
    }
}