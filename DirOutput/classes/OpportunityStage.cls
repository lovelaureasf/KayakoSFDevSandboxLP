public without sharing class OpportunityStage 
{
    public static final String WON = 'Closed Won';
    public static final String LOST = 'Closed Lost';
    public static final String DEMO = 'Demo';
    public static final String VALUE_PROPOSITION = 'Value Proposition';
    public static final String PROPOSAL_AND_QUOTE = 'Proposal/Price Quote';
    public static final String WAITING_FOR_APPROVAL = 'Waiting for approval';
    public static final String PROJECT_POSTPONED = 'Project Postponed';
    public static final String REVIEW_AND_NEGOTIATION = 'Negotiation/Review';
    public static final String CREATED = 'Created';
    public static final String REJECTED = 'Closed: Rejected';

    public static Set <String> getAll()
    {
        return new Set <String> 
        {
            WON,
            LOST,
            DEMO,
            VALUE_PROPOSITION,
            PROPOSAL_AND_QUOTE,
            REVIEW_AND_NEGOTIATION,
            CREATED,
            REJECTED,
            PROJECT_POSTPONED,
            WAITING_FOR_APPROVAL
        };
    }
}