/*
    Description: This class is being used to update the instance metrics.
    
*/
global class BatchInstanceMetricsUpdater implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
   
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all the Instances.
        
       String query='select id,name,UUID__c,Expiry_Date__c,Instance_Id__c from Instance__c where state__c!=\'DELETED\'';
       return Database.getQueryLocator(query);  
       
    }
    
     public static Boolean runningInASandbox() {return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;} // to check if running in sandbox or production.
     public String customkey = [select id,name, Key__c from KayakoMetricsKey__c limit 1][0].Key__c; // custom key to access metrics.

     
    global void execute(Database.BatchableContext BC, List<Instance__c> scope) { //The execute context performs the main operation that is getting the values from plaform.
        
        List<Instance__c>instanceList = new List<Instance__c>();
        
        
        for(Instance__c i: scope){  
                
            Http WebDriver = new Http();
            HttpRequest request = new HttpRequest();
            if(!runningInASandbox()){
                request.setEndpoint('https://my.kayako.com/Backend/InstanceMetricProxy/Index/'+i.name.split('\\.')[0]);
            }else{
                request.setEndpoint('https://my.kayakostage.net/Backend/InstanceMetricProxy/Index/'+i.name.split('\\.')[0]);

            }
            request.setMethod('GET');  
            request.setHeader('ACCESSKEY', 'test');
            request.setTimeout(120000);
            String timestamp = String.valueOf(DateTime.Now().getTime()/1000);
            request.setHeader('TIMESTAMP',timestamp);
            String shasign = EncodingUtil.ConverttoHex(Crypto.generateDigest('SHA1', Blob.valueOf('test'+customkey+timestamp)));
            request.setHeader('HASH',shasign);
            HttpResponse response = new HttpResponse ();
            Integer sCode = 0;    
            if(!Test.isRunningTest()){
                response = WebDriver.send(request); 
                sCode = response.getStatusCode();
            }else{
                sCode = 200;
            }
            if(sCode!=200){
            
            }
            else{
                String res = '';
                if(!Test.isRunningTest()){
                    res = String.valueOf(response.getBody()); 
                }
                else{
                    res = '{ "status": 200, "data": { "owner": { "total": 1,  "daily_active": 1,"weekly_active": 1, "monthly_active": 1, "l28": {  "user_count": 1,     "average_no_of_days": 26,   "resource_type": "l28_metric"    },"resource_type": "role_metric"  },"administrator": {  "total": 0,"daily_active": 0,  "weekly_active": 0,  "monthly_active": 0,  "l28": {   "user_count": 0, "average_no_of_days": 0,"resource_type": "l28_metric"    }, "resource_type": "role_metric"      },  "agent": {  "total": 2,"daily_active": 0,"weekly_active": 0, "monthly_active": 0,"l28": { "user_count": 0, "average_no_of_days": 0,  "resource_type": "l28_metric"   },"resource_type": "role_metric"   }, "collaborator": {  "total": 0,  "daily_active": 0,  "weekly_active": 0,"monthly_active": 0, "l28": {"user_count": 0,"average_no_of_days": 0, "resource_type": "l28_metric"   }, "resource_type": "role_metric" }, "customer": { "total": 90821, "daily_active": 10,"weekly_active": 60, "monthly_active": 303,  "l28": null,"resource_type": "role_metric"  },  "resource_type": "instance_metric" }, "resource": "instance_metric" }';
                }    
                 
                Instance__c ins = new Instance__c();
                ins.id = i.id;
                System.debug('$$$$$$ response for metrics'+response.getbody());
                MetricsData md = MetricsData.parse(res);
                System.debug('md is'+md); 
                ins.Agents__c = md.data.agent.total; 
                ins.L28Agents__c = md.data.agent.l28.user_count; 
                ins.L28AverageNoOfDaysAdmins__c = md.data.agent.l28.average_no_of_days; 
                ins.Collaborators__c = md.data.collaborator.total; 
                ins.L28collaborators__c = md.data.collaborator.l28.user_count; 
                ins.L28AverageNoOfDayscollaborators__c = md.data.collaborator.l28.average_no_of_days; 
                ins.Customers__c = md.data.customer.total;  
                ins.Administrators__c = md.data.administrator.total; 
                ins.L28admins__c = md.data.administrator.l28.user_count; 
                ins.L28AverageNoOfDaysadmins__c = md.data.administrator.l28.average_no_of_days; 
                ins.Owners__c = md.data.owner.total; 
                ins.L28owners__c = md.data.owner.l28.user_count; 
                ins.L28AverageNoOfDaysowners__c = md.data.owner.l28.average_no_of_days; 
                ins.AgentsWithActivityYesterday__c = md.data.agent.daily_active; 
                ins.CollaboratorsWithActivityYesterday__c = md.data.collaborator.daily_active; 
                ins.CustomersWithActivityYesterday__c = md.data.customer.daily_active; 
                ins.AdminsWithActivityYesterday__c = md.data.administrator.daily_active; 
                ins.OwnersWithActivityYesterday__c = md.data.owner.daily_active; 
                ins.AgentsWithLast30DaysActivity__c = md.data.agent.monthly_active; 
                ins.CollaboratorsWithLast30DaysActivity__c = md.data.collaborator.monthly_active; 
                ins.CustomersWithLast30daysActivity__c = md.data.customer.monthly_active; 
                ins.AdminsWithLast30DaysActivity__c = md.data.administrator.monthly_active; 
                ins.OwnersWithLast30Days_activity__c = md.data.owner.monthly_active; 
                ins.AgentsWithLast7DaysActivity__c = md.data.agent.weekly_active; 
                ins.CollaboratorsWithLast7DaysActivity__c = md.data.collaborator.weekly_active; 
                ins.CustomersWithLast7DaysActivity__c = md.data.customer.weekly_active; 
                ins.AdminsWithLast7DaysActivity__c = md.data.administrator.weekly_active; 
                ins.OwnersWithLast7DaysActivity__c = md.data.owner.weekly_active;
                InstanceList.add(ins);
            }     
                
        }      
        update InstanceList;
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}