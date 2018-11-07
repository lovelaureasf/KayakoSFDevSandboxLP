/* Description: This trigger closes the opportunity which is not closed and have same account and order id on it and is of Existing - K4 to Kayako type.
   Developed By: Sagar Pareek
   CreatedDate: 23 November 2016
   Last Modified Date: 23 November 2016
*/

trigger CloseDuplicateOpportunity on Opportunity (before insert) {
    
    List<Decimal> orderList = new List<Decimal>();
    List<String> accountIdList = new List<String>();
    List<Opportunity>opportunityList = new List<Opportunity>();
    
    for(Opportunity o: Trigger.New){
        
        if(o.Type == 'Existing - K4 to Kayako'){
            
                    orderList.add(o.OrderID__c);
                    accountIdList.add(o.accountId);    
        }
    }
    
    for(Opportunity o: [select id,name from opportunity where OrderId__c IN:orderList AND accountId IN:accountIdList AND isClosed = false AND type='Existing - K4 to Kayako']){
        
                o.StageName = 'Closed Lost: Duplicate';
                o.closeDate = date.today();
                opportunityList.add(o);            
    
    }
    
    
    if(opportunityList.size()>0 && opportunityList!=null){
        update opportunityList;
    }
    
    
}