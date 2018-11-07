public class OrderLinkerController {

   

    public String SubId{get;set;}
    public String message {get;set;}
    public String backLink {get;set;}
    
    
     public void linkSub() {
     
        Http WebDriver = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        message = ' ';
        SubId = ApexPages.CurrentPage().getParameters().get('id');
        backLink = ApexPages.CurrentPage().getParameters().get('back');
        List<User>userList = [select id,name from user where id=:UserInfo.getUserId()];
        request.setEndpoint('https://my.kayako.com/service/index.php?/Backend/SFWebhookListener/GetOrderID/'+SubId);
        request.setMethod('GET');
        request.setBody('{"subscription_id" : "test_id"}');
        if(!Test.isRunningTest()){
            response = WebDriver.send(request);
            message = response.getBody();
            System.debug('The response is'+response.getBody());
            System.debug('The response code is'+response.getStatusCode());
        }
        
        
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'sagar.pareek@kayako.com','dhruv.agarwal@kayako.com'};
        String subject = '"Get Order ID" button pressed for '+SubId+' by '+userList[0].name+' and its response is '+message ;
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody(subject);
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
      
                              
                          
         
     
                              
        
    }
    
    
    
}