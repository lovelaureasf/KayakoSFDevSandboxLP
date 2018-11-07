public class QuoteCreationController {
    
    public String recordId;
    public Boolean createNew{get;set;}
    public Boolean upgradeCheck{get;set;}
    public Boolean showProceed {get;set;}
    public List<zqu__Quote__c>qList;
    public List<Zuora__CustomerAccount__c>caList;
    public List<opportunity> oppList;
    public List<Instance__c>InstanceList;
    public List<Zuora__Subscription__c>subscriptionList;
    
    public QuoteCreationController(ApexPages.StandardController controller) {
        
        subscriptionList = new List<Zuora__Subscription__c>();
        
        InstanceList = new List<Instance__c>();
        
        recordId = controller.getRecord().Id;
        
        createNew = false;
        
        upgradeCheck = false;
        
        showProceed = true;
        
        qList = new List<zqu__Quote__c>();
        
        caList = new List<Zuora__CustomerAccount__c>();
        
        qList = [select id,name,zqu__Account__c,zqu__Account__r.id from zqu__Quote__c where zqu__Opportunity__r.id =:recordId];
        
        oppList = [select id,name,accountId,Product__c,Instance__c from opportunity where id=:recordId];
        
        InstanceList = [select id,name,Instance_Id__c,PlatformStatus__c,Status__c,State__c from Instance__c where id =:oppList[0].Instance__c ];
        
        if(InstanceList.size()>0){
        
            subscriptionList = [select id,name,InstanceID__c from Zuora__Subscription__c where InstanceID__c=:String.valueOf(InstanceList[0].Instance_Id__c) limit 1];
        
        }
        
        if(subscriptionList.size()>0 && showProceed==true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'The trial you are trying to convert is already paid and linked to  a'+ '<a href="/'+subscriptionList[0].id+'"> subscription </a>');
            ApexPages.addMessage(myMsg);
            showProceed = false;
        }
        
        if(InstanceList.size()>0 && InstanceList[0].Status__c == 'Expired' && showProceed == true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'The trial you are trying to convert is no longer active. Please extend expiry of <a href="/'+InstanceList[0].id+'">trial.</a>');
            ApexPages.addMessage(myMsg);
            showProceed = false;
        }
        
        if(InstanceList.size()>0 && InstanceList[0].State__c == 'DELETED' && showProceed == true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'The trial you are trying to convert no longer exists and is in a deleted state.');
            ApexPages.addMessage(myMsg);
            showProceed = false;
        }
        
        
        caList = [select id,name, Zuora__Account__c from Zuora__CustomerAccount__c where Zuora__Account__r.id=:oppList[0].accountId];
        
        if(caList.size()>0 && showProceed==true){
        
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There is an existing Billing Account with this opportunity, a new subscription will be created under this Billing Account.');
             ApexPages.addMessage(myMsg);
             createNew = false;
        
        }else if (caList.size()==0 && showProceed== true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'There is no existing Billing Account with this opportunity, a new subscription will be created with new Billing Account.');
            ApexPages.addMessage(myMsg);
            createNew = true;
        }
        
        
        if(oppList[0].Product__c.contains('4') && (oppList[0].Product__c.contains('Upgrade') || oppList[0].Product__c.contains('upgrade'))){
            Set<String>subIds = new Set<String>();
            for(Zuora__Subscription__c s:[select id,name,Zuora__Status__c from Zuora__Subscription__c where Zuora__Account__c=:oppList[0].accountId and Zuora__Status__c='Active' ]){
                subIds.add(s.id);
            }
        for(Zuora__SubscriptionProductCharge__c spc:[select id,name from Zuora__SubscriptionProductCharge__c where Zuora__Subscription__r.id IN:subIds]){      
              if(spc.Name.contains('4')){  
                createNew = false;
                upgradecheck = true;
              }  
            }
        if(upgradecheck==true && showProceed == true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'This quote needs amendment to existing subscription. Please raise a JIRA in BPDM with details so that your system administrator can process it. To return to opportunity click Proceed.');
            ApexPages.addMessage(myMsg);
        }
        
        }
    }
    
    
    public pageReference proceed(){
        if(createNew){
            PageReference pg = new PageReference('https://zqu.ap0.visual.force.com/apex/CreateQuote?oppId='+recordId+'&quoteType=Subscription&retUrl='+recordId+'&stepNumber=2&crmAccountId='+oppList[0].accountId);
            pg.setRedirect(true);
            return pg;
        }else if(!upgradecheck && !createNew){
            Zuora__CustomerAccount__c zca = [select id,name,Zuora__Zuora_Id__c from Zuora__CustomerAccount__c where Zuora__Account__r.id=:oppList[0].accountid limit 1];
            PageReference pg = new PageReference('https://zqu.ap0.visual.force.com/apex/CreateQuote?billingAccountId='+zca.Zuora__Zuora_Id__c+'&oppId='+recordId+'&quoteType=Subscription&retUrl='+recordId+'&stepNumber=2&crmAccountId='+oppList[0].accountId);
            pg.setRedirect(true);
            return pg;
        }else{
            PageReference pg = new PageReference('/'+oppList[0].id);
            pg.setRedirect(true);
            return pg;
        
        }
        
        
    }
    
   

}