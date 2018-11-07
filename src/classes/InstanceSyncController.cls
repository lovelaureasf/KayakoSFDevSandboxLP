/*
    Description: This class is a custom extension to the Instance Syncer
    This will be used with the button on the instance record.
*/

public class InstanceSyncController {
    public String result {get;set;}
    public String reason {get;set;}
    public String recId{get;set;} // this will store the current record id in it;
    public Map<String,Zuora__Subscription__c> MapOfInstanceIdAndSubscription = new Map<String,Zuora__Subscription__c>(); // Map Of InstanceId and Subscription
    public Map<String,Opportunity> MapOfInstanceIdAndOpportunity = new Map<String,Opportunity>(); // Map of InstanceId and Opportunity
    public Map<String,Lead> MapOfInstanceIdAndLead = new Map<String,Lead>(); //Map of Instance and Lead    
    public String auditorKey = [select id,name, Key__c from KayakoAuditorKey__c limit 1][0].Key__c;
    public Set<String>InstanceIds = new Set<String>();
    public String rec {get;set;}
    public static Boolean runningInASandbox() {  // to check if running in sandbox.
          return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
       }
     
    public InstanceSyncController(ApexPages.StandardController controller) {
        recId = ApexPages.currentPage().getParameters().get('Id'); //get the id from url
        rec = ApexPages.currentPage().getParameters().get('rec'); //get the return id from url
        submit();
    }
    
    
    
   public pageReference submit(){
     
    List<Decimal>Instancelist = new List<Decimal>();
    
    result = '';
    
    
    
    for(Instance__c i:[select id,name,Instance_Id__c from instance__c where id =:recId]){
            InstanceIds.add(i.id); 
            InstanceList.add(i.Instance_id__c);   // loop over the instance mapped to record id
        }
    
    
    // collect lead,opp and sub associated to the record
  for(Lead l:[ select id,name,KA_Product__c,isConverted,Instance__r.id from Lead where Status !='Purchased' AND Instance__r.id IN:InstanceIds]){
            MapOfInstanceIdAndLead.put(l.Instance__r.id,l);
        }
        
        for(Opportunity o:[ select id,name,Product__c,Plan__c,type,Instance__r.id from Opportunity where StageName!='Closed Won' AND  Instance__r.id IN:InstanceIds]){
           MapOfInstanceIdAndOpportunity.put(o.Instance__r.id,o);
        }
        
        for(Zuora__Subscription__c zs:[ select id,Zuora__Zuora_Id__c,Instance__r.id from Zuora__Subscription__c where Instance__r.id IN:InstanceIds]){
           MapOfInstanceIdAndSubscription.put(zs.Instance__r.id,zs);
        }    
    
   
    
       // send request to the production to sync
       for(Instance__c i: [select id,name,UUID__c,Expiry_Date__c,Instance_ID__c from Instance__c where Instance_ID__c IN:InstanceList]){
      
           String auditorUrl = ''; 
           String uid = String.valueOf(i.UUID__c);
           System.debug('name is'+i.name);
           System.debug('the uuid is'+String.valueOf(i.Instance_ID__c));
           
           if(runningInASandbox()){
               auditorurl='https://my.kayakostage.net/api/index.php?/v1/instances/'+uid+'/sync';
           }else{
               auditorurl='https://my.kayako.com/api/index.php?/v1/instances/'+uid+'/sync'; 
           }
           
           HttpRequest request3 = new HttpRequest();
           Http WebDriver3 = new Http();
           request3.setEndpoint(auditorUrl);
           request3.setMethod('PUT');
           request3.setHeader('ACCESSKEY', 'test');
           String timestamp = String.valueOf(DateTime.Now().getTime()/1000);
           System.debug('timestamp'+timestamp);
           request3.setHeader('TIMESTAMP',timestamp);
           String shasign3 = EncodingUtil.ConverttoHex(Crypto.generateDigest('SHA1', Blob.valueOf('test'+auditorkey+timestamp)));  
           request3.setHeader('HASH',shasign3);
           request3.setHeader('content-type', 'application/json');         
           String subid = '';         
           String leadid = '';
           String oppid = '';
           String product = '';
           String plan = '';
           String type = 'hard';
           String expirydate = String.valueOf(i.Expiry_date__c.getTime()/1000);
           String js ='{';
           
                    if(MapOfInstanceIdAndSubscription.keySet().contains(i.id)){
                            js = js+'"subscription_id":"'+MapOfInstanceIdAndSubscription.get(i.id).Zuora__Zuora_Id__c+'",';
                            
                    }else if(MapOfInstanceIdAndLead.keySet().contains(i.id)){
                          js = js+'"expiry":"'+expirydate+'",';
                          js = js+'"lead_id":"'+MapOfInstanceIdAndLead.get(i.id).id+'",';
                            
                         if(MapOfInstanceIdAndLead.get(i.id).isConverted && MapOfInstanceIdAndOpportunity.keySet().contains(i.id) && (MapOfInstanceIdAndOpportunity.get(i.id).type == 'Existing - K4 to Kayako' || MapOfInstanceIdAndOpportunity.get(i.id).type == 'New Business')){
                             
                             
                             
                             js = js+'"plan":"'+MapOfInstanceIdAndOpportunity.get(i.id).plan__c+'",';
                             
                            
                              
                                
                         }else{
                            
                            js = js+'"plan":"'+MapOfInstanceIdAndLead.get(i.id).ka_product__c+'",';
                             
                         }
                         
                         
                            
                        
                    }else if(MapOfInstanceIdAndOpportunity.keySet().contains(i.id) && (MapOfInstanceIdAndOpportunity.get(i.id).type == 'Existing - K4 to Kayako' || MapOfInstanceIdAndOpportunity.get(i.id).type == 'New Business')){
                                                 js = js+'"expiry":"'+expirydate+'",';
                                                 js = js+'"product":"'+MapOfInstanceIdAndOpportunity.get(i.id).product__c+'",';
                                                 js = js+'"plan":"'+MapOfInstanceIdAndOpportunity.get(i.id).plan__c+'",';
                                                 js = js+'"opportunity_id":"'+MapOfInstanceIdAndOpportunity.get(i.id).id+'",';
    
                        
                          
                        
                    }
                     js = js+'"type":"'+'hard'+'"}';
                    System.debug('js is'+js);
    
                    request3.setBody(js);
                    request3.setTimeout(120000);
                    HttpResponse response3 = new HttpResponse ();
                    if(!Test.isRunningTest()){response3 = WebDriver3.send(request3); System.debug('the response we got is'+response3.getStatusCode());System.debug('the response we got is'+response3.getBody());if(response3.getStatusCode()==200){result='Success';}else{result='Failure';JSONParser parser = JSON.createParser(response3.getBody());  while (parser.nextToken() != null) {if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'code')) {parser.nextToken();reason = parser.getText();}} }}
                   
                    
       
    }         
        return null;  
    }
    
    public pageReference goBack(){
        PageReference pg = new PageReference('/'+rec);
        pg.setRedirect(true);
        return pg;
    }
    

}