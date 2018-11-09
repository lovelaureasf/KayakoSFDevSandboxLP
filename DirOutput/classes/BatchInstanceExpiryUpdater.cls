/* Description: This class is responsible to update the expiry dates of instances and run auditor.
*  Developed By: Sagar Pareek
*
*/


global class BatchInstanceExpiryUpdater implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    public Set<String>SubInstanceId = new Set<String>(); // Set of Subscription InstanceId
    public Map<String,Zuora__Subscription__c> MapOfInstanceIdAndSubscription = new Map<String,Zuora__Subscription__c>(); // Map Of InstanceId and Subscription
    public Map<String,Opportunity> MapOfInstanceIdAndOpportunity = new Map<String,Opportunity>(); // Map of InstanceId and Opportunity
    public Map<String,Lead> MapOfInstanceIdAndLead = new Map<String,Lead>(); //Map of Instance and Lead
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all the Instances.
        
       
        //Collect all active subscriptions.
        for(Zuora__Subscription__c zs: [select id,name,Zuora__Status__c,InstanceID__c from Zuora__Subscription__c where  Zuora__Status__c='Active' OR ( Zuora__Status__c='Cancelled' AND VersionCreatedDate__c>=:Date.Today()-3 )]){
           
           if(zs.InstanceId__c!=null && zs.InstanceId__c!='0'){     
                SubInstanceId.add(zs.id);
            }
        
        }
        
        //Main query String that is being used to get records.
        
        Set<String> instanceIdSet = new Set<String>();
        for(Instance__c i:[select id,name,UUID__c,Expiry_Date__c,InstanceId__c from Instance__c where state__c!='DELETED' AND Expiry_Date__c>=:Date.today()-7]){
         InstanceIdSet.add(i.id);
        }
        String query='select id,name,UUID__c,Expiry_Date__c,InstanceId__c from Instance__c where Id IN:InstanceIdSet';
            return Database.getQueryLocator(query);  
        
        }
        
        //Check if it is running in a sandbox or not. 
        public static Boolean runningInASandbox() {
            
            return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
        
        }
   
       public String auditorKey = [select id,name, Key__c from KayakoAuditorKey__c limit 1][0].Key__c; // custom key for auditor
     
    
    
    
    global void execute(Database.BatchableContext BC, List<Instance__c> scope) { //The execute context performs the main operation that is getting the values from plaform.
        
      List<Instance__c>instanceList = new List<Instance__c>();
      Set<String>InstanceIds = new Set<String>();
      
      String debug = '';
      
      Boolean k5 = false;
      
      for(Instance__c i:scope){
          InstanceIds.add(i.id);
      }
      
      for(Lead l:[ select id,name,KA_Product__c,isConverted,Instance__r.id from Lead where Status !='Purchased' AND  Instance__r.id IN:InstanceIds]){
          MapOfInstanceIdAndLead.put(l.Instance__r.id,l);
      }
      
      for(Opportunity o:[ select id,name,Product__c,Plan__c,type,Instance__r.id from Opportunity where StageName!='Closed Won' AND Instance__r.id IN:InstanceIds]){
          MapOfInstanceIdAndOpportunity.put(o.Instance__r.id,o);
      }
      
      for(Zuora__Subscription__c zs:[ select id,Zuora__Zuora_Id__c, Family__c,Type__c,Instance__r.id from Zuora__Subscription__c where Instance__r.id IN:InstanceIds]){
          MapOfInstanceIdAndSubscription.put(zs.Instance__r.id,zs);
      }
        
        
        
        for(Instance__c i: scope){  
                
            debug ='';
            
            k5 = false;
            
            Http expiryDriver = new Http();
            
            Http auditorDriver = new Http();
            
            String url ='';
            
            String auditorUrl = ''; 
            
            String uid = i.InstanceId__c;
            
            if(runningInASandbox()){
                
                url= 'https://my.kayakostage.net/api/v1/instances/';
                auditorurl='https://my.kayakostage.net/api/index.php?/v1/instances/'+uid+'/audit';
            
            }
            else{
                
                url = 'https://my.kayako.com/api/v1/instances/';
                auditorurl='https://my.kayako.com/api/index.php?/v1/instances/'+uid+'/audit';
            
            }
            
            
            
            
            HttpRequest expiryRequest = new HttpRequest();
            
            Blob headerValue = Blob.valueOf('sagar.pareek@kayako.com:z82mQTXuniwDJP');
            //encode and create the header for initial authentication!
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            //setting header
            expiryRequest.setHeader('Authorization', authorizationHeader);
            
            HttpRequest auditorRequest = new HttpRequest();
            
            expiryRequest.setEndpoint(url+i.UUID__c);
            
            auditorRequest.setEndpoint(auditorUrl);
            
            expiryRequest.setMethod('GET');
            
            auditorRequest.setMethod('PUT');
            
            expiryRequest.setHeader('Content-Type', 'application/json'); 
            
            auditorRequest.setHeader('ACCESSKEY', 'test');
            
            String timestamp = String.valueOf(DateTime.Now().getTime()/1000);
            
            auditorRequest.setHeader('TIMESTAMP',timestamp);
            
            auditorRequest.setTimeout(120000);
            
            expiryRequest.setTimeout(120000);
            
            String shasign3 = EncodingUtil.ConverttoHex(Crypto.generateDigest('SHA1', Blob.valueOf('test'+auditorkey+timestamp)));
            
            auditorRequest.setHeader('HASH',shasign3);auditorRequest.setHeader('content-type', 'application/json');
            
            String subid = '';
            
            String leadid = '';
            
            String oppid = '';
            
            String product = '';
            
            String plan = '';
            
            
            
            String expirydate = String.valueOf(i.Expiry_date__c.getTime()/1000);
            
            String json ='{';
            if(MapOfInstanceIdAndSubscription.keySet().contains(i.id)){
                
                
                json = json+'"subscription_id":"'+MapOfInstanceIdAndSubscription.get(i.id).Zuora__Zuora_Id__c+'"';
            
                if(MapOfInstanceIdAndSubscription.get(i.id).Family__c.contains('novo') && MapOfInstanceIdAndSubscription.get(i.id).Type__c.contains('novo')){
                    
                    debug = debug+'K5 Subscription ';
                    k5 = true;
                    
                }
            
            }
            else if(MapOfInstanceIdAndLead.keySet().contains(i.id)){
                
                json = json+'"expiry":"'+expirydate+'",';
                
                json = json+'"lead_id":"'+MapOfInstanceIdAndLead.get(i.id).id+'",';
                
                if(MapOfInstanceIdAndLead.get(i.id).isConverted && MapOfInstanceIdAndOpportunity.keySet().contains(i.id)){
                    
                    json = json+'"plan":"'+MapOfInstanceIdAndOpportunity.get(i.id).plan__c+'",';
                    
                    if(MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Growth' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Enterprise' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Standard' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Scale' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Free' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Inbox'){
                        
                         debug = debug+'K5 Opportunity '+MapOfInstanceIdAndOpportunity.get(i.id).id+' ';
                         k5 = true;
                    }
                
                }
                else{
                    
                    json = json+'"plan":"'+MapOfInstanceIdAndLead.get(i.id).ka_product__c+'"'; 
                    
                    if(MapOfInstanceIdAndLead.get(i.id).ka_product__c == 'Standard' || MapOfInstanceIdAndLead.get(i.id).ka_product__c == 'Enterprise'){
                         
                         json = json+',"product":"'+'Kayako (Nov 2017)'+'"';     
                    }
                
                    if(MapOfInstanceIdAndLead.get(i.id).ka_product__c =='Free' || MapOfInstanceIdAndLead.get(i.id).ka_product__c =='Scale' || MapOfInstanceIdAndLead.get(i.id).ka_product__c =='Growth' || MapOfInstanceIdAndLead.get(i.id).ka_product__c =='Inbox' || MapOfInstanceIdAndLead.get(i.id).ka_product__c =='Standard' || MapOfInstanceIdAndLead.get(i.id).ka_product__c =='Enterprise' ){
                        
                        debug = debug+'K5 Lead '+MapOfInstanceIdAndLead.get(i.id).id+' ';
                        k5 = true;
                    }
                
                
                }
                
            }
          /*  else if(MapOfInstanceIdAndOpportunity.keySet().contains(i.id) && (MapOfInstanceIdAndOpportunity.get(i.id).type == 'Existing - K4 to Kayako' || MapOfInstanceIdAndOpportunity.get(i.id).type == 'New Business' )){ 
                
                json = json+'"expiry":"'+expirydate+'",'; 
                
                json = json+'"product":"'+MapOfInstanceIdAndOpportunity.get(i.id).product__c+'",'; 
                
                json = json+'"plan":"'+MapOfInstanceIdAndOpportunity.get(i.id).plan__c+'",'; 
                
                json = json+'"opportunity_id":"'+MapOfInstanceIdAndOpportunity.get(i.id).id+'"';
            
                if(MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Growth' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Enterprise' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Standard' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Scale' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Free' || MapOfInstanceIdAndOpportunity.get(i.id).plan__c == 'Inbox'){
                        
                         debug = debug+'K5 Opportunity '+MapOfInstanceIdAndOpportunity.get(i.id).id+' ';
                         k5 = true;
                    }
            }  */
                
                json = json+'}';
                
                System.debug('json is'+json);
                auditorRequest.setTimeout(120000);
                auditorRequest.setBody(json);
            
            
            
            
            
            
            HttpResponse response = new HttpResponse ();
            
            
            
            HttpResponse response3 = new HttpResponse ();
            
            try{
                
                if(!Test.isRunningTest()){
                   response3 = auditorDriver.send(auditorRequest); 
                   System.debug('the json is'+json);
                   response = expiryDriver.send(expiryRequest);
                }
            }
            
            catch(Exception e)
            {
                System.debug('@@@@ Exception' + e.getmessage());
            }
            
            System.debug('response is'+response);
            String res = '';
            String res3 = '';
            if(runningInASandbox() || Test.isRunningTest()){
                res =     '{"status": 201,"data": {"instance_id": "8012","uuid": "ec806a19-968b-4716-8f91-fdb634e26c01","status": "CREATED","state": "ENABLED","seats": "49","expiry": "2016-08-07T09:45:33+00:00"},"resource": "instance"}';
            }
            else {
                if(k5){  
                    res = String.valueOf(response.getBody());
                    res3 = String.valueOf(response3.getBody());  
                    System.debug('the url of sync/audit is'+auditorurl);
                    System.debug('the syncer/auditor response code is'+response3.getStatusCode());
                    System.debug('the syncer/auditor response is'+response3.getbody());
                    debug = debug+ ','+i.id+', '+response3.getStatusCode()+', '+res;
                  /*
                    Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                    Blob csvBlob = Blob.valueOf(debug);
                    String csvname= i.id+'.csv';
                    csvAttc.setFileName(csvname);
                    csvAttc.setBody(csvBlob);
                    Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                    String[] toAddresses = new list<string> {'sagar.pareek@kayako.com'};
                    String subject ='Instance Log: '+i.id+'.csv';
                    email.setSubject(subject);
                    email.setToAddresses( toAddresses );
                    email.setPlainTextBody(i.id+'Debug log');
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
				*/
                }
            
                System.debug('the response from the expiry is'+res);
                //Added null check by sruti on 19th September, 2018
                Instance__c ins = new Instance__c();
                ins.id = i.id; 
                If(res != null && !String.isBlank(res) ) {
                    If(parse(res).data != null && parse(res).data.expiry!= null ) {
                        ins.Expiry_Date__c = DateTime.valueOf(KayakoTimeConvertorUtil.convert(parse(res).data.expiry)); 
                    }
                    If(parse(res).data != null && parse(res).data.status!= null ) {
                        ins.PlatformStatus__c = parse(res).data.status; 
                    }
                    If(parse(res).data != null && parse(res).data.state!= null ) {
                        ins.State__c = parse(res).data.state;
                    }
                    If(parse(res).data != null && parse(res).data.country_name!= null ) {
                        ins.Country__c = parse(res).data.country_name; 
                    }
                    if(parse(res).data != null && parse(res).data.app_domain!=null && parse(res).data.app_domain!=''){
                        ins.name = parse(res).data.app_domain+'.kayako.com';
                    }
                } 
                instanceList.add(ins);
            }      
            update InstanceList;
        }         
    }
      
      
      
    public static InstanceController parse(String json) { 
          return (InstanceController) System.JSON.deserialize(json, InstanceController.class);
     }
      
    global void finish(Database.BatchableContext BC) {
    }
      
}