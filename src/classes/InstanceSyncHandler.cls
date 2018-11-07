// This is responsible to handle sync requests which are coming from lead instance change.
// Developed By: Sagar Pareek


global with sharing class InstanceSyncHandler {
    
    
    public static Boolean runningInASandbox() {
      return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
   }
    
   public static String auditorKey = [select id,name, Key__c from KayakoAuditorKey__c limit 1][0].Key__c; 
    
    
    @Future(callout = true)
    public static void handleEvent(String uuid,String expirydate,String leadId,String product){
                    
                    String syncurl = '';
                    
                    if(runningInASandbox()){
                       syncurl= 'https://my.kayakostage.net/api/v1/instances/';
                    }else{
                       syncurl = 'https://my.kayako.com/api/v1/instances/';
                    }
       
                   
                   
                   
                   
                   
                   
                   
                   
                   HttpRequest request = new HttpRequest();
                   Http WebDriver = new Http();
                   syncurl = syncurl+uuid+'/'+'sync';
                   request.setEndpoint(syncUrl);
                   request.setMethod('PUT');
                   request.setHeader('ACCESSKEY', 'test');
                   String timestamp = String.valueOf(DateTime.Now().getTime()/1000);
                   request.setHeader('TIMESTAMP',timestamp);
                   String shasign3 = EncodingUtil.ConverttoHex(Crypto.generateDigest('SHA1', Blob.valueOf('test'+auditorkey+timestamp)));  
                   request.setHeader('HASH',shasign3);
                   request.setHeader('content-type', 'application/json');         
                   
                   String json = '{';
                   
                   json = json+'"expiry":"'+expirydate+'",';
                   
                   json = json+'"lead_id":"'+leadId+'",';  
                   
                   json = json+'"plan":"'+product+'",';
                   
                   json = json+'"type":"'+'hard'+'"}';
    
                   request.setBody(json);
                   
                   HttpResponse response = new HttpResponse ();
                   
                   System.debug('The URL'+syncurl);
                   
                   
                   if(!Test.isRunningTest()){
                       response = WebDriver.send(request); 
                       System.debug('the response we got is'+response);
                   }    
    }
}