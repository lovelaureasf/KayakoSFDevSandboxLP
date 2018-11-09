public class SubscriptionExpiryExtender {
    
    public List<SelectOption> daysList {get;set;} //stores the list of days to show on page.
    
    public String daySelected {get;set;} // selected day is stored here.
    
    public String recordId;   // stores the record if fetched from the url.
    
    String url; //stores the endpoint url.
    
    String request; // stores the request.
    
    Zuora__Subscription__c zs; //instance of zoura subscription 
    
    public long timestamp; //timestamp in epoch format
    
    public  String Data; //data sum of everything.
    
    public String signature; //signature is encoded stuff to be sent.
    
    public SubscriptionExpiryExtender(ApexPages.StandardController controller) {
        
        daysList = new List<selectOption>();
        //add all the days to be shown.
        daysList.add(new SelectOption('2','2'));
        daysList.add(new SelectOption('7','7'));
        daysList.add(new SelectOption('15','15'));
        daysList.add(new SelectOption('30','30'));    
        
        //fetch the id from the page.
        recordId = Apexpages.currentPage().getParameters().get('id'); 
        //store the subscription here in the instance of zuora subscription.
        zs =[select id,SecurityToken__c,Zuora__Zuora_Id__c from Zuora__Subscription__c where id=:recordId limit 1];    
        
        //mark all the strings blank.
        url ='';
        request ='';
        Data ='';
    }
    
   //method to check its sandbox or proudction org.
   public static Boolean runningInASandbox() {
      return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
   }
    
    public PageReference submitExpiry(){
        
        if(runningInASandbox()){
            url= 'https://my.kayakostage.net/service/index.php?/Backend/SFWebhookListener/ExtendExpiry';
        }
        else{
            url = 'https://my.kayako.com/service/index.php?/Backend/SFWebhookListener/ExtendExpiry';
        }
        
        request  = '{"subscription_id": "' + zs.Zuora__Zuora_Id__c + '", "days": ' + daySelected + '}';
        
        
        
        SendRequest(url,request);
        PageReference pg = new PageReference('/'+recordId);
        return pg;
    
    }
    
    //back button method
    public PageReference backToDetailPage(){
    
        PageReference pg = new PageReference('/'+recordId);
        return pg;
    }
    
    
    public void SendRequest(String Url, String Content){
        
            //time stamp is epoch format
            timestamp = DateTime.Now().getTime()/1000;
           
            //data is sum of token, timestamp and zuoura id.
            data = zs.SecurityToken__c + timestamp + zs.Zuora__Zuora_Id__c;
           
            //sha1 form of security token
            Blob finalkey = Crypto.generateDigest('SHA1',Blob.valueOf(zs.SecurityToken__c));
            
            // crypto key in hmac256 form.
            Blob cryptoKey = Crypto.generateMac('hmacSHA256',Blob.valueOf(data),Blob.valueOf(EncodingUtil.convertToHex(Crypto.generateDigest('SHA1',Blob.valueOf(zs.SecurityToken__c)))));
           
            //signature in encoded form.
            signature = EncodingUtil.base64Encode(cryptoKey);
            
            //replace + with -,/ with _ and = with ,
            signature = signature.replace('+','-');
            signature = signature.replace('/','_');
            signature = signature.replace('=',',');
            
            //json format content that needs to be sent.
            content  = '{"subscription_id": "' + zs.Zuora__Zuora_Id__c + '"'+',"signature":"'+signature+'","days":'+dayselected+'}';
            
            //go hit the server .....
            if (!System.Test.isRunningTest()){
                Http WebDriver = new Http();
        
                HttpRequest request = new HttpRequest();
                request.setEndpoint(url);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json');
                request.setBody(Content);
                request.setHeader('X-Request-Timestamp',String.valueOf(timestamp));
                
                HttpResponse response = WebDriver.send(request);
                
                if(response.getStatusCode() != 200){ throw new RuntimeException('Webhook callout request was not handled properly by ' + url + ' - Error (' + response.getBody() + ') - Tried to send payload (' + Content + ')');}
           }
    }

}