@isTest
public class OpportunityButtonRendererTest 
{
    private static SObject opportunity;

    private static void createMock()
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());
        
        opportunity = ObjectMocker.mock('Opportunity');
        opportunity.put('OwnerId', UserInfo.GetUserId());
        insert opportunity;
        ApexPages.currentPage().getParameters().put('id', opportunity.Id);
    }

    private static OpportunityButtonRenderer createRenderer()
    {
        ApexPages.StandardController controller = new ApexPages.StandardController(opportunity);
        return new OpportunityButtonRenderer(controller);
    }

    private static OpportunityButtonRenderer createHandler()
    {
        createMock();
        return createRenderer();
    }

    public static TestMethod void testConstructor()
    {
        createHandler();
    }

    public static TestMethod void testCanDemoOpportunity()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.VALUE_PROPOSITION);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert(handler.GetCanDemoOpportunity());
    }


    public static TestMethod void testCanProjectPosponedOpportunity()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.VALUE_PROPOSITION);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert(handler.GetCanProjectPostponedOpportunity());
    }

    public static TestMethod void testCanUpdatePriceOpportunity()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.VALUE_PROPOSITION);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert(handler.GetCanUpdatePrice());
    }

    public static TestMethod void testGetCanMarkAsAcceptOpportunity(){
        createMock();
        opportunity.put('StageName', OpportunityStage.CREATED);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        
    }

    public static TestMethod void testGetCanMarkAsRejectOpportunity(){
        createMock();
        opportunity.put('StageName', OpportunityStage.CREATED);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        
    }

    public static testMethod void testCanUpgrade(){
        Instance__c i = new Instance__c();
        i.name = 'test.kayako.com';
        i.state__c = 'trial';
        i.expiry_date__c = date.today()-1;
        insert i;
        
        
        createMock();
        opportunity.put('Product__c','Kayako(Nov 2016)');
        opportunity.put('Instance__c',i.id);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();
        
        
        System.assertEquals(false, handler.GetCanUpgrade());
    }


    public static TestMethod void testCanProvideProposalAndQuoteInValueProposition()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.VALUE_PROPOSITION);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert(handler.GetCanProvideProposalAndQuote());
    }

    public static TestMethod void testCanProvideProposalAndQuoteInDemo()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.DEMO);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert(handler.GetCanProvideProposalAndQuote());
    }

    public static TestMethod void testCannotMarkAsLostIfLost()
    {
        createMock();
        opportunity.put('StageName', 'Closed Lost: Dead');
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        
    }

    public static TestMethod void testCannotMarkAsLostIfWon()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.WON);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert( ! handler.GetCanMarkAsLost());
    }

    public static TestMethod void testCanMarkAsWonInReviewAndNegotiation()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.REVIEW_AND_NEGOTIATION);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assertEquals(UserDataAccess.GetCurrentUser().Profile.Name == 'System Administrator', handler.GetCanMarkAsWon());
    }

    public static TestMethod void testCanMarkAsWonInProposalAndQuote()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.PROPOSAL_AND_QUOTE);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();
        
        System.assertEquals(UserDataAccess.GetCurrentUser().Profile.Name == 'System Administrator', handler.GetCanMarkAsWon());
    }

    public static TestMethod void testCanReviewAndNegotiate()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.PROPOSAL_AND_QUOTE);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert(handler.GetCanReviewAndNegotiate());
    }

    public static TestMethod void testCanProvideNewQuote()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.PROPOSAL_AND_QUOTE);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert(handler.GetCanProvideNewQuote());
    }
    
    public static TestMethod void testCanUpdateInstance()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.PROPOSAL_AND_QUOTE);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert(handler.GetCanUpdateInstanceDetails());
    }
    
    public static TestMethod void testCannotUpdateInstanceIfWon()
    {
        createMock();
        opportunity.put('StageName', OpportunityStage.WON);
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        System.assert( ! handler.GetCanUpdateInstanceDetails());
    }
    
    public static TestMethod void testCannotUpdateInstanceIfLost()
    {
        createMock();
        opportunity.put('StageName', 'Closed Lost: Dead');
        update opportunity;
        OpportunityButtonRenderer handler = createRenderer();

        
    }
    
    public static TestMethod void TestDemoOpportunity()
    {
        OpportunityButtonRenderer handler = createHandler();
        PageReference response = handler.DemoOpportunity();
        Opportunity subject = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];
        System.assert(subject.StageName == OpportunityStage.DEMO);
    }

    public static TestMethod void TestProjectPostponedOpportunity()
    {
        OpportunityButtonRenderer handler = createHandler();
        PageReference response = handler.ProjectPostponedOpportunity();
        Opportunity subject = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];
        System.assert(subject.StageName == OpportunityStage.PROJECT_POSTPONED);
    }

    public static TestMethod void TestMarkAsAcceptOpportunity()
    {
        OpportunityButtonRenderer handler = createHandler();
        PageReference response = handler.markAsAccept();
        Opportunity subject = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];
        System.assert(subject.StageName == OpportunityStage.VALUE_PROPOSITION);
    }

    public static TestMethod void TestMarkAsRejectOpportunity()
    {
        OpportunityButtonRenderer handler = createHandler();
        PageReference response = handler.markAsReject();
        Opportunity subject = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];
        System.assert(subject.StageName == OpportunityStage.REJECTED);
    }

    public static TestMethod void testProposalAndQuoteGiven()
    {
        OpportunityButtonRenderer handler = createHandler();
        PageReference response = handler.ProvideProposalAndQuote();
        Opportunity subject = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];
        System.assert(subject.StageName == OpportunityStage.PROPOSAL_AND_QUOTE);
    }

   

    public static TestMethod void testOpportunityIsWon()
    {
        OpportunityButtonRenderer handler = createHandler();
        PageReference response = handler.MarkAsWon();
        Opportunity subject = [SELECT Id, StageName, ClosedBy__c FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];

        System.assertEquals('Agent', subject.ClosedBy__C);
        System.assertEquals(OpportunityStage.WON, subject.StageName);
    }

    public static TestMethod void testUpdateWonReason()
    {
        OpportunityButtonRenderer handler = createHandler();
        PageReference response = handler.UpdateWonReason();
        Opportunity subject = [SELECT Id, factors__c,StageName, ClosedBy__c FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];

        System.assertEquals(null, subject.factors__c);
       // System.assertEquals(OpportunityStage.WON, subject.StageName);
    }

    public static TestMethod void testOpportunityIsLost()
    {
        OpportunityButtonRenderer handler = createHandler();
        handler.lostStage = 'Closed Lost: Dead';
        handler.lostReason ='test';
        PageReference response = handler.MarkAsLost();

        Opportunity subject = [SELECT Id, Factors__c,StageName, ClosedBy__c FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];

        System.assertEquals('Agent', subject.ClosedBy__C);
        System.assertEquals('test', subject.Factors__c);
        System.assertEquals('Closed Lost: Dead', subject.StageName);
    }

    public static TestMethod void testReviewAndNegotiate()
    {
        OpportunityButtonRenderer handler = createHandler();
        PageReference response = handler.ReviewAndNegotiate();
        Opportunity subject = [SELECT Id, StageName FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];
        System.assert(subject.StageName == OpportunityStage.REVIEW_AND_NEGOTIATION);
    }


}