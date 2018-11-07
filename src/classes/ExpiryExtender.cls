/*
    This class is used to extend the expiry on the kayako instance
*/

public class ExpiryExtender {
    
    public List<SelectOption> daysList {get;set;} //stores the list of days to show on page.
    
    public String daySelected {get;set;} // selected day is stored here.
    
    public String iId;
    
    String url; //stores the endpoint url.
    
    String request; // stores the request.
    
    List<Zuora__Subscription__c> zs; //instance of zoura subscription 
    
    public List<lead> l; // instance of lead
    
    List<opportunity> o; //instance of opportunity
    
    public long timestamp; //timestamp in epoch format
    
    public  String Data; //data sum of everything.
    
    public String signature; //signature is encoded stuff to be sent.
    
    public Instance__c i;
    
    public ExpiryExtender(ApexPages.StandardController controller) {
        
        daysList = new List<selectOption>();
        //add all the days to be shown.
        daysList.add(new SelectOption('2','2'));
        daysList.add(new SelectOption('7','7'));
        daysList.add(new SelectOption('15','15'));
        daysList.add(new SelectOption('30','30'));    
        
        Id uId = UserInfo.getProfileId();
        List<Profile>proName = [Select Name from Profile where Id =:uid];
        if(proName[0].Name=='System Administrator' || UserInfo.getUserId() == '00510000006DA7hAAG'){
            daysList.add(new SelectOption('180','180'));
            daysList.add(new SelectOption('365','365'));  
        }
        
        iId = Apexpages.currentPage().getParameters().get('id'); 
        
        i = [select id,name,Instance_ID__c,Expiry_Date__c from Instance__c where Id=:iId];
        
        
        //store the subscription here in the instance of zuora subscription.
       
        
           zs = new List<Zuora__Subscription__c> ();
           zs = [select id,SecurityToken__c,Zuora__Zuora_Id__c from Zuora__Subscription__c where Instance__c=:iId limit 1];
        
     
            
          l = new List<lead>();
          l = [select id,name,KA_Product__c from lead where Instance__c=:iId limit 1];
          System.debug('id from page'+l);
        
        
         List<opportunity>   o = new List<opportunity>();
         o = [select id,name from opportunity where Instance__c=:iId limit 1];
        
       
        
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
        
        System.debug('the lead is'+l);
        
        
        
        if(runningInASandbox()){
            url= 'https://my.kayakostage.net/service/index.php?/Backend/SFWebhookListener/ExtendExpiry';
        }
        else{
            url = 'https://my.kayako.com/service/index.php?/Backend/SFWebhookListener/ExtendExpiry';
        }
        
         if(zs.size()>0 && zs!=null){
            request  = '{"subscription_id": "' + zs[0].Zuora__Zuora_Id__c + '", "days": ' + daySelected + '}';
         }else if(l!=null && l.size()>0){
            System.debug('in lead clause');
              String version = '5';if(l[0].KA_Product__c == 'Fusion' || l[0].KA_Product__c == 'Case' || l[0].KA_Product__c == 'Engage'){version = '4';}request  = '{"days": "' + daySelected + '", "instance_id": "'+i.Instance_ID__c +'","version":'+'"'+version+'"}'; }else if(o!=null && o.size()>0){request  = '{"days": "' + daySelected + '", "instance_id": "'+i.Instance_ID__c +'"}'; }else{request  = '{"days": "' + daySelected + '", "instance_id": "'+i.Instance_ID__c +'"}'; }
        
       
        SendRequest(url,request);Instance__c ik = new Instance__c();ik.id = iId;ik.Expiry_Date__c = i.Expiry_Date__c +Integer.valueOf(daySelected);update ik;PageReference pg = new PageReference('/'+iId);return pg;
    
    }
    
    //back button method
    public PageReference backToDetailPage(){PageReference pg = new PageReference('/'+iId);return pg;}
    
    
    public void SendRequest(String Url, String Content){
             
            System.debug('the url is'+url);
            System.debug('the content is'+content);
             
            //time stamp is epoch format
            timestamp = DateTime.Now().getTime()/1000;
           
            if(zs!=null && zs.size()>0){
            
            //data is sum of token, timestamp and zuoura id.
            data = zs[0].SecurityToken__c + timestamp + zs[0].Zuora__Zuora_Id__c;
           
            //sha1 form of security token
            Blob finalkey = Crypto.generateDigest('SHA1',Blob.valueOf(zs[0].SecurityToken__c));
            
            // crypto key in hmac256 form.
            Blob cryptoKey = Crypto.generateMac('hmacSHA256',Blob.valueOf(data),Blob.valueOf(EncodingUtil.convertToHex(Crypto.generateDigest('SHA1',Blob.valueOf(zs[0].SecurityToken__c)))));
           
            //signature in encoded form.
            signature = EncodingUtil.base64Encode(cryptoKey);
            
            //replace + with -,/ with _ and = with ,
            signature = signature.replace('+','-');signature = signature.replace('/','_');signature = signature.replace('=',',');
            
            //json format content that needs to be sent.
            content  = '{"subscription_id": "' + zs[0].Zuora__Zuora_Id__c + '"'+',"signature":"'+signature+'","days":'+dayselected+'}';
            
            }
            
            
            
            //go hit the server .....
            if (!System.Test.isRunningTest()){
                Http WebDriver = new Http();
        
                HttpRequest request = new HttpRequest();request.setEndpoint(url);request.setMethod('POST');request.setHeader('Content-Type', 'application/json');request.setBody(Content);request.setHeader('X-Request-Timestamp',String.valueOf(timestamp));
                
                HttpResponse response = WebDriver.send(request);
                System.debug('The response is'+response.getBody());
                System.debug('The response code is'+response.getStatusCode());
                if(response.getStatusCode() != 200){ throw new RuntimeException('Webhook callout request was not handled properly by ' + url + ' - Error (' + response.getBody() + ') - Tried to send payload (' + Content + ')');}
           }
    }

}