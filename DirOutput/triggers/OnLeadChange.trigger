trigger OnLeadChange on Lead (before insert, before update)
{
    // Webhook sent out on After Insert and After Update events.
    // Only trigger the hook if the environment is production or testing and system
    // is not in batch mode, which might be cause by this same hook if it tries to update a lead
    if(!Test.IsRunningTest()){
       // if ((Environment.IsProduction() || Environment.IsTest()) && ( ! system.isBatch() && ! system.isFuture()))
        //{
            //String url = 'https://my.kayako.com/service/index.php?/Backend/SFWebhookListener/Handle';
            
            String content = Webhook.AsJson(Trigger.new, Trigger.old);
    
            if(!Test.isRunningTest()){ //Added to avoid webservice callout while test cases are running.
                Webhook.SendRequest('http://sagarpareek.com', content);
            }
        //}
    }
}