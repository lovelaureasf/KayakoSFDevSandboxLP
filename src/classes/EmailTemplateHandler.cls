public class EmailTemplateHandler {
    
    public String message {get;set;}
    public String InstanceId {get;set;}
   
    public static Boolean runningInASandbox() {  // to check if running in sandbox.
          return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
       }
       
    public String auditorKey = [select id,name, Key__c from KayakoAuditorKey__c limit 1][0].Key__c; // custom key for email template
       
    public emailTemplateHandler(){
            
            message = '';
            
            InstanceId = ApexPages.CurrentPage().getParameters().get('id');
            
            List<lead>leadlist = [select id from lead where instance__r.id=:InstanceId limit 1];
            
            List<opportunity>oppList = [select id from opportunity where instance__r.id=:InstanceId and isClosed=false limit 1];
            
            if(leadlist.size()>0 || opplist.size()>0){
            
                
                String type = ApexPages.CurrentPage().getParameters().get('type');
                
                
                
                
                Instance__c i = [select id,name,Instance_id__c from Instance__c where id =:InstanceId limit 1][0];
                
                String url = 'https://my.kayako.com/api/index.php?/v1/instances/'+String.valueOf(i.Instance_id__c)+'/ToggleTemplateModification';
            
                if(runningInASandbox()){
                    url = 'https://my.kayakostage.net/api/index.php?/v1/instances/'+String.valueOf(i.Instance_id__c)+'/ToggleTemplateModification';
                }
                
                String body = '';
                if(type == 'enable'){
                    body = 'state=ENABLED';
                }else if(type == 'disable'){
                    body = 'state=DISABLED';
                }
                
                Http WebDriver = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(url);
                request.setMethod('PUT');
                request.setTimeout(120000);
                request.setHeader('ACCESSKEY', 'test');
                String timestamp = String.valueOf(DateTime.Now().getTime()/1000);
                request.setHeader('TIMESTAMP',timestamp);
                String shasign3 = EncodingUtil.ConverttoHex(Crypto.generateDigest('SHA1', Blob.valueOf('test'+auditorkey+timestamp)));
                request.setHeader('HASH',shasign3);
                request.setBody(body);
                
                if(!Test.isRunningTest()){
                    HttpResponse response = WebDriver.send(request);
                    System.debug('the response is'+response.getBody());
                    if(response.getStatusCode() == 200){
                        message = 'The response is Success';
                    }
                    else{
                        message = 'The response is Failure. Invalid Response from Backend. Report this in #bizops/#salesforce slack channel.';
                    }
                }
         }else{
         
             message = 'Email Template can only be enabled for Trials. This is not a trial Instance.';
         
         }   
    }    

}