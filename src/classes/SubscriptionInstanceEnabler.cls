public class SubscriptionInstanceEnabler {
    
    public  String recordId; //stores the id from the page url
    
    public  Zuora__Subscription__c zs; // record instance of zuora subscription
    
    public  String url; //stores the webservice end point.
    
    public  String content; //content which needs to sent as Json
    
    public  String Data; //data -- token +timestamp + zoura id.
    
    public String signature; //signature ecrypted value.
    
    public long timestamp; //timestamp in epoch form
    
    public SubscriptionInstanceEnabler(ApexPages.StandardController controller) {
      
      recordId = Apexpages.currentPage().getParameters().get('id');       
       
       // fetch the record instance on page load!
       
       zs = [select id,SecurityToken__c,Zuora__Zuora_Id__c from Zuora__Subscription__c where id=:recordId limit 1];    
       
       //set blank every string.
       
       url ='';
       
       content ='';
       
       Data ='';
    }
    
    //method to check if the org is sandbox.
    
    public static Boolean runningInASandbox() {
      
      return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
    
    }
    
   //webservice call method specific to enable instance endpoint.
      public  void callWebService(){  
        
        //check type of org
        if(runningInASandbox()){
            url= 'https://my.kayakostage.net/service/index.php?/Backend/SFWebhookListener/EnableInstance';
        }
        else{
            url = 'https://my.kayako.com/service/index.php?/Backend/SFWebhookListener/EnableInstance';
        }
        
        //generate timestamp in epoch format not in salesforce format.
        
        timestamp = DateTime.Now().getTime()/1000;
        
        //add up everything and generate the data. 
        data = zs.SecurityToken__c + timestamp + zs.Zuora__Zuora_Id__c;
        
        
        //SHA1 digest in salesforce format
        Blob finalkey = Crypto.generateDigest('SHA1',Blob.valueOf(zs.SecurityToken__c));
        
        //hmac256 mac in salesforce format 
        Blob cryptoKey = Crypto.generateMac('hmacSHA256',Blob.valueOf(data),Blob.valueOf(EncodingUtil.convertToHex(Crypto.generateDigest('SHA1',Blob.valueOf(zs.SecurityToken__c)))));
       
        //encode and generate the final signature.
        signature = EncodingUtil.base64Encode(cryptoKey);
        
        //replace + with -,/ with _ and = with ,
        signature = signature.replace('+','-');
        
        signature = signature.replace('/','_');
        
        signature = signature.replace('=',',');
        
        content  = '{"subscription_id": "' + zs.Zuora__Zuora_Id__c + '"'+',"signature":"'+signature+'"}';
        
        
        //Go and hit the server.
        if (!System.Test.isRunningTest()){
            Http WebDriver = new Http();
    
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('X-Request-Timestamp',String.valueOf(timestamp));
            request.setBody(Content);
            
            
            System.debug('request is'+request);
            HttpResponse response = WebDriver.send(request);
            
            if(response.getStatusCode() != 200){ throw new RuntimeException('Webhook callout request was not handled properly by ' + url + ' - Error (' + response.getBody() + ') - Tried to send payload (' + Content + ')');}
       }
    
    }
        
    // method -- make a webservice call and hit the page back.    
    public PageReference submitUpdateRequest(){   
        
        callWebservice();
        PageReference pg = new PageReference('/'+recordId);
        return pg;
    
    }
    
    

}