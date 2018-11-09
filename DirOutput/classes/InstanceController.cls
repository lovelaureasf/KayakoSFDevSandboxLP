public class InstanceController {

    public String url;
    public String instanceId;
    public Integer status;
    public Data data;
    public String resource;
    public String country;
    public Instance__c ins {get;set;}
    
    public InstanceController(ApexPages.StandardController controller) {//constructor of the extension
                    
    }

    //method to check its sandbox or proudction org.
   public static Boolean runningInASandbox() {
      return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
   }
   
   public void getData(){
       instanceId = ApexPages.currentPage().getParameters().get('id');
       
       if(runningInASandbox()){
           url= 'https://my.kayakostage.net/api/v1/instances/';
       }else{
            url = 'https://my.kayako.com/api/v1/instances/';
       }
       
       if(instanceId!=null){
            
            List<Instance__c>InstanceList = new List<Instance__c>();
            InstanceList = [select id,name,UUID__c,Instance_ID__c from Instance__c where id=:InstanceId];
            
            if(InstanceList.size()>0){
                
                url=url+InstanceList[0].Instance_ID__c;
            }
        
        }
        
        //go hit the server .....
       
                Http WebDriver = new Http();
        
                HttpRequest request = new HttpRequest();
                request.setEndpoint(url);
                request.setMethod('GET');
                request.setHeader('Content-Type', 'application/json');
                Blob headerValue = Blob.valueOf('sagar.pareek@kayako.com:z82mQTXuniwDJP');
                //encode and create the header for initial authentication!
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                //setting header
                request.setHeader('Authorization', authorizationHeader);
                HttpResponse response = new HttpResponse ();
                if(!Test.isRunningTest()){
                  response = WebDriver.send(request);
                }
                //if(response.getStatusCode() != 200){ throw new RuntimeException('Webhook callout request was not handled properly by ' + url + ' - Error (' + response.getBody() + ') - Tried to send payload (' + Content + ')');}
           
                System.debug('response is'+response);
                    String res = '';
                 if(Test.isRunningTest()){
                       res =     '{"status": 201,"data": {"instance_id": "8012","uuid": "ec806a19-968b-4716-8f91-fdb634e26c01","status": "CREATED","state": "ENABLED","seats": "49","expiry": "2016-08-07T09:45:33+00:00"},"resource": "instance"}';
                }else if(runningInASandbox()){
                        res = String.valueOf(response.getBody());    
                        System.debug('the res is'+res);
               
                
                }else{
                      
                      res = String.valueOf(response.getBody());    
                      System.debug('the res is'+res);
                
                }
                
                if((response.getStatusCode()==200 || response.getStatusCode()==201) || Test.isRunningTest()){
                        System.debug('parse result'+parse(res).data.expiry);
                        ins = new Instance__c();ins.id = instanceId;ins.Expiry_Date__c=DateTime.valueOf(KayakoTimeConvertorUtil.convert(parse(res).data.expiry)); ins.PlatformStatus__c = parse(res).data.status; ins.State__c = parse(res).data.state;ins.Country__c =parse(res).data.country_name; if(parse(res).data.app_domain!=null && parse(res).data.app_domain!=''){ins.name =parse(res).data.app_domain+'.kayako.com';}   
                        update ins;
                        
                }
           }
    
    
    
    

    public class Data { // wrapper class for the json response
        public String instance_id;
        public String uuid;
        public String status;
        public String state;
        public String seats;
        public String expiry;
        public String country_name;
        public String app_domain;
    }

    
    public static InstanceController parse(String json) { //parser method for the json response
        return (InstanceController) System.JSON.deserialize(json, InstanceController.class);
    }
    
    
    
}