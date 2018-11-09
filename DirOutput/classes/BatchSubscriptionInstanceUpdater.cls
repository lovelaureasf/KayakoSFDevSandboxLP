global class BatchSubscriptionInstanceUpdater implements Database.Batchable<sObject> {
    
    public Map<Decimal,String>MapOfInstanceWithId = new Map<Decimal,String>();
    public Set<Decimal>iSet = new Set<Decimal>();
    public  List<Zuora__Subscription__c>zList = new List<Zuora__Subscription__c>();
    public  List<opportunity>oList = new List<opportunity>();
    List<String>InstanceIds = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all the accounts in chunk of 200.
        
        
        String query='select id,InstanceID__c from Zuora__Subscription__c where Instance__c=null and InstanceID__c!=null and InstanceID__c!=\'0\'';
        return Database.getQueryLocator(query);  
    }
   
    global void execute(Database.BatchableContext BC, List<Zuora__Subscription__c> scope) { //The execute context performs the main operation that is filling net next charge amount field.
        
      
       
       for(Zuora__Subscription__c zs : scope){
           if(zs.InstanceID__c!=null){
           if(Decimal.valueOf(zs.InstanceID__c)!=0 && Decimal.valueOf(zs.InstanceID__c)!=null){
               iSet.add(Decimal.valueOf(zs.InstanceID__c));
               InstanceIds.add(zs.InstanceID__c);
           }
           }
       }
       
       for(Instance__c i : [select id,Instance_ID__c from Instance__c where Instance_ID__c IN:iSet]){
           MapOfInstanceWithId.put(i.Instance_ID__c,i.id);
       }
       
       for(Opportunity o:[select id,name,Instance__c from opportunity where Instance__c IN:InstanceIds]){
           o.Instance__c=null;
           oList.add(o);
       }
       
       for(Zuora__Subscription__c zs: scope){
           if(zs.InstanceID__c!=null){
               if(MapOfInstanceWithId.keySet().contains(Decimal.valueOf(zs.InstanceID__c))){
                   zs.Instance__c= MapOfInstanceWithId.get(Decimal.valueOf(zs.InstanceID__c));
                   zList.add(zs);
               }
           }    
       } 
 
      
      if(zList.size()>0 && zList!=null){
          update zList;
          
      }

      if(oList.size()>0 && oList!=null){
          update oList;
          
      }



    
    }   
    
    global void finish(Database.BatchableContext BC) {
        
        System.debug('The update records are'+zList);
    
    }
}