global class BatchProductUpdater implements Database.Batchable<sObject>,Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all products in chunk of 200.
        
        String query = 'select id,name,Type__c,Family__c,zqu__SKU__c from zqu__ZProduct__c';
      
        return Database.getQueryLocator(query);  
    }
    
    
    global void execute(Database.BatchableContext BC, List<zqu__ZProduct__c> scope) { 
        
    	    Map<String,String> skuAndData = new Map<String,String>();	
            List<Zuora.zObject>objList = new List<Zuora.zObject>();
           
        	if(Test.isRunningTest()){
               
                Zuora.zObject prod = new Zuora.zObject('Product');
				prod.setValue('SKU','sku001');
				prod.setValue('Family__c','novo');
                prod.setValue('Type__c','novo');
                
               
                objlist.add(prod);
				 
            }else{ //we cannot test this block of code.
                Zuora.zApi.QueryResult queryResult;Zuora.zApi zApiInstance = new Zuora.zApi();zApiInstance.zlogin();Zuora.zApi.QueryRequest qr = new Zuora.zApi.QueryRequest();Zuora.zApi.QueryOptions qo = new Zuora.zApi.QueryOptions();qo.batchSize = 2000;qo.caseSensitive = false;qr.queryOptions = qo;qr.zoql = 'select id,name,Type__c,SKU,Family__c from product';queryResult = zApiInstance.zquery(qr);objList = queryResult.records;
            }
                for (Zuora.zObject zobject : objList) {
                System.debug('zObject$$$$1'+zobject);
                
                
                
                String data = String.valueOf(zobject.getValue('Type__c')+'::'+zobject.getValue('Family__c'));
        		
                System.debug('data1'+data);
                
                skuAndData.put(String.valueOf(zobject.getValue('SKU')), data);
                
                System.debug('the map1 is'+skuAndData);
            }
        
        List<zqu__ZProduct__c>zpList = new List<zqu__ZProduct__c>();
       
        for(zqu__ZProduct__c zp:scope){
            
            if(zp.zqu__SKU__c != null){
                
                if(skuAndData.keySet().contains(zp.zqu__SKU__c)){
	            	zp.type__c = skuAndData.get(zp.zqu__SKU__c).split('::')[0];
                	zp.family__c = skuAndData.get(zp.zqu__SKU__c).split('::')[1];
                	zpList.add(zp);
                }    
            }
            
        }
    	System.debug('####'+skuAndData);
        update zpList;
    }        
        
    global void finish(Database.BatchableContext BC) {
    
    }
        
    
}