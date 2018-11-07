public without sharing class OpportunityInstanceDetailsController extends OpportunityButtonActionHandler
{   
    public Opportunity opportunityValue { get; set; }

    public OpportunityInstanceDetailsController(ApexPages.StandardController controller)
    {
        if(!Test.isRunningTest()){
            controller.addFields(new List<String> {'KA_ExpiryDate__c'});
        }
        opportunityValue = (opportunity)controller.getRecord();

        if(opportunityValue.KA_ExpiryDate__c == null){ 
        
            opportunityValue.KA_ExpiryDate__c = DateTime.now(); 
        
        }
    }

    public PageReference UpdateInstance()
    {
        opportunity.KA_ExpiryDate__c = opportunityValue.KA_ExpiryDate__c;
        opportunity.Plan__c = opportunityValue.Plan__c;
        opportunity.Product__c = opportunityValue.Product__c;
        
        update opportunity;

        return Util.RedirectTo(GetOpportunityId());
    }
}