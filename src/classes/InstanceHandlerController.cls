public class InstanceHandlerController {
    public String instanceId {get;set;}
    public String actionType {get;set;}
    public String actionStatus{get;set;}
    public String reason {get;set;}
    public String customkey;
    
    public static Boolean runningInASandbox() {  // to check if running in sandbox.
          return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
       }
    
    
    public InstanceHandlerController(){
        
        instanceId = ApexPages.currentPage().getParameters().get('id');
        
        actionType = ApexPages.currentPage().getParameters().get('type');
        
        List<Instance__c>instanceList = new List<Instance__c>();
        
        instanceList = [select id,name,platformStatus__c,UUID__c from Instance__c where id=:instanceId];
        
        String url = 'https://my.kayako.com/api/index.php?/v1/instances/'+instanceList[0].UUID__c;
        
        if(runningInASandbox()){
            url = 'https://my.kayakostage.net/api/index.php?/v1/instances/'+instanceList[0].UUID__c;
        }
        
        System.debug('action type is'+actionType);
        if(actionType == 'enable'){
           
           url = url+'/enable';
           
           actionStatus = 'Enable action status is'; 
            
        }else if(actionType == 'disable'){
            
            url = url+'/disable';
            
            actionStatus = 'Disable action status is';
        }    
        
        System.debug('url is this'+url);
        
        if(!Test.isRunningTest()){
            customKey = [select id,name, Key__c from KayakoAuditorKey__c limit 1][0].Key__c;    
        }else{
            customKey = 'test';
        }
        Http WebDriver = new Http();
        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(url); 
        
        request.setMethod('PUT');
        
        request.setHeader('ACCESSKEY', 'test');
        
        String timestamp = String.valueOf(DateTime.Now().getTime()/1000);
        
        request.setHeader('TIMESTAMP',timestamp);
        
        String shasign = EncodingUtil.ConverttoHex(Crypto.generateDigest('SHA1', Blob.valueOf('test'+customkey+timestamp)));
        
        request.setHeader('HASH',shasign);
        
        HttpResponse response = new HttpResponse ();
        
        
        if(!Test.isRunningTest()){ response = WebDriver.send(request); System.debug('response is'+response.getBody()); if(response.getBody().contains('200')){ actionStatus = 'Result is: Success'; }else{ actionStatus ='Result is Failure';JSONParser parser = JSON.createParser(response.getBody());  while (parser.nextToken() != null) {if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'code')) {parser.nextToken();reason = parser.getText();}} } }
    
    }
    
     public pageReference goBack(){
        PageReference pg = new PageReference('/'+instanceId);
        pg.setRedirect(true);
        return pg;
    }
    
}